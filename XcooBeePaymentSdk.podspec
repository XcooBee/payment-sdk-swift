Pod::Spec.new do |spec|

  spec.name         = "XcooBeePaymentSdk"
  spec.version      = "1.0.1"
  spec.summary      = "XcooBee Payment SDK for Swift and iOS"

  spec.description  = <<-DESC
The XcooBee payment SDK allows you to quickly create contactless payments QR and URL that can be processed in your app. You can use XcooBee to configure accepted payment processors and methods. This simplifies the implementation of payments in apps and makes it safer for your users.
                   DESC

  spec.homepage     = "https://github.com/XcooBee/payment-sdk-swift"
  spec.license = 'Apache License, Version 2.0'
  spec.author             = { "XcooBee" => "support@xcoobee.com" }
  spec.ios.deployment_target = "10.0"

  spec.source       = { :git => "https://github.com/XcooBee/payment-sdk-swift.git", :tag => "#{spec.version}" }

  spec.source_files  = "PaymentSDK/*.swift"

end
