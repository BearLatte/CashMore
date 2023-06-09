//
//  NetworkApi.swift
//  CashMore
//
//  Created by Tim on 2023/6/7.
//

import Foundation
import Alamofire

enum ApiHTTPMethod {
    case delete, get, put, post, patch
}

protocol APIProtocol {
    /// API URL address
    var url: String { get }
    /// API description information
    var description: String { get }
    /// API additional information, eg: Author | Note...
    var extra: String? { get }
    /// Type representing HTTP methods.
    var method: ApiHTTPMethod { get }
}

extension APIProtocol {
    /// 根据`APIProtocol`进行一个网络请求
    ///
    /// - Parameters:
    ///   - parameters: `nil` by default.
    ///   - headers: `HTTPHeaders` value to be added to the `URLRequest`. `nil` by default.
    ///   - success: Successful response
    ///   - failed: Failed response
    ///
    func fetch(_ parameters: [String: Any]? = nil, headers: [String: Any]? = nil, success: SuccessClosure?, failed: FailedClosure?) {
        let task = NTTool.fetch(self, parameters: parameters)
        if let s = success {
            task.success(s)
        }
        if let f = failed {
            task.failed(f)
        }
    }
    
    /// 根据`APIProtocol`进行一个网络请求
    ///
    /// - Parameters:
    ///   - parameters: `nil` by default.
    ///   - headers: `HTTPHeaders` value to be added to the `URLRequest`. `nil` by default.
    ///
    func fetch(_ parameters: [String: Any]? = nil, headers: [String: Any]? = nil) -> NetworkRequest {
        NTTool.fetch(self, parameters: parameters)
    }
    
    func fetchHeaders() -> [String : String]? {
        var header : [String : String] = [:]
        header["lang"] = "id"
        header["token"] = Constants.token
        guard let data = try? JSONSerialization.data(withJSONObject: Constants.deviceInfo),
              let deviceInfoStr = String(data: data, encoding: .utf8) else {
            return header
        }
        
        header["deviceInfo"] = deviceInfoStr
        return header
    }
}

/// 为了`APIProtocol`给`NetworkTool`扩展的网络请求方法
extension NetworkTool {
    /// Creates a request, for `APIProtocol`
    ///
    /// - note: more see: `self.request(...)`
    @discardableResult
    func fetch(_ api: APIProtocol, parameters: [String: Any]? = nil) -> NetworkRequest {
        let method = methodWith(api.method)
        let task = request(url: api.url, method: method, parameters: parameters, headers: api.fetchHeaders())
        task.description = api.description
        task.extra = api.extra
        return task
    }
}

private func methodWith(_ m: ApiHTTPMethod) -> Alamofire.HTTPMethod {
    // case delete, get, patch, post, put
    switch m {
    case .delete: return .delete
    case .get: return .get
    case .patch: return .patch
    case .post: return .post
    case .put: return .put
    }
}
