//
//  DiscoverRecipeViewController.swift
//  Recipea
//
//  Created by James  Farrell on 22/03/2021.
//  Copyright © 2021 James  Farrell. All rights reserved.
//

import UIKit
import CoreData

class DiscoverRecipeViewController: UIViewController, UIScrollViewDelegate {
    var recipeID: String?
    var recipe: RecipeModelData?
    var recipeManager = RecipeManager()
    
    // db context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var recipeName: UILabel!
    @IBOutlet weak var recipeIngredients: UILabel!
    @IBOutlet weak var recipeInstructions: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager
        .default
        .urls(for: .applicationSupportDirectory, in: .userDomainMask)
        .last?
        .absoluteString
        .replacingOccurrences(of: "file://", with: "")
        .removingPercentEncoding)
    
        recipeManager.delegate = self
        recipeManager.getMealById(with: recipeID!)
    }
}

//MARK: - Update UI View Methods

extension DiscoverRecipeViewController {
    func updateIngredientsLabel() {
        let sortedIngredients = recipe!.ingridients.sorted(by: <)
        let sortedMeasurements = recipe!.measures.sorted(by: <)
        
        for i in sortedIngredients {
            recipeIngredients.text = recipeIngredients.text! + "- \(sortedMeasurements[i.key - 1].value): \(i.value)\n"
        }
    }
}

extension DiscoverRecipeViewController: RecipeManagerDelegate {
    func didUpdateWithData<T>(_ data: T) {
        DispatchQueue.main.async {
            let recipeObj = data as! RecipeModelData
            self.recipe = recipeObj
            self.recipeName.text = recipeObj.name
            self.recipeInstructions.text = recipeObj.instructions
            self.updateIngredientsLabel()
        }
    }
    
    func didFailWithError(error: Error) {
        print("Failed with: \(error)")
    }
}

//MARK: - Database CRUD Methods

extension DiscoverRecipeViewController {
    func saveRecipe() {
        
        do {
            try context.save()
            print("Sved item")
        } catch {
            print("Error saving context: \(error)")
        }
    }
    
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        let selectedRecipe = RecipeDb(context: context)
        selectedRecipe.category = recipe?.category
        selectedRecipe.instructions = recipe?.instructions
        selectedRecipe.name = recipe?.name
        
        saveRecipe()
    }
}
