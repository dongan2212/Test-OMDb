//
//  UIView+.swift
//  Test-SmartDev-ODMB
//
//  Created by Vo The Dong An on 17/03/2023.
//

import UIKit

extension UIView {
    class var loadNib: UINib {
        return UINib(nibName: "\(self)", bundle: nil)
    }

    func contentFromXib() -> UIView? {
        guard let contentView = type(of: self).loadNib.instantiate(withOwner: self, options: nil).last as? UIView else {
            return nil
        }

        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(contentView)

        return contentView
    }
}

extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set {
            self.rounded(cornerRadius: newValue)
        }
    }

    @IBInspectable var borderWidth: CGFloat {
        get {
            return self.layer.borderWidth
        }
        set {
            self.layer.borderWidth = newValue
        }
    }

    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: self.layer.borderColor!)
        }
        set {
            self.layer.borderColor = newValue?.cgColor
        }
    }
    
    func roundedUsingWidth() {
        self.rounded(cornerRadius: self.frame.size.width / 2)
    }

    func roundedUsingHeight() {
        self.rounded(cornerRadius: self.frame.size.height / 2)
    }

    func rounded(cornerRadius: CGFloat) {
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = true
    }

    func round(corners: CACornerMask, radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.maskedCorners = corners
    }
}

extension UIView {
    func addShadow(cornerRadius: CGFloat, radius: CGFloat, color: UIColor?, offset: CGSize, opacity: Float) {
        self.layer.cornerRadius = cornerRadius
        self.layer.shadowRadius = radius
        self.layer.shadowColor = color.ignoreNil().cgColor
        self.layer.shadowOffset = offset
        self.layer.shadowOpacity = opacity
        self.clipsToBounds = false
    }

    func addBorder(color: UIColor?, borderWidth: CGFloat = 0) {
        self.layer.borderColor = color.ignoreNil().cgColor
        self.layer.borderWidth = borderWidth
    }
}
