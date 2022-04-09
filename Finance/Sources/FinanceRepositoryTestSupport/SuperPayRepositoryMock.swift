//
//  SuperPayRepositoryMock.swift
//  
//
//  Created by 김두리 on 2022/04/09.
//

import Foundation
import FinanceRepository
import CombineUtil
import Combine

public final class SuperPayRepositoryMock: SuperPayRepository {
    
    public var balanceSubject = CurrentValueSubject<Double>()
    public var balance: ReadOnlyCurrentValuePublisher<Double> { balanceSubject }
    
    public var topupCallCount = 0
    public var topupAmount: Double?
    public var paymnetMethodID: String?
    public var shouldTopupSucceed: Bool = true
    public func topup(amount: Double, paymentMethodId: String) -> AnyPublisher<Void, Error> {
        topupCallCount += 1
        topupAmount = amount
        self.paymentMethodID = paymentMethodId
        
        if shouldTopupSucceed {
            return Just(()).setFailureType(to: Error.self).eraseToAnyPublisher()
        } else {
            return Fail(error: NSError(domoin: "SuperPayRepositoryMock", code: 0, userInfo: nil)).eraseToAnyPublisher()
        }
        
    }
    
    public init() {
        
    }
}
