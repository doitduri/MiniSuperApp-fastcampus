import ModernRIBs

protocol FinanceHomeInteractable: Interactable {
    var router: FinanceHomeRouting? { get set }
    var listener: FinanceHomeListener? { get set }
}

protocol FinanceHomeViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class FinanceHomeRouter: ViewableRouter<FinanceHomeInteractable, FinanceHomeViewControllable>, FinanceHomeRouting {
    
    // TODO: Constructor inject child builder protocols to allow building children.
    private let superPayDashboardBuildable: SuperPayDashboardBuildable
    
    init(
        interactor: FinanceHomeInteractable,
        viewController: FinanceHomeViewControllable,
        superPayDashboardBuildable: SuperPayDashboardBuildable
    ) {
        self.superPayDashboardBuildable = superPayDashboardBuildable
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
