//
//  Utils.swift
//  Final_RecipeLab_Team16
//
//  Created by 王敬捷 on 12/5/25.
//

import UIKit

extension UIImageView {

    /// Loads an image from a URL string. Supports optional URL and placeholder.
    func loadImage(
        from urlString: String?,
        placeholderNamed placeholder: String? = nil
    ) {
        // Apply placeholder first
        if let placeholder = placeholder {
            self.image = UIImage(named: placeholder)
        }

        // Ensure non-empty valid URL string
        guard let urlString = urlString,
              let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
            guard error == nil,
                  let data = data,
                  let downloaded = UIImage(data: data) else { return }

            DispatchQueue.main.async {
                self.image = downloaded
            }
        }.resume()
    }

    /// Convenience method for URL type
    func loadImage(
        from url: URL?,
        placeholderNamed placeholder: String? = nil
    ) {
        loadImage(from: url?.absoluteString, placeholderNamed: placeholder)
    }
}
