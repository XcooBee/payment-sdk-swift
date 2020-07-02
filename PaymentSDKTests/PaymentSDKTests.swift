//
//  PaymentSDKTests.swift
//  PaymentSDKTests
//
//  Created by Maxym Krutykh on 30.06.2020.
//

import XCTest
@testable import PaymentSDK

class PaymentSDKTests: XCTestCase {
    
    let campaignId = "f98.eg6152508"
    let formId = "v025"
    
        let longText = """
    Sed ut perspiciatis, unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam eaque ipsa, quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt, explicabo. Nemo enim ipsam voluptatem, quia voluptas sit, aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos, qui ratione voluptatem sequi nesciunt, neque porro quisquam est, qui dolorem ipsum, quia dolor sit amet consectetur adipisci[ng]velit, sed quia non-numquam [do] eius modi tempora inci[di]dunt, ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum[d] exercitationem ullam corporis suscipitlaboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit, qui inea voluptate velit esse, quam nihil molestiae consequatur, vel illum, qui dolorem eum fugiat, quo voluptas nulla pariatur? [33] At vero eos et accusamus et iusto odio dignissimos ducimus, qui blanditiis praesentium voluptatum deleniti atque corrupti, quos dolores et quas molestias excepturi sint, obcaecati cupiditate non-provident, similique sunt in culpa, qui officia deserunt mollitia animi, id est laborum et dolorum fuga. Et harum quidem rerum facilis est et expedita distinctio. Nam libero tempore, cum soluta nobis est eligendi optio, cumque nihil impedit, quo minus id, quod maxime placeat, facere possimus, omnis voluptas assumenda est, omnis dolor repellendus. Temporibus autem quibusdam et aut officiis debitis aut rerum necessitatibus saepe eveniet, ut et voluptates repudiandae sint et molestiae non-recusandae. Itaque earum rerum hic tenetur a sapiente delectus, ut aut reiciendis voluptatibus maiores alias consequatur aut perferendis doloribus asperiores repellat
    """
    
