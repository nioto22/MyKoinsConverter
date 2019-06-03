//
//  SelectCurrencyViewController.swift
//  MyKoinsConverter
//
//  Created by Antoine Proux on 28/05/2019.
//  Copyright © 2019 Antoine Proux. All rights reserved.
//

import UIKit

class SelectCurrencyViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    

    let flagCollectionCellIdentifier = "FlagCollectionViewCell"
    let countryTableViewCellIdentifier =  "CountryTableViewCellIdentifier"

    let countriesListURL = URL(string: "https://openexchangerates.org/api/currencies.json?app_id=cd0eb7d8486b4d988c59c976b526197c")!
    var allCountryList: [String] = []
    var allCountryIsoCode: [String] = []
    var refCurrency: String!
    var currenciesChoosen: [String] = []
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var flagsCollectionView: UICollectionView!
    @IBOutlet weak var countryListTableView: UITableView!
    @IBOutlet weak var refCurrencyFlagView: UIImageView!
    @IBOutlet weak var validateAndCloseButton: UIBarButtonItem!
    
    // USER DEFAULTS VAR
    let defaults = UserDefaults.standard
    let currenciesChoosenKey = "currenciesChoosenKey"
    
    // SEARCH BAR VAR
    //let searchController = UISearchController(searchResultsController: nil)
    var filteredCurrenciesList = [String]()
    var filteredIsoCodeList = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Setup the Search Controller
//        searchController.searchResultsUpdater = self
//        searchController.obscuresBackgroundDuringPresentation = false
//        searchController.searchBar.placeholder = "Search Currency"
//        searchController.searchBar.delegate = self
//        definesPresentationContext = true
        
        // TextField Color Customization
        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = UIColor.white
        
        configureRefFlagImageView()
        
        getCountryListHttpFecth()
        
        // CollectionView
        flagsCollectionView.dataSource = self
        flagsCollectionView.delegate = self
        
        // TableView
        countryListTableView.dataSource = self
        countryListTableView.delegate = self
        
        // SEARCH BAR
//        searchController.searchResultsUpdater = self
//        self.definesPresentationContext = true
        // Place the search bar in the navigation item's title view.
        //searchBar = searchController.searchBar
