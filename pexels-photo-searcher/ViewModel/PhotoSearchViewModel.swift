//
//  PhotoSearchViewModel.swift
//  pexels-photo-searcher
//
//  Created by Yusuke Miyata on 2021/11/12.
//  Copyright © 2021 Yusuke Miyata. All rights reserved.
//

import RxSwift

final class PhotoSearchViewModel {
    private let photoAPI: IPhotoAPI
    let searchText: Observable<String>

    init(photoAPI: IPhotoAPI, searchTextObservable: Observable<String?>) {
        self.photoAPI = photoAPI
        self.searchText = searchTextObservable
            .distinctUntilChanged()
            .flatMap { text -> Observable<String> in
                if let text = text {
                    return .just(text)
                }
                return .empty()
            }
    }
}
