//
//  File.swift
//  
//
//  Created by 김두리 on 2022/03/27.
//

import Foundation

struct Formatter {
    static let balanceFormatter: NumberFormatter =  {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
}
