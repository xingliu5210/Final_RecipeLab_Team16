import UIKit

class AddRecipiePageController: BaseViewController {
    private let rootView = AddRecipePageView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setContent(rootView)
    }
}
