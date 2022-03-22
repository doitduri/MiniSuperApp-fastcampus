//
//  CardOnFileRepository.swift
//  MiniSuperApp
//
//  Created by 김두리 on 2022/03/22.
//

import Foundation

protocol CardOnFileRepository {
    var cardOnFile: ReadOnlyCurrentValuePublisher<[PaymentMethod]> { get }
}


final class CardOnFileRepositoryImp: CardOnFileRepository {
    var cardOnFile: ReadOnlyCurrentValuePublisher<[PaymentMethod]> { paymentMethodsSubject }
    
    private let paymentMethodsSubject = CurrentValuePublisher<[PaymentMethod]>([
        PaymentMethod(id: "0", name: "우리은행", digits: "0123", color: "#f19a38ff", isPrimary: false),
        PaymentMethod(id: "0", name: "신한카드", digits: "0987", color: "#3478f6ff", isPrimary: false),
        PaymentMethod(id: "0", name: "현대카드", digits: "6121", color: "#78c5f5ff", isPrimary: false),
        PaymentMethod(id: "0", name: "국민은행", digits: "2812", color: "#65c466ff", isPrimary: false),
        PaymentMethod(id: "0", name: "카카오뱅크", digits: "8751", color: "#ffcc00ff", isPrimary: false),
        PaymentMethod(id: "0", name: "우리은행", digits: "0123", color: "#f19a38ff", isPrimary: false),
        PaymentMethod(id: "0", name: "신한카드", digits: "0987", color: "#3478f6ff", isPrimary: false),
        PaymentMethod(id: "0", name: "현대카드", digits: "6121", color: "#78c5f5ff", isPrimary: false),
        PaymentMethod(id: "0", name: "국민은행", digits: "2812", color: "#65c466ff", isPrimary: false),
        PaymentMethod(id: "0", name: "카카오뱅크", digits: "8751", color: "#ffcc00ff", isPrimary: false)
    ])
}
