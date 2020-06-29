//
//  SecurePayLogic.swift
//  PaymentSDK
//
//  Created by Maxym Krutykh on 28.06.2020.
//  Copyright © 2020 XcooBee. All rights reserved.
//

import Foundation

struct SecurePayLogic {
    let action: SecurePayItemActions
    let minimum: Double?
    let maximum: Double?
    let fixed: Double?
    let reference: Any?
    
    init(action: SecurePayItemActions,
         minimum: Double? = nil,
         maximum: Double? = nil,
         fixed: Double? = nil,
         reference: Any? = nil ) {
        self.action = action
        self.minimum = minimum
        self.maximum = maximum
        self.fixed = fixed
        self.reference = reference
    }
    
    func toJSON() -> [String: Any] {
        let dict: [String: Any?] = [SecurePayLogicParam.action.rawValue: action.rawValue,
                                    SecurePayLogicParam.minimum.rawValue: minimum,
                                    SecurePayLogicParam.maximum.rawValue: maximum,
                                    SecurePayLogicParam.fixed.rawValue: fixed,
                                    SecurePayLogicParam.reference.rawValue: reference]
        return dict.compactMapValues { $0 }
    }
}

enum SecurePayItemActions: Int {
  case addMinOrFixed = 1
  case addMaxOrFixed = 2
  case addSubRadio = 3
  case addSubRadioWithExtraCost = 4
  case addSubCheckbox = 5
  case addSubCheckboxWithExtraCost = 6
  case setTip = 7
  case externalPricing = 8
  case userEntry = 9
  case setTotal = 10
}

enum SecurePayLogicParam: String {
    case action = "a"
    case minimum = "m"
    case maximum = "M"
    case fixed = "o"
    case reference = "r"
}
