//
//  CreateGrowthContentCardViewController.swift
//  vini
//
//  Created by Yi-Chin Hsu on 2021/10/19.
//

import UIKit
import PhotosUI
import RSKPlaceholderTextView

class SetGrowthContentCardViewController: UIViewController {
    
    enum Status {
        
        case create
        case edit
    }
    
    private enum Segue: String {
        
        case showUpdateContentCardAlert = "ShowUpdateContentCardAlert"
        case showEmptyInputAlert = "ShowEmptyInputAlert"
    }
    
    weak var delegate: DataManagerProtocol?
    var manager: GrowthContentManager = GrowthContentManager.shared
    
    @IBOutlet weak var photoLibraryButton: UIButton! {
        
        didSet {
            
            if #available(iOS 15, *) {
                photoLibraryButton.setBackgroundImage(UIImage(systemName: "photo.circle.fill"), for: .normal)
            }
        }
    }
    
    @IBOutlet weak var introLabel: UILabel! {
        
        didSet {
            
            introLabel.text = "關於「\(growthCard?.title ?? "")」..."
        }
    }
    
    @IBOutlet weak var titleIntroLabel: UILabel! {
        
        didSet {
            
            titleIntroLabel.text = "這個學習的標題是..."
        }
    }
    
    @IBOutlet weak var contentTextView: RSKPlaceholderTextView! {
        
        didSet {
            
            contentTextView.delegate = self
            contentTextView.text = contentCard.content
        }
    }
    
    @IBOutlet weak var titleTextView: RSKPlaceholderTextView! {
        didSet {
            titleTextView.delegate = self
            titleTextView.text = contentCard.title
        }
    }
    
    @IBOutlet weak var contentImageView: UIImageView! {
        
        didSet {
            
            contentImageView.layer.cornerRadius = 18
            contentImageView.loadImage(contentCard.image, placeHolder: nil)
        }
    }
    
    var growthCard: GrowthCard?
    var contentCard = GrowthContent()
    var newImageIsSet: Bool = false
    var currentStatus: Status = .create
        
    override func viewDidLoad() {
        super.viewDidLoad()
                
        self.isModalInPresentation = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupTextView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(
            withDuration: 0.4,
            animations: {
                self.contentTextView.becomeFirstResponder()
        })
    }
    
    @IBAction func tapCameraButton(_ sender: Any) {
        
        showImagePickerController(sourceType: .camera)
    }
    @IBAction func tapAlbumButton(_ sender: Any) {
        
        showImagePickerController(sourceType: .photoLibrary)
    }
    
    @IBAction func tapDismissButton(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tapSaveButton(_ sender: Any) {
        
        view.endEditing(true)
        
        if contentCard.title.isEmpty || contentCard.content.isEmpty {
            
            performSegue(withIdentifier: Segue.showEmptyInputAlert.rawValue, sender: nil)
            
        } else {
            
            playLightImpactVibration()
            
            switch currentStatus {
                
            case .create:
                
                addGrowthContentCard()
                
            case .edit:
                
                performSegue(withIdentifier: Segue.showUpdateContentCardAlert.rawValue, sender: nil)
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let alert = segue.destination as? AlertViewController {
            
            switch segue.identifier {
 
            case Segue.showUpdateContentCardAlert.rawValue:
                
                alert.alertType = .updateContentCardAlert
                alert.onConfirm = { [weak self] in
                    
                    guard let self = self else { return }

                    self.updateGrowthContentCard()
                }
                
            case Segue.showEmptyInputAlert.rawValue:
                
                alert.alertType = .emptyInputAlert
            
            default:
                break
            
            }
        }
    }
    
}

// MARK: - Firebase -
extension SetGrowthContentCardViewController {
    
    private func addGrowthContentCard() {
        
        VProgressHUD.show()
        
        manager.addGrowthContents(
            id: growthCard?.id ?? "",
            contentCard: contentCard,
            imageView: contentImageView) { result in
                
                switch result {
                case .success(let message):
                    
                    print(message)
                    self.delegate?.fetchData()
                    VProgressHUD.showSuccess()
                    self.dismiss(animated: true, completion: nil)
                    
                case .failure(let error):
                    print(error)
                    VProgressHUD.showFailure()
                }
            }
    }
    
    func updateGrowthContentCard() {
        
        VProgressHUD.show()
        
        manager.updateGrowthContents(
            contentCard: contentCard,
            imageView: newImageIsSet ? contentImageView : nil) { result in
            
            switch result {
            case .success(let message):
                print(message)
                self.delegate?.fetchData()
                VProgressHUD.showSuccess()
                self.dismiss(animated: true, completion: nil)
                
            case .failure(let error):
                print(error)
                VProgressHUD.showFailure()
            }
        }
    }
    
}

// MARK: - View-related Setup
extension SetGrowthContentCardViewController {
    
    func setupTextView() {
        
        contentTextView.placeholder = "我的新發現/學習是..."
        contentTextView.tintColor = UIColor.S1
        contentTextView.contentInset = UIEdgeInsets(top: 0, left: -2, bottom: 0, right: 0)
        
        titleTextView.placeholder = "為這個學習下一個標題..."
        titleTextView.tintColor = UIColor.S1
        titleTextView.contentInset = UIEdgeInsets(top: 0, left: -2, bottom: 0, right: 0)
    }
}

// MARK: - UITextView Delegate -
extension SetGrowthContentCardViewController: UITextViewDelegate {
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        
        textView.resignFirstResponder()
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        guard let text = textView.text,
              !text.isEmpty else {
                  return
              }
        
        switch textView {
            
        case contentTextView:
            
            contentCard.content = text
            
        case titleTextView:
            
            contentCard.title = text
            
        default:
            
            break
        }
    }
    
}

// MARK: - Image Picker -
extension SetGrowthContentCardViewController: UIImagePickerControllerDelegate,
                                                UINavigationControllerDelegate, PHPickerViewControllerDelegate {

    func showImagePickerController(sourceType: UIImagePickerController.SourceType) {

            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.allowsEditing = true
            imagePickerController.sourceType = sourceType
            present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {

        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            contentImageView.image = editedImage
        }

        if let originalImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            contentImageView.image = originalImage
        }
        
        newImageIsSet = true

        dismiss(animated: true, completion: nil)
    }
    
    @available(iOS 14, *)
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        picker.dismiss(animated: true)
        
        let itemProviders = results.map(\.itemProvider)
        
        if let itemProvider = itemProviders.first, itemProvider.canLoadObject(ofClass: UIImage.self) {
            
            let previousImage = contentImageView.image
            
            itemProvider.loadObject(ofClass: UIImage.self) {[weak self] (image, _) in
                DispatchQueue.main.async {
                    guard let self = self,
                          let image = image as? UIImage,
                          self.contentImageView.image == previousImage else {
                              return
                              
                          }
                    self.contentImageView.image = image
                }
            }
        }
    }
    
}
