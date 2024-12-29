//
//  UIImageView+.swift
//  Test-SmartDev-ODMB
//
//  Created by Vo The Dong An on 19/03/2023.
//

import UIKit
import Kingfisher

extension UIImageView {
    func imageFromURL(path: String?, placeholder: UIImage? = UIImage(named: "img_placeholder_banner")) {
        guard let path = path, !path.isEmpty else {
            self.image = placeholder
            return
        }
        let isImageCached = ImageCache.default.imageCachedType(forKey: path)
        if isImageCached.cached, let image = ImageCache.default.retrieveImageInMemoryCache(forKey: path) {
          self.image = image
        } else {
          guard let url = URL(string: path) else {
              self.image = placeholder
              return
          }
          kf.setImage(with: url, placeholder: placeholder)
        }
    }
}
