//
//  AddGrowthCardViewController.swift
//  vini
//
//  Created by Yi-Chin Hsu on 2021/10/18.
//

import UIKit

class AddGrowthCardViewController: UIViewController {
    
    weak var growthPage: GrowthPageViewController?
    
    @IBOutlet weak var cardTitleTextField: UITextField! {
        didSet {
            cardTitleTextField.delegate = self
            cardTitleTextField.accessibilityLabel = "title"
        }
    }
    @IBOutlet weak var emojiTextField: UITextField! {
        didSet {
            emojiTextField.delegate = self
            emojiTextField.accessibilityLabel = "emoji"
        }
    }
    @IBOutlet weak var addGrowthCardButton: UIButton!
    
    var growthCard: GrowthCard = GrowthCard(
        id: "",
        title: "",
        emoji: "",
        isStarred: false,
        isArchived: false,
        archivedTime: nil,
        contents: nil,
        conclusion: nil,
        createdTime: nil
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func tapAddGrowthCardButton(_ sender: Any) {
        
        textFieldDidEndEditing(cardTitleTextField)
        textFieldDidEndEditing(emojiTextField)
        
        GrowthCardProvider.shared.addData(growthCard: &growthCard) { result in
            switch result {
            case .success(let message):
                print(message)
            case .failure(let error):
                print(error)
            }
        }
        
        growthPage?.fetchGrowthCards()
        dismiss(animated: true, completion: nil)
    }
    
}

extension AddGrowthCardViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {

        guard let text = textField.text,
              !text.isEmpty else {
            print("empty input")
            return
        }

        switch textField.accessibilityLabel {
        case "title":
            growthCard.title = text
        case "emoji":
            growthCard.emoji = text
        default:
            break
        }
    }
}
