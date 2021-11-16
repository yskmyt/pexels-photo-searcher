//
//  MockPhotoAPI.swift
//  pexels-photo-searcherTests
//
//  Created by Yusuke Miyata on 2021/11/16.
//  Copyright © 2021 Yusuke Miyata. All rights reserved.
//

import Foundation
import RxSwift
@testable import pexels_photo_searcher


final class MockPhotoAPI: IPhotoAPI {
    var isError = false
    var mockPerPage = 5

    func fetchPhotoData(searchText: String, perPage: Int) -> Observable<PhotoSearchResult> {
        if (isError) {
            return Observable.error(MockError.any)
        }

        let result = PhotoSearchResultFactory.generatePhotoSearchResult(perPage: mockPerPage)
        return Observable.just(result)
    }

    func fetchNextPhotoData(url: String) -> Observable<PhotoSearchResult> {
        if (isError) {
            return Observable.error(MockError.any)
        }

        let result = PhotoSearchResultFactory.generatePhotoSearchResult(perPage: mockPerPage, isNext: true)
        return Observable.just(result)
    }
}
