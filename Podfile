# Uncomment the next line to define a global platform for your project
platform :ios, '16.0'

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
    if target.name == 'BoringSSL-GRPC'
      target.source_build_phase.files.each do |file|
        if file.settings && file.settings['COMPILER_FLAGS']
          flags = file.settings['COMPILER_FLAGS'].split
          flags.reject! { |flag| flag == '-GCC_WARN_INHIBIT_ALL_WARNINGS' }
          file.settings['COMPILER_FLAGS'] = flags.join(' ')
        end
      end
    end

    target.build_configurations.each do |config|
    # some older pods don't support some architectures, anything over iOS 11 resolves that
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '16.0'
      config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
    end
  end
end
