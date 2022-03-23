import ModernRIBs

protocol FinanceHomeInteractable: Interactable, SuperPayDashboardListener, CardOnFileDashboardListener, AddPaymentMethodListener, TopupListener {
    // 자식 Reblet의 Listener를 상속 받아줌
    var router: FinanceHomeRouting? { get set }
    var listener: FinanceHomeListener? { get set }
    
    // interactor의 proxy를 설정 해줘야 함, interactor -> protocol 이기에 값을 노출
    var presentationDelegateProxy: AdaptivePresentationControllerDelegateProxy { get }
}

protocol FinanceHomeViewControllable: ViewControllable {
    func addDashboard(_ view: ViewControllable)
}

final class FinanceHomeRouter: ViewableRouter<FinanceHomeInteractable, FinanceHomeViewControllable>, FinanceHomeRouting {
    
    private let superPayDashboardBuildable: SuperPayDashboardBuildable
    private let cardOnFileDashboardBuildable: CardOnFileDashboardBuildable
    private let addPaymentMethodBuildable: AddPaymentMethodBuildable
    private let topupBuildable: TopupBuildable

    private var superPayRouting: Routing?
    private var cardOnFileRouting: Routing?
    private var addPaymentMethodRouting: Routing?
    private var topupRouting: Routing?
    
    init(
        interactor: FinanceHomeInteractable,
        viewController: FinanceHomeViewControllable,
        superPayDashboardBuildable: SuperPayDashboardBuildable,
        cardOnFileDashboardBuildable: CardOnFileDashboardBuildable,
        addPaymentBuildable: AddPaymentMethodBuildable,
        topupBuildable: TopupBuildable
    ) {
        self.superPayDashboardBuildable = superPayDashboardBuildable
        self.cardOnFileDashboardBuildable = cardOnFileDashboardBuildable
        self.addPaymentMethodBuildable = addPaymentBuildable
        self.topupBuildable = topupBuildable
        
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
    
    func attachAddPaymentMethod() {
        if addPaymentMethodRouting != nil {
            return
        }
        
        let router = addPaymentMethodBuildable.build(withListener: interactor, closeButtonType: .close)
        let navigation = NavigationControllerable(root: router.viewControllable)
        
        navigation.navigationController.presentationController?.delegate = interactor.presentationDelegateProxy
        viewControllable.present(navigation, animated: true, completion: nil)
        
        addPaymentMethodRouting = router
        attachChild(router)
    }
    
    func detachAddPaymentMethod() {
        // detach 할 떄는, reference로 들고 있던 router를 가져와서 dismiss & detach
        guard let router = addPaymentMethodRouting else {
            return
        }
        
        viewControllable.dismiss(completion: nil)
        
        detachChild(router)
        addPaymentMethodRouting = nil
    }
    
    func attachTopup() {
        if topupRouting != nil {
            return
        }
        
        let router = topupBuildable.build(withListener: interactor)
        topupRouting = router
        // topup Reblet은 ViewController가 없음
        
        attachChild(router)
    }
    
    func detachTopup() {
        guard let router = topupRouting else {
             return
        }
        
        detachChild(router)
        self.topupRouting = nil
    }
}
