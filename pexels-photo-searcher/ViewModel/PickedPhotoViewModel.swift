//
//  PickedPhotoViewModel.swift
//  pexels-photo-searcher
//
//  Created by Yusuke Miyata on 2021/11/14.
//  Copyright © 2021 Yusuke Miyata. All rights reserved.
//

import Foundation
import RxSwift

final class PickedPhotoViewModel {
    private(set) var image = Observable<UIImage?>.empty()
    private(set) var photographer = Observable<String>.empty()
    private(set) var data = Observable<PhotoCellData>.empty()

    func setPhotoCellData(_ data: PhotoCellData) {
        self.data = Observable.just(data)
        self.photographer = Observable.just(data.photographer)
        self.image = ImageLoader.shared.loadImage(from: data.imageUrl)
    }
}
