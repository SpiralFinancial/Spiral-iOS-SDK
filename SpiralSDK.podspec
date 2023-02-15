Pod::Spec.new do |s|
  s.name             = 'SpiralSDK'
  s.version          = '0.1.0'
  s.summary          = 'Spiral iOS SDK'
  s.swift_version    = '5.0'

  s.description      = <<-DESC
The Spiral SDK is used to open up as a modal in your application. Through the modal, end-users can select a non-profit, select a donation amount / frequency, and submit their donation.
                       DESC

  s.homepage         = 'https://github.com/SpiralFinancial/Spiral-iOS-SDK'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Spiral Financial' => 'ron.soffer@spiral.us' }
  s.source           = { :git => 'https://github.com/spiralfinancial/spiral-ios-sdk.git', :tag => s.version.to_s }

  s.ios.deployment_target = '12.0'

  s.source_files = 'Sources/**/*.swift'

  s.resource_bundles = {
    'Resources' => ['Resources/*/*.*']
  }
end
