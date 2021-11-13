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

    private lazy var viewModel = PhotoSearchViewModel(photoAPI: PhotoAPI())

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        setupSearchBar()
        setupCollectionView()
    }


    private func setupBindings() {
        viewModel.cellDataList
            .bind(to: collectionView.rx.items(
                    cellIdentifier: PhotoCollectionViewCell.identifier,
                    cellType: PhotoCollectionViewCell.self)
            ) { (row, element, cell) in
                cell.configure(element)
            }
            .disposed(by: disposeBag)
    }

    private func setupSearchBar() {
        searchBar.rx.searchText
            .flatMap { Observable.just($0) }
            .subscribe(onNext: { [weak self] in self?.viewModel.search(text: $0) })
            .disposed(by: disposeBag)
    }
    
    private func setupCollectionView() {
        setFlowLayout()
        collectionView.register(PhotoCollectionViewCell.self,
                                forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        collectionView.rx
            .modelSelected(PhotoCellData.self)
            .bind { data in
                print(data)
            }
            .disposed(by: disposeBag)
    }

    private func setFlowLayout() {
        let layout = UICollectionViewFlowLayout()
        let itemWidth = (collectionView.bounds.width - CGFloat(30)) / CGFloat(3)
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        collectionView.setCollectionViewLayout(layout, animated: true)
    }
}

