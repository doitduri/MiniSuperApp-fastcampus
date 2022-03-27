//
//  AdaptivePresentationControllerDelegate.swift
//  MiniSuperApp
//
//  Created by 김두리 on 2022/03/23.
//

import UIKit


// delegate -> weak로 Obejct (retain ..)
public protocol AdaptivePresentationControllerDelegate: AnyObject {
    func presentationControllerDidDismiss()
}

// Adapter를 대신해서 받는 객체
public final class AdaptivePresentationControllerDelegateProxy: NSObject, UIAdaptivePresentationControllerDelegate {
    
    public weak var delegate: AdaptivePresentationControllerDelegate?
    
    public func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        delegate?.presentationControllerDidDismiss()
    }
}
