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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recipeManager.delegate = self
        recipeManager.getMealCategories()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categories.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCategoryCell", for: indexPath)
        cell.textLabel?.text = categories[indexPath.row].strCategory

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: K.SegueId.discoverRecipeByCategory, sender: self)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}

extension DiscoverViewController: RecipeManagerDelegate {
    func didUpdateWithData<T>(_ categories: T) {
        DispatchQueue.main.async {
            let categoryObj = categories as! CategoriesModel
            self.categories = categoryObj.categories
            self.tableView.reloadData()
        }
    }
    
    func didFailWithError(error: Error) {
        print("Failed with: \(error)")
    }
}
