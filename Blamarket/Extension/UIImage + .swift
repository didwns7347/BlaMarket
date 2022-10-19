//
//  UIImage + .swift
//  Blamarket
//
//  Created by yangjs on 2022/10/19.
//

import UIKit
extension UIImage {
    func imageResized(to size: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