    override func setUp() {
        PaymentCore.shared.clearSystemConfig()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_ShouldHaveEmptyConfig() throws {
        XCTAssert(!PaymentCore.shared.isConfigAvailable)
        XCTAssertEqual(PaymentCore.shared.lastErrorMessage, "config is required")
    }
    
    func test_ShouldHaveConfigAfterSetup() throws {
        let config = XcooBeePayConfig(campaignId: "t")
        PaymentCore.shared.setSystemConfig(config)
        XCTAssert(PaymentCore.shared.isConfigAvailable)
    }
    
    func test_ShouldShowErrorWhenConfigIsEmpty() throws {
        let input = XcooBeeInputModel(amount: 2)
        let url = PaymentCore.shared.createPayUrl(input: input)
        XCTAssert(url == nil)
        XCTAssertEqual(PaymentCore.shared.lastErrorMessage, "Instance is not configured, invoke setConfig() before using functions.")
    }
    
    func test_ShouldValidateCapmpaingId() throws {
        let config = XcooBeePayConfig(campaignId: "t")
        let input = XcooBeeInputModel(amount: 2, config: config)
        let url = PaymentCore.shared.createPayUrl(input: input)
        XCTAssert(url == nil)
        XCTAssertEqual(PaymentCore.shared.lastErrorMessage, "Campaign id has incorrect format")
    }
    
    func test_ShouldValidateFormIdIfAvalable() throws {
        let config = XcooBeePayConfig(campaignId: campaignId, formId: "t")
        let input = XcooBeeInputModel(amount: 2, config: config)
        let url = PaymentCore.shared.createPayUrl(input: input)
        XCTAssert(url == nil)
        XCTAssertEqual(PaymentCore.shared.lastErrorMessage, "Form id has incorrect format")
    }
    
    func test_ShouldValidateAmount() throws {
        let config = XcooBeePayConfig(campaignId: campaignId, formId: formId)
        let input = XcooBeeInputModel(amount: 100000000, config: config)
        let url = PaymentCore.shared.createPayUrl(input: input)
        XCTAssert(url == nil)
        XCTAssertEqual(PaymentCore.shared.lastErrorMessage, "Amount parameter should be less than \(Constants.maxAmount)")
    }
    
    func test_ShouldValidateReferenceSize() throws {
        let config = XcooBeePayConfig(campaignId: campaignId, formId: formId)
        let input = XcooBeeInputModel(amount: 2, reference: longText, config: config)
        let url = PaymentCore.shared.createPayUrl(input: input)
        XCTAssert(url == nil)
        XCTAssertEqual(PaymentCore.shared.lastErrorMessage, "Reference parameter should be less than \(Constants.maxReferenceLength)")
    }
    
    func test_ShouldValidateSubItem() throws {
        let config = XcooBeePayConfig(campaignId: campaignId, formId: formId)
        let input = XcooBeeInputModel(amount: 2, config: config)
        let items = [SecurePaySubItem(reference: longText)]
        let url = PaymentCore.shared.createSingleSelectUrl(input: input, items: items)
        XCTAssert(url == nil)
        XCTAssertEqual(PaymentCore.shared.lastErrorMessage, "Sub Item Reference parameter should be less than \(Constants.maxSubItemsRefLength)")
    }
    
    func test_ShouldValidateSubItemWithCosts() throws {
        let config = XcooBeePayConfig(campaignId: campaignId, formId: formId)
        let input = XcooBeeInputModel(amount: 2, config: config)
        let items = [SecurePaySubItemWithCost(reference: "test", amount: 9999)]
        let url = PaymentCore.shared.createSingleSelectWithCostUrl(input: input, items: items)
        let message = """
        Sub Item Reference parameter should be less than \(Constants.maxSubItemsRefLength)
        Sub Item Amount parameter should be less than \(Constants.maxSubItemAmount)
        """
        XCTAssert(url == nil)
        XCTAssertEqual(PaymentCore.shared.lastErrorMessage, message)
    }
    
    func test_ShouldValidateDeviceId() throws {
        let config = XcooBeePayConfig(campaignId: campaignId, formId: formId, xcoobeeDeviceId: longText)
        let input = XcooBeeInputModel(amount: 2, config: config)
        let url = PaymentCore.shared.createPayUrl(input: input)
        XCTAssert(url == nil)
        XCTAssertEqual(PaymentCore.shared.lastErrorMessage, "XcooBeeDeviceId parameter is bigger than \(Constants.maxDeviceIdLength)")
    }
    
    func test_ShouldValidateExternalDeviceId() throws {
        let config = XcooBeePayConfig(campaignId: campaignId, formId: formId, deviceId: longText)
        let input = XcooBeeInputModel(amount: 2, config: config)
        let url = PaymentCore.shared.createPayUrl(input: input)
        XCTAssert(url == nil)
        XCTAssertEqual(PaymentCore.shared.lastErrorMessage, "ExternalDeviceId parameter is bigger than \(Constants.maxDeviceIdLength)")
    }
    
    func test_ShouldValidateSource() throws {
        let config = XcooBeePayConfig(campaignId: campaignId, formId: formId, source: longText)
        let input = XcooBeeInputModel(amount: 2, config: config)
        let url = PaymentCore.shared.createPayUrl(input: input)
        XCTAssert(url == nil)
        XCTAssertEqual(PaymentCore.shared.lastErrorMessage, "Source parameter is bigger than \(Constants.maxSourceLength)")
    }
}

class PaymentCorePublicMethodsTests: XCTestCase {
    let campaignId = "f98.eg6152508"
    let imageSize = 750
    let input = XcooBeeInputModel(amount: 2)
    let items = [SecurePaySubItem(reference: "Test")]
    let itemsWithCost = [SecurePaySubItemWithCost(reference: "Test", amount: 1)]
    var qrConfig: XcooBeeQRConfig?
    
    override func setUp() {
        qrConfig = XcooBeeQRConfig(size: imageSize)
        let config = XcooBeePayConfig(campaignId: campaignId)
        PaymentCore.shared.setSystemConfig(config)
    }
    
    override func tearDown() {
        PaymentCore.shared.clearSystemConfig()
    }

    func test_createPayUrl() throws {
        let url = PaymentCore.shared.createPayUrl(input: input)
        let resultString = reverseURL(url)
        XCTAssert(resultString != nil)
    }
    
    func test_createPayQR() throws {
        let image = PaymentCore.shared.createPayQR(input: input, qrConfig: qrConfig)
        XCTAssert(image != nil)
        XCTAssert(image?.size.height == CGFloat(imageSize))
    }
    
