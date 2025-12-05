//
//  RecipieDetailController.swift
//  Final_RecipeLab_Team16
//
//  Created by 王敬捷 on 11/16/25.
//

import UIKit

class RecipieDetailPageController: BaseViewController {

    var recipe: Recipe?

    private let rootView = RecipieDetailPageView()

    convenience init(recipe: Recipe) {
        self.init()
        self.recipe = recipe
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setContent(rootView)
        if let recipe = recipe {
            rootView.configure(with: recipe)
        }
    }
}
