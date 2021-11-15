//
//  HTTPClient.swift
//  pexels-photo-searcher
//
//  Created by Yusuke Miyata on 2021/11/12.
//  Copyright © 2021 Yusuke Miyata. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import UIKit

protocol IHttpClient {
    func get<T: Decodable>(responseType: T.Type, path: String, headers: [String:String]?) -> Observable<T>
    func get<T: Decodable>(responseType: T.Type, url: String, headers: [String:String]?) -> Observable<T>
}

final class HTTPClient: IHttpClient {
    private let baseUrlString: String

    init(baseUrlString: String) {
        self.baseUrlString = baseUrlString
    }

    //　for path only url
    func get<T: Decodable>(responseType: T.Type, path: String, headers: [String:String]?) -> Observable<T> {
        let wrapUrl = wrapUrl(path)
        let request = makeRequest(method: HTTPMethod.GET, url: wrapUrl, headers: headers)
        return URLSession.shared.rx.response(request: request)
            .map { (response, data) in
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                return try decoder.decode(T.self, from: data)
            }
            .asObservable()
            .single()
    }

    //　for protocol include url
    func get<T: Decodable>(responseType: T.Type, url: String, headers: [String:String]?) -> Observable<T> {
        let request = makeRequest(method: HTTPMethod.GET, url: url, headers: headers)
        return URLSession.shared.rx.response(request: request)
            .map { (response, data) in
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                return try decoder.decode(T.self, from: data)
            }
            .asObservable()
            .single()
    }
}

extension HTTPClient {
    private func wrapUrl(_ url: String) -> String {
        self.baseUrlString + url
    }

    private func makeRequest(method: HTTPMethod, url: String, headers: [String:String]?) -> URLRequest {
        guard let encodedString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: encodedString) else {
            fatalError("Unable to convert \(url) to URL")
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        return setHeader(headers: headers, request: request)
    }

    private func setHeader(headers: [String:String]?, request: URLRequest) -> URLRequest {
        var _request = request

        if let headers = headers {
            for (key, value) in headers {
                _request.setValue(value, forHTTPHeaderField: key)
            }
        }
        return _request
    }
}

enum HTTPMethod: String {
    case GET = "GET"
}

enum HTTPError: Error {
    case jsonDecode
}
