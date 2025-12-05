//
//  MainPageController.swift
//  Final_RecipeLab_Team16
//
//  Created by 王敬捷 on 11/16/25.
//

import UIKit

class MainPageController: BaseViewController {

    private let mainView = MainPageView()
    private let model = MainPageModel()

    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
    }

    private func setupData() {
        model.fetchRecipes { [weak self] recipes, error in
            if let error = error {
                print("DEBUG: fetch error → \(error.localizedDescription)")
                return
            }
            guard let recipes = recipes else { return }
            DispatchQueue.main.async {
                self?.mainView.render(recipes: recipes)
            }
        }
    }
}

