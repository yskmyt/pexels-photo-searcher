//
//  PhotoAPI.swift
//  pexels-photo-searcher
//
//  Created by Yusuke Miyata on 2021/11/12.
//  Copyright © 2021 Yusuke Miyata. All rights reserved.
//

import Foundation
import RxSwift
import UIKit

protocol IPhotoAPI {
    func fetchPhotoData(searchText: String, perPage: Int) -> Observable<PhotoSearchResult>
    func fetchNextPhotoData(url: String) -> Observable<PhotoSearchResult>
}

final class PhotoAPI: IPhotoAPI {
    private let client = HTTPClient(baseUrlString: "https://api.pexels.com/v1")
    private let authorizationHeader = ["Authorization": "563492ad6f917000010000010cc68d895d954cce83553bc14c009f0e"]

    func fetchPhotoData(searchText: String, perPage: Int) -> Observable<PhotoSearchResult> {
        let path = "/search?query=\(searchText)&per_page=\(perPage)&page=1"
        return client.get(responseType: PhotoSearchResult.self,
                          path: path,
                          headers: authorizationHeader)
    }

    func fetchNextPhotoData(url: String) -> Observable<PhotoSearchResult> {
        return client.get(responseType: PhotoSearchResult.self,
                          url: url,
                          headers: authorizationHeader)
    }
}
