import Foundation
import FirebaseFirestore

class MyRecipiePageModel {

    private let db = Firestore.firestore()

    // Fetch all recipes created by a given userId
    func fetchRecipesByUserId(_ userId: String, completion: @escaping (Result<[Recipe], Error>) -> Void) {
        db.collection("recipes")
            .whereField("userId", isEqualTo: userId)
            .getDocuments { snapshot, error in
                print("DEBUG: Fetching recipes for userId =", userId)
                if let error = error {
                    print("DEBUG: Firestore error:", error.localizedDescription)
                    completion(.failure(error))
                    return
                }

                guard let documents = snapshot?.documents else {
                    print("DEBUG: No documents found for userId =", userId)
                    completion(.success([]))
                    return
                }

                let recipes: [Recipe] = documents.compactMap { doc in
                    try? doc.data(as: Recipe.self)
                }
                print("DEBUG: Decoded \(recipes.count) recipes for userId =", userId)

                completion(.success(recipes))
            }
    }

    // Fetch all recipes liked by a given userId
    func fetchLikedRecipes(by userId: String, completion: @escaping (Result<[Recipe], Error>) -> Void) {
        db.collection("recipes")
            .getDocuments { snapshot, error in
                print("DEBUG: Fetching liked recipes for userId =", userId)
                if let error = error {
                    print("DEBUG: Error fetching liked recipes:", error.localizedDescription)
                    completion(.failure(error))
                    return
                }

                guard let documents = snapshot?.documents else {
                    print("DEBUG: No documents found while fetching liked recipes")
                    completion(.success([]))
                    return
                }

                let allRecipes: [Recipe] = documents.compactMap { doc in
                    try? doc.data(as: Recipe.self)
                }
                print("DEBUG: Total recipes loaded =", allRecipes.count)

                let likedRecipes = allRecipes.filter { recipe in
                    recipe.likedBy.keys.contains(userId)
                }
                print("DEBUG: Liked recipes count =", likedRecipes.count)

                completion(.success(likedRecipes))
            }
    }
}
