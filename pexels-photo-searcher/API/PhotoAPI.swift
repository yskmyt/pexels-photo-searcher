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
    func fetchPhotos(path: String) -> Observable<PhotoSearchResult>
}

final class PhotoAPI: IPhotoAPI {
    private let client = HTTPClient(baseUrlString: "https://api.pexels.com/v1/")
    private let authorizationHeader = ["Authorization": ""]

    func fetchPhotos(path: String) -> Observable<PhotoSearchResult> {
        return client.get(path: path, parameters: nil, headers: authorizationHeader)
    }
}
