//
//  InputModel.swift
//  PaymentSDK
//
//  Created by Maxym Krutykh on 21.06.2020.
//

import Foundation


/// Model for passing input parameters to XcooBeePaymentSDK
public struct XcooBeeInputModel {
    let amount: Double
    let tax: Double?
    let reference: String?
    let config: XcooBeePayConfig?
    
    /**
     - Parameters:
        - amount: amount
        - tax: tax the included tax of the item
        - reference: reference the item description or reference for payment
        - config: config the method specific configuration object override
     */
    
    public init(amount: Double, tax: Double? = nil, reference: String? = nil, config: XcooBeePayConfig? = nil) {
        self.amount = amount
        self.tax = tax
        self.reference = reference
        self.config = config
    }
}
