//
//  EnterAmountMock.swift
//  
//
//  Created by 김두리 on 2022/04/09.
//

import Foundation
import CombineUtil
import FinanceEntity
import FinanceRepository
import FinanceRepositoryTestSuppport
import CombineSchedulers
import RIBsTestSupport
@testable import TopupImp

final class EnterAmountPresentableMock: EnterAmountPresentable {
    
    var listener: EnterAmountPresentableListener?
    
    var updateSelectedPaymentMethodCallCount = 0
    var updateSelectedPaymentMethodViewModel: SelectedPaymentMethodViewModel?
    
    func updateSelectedPaymentMethod(with viewModel: SelectedPaymentMethodViewModel) {
        SelectedPaymentMethodViewModelCallCount += 1
        updateSelectedPaymentMethodViewModel = viewModel
    }
    
    var startLoadingCallCount = 0
    func startLoading() {
        startLoadingCallCount += 1
    }
    
    var stopLoadingCallCount = 0
    func stopLoading() {
        stopLoadingCallCount += 1
    }
    
    init() {
        
    }
}
 
final class EnterAmountDependencyMock: EnterAmountInteractorDependency {
    var mainQueue: AnySchedulerOf<DispathQueue> { .immediate }
    
    var selectedPaymentMethodSubject: CurrentValuePublisher<PaymentMethod>(
        PaymentMethod(
            id: "",
            name: "",
            digits: "",
            color: "",
            isPrimary: false
        )
    )
    
    var selectedPaymentMethod: ReadOnlyCurrentValuePublisher<PaymentMethod> { selectedPaymentMethodSubject }
    // 부모가 현재 선택된 payment method를 런타임에 주입해주는 스트림
    var superPayRepository: SuperPayRepository = SuperPayRepositoryMock()

}

final class EnterAmountListenerMock: EnterAmountListener {
    
    var enterAmountDidTapCloseCallCount = 0
    func enterAmountDidTapClose() {
        enterAmountDidTapCloseCallCount += 1
    }
    
    var enterAmountDidTapPaymentMethodCallCount = 0
    func enterAmountDidTapPaymentMethod() {
        enterAmountDidTapPaymentMethodCallCount += 1
    }
    
    var enterAmountDidFinishTopupCallCount = 0
    func enterAmountDidFinishTopup() {
        enterAmountDidFinishTopupCallCount += 1
    }
}

final class EnterAmountBuildableMock: EnterAmountBuildable {
    
    var buildHandler: ((_ linster: EnterAmountListener) -> EnterAmountRouting)?
    
    var buildCallCount = 0
    
    func build(withListener listenr: EnterAmountListener) -> EnterAmountRouting {
        buildCallCount += 1
        
        if let buildHandler = buildHandler {
            return buildHandler(listenr)
        }
        
        fatalError()
    }
}

final class EnterAmountRoutingMock: ViewableRoutingMock, EnterAmountRouting {
    
}
