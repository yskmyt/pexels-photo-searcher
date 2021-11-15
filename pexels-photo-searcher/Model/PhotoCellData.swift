//
//  PhotoCellData.swift
//  pexels-photo-searcher
//
//  Created by Yusuke Miyata on 2021/11/16.
//  Copyright © 2021 Yusuke Miyata. All rights reserved.
//

import Foundation

struct PhotoCellData {
    let id: Int
    let photographer: String
    let photographerUrl: String
    let imageUrl: String

    init(from data: PhotoData) {
        self.id = data.id
        self.photographer = data.photographer
        self.photographerUrl = data.photographerUrl
        self.imageUrl = data.src.large
    }
}
