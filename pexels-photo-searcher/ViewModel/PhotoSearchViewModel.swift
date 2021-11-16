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

    init(photoAPI: IPhotoAPI) {
        self.photoAPI = photoAPI
    }

    private(set) var cellDataList = BehaviorRelay<[PhotoCellData]>(value: [])
    private var nextPageUrl = ""

    private let disposeBag = DisposeBag()
    private let perPage = 40

    func search(text: String) {
        photoAPI.fetchPhotoData(searchText: text, perPage: perPage)
            .catchAndReturn(PhotoSearchResult.empty())
            .bind(to: setCellDataList)
            .disposed(by: disposeBag)
    }

    func loadNextPhotoData() {
        guard !nextPageUrl.isEmpty else { return }
        photoAPI.fetchNextPhotoData(url: nextPageUrl)
            .catchAndReturn(PhotoSearchResult.empty())
            .bind(to: appendCellDataList)
            .disposed(by: disposeBag)
    }
}

extension PhotoSearchViewModel {
    private var setCellDataList: Binder<PhotoSearchResult> {
        return Binder(self) { base, result  in
            let cellDataList = base.makeCellData(from: result.photos)
            base.cellDataList.accept(cellDataList)
            base.nextPageUrl = result.nextPage ?? ""
        }
    }

    private var appendCellDataList: Binder<PhotoSearchResult> {
        return Binder(self) { base, result  in
            let currentCellDataList = base.cellDataList.value
            let addedCellDataList = base.makeCellData(from: result.photos)
            base.cellDataList.accept(currentCellDataList + addedCellDataList)
            base.nextPageUrl = result.nextPage ?? ""
        }
    }

    private func makeCellData(from dataList: [PhotoData]) -> [PhotoCellData] {
        dataList.map { PhotoCellData(from: $0) }
    }
}
