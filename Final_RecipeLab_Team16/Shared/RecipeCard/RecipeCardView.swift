//
//  CardView.swift
//  Final_RecipeLab_Team16
//
//  Created by 王敬捷 on 11/16/25.
//

import UIKit

class RecipeCardView: UICollectionViewCell {
    private let model = RecipeCardModel()
    
    static let identifier = "RecipeCard"

    // UI Components
    private let userImageView = UIImageView()
    private let userNameLabel = UILabel()
    private let timeLabel = UILabel()

    private let recipeImageView = UIImageView()
    private let titleLabel = UILabel()
    
    private let likeIcon = UIImageView()
    private let likeLabel = UILabel()

    private let clockIcon = UIImageView()
    private let timeAmountLabel = UILabel()

    private var recipeId: String?
    private var userId: String?
    private var isLiked: Bool = false

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with recipe: Recipe, userId: String?) {
        self.recipeId = recipe.id
        self.userId = userId
        
        // check if user liked this recipe
        if let uid = userId, recipe.likedBy.keys.contains(uid) {
            self.isLiked = true
        } else {
            self.isLiked = false
        }
        updateLikeIcon()

        userNameLabel.text = recipe.userName
        timeLabel.text = recipe.creationTimeAgo
        titleLabel.text = recipe.title
        likeLabel.text = "\(recipe.likedBy.count)"
        timeAmountLabel.text = "\(recipe.cookingTime) min"

        userImageView.loadImage(from: recipe.userImageUrl, placeholderNamed: "chiefimage (1)")
        recipeImageView.loadImage(from: recipe.imageUrl, placeholderNamed: "placeholder")
    }

    private func setupUI() {
        backgroundColor = .white
        layer.cornerRadius = 16
        // Shadow
        layer.shadowColor = UIColor.black.withAlphaComponent(0.08).cgColor
        layer.shadowOpacity = 1
        layer.shadowRadius = 8
        layer.shadowOffset = CGSize(width: 0, height: 4)

        // Styling
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
        
        likeIcon.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapLike))
        likeIcon.addGestureRecognizer(tap)
        
        clockIcon.image = UIImage(systemName: "clock")
        clockIcon.tintColor = .gray

        // --- THE FIX: Add to contentView ---
        [userImageView, userNameLabel, timeLabel, recipeImageView, titleLabel, likeIcon, likeLabel, clockIcon, timeAmountLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
    }
    
    private func setupConstraints() {
        // --- THE FIX: Constrain to contentView ---
        NSLayoutConstraint.activate([
            userImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            userImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            userImageView.widthAnchor.constraint(equalToConstant: 32),
            userImageView.heightAnchor.constraint(equalToConstant: 32),

            userNameLabel.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant: 8),
            userNameLabel.topAnchor.constraint(equalTo: userImageView.topAnchor),

            timeLabel.leadingAnchor.constraint(equalTo: userNameLabel.leadingAnchor),
            timeLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 2),

            recipeImageView.topAnchor.constraint(equalTo: userImageView.bottomAnchor, constant: 12),
            recipeImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            recipeImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            recipeImageView.heightAnchor.constraint(equalToConstant: 160),

            titleLabel.topAnchor.constraint(equalTo: recipeImageView.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: recipeImageView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: recipeImageView.trailingAnchor),

            likeIcon.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            likeIcon.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            likeIcon.widthAnchor.constraint(equalToConstant: 16),
            likeIcon.heightAnchor.constraint(equalToConstant: 16),

            likeLabel.centerYAnchor.constraint(equalTo: likeIcon.centerYAnchor),
            likeLabel.leadingAnchor.constraint(equalTo: likeIcon.trailingAnchor, constant: 4),

            clockIcon.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -60),
            clockIcon.centerYAnchor.constraint(equalTo: likeIcon.centerYAnchor),
            clockIcon.widthAnchor.constraint(equalToConstant: 16),
            clockIcon.heightAnchor.constraint(equalToConstant: 16),

            timeAmountLabel.centerYAnchor.constraint(equalTo: clockIcon.centerYAnchor),
            timeAmountLabel.leadingAnchor.constraint(equalTo: clockIcon.trailingAnchor, constant: 4),
            
            // Important: Pin bottom so cell has height
            contentView.bottomAnchor.constraint(equalTo: timeAmountLabel.bottomAnchor, constant: 12)
        ])
    }
    
    private func updateLikeIcon() {
        let imageName = isLiked ? "likeOn (1)" : "likeOff (1)"
        likeIcon.image = UIImage(named: imageName)
    }

    @objc private func didTapLike() {
        guard let recipeId = recipeId, let userId = userId else { return }
        
        // Simple toggle logic
        if isLiked {
            model.unlikeRecipe(recipeId: recipeId, userId: userId) { [weak self] _ in
                DispatchQueue.main.async {
                    self?.isLiked = false
                    self?.updateLikeIcon()
                    NotificationCenter.default.post(name: NSNotification.Name("Refresh"), object: nil)
                }
            }
        } else {
            model.likeRecipe(recipeId: recipeId, userId: userId) { [weak self] _ in
                DispatchQueue.main.async {
                    self?.isLiked = true
                    self?.updateLikeIcon()
                    NotificationCenter.default.post(name: NSNotification.Name("Refresh"), object: nil)
                }
            }
        }
    }
}
