//
//  PaymentCore.swift
//  PaymentSDK
//
//  Created by Maxym Krutykh on 21.06.2020.
//  Copyright © 2020 XcooBee. All rights reserved.
//

import UIKit
import os.log

public class PaymentCore {
    public static let shared = PaymentCore()
    
    private var config: XcooBeePayConfig?
    
    private init() {}
    
    public func setSystemConfig(_ config: XcooBeePayConfig) {
        self.config = config
    }
    
    public func clearSystemConfig() {
        self.config = nil
    }
    
    // MARK: Create simple payment request
    
     /// Returns URL that can activate a single total payment. Existing items will be deleted. Only this item can be
     /// processed. If you use zero amount, the user can enter the amount for payment.
    public func createPayUrl (input: XcooBeeInputModel) -> URL? {
        let securepayItem = SecurePayItem(amount: input.amount, reference: input.reference, tax: input.tax)
        let securePay = makeSecurePayItemTotal(securepayItem)
        let string = makePayUrl(securePay: securePay, forcedConfig: input.config)
        return URL(string: string)
    }
    
    
     /// Returns QR that can activate a single total payment. Existing items will be deleted. Only this item can be
     /// processed. If you use zero amount, the user can enter the amount for payment.
    public func createPayQR(input: XcooBeeInputModel, qrConfig: XcooBeeQRConfig?) -> UIImage? {
        let urlString =  createPayUrl(input: input)?.absoluteString ?? ""
        return QRImageProvider.generateQRCode(from: urlString, qrConfig: qrConfig)
    }
    
    // MARK: Create payment request with tip
    
    
    /// Returns a URL that can activate a total payment and predefined Tip calculator. This allows an additional Tip to be
    /// added to the total at checkout. Existing items in cart will be removed when this item is activated.
    public func createPayUrlwithTip(input: XcooBeeInputModel) -> URL? {
        let securepayItem = SecurePayItem(amount: input.amount, reference: input.reference, tax: input.tax, tip: true)
        let securePay = makeSecurePayItemTotal(securepayItem)
        let string = makePayUrl(securePay: securePay, forcedConfig: input.config)
        return URL(string: string)
    }
    
    /// Returns a QR that can activate a total payment and predefined Tip calculator. This allows an additional Tip to be
    /// added to the total at checkout. Existing items in cart will be removed when this item is activated.
    public func createPayQRwithTip(input: XcooBeeInputModel, qrConfig: XcooBeeQRConfig?) -> UIImage? {
        let urlString =  createPayUrlwithTip(input: input)?.absoluteString ?? ""
        return QRImageProvider.generateQRCode(from: urlString, qrConfig: qrConfig)
    }
    
    // MARK: eCommerce Method
    
    /// Return URL that adds new item to eCommerce basket.
    public func createSingleItemUrl(input: XcooBeeInputModel) -> URL? {
        let securepayItem = SecurePayItem(amount: input.amount, reference: input.reference, tax: input.tax)
        let securePay = makeSecurePayItem(securepayItem, logic: [SecurePayLogic(action: .userEntry)])
        let string = makePayUrl(securePay: [securePay], forcedConfig: input.config)
        return URL(string: string)
    }
    
    /// Return QR that adds new item to eCommerce basket
    public func createSingleItemQR(input: XcooBeeInputModel, qrConfig: XcooBeeQRConfig?) -> UIImage? {
        let urlString =  createSingleItemUrl(input: input)?.absoluteString ?? ""
        return QRImageProvider.generateQRCode(from: urlString, qrConfig: qrConfig)
    }
    
    /// Return URL to add a single item to cart. The item has multiple options of which one can be selected
    public func createSingleSelectUrl(input: XcooBeeInputModel, items: [SecurePaySubItem]) -> URL? {
        let securepayItem = SecurePayItem(amount: input.amount, reference: input.reference, tax: input.tax)
        let logic = SecurePayLogic(action: .addSubRadio, reference: items.map { $0.reference })
        let securePay = makeSecurePayItem(securepayItem, logic: [logic])
        let string = makePayUrl(securePay: [securePay], forcedConfig: input.config)
        return URL(string: string)
    }
    
    /// Return QR to add a single item to cart. The item has multiple options of which one can be selected
    public func createSingleSelectQR(input: XcooBeeInputModel,
                                     items: [SecurePaySubItem],
                                     qrConfig: XcooBeeQRConfig?) -> UIImage? {
        let urlString =  createSingleSelectUrl(input: input, items: items)?.absoluteString ?? ""
        return QRImageProvider.generateQRCode(from: urlString, qrConfig: qrConfig)
    }
    
    /// Return URL to add a single item to cart. The item has multiple options of which one can be selected. Each option can also add cost to item total
    public func createSingleSelectWithCostUrl(input: XcooBeeInputModel, items: [SecurePaySubItemWithCost]) -> URL? {
        let securepayItem = SecurePayItem(amount: input.amount, reference: input.reference, tax: input.tax)
        let logic = SecurePayLogic(action: .addSubRadioWithExtraCost,
                                   reference: items.map { ($0.reference, $0.amount) })
        let securePay = makeSecurePayItem(securepayItem, logic: [logic])
        let string = makePayUrl(securePay: [securePay], forcedConfig: input.config)
        return URL(string: string)
    }
    
