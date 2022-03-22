//
//  CardOnFileDashboardBuilder.swift
//  MiniSuperApp
//
//  Created by 김두리 on 2022/03/22.
//

import ModernRIBs

protocol CardOnFileDashboardDependency: Dependency {
    var cardsOnFileRepository: CardOnFileRepository { get }
}

final class CardOnFileDashboardComponent: Component<CardOnFileDashboardDependency>, CardOnFileDashboardInteractorDependency {
    var cardsOnFileRepository: CardOnFileRepository { dependency.cardsOnFileRepository }
    // CardOnFileDashboard에서 처리하기보다) 부모에 요청 (금융사의 정보 등등)
}

// MARK: - Builder

protocol CardOnFileDashboardBuildable: Buildable {
    func build(withListener listener: CardOnFileDashboardListener) -> CardOnFileDashboardRouting
}

final class CardOnFileDashboardBuilder: Builder<CardOnFileDashboardDependency>, CardOnFileDashboardBuildable {

    override init(dependency: CardOnFileDashboardDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: CardOnFileDashboardListener) -> CardOnFileDashboardRouting {
        let component = CardOnFileDashboardComponent(dependency: dependency)
        let viewController = CardOnFileDashboardViewController()
        let interactor = CardOnFileDashboardInteractor(
            presenter: viewController,
            dependency: component
        )
        interactor.listener = listener
        return CardOnFileDashboardRouter(interactor: interactor, viewController: viewController)
    }
}
