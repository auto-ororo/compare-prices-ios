# Uncomment the next line to define a global platform for your project
platform :ios, '14.5'
#

target 'ComparePrices' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  
  pod 'SwiftFormat/CLI'
  pod 'SwiftLint'
  pod 'Firebase/Core'
  pod 'Firebase/Auth'
  pod 'Firebase/Firestore'
  pod 'FirebaseFirestoreSwift'
  pod 'Firebase/Analytics'
  pod 'Firebase/Crashlytics'

  # Pods for ComparePrices

  target 'ComparePricesTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'ComparePricesUITests' do
    # Pods for testing
  end

end

# post_install do |installer|
#   installer.pods_project.build_configurations.each do |config|
#     config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
#   end
# end
