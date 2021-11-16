//
//  PhotoSearchViewModelTest.swift
//  pexels-photo-searcherTests
//
//  Created by Yusuke Miyata on 2021/11/16.
//  Copyright © 2021 Yusuke Miyata. All rights reserved.
//

import XCTest
import RxSwift
import RxCocoa

@testable import pexels_photo_searcher

class PhotoSearchViewModelTest: XCTestCase {
    private var viewModel = PhotoSearchViewModel(photoAPI: MockPhotoAPI())
    private let disposeBag = DisposeBag()

    override func setUpWithError() throws {
        viewModel = PhotoSearchViewModel(photoAPI: MockPhotoAPI())
    }

    func testSearch() {
        viewModel.cellDataList
            .asDriver()
            .skip(1)
            .drive {
                XCTAssertEqual(5, $0.count)
            }
            .disposed(by: disposeBag)

        viewModel.search(text: "test")
    }

    func testSearchWithError() {
        setErrorViewModel()

        viewModel.cellDataList
            .asDriver()
            .skip(1)
            .drive {
                XCTAssertEqual(0, $0.count)
            }
            .disposed(by: disposeBag)

        viewModel.search(text: "test")
    }

    func testLoadNextPhotoData() {
        let appendedCellDataList = PhotoSearchResultFactory.generatePhotoDataList(size: 5).map { PhotoCellData.init(from: $0) }
        viewModel.cellDataList.accept(appendedCellDataList)
        viewModel.cellDataList
            .asDriver()
            .skip(1)
            .drive {
                XCTAssertEqual(10, $0.count)
            }
            .disposed(by: disposeBag)

        viewModel.loadNextPhotoData()
    }

    func testLoadNextPhotoDataWithError() {
        setErrorViewModel()

        let appendedCellDataList = PhotoSearchResultFactory.generatePhotoDataList(size: 5).map { PhotoCellData.init(from: $0) }
        viewModel.cellDataList.accept(appendedCellDataList)
        viewModel.cellDataList
            .asDriver()
            .skip(1)
            .drive {
                XCTAssertEqual(10, $0.count)
            }
            .disposed(by: disposeBag)

        viewModel.loadNextPhotoData()
    }

    private func setErrorViewModel() {
        let mockApi = MockPhotoAPI()
        mockApi.isError = true
        viewModel = PhotoSearchViewModel(photoAPI: mockApi)
    }

}
