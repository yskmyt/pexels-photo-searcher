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

    private var nextPageUrl = ""
    
    init(photoAPI: IPhotoAPI) {
        self.photoAPI = photoAPI
    }

    func search(text: String) {
        self.cellDataList.accept([])
        photoAPI.fetchPhotoData(searchText: text, perPage: perPage)
            .subscribe(onNext: { [weak self] result in
                let cellDataList = self?.makeCellData(from: result.photos) ?? []
                self?.cellDataList.accept(cellDataList)
                self?.nextPageUrl = result.nextPage ?? ""
            })
            .disposed(by: disposeBag)
    }

    func loadNextPhotoData() {
        guard !nextPageUrl.isEmpty else { return }
        photoAPI.fetchNextPhotoData(url: nextPageUrl)
            .subscribe(onNext: { [weak self] result in
                let currentCellDataList = self?.cellDataList.value ?? []
                let addedCellDataList = self?.makeCellData(from: result.photos) ?? []
                self?.cellDataList.accept(currentCellDataList + addedCellDataList)
                self?.nextPageUrl = result.nextPage ?? ""
            })
            .disposed(by: disposeBag)
    }

    private func makeCellData(from dataList: [PhotoData]) -> [PhotoCellData] {
        return dataList.map { data in
            PhotoCellData(id: data.id,
                          photographer: data.photographer,
                          photographerUrl: data.photographerUrl,
                          imageUrl: data.src.medium)
        }
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
    let imageUrl: String
}
