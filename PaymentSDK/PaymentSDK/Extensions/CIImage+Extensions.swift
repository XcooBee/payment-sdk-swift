//
//  CIImage+Extensions.swift
//  PaymentSDK
//
//  Created by Maxym Krutykh on 29.06.2020.
//  Copyright © 2020 XcooBee. All rights reserved.
//

import UIKit

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