//        self.navigationItem.titleView = searchController.searchBar
//        searchController.hidesNavigationBarDuringPresentation = false
//        searchController.dimsBackgroundDuringPresentation = false
//        searchController.searchBar.sizeToFit()
//        searchController.searchBar.placeholder = "Search a Currency"
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    // MARK: - View Methods
    
    func configureRefFlagImageView(){
        if (UIImage(named: refCurrency) != nil) {
            refCurrencyFlagView.image = UIImage(named: refCurrency)
        }else {
            refCurrencyFlagView.image = UIImage(named: "NAFLAG")
        }
    }
    
    func removeCurrencyToFavorites(indexPath: IndexPath){
        // remove the currency in the model.
        if currenciesChoosen.count > 1 {
        currenciesChoosen.remove(at: indexPath.row)
        // fancy animation to delete the row
        flagsCollectionView.reloadData()
        countryListTableView.reloadData()
        
        pushUserDefaultsParameters()
        } else {
          showToast(controller: self, message: "You can't deselect all items of your list !", seconds: 2)
        }
    }
    
    func pushUserDefaultsParameters(){
        defaults.set(currenciesChoosen, forKey: currenciesChoosenKey)
    }
    
    func showToast(controller: UIViewController, message: String, seconds: Double){
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .actionSheet)
        
        controller.present(alert, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds){
            alert.dismiss(animated: true)
        }
    }
    
    func updateCurrenciesChoosen(isAddingAction: Bool, indexPath: IndexPath){
        if isSearchActivated() {
            if isAddingAction {
                currenciesChoosen.append(filteredIsoCodeList[indexPath.row])
            } else {
                currenciesChoosen.removeAll{ $0 == filteredIsoCodeList[indexPath.row]}
            }
        } else {
            if isAddingAction {
                currenciesChoosen.append(allCountryIsoCode[indexPath.row])
            } else {
                currenciesChoosen.removeAll{ $0 == allCountryIsoCode[indexPath.row]}
            }
        }
        pushUserDefaultsParameters()
        flagsCollectionView.reloadData()
        countryListTableView.reloadData()
    }
    
    // MARK: - UISearchController
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchBar.text?.isEmpty ?? true
    }
    
    func filterContent(for searchText: String) {
        // Update the searchResults array with matches
        // in our entries based on the title value.
        if let searchText = searchBar.text, !searchText.isEmpty {
            filteredCurrenciesList = allCountryList.filter{
                country in
                return (country.lowercased().contains(searchText.lowercased()))
            }
        }
        for string in filteredCurrenciesList {
            filteredIsoCodeList.append(String(string.prefix(3)))
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        if let searchText = searchBar.text {
            filterContent(for: searchText)
            // Reload the table view with the search result data.
            countryListTableView.reloadData()
        }
    }
    
//    func searchBar(_searchBar: UIS(for searchController: UISearchController) {
//        if let searchText = searchController.searchBar.text {
//            filterContent(for: searchText)
//            // Reload the table view with the search result data.
//            countryListTableView.reloadData()
//        }
//    }
    
    func isSearchActivated() -> Bool {
        return !searchBarIsEmpty()
    }
    
    
    // MARK: - CollectionView Methods
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currenciesChoosen.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.flagsCollectionView.dequeueReusableCell(withReuseIdentifier: flagCollectionCellIdentifier, for: indexPath) as! FlagCollectionViewCell
        if (UIImage(named: currenciesChoosen[indexPath.row]) != nil) {
            cell.flagImageView.image = UIImage(named: currenciesChoosen[indexPath.row])
        }else {
            cell.flagImageView.image = UIImage(named: "NAFLAG")
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        removeCurrencyToFavorites(indexPath: indexPath)
    }
    
    // MARK: - TableView Methods
    // Mark: TableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearchActivated() ? filteredCurrenciesList.count : allCountryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.countryListTableView.dequeueReusableCell(withIdentifier: countryTableViewCellIdentifier) as! CountryListTableViewCell
        
        if isSearchActivated() {
            print(filteredIsoCodeList[indexPath.row])
            cell.countryNameLabel.text = filteredCurrenciesList[indexPath.row]
            if (currenciesChoosen.contains(filteredIsoCodeList[indexPath.row])){
                cell.countryCheckBoxImageView.image = UIImage(named: "boxChecked")
            } else {
                cell.countryCheckBoxImageView.image = UIImage(named: "boxUnchecked")
            }
            
            if (UIImage(named: filteredIsoCodeList[indexPath.row]) != nil){
                cell.countryFlagImageView.image = UIImage(named: filteredIsoCodeList[indexPath.row])
            } else {
                cell.countryFlagImageView.image = UIImage(named: "NAFLAG")
            }
        } else {
            cell.countryNameLabel.text = allCountryList[indexPath.row]
            if (currenciesChoosen.contains(allCountryIsoCode[indexPath.row])){
                cell.countryCheckBoxImageView.image = UIImage(named: "boxChecked")
                } else {
                cell.countryCheckBoxImageView.image = UIImage(named: "boxUnchecked")
                }
            
            if (UIImage(named: allCountryIsoCode[indexPath.row]) != nil){
                cell.countryFlagImageView.image = UIImage(named: allCountryIsoCode[indexPath.row])
            } else {
                cell.countryFlagImageView.image = UIImage(named: "NAFLAG")
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    // Mark: TableView Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isSearchActivated() {
            if (currenciesChoosen.contains(filteredIsoCodeList[indexPath.row])){
                updateCurrenciesChoosen(isAddingAction: false, indexPath: indexPath)
            } else {
                updateCurrenciesChoosen(isAddingAction: true, indexPath: indexPath)
            }
        } else {
            if (currenciesChoosen.contains(allCountryIsoCode[indexPath.row])){
                updateCurrenciesChoosen(isAddingAction: false, indexPath: indexPath)
            } else {
                updateCurrenciesChoosen(isAddingAction: true, indexPath: indexPath)
            }
        }
    }

    // MARK: - HTTP Fetch
    func getCountryListHttpFecth(){
        let session = URLSession.shared
        let getCountriesList = session.dataTask(with: countriesListURL){
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
                let countriesData = try JSONDecoder().decode(Dictionary<String, String>.self, from: data)
                DispatchQueue.main.async {
                    for (isoCode, countryName) in countriesData {
                        let formatedName = isoCode + ": " + countryName
                        self.allCountryList.append(formatedName)
                        self.allCountryIsoCode.append(isoCode)
                    }
                    self.allCountryIsoCode.sort()
                    self.allCountryList.sort()
                    self.countryListTableView.reloadData()
                }
            } catch let jsonError {
                print("error here")
                print(jsonError)
            }
        }
        getCountriesList.resume()
        
    }
    
    
    // MARK: - Navigation

    @IBAction func validateAndCloseButtonClicked(_ sender: Any) {
        performSegue(withIdentifier: "selectCurrencyToViewControllerSegue", sender: self)
    }
    
    
}


