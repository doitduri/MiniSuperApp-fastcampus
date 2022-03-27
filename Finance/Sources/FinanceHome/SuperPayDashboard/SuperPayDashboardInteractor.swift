//
//  SuperPayDashboardInteractor.swift
//  MiniSuperApp
//
//  Created by 김두리 on 2022/03/22.
//

import ModernRIBs
import Combine
import Foundation
import CombineUtil

protocol SuperPayDashboardRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol SuperPayDashboardPresentable: Presentable {
    var listener: SuperPayDashboardPresentableListener? { get set }
    
    func updateBalance(_ balance: String)
}

protocol SuperPayDashboardListener: AnyObject {
    func superPayDashboardDidTapTopup()
}

// interactor에 dependency를 protocol로 관리 (프로토콜로 하면 inject이 간단해짐)
protocol SuperPayDashboardInteractorDependency {
    var balance: ReadOnlyCurrentValuePublisher<Double> { get }
    var balanceFormatter: NumberFormatter { get }
}

final class SuperPayDashboardInteractor: PresentableInteractor<SuperPayDashboardPresentable>, SuperPayDashboardInteractable, SuperPayDashboardPresentableListener {

    weak var router: SuperPayDashboardRouting?
    weak var listener: SuperPayDashboardListener?

    private let dependency: SuperPayDashboardInteractorDependency
    private var cancellables: Set<AnyCancellable>
    
    init(
        presenter: SuperPayDashboardPresentable,
        dependency: SuperPayDashboardInteractorDependency
    ) {
        self.dependency = dependency
        self.cancellables = .init()
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        
        dependency.balance
            .receive(on: DispatchQueue.main)
            .sink { [weak self] balance in
            // unwrapping을 위해 map으로 updateBalance 메소드 호출
            self?.dependency.balanceFormatter.string(from: NSNumber(value: balance)).map({
                // interactor에서 UI를 업데이트 할 때는 presneter를 호출한다.
                self?.presenter.updateBalance($0)
            })
        }.store(in: &cancellables)
    }

    override func willResignActive() {
        super.willResignActive()
    }
    
    func topupButtonDidTap() {
        listener?.superPayDashboardDidTapTopup()
    }
}
