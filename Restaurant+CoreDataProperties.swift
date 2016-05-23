//
//  Restaurant+CoreDataProperties.swift
//  Yelp
//
//  Created by Ashish Mishra on 5/22/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Restaurant {

    @NSManaged var name: String?
    @NSManaged var reviewcount: NSNumber?
    @NSManaged var address: String?
    @NSManaged var phone: String?
    @NSManaged var lat: String?
    @NSManaged var long: String?
    @NSManaged var snippet: String?
    @NSManaged var imageUrl: String?
    @NSManaged var ratingurl: String?

}
