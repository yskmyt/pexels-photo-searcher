//
//  SearchResult.swift
//  pexels-photo-searcher
//
//  Created by Yusuke Miyata on 2021/11/12.
//  Copyright © 2021 Yusuke Miyata. All rights reserved.
//

import Foundation

// See https://www.pexels.com/api/documentation/#photos-search
struct PhotoSearchResult: Codable {
    let totalResults: Int
    let page: Int
    let perPage: Int
    let photos: [PhotoData]
    let nextPage: String?
    let prevPage: String?
}

struct PhotoData: Codable {
    let id: Int
    let width: Int
    let height: Int
    let url: String
    let photographer: String
    let photographerUrl: String
    let photographerId: Int
    let avgColor: String
    let src: PhotoSource
    let liked: Bool
}

struct PhotoSource: Codable {
    let original: String
    let large2x: String
    let large: String
    let medium: String
    let small: String
    let portrait: String
    let landscape: String
    let tiny: String
}
