//
//  PickedPhotoViewController.swift
//  pexels-photo-searcher
//
//  Created by Yusuke Miyata on 2021/11/14.
//  Copyright © 2021 Yusuke Miyata. All rights reserved.
//

import UIKit
import RxSwift

class PickedPhotoViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!

    private lazy var viewModel = PickedPhotoViewModel()

    private let disposeBag = DisposeBag()

    static func instantiate(data: PhotoCellData) -> PickedPhotoViewController? {
        guard let viewController: PickedPhotoViewController = UIStoryboard(name: "PickedPhotoViewController", bundle: nil).instantiateInitialViewController() else {
            return nil
        }
        viewController.viewModel.setPhotoCellData(data)
        return viewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupImageView()
        setupBindings()
    }

    private func setupBindings() {
        viewModel.photographer
            .bind(to: navigationItem.rx.title)
            .disposed(by: disposeBag)
        
        viewModel.image
            .bind(to: imageView.rx.image)
            .disposed(by: disposeBag)
    }

    private func setupImageView() {
        imageView.contentMode = .scaleAspectFit
    }
}
