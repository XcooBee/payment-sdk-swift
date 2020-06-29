//
//  Config.swift
//  PaymentSDK
//
//  Created by Maxym Krutykh on 21.06.2020.
//  Copyright © 2020 XcooBee. All rights reserved.
//

import Foundation

public struct XcooBeePayConfig {
    let campaignId: String
    let formId: String?
    let source: String?
    let deviceId: String?
    let xcoobeeDeviceId: String?
    
    public init(campaignId: String,
                formId: String? = nil,
                source: String? = nil,
                deviceId: String? = nil,
                xcoobeeDeviceId: String? = nil) {
        self.campaignId = campaignId
        self.formId = formId
        self.source = source
        self.deviceId = deviceId
        self.xcoobeeDeviceId = xcoobeeDeviceId
    }
}

enum SecurePayParams: String {
  case data = "d"
  case source = "s"
  case xcooBeeDeviceId = "did"
  case externalDeviceId = "ed"
}
