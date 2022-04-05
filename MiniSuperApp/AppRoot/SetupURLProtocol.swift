//
//  SetupURLProtocol.swift
//  MiniSuperApp
//
//  Created by 김두리 on 2022/03/28.
//

import Foundation

func setupURLProtocol() {
    let topupResponse: [String: Any] = [
        "status": "success"
    ]
    
    let topupResponseData = try! JSONSerialization.data(withJSONObject: topupResponse, options: [])
    
    let addCardResponse: [String: Any] = [
        "card": [
            "id": "999",
            "name": "새 카드",
            "digits": "*** 0101",
            "color": "",
            "isPrimary": false
        ]
    ]
    let addCardResponseData = try! JSONSerialization.data(withJSONObject: addCardResponse, options: [])
    
    let cardOnFileResponse: [String: Any] = [
        "cards": [
            [
                "id": "0",
                "name": "우리은행",
                "digits": "0123",
                "color": "#f19a38ff",
                "isPrimary": false
            ],
            [
                "id": "1",
                "name": "신한카드",
                "digits": "0987",
                "color": "#3478f6ff",
                "isPrimary": false
            ],
            [
                "id": "2",
                "name": "현대카드",
                "digits": "6121",
                "color": "#78c5f5ff",
                "isPrimary": false
            ]
        ]
    ]
    
    let cardOnFileResponseData = try! JSONSerialization.data(withJSONObject: cardOnFileResponse, options: [])
    
    
    SuperAppURLProtocol.successMock = [
        "/api/v1/topup": (200, topupResponseData),
        "/api/v1/addCard": (200, addCardResponseData),
        "/api/v1/cards": (200, cardOnFileResponseData)
    ]
}
