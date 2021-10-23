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

class GrowthCaptureViewController: UIViewController {
    
    private enum Segue: String {
        
        case createContentCard = "CreateGrowthContentCard"
        case editContentCard = "EditGrowthContentCard"
        case drawConclusions = "DrawConclusions"
    }
    
    weak var growthPageVC: GrowthPageViewController?

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
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    @IBOutlet weak var footerView: UIView!
    
    @IBOutlet weak var editButton: UIButton!
    
    lazy var headerEmoji: String = ""
    lazy var headerTitle: String = ""
    lazy var headerEmojiToUpdate: String = ""
    lazy var headerTitleToUpdate: String = ""
    var growthCardID: String = ""
    
    var data: [GrowthContent] = []
    
    var isInCreateCardMode: Bool = false
    
    var isInEditMode: Bool = false {
        didSet {
            emojiTextField.isEnabled = isInEditMode
            headerTitleTextView.isEditable = isInEditMode
            tableView.isScrollEnabled = !isInEditMode
            
            let imageName = isInEditMode ? "checkmark.circle.fill" : "pencil.circle.fill"
            
            editButton.setBackgroundImage(UIImage(systemName: imageName), for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerCellWithNib(identifier: GrowthContentCell.identifier, bundle: nil)
        tableView.registerCellWithNib(identifier: CreateGrowthContentCell.identifier, bundle: nil)
        isInEditMode = isInCreateCardMode
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = true
        
        if !isInCreateCardMode {
            fetchGrowthContents()
        }
        
        setupHeaderView()
        setupFooterview()
        setupTextView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if isInCreateCardMode {
            showEditPage()
        }
    }
    
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
    }
    
    @IBAction func tapBackButton(_ sender: Any) {
        
        if isInEditMode {
            
            hideEditPage()
            
        } else {
            
            self.growthPageVC?.fetchGrowthCards()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func tapEditButton(_ sender: Any) {
        
        if isInCreateCardMode {
            
            createGrowthCard()
            hideEditPage()
            isInCreateCardMode = false
            
        } else if isInEditMode {
            
            updateGrowthCard()

        } else {
            
            showEditPage()
        }
    }
    
    @objc func tapCreateGrowthContentCardButton(_ sender: UIButton) {
        
        performSegue(withIdentifier: Segue.createContentCard.rawValue, sender: growthCardID)
    }
    
    @objc func tapDrawConclusionsButton(_ sender: UIButton) {
        
        performSegue(withIdentifier: Segue.drawConclusions.rawValue, sender: nil)
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

        GrowthCardProvider.shared.updateGrowthCard(id: growthCardID, emoji: headerEmojiToUpdate, title: headerTitleToUpdate) { result in
            
            switch result {
            case .success(let message):
                
                print(message)
                self.hideEditPage()
                
            case .failure(let error):
                
                print(error)
                self.headerEmojiLabel.text = self.headerEmoji
                self.headerTitleLabel.text = self.headerTitle
            }
        }
    }
    
    private func createGrowthCard() {
        
        var growthCard: GrowthCard = GrowthCard(
            id: "",
            title: headerTitleToUpdate,
            emoji: headerEmojiToUpdate,
            isStarred: false,
            isArchived: false,
            archivedTime: nil,
            contents: nil,
            conclusion: nil,
            createdTime: nil
        )
        
        GrowthCardProvider.shared.addData(growthCard: &growthCard) { result in
            
            switch result {
            case .success(let message):
                print(message)
                self.growthCardID = growthCard.id
            case .failure(let error):
                print(error)
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
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CreateGrowthContentCell.identifier, for: indexPath) as? CreateGrowthContentCell else {
                fatalError()
            }
            
            cell.createGrowthContentCardButton.addTarget(self, action: #selector(tapCreateGrowthContentCardButton(_:)), for: .touchUpInside)
            
            return cell
            
        } else {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: GrowthContentCell.identifier, for: indexPath) as? GrowthContentCell else {
                fatalError()
            }
            
            cell.setupCell(content: data[indexPath.row - 1])
            
            return cell
        }
        
    }
}

extension GrowthCaptureViewController: UITableViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        editButton.isHidden = scrollView.contentOffset.y != 0
    }

    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        // Disable welcome cell's content menu
        if indexPath.row == 0 {
            
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
                    
                    let id = self.data[indexPath.row - 1].id
                    let imageExists = !self.data[indexPath.row - 1].image.isEmpty
                    
                    self.deleteGrowthContentCard(id: id, imageExists: imageExists) { success in
                        
                        if success {
                            self.data.remove(at: indexPath.row - 1)
                            self.tableView.deleteRows(at: [indexPath], with: .fade)
                        }
                    }
                }
            
            return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
                UIMenu(title: "", children: [edit, delete])
            }
        }
    }
    
}

