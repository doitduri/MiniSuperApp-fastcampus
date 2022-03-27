//
//  File.swift
//  
//
//  Created by 김두리 on 2022/03/25.
//

import Foundation

extension Array {
  subscript(safe index: Int) -> Element? {
    return indices ~= index ? self[index] : nil
  }
}
