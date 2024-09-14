//
//  DiscoverViewController.swift
//  vini
//
//  Created by Yi-Chin Hsu on 2021/10/25.
//

import UIKit

class DiscoverViewController: UIViewController {
    
    private enum Segue: String {
        
        case showProfileSetting = "ShowProfileSetting"
        case showSendMailPage = "ShowSendMailPage"
        case showMap = "ShowMap"
        case showBlockUserAlert = "ShowBlockUserAlert"
    }
    
    @IBOutlet weak var backgroundRectView: UIView!
    @IBOutlet weak var bigCloudImageView: UIImageView!
    @IBOutlet weak var mediumCloudImageView: UIImageView!
    
    private let mapView = MapScrollView()
    private var cloudCategory: CloudCategory = .selfGrowth
    private var infoOfUsers: [ViniView] = []
        
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var wonderingLabel: UILabel!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var mapButton: UIButton! {
        
        didSet {
            
            if #available(iOS 15, *) {
                
                mapButton.setBackgroundImage(UIImage(systemName: "map.circle.fill"), for: .normal)
            }
        }
    }
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var blockButton: UIButton!
    @IBOutlet weak var leftIndicatorArrow: UIButton!
    @IBOutlet weak var rightIndicatorArrow: UIButton!
    
    let discoverUserManager = DiscoverUserManager.shared
    let userManager = UserManager.shared
    
    private var currentSelectedVini: ViniView = ViniView()
    private var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.isUserInteractionEnabled = true
        
        setupNotificationCenterObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupMapScrollView()
        setupNavigationController(title: "探索", titleColor: .white)
        navigationController?.navigationBar.isHidden = true
        sendButton.setupCorner()
        bigCloudImageView.float(duration: 1.6)
        mediumCloudImageView.float(duration: 2.0)
        view.bringSubviewToFront(headerView)
        view.bringSubviewToFront(mapButton)
        view.bringSubviewToFront(profileButton)
        view.bringSubviewToFront(mediumCloudImageView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if (backgroundRectView.layer.sublayers?.first as? CAGradientLayer) == nil {

            setupBackgroundRectView()
        }
        
        fetchUserInfoWithoutBlockList()
        showBackgroundViewScaleUpAnimation()
        showInitialIndicatorAnimation()
        playPageLandingImpactVibration()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        backgroundRectView.alpha = 0.1
        wonderingLabel.alpha = 0
        nameLabel.alpha = 0
        bigCloudImageView.alpha = 0
        mediumCloudImageView.alpha = 0
        mapView.clearStackSubviews()
        resetTitle()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        resetBackgroundViewScaleUpAnimation()
    }
    
    @objc private func onTap(_ gesture: UIGestureRecognizer) {
        
        let touchPoint = gesture.location(in: self.mapView.mapStackView)
        
        self.mapView.mapStackView.arrangedSubviews.filter { $0.frame.contains(touchPoint)}.forEach { map  in
            
            let location = gesture.location(in: map)
            
            map.subviews.filter {$0.frame.contains(location)}.forEach { vini in
                
                if let vini = vini as? ViniView {
                    
                    sendButton.alpha = 1
                    blockButton.alpha = 1
                    
                    vini.isUserInteractionEnabled = false
                    
                    if vini.data.id == UserManager.shared.userID {
                        
                        sendButton.alpha = 0
                        blockButton.alpha = 0
                    }
                    
                    nameLabel.text = vini.data.name
                    wonderingLabel.text = vini.data.wondering
                    
                    if self.currentSelectedVini != vini {
                        
                        vini.float(duration: 0.5)
                        self.currentSelectedVini.layer.removeAllAnimations()
                        self.currentSelectedVini.isUserInteractionEnabled = true
                        self.currentSelectedVini = vini
                        self.playLightImpactVibration(delay: 0.1)
                    }
                }
            }
        }
    }
    
    @IBAction func tapProfileSettingButton(_ sender: Any) {

        playLightImpactVibration()
        performSegue(withIdentifier: Segue.showProfileSetting.rawValue, sender: nil)
    }
    
    @IBAction func tapSendMailButton(_ sender: Any) {
        
        playLightImpactVibration()
        performSegue(withIdentifier: Segue.showSendMailPage.rawValue, sender: nil)
    }
    
    @IBAction func tapMapButton(_ sender: Any) {
        
        playLightImpactVibration()
        performSegue(withIdentifier: Segue.showMap.rawValue, sender: nil)
    }
    
    @IBAction func tapBlockUserButton(_ sender: Any) {
        
        performSegue(withIdentifier: Segue.showBlockUserAlert.rawValue, sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destination = segue.destination as? SendMailViewController {
            
            destination.recipient = currentSelectedVini
            destination.user = user
            destination.delegate = self
        }
        
        if let destination = segue.destination as? DiscoverMapViewController {
            
            destination.delegate = self
            destination.currentSelectedCategory = cloudCategory
        }
        
        if let destination = segue.destination as? SetProfileViewController {
            
            destination.delegate = self
        }
        
        if let alert = segue.destination as? AlertViewController {
            
            alert.alertStyle = .danger
            alert.alertType = .blockUserAlert
            alert.viniType = UIImage.AssetIdentifier.xmark
            alert.onConfirm = { [weak self] in
                
                guard let self = self else { return }
                
                self.blockUser()
            }
        }
    }
    
}

