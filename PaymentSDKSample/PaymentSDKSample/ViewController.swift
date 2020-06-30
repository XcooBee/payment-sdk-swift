//
//  ViewController.swift
//  PaymentSDKSample
//
//  Created by Maxym Krutykh on 21.06.2020.
//

import UIKit
import PaymentSDK

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let config = XcooBeePayConfig(campaignId: "t", formId: "t")
        PaymentCore.shared.setSystemConfig(config)
        let input = XcooBeeInputModel(amount: 1)
        let url = PaymentCore.shared.createSingleItemUrl(input: input)
        let urlString = url?.absoluteString ?? ""
        let index = urlString.firstIndex(of: "d")
        let startIndex = index.map { urlString.index($0, offsetBy: 2) }
        let substring = String(startIndex.map { urlString[$0...] } ?? "")
        if let base64Decoded = Data(base64Encoded: substring, options: Data.Base64DecodingOptions(rawValue: 0))
            .map({ String(data: $0, encoding: .utf8) }) {
            // Convert back to a string
            print("Decoded: \(base64Decoded ?? "")")
        }
        
        let image = PaymentCore.shared.createSingleItemQR(input: input, qrConfig: XcooBeeQRConfig(size: 750))
        if let image = image {
            print(image)
        }
    }
}

