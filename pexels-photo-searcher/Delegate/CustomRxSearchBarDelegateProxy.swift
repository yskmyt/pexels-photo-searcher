//
//  RxUISearchBarDelegateProxy.swift
//  pexels-photo-searcher
//
//  Created by Yusuke Miyata on 2021/11/12.
//  Copyright © 2021 Yusuke Miyata. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

extension Reactive where Base: UISearchBar {
    public var delegate: DelegateProxy<UISearchBar, UISearchBarDelegate> {
        return CustomRxSearchBarDelegateProxy.proxy(for: base)
    }

    public var searchBarSearchButtonClicked: Observable<Void> {
        return CustomRxSearchBarDelegateProxy.proxy(for: base).searchBarSearchButtonClickedSubject.asObservable()
    }

    public var searchText: Observable<String> {
        return delegate.methodInvoked(#selector(UISearchBarDelegate.searchBarSearchButtonClicked(_:)))
            .map { any in
                guard let searchBar = any.first as? UISearchBar else {
                    return ""
                }
                searchBar.resignFirstResponder()
                return searchBar.text ?? ""
            }
    }
}

public class CustomRxSearchBarDelegateProxy: DelegateProxy<UISearchBar, UISearchBarDelegate>, DelegateProxyType, UISearchBarDelegate {
    public init(searchBar: UISearchBar) {
        super.init(parentObject: searchBar, delegateProxy: CustomRxSearchBarDelegateProxy.self)
    }

    public static func registerKnownImplementations() {
        self.register { CustomRxSearchBarDelegateProxy(searchBar: $0) }
    }

    internal lazy var searchBarSearchButtonClickedSubject = PublishSubject<Void>()

    public func searchBarSearchButtonClicked() {
        searchBarSearchButtonClickedSubject.onNext(())
    }

    deinit {
        self.searchBarSearchButtonClickedSubject.on(.completed)
    }
}
