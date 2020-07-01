# XcooBee Payment SDK for Swift and iOS

## Description

The XcooBee contactless payment system is a complete shopping cart and checkout system that can be included in your projects (mobile or web) quickly.
In order to fully use this you will need a XcooBee account ( Professional, Business, or  Enterprise) and an active “Payment Project” created.

The SDK simplifies the generation of URLs and QRs. 
Smart QRs and URLs can cover many different use cases.

The URLs can be send to remote user or embedded in a website to quickly add a shopping cart system with a few lines. 
Examples of this could be "Pay" button or links "add to cart" links for merchandise that is sold on the site. 

The URLs can help you build a very simply shopping system that is focused on cart and checkout. Nothing else is needed. 

Touchless smart QRs can be used with users that are directly in vicinity of your app or to start a shopping/payment process from physical media like signs and printed materials. Examples of this would include restaurant menus, flyers, catalogs, books, invoices, statements, etc..

## Installation

### Cocoapods
[CocoaPods](.https://cocoapods.org/) is a dependency manager for Cocoa projects. For usage and installation instructions, visit their website. To integrate Alamofire into your Xcode project using CocoaPods, specify it in your Podfile:

`pod install XcooBeePaymentSDK`

## Using

### Setup
in `AppDelegate`
```
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    let config = XcooBeePayConfig(campaignId: "a00.aa0000000", formId: "a000")
    PaymentCore.shared.setSystemConfig(config)
    return true
}
```
You can put code above in any place but before you start using SDK.

### Usage example 
```
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
```

## Documentation

To overview documentation please follow [documentation link](./Documentation/Reference/README.md).
