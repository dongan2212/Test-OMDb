//
//  MovieResultViewController.swift
//  Test-SmartDev-ODMB
//
//  Created by Vo The Dong An on 19/03/2023.
//

import UIKit
import RxSwift
import RxCocoa

final class MovieResultViewController: ViewController {
    // MARK: - Outlets
    @IBOutlet private weak var emptyContainerView: UIView!
    @IBOutlet private weak var emptyLabel: UILabel!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var searchBarContainerView: UIView!
    @IBOutlet private weak var searchBarTextField: AppSearchBar!
    @IBOutlet private weak var collectionViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet private weak var searchButton: UIButton!
    
    // MARK: - Properties
    private var viewModel: MovieResultViewModel
    let minYOffset: CGFloat = 45.0
    let buttonHeight: CGFloat = 48.0

    init(viewModel: MovieResultViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        observableKeyboardHeight()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNavigationBar(animated: true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        showNavigationBar(bgColor: .white, animated: true)
    }

    // MARK: - Setup
    override func makeUI() {
        emptyContainerView.isHidden = true
        emptyLabel.text = "Empty Result"
        emptyLabel.textColor = UIColor.red
        emptyLabel.font = UIFont.systemFont(ofSize: 14.0)

        setupSearchButton()
        setupSearchTextField()
        setupCollectionView()
    }

    private func setupSearchTextField() {
        searchBarContainerView.rounded(cornerRadius: 10)
        searchBarContainerView.backgroundColor = UIColor.white

        let attributedPlaceholder = NSAttributedString(string: "Search by title",
                                                       attributes: [
                                                                        .font: UIFont.systemFont(ofSize: 18),
                                                                        .foregroundColor: UIColor.gray
                                                       ])

        searchBarTextField.attributedPlaceholder = attributedPlaceholder
        searchBarTextField.font = UIFont.systemFont(ofSize: 18)
        searchBarTextField.textColor = UIColor.black
        searchBarTextField.tintColor = UIColor.blue

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
            self.searchBarTextField.becomeFirstResponder()
        }
    }

    private func setupSearchButton() {
        searchButton.setTitleColor(UIColor.blue, for: .highlighted)
        searchButton.setTitle("Search", for: .normal)
    }

    private func setupCollectionView() {
        collectionView.register(MovieResultCollectionCell.self)
        collectionView.rx.setDelegate(self).disposed(by: disposeBag)
    }

    // MARK: - Binding
    override func bindingData() {
        super.bindingData()
        let submitSearchAction = searchBarTextField.rx.controlEvent(.editingDidEndOnExit)
        let tapOnSearchButtonAction = searchButton.rx.tap
        let input = MovieResultViewModel.Input(
            loadTrigger: .just(()),
            searchTextTrigger: searchBarTextField.value(),
            submitSearchAction: submitSearchAction.asDriver(),
            tapOnSearchButtonAction: tapOnSearchButtonAction.asDriver()
        )

        let output = viewModel.transform(input: input)
        output.appError
            .drive(self.rx.appError)
            .disposed(by: disposeBag)

        output.isEmpty
            .drive(onNext: { [weak self] isEmpty in
            self?.emptyContainerView.isHidden = !isEmpty
            self?.collectionView.isHidden = isEmpty
//            self?.scrollButton.isHidden = isEmpty
        }).disposed(by: disposeBag)

        output
            .movies
            .drive(collectionView.rx.items) { collectionView, index, item in
            let cell = collectionView.dequeueReusableCell(MovieResultCollectionCell.self,
                                                          for: .init(item: index, section: 0))
            cell.setupUI(for: item)
            return cell
        }.disposed(by: disposeBag)
    }

    // MARK: - Private function
    private func observableKeyboardHeight() {
        let keyboardShowHeight = NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
            .map({ [weak self] notification -> CGFloat in
            guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
                return 0.0
            }
            return keyboardFrame.cgRectValue.height - (self?.view.safeAreaInsets.bottom ?? 0.0)
        })

        let keyboardHideHeight = NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)
            .map { _ -> CGFloat in 0.0 }

        let keyboardOnScreenHeight = Observable.from([keyboardShowHeight, keyboardHideHeight]).merge()

        keyboardOnScreenHeight
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] keyboardHeight in
            DispatchQueue.main.async {
                self?.collectionViewBottomConstraint.constant = keyboardHeight + 24.0
                UIView.animate(withDuration: 0.2) {
                    self?.view.layoutIfNeeded()
                }
            }
        }).disposed(by: disposeBag)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension MovieResultViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.collectionView.frame.width - 20
        let widthPerItem = width / 2
        let heightPerItem = widthPerItem * 4 / 3
        return CGSize(width: widthPerItem, height: heightPerItem)
    }
}


// MARK: - UIScrollViewDelegate
extension MovieResultViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let yOffset = scrollView.contentOffset.y
//        if yOffset < minYOffset {
//            self.scrollButton.alpha = 0
//        } else {
            // get y offset start from min y
//            let newOffset = yOffset - minYOffset
//            let alpha = min(1, (newOffset / buttonHeight))
//            self.scrollButton.alpha = alpha
//        }
//        self.scrollButton.isEnabled = self.scrollButton.alpha == 1
    }
}
