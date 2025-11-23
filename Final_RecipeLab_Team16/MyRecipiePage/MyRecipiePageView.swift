
import UIKit

class RecipeCardCell: UICollectionViewCell {
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 10
        return iv
    }()

    let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        lbl.textColor = .black
        lbl.textAlignment = .center
        lbl.numberOfLines = 2
        return lbl
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: contentView.widthAnchor),

            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 4),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 2),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -2),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4)
        ])
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) not implemented") }
}

class MyRecipiePageView: UIView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    // MARK: - UI Components

    let scrollView = UIScrollView()
    let container = UIView()

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
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 14
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        return cv
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }

    // MARK: - Setup

    private func setupView() {
        addSubview(scrollView)
        scrollView.addSubview(container)

        [avatarImageView, usernameLabel, roleLabel, followersLabel, recipesLabel, segmentedControl, collectionView]
            .forEach {
                container.addSubview($0)
                $0.translatesAutoresizingMaskIntoConstraints = false
            }

        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(RecipeCardCell.self, forCellWithReuseIdentifier: "cell")

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        container.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),

            container.topAnchor.constraint(equalTo: scrollView.topAnchor),
            container.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            container.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            container.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            avatarImageView.topAnchor.constraint(equalTo: container.topAnchor, constant: 20),
            avatarImageView.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: 90),
            avatarImageView.heightAnchor.constraint(equalToConstant: 90),

            usernameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 12),
            usernameLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            usernameLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor),

            roleLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 4),
            roleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            roleLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor),

            followersLabel.topAnchor.constraint(equalTo: roleLabel.bottomAnchor, constant: 16),
            followersLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            followersLabel.widthAnchor.constraint(equalTo: container.widthAnchor, multiplier: 0.5),

            recipesLabel.topAnchor.constraint(equalTo: roleLabel.bottomAnchor, constant: 16),
            recipesLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            recipesLabel.widthAnchor.constraint(equalTo: container.widthAnchor, multiplier: 0.5),

            segmentedControl.topAnchor.constraint(equalTo: followersLabel.bottomAnchor, constant: 20),
            segmentedControl.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            segmentedControl.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),

            collectionView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
            collectionView.heightAnchor.constraint(equalToConstant: 900),
            collectionView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -20)
        ])
    }

    // MARK: - Dynamic Update Methods

    func updateUserProfile(_ profile: UserProfile) {
        usernameLabel.text = profile.username
        roleLabel.text = profile.role
        followersLabel.text = "\(profile.followers)\nFollowers"
        recipesLabel.text = "\(profile.recipeCount)\nRecipes"

        if !profile.avatarUrl.isEmpty, let url = URL(string: profile.avatarUrl) {
            URLSession.shared.dataTask(with: url) { data, _, _ in
                if let data = data {
                    DispatchQueue.main.async {
                        self.avatarImageView.image = UIImage(data: data)
                    }
                }
            }.resume()
        }
    }

    // MARK: - Static Simulation Data
    private let mockRecipes = Array(repeating: "Mock", count: 8)

    // MARK: - CollectionView DataSource

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mockRecipes.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! RecipeCardCell
        cell.imageView.image = UIImage(named: "blackPasta") ?? UIImage(systemName: "photo")
        cell.titleLabel.text = "Creamy Tomato Pasta"
        return cell
    }

    // MARK: - Layout

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 10) / 2
        return CGSize(width: width, height: width * 1.2)
    }
}
