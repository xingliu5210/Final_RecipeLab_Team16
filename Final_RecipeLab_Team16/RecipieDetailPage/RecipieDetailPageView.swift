//
//  RecipieDetailView.swift
//  Final_RecipeLab_Team16
//
//  Created by 王敬捷 on 11/16/25.
//

import UIKit

class RecipieDetailPageView: UIView {

    // MARK: - UI

    private let scrollView = UIScrollView()
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
    private let commentIconView = UIImageView(image: UIImage(systemName: "bubble.right"))
    private let commentCountLabel = UILabel()

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
        commentIconView.tintColor = .gray
        likeCountLabel.text = "128"
        commentCountLabel.text = "9"
        likeCountLabel.font = UIFont.systemFont(ofSize: 15)
        commentCountLabel.font = UIFont.systemFont(ofSize: 15)
    }

    // MARK: - Setup

    private func setupUI() {
        // Scroll
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceVertical = true
        addSubview(scrollView)

        // Stack
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false
        // FIX: Ensure stackView is allowed to grow vertically to determine content size
        stackView.setContentHuggingPriority(.defaultLow, for: .vertical)

        // Add stack to scroll
        scrollView.addSubview(stackView)

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
        statsStackView.addArrangedSubview(commentIconView)
        statsStackView.addArrangedSubview(commentCountLabel)

        // Arrange content inside stackView

        // 1. image (full width, no side margins)
        recipeImageView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(recipeImageView)
        recipeImageView.heightAnchor.constraint(equalToConstant: 240).isActive = true

        // 2. Content labels
        stackView.setCustomSpacing(16, after: recipeImageView) // bigger gap under image
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
        let contentGuide = scrollView.contentLayoutGuide
        let frameGuide = scrollView.frameLayoutGuide // Used for horizontal constraints

        NSLayoutConstraint.activate([
            // Scroll view within safe area (so tab bar doesn't cover content)
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),

            // Stack view pinned vertically to scroll content (contentGuide)
            stackView.topAnchor.constraint(equalTo: contentGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentGuide.bottomAnchor),

            // FIXED: Stack view pinned horizontally to the scroll view's frame (frameGuide)
            // This ensures the width of the content (stackView) matches the visible width (frame),
            // which is essential for scroll view to calculate vertical content size.
            stackView.leadingAnchor.constraint(equalTo: frameGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: frameGuide.trailingAnchor),
        ])
    }
}
