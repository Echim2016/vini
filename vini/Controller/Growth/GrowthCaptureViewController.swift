//
//  GrowthCaptureViewController.swift
//  vini
//
//  Created by Yi-Chin Hsu on 2021/10/19.
//

import UIKit
import grpc
import FirebaseFirestore
import RSKPlaceholderTextView
import Haptica
import AVFoundation

protocol GrowthDelegate: AnyObject {
    
    func fetchData()
}

class GrowthCaptureViewController: UIViewController {
    
    private enum Segue: String {
        
        case createContentCard = "CreateGrowthContentCard"
        case editContentCard = "EditGrowthContentCard"
        case drawConclusions = "DrawConclusions"
        case showArchiveView = "ShowArchiveView"
        case showCongratsPage = "ShowCongratsPage"
        case showDeleteGrowthContentCardAlert = "ShowDeleteGrowthContentCardAlert"
        case showContentCardEmptyAlert = "ShowContentCardEmptyAlert"
    }
    
    enum State {

        case create
        case edit
        case browse
        case toArchive
        case archiving
        case archived
        case review
    }

    weak var delegate: GrowthDelegate?
    
    var state: State = .browse {
        
        didSet {
            
            switch state {
                
            case .browse:
                setupFooterAppearance()
                setupEditAppearance(disable: true)
                
            case .toArchive:
                setupFooterAppearance(archive: true)
                
            case .archived:
                navigateToCongratsPage()
                
            case .review:
                setupEditButton(disable: true)
                setupEditAppearance(disable: true)
                
            case .edit:
                setupEditAppearance()
                
            default:
                break
            }
        }
    }

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var expandView: UIView!
    @IBOutlet weak var expandViewHeight: NSLayoutConstraint!
    @IBOutlet weak var headerEmojiBackgroundView: UIView!
    @IBOutlet weak var headerEmojiLabel: UILabel! {
        didSet {
            headerEmojiLabel.text = headerEmoji
        }
    }
    @IBOutlet weak var headerTitleLabel: UILabel! {
        didSet {
            headerTitleLabel.text = headerTitle
        }
    }
    
    @IBOutlet weak var emojiTextField: UITextField! {
        didSet {
            emojiTextField.text = headerEmoji
            emojiTextField.delegate = self
        }
    }
   
    @IBOutlet weak var headerTitleTextView: RSKPlaceholderTextView! {
        didSet {
            headerTitleTextView.text = headerTitle
            headerTitleTextView.delegate = self
        }
    }
    
    @IBOutlet weak var characterLimitLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    let titleCharactersLimit = 18
    
    var buttonStackView: UIStackView = {
       
        let buttonStackView = UIStackView()
        buttonStackView.distribution = .fillEqually
        buttonStackView.axis = .vertical
        buttonStackView.spacing = 16
        
        return buttonStackView
    }()
    
    var sparkVini: UIImageView = {
       
        let viniImageView = UIImageView()
        viniImageView.image = UIImage(assetIdentifier: .spark)
        viniImageView.contentMode = .scaleAspectFit
        
        return viniImageView
    }()

    @IBOutlet weak var archiveIntroLabel: UILabel!
    @IBOutlet weak var archiveButton: UIButton!
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var editButton: UIButton!
    
    // MARK: - to be refactor
    
    lazy var headerEmoji: String = ""
    lazy var headerTitle: String = ""
    lazy var headerEmojiToUpdate: String = ""
    lazy var headerTitleToUpdate: String = ""
    var growthCardID: String = ""
    
    // -------------------------------
    
    var data: [GrowthContent] = [] {
        didSet {
            if data.isEmpty && state == .archiving {
                
                state = .archived
            }
        }
    }

    var player: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerCellWithNib(identifier: GrowthContentCell.identifier, bundle: nil)
        tableView.registerCellWithNib(identifier: CreateGrowthContentCell.identifier, bundle: nil)
        setupFooterview()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = true
        
        if state != .create {
            fetchGrowthContents()
        }
        
