# Uncomment the next line to define a global platform for your project
platform :ios, '13.0'

target 'vini' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for vini

  pod 'SwiftLint' 
  pod 'Firebase/Auth'
  pod 'Firebase/Firestore'
  pod 'FirebaseFirestoreSwift'
  pod 'Firebase/Storage'
  pod 'Firebase/Crashlytics'
  pod 'Kingfisher'
  pod 'RSKPlaceholderTextView'
  pod 'IQKeyboardManagerSwift'
  pod "Haptica"
  pod 'JGProgressHUD'

  target 'ViniUnitTests' do
        inherit! :search_paths
        pod 'SwiftLint' 
        pod 'Firebase/Auth'
        pod 'Firebase/Firestore'
        pod 'FirebaseFirestoreSwift'
        pod 'Firebase/Storage'
        pod 'Firebase/Crashlytics'
        pod 'Kingfisher'
        pod 'RSKPlaceholderTextView'
        pod 'IQKeyboardManagerSwift'
        pod 'Haptica'
        pod 'JGProgressHUD'
    end


end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
    # some older pods don't support some architectures, anything over iOS 11 resolves that
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
      config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
    end
  end
end