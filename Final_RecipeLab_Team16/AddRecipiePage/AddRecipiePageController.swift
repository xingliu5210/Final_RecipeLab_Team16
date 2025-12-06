import UIKit
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

class AddRecipiePageController: BaseViewController {
    private let rootView = AddRecipePageView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setContent(rootView)
        rootView.saveButton.addTarget(self, action: #selector(saveRecipe), for: .touchUpInside)
        
        NotificationCenter.default.addObserver(self, selector: #selector(openImagePicker), name: NSNotification.Name("AddRecipePickImage"), object: nil)
        
        // Remove old prompt if exists
        view.viewWithTag(999)?.removeFromSuperview()

        _ = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            guard let self = self else { return }

            DispatchQueue.main.async {
                if let user = user {
                    // Logged in → show content
                    let profile = UserProfile(
                        id: user.uid,
                        username: user.displayName ?? "Unknown",
                        avatarUrl: user.photoURL?.absoluteString
                    )
                    self.rootView.showContent()
                } else {
                    // Logged out → show placeholder
                    self.rootView.showLoginPlaceholder()
                }
            }
        }
    }
    
    @objc private func openImagePicker() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true)
    }
    
    func uploadImageToFirebase(_ image: UIImage, completion: @escaping (Result<String, Error>) -> Void) {
        guard let data = image.jpegData(compressionQuality: 0.8) else {
            completion(.failure(NSError(domain: "Image", code: -1)))
            return
        }
        let ref = Storage.storage().reference().child("recipes/\(UUID().uuidString).jpg")
        ref.putData(data, metadata: nil) { _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            ref.downloadURL { url, error in
                if let url = url {
                    completion(.success(url.absoluteString))
                } else {
                    completion(.failure(error ?? NSError()))
                }
            }
        }
    }
    
    @objc private func saveRecipe() {

        guard let user = Auth.auth().currentUser else {
            print("User not logged in")
            return
        }

        guard let title = rootView.titleField.text, !title.isEmpty else {
            print("Missing title")
            return
        }

        guard let timeText = rootView.cookingTimeField.text,
              let cookingTime = Int(timeText) else {
            print("Invalid cooking time")
            return
        }

        guard let imageUrl = rootView.uploadedImageURL else {
            print("Image not uploaded")
            return
        }

        let ingredients: [String] = rootView.ingredientStack.arrangedSubviews.compactMap { row in
            guard let stack = row as? UIStackView else { return nil }
            guard let tf = stack.arrangedSubviews.first(where: { $0 is UITextField }) as? UITextField else { return nil }
            let text = tf.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            return (text?.isEmpty == false) ? text : nil
        }

        let steps: [String] = rootView.stepsStack.arrangedSubviews.compactMap { row in
            guard let stack = row as? UIStackView else { return nil }
            guard let tf = stack.arrangedSubviews.first(where: { $0 is UITextField }) as? UITextField else { return nil }
            let text = tf.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            return (text?.isEmpty == false) ? text : nil
        }

        let recipe = Recipe(
            id: nil,
            title: title,
            imageUrl: imageUrl,
            cookingTime: cookingTime,
            ingredients: ingredients,
            steps: steps,
            userName: user.displayName ?? "Unknown",
            userId: user.uid,
            creationTime: Timestamp(date: Date()),
            userImageUrl: user.photoURL?.absoluteString ?? "",
            likedBy: [:]
        )

        let model = AddRecipiePageModel()

        model.addRecipe(recipe) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let id):
                    print("Recipe saved with ID:", id)
                    self.rootView.clearInputs()
                    NotificationCenter.default.post(name: NSNotification.Name("Refresh"), object: nil)
                    self.tabBarController?.selectedIndex = 2
                case .failure(let error):
                    print("Save failed:", error.localizedDescription)
                }
            }
        }
    }
}

extension AddRecipiePageController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true)
        guard let image = info[.originalImage] as? UIImage else { return }
        rootView.uploadIcon.image = image
        rootView.uploadLabel.text = "Uploading..."
        self.rootView.saveButton.isEnabled = false
        self.rootView.saveButton.alpha = 0.5
        uploadImageToFirebase(image) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let url):
                    self?.rootView.uploadedImageURL = url
                    self?.rootView.uploadLabel.text = "Uploaded"
                    self?.rootView.saveButton.isEnabled = true
                    self?.rootView.saveButton.alpha = 1.0
                case .failure:
                    self?.rootView.uploadLabel.text = "Upload failed"
                    self?.rootView.saveButton.isEnabled = true
                    self?.rootView.saveButton.alpha = 1.0
                }
            }
        }
    }
}