        setupHeaderView()
        setupTextView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if state == .create {
            showEditPage()
            setupEditAppearance()
        }
    }
    
    // MARK: - to be refactor
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destinationVC = segue.destination as? SetGrowthContentCardViewController {
            
            destinationVC.growthCaptureVC = self
            destinationVC.contentIntroText = headerTitle
            
            if let growthCardID = sender as? String {
                
                destinationVC.growthCardID = growthCardID
            }
            
            if let index = sender as? Int {
                
                destinationVC.titleToAdd = data[index].title
                destinationVC.contentToAdd = data[index].content
                destinationVC.imageURL = data[index].image
                destinationVC.contentCardID = data[index].id
            }
            
            switch segue.identifier {
                
            case Segue.createContentCard.rawValue:
                destinationVC.currentStatus = .create
                
            case Segue.editContentCard.rawValue:
                destinationVC.currentStatus = .edit
                
            default:
                break
            }
        }
        
        if let destinationVC = segue.destination as? DrawConclusionsViewController {
            
            destinationVC.introText = headerTitle
            destinationVC.growthCardID = self.growthCardID
        }
        
        if let destinationVC = segue.destination as? CongratsViewController {
            
            destinationVC.delegate = delegate
        }
        
        if let alert = segue.destination as? AlertViewController {
            
            switch segue.identifier {
                
            case Segue.showDeleteGrowthContentCardAlert.rawValue:
                
                if let indexPath = sender as? IndexPath {
                    
                    alert.alertType = .deleteGrowthContentCardAlert
                    alert.onConfirm = {
                        
                        let id = self.data[indexPath.row - 1].id
                        let imageExists = !self.data[indexPath.row - 1].image.isEmpty
                        
                        self.deleteGrowthContentCard(id: id, imageExists: imageExists) { success in
                            
                            if success {
                                self.data.remove(at: indexPath.row - 1)
                                self.tableView.deleteRows(at: [indexPath], with: .fade)
                            }
                        }
                    }
                }
                
            case Segue.showContentCardEmptyAlert.rawValue:
                
                alert.alertType = .emptyContentCardAlert
                
            default:
                break
            }
        }
    }
    // -------------------------------
    
    // MARK: - to be refactor
    @IBAction func tapBackButton(_ sender: Any) {
        
        switch state {
            
        case .create:
            
            self.dismiss(animated: true, completion: nil)
            
        case .edit:
            
            hideEditPage()
            headerTitleTextView.text = headerTitle
            
        default:
            
            self.delegate?.fetchData()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func tapEditButton(_ sender: Any) {
        
        switch state {
            
        case .create:
            
            createGrowthCard()
            
        case .edit:
            
            updateGrowthCard()
            
        case .browse:
            
            showEditPage()
            state = .edit
            
        default:
            
            break
        }
    }
    
    // -----------------------------------------------------------
    
    @objc func tapCreateGrowthContentCardButton(_ sender: UIButton) {
        
        Haptic.play(".", delay: 0)
        performSegue(withIdentifier: Segue.createContentCard.rawValue, sender: growthCardID)
    }
    
    @objc func tapDrawConclusionsButton(_ sender: UIButton) {
        
        Haptic.play(".", delay: 0)
        performSegue(withIdentifier: Segue.drawConclusions.rawValue, sender: nil)
    }
    
    @objc func tapShowArchiveViewButton(_ sender: UIButton) {
        
        Haptic.play(".", delay: 0)
        
        if data.isEmpty {
            
            performSegue(withIdentifier: Segue.showContentCardEmptyAlert.rawValue, sender: nil)
            
        } else {
            
            showArchiveButton()
        }
    }
    
    @objc func longPress(gesture: UILongPressGestureRecognizer) {
        
        var workItem: DispatchWorkItem?
                
        if gesture.state == UIGestureRecognizer.State.began {
                                    
            state = .archiving
            
            setupArchivingAppearance()
            
            let dataLength = data.count
            for index in 0..<dataLength {
                
                workItem = DispatchWorkItem {
                    
                    if self.state == .archiving {
                       
                        let indexPath = IndexPath(row: dataLength - index, section: 0)
                        self.data.remove(at: dataLength - 1 - index)
                        self.tableView.deleteRows(at: [indexPath], with: .fade)
                        self.playArchivedSound()
                        Haptic.play("..oO-Oo..", delay: 0.2)

                    } else {
                        
                        self.fetchGrowthContents()
                    }
                }
                
                if let workItem = workItem {
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.9 * Double(index), execute: workItem)
                }

            }

        } else if gesture.state == UIGestureRecognizer.State.ended {
            
            if data.isEmpty {
                
                navigateToCongratsPage()
                
            } else {
                
                state = .browse
            }
        }
    }
}

