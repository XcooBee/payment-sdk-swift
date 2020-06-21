//
//  PaymentCore.swift
//  PaymentSDK
//
//  Created by Maxym Krutykh on 21.06.2020.
//  Copyright © 2020 XcooBee. All rights reserved.
//

import UIKit

public class PaymentCore {
    public static let shared = PaymentCore()
    
    private var config: Config?
    
    private init() {}
    
    func setSystemConfig(_ config: Config) {
        self.config = config
    }
    
    func clearSystemConfig() {
        self.config = nil
    }
    
    // MARK: Create simple payment request
    
    func createPayUrl (input: InputModel, conig: Config) -> URL? {
        return nil
    }
    
    func createPayQR(input: InputModel, size: Int, conig: Config) -> UIImage? {
        return nil
    }
    
    // MARK: Create payment request with tip
    
    func createPayUrlwithTip(input: InputModel, conig: Config) -> URL? {
        return nil
    }
    
    func createPayQRwithTip(input: InputModel, size: Int, conig: Config) -> UIImage? {
        return nil
    }
    
    // MARK: eCommerce Method
    
    func createSingleItemUrl(input: InputModel, conig: Config) -> URL? {
        return nil
    }
    
    func createSingleItemQR(input: InputModel, size: Int, conig: Config) -> UIImage? {
        return nil
    }
    
    func createSingleSelectUrl(input: InputModel, items: [String], conig: Config) -> URL? {
        return nil
    }
    
    func createSingleSelectWithCostUrl(input: InputModel, items: [(String, Double)], conig: Config) -> URL? {
        return nil
    }
    
    func createMultiSelectUrl(input: InputModel, items: [String], conig: Config) -> URL? {
        return nil
    }
    
    func createMultiSelectQR(input: InputModel, items: [String], size: Int, conig: Config) -> UIImage? {
        return nil
    }
    
    func createMultiSelectUrlWithCost(input: InputModel, items: [(String, Double)], conig: Config) -> URL? {
        return nil
    }
    
    func createMultiSelctQRWithCost(input: InputModel, items: [(String, Int)], size: Int, conig: Config) -> UIImage? {
        return nil
    }
    
    func createExternalReferenceURL(priceCode: String, config: Config) -> URL? {
        return nil
    }
    
    func createExternalReferenceQR(priceCode: String, size: Int, config: Config) -> UIImage? {
        return nil
    }
}
