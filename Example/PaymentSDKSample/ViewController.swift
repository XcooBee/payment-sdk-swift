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
        _ = getPaymentURL()
        _ = getPaymentQR()
    }
    
    func getPaymentURL() -> URL? {
        let input = XcooBeeInputModel(amount: 1)
        return PaymentCore.shared.createSingleItemUrl(input: input)
        
    }
    
    func getPaymentQR() -> UIImage? {
        let qrConfig = XcooBeeQRConfig(size: 750)
        let input = XcooBeeInputModel(amount: 10)
        return PaymentCore.shared.createSingleItemQR(input: input, qrConfig: qrConfig)
    }
}

