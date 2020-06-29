//
//  ViewController.swift
//  PaymentSDKSample
//
//  Created by Maxym Krutykh on 21.06.2020.
//  Copyright © 2020 XcooBee. All rights reserved.
//

import UIKit
import PaymentSDK

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let config = XcooBeePayConfig(campaignId: "t")
        PaymentCore.shared.setSystemConfig(config)
        let input = InputModel(amount: 1)
        let url = PaymentCore.shared.createPayUrlwithTip(input: input)
        let urlString = url?.absoluteString ?? ""
        let index = urlString.firstIndex(of: "d")
        let startIndex = index.map { urlString.index($0, offsetBy: 2) }
        let substring = String(startIndex.map { urlString[$0...] } ?? "")
        if let base64Decoded = Data(base64Encoded: substring, options: Data.Base64DecodingOptions(rawValue: 0))
            .map({ String(data: $0, encoding: .utf8) }) {
            // Convert back to a string
            print("Decoded: \(base64Decoded ?? "")")
        }
        
        let image = PaymentCore.shared.createPayQRwithTip(input: input, size: 750)
        if let image = image {
            print(image)
        }
    }
}

