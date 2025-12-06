//
//  AddRecipiePageModel.swift
//  Final_RecipeLab_Team16
//
//  Created by 王敬捷 on 11/16/25.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class AddRecipiePageModel {

    private let db = Firestore.firestore()

    func addRecipe(_ recipe: Recipe, completion: @escaping (Result<String, Error>) -> Void) {
        do {
            let data = try Firestore.Encoder().encode(recipe)
            var ref: DocumentReference? = nil
            ref = db.collection("recipes").addDocument(data: data) { error in
                if let error = error {
                    completion(.failure(error))
                } else if let id = ref?.documentID {
                    completion(.success(id))
                }
            }
        } catch {
            completion(.failure(error))
        }
    }
}
