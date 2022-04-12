//
//  TopupRouterTests.swift
//  MiniSuperApp
//
//  Created by 김두리 on 2022/04/13.
//

@testable import TopupImp
import XCTest
import RIBsTestSupport
import AddPaymentMethodTestSupport
import ModernRIBs

final class TopupRouterTests: XCTestCase {
    
    private var router: TopupRouter!
    private var interactor: TopupInteractableMock!
    private var viewController: ViewControllableMock!
    private var addPaymentMethodBuildable: AddPaymentMethodBuildableMock!
    private var enterAmountBuildable: EnterAmountBuildableMock!
    private var cardOnFileBuildable: CardOnFileBuildableMock!
    
    override func setUp() {
        super.setUp()
        
        interactor = TopupInteractableMock()
        viewController = ViewControllableMock()
        addPaymentMethodBuildable = AddPaymentMethodBuildableMock()
        enterAmountBuildable = EnterAmountBuildableMock()
        cardOnFileBuildable = CardOnFileBuildableMock()
        
        sut = TopupRouter(
            interactor: TopupInteractor,
            viewController: viewController,
            addPaymentMethodBuildable: addPaymentMethodBuildable,
            enterAmountBuildable: enterAmountBuildable,
            cardOnFileBuildable: cardOnFileBuildable
        )
    }
    
    // MARK: - Tests
    
    func testAttachAddPaymentMethod() {
        // givne
        
        // when
        sut.attachAddPaymentMethod(closeButtonType: .close)
        
        // then
        XCTAssertEqual(addPaymentMethodBuildable.buildCallCount, 1)
        XCTAssertEqual(addPaymentMethodBuildable.closeButtonType, .close)
        XCTAssertEqual(viewController.presentCallCount, 1)
    }
    
    func testAttachEnterAmount() {
        // givne
        let router = EnterAmountRoutingMock(
            interactable: interactor(),
            viewControllable: ViewControllableMock()
        )
        
        var assignedListener: EnterAmountListener?
        enterAmountBuildable.buildHandler = { listener in
            return router
        }
        
        // when
        sut.attachEnterAmount()
        
        // then
        XCTAssertTrue(assignedListener == interactor)
        XCTAssertEqual(enterAmountBuildable.buildCallCount, 1)
    }
    
    func testAttachEnterAmountOnNavigation() {
        // givne
        let router = EnterAmountRoutingMock(
            interactable: interactor(),
            viewControllable: ViewControllableMock()
        )
        
        var assignedListener: EnterAmountListener?
        enterAmountBuildable.buildHandler = { listener in
            return router
        }
        
        // when
        sut.router?.attachAddPaymentMethod(closeButtonType: .close)
        sut.attachEnterAmount()
        
        // then
        XCTAssertTrue(assignedListener == interactor)
        XCTAssertEqual(enterAmountBuildable.buildCallCount, 1)
        XCTAssertEqual(viewController.presentCallCount, 1)
        XCTAssertEqual(sut.children.count, 1)
    }
}
