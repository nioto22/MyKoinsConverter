//
//  ViewController.swift
//  MyKoinsConverter
//
//  Created by Antoine Proux on 26/05/2019.
//  Copyright © 2019 Antoine Proux. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    

    // MARK: - Outlets
    @IBOutlet weak var currencyTableView: UITableView!
    
    @IBOutlet weak var currencyRefIcon: UIImageView!
    @IBOutlet weak var currencyRefNameLabel: UILabel!
    @IBOutlet weak var currencyRefInputLabel: UILabel!
    
    @IBOutlet weak var navigationBar: UINavigationItem!
    
    // MARK: - Variables
    var currentInputValue: String!
    var refCurrency: String!
    var selectedCurrency: String!
    var selectedRate: Double!
    var currenciesChoosen: [String]!
    //var currenciesResults: [String] = ["£0,882","€0,97", "R$4,523","$1,503", "£F2.356"]
    var ratesUSDList: Rates!
    var allCurrenciesList: [String] = []
    var allCurrenciesRates: [Double] = []
    
    var tableSelectedCurrency: String!
    var tableSelectedRate: Double!
    
    let ratesListUSDBaseURL = "https://openexchangerates.org/api/latest.json?app_id=cd0eb7d8486b4d988c59c976b526197c"
    let currencyCellIdentifier = "CurrencyCellIdentifier"
    let cellSpacingHeight: CGFloat = 0
    
    
    // USER DEFAULTS VAR
    let defaults = UserDefaults.standard
    let currentInputValueKey = "currentInputValueKey"
    let refCurrencyKey = "refCurrencyKey"
    let currenciesChoosenKey = "currenciesChoosenKey"
    var getFromInputValueDatas: Bool = false
    

    // DESIGN Var
    
    // MARK: - View Life Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.alpha = 1.0
        
        if getFromInputValueDatas {
            defaults.set(currentInputValue, forKey: currentInputValueKey)
            defaults.set(refCurrency, forKey: refCurrencyKey)
            getFromInputValueDatas = false
        }
        getUserDefaultsParameters()

        currencyTableView.dataSource = self
        currencyTableView.delegate = self
        
        let title = UILabel()
        title.text = "Currency Converter"
        title.textColor = UIColor.white
        title.textAlignment = .left
        let leftTitle = UIBarButtonItem(customView: title)
        self.navigationBar.leftBarButtonItem = leftTitle
        
        navigationController?.setNavigationBarHidden(false, animated: true)
        

        
        refreshRefView()
        performHTTPRequest()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    
    
    // MARK: - TableView Methods
    // MARK: TableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currenciesChoosen.count
    }
    
    // Set the spacing between sections
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return cellSpacingHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.currencyTableView.dequeueReusableCell(withIdentifier: currencyCellIdentifier) as! CurrencyTableViewCell
        
        cell.currencyNameLabel.text = currenciesChoosen[indexPath.row]
        
        if allCurrenciesList.count != 0 {
            let indexOfCurrency = getIndexOfCurrency(countryCode: currenciesChoosen[indexPath.row])
            if indexOfCurrency != nil {
                let rateValue = Double(allCurrenciesRates[indexOfCurrency!]) * Double(currentInputValue)!
                cell.convertValueLabel.text = String(format:"%.2f", rateValue)

                let rateValueLabelString = "1" + refCurrency + " = "
                    + String(format: "%.2f", allCurrenciesRates[indexOfCurrency!])
                    + " " + currenciesChoosen[indexPath.row]
                cell.rateValueLabel.text = rateValueLabelString
            }
        }
        if (UIImage(named: currenciesChoosen[indexPath.row]) != nil) {
            cell.flagIconImageView.image = UIImage(named: currenciesChoosen[indexPath.row])
        }else {
            cell.flagIconImageView.image = UIImage(named: "NAFLAG")
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    // MARK: TableView Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switchCurrencyWithRef(indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // Delete Action
        let deleteAction = UIContextualAction(style: .normal, title: "Remove", handler: { (deleteAction, view, completionHandler) in
            self.removeCurrencyToFavorites(indexPath: indexPath)
            // "close" the swipe (1)
            self.currencyTableView.setEditing(false, animated: true)
            completionHandler(true)
        })
        deleteAction.image = UIImage(named: "deleteIcon")
        deleteAction.backgroundColor = UIColor.MyCoinsConverterDark.BackgroundBlue
        
        // Detail Action
        let detailAction = UIContextualAction(style: .normal, title: "Details", handler: { (detailAction, view, completionHandler) in
            
            self.toDetailCurrencyViewController(indexPath: indexPath)
            self.currencyTableView.setEditing(false, animated: true)
            completionHandler(true)
        })
        detailAction.image = UIImage(named: "detailsIcon")
        detailAction.backgroundColor = UIColor.MyCoinsConverterDark.BackgroundBlue
        
        // Conversion Action
        let conversionAction = UIContextualAction(style: .normal, title: "Conversion", handler: { (conversionAction, view, completionHandler) in
            
            self.toConversionGuideViewController(indexPath: indexPath)
            self.currencyTableView.setEditing(false, animated: true)
            completionHandler(true)
        })
        conversionAction.image = UIImage(named: "conversionIcon")
        conversionAction.backgroundColor = UIColor.MyCoinsConverterDark.BackgroundBlue
        
        // Blank Button
//        let closeAction = UIContextualAction(style: .normal, title: "", handler: { (closeAction, view, completionHandler) in
//            let st = String(format: "row %d convert",indexPath.row)
//            print(st)
//            self.currencyTableView.setEditing(false, animated: true)
//            completionHandler(true)
//        })
//        closeAction.image = UIImage(named: "cancelIcon")
//        closeAction.backgroundColor = UIColor.MyCoinsConverterDark.BackgroundBlue
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction, detailAction, conversionAction])  // , closeAction
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
    
    // MARK: - View Methods
    
    func getIndexOfCurrency(countryCode: String)-> Int? {
        guard let index = allCurrenciesList.firstIndex(of: countryCode) else {
           return nil
        }
        return index
    }
    
    func refreshRefView(){
        currencyRefNameLabel.text = refCurrency
        currencyRefInputLabel.text = currentInputValue
        if (UIImage(named: refCurrency) != nil) {
           currencyRefIcon.image = UIImage(named: refCurrency)
        }else {
            currencyRefIcon.image = UIImage(named: "NAFLAG")
        }
    }
    
    
    func pushUserDefaultsParameters(){
        defaults.set(currentInputValue, forKey: currentInputValueKey)
        defaults.set(currenciesChoosen, forKey: currenciesChoosenKey)
        defaults.set(refCurrency, forKey: refCurrencyKey)
    }
    
    func getUserDefaultsParameters(){
        currentInputValue = defaults.string(forKey: currentInputValueKey) ?? "1.0"
        refCurrency = defaults.string(forKey: refCurrencyKey) ?? "USD"
        currenciesChoosen = defaults.object(forKey: currenciesChoosenKey) as? [String] ?? ["EUR"]
    }
    
    // MARK: - HTTP Request
    
    func performHTTPRequest(){
        
        let session = URLSession.shared
        let urlTaskSt = ratesListUSDBaseURL    //+ "&base=" + refCurrency
        let urlTask = URL(string: urlTaskSt)!
        let getRatesBaseUSD = session.dataTask(with: urlTask){
            (data, response, error) in
            
            if error != nil {
                print("Error in http task")
                print(error as Any)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode)
                else {
                    print("http status code is not ok")
                    print(response as Any)
                    return
            }
            
            guard let data = data else {
                print("No data")
                return
            }
            do {
                let ratesData = try JSONDecoder().decode(Rates.self, from: data)
                DispatchQueue.main.async {
                    self.saveUSDRates(ratesUSD: ratesData)
                }
            } catch let jsonError {
                print("error here")
                print(jsonError)
            }
        }
        getRatesBaseUSD.resume()
    }


    func saveUSDRates(ratesUSD: Rates){
        ratesUSDList = ratesUSD
        allCurrenciesList = Array(ratesUSD.rates.keys)
        allCurrenciesRates = Array(ratesUSD.rates.values)
        // Add USD value
        allCurrenciesList.append("USD")
        allCurrenciesRates.append(1.000)
        
        if refCurrency != "USD"{
            let index = getIndexOfCurrency(countryCode: refCurrency)
            if index != nil {
                // Division of all factor by new ref rate
                let baseFactor = Double(allCurrenciesRates[index!])
                var allRatesInDouble: [Double] = []
                for rateString in allCurrenciesRates {
                    let double = rateString/baseFactor
                    let roundDouble = Double(round(1000*double)/1000)
                    allRatesInDouble.append(roundDouble)
                }
                allCurrenciesRates = allRatesInDouble
            }
        }
        currencyTableView.reloadData()
        showToast(controller: self, message: "Data updated !", seconds: 1)
    }
    
    func showToast(controller: UIViewController, message: String, seconds: Double){
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .actionSheet)
        //alert.view.backgroundColor = UIColor.MyCoinsConverterDark.BackgroundLight
        //alert.view.alpha = 0.8
        //alert.view.layer.cornerRadius = 15
        
        controller.present(alert, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds){
            alert.dismiss(animated: true)
        }
        
    }
    
    // MARK: - Actions
    
    func switchCurrencyWithRef(indexPath: IndexPath){
        print("switchCurrencyWithRef")
        let tempString = currenciesChoosen[indexPath.row]
        currenciesChoosen[indexPath.row] = refCurrency
        refCurrency = tempString
        let index = getIndexOfCurrency(countryCode: refCurrency)
        if index != nil {
            currentInputValue = String(format:"%.2f", (allCurrenciesRates[index!] * Double(currentInputValue)!))
        }
        pushUserDefaultsParameters()
        performHTTPRequest()
        refreshRefView()
    }
    
    func removeCurrencyToFavorites(indexPath: IndexPath){
        // remove the currency in the model.
        currenciesChoosen.remove(at: indexPath.row)
        // fancy animation to delete the row
        currencyTableView.beginUpdates()
        currencyTableView.deleteRows(at: [IndexPath(row: indexPath.row, section: 0)], with: .automatic)
        currencyTableView.endUpdates()
        
        pushUserDefaultsParameters()
    }
    
    @IBAction func refreshButtonAction(_ sender: Any) {
        performHTTPRequest()
    }
    
    @IBAction func editButtonAction(_ sender: Any) {
        performSegue(withIdentifier: "toSelectCurrencySegue", sender: self)
    }
    
    
    @IBAction func inputValueButtonClicked(_ sender: Any) {
        performSegue(withIdentifier: "inputValueVCSegue", sender: self)
    }
    
    
    
    // MARK: - Navigators
    
    @IBAction func referenceCurrencyClicked(_ sender: Any) {
       performSegue(withIdentifier: "toSelectCurrencySegue", sender: self)
    }
    
    func toDetailCurrencyViewController(indexPath: IndexPath) {
        selectedCurrency = currenciesChoosen[indexPath.row]
        let index = getIndexOfCurrency(countryCode: selectedCurrency)
        if index != nil {
            selectedRate = allCurrenciesRates[index!]
        }
        performSegue(withIdentifier: "toDetailCurencySegue", sender: self)
    }
    
    func toConversionGuideViewController(indexPath: IndexPath) {
        selectedCurrency = currenciesChoosen[indexPath.row]
        let index = getIndexOfCurrency(countryCode: selectedCurrency)
        if index != nil {
            selectedRate = allCurrenciesRates[index!]
        }
        performSegue(withIdentifier: "toConversionGuideSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier{
        case "toSelectCurrencySegue":
            if let selectCurrencyVC = segue.destination as? SelectCurrencyViewController{
                selectCurrencyVC.currenciesChoosen = currenciesChoosen
                selectCurrencyVC.refCurrency = refCurrency
            }
            break
        case "toDetailCurencySegue":
            if let detailVC = segue.destination as? DetailCurrencyViewController{
                detailVC.refCurrency = self.refCurrency
                detailVC.resultCurrency = self.selectedCurrency
                detailVC.currentRate = self.selectedRate
                detailVC.currentInputValue = self.currentInputValue
            }
            break
        case "toConversionGuideSegue":
            if let conversionVC = segue.destination as? ConversionCurrencyViewController{
                conversionVC.refCurrency = self.refCurrency
                conversionVC.resultCurrency = self.selectedCurrency
                conversionVC.currentRate = self.selectedRate
            }
            break
        case "inputValueVCSegue":
            let destinationNC = segue.destination as! UINavigationController
            if let inputValueVC = destinationNC.topViewController as? InputValueModalViewController {
                self.view.alpha = 0.45
                inputValueVC.sendInputValue = currentInputValue
                inputValueVC.refCurrency = refCurrency
                // TODO send symbol value
                //inputValueVC.currentSymbolValue = symbolOfRef
                inputValueVC.isNewInput = true
            }
            break
        default:
            break
        }
    }
    
    
    
}

