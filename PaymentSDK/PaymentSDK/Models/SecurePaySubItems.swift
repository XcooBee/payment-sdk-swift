//
//  SecurePaySubItems.swift
//  PaymentSDK
//
//  Created by Maxym Krutykh on 29.06.2020.
//  Copyright © 2020 XcooBee. All rights reserved.
//

import Foundation

public struct SecurePaySubItem {
    let reference: String
}

public struct SecurePaySubItemWithCost {
    let reference: String
    let amount: Double
}
