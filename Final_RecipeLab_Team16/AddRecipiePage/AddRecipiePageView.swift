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
        tf.placeholder = "Cooking Time (e.g., 20 min)"
        tf.borderStyle = .roundedRect
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

            // Add components directly to this view (self)
            [titleLabel, titleField, cookingTimeLabel, cookingTimeField, ingredientsLabel, ingredientsField, stepsLabel, stepsField, uploadContainer, uploadIcon, uploadLabel, saveButton]
                .forEach { component in
                    addSubview(component) // 💡 Add to self, not container
                    component.translatesAutoresizingMaskIntoConstraints = false
                }
            
            // Add upload icon/label inside the upload container
            uploadContainer.addSubview(uploadIcon)
            uploadContainer.addSubview(uploadLabel)
            
            // Set constraints for upload icon/label inside the container
            NSLayoutConstraint.activate([
                // Icon centered
                uploadIcon.centerXAnchor.constraint(equalTo: uploadContainer.centerXAnchor),
                uploadIcon.topAnchor.constraint(equalTo: uploadContainer.topAnchor, constant: 25),
                uploadIcon.widthAnchor.constraint(equalToConstant: 60),
                uploadIcon.heightAnchor.constraint(equalToConstant: 60),

                // Label centered under icon
                uploadLabel.topAnchor.constraint(equalTo: uploadIcon.bottomAnchor, constant: 10),
                uploadLabel.centerXAnchor.constraint(equalTo: uploadContainer.centerXAnchor),
            ])
            
            // Activate main layout constraints
            NSLayoutConstraint.activate([
                // Title label (Pinning to self.topAnchor)
                titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20),
                titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
                titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),

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

                // Ingredients field
                ingredientsField.topAnchor.constraint(equalTo: ingredientsLabel.bottomAnchor, constant: 8),
                ingredientsField.leadingAnchor.constraint(equalTo: titleField.leadingAnchor),
                ingredientsField.trailingAnchor.constraint(equalTo: titleField.trailingAnchor),
                ingredientsField.heightAnchor.constraint(equalToConstant: 180),

                // Steps label
                stepsLabel.topAnchor.constraint(equalTo: ingredientsField.bottomAnchor, constant: 20),
                stepsLabel.leadingAnchor.constraint(equalTo: titleField.leadingAnchor),
                stepsLabel.trailingAnchor.constraint(equalTo: titleField.trailingAnchor),

                // Cooking Steps field
                stepsField.topAnchor.constraint(equalTo: stepsLabel.bottomAnchor, constant: 8),
                stepsField.leadingAnchor.constraint(equalTo: titleField.leadingAnchor),
                stepsField.trailingAnchor.constraint(equalTo: titleField.trailingAnchor),
                stepsField.heightAnchor.constraint(equalToConstant: 220),

                // Upload container
                uploadContainer.topAnchor.constraint(equalTo: stepsField.bottomAnchor, constant: 25),
                uploadContainer.leadingAnchor.constraint(equalTo: titleField.leadingAnchor), // Use existing margins
                uploadContainer.trailingAnchor.constraint(equalTo: titleField.trailingAnchor),
                uploadContainer.heightAnchor.constraint(equalToConstant: 180),

                // Save button
                saveButton.topAnchor.constraint(equalTo: uploadContainer.bottomAnchor, constant: 35),
                saveButton.leadingAnchor.constraint(equalTo: titleField.leadingAnchor),
                saveButton.trailingAnchor.constraint(equalTo: titleField.trailingAnchor),
                saveButton.heightAnchor.constraint(equalToConstant: 50),
                
                // 🔑 CRUCIAL: Pin the bottom-most element to the view's bottom to define content height
                saveButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -40)
            ])
        }
    }