// MARK: - VC appearance in different state
extension GrowthCaptureViewController {
    
    private func setupEditButton(disable: Bool = false) {
        
        editButton.isEnabled = !disable
        editButton.isHidden = disable
    }
    
    private func setupFooterAppearance(archive: Bool = false) {
 
        buttonStackView.alpha = archive ? 0 : 1
        archiveButton.alpha = archive ? 1 : 0
        sparkVini.alpha = archive ? 1 : 0
        archiveIntroLabel.text = archive ? "請長按按鈕來封存卡片" : "對生活中的小細節用心，\n就能把世界活得更寬闊。"
    }
    
    private func setupArchivingAppearance() {
        
        archiveIntroLabel.text = "正在努力打包所有學習，請持續長按..."
        archiveIntroLabel.isHidden = false
        self.sparkVini.shake()
    }
    
    private func setupEditAppearance(disable: Bool = false) {
        
        emojiTextField.isEnabled = !disable
        headerTitleTextView.isEditable = !disable
        characterLimitLabel.isHidden = disable
        tableView.isScrollEnabled = disable
        
        let imageName = disable ? "pencil.circle.fill" : "checkmark.circle.fill"
        
        editButton.setBackgroundImage(UIImage(systemName: imageName), for: .normal)
    }
}

// MARK: - Firebase -
extension GrowthCaptureViewController {
    
    func fetchGrowthContents() {
        
        GrowthContentProvider.shared.fetchGrowthContents(id: growthCardID) { result in
            
            switch result {
            case .success(let contents):
                
                self.data = contents
        
                UIView.transition(
                    with: self.tableView,
                    duration: 0.5,
                    options: .transitionCrossDissolve,
                    animations: {
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    },
                    completion: nil)
                
            case .failure(let error):
                
                print(error)
            }
        }
    }
    
    private func deleteGrowthContentCard(id: String, imageExists: Bool, completion: @escaping (Bool) -> Void) {
        
        GrowthContentProvider.shared.deleteGrowthContentCard(id: id, imageExists: imageExists) { result in
            
            switch result {
            case .success(let message):
                
                print(message)
                completion(true)
                
            case .failure(let error):
                
                print(error)
                completion(false)
            }
        }
    }
    
    private func updateGrowthCard() {
        
        textFieldDidChangeSelection(emojiTextField)
        textViewDidEndEditing(headerTitleTextView)

        GrowthCardProvider.shared.updateGrowthCard(id: growthCardID, emoji: headerEmojiToUpdate, title: headerTitleToUpdate) { [self] result in
            
            switch result {
            case .success(let message):
                
                print(message)
                self.headerTitle = self.headerTitleToUpdate
                self.headerEmoji = self.headerEmojiToUpdate
                self.hideEditPage()
                
            case .failure(let error):
                
                print(error)
                self.headerEmojiLabel.text = self.headerEmoji
                self.headerTitleLabel.text = self.headerTitle
            }
        }
    }
    
    private func createGrowthCard() {
        
        if headerEmojiToUpdate.isEmpty || headerTitleToUpdate.isEmpty {
            
            VProgressHUD.showFailure(text: "似乎有空白的欄位，\n別忘了在圓圈處填入Emoji！🙆‍♂️")
            
        } else if let userID = UserManager.shared.userID {
            
            VProgressHUD.show()
            
            // MARK: - to be refactor
            var growthCard: GrowthCard = GrowthCard(
                id: "",
                userID: userID,
                title: headerTitleToUpdate,
                emoji: headerEmojiToUpdate,
                isStarred: false,
                isArchived: false,
                archivedTime: nil,
                contents: nil,
                conclusion: nil,
                createdTime: nil
            )
            // ------------------------------------
            
            // MARK: - to be refactor
            GrowthCardProvider.shared.addData(growthCard: &growthCard) { result in
                
                switch result {
                case .success(let message):
                    print(message)
                    self.growthCardID = growthCard.id
                    self.headerTitle = growthCard.title
                    self.dismiss(animated: true, completion: nil)
                    VProgressHUD.dismiss()
                case .failure(let error):
                    print(error)
                    VProgressHUD.showFailure(text: "創建成長項目時出了一些問題，請重新再試")
                }
            }
            // ------------------------------------
            
        } else {
            
            VProgressHUD.showFailure(text: "創建成長項目時出了一些問題，請重新登入再試")
        }
        
    }
    
