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

    override func viewDidLoad() {
        super.viewDidLoad()
        setContent(rootView)

        // Always observe login state
        Auth.auth().addStateDidChangeListener { [weak self] _, user in
            guard let self = self else { return }

            DispatchQueue.main.async {
                if let user = user {
                    // Logged in → show content
                    let profile = UserProfile(
                        id: user.uid,
                        username: user.displayName ?? "Unknown",
                        avatarUrl: user.photoURL?.absoluteString
                    )
                    self.rootView.updateUserProfile(profile)
                    self.rootView.showContent()
                } else {
                    // Logged out → show placeholder
                    self.rootView.showLoginPlaceholder()
                }
            }
        }
    }
}
