platform :ios, '12.0'
inhibit_all_warnings!

target 'CashMore' do
  use_frameworks!
  pod 'PKHUD'
  pod 'Adjust'
  pod 'R.swift'
  pod 'SnapKit'
  pod 'Alamofire'
  pod 'HandyJSON'
  pod 'AliyunOSSiOS'
  pod 'DynamicColor'
  pod 'KingfisherWebP'
  pod 'PullToRefresher'
  pod 'EmptyDataSet-Swift'
  pod 'IQKeyboardManagerSwift'
end

post_install do |installer|
    installer.generated_projects.each do |project|
          project.targets.each do |target|
              target.build_configurations.each do |config|
                  config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
               end
          end
   end
end
