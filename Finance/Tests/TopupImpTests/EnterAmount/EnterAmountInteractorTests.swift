//
//  EnterAmountInteractorTests.swift
//  MiniSuperApp
//
//  Created by 김두리 on 2022/04/09.
//

@testable import TopupImp
import XCTest

final class EnterAmountInteractorTests: XCTestCase {

    // system under test : 검증 대상이 되는 객체
    private var sut: EnterAmountInteractor!
    private var presenter: EnterAmountPresentableMock!
    private var dependency: EnterAmountDependencyMock!
    private var listener: EnterAmountListenerMock!
    
    private var repository: SuperPayRepositoryMock! {
        dependency.superPayRepository as? SuperPayRepositoryMock
    }
    
    override func setUp() {
        super.setUp()
        
        self.presenter = EnterAmountPresentableMock()
        self.dependency = EnterAmountDependencyMock()
        self.listener = EnterAmountListenerMock()
        
        sut = EnterAmountInteractor(
            presenter: self.presenter,
            dependency: self.dependency
        )
        sut.listener = self.listener
    }

    // MARK: - Tests
    func testActivate() {
        // given : 테스트 수행 전, 환경을 셋업해주는 것
        let paymentMethod = PaymentMethod(
            id: "id_0",
            name: "name_0",
            digits: "9999",
            color: "#f19a38ff",
            isPrimary: false
        )
        dependency.selectedPaymentMethodSubject.send(paymentMethod)
        
        // when : 검증하고자 하는 행위
        sut.activate()
        
        // then
        XCTAssertEqual(presenter.updateSelectedPaymentMethodCallCount, 1)
        XCTAssertEqual(presenter.updateSelectedPaymentMethodViewModel?.name, "name_0 9999")
        XCTAssertNotNil(presenter.updateSelectedPaymentMethodViewModel?.image)
    }
    
    func testTopupWithValidAmount() {
        // given
        let paymentMethod = PaymentMethod(
            id: "id_0",
            name: "name_0",
            digits: "9999",
            color: "#f19a38ff",
            isPrimary: false
        )
        dependency.selectedPaymentMethodSubject.send(paymentMethod)
        
        // when
        sut.didTapTopup(with: 1_000_000)
        
        // then
        
        // 비동기 처리로 인한 테스트 실패를 방지하기 위해 wait을 걸어줌 -> 바람직하지 않은 방법
        //  _ = XCTWaiter.wait(for: [expectation(description: "Wait 0.1 second")], timeout: 0.1)
        
        XCTAssertEqual(presenter.startLoadingCallCount, 1)
        XCTAssertEqual(presenter.stopLoadingCallCount, 1)
        // 로딩이 잘 되고 있는지 확인하는 것은 중요함 (터치 등등 먹힐 수 잇음)
        XCTAssertEqual(repository.topupCallCount, 1)
        XCTAssertEqual(repository.paymnetMethodID, "id_0")
        XCTAssertEqual(repository.topupAmount, 1_000_000)
        XCTAssertEqual(listener.enterAmountDidFinishTopupCallCount, 1)
    }
    // 테스트 실패 -> 멀티 스레딩, 비동기로 처리되고 있음
}
