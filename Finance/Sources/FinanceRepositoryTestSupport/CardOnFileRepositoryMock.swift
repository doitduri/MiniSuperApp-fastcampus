//
//  CardOnFileRepositoryMock.swift
//  
//
//  Created by 김두리 on 2022/04/13.
//

import Foundation
import FinanceRepository
import CombineUtil
import Combine
import FinanceEntity

final class CardOnFileRepositoryMock: CardOnFileRepository {
    public var cardOnFileSubject: CurrentValuePublisher<[PaymentMethod]> = .init([])
    public var cardOnFile: ReadOnlyCurrentValuePublisher<[PaymentMethod]> { cardOnFileSubject }
    
    public var addCardCallCount = 0
    public var addCardInfo: AddPaymentMethodInfo?
    public var addPaymentMethod: PaymentMethod?
    public func addCard(info: AddPaymentMethodInfo) -> AnyPublisher<PaymentMethod, Error> {
        addCardCallCount += 1
        addCardInfo = info
        
        if let addedPaymentMethod = addPaymentMethod {
            return Just(addedPaymentMethod).setFailureType(to: Error.self).eraseToAnyPublisher()
        } else {
            return Fail(error: NSError(domain: "CardOnFileRepositoryMock", code: 0, userInfo: nil)).eraseToAnyPublisher()
        }
    }
    
    public var fetchCallCount = 0
    public func fetch() {
        fetchCallCount += 1
    }
    
    public init() {
        
    }
}
