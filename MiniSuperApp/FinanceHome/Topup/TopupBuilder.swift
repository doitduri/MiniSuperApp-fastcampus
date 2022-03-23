//
//  TopupBuilder.swift
//  MiniSuperApp
//
//  Created by 김두리 on 2022/03/23.
//

import ModernRIBs

protocol TopupDependency: Dependency {
    // topup Reblet이 동작하기 위해 필요한 것들 (= dependency)
    // 부모 Reblet이 ViewController를 지정 해줘야 함 (상태에 따른 화면 분기처리를 위해 ViewController를 받음)
    // 따라서, topup Reblet의 topupBaseVC는 topup Reblet을 띄운 부모가 지정해준 ViewController 
    
    var topupBaseViewController: ViewControllable { get }
    var cardsOnFileRepository: CardOnFileRepository { get }
}

final class TopupComponent: Component<TopupDependency>, TopupInteractorDependency, AddPaymentMethodDependency, EnterAmountDependency {
    var cardsOnFileRepository: CardOnFileRepository { dependency.cardsOnFileRepository }
    fileprivate var topupBaseViewController: ViewControllable { dependency.topupBaseViewController }
}

// MARK: - Builder

protocol TopupBuildable: Buildable {
    func build(withListener listener: TopupListener) -> TopupRouting
}

final class TopupBuilder: Builder<TopupDependency>, TopupBuildable {

    override init(dependency: TopupDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: TopupListener) -> TopupRouting {
        let component = TopupComponent(dependency: dependency)
        let interactor = TopupInteractor(dependency: component)
        interactor.listener = listener
        
        let addPaymentMethodBuilder = AddPaymentMethodBuilder(dependency: component)
        let enterAmountBuilder = EnterAmountBuilder(dependency: component)
        
        return TopupRouter(
            interactor: interactor,
            viewController: component.topupBaseViewController,
            addPaymentMethodBuildable: addPaymentMethodBuilder,
            enterAmountBuildable: enterAmountBuilder
        )
    }
}
