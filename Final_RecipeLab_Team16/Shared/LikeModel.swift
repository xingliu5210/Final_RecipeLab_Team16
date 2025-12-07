import Foundation
import FirebaseFirestore

class LikeModel {

    private let db = Firestore.firestore()

    func likeRecipe(recipeId: String, userId: String, completion: @escaping (Error?) -> Void) {
        let ref = db.collection("recipes").document(recipeId)
        ref.updateData([
            "likedBy.\(userId)" : NSNull()
        ]) { error in
            completion(error)
        }
    }

    func unlikeRecipe(recipeId: String, userId: String, completion: @escaping (Error?) -> Void) {
        let ref = db.collection("recipes").document(recipeId)
        ref.updateData([
            "likedBy.\(userId)" : FieldValue.delete()
        ]) { error in
            completion(error)
        }
    }
}
