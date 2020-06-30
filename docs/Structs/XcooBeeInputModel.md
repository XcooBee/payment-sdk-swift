**STRUCT**

# `XcooBeeInputModel`

```swift
public struct XcooBeeInputModel
```

Model for passing input parameters to XcooBeePaymentSDK

## Methods
### `init(amount:tax:reference:config:)`

```swift
public init(amount: Double, tax: Double? = nil, reference: String? = nil, config: XcooBeePayConfig? = nil)
```

- Parameters:
   - amount: amount
   - tax: tax the included tax of the item
   - reference: reference the item description or reference for payment
   - config: config the method specific configuration object override

#### Parameters

| Name | Description |
| ---- | ----------- |
| amount | amount |
| tax | tax the included tax of the item |
| reference | reference the item description or reference for payment |
| config | config the method specific configuration object override |