    func test_createPayUrlWithTip() throws {
        let url = PaymentCore.shared.createPayUrlWithTip(input: input)
        let resultString = reverseURL(url)
        XCTAssert(resultString != nil)
    }
    
    func test_createPayQRWithTip() throws {
        let image = PaymentCore.shared.createPayQRWithTip(input: input, qrConfig: qrConfig)
        XCTAssert(image != nil)
        XCTAssert(image?.size.height == CGFloat(imageSize))
    }
    
    func test_createSingleItemUrl() throws {
        let url = PaymentCore.shared.createSingleItemUrl(input: input)
        let resultString = reverseURL(url)
        XCTAssert(resultString != nil)
    }
    
    func test_createSingleItemQR() throws {
        let image = PaymentCore.shared.createSingleItemQR(input: input, qrConfig: qrConfig)
        XCTAssert(image != nil)
        XCTAssert(image?.size.height == CGFloat(imageSize))
    }
    
    func test_createSingleSelectUrl() throws {
        let url = PaymentCore.shared.createSingleSelectUrl(input: input, items: items)
        let resultString = reverseURL(url)
        XCTAssert(resultString != nil)
    }
    
    func test_createSingleSelectQR() throws {
        let image = PaymentCore.shared.createSingleSelectQR(input: input, items: items, qrConfig: qrConfig)
        XCTAssert(image != nil)
        XCTAssert(image?.size.height == CGFloat(imageSize))
    }
    
    func test_createSingleSelectWithCostUrl() throws {
        let url = PaymentCore.shared.createSingleSelectWithCostUrl(input: input, items: itemsWithCost)
        let resultString = reverseURL(url)
        XCTAssert(resultString != nil)
    }
    
    func test_createSingleSelectWithCostQR() throws {
        let image = PaymentCore.shared.createSingleSelectWithCostQR(input: input, items: itemsWithCost, qrConfig: qrConfig)
        XCTAssert(image != nil)
        XCTAssert(image?.size.height == CGFloat(imageSize))
    }
    
    func test_createMultiSelectUrl() throws {
        let url = PaymentCore.shared.createMultiSelectUrl(input: input, items: items)
        let resultString = reverseURL(url)
        XCTAssert(resultString != nil)
    }
    
    func test_createMultiSelectQR() throws {
        let image = PaymentCore.shared.createMultiSelectQR(input: input, items: items, qrConfig: qrConfig)
        XCTAssert(image != nil)
        XCTAssert(image?.size.height == CGFloat(imageSize))
    }
    
    func test_createMultiSelectUrlWithCost() throws {
        let url = PaymentCore.shared.createMultiSelectUrlWithCost(input: input, items: itemsWithCost)
        let resultString = reverseURL(url)
        XCTAssert(resultString != nil)
    }
    
    func test_createMultiSelectQRWithCost() throws {
        let image = PaymentCore.shared.createMultiSelectQRWithCost(input: input, items: itemsWithCost, qrConfig: qrConfig)
        XCTAssert(image != nil)
        XCTAssert(image?.size.height == CGFloat(imageSize))
    }
    
    func test_createExternalReferenceURL() throws {
        let url = PaymentCore.shared.createExternalReferenceURL(priceCode: "Test", config: nil)
        let resultString = reverseURL(url)
        XCTAssert(resultString != nil)
    }
    
    func test_createExternalReferenceQR() throws {
        let image = PaymentCore.shared.createExternalReferenceQR(priceCode: "Test", qrConfig: qrConfig, config: nil)
        XCTAssert(image != nil)
        XCTAssert(image?.size.height == CGFloat(imageSize))
    }
    
    func reverseURL(_ url: URL?) -> String? {
        let urlString = url?.absoluteString ?? ""
        let index = urlString.firstIndex(of: "d")
        let startIndex = index.map { urlString.index($0, offsetBy: 2) }
        let substring = String(startIndex.map { urlString[$0...] } ?? "")
        if let base64Decoded = Data(base64Encoded: substring, options: Data.Base64DecodingOptions(rawValue: 0))
            .map({ String(data: $0, encoding: .utf8) }) {
            // Convert back to a string
            print("Decoded: \(base64Decoded ?? "")")
            return base64Decoded
        }
        return nil
    }
}
