//
//  NetworkTool.swift
//  CashMore
//
//  Created by Tim on 2023/6/7.
//

import Foundation
import Alamofire

typealias SuccessClosure = (_ networkModel: BaseModel) -> Void
typealias FailedClosure  = (_ error: NetworkError) -> Void
typealias ProgressClosure = (Progress) -> Void


enum ReachabilityStatus {
    /// It is unknown whether the network is reachable.
    case unknown
    /// The network is not reachable.
    case notReachable
    /// The connection type is either over Ethernet or WiFi.
    case ethernetOrWiFi
    /// The connection type is a cellular connection.
    case cellular
}

let NTTool = NetworkTool.shared

let kNetworkStatusNotification = Notification.Name(rawValue: "kNetworkStatusNotification")

class NetworkTool {
    static let shared = NetworkTool()
    private(set) var taskQueue = [NetworkRequest]()
    var sessionManager : Alamofire.Session!
    var reachability: NetworkReachabilityManager?
    var networkStatus: ReachabilityStatus = .unknown
    
    // MARK: - Core Method
    private init() {
        let config = URLSessionConfiguration.af.default
        config.timeoutIntervalForRequest = 20  // Timeout interval
        config.timeoutIntervalForResource = 20  // Timeout interval
        sessionManager = Alamofire.Session(configuration: config)
    }
    
    func request(url: String,
                 method: HTTPMethod = .get,
                 parameters: [String: Any]?,
                 headers: [String: String]? = nil,
                 encoding: ParameterEncoding = URLEncoding.default) -> NetworkRequest {
        let task = NetworkRequest()
        var h : HTTPHeaders?
        if let tempHeaders = headers {
            h = HTTPHeaders(tempHeaders)
        }
        
        // config parameters
        Constants.debugLog("请求地址: \(url)\n请求头:\(headers ?? [:])\n请求体: \(parameters ?? [:])\n请求方式: \(method)\n ")
        sessionManager
            .request(url, method: method, parameters: parameters, encoding: encoding, headers: h)
            .validate()
            .responseString { [weak self] response in
                task.handleResponse(response: response)
                if let index = self?.taskQueue.firstIndex(of: task) {
                    self?.taskQueue.remove(at: index)
                }
            }
        taskQueue.append(task)
        return task
    }
    
    func upload(url: String, method: HTTPMethod = .post, parameters: [String: String]?, datas: [MultipartData], headers: [String: String]? = nil) -> NetworkRequest {
        let task = NetworkRequest()

        var h: HTTPHeaders?
        if let tempHeaders = headers {
            h = HTTPHeaders(tempHeaders)
        }
        
        sessionManager.upload(multipartFormData: { (multipartData) in
            // 1.参数 parameters
            if let parameters = parameters {
                for p in parameters {
                    multipartData.append(p.value.data(using: .utf8)!, withName: p.key)
                }
            }
            // 2.数据 datas
            for d in datas {
                multipartData.append(d.data, withName: d.name, fileName: d.fileName, mimeType: d.mimeType)
            }
        }, to: url, method: method, headers: h).uploadProgress(queue: .main) { progress in
            task.handleProgress(progress: progress)
        }
        .validate()
        .responseString { [weak self] response in
            task.handleResponse(response: response)
            if let index = self?.taskQueue.firstIndex(of: task) {
                self?.taskQueue.remove(at: index)
            }
        }
        taskQueue.append(task)
        return task
    }
    
    func download(url: String, method: HTTPMethod = .post) -> NetworkRequest {
        // has not been implemented
        fatalError("download(...) has not been implemented")
    }
    
    func cancelAllRequests(completingOnQueue queue: DispatchQueue = .main, completion: (() -> Void)? = nil) {
        sessionManager.cancelAllRequests(completingOnQueue: queue, completion: completion)
    }
}

/// Shortcut method for `NetworkTool`
extension NetworkTool {

    /// Creates a POST request
    ///
    /// - note: more see: `self.request(...)`
    @discardableResult
    public func POST(url: String, parameters: [String: Any]? = nil, headers: [String: String]? = nil) -> NetworkRequest {
        request(url: url, method: .post, parameters: parameters, headers: nil)
    }

    /// Creates a POST request for upload data
    ///
    /// - note: more see: `self.request(...)`
    @discardableResult
    public func POST(url: String, parameters: [String: String]? = nil, headers: [String: String]? = nil, datas: [MultipartData]? = nil) -> NetworkRequest {
        guard datas != nil else {
            return request(url: url, method: .post, parameters: parameters, headers: nil)
        }
        return upload(url: url, parameters: parameters, datas: datas!, headers: headers)
    }

    /// Creates a GET request
    ///
    /// - note: more see: `self.request(...)`
    @discardableResult
    public func GET(url: String, parameters: [String: Any]? = nil, headers: [String: String]? = nil) -> NetworkRequest {
        request(url: url, method: .get, parameters: parameters, headers: nil)
    }
}

/// Detect network status
extension NetworkTool {
    /// Starts monitoring for changes in network reachability status.
    public func startMonitoring() {
        if reachability == nil {
            reachability = NetworkReachabilityManager.default
        }

        reachability?.startListening(onQueue: .main, onUpdatePerforming: { [unowned self] (status) in
            switch status {
            case .notReachable:
                self.networkStatus = .notReachable
            case .unknown:
                self.networkStatus = .unknown
            case .reachable(.ethernetOrWiFi):
                self.networkStatus = .ethernetOrWiFi
            case .reachable(.cellular):
                self.networkStatus = .cellular
            }
            // Sent notification
            NotificationCenter.default.post(name: kNetworkStatusNotification, object: nil)
            Constants.debugLog("HWNetworking Network Status: \(self.networkStatus)")
        })
    }

    /// Stops monitoring for changes in network reachability status.
    public func stopMonitoring() {
        guard reachability != nil else { return }
        reachability?.stopListening()
    }
}





