//
//  CardOnFileDashboardInteractor.swift
//  MiniSuperApp
//
//  Created by 김두리 on 2022/03/22.
//

import ModernRIBs
import Combine

protocol CardOnFileDashboardRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol CardOnFileDashboardPresentable: Presentable {
    var listener: CardOnFileDashboardPresentableListener? { get set }
    
    func update(with viewModels: [PaymentMethodViewModel])
}

protocol CardOnFileDashboardListener: AnyObject {
    // listner -> 부모 Reblet의 interactor
    func cardOnFileDashboardDidTapPaymentMethod()
}

protocol CardOnFileDashboardInteractorDependency {
    var cardsOnFileRepository: CardOnFileRepository { get }
}

final class CardOnFileDashboardInteractor: PresentableInteractor<CardOnFileDashboardPresentable>, CardOnFileDashboardInteractable, CardOnFileDashboardPresentableListener {

    weak var router: CardOnFileDashboardRouting?
    weak var listener: CardOnFileDashboardListener?

    private let dependency: CardOnFileDashboardInteractorDependency
    private var cancellables: Set<AnyCancellable>
    
    init(
        presenter: CardOnFileDashboardPresentable,
        dependency: CardOnFileDashboardInteractorDependency
    ) {
        self.dependency = dependency
        self.cancellables = .init()
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        
        // PaymentMethod Model -> ViewModel로 변환하는 작업 필요 (ViewController 의존성 낮추기)
        dependency.cardsOnFileRepository.cardOnFile.sink { methods in
            let viewModels = methods.prefix(3).map(PaymentMethodViewModel.init)
            self.presenter.update(with: viewModels)
        }.store(in: &cancellables)
    }

    override func willResignActive() {
        // deattrach 되기 직전에 willResignActive() 메소드가 호출된다.
        // retain으로 인해 무분별한 [weak self]을 막고자 한다면 cancellables를 모두 지워주면 참조관계가 사라짐!
        super.willResignActive()
        
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
    }
    
    func didTapAddPaymentMethod() {
        listener?.cardOnFileDashboardDidTapPaymentMethod()
    }
}
