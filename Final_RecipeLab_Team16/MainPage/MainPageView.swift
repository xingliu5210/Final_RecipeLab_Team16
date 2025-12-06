//
//  MainPageView.swift
//  Final_RecipeLab_Team16
//
//  Created by 王敬捷 on 11/16/25.
//

import UIKit

protocol MainPageViewDelegate: AnyObject {
    func mainPageView(_ view: MainPageView, didSelect recipe: Recipe)
}

class MainPageView: UIView {

    weak var delegate: MainPageViewDelegate?

    private var recipes: [Recipe] = []

    // Vertical stack; each arranged subview is one horizontal row of 2 cards
    private let containerStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        stack.alignment = .fill
        stack.distribution = .fillEqually
        return stack
    }()

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

    func render(recipes: [Recipe]) {
        self.recipes = recipes

        // Remove old rows
        for view in containerStackView.arrangedSubviews {
            containerStackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }

        var currentRow: UIStackView?

        for (index, recipe) in recipes.enumerated() {
            // Start a new row every 2 cards
            if index % 2 == 0 {
                let row = UIStackView()
                row.axis = .horizontal
                row.spacing = 12
                row.alignment = .fill
                row.distribution = .fillEqually
                containerStackView.addArrangedSubview(row)
                currentRow = row
            }

            let card = CardView()
            card.configure(with: recipe)

            card.isUserInteractionEnabled = true
            card.tag = index
            let tap = UITapGestureRecognizer(target: self,
                                             action: #selector(cardTapped(_:)))
            card.addGestureRecognizer(tap)

            currentRow?.addArrangedSubview(card)
        }
    }

    // MARK: - Private

    private func setupUI() {
        backgroundColor = .clear
        containerStackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(containerStackView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            containerStackView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            containerStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            containerStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            containerStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }

    @objc private func cardTapped(_ gesture: UITapGestureRecognizer) {
        guard let card = gesture.view as? CardView else { return }
        let index = card.tag
        guard index >= 0 && index < recipes.count else { return }
        let recipe = recipes[index]
        delegate?.mainPageView(self, didSelect: recipe)
    }
}
