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

enum HTTPMethod: String {
    case GET = "GET"
}

protocol IHttpClient {
    func get<T: Decodable>(path: String, parameters: [String:String]?, headers: [String:String]?) -> Observable<T>
}

final class HTTPClient: IHttpClient {
    private let baseUrlString: String

    init(baseUrlString: String) {
        self.baseUrlString = baseUrlString
    }

    func get<T: Decodable>(path: String, parameters: [String:String]?, headers: [String:String]?) -> Observable<T> {
        let request = makeRequest(method: HTTPMethod.GET, path: path, parameters: parameters, headers: headers)
        return URLSession.shared.rx.response(request: request)
            .map { response, data in
                return try JSONDecoder().decode(T.self, from: data)
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

        guard let url = components.url else {
            fatalError("Could not get url")
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Accept")
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
