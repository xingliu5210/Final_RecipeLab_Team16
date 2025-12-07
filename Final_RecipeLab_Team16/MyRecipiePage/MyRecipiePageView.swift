import UIKit

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

    // MARK: - UI Components

    let avatarImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "person.circle.fill")
        iv.tintColor = .lightGray
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 45
        return iv
    }()

    let usernameLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "@username"
        lbl.font = UIFont.boldSystemFont(ofSize: 22)
        lbl.textAlignment = .center
        return lbl
    }()

    let roleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Home Cook"
        lbl.font = UIFont.systemFont(ofSize: 16)
        lbl.textColor = .darkGray
        lbl.textAlignment = .center
        return lbl
    }()

    let followersLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "0\nFollowers"
        lbl.numberOfLines = 2
        lbl.font = UIFont.systemFont(ofSize: 16)
        lbl.textAlignment = .center
        return lbl
    }()

    let recipesLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "0\nRecipes"
        lbl.numberOfLines = 2
        lbl.font = UIFont.systemFont(ofSize: 16)
        lbl.textAlignment = .center
        return lbl
    }()

    let segmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Saved", "My Recipes"])
        sc.selectedSegmentIndex = 1
        return sc
    }()

    let collectionView: UICollectionView = {
        let layout = MyRecipiePageView.createLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        return cv
    }()

    // MARK: - Data

    var recipes: [Recipe] = []
    var userId: String = ""

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }

    // MARK: - Setup

    private func setupView() {
        [avatarImageView, usernameLabel, roleLabel, followersLabel, recipesLabel, segmentedControl, collectionView]
            .forEach {
                addSubview($0)
                $0.translatesAutoresizingMaskIntoConstraints = false
            }

        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(RecipeCardView.self, forCellWithReuseIdentifier: RecipeCardView.identifier)

        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            avatarImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: 90),
            avatarImageView.heightAnchor.constraint(equalToConstant: 90),

            usernameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 12),
            usernameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            usernameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),

            roleLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 4),
            roleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            roleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),

            followersLabel.topAnchor.constraint(equalTo: roleLabel.bottomAnchor, constant: 16),
            followersLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            followersLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5),

            recipesLabel.topAnchor.constraint(equalTo: roleLabel.bottomAnchor, constant: 16),
            recipesLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            recipesLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5),

            segmentedControl.topAnchor.constraint(equalTo: followersLabel.bottomAnchor, constant: 20),
            segmentedControl.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            segmentedControl.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),

            collectionView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            collectionView.heightAnchor.constraint(equalToConstant: 900),
            collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20)
        ])
    }

    // MARK: - Dynamic Update Methods

    func updateUserProfile(_ profile: UserProfile) {
        usernameLabel.text = profile.username

        if let avatar = profile.avatarUrl,
           !avatar.isEmpty,
           let url = URL(string: avatar) {
            URLSession.shared.dataTask(with: url) { data, _, _ in
                if let data = data {
                    DispatchQueue.main.async {
                        self.avatarImageView.image = UIImage(data: data)
                    }
                }
            }.resume()
        } else {
            // Fallback to local asset if no URL provided
            self.avatarImageView.image = UIImage(named: "chiefimage (1)")
        }
    }

    // MARK: - CollectionView DataSource

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recipes.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecipeCardView.identifier, for: indexPath) as! RecipeCardView
        cell.configure(with: recipes[indexPath.item], userId : self.userId)
        return cell
    }

    // MARK: - Layout

    static func createLayout() -> UICollectionViewLayout {
        let item = NSCollectionLayoutItem(
            layoutSize: .init(
                widthDimension: .fractionalWidth(0.5),
                heightDimension: .estimated(260)
            )
        )
        item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6)

        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(260)
            ),
            subitems: [item, item]
        )

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 8

        return UICollectionViewCompositionalLayout(section: section)
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

    func showContent(user : UserProfile) {
        loginPlaceholderLabel.isHidden = true
        loginPlaceholderLabel.removeFromSuperview()
        avatarImageView.isHidden = false
        usernameLabel.isHidden = false
        roleLabel.isHidden = false
        followersLabel.isHidden = false
        recipesLabel.isHidden = false
        segmentedControl.isHidden = false
        collectionView.isHidden = false
        updateUserProfile(user)
    }
    
    func updateRecipes(_ list: [Recipe],_ userId : String) {
        self.recipes = list
        self.userId = userId
        self.collectionView.reloadData()
    }
}
