//
//  SearchResult.swift
//  pexels-photo-searcher
//
//  Created by Yusuke Miyata on 2021/11/12.
//  Copyright © 2021 Yusuke Miyata. All rights reserved.
//

import Foundation

// See https://www.pexels.com/api/documentation/#photos-search
struct PhotoSearchResult: Decodable {
    let totalResults: Int
    let page: Int
    let perPage: Int
    let photos: [PhotoData]
    let nextPage: String
}

struct PhotoData: Decodable {
    let photoDataDetail: PhotoDataDetail
    let liked: Bool
}

struct PhotoDataDetail: Decodable {
    let id: Int
    let width: Int
    let height: Int
    let url: String
    let photographer: String
    let photographerUrl: String
    let photographerId: Int
    let avgColor: String
    let src: PhotoSource
}

struct PhotoSource: Decodable {
    let original: String
    let large2x: String
    let large: String
    let medium: String
    let small: String
    let portrait: String
    let landscape: String
    let tiny: String
}

fileprivate enum CodingKeys: String, CodingKey {
    case totalResults = "total_results"
    case perPage = "per_page"
    case nextPage = "next_page"
    case photographerUrl = "photographer_url"
    case photographerId = "photographer_id"
    case avgColor = "avg_color"
}
