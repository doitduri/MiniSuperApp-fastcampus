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

final class AppRootComponent: Component<AppRootDependency>, AppHomeDependency, FinanceHomeDependency, ProfileHomeDependency, TransportHomeDependency {
    
    var cardsOnFileRepository: CardOnFileRepository
    var superPayRepository: SuperPayRepository
    
    lazy var transportHomeBuildable: TransportHomeBuildable = {
        return TransportHomeBuilder(dependency: self)
    }()
    
    init(
        dependency: AppRootDependency,
        cardsOnFileRepository: CardOnFileRepository,
        superPayRepository: SuperPayRepository
    ) {
        self.cardsOnFileRepository = cardsOnFileRepository
        self.superPayRepository = superPayRepository
        super.init(dependency: dependency)
    }
}
