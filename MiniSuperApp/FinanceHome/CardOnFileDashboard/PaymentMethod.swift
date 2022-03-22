//
//  PaymentMethod.swift
//  MiniSuperApp
//
//  Created by 김두리 on 2022/03/22.
//

import Foundation

struct PaymentMethod: Decodable {
    let id: String
    let name: String
    let digits: String
    let color: String
    let isPrimary: Bool
}
