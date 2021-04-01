//
//  RecipeModelData.swift
//  Recipea
//
//  Created by James  Farrell on 27/03/2021.
//  Copyright © 2021 James  Farrell. All rights reserved.
//

import Foundation

// Convert struct properties into key value pairs so they can be interated through
extension Encodable {
    var dictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap{ $0 as? [String: Any] }
    }
}

// Return number from a string
extension String {
    var numbersOnly: String {
        let pattern = UnicodeScalar("0")..."9"
        return String(unicodeScalars.compactMap({ pattern ~= $0 ? Character($0) : nil }))
    }
}

struct RecipeModelData: Decodable {
    var ingridients: [Int: String]
    var measures: [Int: String]
    var name: String
    var instructions: String
    var category: String
    var recipeId: Int32
    
    init(recipeData: RecipeModel) {
        let data = recipeData.meals[0]
        let dataDict = data.dictionary
        var i: [Int: String] = [:]
        var m: [Int: String] = [:]
        
        // loop through struct properties and add key, value
        // to the correct dictionary
        for (key, value) in dataDict! {
            let k = key
            let v = value as? String
                        
            if k.contains("strIngredient") && !(v?.isEmpty ?? true) {
                i[Int(k.numbersOnly) ?? 0] = v!
            }
            else if k.contains("strMeasure") && !(v?.isEmpty ?? true) {
                m[Int(k.numbersOnly) ?? 0] = v!
            }
        }
        
        self.ingridients = i
        self.measures = m
        self.name = data.strMeal
        self.instructions = data.strInstructions
        self.category = data.strCategory
        self.recipeId = Int32(data.idMeal)!
    }
}
