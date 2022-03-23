//
//  TopupRouter.swift
//  MiniSuperApp
//
//  Created by 김두리 on 2022/03/23.
//

import ModernRIBs

protocol TopupInteractable: Interactable, AddPaymentMethodListener, EnterAmountListener, CardOnFileListener {
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
    
    private let cardOnFileBuildable: CardOnFileBuildable
    private var cardOnFileRouting: Routing?
    
    init(
        interactor: TopupInteractable,
        viewController: ViewControllable,
        addPaymentMethodBuildable: AddPaymentMethodBuildable,
        enterAmountBuildable: EnterAmountBuildable,
        cardOnFileBuildable: CardOnFileBuildable
    ) {
        self.viewController = viewController
        self.addPaymentMethodBuildable = addPaymentMethodBuildable
        self.enterAmountBuildable = enterAmountBuildable
        self.cardOnFileBuildable = cardOnFileBuildable
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

    func attachAddPaymentMethod(closeButtonType: DismissButtonType) {
        if addPaymnetMethodRouting != nil {
            return
        }
        
        let router = addPaymentMethodBuildable.build(withListener: interactor, closeButtonType: closeButtonType)
        
        if let navigationControllable = navigationControllable {
            navigationControllable.pushViewController(router.viewControllable, animated: true)
        } else {
            // navigation이 없는 경우 push
            presentInsideNavigation(router.viewControllable)
        }
        
        attachChild(router)
        addPaymnetMethodRouting = router
    }
    
    func detachAddPaymentMethod() {
        guard let router = addPaymnetMethodRouting else { return }
        
        navigationControllable?.popViewController(animated: true)
        detachChild(router)
        addPaymnetMethodRouting = nil
    }
    
    func attachEnterAmount() {
        if enterAmountRouting != nil {
            return
        }
        
        let router = enterAmountBuildable.build(withListener: interactor)
        
        if let navigation = navigationControllable {
            // navigation이 있는 경우([카드목록] - [카드추가]로 해서 들어오는 경우)
            navigation.setViewControllers([router.viewControllable])
            resetChildRouting()
            
        } else {
            // [카드추가]로 해서 들어오는 경우
            presentInsideNavigation(router.viewControllable)
        }
        
        attachChild(router)
        addPaymnetMethodRouting = router
    }
    
    func detachEnterAmount() {
        guard let router = addPaymnetMethodRouting else { return }
        dismissPresentedNavigation(completion: nil)
        detachChild(router)
        enterAmountRouting = nil
    }
    
    func attachCardOnFile(paymentMethods: [PaymentMethod]) {
        if cardOnFileRouting != nil {
            return
        }
        
        let router = cardOnFileBuildable.build(withListener: interactor, paymentMethods: paymentMethods)
        navigationControllable?.pushViewController(router.viewControllable, animated: true)
        cardOnFileRouting = router
        attachChild(router)
    }
    
    func detachCardOnFile() {
        guard let router = cardOnFileRouting else { return }
        
        navigationControllable?.popViewController(animated: true)
        detachChild(router)
        enterAmountRouting = nil
    }
    
    func popToRoot() {
        navigationControllable?.popViewController(animated: true)
        resetChildRouting()
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
    
    private func resetChildRouting() {
        // 다른 child들을 detach & 초기화
        if let cardOnFileRouting = cardOnFileRouting {
            detachChild(cardOnFileRouting)
            self.cardOnFileRouting = nil
        }
        
        if let addPaymnetMethodRouting = addPaymnetMethodRouting {
            detachChild(addPaymnetMethodRouting)
            self.addPaymnetMethodRouting = nil
        }
    }
    
    // MARK: - Private
    private let viewController: ViewControllable
}
