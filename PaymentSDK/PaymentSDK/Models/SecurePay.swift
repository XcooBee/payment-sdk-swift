//
//  SecurePay.swift
//  PaymentSDK
//
//  Created by Maxym Krutykh on 28.06.2020.
//  Copyright © 2020 XcooBee. All rights reserved.
//

import Foundation

public struct SecurePay {
    let amount: Double?
    let tax: Double?
    let reference: String?
    let logic: [SecurePayLogic]?
    
    init(amount: Double? = nil, tax: Double? = nil, reference: String? = nil, logic: [SecurePayLogic]? = nil) {
        self.amount = amount
        self.tax = tax
        self.reference = reference
        self.logic = logic
    }
    
    func toJSON() -> [String: Any] {
        let dict: [String: Any?] = [SecurePayItemParams.amount.rawValue: amount,
                                    SecurePayItemParams.tax.rawValue: tax,
                                    SecurePayItemParams.reference.rawValue: reference,
                                    SecurePayItemParams.logic.rawValue: logic?.compactMap{ $0.toJSON() }]
        return dict.compactMapValues { $0 }
    }
}

enum SecurePayItemParams: String {
  case amount = "0-3"
  case tax = "0-5"
  case reference = "0-6"
  case logic = "l"
}
