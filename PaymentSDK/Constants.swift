//
//  Constants.swift
//  PaymentSDK
//
//  Created by Maxym Krutykh on 29.06.2020.
//

import Foundation

/// sdk constants
struct Constants {
    static let maxAmount = 9999.99
    static let maxDataLength = 1800
    static let maxDeviceIdLength = 200
    static let maxReferenceLength = 40
    static let maxSourceLength = 10
    static let maxSubItemAmount = 25.0
    static let maxSubItemsRefLength = 40
    static let appUrl = "https://app.xcoobee.net"
    static let regexpCampaingId = "^[a-z\\d]{3}\\.[a-z\\d]{8,10}$"
    static let regexpFormId = "^[a-z\\d]{3,5}$"
}
