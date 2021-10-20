//
//  CreateGrowthContentCardViewController.swift
//  vini
//
//  Created by Yi-Chin Hsu on 2021/10/19.
//

import UIKit
import PhotosUI
import RSKPlaceholderTextView

class CreateGrowthContentCardViewController: UIViewController {
    
    @IBOutlet weak var introLabel: UILabel! {
        didSet {
            introLabel.text = "關於「\(contentIntroText)」..."
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
            contentTextView.accessibilityLabel = "content"
        }
    }
    
    @IBOutlet weak var titleTextView: RSKPlaceholderTextView! {
        didSet {
            titleTextView.delegate = self
            titleTextView.accessibilityLabel = "title"
        }
    }
    
    @IBOutlet weak var contentImageView: UIImageView! {
        didSet {
            contentImageView.layer.cornerRadius = 18
        }
    }
    
    @IBOutlet weak var imageLabel: UILabel! {
        didSet {
            imageLabel.text = imageIntroText
        }
    }
    
    var contentIntroText: String = "..."
    var imageIntroText: String = ""
    var growthCardID: String = ""
    
    var titleToAdd: String = ""
    var contentToAdd: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        self.isModalInPresentation = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupTextView()
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
        
        textViewDidEndEditing(contentTextView)
        textViewDidEndEditing(titleTextView)
        
        addGrowthContentCard()
    }
}

// MARK: - Firebase -
extension CreateGrowthContentCardViewController {
    
    func addGrowthContentCard() {
        
        GrowthContentProvider.shared.addGrowthContents(id: growthCardID, title: titleToAdd, content: contentToAdd, imageView: contentImageView) { result in
            
            switch result {
            case .success(let message):
                print(message)
                self.dismiss(animated: true, completion: nil)
                
            case .failure(let error):
                print(error)
            }
        }
    }
}

// MARK: - View-related Setup
extension CreateGrowthContentCardViewController {
    
    func setupTextView() {
        
        contentTextView.placeholder = "我的新發現/學習是..."
        contentTextView.tintColor = UIColor.S1
        contentTextView.contentInset = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 0)
        
        titleTextView.placeholder = "為這個學習下一個標題..."
        titleTextView.tintColor = UIColor.S1
        titleTextView.contentInset = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 0)
    }
}

// MARK: - UITextView Delegate -
extension CreateGrowthContentCardViewController: UITextViewDelegate {
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        
        textView.resignFirstResponder()
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        guard let text = textView.text,
              !text.isEmpty else {
                  return
              }
        
        switch textView.accessibilityLabel {
        case "content":
            contentToAdd = text
        case "title":
            titleToAdd = text
        default:
            break
        }
    }
}

// MARK: - Image Picker -
extension CreateGrowthContentCardViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate, PHPickerViewControllerDelegate {

    func showImagePickerController(sourceType: UIImagePickerController.SourceType) {

            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.allowsEditing = true
            imagePickerController.sourceType = sourceType
            present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            contentImageView.image = editedImage
        }

        if let originalImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            contentImageView.image = originalImage
        }

        dismiss(animated: true, completion: nil)
    }
    
    @available(iOS 14, *)
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        picker.dismiss(animated: true)
        
        let itemProviders = results.map(\.itemProvider)
        
        if let itemProvider = itemProviders.first, itemProvider.canLoadObject(ofClass: UIImage.self) {
            
            let previousImage = contentImageView.image
            itemProvider.loadObject(ofClass: UIImage.self) {[weak self] (image, error) in
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
