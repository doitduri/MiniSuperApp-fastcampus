//
//  File.swift
//  
//
//  Created by 김두리 on 2022/03/27.
//

import Foundation
import ModernRIBs

public protocol TopupBuildable: Buildable {
    func build(withListener listener: TopupListener) -> Routing
}

public protocol TopupListener: AnyObject {
    func topupDidClose()
    func topupDidFinish()
}
