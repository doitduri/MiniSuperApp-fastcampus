import ModernRIBs

protocol FinanceHomeDependency: Dependency {
  // TODO: Declare the set of dependencies required by this RIB, but cannot be
  // created by this RIB.
}

final class FinanceHomeComponent: Component<FinanceHomeDependency>, SuperPayDashboardDependency {
    var balance: ReadOnlyCurrentValuePublisher<Double> { balancePublisher }
    private let balancePublisher: CurrentValuePublisher<Double>
    // CurrentValuePublisher의 자식 클래스 -> ReadOnlyCurrentValuePublisher
    // 따라서 balance는 값을 업데이트하는 send를 호출 할 수 없음
    
    init(
        dependency: FinanceHomeDependency,
        balance: CurrentValuePublisher<Double>
    ) {
        self.balancePublisher = balance
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
      
    let component = FinanceHomeComponent(dependency: dependency, balance: balancePublisher)
    let viewController = FinanceHomeViewController()
    let interactor = FinanceHomeInteractor(presenter: viewController)
    interactor.listener = listener
      
    let superPayDashboardBulder = SuperPayDashboardBuilder(dependency: component)
      
    return FinanceHomeRouter(
        interactor: interactor,
        viewController: viewController,
        superPayDashboardBuildable: superPayDashboardBulder
    )
  }
}
