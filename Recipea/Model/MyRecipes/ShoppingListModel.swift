//
//  ShoppingListModel.swift
//  Recipea
//
//  Created by James  Farrell on 03/04/2021.
//  Copyright © 2021 James  Farrell. All rights reserved.
//

import Foundation

struct ShoppingListModel {
    var measures: [MeasuresDb]
    var ingredients: [IngredientsDb]
    var shoppingListStrings: [String] {
        var shoppingList: [String] = []
        
        for (m, i) in zip(measures, ingredients) {
            shoppingList.append("\(m.measure!): \(i.name!)")
        }
        
        return shoppingList
    }
    
    init(measures: [MeasuresDb], ingredients: [IngredientsDb]) {
        self.measures = measures.filter { $0.shoppingList == true }
        self.ingredients = ingredients.filter { $0.shoppingList == true }
    }
    
    mutating func removeItem(at index: Int) {
        measures.remove(at: index)
        ingredients.remove(at: index)
    }
}
