//
//  InputModel.swift
//  PaymentSDK
//
//  Created by Maxym Krutykh on 21.06.2020.
//  Copyright © 2020 XcooBee. All rights reserved.
//

import Foundation

public struct InputModel {
    let amount: Double
    let tax: Double?
    let reference: String?
    let config: XcooBeePayConfig?
    
    public init(amount: Double, tax: Double? = nil, reference: String? = nil, config: XcooBeePayConfig? = nil) {
        self.amount = amount
        self.tax = tax
        self.reference = reference
        self.config = config
    }
}
