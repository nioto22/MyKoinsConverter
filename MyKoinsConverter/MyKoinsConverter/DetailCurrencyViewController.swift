//
//  DetailCurrencyViewController.swift
//  MyKoinsConverter
//
//  Created by Antoine Proux on 28/05/2019.
//  Copyright © 2019 Antoine Proux. All rights reserved.
//

import UIKit

class DetailCurrencyViewController: UIViewController {
    
    var refCurrency: String!
    var currentRate: Double!
    var resultCurrency: String!
    var currentInputValue: String!
    
    
    @IBOutlet weak var refFlagImageView: UIImageView!
    @IBOutlet weak var refCurrentRate: UILabel!
    @IBOutlet weak var refNameLabel: UILabel!
    
    @IBOutlet weak var reultFlagImageView: UIImageView!
    @IBOutlet weak var resultCurrentRateLabel: UILabel!
    @IBOutlet weak var resultNameLabel: UILabel!
    
    @IBOutlet weak var switchButton: UIButton!
    
    @IBOutlet weak var inputViewRefValueLabel: UILabel!
    @IBOutlet weak var inputViewRefNameLabel: UILabel!
    @IBOutlet weak var inputViewResultValueLabel: UILabel!
    @IBOutlet weak var inputViewResultNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureViews()
    }
    
    func configureViews(){
        configureTopView()
        configureInputView()
    }
    func configureTopView(){
        if UIImage(named: refCurrency) != nil {
            refFlagImageView.image = UIImage(named: refCurrency)
        }
        if UIImage(named: resultCurrency) != nil {
            reultFlagImageView.image = UIImage(named: resultCurrency)
        }
        refNameLabel.text = refCurrency
        resultNameLabel.text = resultCurrency
        
        refCurrentRate.text = String(format: "%.2f", (1/currentRate)) + " " + resultCurrency
        resultCurrentRateLabel.text = String(format: "%.2f", currentRate) + " " + refCurrency
    }
    
    func configureInputView(){
        inputViewRefValueLabel.text = currentInputValue
        inputViewRefNameLabel.text = refCurrency
        let currentValueDouble = Double(currentInputValue)!
        let resultValue = currentValueDouble * currentRate
        let resultRound = Double(round(resultValue*1000/1000))
        inputViewResultValueLabel.text = String(resultRound)
        inputViewResultNameLabel.text = resultCurrency
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }

    
    @IBAction func switchButtonClicked(_ sender: Any) {
        let tempCurrency = refCurrency
        refCurrency = resultCurrency
        resultCurrency = tempCurrency
        let currentValueDouble = Double(currentInputValue)!
        let resultValue = currentValueDouble * currentRate
        let resultRound = Double(round(resultValue*1000/1000))
        currentInputValue = String(resultRound)
        currentRate = 1 / currentRate
        currentRate = Double(round(1000*currentRate)/1000)
        
        configureViews()
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
