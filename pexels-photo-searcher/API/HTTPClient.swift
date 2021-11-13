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

enum HTTPMethod: String {
    case GET = "GET"
}

protocol IHttpClient {
    func get<T: Decodable>(responseType: T.Type, path: String, parameters: [String:String]?, headers: [String:String]?) -> Observable<T>
}

final class HTTPClient: IHttpClient {
    private let baseUrlString: String

    init(baseUrlString: String) {
        self.baseUrlString = baseUrlString
    }

    func get<T: Decodable>(responseType: T.Type, path: String, parameters: [String:String]?, headers: [String:String]?) -> Observable<T> {
        let request = makeRequest(method: HTTPMethod.GET, path: path, parameters: parameters, headers: headers)
        return URLSession.shared.rx.response(request: request)
            .map { response, data in
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                return try decoder.decode(T.self, from: data)
        }
        .asObservable()
    }

    func getImage(url: String, headers: [String:String]?) -> Observable<UIImage> {
        guard let url = URL(string: url) else {
            return Observable<UIImage>.of(UIImage())
        }
        let request = URLRequest(url: url)
        return URLSession.shared.rx.response(request: request)
            .map { response, data in
                return UIImage(data: data) ?? UIImage()
            }
            .asObservable()
    }
}

extension HTTPClient {
    private func makeRequest(method: HTTPMethod, path: String, parameters: [String:String]?, headers: [String:String]?) -> URLRequest {
        guard let baseURL = URL(string: baseUrlString) else {
            fatalError("Unable to convert \(baseUrlString) to URL")
        }

        guard var components = URLComponents(url: baseURL.appendingPathComponent(path), resolvingAgainstBaseURL: false) else {
            fatalError("Unable to create URL components")
        }

        components.queryItems = parameters?.map {
            URLQueryItem(name: String($0), value: String($1))
        }

        guard let urlString = components.url?.absoluteString.removingPercentEncoding,
            let url = URL(string: urlString) else {
                fatalError("Could not get url")
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
