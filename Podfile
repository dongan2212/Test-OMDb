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
  pod 'Kingfisher', '7.6.1'
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
  pods_project = installer.pods_project
  deployment_target_key = 'IPHONEOS_DEPLOYMENT_TARGET'
  deployment_targets = pods_project.build_configurations.map{ |config| config.build_settings[deployment_target_key] }
  minimal_deployment_target = deployment_targets.min_by{ |version| Gem::Version.new(version) }

  puts 'Minimal deployment target is ' + minimal_deployment_target
  puts 'Setting each pod deployment target to ' + minimal_deployment_target

  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings[deployment_target_key] = minimal_deployment_target
    end
  end
end

