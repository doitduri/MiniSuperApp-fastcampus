//
//  AddCardRequest.swift
//  MiniSuperApp
//
//  Created by 김두리 on 2022/03/28.
//

import Foundation
import Network
import FinanceEntity

struct AddCardRequest: Request {
    typealias Output = AddCardResponse

    let endpoint: URL
    let method: HTTPMethod
    let query: QueryItems
    let header: HTTPHeader
    
    init(baseURL: URL, info: AddPaymentMethodInfo) {
        self.endpoint = baseURL.appendingPathExtension("/addCard")
        self.method = .post
        self.query = [
            "number": info.number,
            "cvc": info.cvc,
            "expiry": info.expiration
        ]
        self.header = [:]
    }
}

struct AddCardResponse: Decodable {
    let card: PaymentMethod
}
