//
//  ImageLoader.swift
//  pexels-photo-searcher
//
//  Created by Yusuke Miyata on 2021/11/14.
//  Copyright © 2021 Yusuke Miyata. All rights reserved.
//

// Refer to https://github.com/sgl0v/OnSwiftWings/blob/master/ImageCache.playground/Sources/ImageLoader.swift

import Foundation
import UIKit.UIImage
import RxSwift

public final class ImageLoader {
    public static let shared = ImageLoader()

    private let cache: ImageCacheType
    private lazy var backgroundQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 5
        return queue
    }()

    public init(cache: ImageCacheType = ImageCache()) {
        self.cache = cache
    }

    public func loadImage(from url: URL) -> Observable<UIImage?> {
        if let image = cache[url] {
            return Observable.just(image).single()
        }

        let request = URLRequest(url: url)
        return URLSession.shared.rx.response(request: request)
            .map { (response, data) in UIImage(data: data) }
            .catchAndReturn(nil)
            .do { [unowned self] image in
                guard let image = image else { return }
                self.cache[url] = image
            }
            .asObservable().single()
    }
}
