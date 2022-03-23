//
//  TopupInteractor.swift
//  MiniSuperApp
//
//  Created by 김두리 on 2022/03/23.
//

import ModernRIBs

protocol TopupRouting: Routing {
    func cleanupViews()
    
    func attachAddPaymentMethod()
    func detachAddPaymentMethod()
    
    func attachEnterAmount()
    func detachEnterAmount()
}

protocol TopupListener: AnyObject {
    func topupDidClose()
}

protocol TopupInteractorDependency {
    var cardsOnFileRepository: CardOnFileRepository { get }
}

final class TopupInteractor: Interactor, TopupInteractable, AddPaymentMethodListener, AdaptivePresentationControllerDelegate {

    weak var router: TopupRouting?
    weak var listener: TopupListener?
    
    let presentationDelegateProxy: AdaptivePresentationControllerDelegateProxy
    
    private let dependency: TopupInteractorDependency
    
    init(
        dependency: TopupInteractorDependency
    ) {
        self.dependency = dependency
        self.presentationDelegateProxy = AdaptivePresentationControllerDelegateProxy()
        super.init()
        self.presentationDelegateProxy.delegate = self
    }
    
    override func didBecomeActive() {
        super.didBecomeActive()
        
        // 카드의 개수에 따라서 다른 화면을 띄우기
        if dependency.cardsOnFileRepository.cardOnFile.value.isEmpty {
            // 카드 추가 화면
            router?.attachAddPaymentMethod()
        
        } else {
            // 금액 입력 화면
            router?.attachEnterAmount()
        }
    }
    
    override func willResignActive() {
        super.willResignActive()
        
        router?.cleanupViews()
        // TODO: Pause any business logic.
    }
    
    func presentationControllerDidDismiss() {
        listener?.topupDidClose()
    }
    
    func addPaymentMethodDidTapClose() {
        router?.detachAddPaymentMethod()
        listener?.topupDidClose()
    }
    
    func addPaymentMethodDidAddCard(paymentMethod: PaymentMethod) {
        
    }
    
    func enterAmountDidTapClose() {
        router?.detachEnterAmount()
        listener?.topupDidClose() // topup 전체 flow가 끝난 것이기 때문에 listener에게 알리기
    }
}
