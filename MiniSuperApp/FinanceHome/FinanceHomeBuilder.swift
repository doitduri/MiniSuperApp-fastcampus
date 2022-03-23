import ModernRIBs

protocol FinanceHomeDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class FinanceHomeComponent: Component<FinanceHomeDependency>, SuperPayDashboardDependency, CardOnFileDashboardDependency, AddPaymentMethodDependency, TopupDependency {
    
    let cardsOnFileRepository: CardOnFileRepository
    let superPayRepository: SuperPayRepository
    var balance: ReadOnlyCurrentValuePublisher<Double> { superPayRepository.balance }
    
    var topupBaseViewController: ViewControllable
    // Finance Reblet이 가지고 있는 Finance ViewController가 되면 됨
    // 이렇게 하는 이유) card 유무에 따라서 진입 되는 화면의 분기 처리를 하기 위해
    
    init(
        dependency: FinanceHomeDependency,
        cardsOnFileRepository: CardOnFileRepository,
        superPayRepository: SuperPayRepository,
        topupBaseViewController: ViewControllable
    ) {
        self.cardsOnFileRepository = cardsOnFileRepository
        self.superPayRepository = superPayRepository
        self.topupBaseViewController = topupBaseViewController
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

protocol FinanceHomeBuildable: Buildable {
    func build(withListener listener: FinanceHomeListener) -> FinanceHomeRouting
}

final class FinanceHomeBuilder: Builder<FinanceHomeDependency>, FinanceHomeBuildable {
    
    override init(dependency: FinanceHomeDependency) {
        super.init(dependency: dependency)
    }
    
    func build(withListener listener: FinanceHomeListener) -> FinanceHomeRouting {
        let balancePublisher = CurrentValuePublisher<Double>(0)
        
        let viewController = FinanceHomeViewController()
        
        let component = FinanceHomeComponent(
            dependency: dependency,
            cardsOnFileRepository: CardOnFileRepositoryImp(),
            superPayRepository: SuperPayRepositoryImp(),
            topupBaseViewController: viewController
        )
        
        let interactor = FinanceHomeInteractor(presenter: viewController)
        interactor.listener = listener
        
        let superPayDashboardBuilder = SuperPayDashboardBuilder(dependency: component)
        let cardOnFileDashboardBuilder = CardOnFileDashboardBuilder(dependency: component)
        let addPaymentMethodBuilder = AddPaymentMethodBuilder(dependency: component)
        let topupBuilder = TopupBuilder(dependency: component)
        
        return FinanceHomeRouter(
            interactor: interactor,
            viewController: viewController,
            superPayDashboardBuildable: superPayDashboardBuilder,
            cardOnFileDashboardBuildable: cardOnFileDashboardBuilder,
            addPaymentBuildable: addPaymentMethodBuilder,
            topupBuildable: topupBuilder
        )
    }
}
