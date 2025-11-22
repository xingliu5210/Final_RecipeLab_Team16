//
//  MainPageController.swift
//  Final_RecipeLab_Team16
//
//  Created by 王敬捷 on 11/16/25.
//

import UIKit

class MainPageController: UIViewController {

    private let mainView = MainPageView()

    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
    }

    private func setupData() {
        // Example data — replace with your actual model
        let recipes = [
            RecipeItem(userName: "Alice", timeAgo: "1 hr ago",
                       image: "pasta", title: "Creamy Pasta",
                       desc: "A rich and creamy pasta.", likes: 137, cookTime: "15 min"),

            RecipeItem(userName: "James", timeAgo: "1 hr ago",
                       image: "fried_chicken", title: "Crispy Fried Chicken",
                       desc: "Homemade crispy chicken.", likes: 245, cookTime: "15 min"),

            RecipeItem(userName: "Alice Martin", timeAgo: "1 hr ago",
                       image: "steak", title: "Grilled Steak",
                       desc: "Juicy grilled steak cooked to perfection.",
                       likes: 312, cookTime: "15 min"),

            RecipeItem(userName: "David Green", timeAgo: "3 days ago",
                       image: "cake", title: "Chocolate Cake",
                       desc: "A moist and decadent chocolate cake.",
                       likes: 289, cookTime: "30 min")
        ]

        mainView.render(recipes: recipes)
    }
}

struct RecipeItem {
    let userName: String
    let timeAgo: String
    let image: String
    let title: String
    let desc: String
    let likes: Int
    let cookTime: String
}
