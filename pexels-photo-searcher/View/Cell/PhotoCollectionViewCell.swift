//
//  PhotoCollectionViewCell.swift
//  pexels-photo-searcher
//
//  Created by Yusuke Miyata on 2021/11/13.
//  Copyright © 2021 Yusuke Miyata. All rights reserved.
//

import UIKit
import RxSwift

final class PhotoCollectionViewCell: UICollectionViewCell {
    static var identifier: String {
        return String(describing: self)
    }

    @IBOutlet private weak var photographerLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!

    private var disposeBag = DisposeBag()

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadFromNib()
        initializeView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadFromNib()
        initializeView()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
        photographerLabel.text = ""
        imageView.image = nil
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

    private func initializeView() {
        self.bringSubviewToFront(contentView)
        imageView.contentMode = .scaleAspectFill
    }

    func configure(_ data: PhotoCellData) {
        photographerLabel.text = "Photo by \(data.photographer)"
        ImageLoader.shared.loadImage(from: data.photoSource.medium)
            .bind(to: imageView.rx.image)
            .disposed(by: disposeBag)
    }
}
