//
//  QRImageProvider.swift
//  PaymentSDK
//
//  Created by Maxym Krutykh on 29.06.2020.
//

import UIKit

class QRImageProvider {
    static func generateQRCode(from string: String, qrConfig: XcooBeeQRConfig?) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)
        
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let size = qrConfig?.size ?? 150
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
    
    static private func scaleSize(value: CGFloat?, size: Int) -> CGFloat {
        let imageSize = CGFloat(size)
        let scale = imageSize / (value ?? 0)
        return scale
    }
}
