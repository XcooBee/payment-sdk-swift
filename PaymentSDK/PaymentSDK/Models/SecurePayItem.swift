//
//  SecurePayItem.swift
//  PaymentSDK
//
//  Created by Maxym Krutykh on 28.06.2020.
//  Copyright © 2020 XcooBee. All rights reserved.
//

import Foundation

struct SecurePayItem {
    let amount: Double?
    let reference: String?
    let tax: Double?
    let tip: Bool
    
    init(amount: Double? = nil, reference: String? = nil, tax: Double? = nil, tip: Bool = false) {
        self.amount = amount
        self.reference = reference
        self.tax = tax
        self.tip = tip
    }
};
