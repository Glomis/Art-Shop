# Uncomment the next line to define a global platform for your project
platform :ios, '10.0'

def shared_pods
  pod 'Firebase/Core'
  pod 'Firebase/Auth'
  pod 'Firebase/Firestore'
  pod 'Firebase/Storage'
  pod 'IQKeyboardManagerSwift'
  pod 'Kingfisher'
  pod 'CodableFirebase'
end
  
target 'Art Shop' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Art Shop
  shared_pods
  pod 'Stripe'
  pod 'Alamofire'
  
end

target 'Art Shop Admin' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Art Shop Admin
  shared_pods
end
