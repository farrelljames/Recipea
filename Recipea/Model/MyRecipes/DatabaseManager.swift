//
//  DatabaseManager.swift
//  Recipea
//
//  Created by James  Farrell on 01/04/2021.
//  Copyright © 2021 James  Farrell. All rights reserved.
//

import Foundation
import CoreData
import UIKit

struct DatabaseManager {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func loadCategories() -> [CategoryDb]? {
        var categoryList: [CategoryDb]?
        
        let request: NSFetchRequest<CategoryDb> = CategoryDb.fetchRequest()
        
        do {
            categoryList = try context.fetch(request)
        } catch {
            print("Error fetching data from context: \(error)")
        }
    
        return categoryList
    }
}
