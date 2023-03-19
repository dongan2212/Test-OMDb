//
//  MovieResultCollectionCell.swift
//  Test-SmartDev-ODMB
//
//  Created by Vo The Dong An on 19/03/2023.
//

import UIKit

final class MovieResultCollectionCell: UICollectionViewCell {

    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var bgImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var yearLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setupUI(for item: Movie?) {
        guard let item = item else { return }
        self.bgImageView.imageFromURL(path: item.poster.unwrapped(or: ""))
        self.titleLabel.text = item.title
        self.yearLabel.text = "\(item.year.ignoreNil())"
    }
}
