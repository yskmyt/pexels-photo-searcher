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
            .subscribe(onNext: { [unowned self] in
                self.viewModel.search(text: $0)
            })
            .disposed(by: disposeBag)

        viewModel.photos
            .bind(to: collectionView.rx.items(
                    cellIdentifier: PhotoCollectionViewCell.identifier,
                    cellType: PhotoCollectionViewCell.self)
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
        collectionView.rx
            .modelSelected(PhotoData.self)
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

