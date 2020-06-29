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
    
    private var config: XcooBeePayConfig?
    
    private let appUrl = "https://app.xcoobee.com"
    
    private init() {}
    
    public func setSystemConfig(_ config: XcooBeePayConfig) {
        self.config = config
    }
    
    public func clearSystemConfig() {
        self.config = nil
    }
    
    // MARK: Create simple payment request
    
    public func createPayUrl (input: InputModel) -> URL? {
        let securepayItem = SecurePayItem(amount: input.amount, reference: input.reference, tax: input.tax)
        let securePay = makeSecurePayItemTotal(securepayItem)
        let string = makePayUrl(securePay: securePay, forcedConfig: input.config)
        return URL(string: string)
    }
    
    public func createPayQR(input: InputModel, size: Int) -> UIImage? {
        let urlString =  createPayUrl(input: input)?.absoluteString ?? ""
        return generateQRCode(from: urlString, size: size)
    }
    
    // MARK: Create payment request with tip
    
    public func createPayUrlwithTip(input: InputModel) -> URL? {
        let securepayItem = SecurePayItem(amount: input.amount, reference: input.reference, tax: input.tax, tip: true)
        let securePay = makeSecurePayItemTotal(securepayItem)
        let string = makePayUrl(securePay: securePay, forcedConfig: input.config)
        return URL(string: string)
    }
    
    public func createPayQRwithTip(input: InputModel, size: Int) -> UIImage? {
        let urlString =  createPayUrlwithTip(input: input)?.absoluteString ?? ""
        return generateQRCode(from: urlString, size: size)
    }
    
    // MARK: eCommerce Method
    
    public func createSingleItemUrl(input: InputModel) -> URL? {
        let securepayItem = SecurePayItem(amount: input.amount, reference: input.reference, tax: input.tax)
        let securePay = makeSecurePayItem(securepayItem, logic: [SecurePayLogic(action: .userEntry)])
        let string = makePayUrl(securePay: [securePay], forcedConfig: input.config)
        return URL(string: string)
    }
    
    public func createSingleItemQR(input: InputModel, size: Int) -> UIImage? {
        let urlString =  createSingleItemUrl(input: input)?.absoluteString ?? ""
        return generateQRCode(from: urlString, size: size)
    }
    
    func createSingleSelectUrl(input: InputModel, items: [SecurePaySubItem]) -> URL? {
        let securepayItem = SecurePayItem(amount: input.amount, reference: input.reference, tax: input.tax)
        let logic = SecurePayLogic(action: .addSubRadio, reference: items.map { $0.reference })
        let securePay = makeSecurePayItem(securepayItem, logic: [logic])
        let string = makePayUrl(securePay: [securePay], forcedConfig: input.config)
        return URL(string: string)
    }
    
    public func createSingleSelectQR(input: InputModel, items: [SecurePaySubItem], size: Int) -> UIImage? {
        let urlString =  createSingleSelectUrl(input: input, items: items)?.absoluteString ?? ""
        return generateQRCode(from: urlString, size: size)
    }
    
    func createSingleSelectWithCostUrl(input: InputModel, items: [SecurePaySubItemWithCost]) -> URL? {
        let securepayItem = SecurePayItem(amount: input.amount, reference: input.reference, tax: input.tax)
        let logic = SecurePayLogic(action: .addSubRadioWithExtraCost,
                                   reference: items.map { ($0.reference, $0.amount) })
        let securePay = makeSecurePayItem(securepayItem, logic: [logic])
        let string = makePayUrl(securePay: [securePay], forcedConfig: input.config)
        return URL(string: string)
    }
    
    public func createSingleSelectWithCostQR(input: InputModel, items: [SecurePaySubItemWithCost], size: Int) -> UIImage? {
        let urlString =  createSingleSelectWithCostUrl(input: input, items: items)?.absoluteString ?? ""
        return generateQRCode(from: urlString, size: size)
    }
    
    func createMultiSelectUrl(input: InputModel, items: [SecurePaySubItem]) -> URL? {
        let securepayItem = SecurePayItem(amount: input.amount, reference: input.reference, tax: input.tax)
        let logic = SecurePayLogic(action: .addSubCheckbox, reference: items.map { $0.reference })
        let securePay = makeSecurePayItem(securepayItem, logic: [logic])
        let string = makePayUrl(securePay: [securePay], forcedConfig: input.config)
        return URL(string: string)
    }
    
    func createMultiSelectQR(input: InputModel, items: [SecurePaySubItem], size: Int) -> UIImage? {
        let urlString =  createMultiSelectUrl(input: input, items: items)?.absoluteString ?? ""
        return generateQRCode(from: urlString, size: size)
    }
    
    func createMultiSelectUrlWithCost(input: InputModel, items: [SecurePaySubItemWithCost]) -> URL? {
        let securepayItem = SecurePayItem(amount: input.amount, reference: input.reference, tax: input.tax)
        let logic = SecurePayLogic(action: .addSubCheckboxWithExtraCost,
                                   reference: items.map { ($0.reference, $0.amount) })
        let securePay = makeSecurePayItem(securepayItem, logic: [logic])
        let string = makePayUrl(securePay: [securePay], forcedConfig: input.config)
        return URL(string: string)
    }
    
    func createMultiSelctQRWithCost(input: InputModel, items: [SecurePaySubItemWithCost], size: Int) -> UIImage? {
        let urlString =  createMultiSelectUrlWithCost(input: input, items: items)?.absoluteString ?? ""
        return generateQRCode(from: urlString, size: size)
    }
    
    func createExternalReferenceURL(priceCode: String, config: XcooBeePayConfig?) -> URL? {
        let logic = SecurePayLogic(action: .externalPricing,
                                   reference: priceCode)
        let securePay = makeSecurePayItem(nil, logic: [logic])
        let string = makePayUrl(securePay: [securePay], forcedConfig: config)
        return URL(string: string)
    }
    
    func createExternalReferenceQR(priceCode: String, size: Int, config: XcooBeePayConfig?) -> UIImage? {
        let urlString =  createExternalReferenceURL(priceCode: priceCode, config: config)?.absoluteString ?? ""
        return generateQRCode(from: urlString, size: size)
    }
    
    private func generateQRCode(from string: String, size: Int?) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)
        
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let scaleValue = scaleSize(value: filter.outputImage?.extent.height, size: size)
            let transform = CGAffineTransform(scaleX: scaleValue, y: scaleValue)
            let logoImage = UIImage(named: "xcoobee-logo")
            if let output = filter.outputImage?.transformed(by: transform), let logo = logoImage.flatMap({CIImage(image: $0)}) {
                let image = output.combined(with: logo)
                return image.map { UIImage(ciImage: $0) }
            }
        }
        
        return nil
    }
    
    private func scaleSize(value: CGFloat?, size: Int?) -> CGFloat {
        let imageSize = CGFloat(size ?? 150)
        let scale = imageSize / (value ?? 0)
        return scale
    }
    
    
    private func  makePayUrl(securePay: [SecurePay], forcedConfig: XcooBeePayConfig?) -> String {
        
        guard let config = forcedConfig ?? self.config else { return "" }

      let  dataBase64 = convertToBase64(securePay: securePay)

//      const externalDeviceId = (config!.deviceId || '').substring(0, MAX_DEVICE_ID_LENGTH);
//      const xcoobeeDeviceId = (config!.XcooBeeDeviceId || '').substring(0, MAX_DEVICE_ID_LENGTH);
//      const source = (config!.source || '').substring(0, MAX_SOURCE_LENGTH);
//
//      const deviceId = !!config!.XcooBeeDeviceId ? {
//        [SecurePayParams.XcooBeeDeviceId]: xcoobeeDeviceId || undefined
//      } : {
//        [SecurePayParams.ExternalDeviceId]: externalDeviceId || undefined
//      };
//
//      if (dataBase64.length > MAX_DATA_LENGTH) {
//        console.warn('Data parameter encoded to Base64 is bigger than', MAX_DATA_LENGTH);
//      }
//
//      if ((deviceId[SecurePayParams.XcooBeeDeviceId] || '').length > MAX_DEVICE_ID_LENGTH) {
//        console.warn('XcooBeeDeviceId parameter is bigger than', MAX_DEVICE_ID_LENGTH);
//      }
//
//      if ((deviceId[SecurePayParams.ExternalDeviceId] || '').length > MAX_DEVICE_ID_LENGTH) {
//        console.warn('ExternalDeviceId parameter is bigger than', MAX_DEVICE_ID_LENGTH);
//      }
//
//      if ((source || '').length > MAX_SOURCE_LENGTH) {
//        console.warn('Source parameter is bigger than', MAX_DEVICE_ID_LENGTH);
//      }
//
//      return QueryString.stringifyUrl({
//        url: `${WEB_SITE_URL}/securePay/${config!.campaignId}/${config!.formId}`,
//        query: {
//          [SecurePayParams.Data]: dataBase64.substring(0, MAX_DATA_LENGTH),
//          [SecurePayParams.Source]: source || undefined,
//          ...deviceId,
//        }
//      });
        let deviceQuery = config.xcoobeeDeviceId != nil ? [SecurePayParams.xcooBeeDeviceId.rawValue: config.xcoobeeDeviceId] :
            [SecurePayParams.externalDeviceId.rawValue: config.deviceId]
        var query = [
            SecurePayParams.data.rawValue: dataBase64,
            SecurePayParams.source.rawValue: config.source,
        ]
        for (key, value) in deviceQuery {
            query[key] = value
        }
        
        let queryString = query.compactMapValues{ $0 }.map { "\($0.key)=\($0.value)" }.joined(separator: "&")
        let url = "\(appUrl)/securePay/\(config.campaignId)\(config.formId.map{ "/\($0)" } ?? "")/\(queryString)"
        return url
    }
    
    private func convertToBase64(securePay: [SecurePay]) -> String? {
        let json = securePay.map { $0.toJSON() }
        guard let data = try? JSONSerialization.data(withJSONObject: json, options: []) else {
            return nil
        }
        let base64Encoded = data.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0))
        print("Encoded: \(base64Encoded)")

        if let base64Decoded = Data(base64Encoded: base64Encoded, options: Data.Base64DecodingOptions(rawValue: 0))
            .map({ String(data: $0, encoding: .utf8) }) {
            // Convert back to a string
            print("Decoded: \(base64Decoded ?? "")")
        }
        
        return base64Encoded
        
    }
    
    private func checkConfig(config: XcooBeePayConfig?) -> Bool {
//      if (!config) {
//        throw new Error('Instance is not configured, invoke setConfig() before using functions.');
//      }
//
//      if (!config.campaignId) {
//        throw new Error('Campaign id is not configured. Invoke setConfig() before using functions.');
//      } else if (!config.campaignId.match(REGEXP_CAMPAIGN_ID)) {
//        console.warn('Campaign id has incorrect format.');
//      }
//
//      if (!config.formId) {
//        throw new Error('Form id is not configured. Invoke setConfig() before using functions.');
//      } else if (!config.campaignId.match(REGEXP_FORM_ID)) {
//        console.warn('Form id has incorrect format.');
//      }

      return true;
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


extension CIImage {

    /// Combines the current image with the given image centered.
    func combined(with image: CIImage) -> CIImage? {
        let newSize = self.extent.height * 0.1
        let oldSize = image.extent.height
        let scale = newSize / oldSize
        let transform = CGAffineTransform(scaleX: scale, y: scale)
        let image = image.transformed(by: transform, highQualityDownsample: true)
        guard let combinedFilter = CIFilter(name: "CISourceOverCompositing") else { return nil }
        let centerTransform = CGAffineTransform(translationX: extent.midX - (image.extent.size.width / 2),
                                                y: extent.midY - (image.extent.size.height / 2))
        combinedFilter.setValue(image.transformed(by: centerTransform), forKey: "inputImage")
        combinedFilter.setValue(self, forKey: "inputBackgroundImage")
        return combinedFilter.outputImage
    }
}
