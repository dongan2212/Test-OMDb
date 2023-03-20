//
//  AppAlertViewController.swift
//  Test-SmartDev-ODMB
//
//  Created by Vo The Dong An on 20/03/2023.
//

import UIKit

class AppAlertAction{
    typealias Handler = (AppAlertAction) -> Void

    enum Style {
        case `default`
        case cancel
        case destruction
        case custom(tintColor: UIColor)
    }

    let title: String
    let style: Style
    let handler: Handler?

    init(title: String, style: Style, handler: Handler? = nil) {
        self.title = title
        self.style = style
        self.handler = handler
    }
}

class AppAlertViewController: UIViewController {
    deinit {
        Logger.info("deinit: \(self)")
    }
    // MARK: - Outlets
    @IBOutlet weak var dimmerView: UIView!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var alertContainerView: UIView!
    @IBOutlet weak var alertTitleLabel: UILabel!
    @IBOutlet weak var alertMessageLabel: UILabel!
    @IBOutlet weak var actionStackView: UIStackView!

    // MARK: - Properties
    let maxDimmedAlpha = 0.8
    let alertTitle: String?
    let message: String
    private var actions: [AppAlertAction] = []
    var dismissCallback: (() -> Void)?
    var canDismissOutSide: Bool = true

    // MARK: - Initialization
    init(title: String?, message: String) {
        self.alertTitle = title
        self.message = message
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .overFullScreen
        self.modalTransitionStyle = .crossDissolve
    }

    required init?(coder: NSCoder) {
        self.message = ""
        self.alertTitle = nil
        super.init(coder: coder)
        self.modalPresentationStyle = .overFullScreen
    }

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupActionViews()
    }

    // MARK: - Setup UI
    private func setup() {
        dimmerView.backgroundColor = UIColor.gray.withAlphaComponent(0.22)
        dimmerView.alpha = self.maxDimmedAlpha
        dimmerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissView)))

        alertContainerView.cornerRadius = 14.0

        shadowView.addShadow(cornerRadius: 14,
                             radius: 5,
                             color: UIColor.black.withAlphaComponent(0.1),
                             offset: CGSize(width: 0, height: 4),
                             opacity: 0.3)

        alertTitleLabel.textColor = UIColor.red
        alertTitleLabel.text = self.alertTitle
        alertTitleLabel.font = .systemFont(ofSize: 18, weight: .semibold)

        alertMessageLabel.textColor = UIColor.black
        alertMessageLabel.text = self.message
        alertMessageLabel.numberOfLines = 0
        alertMessageLabel.font = .systemFont(ofSize: 14, weight: .regular)
    }

    private func setupActionViews() {
        if actions.count == 1 {
            let button = getButtonBy(action: actions[0])
            actionStackView.addArrangedSubview(button)
        } else {
            let actionWidth = Float(270 - (1 * actions.count / 2)) / Float(actions.count) // 270 width alert, 1 divider width
            for (index, action) in actions.enumerated() {
                let button = getButtonBy(action: action)
                button.tag = index
                actionStackView.addArrangedSubview(button)
                button.snp.makeConstraints { make in
                    make.width.equalTo(actionWidth)
                }
                if index != actions.count - 1 {
                    // add divider view
                    let dividerView = UIView()
                    dividerView.backgroundColor = UIColor.gray
                    dividerView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
                    actionStackView.addArrangedSubview(dividerView)
                    dividerView.snp.makeConstraints { make in
                        make.width.equalTo(1).priority(750)
                    }
                }
            }
        }
    }

    private func getButtonBy(action: AppAlertAction) -> UIButton {
        let button = UIButton()
        button.setTitle(action.title, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .regular)

        button.addTarget(self, action: #selector(actionButtonTapped(_:)), for: .touchUpInside)

        switch action.style {
        case .default:
            button.setTitleColor(UIColor.black, for: .normal)

        case .cancel:
            button.setTitleColor(UIColor.red, for: .normal)

        case .destruction:
            button.setTitleColor(UIColor.systemBlue, for: .normal)

        case .custom(let tintColor):
            button.setTitleColor(tintColor, for: .normal)
        }

        return button
    }

    // MARK: - Private functions
    private func animateShowDimmedView() {
        dimmerView.alpha = 0
        UIView.animate(withDuration: 0.2, delay: 0.0, options: [.curveLinear]) {
            self.dimmerView.alpha = self.maxDimmedAlpha
        }
    }

    private func animateDismissView(completion: (() -> Void)?) {
        self.dismiss(animated: true, completion: completion)
    }

    // MARK: - Public functions
    func addAction(_ action: AppAlertAction) {
        self.actions.append(action)
    }

    // MARK: - Actions
    @objc func actionButtonTapped(_ sender: UIButton) {
        animateDismissView { [weak self] in
            let index = sender.tag
            if let action = self?.actions[safe: index] {
                action.handler?(action)
            }
        }
    }

    @objc func dismissView() {
        guard canDismissOutSide else { return }
        animateDismissView(completion: { [weak self] in
            self?.dismissCallback?()
        })
    }
}
