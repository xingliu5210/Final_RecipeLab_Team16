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
    private var currentUserId: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        setContent(rootView)
        rootView.selectionDelegate = self
        
        // --- THE FIX: Listen to the switch ---
        rootView.onSegmentChanged = { [weak self] index in
            self?.refreshData(index: index)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleRefresh), name: NSNotification.Name("Refresh"), object: nil)

        _ = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            guard let self = self else { return }
            if let user = user {
                self.currentUserId = user.uid
                let profile = UserProfile(id: user.uid, username: user.displayName ?? "User", avatarUrl: user.photoURL?.absoluteString)
                self.rootView.showContent(user: profile)
                // Load initial data
                self.refreshData(index: self.rootView.segmentedControl.selectedSegmentIndex)
            } else {
                self.currentUserId = nil
                self.rootView.showLoginPlaceholder()
            }
        }
    }

    private func refreshData(index: Int) {
        guard let userId = currentUserId else { return }
        
        if index == 1 {
            // "My Recipes"
            recipeModel.fetchRecipesByUserId(userId) { [weak self] result in
                DispatchQueue.main.async {
                    self?.rootView.updateRecipes((try? result.get()) ?? [], userId)
                }
            }
        } else {
            // "Saved"
            recipeModel.fetchLikedRecipes(by: userId) { [weak self] result in
                DispatchQueue.main.async {
                    self?.rootView.updateRecipes((try? result.get()) ?? [], userId)
                }
            }
        }
    }

    @objc private func handleRefresh() {
        refreshData(index: rootView.segmentedControl.selectedSegmentIndex)
    }
}

extension MyRecipiePageController: MyRecipePageSelectionDelegate {
    func didSelectRecipe(_ recipe: Recipe) {
        let vc = RecipieDetailPageController(recipe: recipe)
        navigationController?.pushViewController(vc, animated: true)
    }
}
