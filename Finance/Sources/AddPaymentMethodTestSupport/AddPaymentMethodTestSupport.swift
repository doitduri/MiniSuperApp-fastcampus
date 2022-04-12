//
//  File.swift
//  
//
//  Created by 김두리 on 2022/04/13.
//

import Foundation
import AddPaymentMethod
import ModernRIBs
import RIBsUtil

public final class AddPaymentMethodBuildableMock: AddPaymentMethodBuildable {
    
    public var buildCallCount = 0
    public var closeButtonType: DismissButtonType?
    
    public func build(withListener listener: AddPaymentMethodListener, closeButtonType: DismissButtonType) -> ViewableRouting {
        buildCallCount += 1
        self.closeButtonType = closeButtonType
        
        return ViewableRoutingMock(
            interactable: Interactor(),
            viewControllable: ViewControllableMock()
        )
    }
    
    public init() {
        
    }
}
