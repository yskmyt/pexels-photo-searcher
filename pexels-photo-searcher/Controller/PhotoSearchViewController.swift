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
            .bind { [weak self] data in self?.didSelectPhoto(data) }
            .disposed(by: disposeBag)

        collectionView.rx.contentOffset.asDriver()
            .map { [unowned self] _ in self.shouldRequestNextPage()}
            .distinctUntilChanged()
            .filter { $0 }
            .drive(onNext: { [weak self] _ in self?.viewModel.loadNextPhotoData() })
            .disposed(by: disposeBag)
    }

    private func shouldRequestNextPage() -> Bool {
        let edgeOffset = collectionView.frame.height / CGFloat(3)
        return collectionView.contentSize.height > 0 &&
            collectionView.isNearBottomEdge(edgeOffset: edgeOffset)
    }

    private func setFlowLayout() {
        let layout = UICollectionViewFlowLayout()
        let itemWidth = (collectionView.bounds.width - CGFloat(30)) / CGFloat(3)
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        collectionView.setCollectionViewLayout(layout, animated: true)
    }

    private func didSelectPhoto(_ data: PhotoCellData) {
        guard let viewController = PickedPhotoViewController.instantiate(data: data) else {
            return
        }
        navigationController?.pushViewController(viewController, animated: true)
    }
}

