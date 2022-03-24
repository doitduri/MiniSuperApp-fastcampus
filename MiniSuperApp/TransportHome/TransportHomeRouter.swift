import ModernRIBs

protocol TransportHomeInteractable: Interactable, TopupListener {
    var router: TransportHomeRouting? { get set }
    var listener: TransportHomeListener? { get set }
}

protocol TransportHomeViewControllable: ViewControllable {
    
}

final class TransportHomeRouter: ViewableRouter<TransportHomeInteractable, TransportHomeViewControllable>, TransportHomeRouting {
    
    private let topupBuildable: TopupBuildable
    private var topupRouting: Routing?
    
    init(
        interactor: TransportHomeInteractable,
        viewController: TransportHomeViewControllable,
        topupBuildable: TopupBuildable
    ) {
        self.topupBuildable = topupBuildable
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func attachTopup() {
        if topupRouting != nil {
            return
        }
        
        let router = topupBuildable.build(withListener: interactor)
        self.topupRouting = router
        attachChild(router)
        // topup Reblet은 Viewless이기 때문에 attach만 해주면 된다
    }
    
    func detachTopup() {
        guard let router = topupRouting else {
            return
        }
        
        detachChild(router)
        self.topupRouting = nil
    }
}
