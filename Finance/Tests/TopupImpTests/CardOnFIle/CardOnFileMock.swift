//
//  CardOnFileMock.swift
//  
//
//  Created by 김두리 on 2022/04/13.
//

import Foundation
import RIBsTestSupport
import FinanceEntity
@testable import TopupImp

final class CardOnFileBuildableMock: CardOnFileBuildable {
    var buildHandler: ((_ linster: CardOnFileListener) -> CardOnFileRouting)?
    
    var buildCallCount = 0
    var buildPaymentMethod: [PaymentMethod]?
    func build(withListener listenr: CardOnFileListener, paymentMethods: [PaymentMethod]) -> CardOnFileRouting {
        buildCallCount += 1
        buildPaymentMethod = paymentMethods
        
        if let buildHandler = buildHandler {
            return buildHandler(listenr)
        }
        
        fatalError()
    }
}

final class CardOnFileRountingMock: ViewableRoutingMock, CardOnFileRouting {
    
}
