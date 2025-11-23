import FirebaseFirestore
//
//  Recipe.swift
//  Final_RecipeLab_Team16
//
//  Created by 应秀秀 on 11/23/25.
//

struct Recipe {
    let id: String
    let title: String
    let imageUrl: String
    let cookingTime: String
    let ingredients: [String]
    let steps: [String]
    let userId: String          // recipe owner
    let createdAt: Timestamp
}
