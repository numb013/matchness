# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'matchness' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for matchness

#表示関係
pod "PagingMenuController"
pod "XLPagerTabStrip"
pod 'ImageViewer'

#歩数関係
pod "MBCircularProgressBar"
pod 'Charts'

#チュートリアル
pod 'EAIntroView'

#メッセージ
#pod 'JSQMessagesViewController'
#pod 'JSQMessagesViewController', :git => 'https://github.com/Tulleb/JSQMessagesViewController.git', :branch => 'develop', :inhibit_warnings => true
pod 'JSQMessagesViewController', :git => 'https://github.com/Ariandr/JSQMessagesViewController.git', :branch => 'master', :inhibit_warnings => true
pod 'Firebase/Core'
pod 'FacebookCore'
pod 'FirebaseDatabase'
pod 'FirebaseStorage'
pod 'SDWebImage'
pod 'FirebaseUI/Storage'
pod 'Firebase/Messaging'
pod 'GoogleSignIn'
pod 'GoogleAPIClientForREST/Drive', '~> 1.2.1'
pod 'GTMAppAuth'

# add the Firebase pod for Google Analytics
pod 'Firebase/Analytics'
# add pods for any other desired Firebase products
# https://firebase.google.com/docs/ios/setup#available-pods

pod 'FBSDKLoginKit'
pod 'HydraAsync'
pod 'Firebase/Functions'
pod 'Stripe'

#API通信
pod 'Alamofire', '4.4'
pod 'SwiftyJSON', '4.0'

pod 'OneSignal', '>= 2.11.2', '< 3.0'

target 'OneSignalNotificationServiceExtension' do
  pod 'OneSignal', '>= 2.11.2', '< 3.0'
end

  target 'matchnessTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'matchnessUITests' do
    inherit! :search_paths
    # Pods for testing
  end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['APPLICATION_EXTENSION_API_ONLY'] = 'NO'
    end
  end
end

end
