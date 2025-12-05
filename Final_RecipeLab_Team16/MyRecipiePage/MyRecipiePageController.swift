//
//  AddRecipiePageController.swift
//  Final_RecipeLab_Team16
//
//  Created by 王敬捷 on 11/16/25.
//

import UIKit

class MyRecipiePageController: BaseViewController {

    private let rootView = MyRecipiePageView()

    override func loadView() {
        view = rootView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Fake User Profile Simulation
        let mockProfile = UserProfile(
            id: "123",
            username: "@JessieCooks",
            avatarUrl: ""
        )
        
        rootView.updateUserProfile(mockProfile)
    }
}
