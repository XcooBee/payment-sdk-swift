//
//  UrlProvider.swift
//  PaymentSDK
//
//  Created by Maxym Krutykh on 29.06.2020.
//

import Foundation

class UrlProvider {
    
    private var errorHandler: ErrorHandler
    
    init(errorHandler: ErrorHandler) {
        self.errorHandler = errorHandler
    }
    
    func  makePayUrl(securePay: [SecurePay], config: XcooBeePayConfig) -> String {
        
        let  dataBase64 = convertToBase64(securePay: securePay)
        
        if ((dataBase64?.count ?? 0) > Constants.maxDataLength) {
            errorHandler.showError(message: "Data parameter encoded to Base64 is bigger than \(Constants.maxDataLength)")
            return ""
        }
        if ((config.xcoobeeDeviceId ?? "").count > Constants.maxDeviceIdLength) {
            errorHandler.showError(message: "XcooBeeDeviceId parameter is bigger than \(Constants.maxDeviceIdLength)")
            return ""
        }
        if ((config.deviceId ?? "").count > Constants.maxDeviceIdLength) {
            errorHandler.showError(message: "ExternalDeviceId parameter is bigger than \(Constants.maxDeviceIdLength)")
            return ""
        }
        if ((config.source ?? "").count > Constants.maxSourceLength) {
            errorHandler.showError(message: "Source parameter is bigger than \(Constants.maxSourceLength)")
            return ""
        }
        
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
        let url = "\(Constants.appUrl)/securePay/\(config.campaignId)\(config.formId.map { "/\($0)" } ?? "")/\(queryString)"
        return url
    }
    
    private func convertToBase64(securePay: [SecurePay]) -> String? {
        let json = securePay.map { $0.toJSON() }
        guard let data = try? JSONSerialization.data(withJSONObject: json, options: []) else {
            return nil
        }
        let base64Encoded = data.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0))
        
        return base64Encoded
        
    }
}
