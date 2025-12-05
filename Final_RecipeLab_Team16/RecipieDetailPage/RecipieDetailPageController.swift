//
//  RecipieDetailController.swift
//  Final_RecipeLab_Team16
//
//  Created by 王敬捷 on 11/16/25.
//
/*
import UIKit

class RecipieDetailPageController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "My Recipie"
    }
}*/

import UIKit

class RecipieDetailPageController: BaseViewController {

    private let rootView = RecipieDetailPageView()

    override func loadView() {
        // Use our detail view directly as the controller's view
        view = rootView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do NOT set title here (to avoid the black "Recipe" text)
        // rootView already configures itself with fake data & scrolling
    }
}
