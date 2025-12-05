//
//  RecipieDetailController.swift
//  Final_RecipeLab_Team16
//
//  Created by 王敬捷 on 11/16/25.
//

import UIKit

class RecipieDetailPageController: BaseViewController {

    private let rootView = RecipieDetailPageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setContent(rootView)
    }
}