    private func archiveGrowthCard(completion: @escaping (Bool) -> Void) {
        
        GrowthCardProvider.shared.archiveGrowthCard(id: growthCardID) { result in
            
            switch result {
            case .success(let message):
                print(message)
                completion(true)
            case .failure(let error):
                print(error)
                completion(false)
            }
        }
    }
}

extension GrowthCaptureViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.count + 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        300
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: CreateGrowthContentCell.identifier,
                for: indexPath) as? CreateGrowthContentCell
            else {
                fatalError()
            }
            
            cell.createGrowthContentCardButton.addTarget(
                self,
                action: #selector(tapCreateGrowthContentCardButton(_:)),
                for: .touchUpInside
            )
            
            cell.isHidden = state == .archiving
            
            if state == .review {
                
                cell.setupCellForArchivedMode()
            }
            
            return cell
            
        } else {
            
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: GrowthContentCell.identifier,
                for: indexPath) as? GrowthContentCell
            else {
                fatalError()
            }
            
            cell.setupCell(content: data[indexPath.row - 1])
            
            return cell
        }
    }
}

extension GrowthCaptureViewController: UITableViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        editButton.isHidden = scrollView.contentOffset.y != 0 || state == .review
    }

    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        // Disable welcome cell's context menu
        if indexPath.row == 0 || state == .review {
            
            return nil
            
        } else {
            
            let edit = UIAction(
                title: "編輯",
                image: UIImage(systemName: "square.and.pencil")
            ) { _ in
                
                // Navigate to edit page
                self.performSegue(withIdentifier: Segue.editContentCard.rawValue, sender: indexPath.row - 1)
            }
            
            let delete = UIAction(
                title: "刪除",
                image: UIImage(systemName: "trash.fill"),
                attributes: [.destructive]) { _ in
                    
                    self.performSegue(
                        withIdentifier: Segue.showDeleteGrowthContentCardAlert.rawValue,
                        sender: indexPath
                    )
                }
            
            return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
                UIMenu(title: "", children: [edit, delete])
            }
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        cell.alpha = 0.2

        UIView.animate(
            withDuration: 0.2,
            delay: 0.05 * Double(indexPath.row),
            animations: {
                cell.alpha = 1
        })
    }
    
}

// MARK: - Text Field & Text View -
extension GrowthCaptureViewController: UITextViewDelegate, UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        
        switch textField {
        case emojiTextField:
            
            guard let text = textField.text,
                  text.count < 2,
                  (text.containsOnlyEmoji || text.isEmpty) else {
                      textField.text = headerEmoji
                      return
                  }
            
            headerEmojiToUpdate = text
            
        default:
            break
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        switch textView {
            
        case headerTitleTextView:
            
            let currentText = textView.text ?? ""
            guard let stringRange = Range(range, in: currentText) else { return false }
            
            let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
            
            let count = updatedText.count < titleCharactersLimit ? updatedText.count : titleCharactersLimit
            
            characterLimitLabel.text = "\(count) / \(titleCharactersLimit)"
                        
            return updatedText.count <= titleCharactersLimit
            
        default:
            return true
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        switch textView {
        case headerTitleTextView:
            
            guard let text = textView.text,
                  !text.isEmpty else {
                      textView.text = headerTitle
                      return
                  }
                        
            headerTitleToUpdate = textView.text
            
        default:
            break
        }

    }
}

extension GrowthCaptureViewController {
    
    func showEditPage() {
                
        UIView.animate(
            withDuration: 0.6,
            delay: 0,
            options: [.curveEaseInOut],
            animations: {
                self.expandViewHeight.constant = self.view.frame.height - 180
                self.view.layoutIfNeeded()
                self.headerTitleTextView.becomeFirstResponder()
            })
    }
    
