//
//  PhotoAPI.swift
//  pexels-photo-searcher
//
//  Created by Yusuke Miyata on 2021/11/12.
//  Copyright © 2021 Yusuke Miyata. All rights reserved.
//

import Foundation
import RxSwift

protocol IPhotoAPI {
    func fetchPhotos(searchText: String, perPage: Int, page: Int) -> Observable<PhotoSearchResult>
}

final class PhotoAPI: IPhotoAPI {
    private let client = HTTPClient(baseUrlString: "https://api.pexels.com/v1/")
    private let authorizationHeader = ["Authorization": "563492ad6f917000010000010cc68d895d954cce83553bc14c009f0e"]

    func fetchPhotos(searchText: String, perPage: Int, page: Int) -> Observable<PhotoSearchResult> {
        let path = "/search?query=\(searchText)&per_page=\(perPage)&page=\(page)"
        return client.get(path: path, parameters: nil, headers: authorizationHeader)
    }
}
