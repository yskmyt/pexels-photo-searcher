//
//  PhotoSearchViewModel.swift
//  pexels-photo-searcher
//
//  Created by Yusuke Miyata on 2021/11/12.
//  Copyright © 2021 Yusuke Miyata. All rights reserved.
//

import RxSwift
import RxCocoa

final class PhotoSearchViewModel {
    private let photoAPI: IPhotoAPI
    let searchText: Observable<String>

    private(set) var photos = BehaviorRelay<[PhotoData]>(value: [])

    private let disposeBag = DisposeBag()

    private let perPage = 20
    private var currentPage = 1
    
    init(photoAPI: IPhotoAPI,
         searchTextObservable: Observable<String>) {
        self.photoAPI = photoAPI
        self.searchText = searchTextObservable
    }

    func search(text: String) {
        photoAPI.fetchPhotos(searchText: text, page: 1, perPage: perPage)
            .subscribe(onNext: { [unowned self] result in
                self.setPhotos(result.photos)
                self.currentPage = 1
            })
            .disposed(by: disposeBag)
    }

    func loadMorePhotos(text: String) {
        photoAPI.fetchPhotos(searchText: text, page: currentPage + 1, perPage: perPage)
            .subscribe(onNext: { [unowned self] result in
                self.appendPhotos(result.photos)
                self.currentPage += 1
            })
            .disposed(by: disposeBag)
    }

    private func setPhotos(_ items: [PhotoData]) {
        photos.accept(items)
    }

    private func appendPhotos(_ addedItems: [PhotoData]) {
        let current = photos.value
        photos.accept(current + addedItems)
    }
}
