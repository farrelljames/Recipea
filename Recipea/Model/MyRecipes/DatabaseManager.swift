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
    // Get the Database context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func saveChanges() {
        do {
            try context.save()
        } catch {
            print("Error saving changes: \(error)")
        }
    }
}

//MARK: - Read Methods

extension DatabaseManager {
    func loadCategories(with predicate: NSPredicate? = nil) -> [CategoryDb]? {
        var categoryList: [CategoryDb]?
        let request: NSFetchRequest<CategoryDb> = CategoryDb.fetchRequest()
        
        if let categoryPredicate = predicate { request.predicate = categoryPredicate }
        
        do {
            categoryList = try context.fetch(request)
        } catch {
            print("Error fetching data from context: \(error)")
        }
    
        return categoryList
    }
    
    func loadRecipes(from category: String, with predicate: NSPredicate? = nil) -> [RecipeDb]? {
        var recipeList: [RecipeDb]?
        let request: NSFetchRequest<RecipeDb> = RecipeDb.fetchRequest()
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", category)
        var recipeCount = 0
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        
        do {
            recipeList = try context.fetch(request)
            recipeCount = recipeList!.count
        } catch {
            print("Error fetching data from context: \(error)")
        }
        
        return recipeCount > 0 ? recipeList : nil
    }
    
    func loadRecipe(from category: String, with recipeId: Int32) -> CompleteRecipe? {
        let predicate = NSPredicate(format: "recipeId == %i", recipeId)
        
        guard let recipe = loadRecipes(from: category, with: predicate)?.first, let measures = loadMeasures(with: recipeId), let ingredients = loadIngredients(with: recipeId) else {
            return nil
        }
        
        return CompleteRecipe(recipe: recipe, measures: measures, Ingredients: ingredients)
    }
    
    func loadMeasures(with recipeId: Int32) -> [MeasuresDb]? {
        var measuresList: [MeasuresDb]?
        let request: NSFetchRequest<MeasuresDb> = MeasuresDb.fetchRequest()
        request.predicate = NSPredicate(format: "parentRecipe.recipeId == %i", recipeId)
        
        do {
            measuresList = try context.fetch(request)
        } catch {
            print("Error fetching data from context: \(error)")
        }
        
        return measuresList
    }
    
    func loadIngredients(with recipeId: Int32) -> [IngredientsDb]? {
        var ingredientsList: [IngredientsDb]?
        let request: NSFetchRequest<IngredientsDb> = IngredientsDb.fetchRequest()
        request.predicate = NSPredicate(format: "parentRecipe.recipeId == %i", recipeId)
        
        do {
            ingredientsList = try context.fetch(request)
        } catch {
            print("Error fetching data from context: \(error)")
        }
        
        return ingredientsList
    }
}

//MARK: - Delete Methods

extension DatabaseManager {
    func deleteRecipe(from category: String, recipe: CompleteRecipe) {
        context.delete(recipe.recipe)
        deleteMeasures(measures: recipe.measures)
        deleteIngredients(ingredients: recipe.Ingredients)
        saveChanges()
        deleteCategory(categoryName: category)
    }
    
    func deleteCategory(categoryName: String) {
        let predicate = NSPredicate(format: "name MATCHES %@", categoryName)
        
        guard loadRecipes(from: categoryName) != nil else {
            if let category = loadCategories(with: predicate)?.first {
                context.delete(category)
                saveChanges()
            }
            return
        }
    }
    
    func deleteMeasures(measures: [MeasuresDb]) {
        for m in measures {
            context.delete(m)
        }
    }
    
    func deleteIngredients(ingredients: [IngredientsDb]) {
        for i in ingredients {
            context.delete(i)
        }
    }
}
