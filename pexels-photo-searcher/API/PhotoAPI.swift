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
    func fetchPhotoData(searchText: String, page: Int, perPage: Int) -> Observable<PhotoSearchResult>
    func downloadImage(url: String) -> Observable<UIImage>
}

final class PhotoAPI: IPhotoAPI {
    private let client = HTTPClient(baseUrlString: "https://api.pexels.com/v1")
    private let authorizationHeader = ["Authorization": "563492ad6f917000010000010cc68d895d954cce83553bc14c009f0e"]

    func fetchPhotoData(searchText: String, page: Int, perPage: Int) -> Observable<PhotoSearchResult> {
        let path = "/search?query=\(searchText)&per_page=\(perPage)&page=\(page)"
        return client.get(responseType: PhotoSearchResult.self,
                          path: path,
                          parameters: nil,
                          headers: authorizationHeader)
    }

    func downloadImage(url: String) -> Observable<UIImage> {
        return client.getImage(url: url, headers: authorizationHeader)
    }
}
