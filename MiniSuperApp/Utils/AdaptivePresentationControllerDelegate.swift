//
//  AdaptivePresentationControllerDelegate.swift
//  MiniSuperApp
//
//  Created by 김두리 on 2022/03/23.
//

import UIKit


// delegate -> weak로 Obejct (retain ..)
protocol AdaptivePresentationControllerDelegate: AnyObject {
    func presentationControllerDidDismiss()
}

// Adapter를 대신해서 받는 객체
final class AdaptivePresentationControllerDelegateProxy: NSObject, UIAdaptivePresentationControllerDelegate {
    
    weak var delegate: AdaptivePresentationControllerDelegate?
    
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        delegate?.presentationControllerDidDismiss()
    }
}
