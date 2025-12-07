//
//  MainPageController.swift
//  Final_RecipeLab_Team16
//
//  Created by 王敬捷 on 11/16/25.
//

import UIKit
import FirebaseAuth

class MainPageController: BaseViewController {

    private let mainView = MainPageView()
    private let model = MainPageModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Put our content into BaseViewController’s scrollView
        setContent(mainView)

        // Receive taps from cards
        mainView.selectionDelegate = self

        setupData()
        NotificationCenter.default.addObserver(self, selector: #selector(handleRefresh), name: Notification.Name("Refresh"), object: nil)
    }

    private func setupData() {
        model.fetchRecipes { [weak self] recipes, error in
            if let error = error {
                print("DEBUG: fetch error → \(error.localizedDescription)")
                return
            }
            guard let recipes = recipes else { return }

            DispatchQueue.main.async {
                let uid = Auth.auth().currentUser?.uid
                self?.mainView.render(recipes: recipes, userId: uid)
            }
        }
    }

    @objc private func handleRefresh() {
        setupData()
    }
}

// MARK: - RecipeCardSelectionDelegate

extension MainPageController: RecipeCardSelectionDelegate {
    func didSelectRecipe(_ recipe: Recipe) {
        let detailVC = RecipieDetailPageController(recipe: recipe)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
