import ModernRIBs
import FinanceRepository
import CombineUtil
import AddPaymentMethod
import Topup

public protocol FinanceHomeDependency: Dependency {
    var cardsOnFileRepository: CardOnFileRepository { get }
    var superPayRepository: SuperPayRepository { get  }
    var topupBuildable: TopupBuildable { get }
}

final class FinanceHomeComponent: Component<FinanceHomeDependency>, SuperPayDashboardDependency, CardOnFileDashboardDependency, AddPaymentMethodDependency {
    
    var cardsOnFileRepository: CardOnFileRepository { dependency.cardsOnFileRepository }
    var superPayRepository: SuperPayRepository { dependency.superPayRepository }
    var balance: ReadOnlyCurrentValuePublisher<Double> { superPayRepository.balance }
    var topupBuildable: TopupBuildable { dependency.topupBuildable }
}

// MARK: - Builder

public protocol FinanceHomeBuildable: Buildable {
    func build(withListener listener: FinanceHomeListener) -> ViewableRouting
}

public final class FinanceHomeBuilder: Builder<FinanceHomeDependency>, FinanceHomeBuildable {
    
    public override init(dependency: FinanceHomeDependency) {
        super.init(dependency: dependency)
    }
    
    public func build(withListener listener: FinanceHomeListener) -> ViewableRouting {
        let balancePublisher = CurrentValuePublisher<Double>(0)
        
        let viewController = FinanceHomeViewController()
        
        let component = FinanceHomeComponent(
            dependency: dependency
        )
        
        let interactor = FinanceHomeInteractor(presenter: viewController)
        interactor.listener = listener
        
        let superPayDashboardBuilder = SuperPayDashboardBuilder(dependency: component)
        let cardOnFileDashboardBuilder = CardOnFileDashboardBuilder(dependency: component)
        let addPaymentMethodBuilder = AddPaymentMethodBuilder(dependency: component)
        
        return FinanceHomeRouter(
            interactor: interactor,
            viewController: viewController,
            superPayDashboardBuildable: superPayDashboardBuilder,
            cardOnFileDashboardBuildable: cardOnFileDashboardBuilder,
            addPaymentBuildable: addPaymentMethodBuilder,
            topupBuildable: component.topupBuildable
        )
    }
}
