//
//  Config.swift
//  PaymentSDK
//
//  Created by Maxym Krutykh on 21.06.2020.
//

import Foundation

/// Model for sdk configs
public struct XcooBeePayConfig {
    let campaignId: String
    let formId: String
    let source: String?
    let deviceId: String?
    let xcoobeeDeviceId: String?
    
    /**
    - Parameters:
       - campaignId: XcooBee campaign id.
       - formId: Form id for the campaign.
       - deviceId: External device id.
       - source: Source tracking reference for order.
       - xcoobeeDeviceId: XcooBee device id. (Only available if your device is connected to XcooBee network).
     If this is provided the “DeviceId” should not be provided. They are mutually exclusive and only XcooBeeDeviceId will be used.
    */
    public init(campaignId: String,
                formId: String,
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
