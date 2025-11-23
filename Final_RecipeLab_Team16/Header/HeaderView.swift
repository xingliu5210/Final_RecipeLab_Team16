//
//  HeaderView.swift
//  Final_RecipeLab_Team16
//
//  Created by 王敬捷 on 11/22/25.
//

import UIKit

class HeaderView: UIView {

    private let titleLabel: UILabel = {
        let label = UILabel()

        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

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
        addSubview(titleLabel)

        let logoImageView = UIImageView()
        logoImageView.image = UIImage(named: "RecipeLabText (1)")
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(logoImageView)

        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            logoImageView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            logoImageView.heightAnchor.constraint(equalToConstant: 130),
            logoImageView.widthAnchor.constraint(equalToConstant: 130),

            titleLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 4),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }

    func setTitle(_ text: String) {
        titleLabel.text = text
    }
}
