**STRUCT**

# `XcooBeePayConfig`

```swift
public struct XcooBeePayConfig
```

Model for sdk configs

## Methods
### `init(campaignId:formId:source:deviceId:xcoobeeDeviceId:)`

```swift
public init(campaignId: String,
            formId: String,
            source: String? = nil,
            deviceId: String? = nil,
            xcoobeeDeviceId: String? = nil)
```

- Parameters:
   - campaignId: XcooBee campaign id.
   - formId: Form id for the campaign.
   - deviceId: External device id.
   - source: Source tracking reference for order.
   - xcoobeeDeviceId: XcooBee device id. (Only available if your device is connected to XcooBee network).
 If this is provided the “DeviceId” should not be provided. They are mutually exclusive and only XcooBeeDeviceId will be used.

#### Parameters

| Name | Description |
| ---- | ----------- |
| campaignId | XcooBee campaign id. |
| formId | Form id for the campaign. |
| deviceId | External device id. |
| source | Source tracking reference for order. |
| xcoobeeDeviceId | XcooBee device id. (Only available if your device is connected to XcooBee network). If this is provided the “DeviceId” should not be provided. They are mutually exclusive and only XcooBeeDeviceId will be used. |