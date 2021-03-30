//
//  DiscoverViewController.swift
//  Recipea
//
//  Created by James  Farrell on 22/03/2021.
//  Copyright © 2021 James  Farrell. All rights reserved.
//

import UIKit

class DiscoverViewController: UITableViewController {
    var categories: [Category] = []
    var recipeManager = RecipeManager()
    var selectedCategory: Category?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        recipeManager.delegate = self
        recipeManager.getMealCategories()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCategoryCell", for: indexPath)
        cell.textLabel?.text = categories[indexPath.row].strCategory

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCategory = categories[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: K.SegueId.discoverRecipeByCategory, sender: self)
    }
}

// MARK: - Navigation

extension DiscoverViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.SegueId.discoverRecipeByCategory {
            if let vc = segue.destination as? DiscoverCategoryViewController {
                vc.category = selectedCategory
            }
        }
    }
}

//MARK: - RecipeManagerDelegate Methods

extension DiscoverViewController: RecipeManagerDelegate {
    func didUpdateWithData<T>(_ data: T) {
        DispatchQueue.main.async {
            let categoryObj = data as! CategoriesModel
            self.categories = categoryObj.categories
            self.tableView.reloadData()
        }
    }
    
    func didFailWithError(error: Error) {
        print("Failed with: \(error)")
    }
}
