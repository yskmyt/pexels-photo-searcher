//
//  PickedPhotoViewModel.swift
//  pexels-photo-searcher
//
//  Created by Yusuke Miyata on 2021/11/14.
//  Copyright © 2021 Yusuke Miyata. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class PickedPhotoViewModel {
    private(set) var photographer = Observable<String>.empty()
    private(set) var image = Observable<UIImage?>.empty()

    private(set) var photographerUrl = ""

    func setPhotoCellData(_ data: PhotoCellData) {
        self.image = ImageLoader.shared.loadImage(from: data.photoSource.medium)
        self.photographer = Observable.just(data.photographer)
        self.photographerUrl = data.photographerUrl
    }
}

extension PickedPhotoViewModel {
    var openPhotographerUrlBinder: Binder<()> {
        return Binder(self) { base, _  in
            if let url = URL(string: base.photographerUrl) {
                UIApplication.shared.open(url)
            }
        }
    }
}
