//
//  TopupInteractorTests.swift
//  MiniSuperApp
//
//  Created by 김두리 on 2022/04/13.
//

@testable import TopupImp
import XCTest
import TopupTestSupport
import FinanceEntity

final class TopupInteractorTests: XCTestCase {

    private var sut: TopupInteractor!
    private var dependency: TopupInteractorDependencyMock!
    private var listener: TopupListenerMock!
    private var router: TopupRouterMock!
    
    private var cardOnFileRepository: CardOnFileRepositoryMock { dependency.cardOnFileRepository as! CardOnFileRepositoryMock }

    override func setUp() {
        super.setUp()
        self.dependency = TopupInteractorDependencyMock()
        self.listener = TopupListenerMock()
        
        let interactor = TopupInteractor(dependency: self.dependency)
        self.router = TopupRoutingMock(interactable: interactor)
        
        interactor.listener = self.listener
        interactor.router = self.router
        
        self.sut = interactor
    }

    // MARK: - Tests

    func testActivate() {
        // given
        let cards = [
            PaymentMethod(
                id: "0",
                name: "Zero",
                digits: "0123",
                color: "",
                isPrimary: false
            )
        ]
        
        cardOnFileRepository.cardOnFileSubject.send(cards)
        
        //when
        sut.activate()
        
        //then
        XCTAssertEqual(router.attachEnterAmountCallCount, 1)
        XCTAssertEqual(dependency.paymentMethodStream.value.name, "Zero")
    }
    
    func testActivateWithoutCard() {
        // given
        let cards = []
        
        cardOnFileRepository.cardOnFileSubject.send(cards)
        
        //when
        sut.activate()
        
        //then
        XCTAssertEqual(router.attachEnterAmountCallCount, 1)
        XCTAssertEqual(router.attachAddPaymentMethodCloseButtonType, .close)
    }
    
    func testDidAddCardWithCard() {
        // given
        let cards = [
            PaymentMethod(
                id: "0",
                name: "Zero",
                digits: "0123",
                color: "",
                isPrimary: false
            )
        ]
        
        cardOnFileRepository.cardOnFileSubject.send(cards)
        
        let newCard = PaymentMethod(
            id: "new_card_id",
            name: "New Card",
            digits: "0000",
            color: "",
            isPrimary: false
        )
        
        // when
        sut.activate()
        sut.addPaymentMethodDidAddCard(paymentMethod: newCard)
        
        // then
        XCTAssertEqual(router.popToRootCallCount, 1)
        XCTAssertEqual(dependency.paymentMethodStream.value.id, "new_card_id")
    }
    
    func testDidAddCardWithoutCard() {
        // given
        cardOnFileRepository.cardOnFileSubject.send([])
        
        let newCard = PaymentMethod(
            id: "new_card_id",
            name: "New Card",
            digits: "0000",
            color: "",
            isPrimary: false
        )
        
        // when
        sut.activate()
        sut.addPaymentMethodDidAddCard(paymentMethod: newCard)
        
        // then
        XCTAssertEqual(router.attachEnterAmountCallCount, 1)
        XCTAssertEqual(dependency.paymentMethodStream.value.id, "new_card_id")
    }
    
    func testAddPaymentMethodDidTapClose() {
        // given
        let cards = [
            PaymentMethod(
                id: "0",
                name: "Zero",
                digits: "0123",
                color: "",
                isPrimary: false
            )
        ]
        
        cardOnFileRepository.cardOnFileSubject.send(cards)

        // when
        sut.activate()
        sut.addPaymentMethodDidTapClose()
        
        // then
        XCTAssertEqual(router.detachAddPaymentMethodCallCount, 1)
    }

    func tstDidSelectCard() {
        // given
        let cards = [
            PaymentMethod(
                id: "0",
                name: "Zero",
                digits: "0123",
                color: "",
                isPrimary: false
            ),
            PaymentMethod(
                id: "1",
                name: "One",
                digits: "1234",
                color: "",
                isPrimary: false
            )
        ]
        cardOnFileRepository.cardOnFileSubject.send(cards)
        
        // when
        sut.cardOnFileDidSelect(at: 0)
        
        // then
        XCTAssertEqual(dependency.paymentMethodStream.value.id, "0")
        XCTAssertEqual(router.detachAddPaymentMethodCallCount, 1)
    }
    
    func tstDidSelectCardWithInvalidIndex() {
        // given
        let cards = [
            PaymentMethod(
                id: "0",
                name: "Zero",
                digits: "0123",
                color: "",
                isPrimary: false
            ),
            PaymentMethod(
                id: "1",
                name: "One",
                digits: "1234",
                color: "",
                isPrimary: false
            )
        ]
        cardOnFileRepository.cardOnFileSubject.send(cards)
        
        // when
        sut.cardOnFileDidSelect(at: 2)
        
        // then
        XCTAssertEqual(dependency.paymentMethodStream.value.id, "")
        XCTAssertEqual(router.detachAddPaymentMethodCallCount, 1)
    }
}
