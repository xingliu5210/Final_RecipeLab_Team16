//
//  CardView.swift
//  Final_RecipeLab_Team16
//
//  Created by 王敬捷 on 11/16/25.
//

import UIKit

class CardView: UIView {

    private let userImageView = UIImageView()
    private let userNameLabel = UILabel()
    private let timeLabel = UILabel()

    private let recipeImageView = UIImageView()
    private let titleLabel = UILabel()
    private let descLabel = UILabel()

    private let likeIcon = UIImageView()
    private let likeLabel = UILabel()

    private let clockIcon = UIImageView()
    private let timeAmountLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        setupConstraints()
    }

    func configure(with recipe: Recipe) {
        userNameLabel.text = recipe.userName
        timeLabel.text = recipe.creationTimeAgo

        userImageView.loadImage(from: recipe.userImageUrl,
                                placeholderNamed: "chiefimage (1)")

        recipeImageView.loadImage(from: recipe.imageUrl,
                                  placeholderNamed: "placeholder")

        titleLabel.text = recipe.title
        likeLabel.text = "\(recipe.likedBy.count)"
        timeAmountLabel.text = "\(recipe.cookingTime) min"
    }
}

// MARK: UI Setup
private extension CardView {

    func setupUI() {
        backgroundColor = .white
        layer.cornerRadius = 16
        layer.shadowColor = UIColor.black.withAlphaComponent(0.08).cgColor
        layer.shadowOpacity = 1
        layer.shadowRadius = 8
        layer.shadowOffset = CGSize(width: 0, height: 4)

        userImageView.layer.cornerRadius = 16
        userImageView.clipsToBounds = true
        userImageView.contentMode = .scaleAspectFill

        userNameLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        timeLabel.font = UIFont.systemFont(ofSize: 12)
        timeLabel.textColor = .gray

        recipeImageView.layer.cornerRadius = 12
        recipeImageView.clipsToBounds = true
        recipeImageView.contentMode = .scaleAspectFill

        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        descLabel.font = UIFont.systemFont(ofSize: 13)
        descLabel.textColor = .darkGray
        descLabel.numberOfLines = 2

        likeIcon.image = UIImage(systemName: "heart.fill")
        likeIcon.tintColor = .systemOrange

        clockIcon.image = UIImage(systemName: "clock")
        clockIcon.tintColor = .gray

        let allSubviews = [
            userImageView, userNameLabel, timeLabel,
            recipeImageView, titleLabel,
            likeIcon, likeLabel, clockIcon, timeAmountLabel
        ]

        allSubviews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
        descLabel.isHidden = true
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([

            // User avatar
            userImageView.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            userImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            userImageView.widthAnchor.constraint(equalToConstant: 32),
            userImageView.heightAnchor.constraint(equalToConstant: 32),

            userNameLabel.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant: 8),
            userNameLabel.topAnchor.constraint(equalTo: userImageView.topAnchor),

            timeLabel.leadingAnchor.constraint(equalTo: userNameLabel.leadingAnchor),
            timeLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 2),

            // Recipe image
            recipeImageView.topAnchor.constraint(equalTo: userImageView.bottomAnchor, constant: 12),
            recipeImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            recipeImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            recipeImageView.heightAnchor.constraint(equalToConstant: 160),

            // Title
            titleLabel.topAnchor.constraint(equalTo: recipeImageView.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: recipeImageView.leadingAnchor),

            // Bottom info row
            likeIcon.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            likeIcon.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            likeIcon.widthAnchor.constraint(equalToConstant: 16),
            likeIcon.heightAnchor.constraint(equalToConstant: 16),

            likeLabel.centerYAnchor.constraint(equalTo: likeIcon.centerYAnchor),
            likeLabel.leadingAnchor.constraint(equalTo: likeIcon.trailingAnchor, constant: 4),

            clockIcon.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -80),
            clockIcon.centerYAnchor.constraint(equalTo: likeIcon.centerYAnchor),
            clockIcon.widthAnchor.constraint(equalToConstant: 16),
            clockIcon.heightAnchor.constraint(equalToConstant: 16),

            timeAmountLabel.centerYAnchor.constraint(equalTo: clockIcon.centerYAnchor),
            timeAmountLabel.leadingAnchor.constraint(equalTo: clockIcon.trailingAnchor, constant: 4),

            bottomAnchor.constraint(equalTo: timeAmountLabel.bottomAnchor, constant: 12)
        ])
    }
}
