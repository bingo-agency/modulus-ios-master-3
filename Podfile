# Uncomment the next line to define a global platform for your project
platform :ios, '11.0'

source 'https://cdn.cocoapods.org/'
source 'https://github.com/SumSubstance/Specs.git'

target 'Modulus' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

# Pods for Modulus

#pod 'SwiftWebSocket'
pod 'SnapKit', '~> 4.0.0'
pod 'SwiftyJSON'
pod 'SwiftChart', '~> 0.6'
pod 'Alamofire','~> 4.7'
pod 'MaterialComponents/Tabs'
pod 'MaterialComponents/Snackbar'
pod 'MaterialComponents/BottomSheet'
pod 'DropDown', '~> 2.3.3'
pod 'NVActivityIndicatorView'
pod 'IQKeyboardManagerSwift','~>6.0.4'
pod 'SkyFloatingLabelTextField', '~> 3.0'
#pod 'JVFloatLabeledTextField'#1.2.1
pod 'TSMessages'
pod 'SwiftR'
pod 'libPhoneNumber-iOS', '~> 0.8'
pod 'Socket.IO-Client-Swift', '~> 15.2.0'
pod 'SwiftyRSA'
#pod 'Charts'
pod 'IdensicMobileSDK'
# pod 'SweetHMAC'
# pod 'MaterialComponents/TextFields'
# pod 'SDWebImage'
 
# pod 'HockeySDK', '~> 5.1.4'
# pod 'Fabric'
# pod 'Crashlytics'
end

post_install do |installer|
    installer.generated_projects.each do |project|
        project.targets.each do |target|
            target.build_configurations.each do |config|
                config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '11.0'
            end
        end
    end
end