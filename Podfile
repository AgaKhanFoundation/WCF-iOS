platform :ios, '11.0'
use_frameworks!
inhibit_all_warnings!

target 'Steps4Impact' do
  # Services
  pod 'AppCenter', '~> 2.3.0'
  pod 'AZSClient', '~> 0.2.6'
  pod 'FBSDKCoreKit', '~> 7.0.0'
  pod 'FBSDKLoginKit', '~> 7.0.0'
  pod 'FBSDKShareKit', '~> 7.0.0'
  pod 'Firebase/Auth', "~> 6.26.0"
  pod 'Firebase/Messaging', '~> 6.26.0'
  pod 'OAuthSwift', '~> 2.0.0'

  # App
  pod 'SDWebImage', '~> 5.1.1'
  pod 'SnapKit', '~> 5.0.1' 
  pod 'RxCocoa', '~> 5.0.0'
  pod 'RxSwift', '~> 5.0.0'
  
  # Dev
  pod 'Sourcery', '~> 0.17.0'
  pod 'SwiftLint', '~> 0.35.0'

  target 'Steps4ImpactTests' do
    inherit! :search_paths
    pod 'Quick', '~> 2.2.0'
    pod 'Nimble', '~> 8.0.4'
    pod 'RxTest', '~> 5.0.0'
    pod 'RxBlocking', '~> 5.0.0'
  end
end
