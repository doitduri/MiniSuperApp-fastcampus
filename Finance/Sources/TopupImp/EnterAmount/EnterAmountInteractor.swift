//
//  EnterAmountInteractor.swift
//  MiniSuperApp
//
//  Created by 김두리 on 2022/03/23.
//

import ModernRIBs
import Combine
import Foundation
import CombineUtil
import FinanceEntity
import FinanceRepository
import CombineSchedulers

protocol EnterAmountRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol EnterAmountPresentable: Presentable {
    var listener: EnterAmountPresentableListener? { get set }
    func updateSelectedPaymentMethod(with viewModel: SelectedPaymentMethodViewModel)
    func startLoading()
    func stopLoading()
}

protocol EnterAmountListener: AnyObject {
    func enterAmountDidTapClose()
    func enterAmountDidTapPaymentMethod()
    func enterAmountDidFinishTopup()
}

protocol EnterAmountInteractorDependency {
    var selectedPaymentMethod: ReadOnlyCurrentValuePublisher<PaymentMethod> { get }
    var superPayRepository: SuperPayRepository { get }
    var mainQueue: AnySchedulerOf<DispathQueue> { get }
}

final class EnterAmountInteractor: PresentableInteractor<EnterAmountPresentable>, EnterAmountInteractable, EnterAmountPresentableListener {
    
    weak var router: EnterAmountRouting?
    weak var listener: EnterAmountListener?
    
    private let dependency: EnterAmountInteractorDependency
    private var cancellables: Set<AnyCancellable>
    
    init(
        presenter: EnterAmountPresentable,
        dependency: EnterAmountInteractorDependency
    ) {
        self.dependency = dependency
        self.cancellables = .init()
        super.init(presenter: presenter)
        presenter.listener = self
    }
    
    override func didBecomeActive() {
        super.didBecomeActive()
        
        dependency.selectedPaymentMethod.sink { [weak self] paymentMethod in
            self?.presenter.updateSelectedPaymentMethod(with: SelectedPaymentMethodViewModel(paymentMethod))
        }.store(in: &cancellables)
    }
    
    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    func didTapClose() {
        listener?.enterAmountDidTapClose()
    }
    
    func didTapPaymentMethod() {
        listener?.enterAmountDidTapPaymentMethod()
    }
    
    func didTapTopup(with amount: Double) {
        presenter.startLoading()
        
        dependency.superPayRepository.topup(
            amount: amount,
            paymentMethodID: dependency.selectedPaymentMethod.value.id
        )
        // 테스트를 통제할 수 없는 부분 (비동기코드), 따라서 테스트에 따라 주입을 받게 해야 함
//            .receive(on: ImmediateScheduler.shared)
            .receive(on: dependency.mainQueue)
            .sink(
                receiveCompletion: { [weak self] _ in
                    self?.presenter.stopLoading()
                },
                receiveValue: { [weak self] in
                    // 통신이 완료되면, 부모 Reblet에 알려준다.
                    self?.listener?.enterAmountDidFinishTopup()
                }).store(in: &cancellables)
    }
}
