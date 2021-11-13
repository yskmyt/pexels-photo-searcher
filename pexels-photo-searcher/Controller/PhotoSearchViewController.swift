//
//  PhotoSearchViewController.swift
//  pexels-photo-searcher
//
//  Created by Yusuke Miyata on 2021/11/12.
//  Copyright © 2021 Yusuke Miyata. All rights reserved.
//

import UIKit
import RxSwift

final class PhotoSearchViewController: UIViewController {
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var collectionView: UICollectionView! {
        didSet {
            collectionView.register(PhotoCollectionViewCell.self,
                                    forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        }
    }

    private let disposeBag = DisposeBag()

    private lazy var viewModel = PhotoSearchViewModel(photoAPI: PhotoAPI(),
                                                      searchTextObservable: searchBar.rx.searchText)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
    }


    private func setupBindings() {
        viewModel.searchText
            .subscribe(onNext: {
                self.viewModel.search(text: $0)
            })
            .disposed(by: disposeBag)

        viewModel.photos
            .asDriver(onErrorJustReturn: [])
            .drive(
                collectionView.rx.items(
                    cellIdentifier: PhotoCollectionViewCell.identifier,
                    cellType: PhotoCollectionViewCell.self
                )
            ) { (_, element, cell) in
                cell.configure(element)
        }
        .disposed(by: disposeBag)
    }
}
