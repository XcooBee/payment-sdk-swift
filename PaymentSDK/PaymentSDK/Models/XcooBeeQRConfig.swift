//
//  XcooBeeQRConfig.swift
//  PaymentSDK
//
//  Created by Maxym Krutykh on 29.06.2020.
//

import Foundation

/// Model for sdk qr configs
public struct XcooBeeQRConfig {
    let size: Int
    
    public init(size: Int) {
        self.size = size
    }
}