extension DiscoverViewController {
    
    func setupMapScrollView() {
        
        mapView.dataSource = self
        mapView.delegate = self
        self.view.addSubview(mapView)
                
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTap(_:)))
        self.mapView.addGestureRecognizer(tapGesture)
        
        mapView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            
            mapView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            mapView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 1)
        ])
    }
    
    func setupBackgroundRectView() {
        
        backgroundRectView.layer.sublayers?.forEach({ layer in
            
            if let layer = layer as? CAGradientLayer {
                layer.removeFromSuperlayer()
            }
        })
        
        let layer = CAGradientLayer()
        layer.frame = self.backgroundRectView.bounds
        layer.colors = cloudCategory.colors.reversed()
        layer.startPoint = CGPoint(x: 200, y: 0)
        layer.endPoint = CGPoint(x: 200, y: 1)
        self.backgroundRectView.layer.insertSublayer(layer, at: 0)
        
        let gradientChangeAnimation = CABasicAnimation(keyPath: "colors")
        gradientChangeAnimation.duration = 1.8
        gradientChangeAnimation.toValue = cloudCategory.colors
        gradientChangeAnimation.fillMode = CAMediaTimingFillMode.forwards
        gradientChangeAnimation.isRemovedOnCompletion = false
        layer.add(gradientChangeAnimation, forKey: nil)
    }
    
    func resetTitle() {
        
        wonderingLabel.text = "這裡是\(cloudCategory.title)層\n看看大家在想些什麼？"
        nameLabel.text = "最近在想些什麼？"
        sendButton.alpha = 0
        blockButton.alpha = 0
    }
    
    func setupNotificationCenterObserver() {
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateUserInfo(notification:)),
            name: Notification.Name(rawValue: "updateUserInfo"),
            object: nil
        )
    }
    
    @objc func updateUserInfo(notification: Notification) {
        
        if let userInfo = notification.userInfo,
           let user = userInfo["user"] as? User {
            
            self.user = user
        }
    }
    
}

extension DiscoverViewController {
    
    func fetchUserInfoWithoutBlockList() {
        
        if let blockList = UserManager.shared.userBlockList {
            
            self.fetchUserInfo(blockList: blockList)
            
        } else {
            
            discoverUserManager.fetchUserProfile { result in
                
                switch result {
                    
                case .success(let user):
                    
                    self.fetchUserInfo(blockList: user.blockList)
                    
                case.failure(let error):
                    
                    print(error)
                }
            }
        }
    }
    
    func fetchUserInfo(blockList: [String]) {
        
        discoverUserManager.fetchData(
            category: cloudCategory.category,
            blockList: blockList) { result in
                
            switch result {
                
            case .success(let vinis):
                
                self.infoOfUsers = vinis
                self.mapView.configureMapScrollView()
                self.displayMapView()

            case .failure(let error):
                
                print(error)
            }
        }
    }
    
    func blockUser() {
        
        VProgressHUD.show()
        
        userManager.updateBlockUserList(blockUserID: currentSelectedVini.data.id, action: .block) { result in
            
            switch result {
                
            case .success:
                
                VProgressHUD.dismiss()
                self.willDisplayDiscoverPage()
                
            case .failure(let error):
                
                print(error)
                VProgressHUD.showFailure(text: "封鎖時出了一些問題，請重新再試")
            }
        }
    }
    
}

extension DiscoverViewController: MapScrollViewDataSource {
    
    func infoOfUsers(_ mapScrollView: MapScrollView) -> [ViniView] {
        
        return infoOfUsers
    }
}

extension DiscoverViewController: MapScrollViewDelegate {
    
    func didReachedRightEdge() {
        
        self.rightIndicatorArrow.setBackgroundImage(UIImage(systemName: "arrow.right.to.line"), for: .normal)
        showIndicatorAnimation(indicator: rightIndicatorArrow)
        playReachedEdgeImpactVibration()
    }
    
