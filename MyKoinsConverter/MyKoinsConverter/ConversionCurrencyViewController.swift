//
//  ConversionCurrencyViewController.swift
//  MyKoinsConverter
//
//  Created by Antoine Proux on 28/05/2019.
//  Copyright © 2019 Antoine Proux. All rights reserved.
//

import UIKit

class ConversionCurrencyViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  

    @IBOutlet weak var refCountryFlagImageView: UIImageView!
    @IBOutlet weak var refCountryCodeLabel: UILabel!
    @IBOutlet weak var resultCountryFlagImageView: UIImageView!
    @IBOutlet weak var resultCountryNameLabel: UILabel!
    @IBOutlet weak var switchButton: UIButton!
    
    @IBOutlet weak var conversionTableView: UITableView!
    
    //var refConversionList: [String] = []
    //var resultConversionList: [String] = []
    var refCurrency: String!
    var resultCurrency: String!
    var currentRate: Double!
    var refSymbol: String = ""
    var resultSymbol: String = ""
    
    let convercionTableViewCellIdentifier = "ConversionTableViewCellIdentifier"
    let conversionValuesList: [Int] = [1,2,5,10,20,50,100,200,500,1000,2000,5000]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateTopView()
        conversionTableView.dataSource = self
        conversionTableView.delegate = self
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }

    
    // MARK: - Actions
    
    @IBAction func switchButtonClicked(_ sender: Any) {
        let tempCurrency = refCurrency
        refCurrency = resultCurrency
        resultCurrency = tempCurrency
        currentRate = 1 / currentRate
        currentRate = Double(round(1000*currentRate)/1000)
        
        updateTopView()
        conversionTableView.reloadData()
    }
    
    func updateTopView(){
        // Ref
        if (UIImage(named: refCurrency) != nil) {
            self.refCountryFlagImageView.image = UIImage(named: refCurrency)
        } else {
           self.refCountryFlagImageView.image = UIImage(named: "EUR")
        }
        self.refCountryCodeLabel.text = refCurrency
        // Result
        if (UIImage(named: resultCurrency) != nil) {
            self.resultCountryFlagImageView.image = UIImage(named: resultCurrency)
        } else {
            self.resultCountryFlagImageView.image = UIImage(named: "EUR")
        }
        self.resultCountryNameLabel.text = resultCurrency
    }
    
    // MARK: - TableView Methods
    //Mark: DataSaource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversionValuesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = conversionTableView.dequeueReusableCell(withIdentifier: convercionTableViewCellIdentifier) as! ConversionTableViewCell
        cell.refConversionLabel.text = refSymbol + String(conversionValuesList[indexPath.row])
        let conversionResult = Double(conversionValuesList[indexPath.row])*currentRate
        let conversionResultString = conversionResult > 100 ? String(format: "%.2f", conversionResult) : String(format: "%.3f", conversionResult)
        cell.resultConversionLabel.text = resultSymbol + conversionResultString
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 32
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
