//
//  NetworkRequest.swift
//  CashMore
//
//  Created by Tim on 2023/6/7.
//

import Foundation
import Alamofire

class NetworkRequest {
    /// Alamofire.DataRequest
    var request: Alamofire.Request?
    /// API description information. default: nil
    var description: String?
    /// API additional information, eg: Author | Note...,  default: nil
    var extra: String?

    /// request response callback
    private var successHandler: SuccessClosure?
    /// request failed callback
    private var failedHandler: FailedClosure?
    /// `ProgressHandler` provided for upload/download progress callbacks.
    private var progressHandler: ProgressClosure?

    // MARK: - Handler

    /// Handle request response
    func handleResponse(response: AFDataResponse<String>) {
        switch response.result {
        case .failure(let error):
            if let closure = failedHandler {
                let hwe = NetworkError(code: error.responseCode ?? -1, localizedDescription: error.localizedDescription)
                closure(hwe)
            }
        case .success(let jsonString):
            if let baseModel = JSONDeserializer<BaseModel>.deserializeFrom(json: jsonString),
               let closure = successHandler {
                closure(baseModel)
            }
        }
        clearReference()
    }

    /// Processing request progress (Only when uploading files)
    func handleProgress(progress: Foundation.Progress) {
        if let closure = progressHandler {
            closure(progress)
        }
    }

    // MARK: - Callback

    /// Adds a handler to be called once the request has finished.
    ///
    /// - Parameters:
    ///   - closure: A closure to be executed once the request has finished.
    ///
    /// - Returns:             The request.
    @discardableResult
    public func success(_ closure: @escaping SuccessClosure) -> Self {
        successHandler = closure
        return self
    }

    /// Adds a handler to be called once the request has finished.
    ///
    /// - Parameters:
    ///   - closure: A closure to be executed once the request has finished.
    ///
    /// - Returns:             The request.
    @discardableResult
    public func failed(_ closure: @escaping FailedClosure) -> Self {
        failedHandler = closure
        return self
    }

    /// Sets a closure to be called periodically during the lifecycle of the instance as data is sent to the server.
    ///
    /// - Note: Only the last closure provided is used.
    ///
    /// - Parameters:
    ///   - closure: The closure to be executed periodically as data is sent to the server.
    ///
    /// - Returns:   The instance.
    @discardableResult
    public func progress(closure: @escaping ProgressClosure) -> Self {
        progressHandler = closure
        return self
    }

    /// Cancels the instance. Once cancelled, a `Request` can no longer be resumed or suspended.
    ///
    /// - Returns: The instance.
    func cancel() {
        request?.cancel()
    }

    /// Free memory
    func clearReference() {
        successHandler = nil
        failedHandler = nil
        progressHandler = nil
    }
}

extension NetworkRequest : Equatable {
    static func == (lhs: NetworkRequest, rhs: NetworkRequest) -> Bool {
        return lhs.request?.id == rhs.request?.id
    }
}
