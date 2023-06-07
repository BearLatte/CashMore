//
//  NetworkError.swift
//  CashMore
//
//  Created by Tim on 2023/6/7.
//

struct NetworkError {
    var code = -1
    var localizedDescription : String
    init(code: Int = 1, localizedDescription: String) {
        self.code = code
        self.localizedDescription = localizedDescription
    }
}
