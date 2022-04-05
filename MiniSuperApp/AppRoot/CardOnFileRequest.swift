//
//  CardOnFileRequest.swift
//  MiniSuperApp
//
//  Created by 김두리 on 2022/03/28.
//

import Foundation
import Network
import FinanceEntity

struct CardOnFileRequest: Request {
    typealias Output = AddCardResponse

    let endpoint: URL
    let method: HTTPMethod
    let query: QueryItems
    let header: HTTPHeader
    
    init(BaseURL: URL) {
        self.endpoint = BaseURL.appendingPathExtension("/cards")
        self.method = .get
        self.query = [:]
        self.header = [:]
    }
}

struct CardOnFileResponse: Decodable {
    let cards: [PaymentMethod]
}

