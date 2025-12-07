import UIKit

protocol MyRecipePageSelectionDelegate: AnyObject {
    func didSelectRecipe(_ recipe: Recipe)
}

class MyRecipiePageView: UIView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // Placeholder when user is not logged in
        let loginPlaceholderLabel: UILabel = {
            let label = UILabel()
            label.text = "Please log in to view your recipes"
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
            label.textColor = .darkGray
            label.isHidden = true
            return label
        }()

    // Helper to talk to Controller
    var onSegmentChanged: ((Int) -> Void)?
    
    // UI
    let avatarImageView = UIImageView()
    let usernameLabel = UILabel()
    let roleLabel = UILabel()
    let followersLabel = UILabel()
    let recipesLabel = UILabel()
    
    let segmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Saved", "My Recipes"])
        sc.selectedSegmentIndex = 1
        return sc
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = MyRecipiePageView.createLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        return cv
    }()
    
    var recipes: [Recipe] = []
    var userId: String = ""
    weak var selectionDelegate: MyRecipePageSelectionDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        // --- THE FIX: Detect clicks ---
        segmentedControl.addTarget(self, action: #selector(segmentChanged(_:)), for: .valueChanged)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    @objc private func segmentChanged(_ sender: UISegmentedControl) {
        onSegmentChanged?(sender.selectedSegmentIndex)
    }

    private func setupView() {
        // Basic Setup
        [avatarImageView, usernameLabel, roleLabel, followersLabel, recipesLabel, segmentedControl, collectionView].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        // Styling defaults
        avatarImageView.layer.cornerRadius = 45
        avatarImageView.clipsToBounds = true
        avatarImageView.backgroundColor = .lightGray
        usernameLabel.font = .boldSystemFont(ofSize: 22); usernameLabel.textAlignment = .center
        roleLabel.text = "Home Cook"; roleLabel.textColor = .darkGray; roleLabel.textAlignment = .center
        followersLabel.textAlignment = .center; followersLabel.numberOfLines = 2; followersLabel.text = "0\nFollowers"
        recipesLabel.textAlignment = .center; recipesLabel.numberOfLines = 2; recipesLabel.text = "0\nRecipes"

        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(RecipeCardView.self, forCellWithReuseIdentifier: RecipeCardView.identifier)

        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            avatarImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: 90),
            avatarImageView.heightAnchor.constraint(equalToConstant: 90),

            usernameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 12),
            usernameLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            roleLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 4),
            roleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            followersLabel.topAnchor.constraint(equalTo: roleLabel.bottomAnchor, constant: 16),
            followersLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            followersLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5),
            
            recipesLabel.topAnchor.constraint(equalTo: roleLabel.bottomAnchor, constant: 16),
            recipesLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            recipesLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5),

            segmentedControl.topAnchor.constraint(equalTo: followersLabel.bottomAnchor, constant: 20),
            segmentedControl.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            segmentedControl.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

            collectionView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            collectionView.heightAnchor.constraint(equalToConstant: 900),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20)
        ])
    }

    // --- THE FIX: Clean Layout (Removed bad insets) ---
    static func createLayout() -> UICollectionViewLayout {
        let item = NSCollectionLayoutItem(
            layoutSize: .init(widthDimension: .fractionalWidth(0.5), heightDimension: .estimated(260))
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(260)),
            subitems: [item, item]
        )
        group.interItemSpacing = .fixed(12)
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 12
        return UICollectionViewCompositionalLayout(section: section)
    }

    func updateRecipes(_ list: [Recipe], _ userId: String) {
        self.recipes = list
        self.userId = userId
        self.recipesLabel.text = "\(list.count)\nRecipes" // Updates the count!
        self.collectionView.reloadData()
    }
    
    // Boilerplate for display
    func showContent(user: UserProfile) {
        usernameLabel.text = user.username
        loginPlaceholderLabel.isHidden = true
        loginPlaceholderLabel.removeFromSuperview()
        avatarImageView.isHidden = false
        usernameLabel.isHidden = false
        roleLabel.isHidden = false
        followersLabel.isHidden = false
        recipesLabel.isHidden = false
        segmentedControl.isHidden = false
        collectionView.isHidden = false
        if let url = URL(string: user.avatarUrl ?? "") {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url), let img = UIImage(data: data) {
                    DispatchQueue.main.async { self.avatarImageView.image = img }
                }
            }
        } else {
             self.avatarImageView.image = UIImage(named: "chiefimage (1)")
        }
    }
    
    func showLoginPlaceholder() {
            avatarImageView.isHidden = true
            usernameLabel.isHidden = true
            roleLabel.isHidden = true
            followersLabel.isHidden = true
            recipesLabel.isHidden = true
            segmentedControl.isHidden = true
            collectionView.isHidden = true

        if loginPlaceholderLabel.superview == nil {
            addSubview(loginPlaceholderLabel)
            loginPlaceholderLabel.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                loginPlaceholderLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
                loginPlaceholderLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
        }
        bringSubviewToFront(loginPlaceholderLabel)
        loginPlaceholderLabel.isHidden = false
    }
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recipes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecipeCardView.identifier, for: indexPath) as! RecipeCardView
        cell.configure(with: recipes[indexPath.item], userId: userId)
        cell.tag = indexPath.item
        cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTap(_:))))
        return cell
    }
    
    @objc func onTap(_ sender: UITapGestureRecognizer) {
        guard let cell = sender.view, let indexPath = collectionView.indexPath(for: cell as! UICollectionViewCell) else { return }
        selectionDelegate?.didSelectRecipe(recipes[indexPath.item])
    }
}
