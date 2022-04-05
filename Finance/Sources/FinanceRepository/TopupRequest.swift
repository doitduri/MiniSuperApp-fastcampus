//
//  File.swift
//  
//
//  Created by 김두리 on 2022/03/28.
//

import Foundation
import Network

struct TopupRequest: Request {
    typealias Output = TopupResponse
    // Output -> 서버에서 준 데이터 타입을 struct로 표현한 것
    
    var endpoint: URL
    var method: HTTPMethod
    var query: QueryItems
    var header: HTTPHeader
    
    init(baseURL: URL, amount: Double, paymentMethodID: String) {
        self.endpoint = baseURL.appendingPathComponent("/topup")
        self.method = .post
        self.query = [
            "amount": amount,
            "paymentMethodId": paymentMethodID
        ]
        self.header = [:]
    }
}

struct TopupResponse: Decodable {
    let status: String
}
