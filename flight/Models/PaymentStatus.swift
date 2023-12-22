//
//  PaymentStatus.swift
//  flight
//
//  Created by Иван Легенький on 22.12.2023.
//

import SwiftUI


enum PaymentStatus: String, CaseIterable {
    case started = "Conected..."
    case initiated = "Secure payment"
    case finished = "Purchased"
    
    var symbolImage: String {
        switch self {
        case .started:
            return "wifi"
        case .initiated:
            return "checkmark.shield"
        case .finished:
            return "checkmark"
        }
    }
}
