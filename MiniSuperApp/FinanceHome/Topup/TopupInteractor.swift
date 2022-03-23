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
    
    func attachCardOnFile(paymentmethods: [PaymentMethod])
    func detachCardOnFile()
}

protocol TopupListener: AnyObject {
    func topupDidClose()
    func topupDidFinish()
}

protocol TopupInteractorDependency {
    var cardsOnFileRepository: CardOnFileRepository { get }
    var paymentMethodStream: CurrentValuePublisher<PaymentMethod> { get }
    // topup Reblet은 paymentMethod Stream의 값을 직접 사용하기 때문에, read-only가 아닌 currentValue~ publisher를 사용한다.
    // 그리고, 해당 값을 사용하는 주체이기 때문에 interactor의 dependency로 추가해준다.
}

final class TopupInteractor: Interactor, TopupInteractable, AddPaymentMethodListener, AdaptivePresentationControllerDelegate {

    weak var router: TopupRouting?
    weak var listener: TopupListener?
    
    let presentationDelegateProxy: AdaptivePresentationControllerDelegateProxy
    
    private var paymentMethods: [PaymentMethod] { self.dependency.cardsOnFileRepository.cardOnFile.value }
    
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
        if let card = dependency.cardsOnFileRepository.cardOnFile.value.first {
            dependency.paymentMethodStream.send(card)
            router?.attachEnterAmount()
        } else {
            router?.attachAddPaymentMethod()
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
    
    func enterAmountDidTapPaymentMethod() {
        router?.attachCardOnFile(paymentmethods: paymentMethods)
    }
    
    func enterAmountDidFinishTopup() {
        listener?.topupDidFinish()
    }
    
    func cardOnFileDidTapClose() {
        router?.detachCardOnFile()
    }
    
    func cardOnFileDidTapAddCard() {
        // attach add card
    }
    
    func cardOnFileDidSelect(at index: Int) {
        if let seleted = paymentMethods[safe: index] {
            dependency.paymentMethodStream.send(seleted)
        }
        router?.detachCardOnFile()
        // 카드 선택 시 화면 빠져나가기
    }
    
}
