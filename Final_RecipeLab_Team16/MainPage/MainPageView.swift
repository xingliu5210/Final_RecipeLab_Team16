//
//  MainPageView.swift
//  Final_RecipeLab_Team16
//
//  Created by 王敬捷 on 11/16/25.
//

import UIKit

class MainPageView: UIView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    weak var selectionDelegate: RecipeCardSelectionDelegate?
    
    private var currentUserId: String?
    private var recipes: [Recipe] = []

    // 1. Define the Collection View
    private lazy var collectionView: UICollectionView = {
        let layout = MainPageView.createLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        // Disable internal scrolling so the BaseViewController scroll handles it
        cv.isScrollEnabled = false
        return cv
    }()
    
    // Constraint to dynamiclly change height
    private var collectionViewHeightConstraint: NSLayoutConstraint?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    // MARK: - Public

    func render(recipes: [Recipe], userId: String?) {
        self.currentUserId = userId
        self.recipes = recipes
        
        self.collectionView.reloadData()
        self.updateContentHeight()
    }

    // MARK: - Private Setup

    private func setupUI() {
        backgroundColor = .clear
        
        addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        // Register the card cell
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(RecipeCardView.self, forCellWithReuseIdentifier: RecipeCardView.identifier)

        // Setup Constraints
        collectionViewHeightConstraint = collectionView.heightAnchor.constraint(equalToConstant: 200) // Initial placeholder height
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            collectionViewHeightConstraint!
        ])
    }
    
    // MARK: - Dynamic Height Logic
    private func updateContentHeight() {
        // Calculate number of rows (2 items per row)
        let rows = ceil(Double(recipes.count) / 2.0)
        
        // Estimated height per item (260) + spacing (12)
        // We add a little buffer to prevent cut-off
        let estimatedHeight = (rows * 280) + 50
        
        collectionViewHeightConstraint?.constant = CGFloat(estimatedHeight)
        layoutIfNeeded()
    }

    // MARK: - CollectionView Layout
    
    static func createLayout() -> UICollectionViewLayout {
        // Same layout as Profile Page for consistency
        let item = NSCollectionLayoutItem(
            layoutSize: .init(widthDimension: .fractionalWidth(0.5), heightDimension: .estimated(260))
        )
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(260)),
            subitems: [item, item]
        )
        group.interItemSpacing = .fixed(12) // Spacing between columns

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 12 // Spacing between rows

        return UICollectionViewCompositionalLayout(section: section)
    }

    // MARK: - DataSource & Delegate

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recipes.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecipeCardView.identifier, for: indexPath) as! RecipeCardView
        
        let recipe = recipes[indexPath.item]
        cell.configure(with: recipe, userId: currentUserId)
        
        // Handle Taps
        cell.tag = indexPath.item
        let tap = UITapGestureRecognizer(target: self, action: #selector(cardTapped(_:)))
        cell.addGestureRecognizer(tap)
        cell.isUserInteractionEnabled = true
        
        return cell
    }
    
    @objc private func cardTapped(_ gesture: UITapGestureRecognizer) {
        guard let card = gesture.view as? RecipeCardView else { return }
        let index = card.tag
        guard index >= 0 && index < recipes.count else { return }
        
        let recipe = recipes[index]
        selectionDelegate?.didSelectRecipe(recipe)
    }
}
