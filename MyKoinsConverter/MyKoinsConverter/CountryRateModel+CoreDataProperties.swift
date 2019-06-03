//
//  CountryRateModel+CoreDataProperties.swift
//  MyKoinsConverter
//
//  Created by Antoine Proux on 29/05/2019.
//  Copyright © 2019 Antoine Proux. All rights reserved.
//
//

import Foundation
import CoreData


extension CountryRateModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CountryRateModel> {
        return NSFetchRequest<CountryRateModel>(entityName: "CountryRateModel")
    }

    @NSManaged public var countryId: String?
    @NSManaged public var countryLongName: String?
    @NSManaged public var date: String?
    @NSManaged public var ratesArray: NSObject?

}
