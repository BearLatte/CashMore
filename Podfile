platform :ios, '12.0'
inhibit_all_warnings!

target 'CashMore' do
  use_frameworks!
  pod 'R.swift'
  pod 'SnapKit'
  pod 'DynamicColor'
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
