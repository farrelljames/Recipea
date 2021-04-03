//
//  Constants.swift
//  Recipea
//
//  Created by James  Farrell on 22/03/2021.
//  Copyright © 2021 James  Farrell. All rights reserved.
//

import Foundation

struct K {
    struct SegueId {
        static let discoverRecipeByCategory = "DiscoverByType"
        static let discoverRecipe = "DiscoverRecipe"
        static let myRecipeRecipeByCategory = "MyRecipesByType"
        static let myRecipeRecipe = "MyRecipiesRecipe"
    }
    
    struct CellIdentifiers {
        static let recipeCell = "RecipeCell"
        static let recipeCategoryCell = "RecipeCategoryCell"
        static let myRecipeCategoryCell = "MyRecipeCategoryCell"
        static let myRecipeRecipeCell = "MyRecipeRecipeCell"
        static let shoppingListCell = "ShoppingListCell"
    }
    
    struct CoreDataPropertyNames {
        static let addToShoppingList = "shoppingList"
    }
}
