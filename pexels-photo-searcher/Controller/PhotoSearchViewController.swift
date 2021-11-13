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
    @IBOutlet private weak var collectionView: UICollectionView!

    private let disposeBag = DisposeBag()

    private lazy var viewModel = PhotoSearchViewModel(photoAPI: PhotoAPI(),
                                                      searchTextObservable: searchBar.rx.searchText)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        setupCollectionView()
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
            ) { (row, element, cell) in
                cell.configure(element)
                switch(row % 3) {
                    case 1: cell.backgroundColor = .red
                    case 2: cell.backgroundColor = .blue
                    default: cell.backgroundColor = .green
                }

        }
        .disposed(by: disposeBag)
    }

    private func setupCollectionView() {
        setFlowLayout()
        collectionView.register(PhotoCollectionViewCell.self,
                                forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)

        collectionView.rx.modelSelected(PhotoData.self)
            .subscribe(onNext: { print($0) },
                       onError: { error in print(error) },
                       onCompleted: { print("onCompleted") },
                       onDisposed: { print("onDisposed") })
            .disposed(by: disposeBag)
    }

    private func setFlowLayout() {
        let layout = UICollectionViewFlowLayout()
        let itemWitdh = collectionView.bounds.width / CGFloat(3)
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: itemWitdh, height: itemWitdh)
        collectionView.setCollectionViewLayout(layout, animated: true)
    }
}
