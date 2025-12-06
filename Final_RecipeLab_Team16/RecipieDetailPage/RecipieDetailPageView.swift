//
//  RecipieDetailView.swift
//  Final_RecipeLab_Team16
//
//  Created by 王敬捷 on 11/16/25.
//

import UIKit

class RecipieDetailPageView: UIView {

    // MARK: - UI

    private let recipeImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()

    private let contentStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.alignment = .fill
        sv.distribution = .fill
        sv.spacing = 12
        sv.isLayoutMarginsRelativeArrangement = true
        sv.directionalLayoutMargins = NSDirectionalEdgeInsets(
            top: 0, leading: 16, bottom: 24, trailing: 16
        )
        return sv
    }()

    // Title
    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        lbl.numberOfLines = 0
        return lbl
    }()

    // Avatar + author + time
    private let avatarImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 16
        iv.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            iv.widthAnchor.constraint(equalToConstant: 32),
            iv.heightAnchor.constraint(equalToConstant: 32)
        ])
        return iv
    }()

    private let authorLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return lbl
    }()

    private let timeAgoLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 14)
        lbl.textColor = .gray
        return lbl
    }()

    private let authorRowStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.alignment = .center
        sv.spacing = 8
        return sv
    }()

    private let authorTextStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.alignment = .leading
        sv.spacing = 2
        return sv
    }()

    // Ingredients
    private let ingredientsTitleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Ingredients"
        lbl.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return lbl
    }()

    private let ingredientsLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 15)
        lbl.numberOfLines = 0
        return lbl
    }()

    // Instructions
    private let instructionsTitleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Instructions"
        lbl.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return lbl
    }()

    private let instructionsLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 15)
        lbl.numberOfLines = 0
        return lbl
    }()

    // Likes
    private let statsStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.alignment = .center
        sv.spacing = 8
        return sv
    }()

    private let likeIconView: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "heart.fill"))
        iv.tintColor = .systemOrange
        return iv
    }()

    private let likeCountLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 15)
        return lbl
    }()

    // MARK: - Init

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

    // MARK: - Public

    func configure(with recipe: Recipe) {
        backgroundColor = .systemBackground

        // main image
        recipeImageView.loadImage(from: recipe.imageUrl,
                                  placeholderNamed: "placeholder")

        titleLabel.text = recipe.title

        // author + time
        authorLabel.text = recipe.userName
        timeAgoLabel.text = recipe.creationTimeAgo

        avatarImageView.loadImage(from: recipe.userImageUrl,
                                  placeholderNamed: "chiefimage (1)")

        // ingredients
        ingredientsLabel.text = recipe.ingredients
            .map { "• \($0)" }
            .joined(separator: "\n")

        // instructions as numbered list
        instructionsLabel.text = recipe.steps
            .enumerated()
            .map { "\($0 + 1). \($1)" }
            .joined(separator: "\n\n")

        likeCountLabel.text = "\(recipe.likedBy.count)"
    }

    // MARK: - Setup

    private func setupUI() {
        backgroundColor = .systemBackground

        addSubview(recipeImageView)
        addSubview(contentStackView)

        recipeImageView.translatesAutoresizingMaskIntoConstraints = false
        contentStackView.translatesAutoresizingMaskIntoConstraints = false

        // build author row
        authorTextStackView.addArrangedSubview(authorLabel)
        authorTextStackView.addArrangedSubview(timeAgoLabel)

        authorRowStackView.addArrangedSubview(avatarImageView)
        authorRowStackView.addArrangedSubview(authorTextStackView)

        // build stats row
        let spacer = UIView()
        spacer.setContentHuggingPriority(.defaultLow, for: .horizontal)

        statsStackView.addArrangedSubview(likeIconView)
        statsStackView.addArrangedSubview(likeCountLabel)
        statsStackView.addArrangedSubview(spacer)

        // add arranged subviews to main stack
        contentStackView.addArrangedSubview(titleLabel)
        contentStackView.addArrangedSubview(authorRowStackView)

        contentStackView.setCustomSpacing(20, after: authorRowStackView)
        contentStackView.addArrangedSubview(ingredientsTitleLabel)
        contentStackView.addArrangedSubview(ingredientsLabel)

        contentStackView.setCustomSpacing(20, after: ingredientsLabel)
        contentStackView.addArrangedSubview(instructionsTitleLabel)
        contentStackView.addArrangedSubview(instructionsLabel)

        contentStackView.setCustomSpacing(20, after: instructionsLabel)
        contentStackView.addArrangedSubview(statsStackView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // big image on top
            recipeImageView.topAnchor.constraint(equalTo: topAnchor),
            recipeImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            recipeImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            recipeImageView.heightAnchor.constraint(equalToConstant: 240),

            // content below image
            contentStackView.topAnchor.constraint(equalTo: recipeImageView.bottomAnchor, constant: 16),
            contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
