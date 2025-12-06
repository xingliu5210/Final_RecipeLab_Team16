//
//  Final_RecipeLab_Team16
//
//  Created by 王敬捷 on 12/6/25.
//

import UIKit

extension UIViewController {
    func topMost() -> UIViewController {
        if let presented = presentedViewController {
            return presented.topMost()
        }
        if let nav = self as? UINavigationController {
            return nav.visibleViewController?.topMost() ?? nav
        }
        if let tab = self as? UITabBarController {
            return tab.selectedViewController?.topMost() ?? tab
        }
        return self
    }
}



extension UIViewController {
    var presentedChain: UIViewController {
        if let presented = self.presentedViewController {
            return presented.presentedChain
        }
        if let nav = self as? UINavigationController {
            return nav.visibleViewController?.presentedChain ?? nav
        }
        if let tab = self as? UITabBarController {
            return tab.selectedViewController?.presentedChain ?? tab
        }
        return self
    }
}


extension UIApplication {
    var keyWindowPresentedController: UIViewController? {
        return self.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first(where: { $0.isKeyWindow })?
            .rootViewController?
            .presentedChain
    }
}
