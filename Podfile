# Uncomment the next line to define a global platform for your project
platform :ios, '12.0'
use_frameworks!

def reactiveModule
  pod 'RxSwift', '6.5.0'
  pod 'RxCocoa', '6.5.0'
  pod 'RxDataSources', '5.0.0'
end


def common
  pod 'Alamofire', '5.6.1'
  pod 'Kingfisher', '7.2.2'
  pod 'IQKeyboardManagerSwift', '6.5.10'
  pod 'SwiftLint', '0.47.1'
  pod 'SnapKit', '5.6.0'
  pod 'SVProgressHUD', '2.2.5'
  pod 'Swinject', '2.8.1'
  pod 'SwiftGen', '6.5.1'
end

target 'Test-SmartDev-ODMB' do
  reactiveModule
  common
end

post_install do |installer|
    installer.pods_project.build_configurations.each do |config|
        config.build_settings.delete('CODE_SIGNING_ALLOWED')
        config.build_settings.delete('CODE_SIGNING_REQUIRED')
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
    end
end

