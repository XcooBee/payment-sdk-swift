//
//  PaymentCore.swift
//  PaymentSDK
//
//  Created by Maxym Krutykh on 21.06.2020.
//

import UIKit

/// Main class of paymentSDK
public class PaymentCore {
    public static let shared = PaymentCore()
    
    private var config: XcooBeePayConfig?
    private let errorHandler: ErrorHandler
    private let urlProvider: UrlProvider
    private let qrImageProvider: QRImageProvider
    
    private init() {
        errorHandler = ErrorHandler()
        urlProvider = UrlProvider(errorHandler: errorHandler)
        qrImageProvider = QRImageProvider(errorHandler: errorHandler)
    }
    
    /// variable whick is used to check config status
    var isConfigAvailable: Bool {
        let isAvailable = config != nil
        if !isAvailable {
            errorHandler.showError(message: "config is required")
        }
        return isAvailable
    }
    
    var lastErrorMessage: String? {
        errorHandler.getLatesErrorMessage()
    }
    
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
        return qrImageProvider.generateQRCode(from: urlString, qrConfig: qrConfig)
    }
    
    // MARK: Create payment request with tip
    
    
    /// Returns a URL that can activate a total payment and predefined Tip calculator. This allows an additional Tip to be
    /// added to the total at checkout. Existing items in cart will be removed when this item is activated.
    public func createPayUrlWithTip(input: XcooBeeInputModel) -> URL? {
        let securepayItem = SecurePayItem(amount: input.amount, reference: input.reference, tax: input.tax, tip: true)
        let securePay = makeSecurePayItemTotal(securepayItem)
        let string = makePayUrl(securePay: securePay, forcedConfig: input.config)
        return URL(string: string)
    }
    
    /// Returns a QR that can activate a total payment and predefined Tip calculator. This allows an additional Tip to be
    /// added to the total at checkout. Existing items in cart will be removed when this item is activated.
    public func createPayQRWithTip(input: XcooBeeInputModel, qrConfig: XcooBeeQRConfig?) -> UIImage? {
        let urlString =  createPayUrlWithTip(input: input)?.absoluteString ?? ""
        return qrImageProvider.generateQRCode(from: urlString, qrConfig: qrConfig)
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
        return qrImageProvider.generateQRCode(from: urlString, qrConfig: qrConfig)
    }
    
    /// Return URL to add a single item to cart. The item has multiple options of which one can be selected
    public func createSingleSelectUrl(input: XcooBeeInputModel, items: [SecurePaySubItem]) -> URL? {
        guard validateSubItems(items) else { return nil }
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
        return qrImageProvider.generateQRCode(from: urlString, qrConfig: qrConfig)
    }
    
    /// Return URL to add a single item to cart. The item has multiple options of which one can be selected. Each option can also add cost to item total
    public func createSingleSelectWithCostUrl(input: XcooBeeInputModel, items: [SecurePaySubItemWithCost]) -> URL? {
        guard validateSubItemsWithCost(items) else { return nil }
        let securepayItem = SecurePayItem(amount: input.amount, reference: input.reference, tax: input.tax)
        let logic = SecurePayLogic(action: .addSubRadioWithExtraCost,
                                   reference: items.map { [$0.reference, $0.amount] })
        let securePay = makeSecurePayItem(securepayItem, logic: [logic])
        let string = makePayUrl(securePay: [securePay], forcedConfig: input.config)
        return URL(string: string)
    }
    
    /// Return QR to add a single item to cart. The item has multiple options of which one can be selected. Each option can also add cost to item total
    public func createSingleSelectWithCostQR(input: XcooBeeInputModel,
                                             items: [SecurePaySubItemWithCost],
                                             qrConfig: XcooBeeQRConfig?) -> UIImage? {
        let urlString =  createSingleSelectWithCostUrl(input: input, items: items)?.absoluteString ?? ""
        return qrImageProvider.generateQRCode(from: urlString, qrConfig: qrConfig)
    }
    
    /// Return URL to add a single item to cart. The item has multiple options of which any can be selected
    public func createMultiSelectUrl(input: XcooBeeInputModel, items: [SecurePaySubItem]) -> URL? {
        guard validateSubItems(items) else { return nil }
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
        return qrImageProvider.generateQRCode(from: urlString, qrConfig: qrConfig)
    }
    
    /// Return URL to add a single item to cart. The item has multiple options of which any can be selected. Each option  can also add cost to item total
    public func createMultiSelectUrlWithCost(input: XcooBeeInputModel, items: [SecurePaySubItemWithCost]) -> URL? {
        guard validateSubItemsWithCost(items) else { return nil }
        let securepayItem = SecurePayItem(amount: input.amount, reference: input.reference, tax: input.tax)
        let logic = SecurePayLogic(action: .addSubCheckboxWithExtraCost,
                                   reference: items.map { [$0.reference, $0.amount] })
        let securePay = makeSecurePayItem(securepayItem, logic: [logic])
        let string = makePayUrl(securePay: [securePay], forcedConfig: input.config)
        return URL(string: string)
    }
    
    /// Return QR to add a single item to cart. The item has multiple options of which any can be selected. Each option can also add cost to item total
    public func createMultiSelectQRWithCost(input: XcooBeeInputModel,
                                     items: [SecurePaySubItemWithCost],
                                     qrConfig: XcooBeeQRConfig?) -> UIImage? {
        let urlString =  createMultiSelectUrlWithCost(input: input, items: items)?.absoluteString ?? ""
        return qrImageProvider.generateQRCode(from: urlString, qrConfig: qrConfig)
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
        return qrImageProvider.generateQRCode(from: urlString, qrConfig: qrConfig)
    }
    
    
    public func  makePayUrl(securePay: [SecurePay?], forcedConfig: XcooBeePayConfig?) -> String {
        guard let config = forcedConfig ?? self.config else {
            errorHandler.showError(message: "Instance is not configured, invoke setConfig() before using functions.")
            return ""
        }
        
        let securePay = securePay.compactMap { $0 }
        
        if securePay.count == 0 { return "" }
        
        if checkConfig(config: config) {
            return urlProvider.makePayUrl(securePay: securePay, config: config)
        } else {
            return ""
        }
    }
    
    private func checkConfig(config: XcooBeePayConfig) -> Bool {
        if (!NSPredicate(format: "SELF MATCHES %@", Constants.regexpCampaingId).evaluate(with: config.campaignId)) {
            errorHandler.showError(message: "Campaign id has incorrect format")
            return false
        }
        
        if (config.formId != nil &&
            !NSPredicate(format: "SELF MATCHES %@", Constants.regexpFormId).evaluate(with: config.formId)) {
            errorHandler.showError(message: "Form id has incorrect format")
            return false
        }
        return true
    }
    
    private func makeSecurePayItemTotal(_ securePayItem: SecurePayItem) -> [SecurePay] {
        let payload = makeSecurePayItem(securePayItem, logic: [SecurePayLogic(action: .setTotal)])
        guard let securePay = payload else { return [] }
        return securePayItem.tip ?
            [
                securePay,
                SecurePay(reference: "Tip", logic: [SecurePayLogic(action: .setTip)])
            ] : [
                securePay
        ];
    }
    
    private func makeSecurePayItem(_ securePayItem: SecurePayItem?, logic: [SecurePayLogic]) -> SecurePay? {
        if ((securePayItem?.amount ?? 0) > Constants.maxAmount) {
            errorHandler.showError(message: "Amount parameter should be less than \(Constants.maxAmount)")
            return nil
        }
        
        if ((securePayItem?.reference ?? "").count > Constants.maxReferenceLength) {
            errorHandler.showError(message: "Reference parameter should be less than \(Constants.maxReferenceLength)")
            return nil
        }
        return SecurePay(amount: securePayItem?.amount,
                         tax: securePayItem?.tax,
                         reference: securePayItem?.reference,
                         logic: logic)
    }
    
    private func validateSubItems(_ items: [SecurePaySubItem] ) -> Bool {
        let result = items.reduce(true) { $0 && $1.reference.count < Constants.maxSubItemsRefLength }
        if !result {
            let message = " Sub Item Reference parameter should be less than \(Constants.maxSubItemsRefLength)"
            errorHandler.showError(message: message)
        }
        return result
    }
 
    private func validateSubItemsWithCost(_ items: [SecurePaySubItemWithCost] ) -> Bool {
        let result = items.reduce(true) {
            $0 && $1.reference.count < Constants.maxSubItemsRefLength && $1.amount < Constants.maxSubItemAmount
        }
        if !result {
            let message = """
            Sub Item Reference parameter should be less than \(Constants.maxSubItemsRefLength)
            Sub Item Amount parameter should be less than \(Constants.maxSubItemAmount)
            """
            errorHandler.showError(message: message)
        }
        return result
    }
}
