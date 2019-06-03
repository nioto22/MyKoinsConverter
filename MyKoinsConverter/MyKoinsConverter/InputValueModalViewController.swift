//
//  InputValueModalViewController.swift
//  MyKoinsConverter
//
//  Created by Antoine Proux on 30/05/2019.
//  Copyright © 2019 Antoine Proux. All rights reserved.
//

import UIKit
import Foundation

class InputValueModalViewController: UIViewController {

    
    @IBOutlet weak var inputValueLabel: RoundedUILabel!
    
    let segueIdentifier = "returnToVCSegue"
    
    var sendInputValue: String!
    var currentInputValue: String!
    var currentSymbolValue: String = ""
    var refCurrency: String!
    
    var isNewInput: Bool!
    var isAValueSend: Bool!
    var isMathToDo: Bool! = false
    var parenthesesLevel: Int = 0
    
    // USER DEFAULTS VAR
    let defaults = UserDefaults.standard
    let currentInputValueKey = "currentInputValueKey"

    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentInputValue = sendInputValue
        updateInputLabel()
        
    }
    
    func updateInputLabel(){
        //inputValueLabel.text = currentSymbolValue + currentInputValue
        inputValueLabel.text = currentInputValue
    }
    // MARK: - Buttons Actions
    
    
    @IBAction func validateButtonClicked(_ sender: Any) {
        isAValueSend = true
        performSegue(withIdentifier: segueIdentifier, sender: self)
    }
    
    @IBAction func cancelButtonClicked(_ sender: Any) {
        isAValueSend = false
        performSegue(withIdentifier: segueIdentifier, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationNC = segue.destination as! UINavigationController
       if let parentVC = destinationNC.topViewController as? ViewController{
        parentVC.getFromInputValueDatas = true
        parentVC.refCurrency = refCurrency
            if !isAValueSend {
                    parentVC.currentInputValue = sendInputValue
                } else if !isMathToDo {
                    parentVC.currentInputValue = currentInputValue
            } else {
                let expn = NSExpression(format:currentInputValue)
                if let result = expn.expressionValue(with: nil, context: nil) as? Double {
//                    let x = result.doubleValue
                    parentVC.currentInputValue = String(format: "%.2f", result)
                } else {
                    print("error")
                    parentVC.currentInputValue = sendInputValue
                }
            }
                }
    }
    
    @IBAction func backButtonClicked(_ sender: Any) {
        if isNewInput {
            currentInputValue = ""
            isNewInput = false
            updateInputLabel()
        } else {
            currentInputValue.removeLast()
            updateInputLabel()
        }
    }
    
    func updateInputValue(number: String){
        if isNewInput {
            currentInputValue = number
            isNewInput = false
            updateInputLabel()
        } else {
            currentInputValue += number
            updateInputLabel()
        }
    }
    
    
    @IBAction func zeroButtonClicked(_ sender: Any) {
        updateInputValue(number: "0")
    }
    @IBAction func dotButtonClicked(_ sender: Any) {
        updateInputValue(number: ".")
    }
    @IBAction func oneButtonClicked(_ sender: Any) {
        updateInputValue(number: "1")
    }
    @IBAction func twoButtonClicked(_ sender: Any) {
        updateInputValue(number: "2")
    }
    @IBAction func threeButtonClicked(_ sender: Any) {
        updateInputValue(number: "3")
    }
    @IBAction func fourButtonClicked(_ sender: Any) {
        updateInputValue(number: "4")
    }
    @IBAction func fiveButtonClicked(_ sender: Any) {
        updateInputValue(number: "5")
    }
    
    @IBAction func sixButtonClicked(_ sender: Any) {
        updateInputValue(number: "6")
    }
    
    @IBAction func sevenButtonClicked(_ sender: Any) {
        updateInputValue(number: "7")
    }
    
    @IBAction func heightButtonClicked(_ sender: Any) {
        updateInputValue(number: "8")
    }
    
    @IBAction func nineButtonClicked(_ sender: Any) {
        updateInputValue(number: "9")
    }
    
    @IBAction func plusButtonClicked(_ sender: Any) {
        updateInputValue(number: "+")
        isMathToDo = true
    }
    
    @IBAction func minusButtonClicked(_ sender: Any) {
        updateInputValue(number: "-")
        isMathToDo = true
    }
    
    @IBAction func multipleButtonClicked(_ sender: Any) {
        updateInputValue(number: "*")
        isMathToDo = true
    }
    
    @IBAction func parenthesesButtonClicked(_ sender: Any) {
        if (parenthesesLevel % 2 == 0) {
            updateInputValue(number: "(")
        } else {
            updateInputValue(number: ")")
        }
        parenthesesLevel += 1
        isMathToDo = true
    }
    
    @IBAction func divisionButtonClicked(_ sender: Any) {
        updateInputValue(number: "/")
        isMathToDo = true
    }

    
}
