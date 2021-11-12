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
                                                      searchTextObservable: searchBar.rx.text.asObservable())

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        bind()
    }

    private func bind() {
        viewModel.searchText
            .bind(to: searchBar.rx.text)
            .disposed(by: disposeBag)
    }
}

extension PhotoSearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