    /// Return QR to add a single item to cart. The item has multiple options of which one can be selected. Each option can also add cost to item total
    public func createSingleSelectWithCostQR(input: XcooBeeInputModel,
                                             items: [SecurePaySubItemWithCost],
                                             qrConfig: XcooBeeQRConfig?) -> UIImage? {
        let urlString =  createSingleSelectWithCostUrl(input: input, items: items)?.absoluteString ?? ""
        return QRImageProvider.generateQRCode(from: urlString, qrConfig: qrConfig)
    }
    
    /// Return URL to add a single item to cart. The item has multiple options of which any can be selected
    public func createMultiSelectUrl(input: XcooBeeInputModel, items: [SecurePaySubItem]) -> URL? {
        let securepayItem = SecurePayItem(amount: input.amount, reference: input.reference, tax: input.tax)
        let logic = SecurePayLogic(action: .addSubCheckbox, reference: items.map { $0.reference })
        let securePay = makeSecurePayItem(securepayItem, logic: [logic])
        let string = makePayUrl(securePay: [securePay], forcedConfig: input.config)
        return URL(string: string)
    }
    
    /// Return QR to add a single item to cart. The item has multiple options of which any can be selected
    public func createMultiSelectQR(input: XcooBeeInputModel,
                             items: [SecurePaySubItem],
                             qrConfig: XcooBeeQRConfig?) -> UIImage? {
        let urlString =  createMultiSelectUrl(input: input, items: items)?.absoluteString ?? ""
        return QRImageProvider.generateQRCode(from: urlString, qrConfig: qrConfig)
    }
    
    /// Return URL to add a single item to cart. The item has multiple options of which any can be selected. Each option  can also add cost to item total
    public func createMultiSelectUrlWithCost(input: XcooBeeInputModel, items: [SecurePaySubItemWithCost]) -> URL? {
        let securepayItem = SecurePayItem(amount: input.amount, reference: input.reference, tax: input.tax)
        let logic = SecurePayLogic(action: .addSubCheckboxWithExtraCost,
                                   reference: items.map { ($0.reference, $0.amount) })
        let securePay = makeSecurePayItem(securepayItem, logic: [logic])
        let string = makePayUrl(securePay: [securePay], forcedConfig: input.config)
        return URL(string: string)
    }
    
    /// Return QR to add a single item to cart. The item has multiple options of which any can be selected. Each option can also add cost to item total
    public func createMultiSelectQRWithCost(input: XcooBeeInputModel,
                                     items: [SecurePaySubItemWithCost],
                                     qrConfig: XcooBeeQRConfig?) -> UIImage? {
        let urlString =  createMultiSelectUrlWithCost(input: input, items: items)?.absoluteString ?? ""
        return QRImageProvider.generateQRCode(from: urlString, qrConfig: qrConfig)
    }
    
    /// Create URL that uses external (XcooBee Hosted) definition for cost, image, and option logic. Obtain references from XcooBee
    public func createExternalReferenceURL(priceCode: String, config: XcooBeePayConfig?) -> URL? {
        let logic = SecurePayLogic(action: .externalPricing,
                                   reference: priceCode)
        let securePay = makeSecurePayItem(nil, logic: [logic])
        let string = makePayUrl(securePay: [securePay], forcedConfig: config)
        return URL(string: string)
    }
    
    /// Create URL that uses external (XcooBee Hosted) definition for cost, image, and option logic. Obtain references from XcooBee
    public func createExternalReferenceQR(priceCode: String,
                                          qrConfig: XcooBeeQRConfig?,
                                          config: XcooBeePayConfig?) -> UIImage? {
        let urlString =  createExternalReferenceURL(priceCode: priceCode, config: config)?.absoluteString ?? ""
        return QRImageProvider.generateQRCode(from: urlString, qrConfig: qrConfig)
    }
    
    
    public func  makePayUrl(securePay: [SecurePay], forcedConfig: XcooBeePayConfig?) -> String {
        guard let config = forcedConfig ?? self.config else {
            os_log(.error, "Instance is not configured, invoke setConfig() before using functions.")
            return ""
        }
        checkConfig(config: config)
        return UrlProvider.makePayUrl(securePay: securePay, config: config)
    }
    
    private func checkConfig(config: XcooBeePayConfig) {
        if (!NSPredicate(format: "SELF MATCHES %@", Constants.regexpCampaingId).evaluate(with: config.campaignId)) {
            os_log(.info, "Campaign id has incorrect format")
        }
        
        if (!NSPredicate(format: "SELF MATCHES %@", Constants.regexpFormId).evaluate(with: config.formId)) {
            os_log(.info, "Form id has incorrect format")
        }
    }
    
    private func makeSecurePayItemTotal(_ securePayItem: SecurePayItem) -> [SecurePay] {
        let payload = makeSecurePayItem(securePayItem, logic: [SecurePayLogic(action: .setTotal)])

        return securePayItem.tip ?
            [
                payload,
                SecurePay(reference: "Tip", logic: [SecurePayLogic(action: .setTip)])
            ] : [
                payload
        ];
    }
    
    private func makeSecurePayItem(_ securePayItem: SecurePayItem?, logic: [SecurePayLogic]) -> SecurePay {
        return SecurePay(amount: securePayItem?.amount,
                         tax: securePayItem?.tax,
                         reference: securePayItem?.reference,
                         logic: logic)
    }

}
