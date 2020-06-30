//
//  PaymentSDKTests.swift
//  PaymentSDKTests
//
//  Created by Maxym Krutykh on 30.06.2020.
//

import XCTest
@testable import PaymentSDK

class PaymentSDKTests: XCTestCase {
    
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
}

class PaymentCorePublicMethodsTests: XCTestCase {
    let campaignId = "f98.eg6152508"
    let formId = "v025"
    
    override func setUp() {
        let config = XcooBeePayConfig(campaignId: campaignId)
        PaymentCore.shared.setSystemConfig(config)
    }
    
    override func tearDown() {
        PaymentCore.shared.clearSystemConfig()
    }

    func test_createPayUrl() throws {
        let input = XcooBeeInputModel(amount: 2)
        let url = PaymentCore.shared.createPayUrl(input: input)
        XCTAssert(url != nil)
    }
    
    func test_createPayQR() throws {
        let input = XcooBeeInputModel(amount: 2)
        let qrConfig = XcooBeeQRConfig(size: 750)
        let image = PaymentCore.shared.createPayQR(input: input, qrConfig: qrConfig)
        XCTAssert(image != nil)
    }
}
