//
//  AddRecipiePageView.swift
//  Final_RecipeLab_Team16
//
//  Created by 王敬捷 on 11/16/25.
//

import UIKit

class AddRecipePageView: UIView {

    // MARK: - UI Components

    let container = UIView()
    let formContainer = UIView()
    var selectedImage: UIImage?
    var uploadedImageURL: String?

    // Login prompt label
    let loginPrompt: UILabel = {
        let lbl = UILabel()
        lbl.text = "Please log in to add a recipe"
        lbl.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        lbl.textColor = .darkGray
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
        lbl.isHidden = true // hidden by default
        return lbl
    }()
    
    func showContent() {
        loginPrompt.isHidden = true
        formContainer.isHidden = false
    }
    
    func showLoginPlaceholder() {
        loginPrompt.isHidden = false
        formContainer.isHidden = true
    }


    let uploadContainer: UIView = {
        let v = UIView()
        v.layer.cornerRadius = 12
        v.backgroundColor = UIColor.systemGray6
        v.layer.borderWidth = 1
        v.layer.borderColor = UIColor.systemGray3.cgColor
        v.clipsToBounds = true
        return v
    }()

    let uploadIcon: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "photo.on.rectangle")?.withRenderingMode(.alwaysTemplate)
        iv.tintColor = UIColor.systemGray
        iv.contentMode = .scaleAspectFit
        return iv
    }()

    let uploadLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Tap to upload"
        lbl.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        lbl.textColor = UIColor.systemGray
        lbl.textAlignment = .center
        return lbl
    }()

    let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Title"
        lbl.font = UIFont.boldSystemFont(ofSize: 18)
        return lbl
    }()

    let titleField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Recipe Title"
        tf.borderStyle = .roundedRect
        return tf
    }()

    let cookingTimeLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Cooking Time"
        lbl.font = UIFont.boldSystemFont(ofSize: 18)
        return lbl
    }()

    let cookingTimeField: UITextField = {
        let tf = UITextField()
        tf.keyboardType = .numberPad   // ← IMPORTANT
        tf.placeholder = "Cooking Time (minutes)"
        tf.borderStyle = .roundedRect
        
        // --- NEW: Add Toolbar to Keyboard ---
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        // Flexible space pushes the "Done" button to the right
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        // Call resignFirstResponder to dismiss keyboard when "Done" is tapped
        let doneBtn = UIBarButtonItem(title: "Done", style: .done, target: tf, action: #selector(resignFirstResponder))
                
        toolbar.items = [flexSpace, doneBtn]
        tf.inputAccessoryView = toolbar
        
        return tf
    }()

    let ingredientsLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Ingredients"
        lbl.font = UIFont.boldSystemFont(ofSize: 18)
        return lbl
    }()

    let ingredientsField: UITextView = {
        let tv = UITextView()
        tv.layer.borderWidth = 1
        tv.layer.borderColor = UIColor.systemGray3.cgColor
        tv.layer.cornerRadius = 10
        tv.font = .systemFont(ofSize: 16)
        return tv
    }()
    
    // Dynamic Ingredients
    let ingredientStack = UIStackView()
    let addIngredientButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("+ Add Ingredient", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        btn.tintColor = .systemBlue
        return btn
    }()

    let stepsLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Cooking Steps"
        lbl.font = UIFont.boldSystemFont(ofSize: 18)
        return lbl
    }()

    let stepsField: UITextView = {
        let tv = UITextView()
        tv.layer.borderWidth = 1
        tv.layer.borderColor = UIColor.systemGray3.cgColor
        tv.layer.cornerRadius = 10
        tv.font = .systemFont(ofSize: 16)
        return tv
    }()
    
    // Dynamic Steps
    let stepsStack = UIStackView()
    let addStepButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("+ Add Step", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        btn.tintColor = .systemBlue
        return btn
    }()

    let saveButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Save Recipe", for: .normal)
        btn.backgroundColor = UIColor(named: "Orange")
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = 10
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        return btn
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Layout Setup

    private func setup() {
            // 🛑 REMOVE: addSubview(scrollView) and scrollView.addSubview(container)

            // Add formContainer to self
            addSubview(formContainer)
            formContainer.translatesAutoresizingMaskIntoConstraints = false

            ingredientStack.axis = .vertical
            ingredientStack.spacing = 8
            stepsStack.axis = .vertical
            stepsStack.spacing = 8
            addIngredientButton.addTarget(self, action: #selector(addIngredientRow), for: .touchUpInside)
            addStepButton.addTarget(self, action: #selector(addStepRow), for: .touchUpInside)

            // Add components to formContainer
            [titleLabel, titleField, cookingTimeLabel, cookingTimeField, ingredientsLabel, ingredientStack, addIngredientButton, stepsLabel, stepsStack, addStepButton, uploadContainer, uploadIcon, uploadLabel, saveButton]
                .forEach { component in
                    formContainer.addSubview(component) // 💡 Add to formContainer
                    component.translatesAutoresizingMaskIntoConstraints = false
                }
            
            addSubview(loginPrompt)
            loginPrompt.translatesAutoresizingMaskIntoConstraints = false
            
            // Add upload icon/label inside the upload container
            uploadContainer.addSubview(uploadIcon)
            uploadContainer.addSubview(uploadLabel)
            
            // Add tap gesture recognizer to uploadContainer
            let tap = UITapGestureRecognizer(target: self, action: #selector(didTapUpload))
            uploadContainer.addGestureRecognizer(tap)
            uploadContainer.isUserInteractionEnabled = true
            
            // Set constraints for upload icon/label inside the container
            NSLayoutConstraint.activate([
                // Icon centered
                uploadIcon.centerXAnchor.constraint(equalTo: uploadContainer.centerXAnchor),
                uploadIcon.topAnchor.constraint(equalTo: uploadContainer.topAnchor, constant: 25),
                uploadIcon.widthAnchor.constraint(equalToConstant: 120),
                uploadIcon.heightAnchor.constraint(equalToConstant: 120),

                // Label centered under icon
                uploadLabel.topAnchor.constraint(equalTo: uploadIcon.bottomAnchor, constant: 10),
                uploadLabel.centerXAnchor.constraint(equalTo: uploadContainer.centerXAnchor),
            ])
            
            // Activate main layout constraints
            NSLayoutConstraint.activate([
                // Pin formContainer to self
                formContainer.topAnchor.constraint(equalTo: topAnchor),
                formContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
                formContainer.trailingAnchor.constraint(equalTo: trailingAnchor),
                formContainer.bottomAnchor.constraint(equalTo: bottomAnchor),

                // Title label (Pinning to formContainer.topAnchor)
                titleLabel.topAnchor.constraint(equalTo: formContainer.topAnchor, constant: 20),
                titleLabel.leadingAnchor.constraint(equalTo: formContainer.leadingAnchor, constant: 20),
                titleLabel.trailingAnchor.constraint(equalTo: formContainer.trailingAnchor, constant: -20),

                // Title field
                titleField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
                titleField.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
                titleField.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
                titleField.heightAnchor.constraint(equalToConstant: 44),

                // Cooking time label
                cookingTimeLabel.topAnchor.constraint(equalTo: titleField.bottomAnchor, constant: 20),
                cookingTimeLabel.leadingAnchor.constraint(equalTo: titleField.leadingAnchor),
                cookingTimeLabel.trailingAnchor.constraint(equalTo: titleField.trailingAnchor),

                // Cooking time field
                cookingTimeField.topAnchor.constraint(equalTo: cookingTimeLabel.bottomAnchor, constant: 8),
                cookingTimeField.leadingAnchor.constraint(equalTo: titleField.leadingAnchor),
                cookingTimeField.trailingAnchor.constraint(equalTo: titleField.trailingAnchor),
                cookingTimeField.heightAnchor.constraint(equalToConstant: 44),

                // Ingredients label
                ingredientsLabel.topAnchor.constraint(equalTo: cookingTimeField.bottomAnchor, constant: 20),
                ingredientsLabel.leadingAnchor.constraint(equalTo: titleField.leadingAnchor),
                ingredientsLabel.trailingAnchor.constraint(equalTo: titleField.trailingAnchor),

                // Ingredient stack
                ingredientStack.topAnchor.constraint(equalTo: ingredientsLabel.bottomAnchor, constant: 8),
                ingredientStack.leadingAnchor.constraint(equalTo: titleField.leadingAnchor),
                ingredientStack.trailingAnchor.constraint(equalTo: titleField.trailingAnchor),

                // Add ingredient button
                addIngredientButton.topAnchor.constraint(equalTo: ingredientStack.bottomAnchor, constant: 6),
                addIngredientButton.leadingAnchor.constraint(equalTo: titleField.leadingAnchor),
                addIngredientButton.heightAnchor.constraint(equalToConstant: 30),

                // Steps label
                stepsLabel.topAnchor.constraint(equalTo: addIngredientButton.bottomAnchor, constant: 20),
                stepsLabel.leadingAnchor.constraint(equalTo: titleField.leadingAnchor),
                stepsLabel.trailingAnchor.constraint(equalTo: titleField.trailingAnchor),

                // Steps stack
                stepsStack.topAnchor.constraint(equalTo: stepsLabel.bottomAnchor, constant: 8),
                stepsStack.leadingAnchor.constraint(equalTo: titleField.leadingAnchor),
                stepsStack.trailingAnchor.constraint(equalTo: titleField.trailingAnchor),

                // Add step button
                addStepButton.topAnchor.constraint(equalTo: stepsStack.bottomAnchor, constant: 6),
                addStepButton.leadingAnchor.constraint(equalTo: titleField.leadingAnchor),
                addStepButton.heightAnchor.constraint(equalToConstant: 30),

                // Upload container
                uploadContainer.topAnchor.constraint(equalTo: addStepButton.bottomAnchor, constant: 25),
                uploadContainer.leadingAnchor.constraint(equalTo: titleField.leadingAnchor), // Use existing margins
                uploadContainer.trailingAnchor.constraint(equalTo: titleField.trailingAnchor),
                uploadContainer.heightAnchor.constraint(equalToConstant: 180),

                // Save button
                saveButton.topAnchor.constraint(equalTo: uploadContainer.bottomAnchor, constant: 35),
                saveButton.leadingAnchor.constraint(equalTo: titleField.leadingAnchor),
                saveButton.trailingAnchor.constraint(equalTo: titleField.trailingAnchor),
                saveButton.heightAnchor.constraint(equalToConstant: 50),
                
                // 🔑 CRUCIAL: Pin the bottom-most element to the formContainer's bottom to define content height
                saveButton.bottomAnchor.constraint(equalTo: formContainer.bottomAnchor, constant: -40),
                
                // Login prompt centered
                loginPrompt.centerXAnchor.constraint(equalTo: centerXAnchor),
                loginPrompt.centerYAnchor.constraint(equalTo: centerYAnchor),
                loginPrompt.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
                loginPrompt.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
            ])
        }
    
    // Public method to show login prompt
//    func showLoginPrompt() {
//        loginPrompt.isHidden = false
//    }
    
    @objc private func addIngredientRow() {
        let row = makeRow()
        ingredientStack.addArrangedSubview(row)
    }

    @objc private func addStepRow() {
        let row = makeRow()
        stepsStack.addArrangedSubview(row)
    }

    private func makeRow() -> UIView {
        let row = UIStackView()
        row.axis = .horizontal
        row.spacing = 10

        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.heightAnchor.constraint(equalToConstant: 40).isActive = true

        let removeButton = UIButton(type: .system)
        removeButton.setTitle("–", for: .normal)
        removeButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        removeButton.widthAnchor.constraint(equalToConstant: 35).isActive = true
        removeButton.addTarget(self, action: #selector(removeRow(_:)), for: .touchUpInside)

        row.addArrangedSubview(textField)
        row.addArrangedSubview(removeButton)

        return row
    }

    @objc private func removeRow(_ sender: UIButton) {
        guard let row = sender.superview else { return }
        row.removeFromSuperview()
    }
    
    @objc private func didTapUpload() {
        NotificationCenter.default.post(name: NSNotification.Name("AddRecipePickImage"), object: nil)
    }
    
    func clearInputs() {
        titleField.text = ""
        cookingTimeField.text = ""
        uploadIcon.image = UIImage(systemName: "photo.on.rectangle")
        uploadLabel.text = "Tap to upload"
        uploadedImageURL = nil

        ingredientStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        stepsStack.arrangedSubviews.forEach { $0.removeFromSuperview() }

        addIngredientRow()
        addStepRow()
    }
}