// MARK: - Text Field & Text View -
extension GrowthCaptureViewController: UITextViewDelegate, UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        
        switch textField {
        case emojiTextField:
            
            guard let text = textField.text,
                  text.count < 2,
                  (text.isSingleEmoji || text.isEmpty) else {
                      textField.text = headerEmoji
                      return
                  }
            
            headerEmojiToUpdate = text
            
        default:
            break
        }
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        switch textView {
        case headerTitleTextView:
            
            guard let text = textView.text,
                  text.count <= 20 else {
                      textView.text = ""
                      return
                  }
            
            headerTitleToUpdate = text
            
        default:
            break
        }

    }
}

extension GrowthCaptureViewController {
    
    func showEditPage() {
        
        isInEditMode = true
        
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
        
        isInEditMode = false
        
        UIView.animate(
            withDuration: 0.6,
            delay: 0,
            options: [.curveEaseInOut],
            animations: {
                self.expandViewHeight.constant = 0
                self.view.layoutIfNeeded()
            })
    }
    
    func setupTextView() {
        
        headerTitleTextView.placeholder = "輸入你的成長項目標題..."
        headerTitleTextView.tintColor = UIColor.B2
        headerTitleTextView.contentInset = UIEdgeInsets(top: 0, left: -4, bottom: 0, right: 0)
    }
    
    func setupHeaderView() {
        
        headerView.setBottomCurve()
        headerEmojiBackgroundView.layer.cornerRadius = 40
    }
    
    func setupFooterview() {
        
        footerView.setTopCurve()
        
        let buttonStackView = UIStackView()
        buttonStackView.distribution = .fillEqually
        buttonStackView.axis = .vertical
        buttonStackView.spacing = 16
        
        footerView.addSubview(buttonStackView)
        
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            buttonStackView.widthAnchor.constraint(equalTo: footerView.widthAnchor, multiplier: 0.7),
            buttonStackView.heightAnchor.constraint(equalToConstant: 100),
            buttonStackView.centerXAnchor.constraint(equalTo: footerView.centerXAnchor),
            buttonStackView.centerYAnchor.constraint(equalTo: footerView.centerYAnchor, constant: 10)
        ])
        
        let conclusionButton = UIButton()
        conclusionButton.layer.cornerRadius = 21
        buttonStackView.addArrangedSubview(conclusionButton)
        
        conclusionButton.backgroundColor = UIColor.S1
        conclusionButton.setTitleColor(UIColor.B2, for: .normal)
        conclusionButton.setTitle("我的學習結論 →", for: .normal)
        conclusionButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        
        conclusionButton.addTarget(self, action: #selector(tapDrawConclusionsButton(_:)), for: .touchUpInside)
        
        let archiveButton = UIButton()
        archiveButton.layer.cornerRadius = 21
        buttonStackView.addArrangedSubview(archiveButton)
        
        archiveButton.backgroundColor = UIColor.B1
        archiveButton.setTitleColor(UIColor.white, for: .normal)
        archiveButton.setTitle("封存這張卡片 →", for: .normal)
        archiveButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        
//        archiveButton.addTarget(self, action: #selector(tapDrawConclusionsButton(_:)), for: .touchUpInside)
    }
}
