//
//  TopupBuilder.swift
//  MiniSuperApp
//
//  Created by 김두리 on 2022/03/23.
//

import ModernRIBs
import FinanceRepository
import AddPaymentMethod
import CombineUtil
import FinanceEntity
import Topup
import CombineSchedulers

public protocol TopupDependency: Dependency {
    // topup Reblet이 동작하기 위해 필요한 것들 (= dependency)
    // 부모 Reblet이 ViewController를 지정 해줘야 함 (상태에 따른 화면 분기처리를 위해 ViewController를 받음)
    // 따라서, topup Reblet의 topupBaseVC는 topup Reblet을 띄운 부모가 지정해준 ViewController 
    
    var topupBaseViewController: ViewControllable { get }
    var cardsOnFileRepository: CardOnFileRepository { get }
    var superPayRepository: SuperPayRepository { get }
    var addPaymentMethodBuildable: AddPaymentMethodBuildable { get }
    var mainQueue: AnySchedulerOf<DispathQueue> { get }
}

final class TopupComponent: Component<TopupDependency>, TopupInteractorDependency, EnterAmountDependency, CardOnFileDependency {
    
    var selectedPaymentMethod: ReadOnlyCurrentValuePublisher<PaymentMethod> { paymentMethodStream }
    
    var cardsOnFileRepository: CardOnFileRepository { dependency.cardsOnFileRepository }
    var superPayRepository: SuperPayRepository { dependency.superPayRepository }
    var addPaymentMethodBuildable: AddPaymentMethodBuildable { dependency.addPaymentMethodBuildable }
    var mainQueue: AnySchedulerOf<DispathQueue> { dependency.mainQueue }
    
    fileprivate var topupBaseViewController: ViewControllable { dependency.topupBaseViewController }
    
    let paymentMethodStream: CurrentValuePublisher<PaymentMethod>
    // 부모 Reblet이 자식 Reblet에게 데이터 전달 하는 방법 -> `Stream`을 사용한다.
    
    init(
        dependency: TopupDependency,
        paymentMethodStream: CurrentValuePublisher<PaymentMethod>
    ) {
        self.paymentMethodStream = paymentMethodStream
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

public final class TopupBuilder: Builder<TopupDependency>, TopupBuildable {

    public override init(dependency: TopupDependency) {
        super.init(dependency: dependency)
    }

    public func build(withListener listener: TopupListener) -> Routing {
        let paymentMethodStream = CurrentValuePublisher(PaymentMethod(id: "", name: "", digits: "", color: "", isPrimary: false))
        
        let component = TopupComponent(dependency: dependency, paymentMethodStream: paymentMethodStream)
        let interactor = TopupInteractor(dependency: component)
        interactor.listener = listener
        
        let enterAmountBuilder = EnterAmountBuilder(dependency: component)
        let cardOnFileBuilder = CardOnFileBuilder(dependency: component)
        
        return TopupRouter(
            interactor: interactor,
            viewController: component.topupBaseViewController,
            addPaymentMethodBuildable: component.addPaymentMethodBuildable,
            enterAmountBuildable: enterAmountBuilder,
            cardOnFileBuildable: cardOnFileBuilder
        )
    }
}
