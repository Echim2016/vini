//
//  SigninViewController.swift
//  vini
//
//  Created by Yi-Chin Hsu on 2021/11/4.
//

import UIKit
import FirebaseAuth
import AuthenticationServices
import CryptoKit
import grpc

class SigninViewController: UIViewController {

    fileprivate var currentNonce: String?

    @IBOutlet weak var welcomeMessageLabel: UILabel!
    @IBOutlet weak var welcomeBackgroundView: UIView!
    @IBOutlet weak var cloudImageView: UIImageView!
    
    var signInButton: ASAuthorizationAppleIDButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupSignInButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupBackgroundView()
    }
    
 
    @objc func handleSignInWithAppleTapped() {
        performSignIn()
    }
    
    @IBAction func tapTransitionButton(_ sender: Any) {
        
        let xScaleFactor = self.view.frame.size.width / welcomeBackgroundView.frame.width
        let yScaleFactor = self.view.frame.size.height / welcomeBackgroundView.frame.height
        
        let scaleTransform = CGAffineTransform(scaleX: xScaleFactor, y: yScaleFactor)
        
        UIView.animate(
            withDuration: 2.0,
            delay: 0.0,
            usingSpringWithDamping: 2.0,
            initialSpringVelocity: 3.0,
            options: .curveEaseIn,
            animations: {
                self.welcomeBackgroundView.transform = scaleTransform
                self.cloudImageView.alpha = 0
                self.signInButton?.alpha = 0
                self.welcomeMessageLabel.alpha = 0
            },
            completion: { _ in
                
                let storyboard = UIStoryboard(name: "Signup", bundle: nil)
                if let vc = storyboard.instantiateViewController(withIdentifier: "SignUp") as? SignupViewController {
                    
                    self.navigationController?.pushViewController(vc, animated: false)
                    
//                    self.present(vc, animated: false, completion: nil)
                }
            }
                
            )
        
    }
    
    func performSignIn() {
        
        let request = createAppleIDRequest()
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        
        authorizationController.performRequests()
    }
    
    func createAppleIDRequest() -> ASAuthorizationAppleIDRequest {
        
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let nonce =  randomNonceString()
        request.nonce = sha256(nonce)
        currentNonce = nonce
        
        return request
    }
    
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError(
                        "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
                    )
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }
    
    @available(iOS 13, *)
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
    
    @available(iOS 13, *)
    func startSignInWithAppleFlow() {
        
        let nonce = randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
}

extension SigninViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        
        return self.view.window!
    }
}

@available(iOS 13.0, *)
extension SigninViewController: ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
                        
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }
            // Initialize a Firebase credential.
            let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                      idToken: idTokenString,
                                                      rawNonce: nonce)
            // Sign in with Firebase.
            Auth.auth().signIn(with: credential) { (authResult, error) in
                if let error = error {
                    // Error. If error.code == .MissingOrInvalidNonce, make sure
                    // you're sending the SHA256-hashed nonce as a hex string with
                    // your request to Apple.
                    print(error.localizedDescription)
                    return
                }
                
                // User is signed in to Firebase with Apple.
                
                if let auth = authResult,
                   let isNewUser = auth.additionalUserInfo?.isNewUser {
                   
                    if isNewUser {
                        var user = User()
                        user.id = auth.user.uid
                        
                        UserManager.shared.createNewUser(user: &user) { result in
                            
                            switch result {
                            case .success(let success):
                                print(success)
                                
//                                let storyboard = UIStoryboard(name: "Signup", bundle: nil)
//                                if let vc = storyboard.instantiateViewController(withIdentifier: "SignUp") as? SignupViewController {
//
//                                    self.navigationController?.pushViewController(vc, animated: true)
//                                }
                                
                                self.tapTransitionButton(self.signInButton)
                                
                            case .failure(let error):
                                print(error)
                            }
                        }
                    }
                    
                    
                    
                }
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
        print("Sign in with Apple errored: \(error)")
    }
    
}

extension SigninViewController {
    
    func setupSignInButton() {
        
        let button = ASAuthorizationAppleIDButton(type: .signIn, style: .white)
        button.addTarget(self, action: #selector(handleSignInWithAppleTapped), for: .touchUpInside)
        
        self.view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            button.heightAnchor.constraint(equalToConstant: 40),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.topAnchor.constraint(equalTo: welcomeBackgroundView.bottomAnchor, constant: 100)
        ])
        
        self.signInButton = button
        
        view.addSubview(button)
    }
    
    func setupBackgroundView() {
        
        let layer = CAGradientLayer()
        layer.frame = self.welcomeBackgroundView.bounds
        layer.colors = [
            UIColor(red: 248/255, green: 129/255, blue: 117/255, alpha: 1.0).cgColor,
            UIColor(red: 85/255, green: 80/255, blue: 126/255, alpha: 1.0).cgColor,
            UIColor.B1.cgColor
        ]
        layer.startPoint = CGPoint(x: 200, y: 0)
        layer.endPoint = CGPoint(x: 200, y: 1)
        self.welcomeBackgroundView.layer.insertSublayer(layer, at: 0)
        
        cloudImageView.float(duration: 1.8)
    }
}
