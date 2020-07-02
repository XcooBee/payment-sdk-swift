//
//  ErrorHandler.swift
//  PaymentSDK
//
//  Created by Maxym Krutykh on 30.06.2020.
//  Copyright © 2020 XcooBee. All rights reserved.
//

import Foundation
import os.log

/// Helper mehods to test erro messages and print them to console
class ErrorHandler {
    
    private var error: String?
    
    /// get last error message
    func getLatesErrorMessage() -> String? {
        return error
    }
    
    /// print error to console
    func showError(message: String) {
        error = message
        print(message)
    }
    
    /// clear last error message
    func clearErrorMessage() {
        error = nil
    }
}
