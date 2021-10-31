//
//  TimePickerViewController.swift
//  vini
//
//  Created by Yi-Chin Hsu on 2021/10/31.
//

import UIKit

class TimePickerViewController: UIViewController {
    
    @IBOutlet weak var windowView: UIView!
    @IBOutlet weak var viniImageView: UIImageView!
    
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var pickerView: UIPickerView! {
        didSet {
            pickerView.delegate = self
            pickerView.dataSource = self
        }
    }
        
    var hourToUpdate: Int = 23
    
    var timeOptions = TimeOptions.allCases
    
    let userDefault = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.isModalInPresentation = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        windowView.layer.cornerRadius = 25
        confirmButton.setupCorner()
        cancelButton.setupCorner()
        viniImageView.float(duration: 0.8)
        getReflectionTime()
    }
    
    @IBAction func tapCancelButton(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tapSaveButton(_ sender: Any) {
        
        view.endEditing(true)
        
        updateReflectionTime()
    }

}

extension TimePickerViewController {
    
    func getReflectionTime() {
        
        if let userID = userDefault.value(forKey: "id") as? String {
            
            MailManager.shared.getReflectionTime(
                id: userID) { result in
                    switch result {
                        
                    case .success(let hour):
                        
                        let pickerSelectedIndex = self.timeOptions.map { $0.hour }.firstIndex(of: hour) ?? 0
                        self.pickerView.selectRow(pickerSelectedIndex, inComponent: 0, animated: true)
                        
                    case . failure(let error):
                        
                        print(error)
                    }
                }
        }
    }
    
    func updateReflectionTime() {
        
        if let userID = userDefault.value(forKey: "id") as? String {
            
            MailManager.shared.updateReflectionTime(
                userID: userID,
                time: hourToUpdate
            ) { result in
                
                switch result {
                    
                case .success(let success):
                    
                    print(success)
                    self.dismiss(animated: true, completion: nil)
                    
                case . failure(let error):
                    
                    print(error)
                }
            }
        }
    }
}

extension TimePickerViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        hourToUpdate = timeOptions[row].hour
    }
}

extension TimePickerViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        timeOptions.count
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        let attributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16),
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.kern: 3.0
        ]
        
        return NSAttributedString(string: timeOptions[row].toString, attributes: attributes)
    }
}
