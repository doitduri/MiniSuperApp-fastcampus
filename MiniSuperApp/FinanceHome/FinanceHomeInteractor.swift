import ModernRIBs

protocol FinanceHomeRouting: ViewableRouting {
    func attachSuperPayDashboard()
    func attachCardOnFileDashbaord()
    func attachAddPaymentMethod()
    func detachAddPaymentMethod()
}

protocol FinanceHomePresentable: Presentable {
    var listener: FinanceHomePresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol FinanceHomeListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class FinanceHomeInteractor: PresentableInteractor<FinanceHomePresentable>, FinanceHomeInteractable, FinanceHomePresentableListener, AdaptivePresentationControllerDelegate {
    
    weak var router: FinanceHomeRouting?
    weak var listener: FinanceHomeListener?
    
    let presentationDelegateProxy: AdaptivePresentationControllerDelegateProxy
    
    override init(presenter: FinanceHomePresentable) {
        self.presentationDelegateProxy = AdaptivePresentationControllerDelegateProxy()
        super.init(presenter: presenter)
        presenter.listener = self
        self.presentationDelegateProxy.delegate = self
    }
    
    override func didBecomeActive() {
        super.didBecomeActive()
        
        router?.attachSuperPayDashboard()
        router?.attachCardOnFileDashbaord()
    }
    
    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    func presentationControllerDidDismiss() {
        router?.detachAddPaymentMethod()
    }
    
    // MARK: - CardOnFileDashboardLinster
    func cardOnFileDashboardDidTapPaymentMethod() {
        router?.attachAddPaymentMethod()
    }
    
    
    // MARK: - AddPaymentMethodLister
    func addPaymentMethodDidTapClose() {
        router?.detachAddPaymentMethod()
    }
}
