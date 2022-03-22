import ModernRIBs

protocol FinanceHomeInteractable: Interactable, SuperPayDashboardListener, CardOnFileDashboardListener {
    // 자식 Reblet의 Listener를 상속 받아줌
    var router: FinanceHomeRouting? { get set }
    var listener: FinanceHomeListener? { get set }
}

protocol FinanceHomeViewControllable: ViewControllable {
    func addDashboard(_ view: ViewControllable)
}

final class FinanceHomeRouter: ViewableRouter<FinanceHomeInteractable, FinanceHomeViewControllable>, FinanceHomeRouting {
    
    private let superPayDashboardBuildable: SuperPayDashboardBuildable
    private let cardOnFileDashboardBuildable: CardOnFileDashboardBuildable

    private var superPayRouting: Routing?
    private var cardOnFileRouting: Routing?
    
    init(
        interactor: FinanceHomeInteractable,
        viewController: FinanceHomeViewControllable,
        superPayDashboardBuildable: SuperPayDashboardBuildable,
        cardOnFileDashboardBuildable: CardOnFileDashboardBuildable
    ) {
        self.superPayDashboardBuildable = superPayDashboardBuildable
        self.cardOnFileDashboardBuildable = cardOnFileDashboardBuildable
        
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func attachSuperPayDashboard() {
        
        if superPayRouting != nil {
            return
        }
        
        // 자식 Reblet을 붙이려면, builder에 build 메소드를 호출해서 router를 받아야함
        let router = superPayDashboardBuildable.build(withListener: interactor)
        // 자식 Reblet의 listener는 interactor(비즈니스 로직)를 넘겨줌
        
        // finance vc의 sub view로 사용 할 거
        let dashboard = router.viewControllable
        viewController.addDashboard(dashboard)
        
        self.superPayRouting = router
        attachChild(router)
    }
    
    func attachCardOnFileDashbaord() {
        if cardOnFileRouting != nil {
            return
        }
        
        let router = cardOnFileDashboardBuildable.build(withListener: interactor)
        let dashbaord = router.viewControllable
        viewController.addDashboard(dashbaord)
        
        self.cardOnFileRouting = router
        attachChild(router)
    }
}
