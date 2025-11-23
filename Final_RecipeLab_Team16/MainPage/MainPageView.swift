//
//  MainPageView.swift
//  Final_RecipeLab_Team16
//
//  Created by 王敬捷 on 11/16/25.
//

import UIKit

class MainPageView: UIView {
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private var cardViews: [CardView] = []

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

    func render(recipes: [RecipeItem]) {
        cardViews.forEach { $0.removeFromSuperview() }
        cardViews.removeAll()

        let cardWidth = (UIScreen.main.bounds.width - 36) / 2

        var x: CGFloat = 12
        var y: CGFloat = 12
        var column = 0

        for item in recipes {
            let card = CardView()

            card.configure(
                userImage: UIImage(named: "user\(cardViews.count + 1)"),
                userName: item.userName,
                timeAgo: item.timeAgo,
                recipeImage: UIImage(named: item.image),
                title: item.title,
                desc: item.desc,
                likes: item.likes,
                cookTime: item.cookTime
            )

            contentView.addSubview(card)
            card.translatesAutoresizingMaskIntoConstraints = false

            NSLayoutConstraint.activate([
                card.topAnchor.constraint(equalTo: contentView.topAnchor, constant: y),
                card.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: x),
                card.widthAnchor.constraint(equalToConstant: cardWidth)
            ])

            card.layoutIfNeeded()

            // New column logic
            if column == 0 {
                x = 12 + cardWidth + 12  // col 2
                column = 1
            } else {
                x = 12
                column = 0
                y += card.frame.height + 20
            }

            cardViews.append(card)
        }

        if let last = cardViews.last {
            last.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20).isActive = true
        }
    }

    // MARK: UI Setup
    private func setupUI() {
        backgroundColor = .systemGroupedBackground

        [scrollView, contentView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        addSubview(scrollView)
        scrollView.addSubview(contentView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // ScrollView constraints
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
}
