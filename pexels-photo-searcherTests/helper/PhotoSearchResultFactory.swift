//
//  PhotoSearchResultFactory.swift
//  pexels-photo-searcherTests
//
//  Created by Yusuke Miyata on 2021/11/16.
//  Copyright © 2021 Yusuke Miyata. All rights reserved.
//

import Foundation
@testable import pexels_photo_searcher

final class PhotoSearchResultFactory {
    static func generatePhotoSearchResult(perPage: Int, isNext: Bool = false) -> PhotoSearchResult {
        let totalResults = perPage * 2
        let page = isNext ? 2 : 1
        let nextPage = isNext ? "" : "nextPage"
        let prevPage = isNext ? "prevPage" : ""
        return PhotoSearchResult(totalResults: totalResults,
                                 page: page,
                                 perPage: perPage,
                                 photos: generatePhotoDataList(size: perPage),
                                 nextPage: nextPage,
                                 prevPage: prevPage)
    }

    static func generatePhotoDataList(size: Int) -> [PhotoData] {
        return (1...size).map { return generatePhotoData(num: $0) }
    }

    static func generatePhotoData(num: Int) -> PhotoData {
        return PhotoData(id: num,
                         width: num,
                         height: num,
                         url: "url\(num)",
                         photographer: "photographer-\(num)",
                         photographerUrl: "photographerUrl-\(num)",
                         photographerId: num*1000,
                         avgColor: "",
                         src: PhotoSource(original: "original",
                                          large2x: "large2x",
                                          large: "large",
                                          medium: "medium",
                                          small: "small",
                                          portrait: "portrait",
                                          landscape: "landscape",
                                          tiny: "tiny"),
                         liked: false)
    }
}
