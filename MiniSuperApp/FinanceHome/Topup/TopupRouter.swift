//
//  TopupRouter.swift
//  MiniSuperApp
//
//  Created by 김두리 on 2022/03/23.
//

import ModernRIBs

protocol TopupInteractable: Interactable, AddPaymentMethodListener, EnterAmountListener {
    var router: TopupRouting? { get set }
    var listener: TopupListener? { get set }
    var presentationDelegateProxy: AdaptivePresentationControllerDelegateProxy { get }
}

protocol TopupViewControllable: ViewControllable {

}

final class TopupRouter: Router<TopupInteractable>, TopupRouting {
    
    private var navigationControllable: NavigationControllerable?
    
    private let addPaymentMethodBuildable: AddPaymentMethodBuildable
    private var addPaymnetMethodRouting: Routing?
    
    private let enterAmountBuildable: EnterAmountBuildable
    private var enterAmountRouting: Routing?
    
    init(
        interactor: TopupInteractable,
        viewController: ViewControllable,
        addPaymentMethodBuildable: AddPaymentMethodBuildable,
        enterAmountBuildable: EnterAmountBuildable
    ) {
        self.viewController = viewController
        self.addPaymentMethodBuildable = addPaymentMethodBuildable
        self.enterAmountBuildable = enterAmountBuildable
        super.init(interactor: interactor)
        interactor.router = self
    }

    func cleanupViews() {
        if viewController.uiviewController.presentationController != nil,
           navigationControllable != nil {
            // viewController가 띄웠던 view가 있다면
            
            navigationControllable?.dismiss(completion: nil)
        }
    }

    func attachAddPaymentMethod() {
        if addPaymnetMethodRouting != nil {
            return
        }
        
        let router = addPaymentMethodBuildable.build(withListener: interactor)
        presentInsideNavigation(router.viewControllable)
        attachChild(router)
        addPaymnetMethodRouting = router
    }
    
    func detachAddPaymentMethod() {
        guard let router = addPaymnetMethodRouting else { return }
        dismissPresentedNavigation(completion: nil)
        detachChild(router)
        addPaymnetMethodRouting = nil
    }
    
    func attachEnterAmount() {
        if enterAmountRouting != nil {
            return
        }
        
        let router = enterAmountBuildable.build(withListener: interactor)
        presentInsideNavigation(router.viewControllable)
        attachChild(router)
        addPaymnetMethodRouting = router
    }
    
    func detachEnterAmount() {
        guard let router = addPaymnetMethodRouting else { return }
        dismissPresentedNavigation(completion: nil)
        detachChild(router)
        enterAmountRouting = nil
    }
    
    private func presentInsideNavigation(_ viewControllable: ViewControllable) {
        // navigation controller를 한번 감싸주기 위함 (닫기 버튼..)
        let navigation = NavigationControllerable(root: viewControllable)
        navigation.navigationController.presentationController?.delegate = interactor.presentationDelegateProxy
        self.navigationControllable = navigation
        viewController.present(navigation, animated: true, completion: nil) // view가 없기 때문에, 부모가 건내준 view로 present
    }
    
    private func dismissPresentedNavigation(completion: (() -> Void)?) {
        if self.navigationControllable == nil {
            return
        }
        
        viewController.dismiss(completion: nil)
        self.navigationControllable = nil
    }
    
    // MARK: - Private
    private let viewController: ViewControllable
}
