//
//  BaseURL.swift
//  MiniSuperApp
//
//  Created by 김두리 on 2022/03/28.
//

import Foundation

struct BaseURL {
    var financeBaseURL: URL {
        return URL(string: "https://finance.superapp.com/api/v1")!
    }
}
