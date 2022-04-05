//
//  CardOnFileInteractor.swift
//  MiniSuperApp
//
//  Created by 김두리 on 2022/03/23.
//

import Foundation
import ModernRIBs
import FinanceEntity
import FinanceHome

protocol CardOnFileRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol CardOnFilePresentable: Presentable {
    var listener: CardOnFilePresentableListener? { get set }
    
    func update(with viewModels: [PaymentMethodViewModel])
}

protocol CardOnFileListener: AnyObject {
    func cardOnFileDidTapClose()
    func cardOnFileDidTapAddCard()
    func cardOnFileDidSelect(at index: Int)
}

final class CardOnFileInteractor: PresentableInteractor<CardOnFilePresentable>, CardOnFileInteractable, CardOnFilePresentableListener {
    
    weak var router: CardOnFileRouting?
    weak var listener: CardOnFileListener?

    private let paymentMethods: [PaymentMethod]
    private var cancellables: Set<AnyCancellable>
    
    init(
        presenter: CardOnFilePresentable,
        paymentMethods: [PaymentMethod]
    ) {
        self.paymentMethods = paymentMethods
        self.cancellables = .init()
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        
        dependency.cardsOnFileRepository.cardOnFile
            .receive(on: DispatchQueue.main)
            .sink { methods in
                let viewModels = methods.prefix(5).map(PaymentMethodViewModel.init)
                self.presenter.update(with: viewModels)
            }.store(in: &cancellables)
    }

    override func willResignActive() {
        super.willResignActive()
    }
    
    func didTapClose() {
        listener?.cardOnFileDidTapClose()
    }
    
    func didSelectItem(at index: Int) {
        // 셀 선택 했을 때
        
        if index >= paymentMethods.count {
            // 마지막 [카드 추가] 셀 분기
            
            listener?.cardOnFileDidTapAddCard()
        } else {
            listener?.cardOnFileDidSelect(at: index)
        }
    }
}
