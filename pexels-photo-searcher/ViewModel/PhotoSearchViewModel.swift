//
//  PhotoSearchViewModel.swift
//  pexels-photo-searcher
//
//  Created by Yusuke Miyata on 2021/11/12.
//  Copyright © 2021 Yusuke Miyata. All rights reserved.
//

import RxSwift
import RxCocoa

final class PhotoSearchViewModel {
    private let photoAPI: IPhotoAPI

    private(set) var cellDataList = BehaviorRelay<[PhotoCellData]>(value: [])

    private let disposeBag = DisposeBag()

    private let perPage = 20
    private var currentPage = 1
    
    init(photoAPI: IPhotoAPI) {
        self.photoAPI = photoAPI
    }

    func search(text: String) {
        photoAPI.fetchPhotoData(searchText: text, page: 1, perPage: perPage)
            .subscribe(onNext: { [weak self] result in
                self?.downloadImages(result.photos)
                self?.currentPage = 1
            })
            .disposed(by: disposeBag)
    }

    private func downloadImages(_ photoDataList: [PhotoData]) {
        photoDataList.forEach { downloadImage($0) }
    }

    private func downloadImage(_ data: PhotoData) {
        photoAPI.downloadImage(url: data.src.medium)
            .subscribe(onNext: { [weak self] image in
                let cellData = self?.makeCellData(data: data, image: image)
                self?.appendCellData(cellData)
            })
            .disposed(by: disposeBag)
    }

    private func makeCellData(data: PhotoData, image: UIImage) -> PhotoCellData {
        return PhotoCellData(id: data.id,
                             photographer: data.photographer,
                             photographerUrl: data.photographerUrl,
                             image: image)
    }

    private func appendCellData(_ appendData: PhotoCellData?) {
        guard let data = appendData else { return }
        let current = cellDataList.value
        cellDataList.accept(current + [data])
    }
}

struct PhotoCellData {
    let id: Int
    let photographer: String
    let photographerUrl: String
    let image: UIImage
}
