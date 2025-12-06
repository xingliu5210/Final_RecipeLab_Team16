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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Put our content into BaseViewController’s scrollView
        setContent(mainView)

        // Receive taps from cards
        mainView.delegate = self

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

// MARK: - MainPageViewDelegate

extension MainPageController: MainPageViewDelegate {
    func mainPageView(_ view: MainPageView, didSelect recipe: Recipe) {
        let detailVC = RecipieDetailPageController(recipe: recipe)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
