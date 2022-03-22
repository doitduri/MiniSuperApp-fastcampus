//
//  SuperPayDashboardViewController.swift
//  MiniSuperApp
//
//  Created by 김두리 on 2022/03/22.
//

import ModernRIBs
import UIKit

protocol SuperPayDashboardPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class SuperPayDashboardViewController: UIViewController, SuperPayDashboardPresentable, SuperPayDashboardViewControllable {

    weak var listener: SuperPayDashboardPresentableListener?
}
