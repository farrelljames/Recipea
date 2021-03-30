//
//  DiscoverCategoryViewController.swift
//  Recipea
//
//  Created by James  Farrell on 22/03/2021.
//  Copyright © 2021 James  Farrell. All rights reserved.
//

import UIKit

class DiscoverCategoryViewController: UITableViewController {
    var category: Category?
    var recipeList: [RecipeDetails] = []
    var recipeManager = RecipeManager()
    var selectedRecipe: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = category?.strCategory
        
        recipeManager.delegate = self
        recipeManager.getMealByCategory(with: category!.strCategory)
        
        tableView.register(UINib(nibName: K.CellIdentifiers.recipeCell, bundle: nil), forCellReuseIdentifier: K.CellIdentifiers.recipeCell)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return recipeList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath) as! RecipeCell
        
        cell.recipeLabel.text = recipeList[indexPath.row].strMeal
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRecipe = recipeList[indexPath.row].idMeal
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: K.SegueId.discoverRecipe, sender: self)
    }
}

extension DiscoverCategoryViewController: RecipeManagerDelegate {
    func didUpdateWithData<T>(_ data: T) {
        DispatchQueue.main.async {
            let recipeListObj = data as! RecipeListModel
            self.recipeList = recipeListObj.meals
            self.tableView.reloadData()
        }
    }
    
    func didFailWithError(error: Error) {
        print("Failed with error: \(error)")
    }
}

// MARK: - Navigation

extension DiscoverCategoryViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.SegueId.discoverRecipe {
            if let vc = segue.destination as? DiscoverRecipeViewController {
                vc.recipeID = selectedRecipe
                vc.categoryObj = category
            }
        }
    }
}
