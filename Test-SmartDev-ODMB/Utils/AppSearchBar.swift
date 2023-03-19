//
//  AppSearchBar.swift
//  Test-SmartDev-ODMB
//
//  Created by Vo The Dong An on 19/03/2023.
//

import UIKit
import RxSwift

class AppSearchBar: UITextField {
    private var clearButton: UIButton!

    var disposeBag = DisposeBag()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        binding()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
        binding()
    }

    private func setup() {
        disposeBag = DisposeBag()

        let leftView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 30.0, height: frame.height)))
        let searchIcon = UIImageView(frame: CGRect(x: 4, y: 7, width: 24.0, height: 22.0))
        searchIcon.center.y = leftView.center.y
//        searchIcon.image = AppImage.icSearchBar.image
        searchIcon.contentMode = .center
        leftView.addSubview(searchIcon)

        self.leftView = leftView
        self.leftViewMode = .always

        let rightView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 29.0, height: frame.height)))

        clearButton = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: 21.0, height: frame.height)))
//        clearButton.setImage(AppImage.icClearText.image, for: .normal)
        clearButton.contentMode = .center
        clearButton.center = rightView.center
        clearButton.addTarget(self, action: #selector(clearButtonTapped(_:)), for: .touchUpInside)
        rightView.addSubview(clearButton)

        self.rightView = rightView
        self.rightViewMode = .never

        self.enablesReturnKeyAutomatically = true
        self.clearButtonMode = .never
        self.borderStyle = .none
        self.textColor = UIColor.black
        self.returnKeyType = .search
    }

    private func binding() {
        let textChange = self.rx.text.asDriver()

        let isShowClearButton = textChange
            .map({ $0?.count ?? 0 > 0 })

        isShowClearButton
            .drive(onNext: { [weak self] isShow in
                self?.rightViewMode = isShow ? .always : .never
            })
            .disposed(by: disposeBag)
    }

    @objc
    private func clearButtonTapped(_ sender: UIButton) {
        self.text = ""
        self.sendActions(for: .valueChanged)
        self.becomeFirstResponder()
    }
}
