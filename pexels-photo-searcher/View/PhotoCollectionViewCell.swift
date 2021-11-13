//
//  PhotoCollectionViewCell.swift
//  pexels-photo-searcher
//
//  Created by Yusuke Miyata on 2021/11/13.
//  Copyright © 2021 Yusuke Miyata. All rights reserved.
//

import UIKit

final class PhotoCollectionViewCell: UICollectionViewCell {
    static var identifier: String {
        return String(describing: self)
    }

    @IBOutlet private weak var testLabel: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadFromNib()

    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadFromNib()
    }

    private func loadFromNib() {
        let nib = UINib(nibName: PhotoCollectionViewCell.identifier,
                        bundle: Bundle(for :PhotoCollectionViewCell.self))
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else {
            return
        }
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        addSubview(view)
    }

    func configure(_ data: PhotoData) {
        testLabel.text = data.photographer
    }

}
