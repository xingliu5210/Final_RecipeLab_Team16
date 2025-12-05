import Foundation
import FirebaseFirestore

class MainPageModel {
    var recipes: [Recipe] = []
    private let db = Firestore.firestore()

    func fetchRecipes(completion: @escaping ([Recipe]?, Error?) -> Void) {

        print("DEBUG: Fetching recipes...")

        db.collection("recipes")
            .order(by: "creationTime")
            .getDocuments { snapshot, error in

                if let error = error {
                    print("DEBUG: Firestore error → \(error.localizedDescription)")
                    completion(nil, error)
                    return
                }

                guard let snapshot = snapshot else {
                    print("DEBUG: No snapshot returned")
                    completion([], nil)
                    return
                }

                print("DEBUG: Received \(snapshot.documents.count) documents")

                let recipes = snapshot.documents.compactMap { doc -> Recipe? in
                    do {
                        let recipe = try doc.data(as: Recipe.self)
                        print("DEBUG: Decoded recipe → \(recipe.title)")
                        return recipe
                    } catch {
                        print("DEBUG: Decoding failed for doc \(doc.documentID): \(error)")
                        return nil
                    }
                }
                self.recipes = recipes
                completion(recipes, nil)
            }
    }
}
