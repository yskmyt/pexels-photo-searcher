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
        setupBindings()
        setupNavigationBar()
        setupImageView()
    }

    private func setupBindings() {
        viewModel.photographer
            .bind(to: navigationItem.rx.title)
            .disposed(by: disposeBag)
        
        viewModel.image
            .bind(to: imageView.rx.image)
            .disposed(by: disposeBag)
    }

    private func setupNavigationBar() {
        let button = UIButton(type: .system)
        button.setTitle("More", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        let barItem = UIBarButtonItem(customView: button)
        let widthAnchor = barItem.customView?.widthAnchor.constraint(equalToConstant: 72)
        let heightAnchor = barItem.customView?.heightAnchor.constraint(equalToConstant: 44)
        widthAnchor?.isActive = true
        heightAnchor?.isActive = true
        self.navigationItem.rightBarButtonItem = barItem

        button.rx.tap
            .bind(to: viewModel.openPhotographerUrlBinder)
            .disposed(by: disposeBag)

    }

    private func setupImageView() {
        imageView.contentMode = .scaleAspectFit
    }
}
