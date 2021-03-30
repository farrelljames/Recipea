//
//  DiscoverRecipeViewController.swift
//  Recipea
//
//  Created by James  Farrell on 22/03/2021.
//  Copyright © 2021 James  Farrell. All rights reserved.
//

import UIKit
import CoreData

class DiscoverRecipeViewController: UIViewController {
    var recipeID: String?
    var recipe: RecipeModelData?
    var recipeManager = RecipeManager()
    var categoryObj: Category?
    var categoryResult: CategoryDb?
    var recipeResult: RecipeDb?
    
    // db context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var recipeName: UILabel!
    @IBOutlet weak var recipeIngredients: UILabel!
    @IBOutlet weak var recipeInstructions: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recipeManager.delegate = self
        recipeManager.getMealById(with: recipeID!)
    }
}

//MARK: - Update UI View Methods

extension DiscoverRecipeViewController {
    func updateUI() {
        let sortedIngredients = recipe!.ingridients.sorted(by: <)
        let sortedMeasurements = recipe!.measures.sorted(by: <)
        
        // Update ingredient and measurements label in the style
        // of a dashed list
        for i in sortedIngredients {
            recipeIngredients.text = recipeIngredients.text! + "- \(sortedMeasurements[i.key - 1].value): \(i.value)\n"
        }
        
        // Unwrapped recipe object and update both the recipe
        // name and instructions labels
        recipeName.text = recipe!.name
        recipeInstructions.text = recipe!.instructions
    }
}

extension DiscoverRecipeViewController: RecipeManagerDelegate {
    func didUpdateWithData<T>(_ data: T) {
        DispatchQueue.main.async {
            self.recipe = data as? RecipeModelData
            self.updateUI()
        }
    }
    
    func didFailWithError(error: Error) {
        print("Failed with: \(error)")
    }
}

//MARK: - Database CRUD Methods

extension DiscoverRecipeViewController {
    func saveChanges() {
        do {
            try context.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        getCategoryDBObject()
        getRecipeDbObject()
        
        if categoryResult == nil {
            let category = CategoryDb(context: context)
            category.name = categoryObj?.strCategory
            saveChanges()
            getCategoryDBObject()
        } else {
            print("Already exists: \(categoryResult!.name)")
        }
        
        if recipeResult == nil {
            let selectedRecipe = RecipeDb(context: context)
            selectedRecipe.instructions = recipe!.instructions
            selectedRecipe.name = recipe!.name
            selectedRecipe.recipeId = recipe!.recipeId
            selectedRecipe.parentCategory = categoryResult
            saveChanges()
            getRecipeDbObject()
            
            for i in recipe!.measures.sorted(by: <) {
                let measures = MeasuresDb(context: context)
                measures.measure = i.value
                measures.parentRecipe = recipeResult
                saveChanges()
            }
            
            for i in recipe!.ingridients.sorted(by: <) {
                let ingredients = IngredientsDb(context: context)
                ingredients.name = i.value
                ingredients.parentRecipe = recipeResult
                saveChanges()
            }
        } else {
            print("Already exists: \(recipeResult!.name)")
        }
    }
    
    func getRecipeDbObject() {
        let request: NSFetchRequest<RecipeDb> = RecipeDb.fetchRequest()
        let recipePredicate = NSPredicate(format: "recipeId == %i", recipe!.recipeId)
        
        request.predicate = recipePredicate
        
        do {
            recipeResult = try context.fetch(request).first
        } catch {
            print("Error fetching data from context: \(error)")
        }
    }
    
    func getCategoryDBObject() {
        let request: NSFetchRequest<CategoryDb> = CategoryDb.fetchRequest()
        let categoryPredicate = NSPredicate(format: "name MATCHES %@", categoryObj!.strCategory)
        
        request.predicate = categoryPredicate
        
        do {
            categoryResult = try context.fetch(request).first
        } catch {
            print("Error fetching data from context: \(error)")
        }
    }
}
