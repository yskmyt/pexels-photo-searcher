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
    private(set) var photographer = Observable<String>.empty()

    func setPhotoCellData(_ data: PhotoCellData) {
        self.photographer = Observable.just(data.photographer)
    }
}