    func didReachedLeftEdge() {
        
        self.leftIndicatorArrow.setBackgroundImage(UIImage(systemName: "arrow.left.to.line"), for: .normal)
        showIndicatorAnimation(indicator: leftIndicatorArrow)
        playReachedEdgeImpactVibration()
    }
}

extension DiscoverViewController: DiscoverProtocol {
    
    func didSelectCloudCategory(_ category: CloudCategory) {
        
        // reload vinis when user changes cloud category
        self.cloudCategory = category
        self.setupBackgroundRectView()
        self.fetchUserInfoWithoutBlockList()
        self.resetTitle()
    }
    
    func willDisplayDiscoverPage() {
        
        self.setupBackgroundRectView()
        self.fetchUserInfoWithoutBlockList()
        self.resetTitle()
    }
}

extension DiscoverViewController {
    
    func displayMapView() {
        
        UIView.animate(
            withDuration: 0.7,
            animations: {
                
                self.mapView.setContentOffsetToMiddle()
                self.wonderingLabel.alpha = 1
                self.nameLabel.alpha = 1
                self.backgroundRectView.alpha = 1
            },
            completion: { _ in
                self.showCloudAnimation()
            }
        )
    }
    
    func showCloudAnimation() {
        
        UIView.animate(
            withDuration: 0.8,
            animations: {
                self.bigCloudImageView.alpha = 1
                self.mediumCloudImageView.alpha = 1
            }
        )
    }
    
    func resetBackgroundViewScaleUpAnimation() {
    
        UIView.animate(
            withDuration: 2.0,
            delay: 0.0,
            usingSpringWithDamping: 2.0,
            initialSpringVelocity: 3.0,
            options: .curveEaseIn,
            animations: {
                self.backgroundRectView.transform = .identity
                
            },
            completion: nil)
    }
    
    func showBackgroundViewScaleUpAnimation() {
        
        guard backgroundRectView.frame.width < self.view.frame.size.width else { return }
        
        let xScaleFactor = self.view.frame.size.width / backgroundRectView.frame.width
        let yScaleFactor = self.view.frame.size.height / backgroundRectView.frame.height
        let scaleTransform = CGAffineTransform(scaleX: xScaleFactor, y: yScaleFactor)
        
        UIView.animate(
            withDuration: 2.0,
            delay: 0.0,
            usingSpringWithDamping: 2.0,
            initialSpringVelocity: 3.0,
            options: .curveEaseIn,
            animations: {
                self.backgroundRectView.transform = scaleTransform
                self.view.bringSubviewToFront(self.mapButton)
            },
            completion: nil)
    }
    
    func showInitialIndicatorAnimation() {
        
        leftIndicatorArrow.transform = .identity
        rightIndicatorArrow.transform = .identity
        
        leftIndicatorArrow.setBackgroundImage(UIImage(systemName: "chevron.left.2"), for: .normal)
        rightIndicatorArrow.setBackgroundImage(UIImage(systemName: "chevron.right.2"), for: .normal)
        
        UIView.animate(
            withDuration: 0.8,
            delay: 0.0,
            options: .curveEaseInOut,
            animations: {
                
                self.leftIndicatorArrow.alpha = 1
                self.rightIndicatorArrow.alpha = 1
                self.leftIndicatorArrow.transform = CGAffineTransform(scaleX: 1.5, y: 1.0)
                self.rightIndicatorArrow.transform = CGAffineTransform(scaleX: 1.5, y: 1.0)
                
            },
            completion: { _ in

                self.hideIndicatorAnimation(indicator: self.leftIndicatorArrow)
                self.hideIndicatorAnimation(indicator: self.rightIndicatorArrow)
            }
        )
    }
    
    func showIndicatorAnimation(indicator: UIView) {
        
        UIView.animate(
            withDuration: 0.2,
            delay: 0.0,
            options: .curveEaseIn,
            animations: {
                
                indicator.alpha = 1
            },
            completion: { _ in
                
                self.hideIndicatorAnimation(indicator: indicator)
            }
        )
    }
    
    func hideIndicatorAnimation(indicator: UIView) {
        
        UIView.animate(
            withDuration: 0.4,
            delay: 0.5,
            options: .curveEaseIn,
            animations: {
                
                indicator.alpha = 0
            },
            completion: { _ in
                
                self.leftIndicatorArrow.transform = .identity
                self.rightIndicatorArrow.transform = .identity
            }
        )
    }
}