    func hideEditPage() {
        
        state = .browse
        
        UIView.animate(
            withDuration: 0.6,
            delay: 0,
            options: [.curveEaseInOut],
            animations: {
                self.expandViewHeight.constant = 0
                self.view.layoutIfNeeded()
            })
    }
    
    func showArchiveButton() {
        
        UIView.animate(
            withDuration: 0.4,
            delay: 0,
            options: [.curveEaseInOut],
            animations: {
                
                self.state = .toArchive
            })
    }
    
    func navigateToCongratsPage() {
        
        archiveGrowthCard { success in
            
            if success {
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {

                    self.performSegue(withIdentifier: Segue.showCongratsPage.rawValue, sender: nil)
                }
            }
        }
    }
    
    func setupTextView() {
        
        headerTitleTextView.placeholder = "輸入成長項目標題..."
        headerTitleTextView.tintColor = UIColor.B2
        headerTitleTextView.contentInset = UIEdgeInsets(top: 0, left: -4, bottom: 0, right: 0)
    
        characterLimitLabel.text = "\(headerTitleTextView.text.count) / \(titleCharactersLimit)"
    }
    
    func setupHeaderView() {
        
        headerView.setBottomCurve()
        headerEmojiBackgroundView.layer.cornerRadius = 40
    }
    
    func setupFooterview() {
        
        footerView.setTopCurve()
   
        footerView.addSubview(buttonStackView)
        
        setupArchiveButton()
        
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            buttonStackView.widthAnchor.constraint(equalTo: footerView.widthAnchor, multiplier: 0.7),
            buttonStackView.heightAnchor.constraint(equalToConstant: 100),
            buttonStackView.centerXAnchor.constraint(equalTo: footerView.centerXAnchor),
            buttonStackView.bottomAnchor.constraint(equalTo: footerView.bottomAnchor, constant: -32)
        ])
        
        let conclusionButton = MainButton()
        conclusionButton.layer.cornerRadius = 21
        buttonStackView.addArrangedSubview(conclusionButton)
        
        conclusionButton.backgroundColor = UIColor.S1
        conclusionButton.setTitleColor(UIColor.B2, for: .normal)
        conclusionButton.setTitle("我的學習結論 →", for: .normal)
        conclusionButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        
        conclusionButton.addTarget(self, action: #selector(tapDrawConclusionsButton(_:)), for: .touchUpInside)
        
        let archiveButton = MainButton()
        archiveButton.layer.cornerRadius = 21
        buttonStackView.addArrangedSubview(archiveButton)
        
        archiveButton.backgroundColor = UIColor.B1
        archiveButton.setTitleColor(UIColor.white, for: .normal)
        archiveButton.setTitle("封存這張卡片 →", for: .normal)
        archiveButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        
        archiveButton.addTarget(self, action: #selector(tapShowArchiveViewButton(_:)), for: .touchUpInside)
        
        archiveButton.alpha = state == .review ? 0 : 1
        archiveButton.isEnabled = state != .review
        
        sparkVini.alpha = 0
        
        view.addSubview(sparkVini)
        
        sparkVini.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            sparkVini.widthAnchor.constraint(equalTo: footerView.widthAnchor, multiplier: 0.3),
            sparkVini.heightAnchor.constraint(equalTo: sparkVini.widthAnchor),
            sparkVini.centerXAnchor.constraint(equalTo: footerView.centerXAnchor),
            sparkVini.bottomAnchor.constraint(equalTo: footerView.topAnchor, constant: 60)
        ])
        
    }
    
    func setupArchiveButton() {
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPress(gesture:)))
            longPress.minimumPressDuration = 0.5
            self.archiveButton.addGestureRecognizer(longPress)
        
        archiveButton.layer.cornerRadius = archiveButton.frame.height / 2
        archiveButton.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .medium)
    }
    
    func playArchivedSound() {
        
        if let url = Bundle.main.url(forResource: "tap-archive-button", withExtension: "wav") {
            
            player = try? AVAudioPlayer(contentsOf: url)
            player?.volume = 0.2
            player?.play()
        }
    }
}
