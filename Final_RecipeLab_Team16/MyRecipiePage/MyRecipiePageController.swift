//
//  AddRecipiePageController.swift
//  Final_RecipeLab_Team16
//
//  Created by 王敬捷 on 11/16/25.
//

import UIKit
import FirebaseAuth

class MyRecipiePageController: BaseViewController {

    private let rootView = MyRecipiePageView()
    private let recipeModel = MyRecipiePageModel()

    private func loadUserRecipes(_ userId: String) {
        recipeModel.fetchRecipesByUserId(userId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let recipes):
                    self?.rootView.updateRecipes(recipes)
                case .failure(let error):
                    print("Failed to fetch recipes:", error)
                    self?.rootView.updateRecipes([])
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setContent(rootView)
        NotificationCenter.default.addObserver(self, selector: #selector(handleRefresh), name: NSNotification.Name("Refresh"), object: nil)

        _ = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            guard let self = self else { return }

            if let user = user {
                let profile = UserProfile(
                    id: user.uid,
                    username: user.displayName ?? "Unknown",
                    avatarUrl: user.photoURL?.absoluteString
                )
                self.rootView.showContent(user: profile)

                self.loadUserRecipes(user.uid)

            } else {
                self.rootView.showLoginPlaceholder()
            }
        }
    }

    @objc private func handleRefresh() {
        guard let user = Auth.auth().currentUser else { return }
        loadUserRecipes(user.uid)
    }
}
