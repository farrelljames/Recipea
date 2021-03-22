//
//  ViewController.swift
//  Recipea
//
//  Created by James  Farrell on 22/03/2021.
//  Copyright © 2021 James  Farrell. All rights reserved.
//

import UIKit

class RecipeaViewController: UIViewController {
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var discoverImage: UIImageView!
    @IBOutlet weak var myRecipeImage: UIImageView!
    @IBOutlet weak var shoppingListImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Creates tiles from background image
        backgroundImage.image = UIImage(named: "Background.png")!.resizableImage(withCapInsets: .zero)
        
        discoverImage.makeCornersRound(byRadius: 20)
        myRecipeImage.makeCornersRound(byRadius: 20)
        shoppingListImage.makeCornersRound(byRadius: 20)
    }
}

extension UIImageView {
    func makeCornersRound(byRadius rad: CGFloat) {
        self.layer.cornerRadius = rad
        self.clipsToBounds = true
    }
}

