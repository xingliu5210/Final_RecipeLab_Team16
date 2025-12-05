//
//  HeaderView.swift
//  Final_RecipeLab_Team16
//
//  Created by 王敬捷 on 11/22/25.
//

import UIKit

class HeaderView: UIView {


    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        backgroundColor = UIColor(named: "Orange")

        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(containerView)

        let leftImageView = UIImageView()
        leftImageView.image = UIImage(named: "chiefimage (1)")
        leftImageView.contentMode = .scaleAspectFit
        leftImageView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(leftImageView)

        let rightImageView = UIImageView()
        rightImageView.image = UIImage(named: "RecipeLabText (1)")
        rightImageView.contentMode = .scaleAspectFit
        rightImageView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(rightImageView)

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            containerView.centerXAnchor.constraint(equalTo: centerXAnchor),

            leftImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            leftImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -6),
            leftImageView.heightAnchor.constraint(equalToConstant: 40),
            leftImageView.widthAnchor.constraint(equalToConstant: 40),

            rightImageView.leadingAnchor.constraint(equalTo: leftImageView.trailingAnchor, constant: 4),
            rightImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            rightImageView.heightAnchor.constraint(equalToConstant: 50),
            rightImageView.widthAnchor.constraint(equalToConstant: 120),
            rightImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),

        ])
    }

}
