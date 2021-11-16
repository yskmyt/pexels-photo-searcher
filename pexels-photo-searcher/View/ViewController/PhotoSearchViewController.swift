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
        setupNavigationBar()
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

    private func setupNavigationBar() {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named:"pexelsLogo"), for: .normal)

        let barItem = UIBarButtonItem(customView: button)
        let widthAnchor = barItem.customView?.widthAnchor.constraint(equalToConstant: 96)
        let heightAnchor = barItem.customView?.heightAnchor.constraint(equalToConstant: 40)
        widthAnchor?.isActive = true
        heightAnchor?.isActive = true
        self.navigationItem.leftBarButtonItem = barItem

        button.rx.tap
            .bind(to: openPexelsPageBinder)
            .disposed(by: disposeBag)
    }

    private func setupSearchBar() {
        searchBar.rx.didTapSearchButton
            .bind(to: searchBinder)
            .disposed(by: disposeBag)
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.register(PhotoCollectionViewCell.self,
                                forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)

        collectionView.rx.modelSelected(PhotoCellData.self)
            .bind(to: didSelectPhotoBinder)
            .disposed(by: disposeBag)

        collectionView.rx.contentOffset
            .asDriver()
            .map { [weak self] _ in self?.shouldRequestNextPage() ?? false }
            .distinctUntilChanged()
            .filter { $0 }
            .drive(loadNextPhotoDataBinder)
            .disposed(by: disposeBag)
    }

    private func shouldRequestNextPage() -> Bool {
        let edgeOffset = collectionView.frame.height / 2
        return collectionView.contentSize.height > 0 &&
            collectionView.isNearBottomEdge(edgeOffset: edgeOffset)
    }
}

extension PhotoSearchViewController {
    private var searchBinder: Binder<String> {
        return Binder(self) { base, text  in
            base.viewModel.search(text: text)
        }
    }

    private var loadNextPhotoDataBinder: Binder<Bool> {
        return Binder(self) { base, _  in
            base.viewModel.loadNextPhotoData()
        }
    }

    private var openPexelsPageBinder: Binder<()> {
        return Binder(self) { _, _  in
            if let url = URL(string: Constants.PEXELS_HOME_URL) {
                UIApplication.shared.open(url)
            }
        }
    }

    private var didSelectPhotoBinder: Binder<(PhotoCellData)> {
        return Binder(self) { base, data  in
            guard let viewController = PickedPhotoViewController.instantiate(data: data) else {
                return
            }
            base.navigationController?.pushViewController(viewController, animated: true)
        }
    }
}

extension UIScrollView {
    func isNearBottomEdge(edgeOffset: CGFloat = 20.0) -> Bool {
        return contentOffset.y + frame.size.height + edgeOffset > contentSize.height
    }
}

extension PhotoSearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = collectionView.frame.width - 2
        let width = availableWidth / 2
        return CGSize(width: width, height: width)
    }
}
