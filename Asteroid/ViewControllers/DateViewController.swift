//
//  DateViewController.swift
//  Asteroid
//
//  Created by Sreeni E V on 06/09/22.
//

import UIKit

class DateViewController: UIViewController {
    
    @IBOutlet weak var startDateField: UITextField!
    @IBOutlet weak var endDateField: UITextField!
    
    let datePicker = UIDatePicker()
    let formatter = DateFormatter()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        formatter.dateFormat = "yyyy-MM-dd"
        showDatePicker()
        view.backgroundColor = UIColor(patternImage: UIImage(named: "space.png")!)
        
        //for testing
        startDateField.text="2022-09-01"
        endDateField.text="2022-09-05"
    }
    @IBAction func submitTapped(_ sender: Any) {
        
        if let startdate = startDateField.text?.trimmingCharacters(in: .whitespaces), let enddate = endDateField.text?.trimmingCharacters(in: .whitespaces) {
            
            if startdate == "" || enddate == "" { return }
            
            let startDate = formatter.date(from: startdate) ?? Date()
            let endDate = formatter.date(from: enddate) ?? Date()
            
            if endDate <= startDate {
                endDateField.text = nil
                let alert = UIAlertController(title: "Oops!", message: "End date should be greater than start date", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                return present(alert, animated: true, completion: nil)
            }
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "NeoViewController") as! NeoViewController
            
            vc.startDate = startdate
            vc.endDate = enddate
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
    }
  
    
    
    func showDatePicker(){
        //Formate Date
        datePicker.datePickerMode = .date
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker_start));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        startDateField.inputAccessoryView = toolbar
        startDateField.inputView = datePicker
        
        let toolbar2 = UIToolbar();
        toolbar2.sizeToFit()
        let doneButton2 = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker_end));
        let spaceButton2 = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton2 = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        
        toolbar2.setItems([doneButton2,spaceButton2,cancelButton2], animated: false)
        
        endDateField.inputAccessoryView = toolbar2
        endDateField.inputView = datePicker
        
    }
    
    @objc func donedatePicker_start(){
        
        startDateField.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func donedatePicker_end(){
       
        endDateField.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
}
