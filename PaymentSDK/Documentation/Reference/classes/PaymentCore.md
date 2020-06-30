**CLASS**

# `PaymentCore`

```swift
public class PaymentCore
```

Main class of paymentSDK

## Methods
### `setSystemConfig(_:)`

```swift
public func setSystemConfig(_ config: XcooBeePayConfig)
```

### `clearSystemConfig()`

```swift
public func clearSystemConfig()
```

### `createPayUrl(input:)`

```swift
public func createPayUrl (input: XcooBeeInputModel) -> URL?
```

Returns URL that can activate a single total payment. Existing items will be deleted. Only this item can be
processed. If you use zero amount, the user can enter the amount for payment.

### `createPayQR(input:qrConfig:)`

```swift
public func createPayQR(input: XcooBeeInputModel, qrConfig: XcooBeeQRConfig?) -> UIImage?
```

Returns QR that can activate a single total payment. Existing items will be deleted. Only this item can be
processed. If you use zero amount, the user can enter the amount for payment.

### `createPayUrlwithTip(input:)`

```swift
public func createPayUrlwithTip(input: XcooBeeInputModel) -> URL?
```

Returns a URL that can activate a total payment and predefined Tip calculator. This allows an additional Tip to be
added to the total at checkout. Existing items in cart will be removed when this item is activated.

### `createPayQRwithTip(input:qrConfig:)`

```swift
public func createPayQRwithTip(input: XcooBeeInputModel, qrConfig: XcooBeeQRConfig?) -> UIImage?
```

Returns a QR that can activate a total payment and predefined Tip calculator. This allows an additional Tip to be
added to the total at checkout. Existing items in cart will be removed when this item is activated.

### `createSingleItemUrl(input:)`

```swift
public func createSingleItemUrl(input: XcooBeeInputModel) -> URL?
```

Return URL that adds new item to eCommerce basket.

### `createSingleItemQR(input:qrConfig:)`

```swift
public func createSingleItemQR(input: XcooBeeInputModel, qrConfig: XcooBeeQRConfig?) -> UIImage?
```

Return QR that adds new item to eCommerce basket

### `createSingleSelectUrl(input:items:)`

```swift
public func createSingleSelectUrl(input: XcooBeeInputModel, items: [SecurePaySubItem]) -> URL?
```

Return URL to add a single item to cart. The item has multiple options of which one can be selected

### `createSingleSelectQR(input:items:qrConfig:)`

```swift
public func createSingleSelectQR(input: XcooBeeInputModel,
                                 items: [SecurePaySubItem],
                                 qrConfig: XcooBeeQRConfig?) -> UIImage?
```

Return QR to add a single item to cart. The item has multiple options of which one can be selected

### `createSingleSelectWithCostUrl(input:items:)`

```swift
public func createSingleSelectWithCostUrl(input: XcooBeeInputModel, items: [SecurePaySubItemWithCost]) -> URL?
```

Return URL to add a single item to cart. The item has multiple options of which one can be selected. Each option can also add cost to item total

### `createSingleSelectWithCostQR(input:items:qrConfig:)`

```swift
public func createSingleSelectWithCostQR(input: XcooBeeInputModel,
                                         items: [SecurePaySubItemWithCost],
                                         qrConfig: XcooBeeQRConfig?) -> UIImage?
```

Return QR to add a single item to cart. The item has multiple options of which one can be selected. Each option can also add cost to item total

### `createMultiSelectUrl(input:items:)`

```swift
public func createMultiSelectUrl(input: XcooBeeInputModel, items: [SecurePaySubItem]) -> URL?
```

Return URL to add a single item to cart. The item has multiple options of which any can be selected

### `createMultiSelectQR(input:items:qrConfig:)`

```swift
public func createMultiSelectQR(input: XcooBeeInputModel,
                         items: [SecurePaySubItem],
                         qrConfig: XcooBeeQRConfig?) -> UIImage?
```

Return QR to add a single item to cart. The item has multiple options of which any can be selected

### `createMultiSelectUrlWithCost(input:items:)`

```swift
public func createMultiSelectUrlWithCost(input: XcooBeeInputModel, items: [SecurePaySubItemWithCost]) -> URL?
```

Return URL to add a single item to cart. The item has multiple options of which any can be selected. Each option  can also add cost to item total

### `createMultiSelectQRWithCost(input:items:qrConfig:)`

```swift
public func createMultiSelectQRWithCost(input: XcooBeeInputModel,
                                 items: [SecurePaySubItemWithCost],
                                 qrConfig: XcooBeeQRConfig?) -> UIImage?
```

Return QR to add a single item to cart. The item has multiple options of which any can be selected. Each option can also add cost to item total

### `createExternalReferenceURL(priceCode:config:)`

```swift
public func createExternalReferenceURL(priceCode: String, config: XcooBeePayConfig?) -> URL?
```

Create URL that uses external (XcooBee Hosted) definition for cost, image, and option logic. Obtain references from XcooBee

### `createExternalReferenceQR(priceCode:qrConfig:config:)`

```swift
public func createExternalReferenceQR(priceCode: String,
                                      qrConfig: XcooBeeQRConfig?,
                                      config: XcooBeePayConfig?) -> UIImage?
```

Create URL that uses external (XcooBee Hosted) definition for cost, image, and option logic. Obtain references from XcooBee

### `makePayUrl(securePay:forcedConfig:)`

```swift
public func  makePayUrl(securePay: [SecurePay], forcedConfig: XcooBeePayConfig?) -> String
```
