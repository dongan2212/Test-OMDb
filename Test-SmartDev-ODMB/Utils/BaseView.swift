//
//  BaseView.swift
//  Test-SmartDev-ODMB
//
//  Created by Vo The Dong An on 17/03/2023.
//

import RxCocoa
import RxSwift
import UIKit

class BaseView: UIView {
    // MARK: - Properties
    var contentView: UIView?

    // MARK: - Init
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setup()
    }

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()

        setup()
        contentView?.prepareForInterfaceBuilder()
    }

    func setup() {
        guard let contentView = contentFromXib() else { return }
        self.contentView = contentView
        makeUI()
    }

    func makeUI() { }
}
