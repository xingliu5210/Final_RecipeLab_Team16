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
        let filename = "\(UUID().uuidString).jpg"
        let storagePath = "recipes/\(filename)"
        let ref = Storage.storage().reference().child(storagePath)
        ref.putData(data, metadata: nil) { _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            let cdnUrl = "https://dark-voice-c973.immactavish.workers.dev/\(storagePath)"
            completion(.success(cdnUrl))
        }
    }
    
    // MARK: - Helper Function
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Opps!", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
    }
    
    @objc private func saveRecipe() {
        // 1. Check user login status
        guard let user = Auth.auth().currentUser else {
            showAlert(message: "You need to be logged in to save a recipe.")
            return
        }

        // 2. Validate Title (cannot be empty after trimming whitespace)
        guard let title = rootView.titleField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !title.isEmpty else {
            showAlert(message: "Please enter a recipe title.")
            return
        }

        // 3. Validate Cooking Time (must be a number > 0)
        guard let timeText = rootView.cookingTimeField.text,
                let cookingTime = Int(timeText),
                cookingTime > 0 else {
            showAlert(message: "Please enter a valid positive cooking time.")
            return
        }

        // 4. Validate Ingredients (Filter empty lines, require at least one valid item)
        let ingredients: [String] = rootView.ingredientStack.arrangedSubviews.compactMap { row in
            guard let stack = row as? UIStackView else { return nil }
            guard let tf = stack.arrangedSubviews.first(where: { $0 is UITextField }) as? UITextField else { return nil }
            let text = tf.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            return (text?.isEmpty == false) ? text : nil
        }

        if ingredients.isEmpty {
            showAlert(message: "Please add at least one ingredient.")
            return
        }

        // 5. Validate Steps (Same logic as ingredients)
        let steps: [String] = rootView.stepsStack.arrangedSubviews.compactMap { row in
            guard let stack = row as? UIStackView else { return nil }
            guard let tf = stack.arrangedSubviews.first(where: { $0 is UITextField }) as? UITextField else { return nil }
            let text = tf.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            return (text?.isEmpty == false) ? text : nil
        }
            
        if steps.isEmpty {
            showAlert(message: "Please add at least one cooking step.")
            return
        }

        // 6. Validate if image is uploaded
        guard let imageUrl = rootView.uploadedImageURL else {
            showAlert(message: "Please upload a photo of your recipe.")
            return
        }

        // --- Validation Passed, Start Saving Logic ---
            
        // Show Loading State (Disable button to prevent double-tap)
        rootView.saveButton.isEnabled = false
        rootView.saveButton.setTitle("Saving...", for: .normal)

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

        model.addRecipe(recipe) { [weak self] result in
            DispatchQueue.main.async {
                // Re-enable the button regardless of success or failure
                self?.rootView.saveButton.isEnabled = true
                self?.rootView.saveButton.setTitle("Save Recipe", for: .normal)
                    
                switch result {
                case .success(let id):
                    print("Recipe saved with ID:", id)
                    // Feedback on success
                    let alert = UIAlertController(title: "Success", message: "Recipe published successfully!", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                        self?.rootView.clearInputs()
                        NotificationCenter.default.post(name: NSNotification.Name("Refresh"), object: nil)
                        self?.tabBarController?.selectedIndex = 2
                    }))
                    self?.present(alert, animated: true)
                        
                case .failure(let error):
                    self?.showAlert(message: "Failed to save: \(error.localizedDescription)")
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
