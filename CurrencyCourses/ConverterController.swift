//
//  ConverterController.swift
//  CurrencyCourses
//
//  Created by hryst on 7/23/19.
//  Copyright © 2019 Anton Mikliayev. All rights reserved.
//

import UIKit

class ConverterController: UIViewController , UITextFieldDelegate {

    @IBOutlet weak var labelCoursesForDate: UILabel!
    
    @IBOutlet weak var buttonFrom: UIButton!
    @IBOutlet weak var buttonTo: UIButton!
    
    @IBOutlet weak var textFrom: UITextField!
    @IBOutlet weak var textTo: UITextField!

    @IBOutlet weak var buttonDone: UIBarButtonItem!
    
    
 
    @IBAction func pushButtonDone(_ sender: Any) {
        textFrom.resignFirstResponder()
        navigationItem.rightBarButtonItem = nil
        
    }
    
    @IBAction func pushFromAction(_ sender: Any) {
       let nc = storyboard?.instantiateViewController(withIdentifier: "selectedCurrencyNSID") as! UINavigationController
       (nc.viewControllers[0] as! SelectCurrencyController).flagCurrency = .from
        present(nc, animated: true, completion: nil)
        
    }
    
    @IBAction func pushToAction(_ sender: Any) {
        let nc = storyboard?.instantiateViewController(withIdentifier: "selectedCurrencyNSID") as! UINavigationController
        (nc.viewControllers[0] as! SelectCurrencyController).flagCurrency = .to
        present(nc, animated: true, completion: nil)
    }
    
  
    @IBAction func textFromEditingChange(_ sender: Any) {
        let amount = Double(textFrom.text!)
        if amount != nil {
           textTo.text = Model.shared.convert(amount: amount)
        }
        
       
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
          textFrom.delegate = self
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        refreshButtons()
        textFromEditingChange(self)
        labelCoursesForDate.text = "Курсы на дату: \(Model.shared.currentDate)"
        
        navigationItem.rightBarButtonItem = nil
        
    }
    
    
    func refreshButtons() {
        
        buttonFrom.setTitle(Model.shared.fromCurrency.CharCode, for: UIControl.State.normal)
        
        buttonTo.setTitle(Model.shared.toCurrency.CharCode, for: UIControl.State.normal)
        
       
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
                navigationItem.rightBarButtonItem = buttonDone
        
    return true
   }

 }
//
//extension ConverterController: UITextFieldDelegate {
//    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//        navigationItem.rightBarButtonItem = buttonDone
//
//        return true
//    }
//}
//
