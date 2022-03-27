//
//  AppRootComponent.swift
//  MiniSuperApp
//
//  Created by 김두리 on 2022/03/27.
//

import Foundation
import ModernRIBs
import AppHome
import FinanceHome
import ProfileHome
import TransportHome
import FinanceRepository
import TransportHomeImp
import Topup
import TopupImp

final class AppRootComponent: Component<AppRootDependency>, AppHomeDependency, FinanceHomeDependency, ProfileHomeDependency, TransportHomeDependency, TopupDependency {
    
    var cardsOnFileRepository: CardOnFileRepository
    var superPayRepository: SuperPayRepository
    
    lazy var transportHomeBuildable: TransportHomeBuildable = {
        return TransportHomeBuilder(dependency: self)
    }()
    
    lazy var topupBuildable: TopupBuildable = {
        return TopupBuilder(dependency: self)
    }()
    
    var topupBaseViewController: ViewControllable { rootViewController.topViewControllerable }
    
    private let rootViewController: ViewControllable
    
    init(
        dependency: AppRootDependency,
        cardsOnFileRepository: CardOnFileRepository,
        superPayRepository: SuperPayRepository,
        rootViewController: ViewControllable
    ) {
        self.cardsOnFileRepository = cardsOnFileRepository
        self.superPayRepository = superPayRepository
        self.rootViewController = rootViewController
        super.init(dependency: dependency)
    }
}
