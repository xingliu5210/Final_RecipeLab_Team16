//
//  RecipieDetailView.swift
//  Final_RecipeLab_Team16
//
//  Created by 王敬捷 on 11/16/25.
//

import UIKit

class RecipieDetailPageView: UIView {

    // MARK: - UI

    private let stackView = UIStackView()

    private let recipeImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()

    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        lbl.numberOfLines = 0
        return lbl
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

    private let statsStackView = UIStackView()
    private let likeIconView = UIImageView(image: UIImage(systemName: "heart.fill"))
    private let likeCountLabel = UILabel()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
        configureWithFakeData()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        setupConstraints()
        configureWithFakeData()
    }

    // MARK: - Fake content

    private func configureWithFakeData() {
        backgroundColor = .systemBackground

        recipeImageView.image = UIImage(named: "blackPasta") ?? UIImage(systemName: "photo")
        titleLabel.text = "Creamy Pasta"
        authorLabel.text = "Alice"
        timeAgoLabel.text = "2 hours ago"

        let ingredients = [
            "8 oz fettuccine or spaghetti",
            "1 cup heavy cream",
            "1/2 cup grated Parmesan cheese",
            "2 tbsp unsalted butter",
            "Salt and pepper to taste"
        ]

        let steps = [
            "Cook the pasta according to package instructions. Drain and set aside.",
            "In a large pan, melt the butter over medium heat. Add the heavy cream and bring to a gentle simmer.",
            "Stir in the Parmesan cheese until the sauce thickens slightly.",
            "Season with salt and pepper. Toss the cooked pasta in the sauce until evenly coated.",
            "Serve immediately and garnish with extra Parmesan and parsley, if desired."
        ]

        ingredientsLabel.text = ingredients.map { "• \($0)" }.joined(separator: "\n")

        instructionsLabel.text = steps
            .enumerated()
            .map { "\($0 + 1). \($1)" }
            .joined(separator: "\n\n")

        likeIconView.tintColor = .systemOrange
        likeCountLabel.text = "128"
        likeCountLabel.font = UIFont.systemFont(ofSize: 15)
    }

    func configure(with recipe: Recipe) {
        backgroundColor = .systemBackground
        recipeImageView.loadImage(from: recipe.imageUrl)
        titleLabel.text = recipe.title
        authorLabel.text = recipe.userName
        timeAgoLabel.text = recipe.creationTimeAgo
        ingredientsLabel.text = recipe.ingredients.map { "• \($0)" }.joined(separator: "\n")
        instructionsLabel.text = recipe.steps.enumerated().map { "\($0 + 1). \($1)" }.joined(separator: "\n\n")
        likeCountLabel.text = "\(recipe.likedBy.count)"
    }

    // MARK: - Setup

    private func setupUI() {
        // Add stackView directly to self
        addSubview(stackView)

        addSubview(recipeImageView)
        recipeImageView.translatesAutoresizingMaskIntoConstraints = false

        // Stack
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false
        // FIX: Ensure stackView is allowed to grow vertically to determine content size
        stackView.setContentHuggingPriority(.defaultLow, for: .vertical)

        // Layout margins for text
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(
            top: 0,
            leading: 16,
            bottom: 24,
            trailing: 16
        )

        // Stats row
        statsStackView.axis = .horizontal
        statsStackView.alignment = .center
        statsStackView.distribution = .fill
        statsStackView.spacing = 8

        let statsSpacer = UIView()
        statsSpacer.setContentHuggingPriority(.defaultLow, for: .horizontal)

        statsStackView.addArrangedSubview(likeIconView)
        statsStackView.addArrangedSubview(likeCountLabel)
        statsStackView.addArrangedSubview(statsSpacer)

        // Arrange content inside stackView

        // 2. Content labels
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(authorLabel)
        stackView.addArrangedSubview(timeAgoLabel)

        stackView.setCustomSpacing(20, after: timeAgoLabel)
        stackView.addArrangedSubview(ingredientsTitleLabel)
        stackView.addArrangedSubview(ingredientsLabel)

        stackView.setCustomSpacing(20, after: ingredientsLabel)
        stackView.addArrangedSubview(instructionsTitleLabel)
        stackView.addArrangedSubview(instructionsLabel)

        stackView.setCustomSpacing(20, after: instructionsLabel)
        stackView.addArrangedSubview(statsStackView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            recipeImageView.topAnchor.constraint(equalTo: topAnchor),
            recipeImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            recipeImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            recipeImageView.heightAnchor.constraint(equalToConstant: 240),

            stackView.topAnchor.constraint(equalTo: recipeImageView.bottomAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
