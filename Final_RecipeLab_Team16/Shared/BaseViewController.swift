import UIKit
import FirebaseCore
import FirebaseAuth
import GoogleSignIn

class BaseViewController: UIViewController {
    let scrollView = UIScrollView()
    let contentContainer = UIView()
    private var loginButton: UIButton?
    private var userImageView: UIImageView?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "Beige")
        setupNavBar()
        _ = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            self?.updateUserStateUI(user: user)
        }
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(startGoogleLogin),
            name: Notification.Name("GoogleLoginRequested"),
            object: nil
        )
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        contentContainer.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.addSubview(contentContainer)
        
        navigationController?.navigationBar.tintColor = .white
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])

        NSLayoutConstraint.activate([
            contentContainer.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentContainer.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentContainer.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentContainer.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentContainer.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
        ])
    }

    // MARK: - Public API for child controllers
    func setContent(_ view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        contentContainer.addSubview(view)

        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: contentContainer.topAnchor),
            view.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: contentContainer.bottomAnchor)
        ])
    }

    private func setupNavBar() {
        // MARK: - Title (Chef + RecipeLab)
        let chef = UIImageView(image: UIImage(named: "chiefimage (1)"))
        chef.contentMode = .scaleAspectFit
        chef.translatesAutoresizingMaskIntoConstraints = false
        chef.widthAnchor.constraint(equalToConstant: 40).isActive = true
        chef.heightAnchor.constraint(equalToConstant: 40).isActive = true

        let logo = UIImageView(image: UIImage(named: "RecipeLabText (1)"))
        logo.contentMode = .scaleAspectFit
        logo.translatesAutoresizingMaskIntoConstraints = false
        logo.widthAnchor.constraint(equalToConstant: 120).isActive = true
        logo.heightAnchor.constraint(equalToConstant: 40).isActive = true

        let titleStack = UIStackView(arrangedSubviews: [chef, logo])
        titleStack.axis = .horizontal
        titleStack.spacing = 6
        titleStack.alignment = .center

        navigationItem.titleView = titleStack

        // MARK: - Login Button
        let loginButton = UIButton(type: .system)
        loginButton.setTitle("Login", for: .normal)
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        loginButton.layer.cornerRadius = 8

        var config = UIButton.Configuration.plain()
        config.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8)
        loginButton.configuration = config

        loginButton.addTarget(self, action: #selector(loginPressed), for: .touchUpInside)

        self.loginButton = loginButton
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: loginButton)

        // MARK: - Navigation Bar Appearance
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(named: "Orange")
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]

        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
    }

    @objc private func loginPressed() {
        NotificationCenter.default.post(name: Notification.Name("GoogleLoginRequested"), object: nil)
    }

    @objc private func startGoogleLogin() {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            print("Missing Firebase client ID")
            return
        }

        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        GIDSignIn.sharedInstance.signIn(withPresenting: self) { result, error in
            if let error = error {
                print("Google Sign-in failed: \(error.localizedDescription)")
                return
            }

            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString else {
                print("Missing ID token")
                return
            }

            let credential = GoogleAuthProvider.credential(
                withIDToken: idToken,
                accessToken: user.accessToken.tokenString
            )

            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    print("Firebase sign-in error: \(error.localizedDescription)")
                    return
                }

                print("Login success:", authResult?.user.uid ?? "No UID")
            }
        }
    }

    private func updateUserStateUI(user: User?) {
        if let user = user {
            showUserAvatar(photoURL: user.photoURL)
        } else {
            showLoginButton()
        }
    }

    private func showLoginButton() {
        guard let loginButton = self.loginButton else { return }

        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: loginButton)
    }

    private func showUserAvatar(photoURL: URL?) {
        let imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        imgView.layer.cornerRadius = 16
        imgView.widthAnchor.constraint(equalToConstant: 32).isActive = true
        imgView.heightAnchor.constraint(equalToConstant: 32).isActive = true

        imgView.loadImage(from: photoURL, placeholderNamed: "chiefimage (1)")

        let tap = UITapGestureRecognizer(target: self, action: #selector(logoutPressed))
        imgView.isUserInteractionEnabled = true
        imgView.addGestureRecognizer(tap)

        self.userImageView = imgView
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: imgView)
    }

    @objc private func logoutPressed() {
        do {
            try Auth.auth().signOut()
            print("Logged out")
        } catch {
            print("Logout failed: \(error)")
        }
    }
}
