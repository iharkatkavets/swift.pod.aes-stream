#
# Be sure to run `pod lib lint AESStream.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'AESStream'
  s.version          = '0.1.0'
  s.summary          = 'A short description of AESStream.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/Igor Kotkovets/AESStream'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Igor Kotkovets' => 'igorkotkovets@users.noreply.github.com' }
  s.source           = { :git => 'https://github.com/Igor Kotkovets/AESStream.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'
  
  s.source_files = 'AESStream/Classes/**/*.swift'
  s.preserve_paths = 'AESStream/Classes/CommonCryptoSwift/*.modulemap'
  s.pod_target_xcconfig = {
    'SWIFT_VERSION' => '3.2',
    'SWIFT_INCLUDE_PATHS[sdk=macosx*]'           => '$(PODS_TARGET_SRCROOT)/AESStream/Classes/CommonCryptoSwift/macosx.modulemap',
    'SWIFT_INCLUDE_PATHS[sdk=iphoneos*]'         => '$(PODS_TARGET_SRCROOT)/AESStream/Classes/CommonCryptoSwift/iphoneos.modulemap',
    'SWIFT_INCLUDE_PATHS[sdk=iphonesimulator*]'  => '$(PODS_TARGET_SRCROOT)/AESStream/Classes/CommonCryptoSwift/iphonesimulator.modulemap',
    'SWIFT_INCLUDE_PATHS[sdk=appletvos*]'        => '$(PODS_TARGET_SRCROOT)/AESStream/Classes/CommonCryptoSwift/appletvos.modulemap',
    'SWIFT_INCLUDE_PATHS[sdk=appletvsimulator*]' => '$(PODS_TARGET_SRCROOT)/AESStream/Classes/CommonCryptoSwift/appletvsimulator.modulemap',
    'SWIFT_INCLUDE_PATHS[sdk=watchos*]'          => '$(PODS_TARGET_SRCROOT)/AESStream/Classes/CommonCryptoSwift/watchos.modulemap',
    'SWIFT_INCLUDE_PATHS[sdk=watchsimulator*]'   => '$(PODS_TARGET_SRCROOT)/AESStream/Classes/CommonCryptoSwift/watchsimulator.modulemap'
  }
#  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '3.2' }
#  s.xcconfig = { 'SWIFT_INCLUDE_PATHS' => '$(PODS_TARGET_SRCROOT)/AESStream/Classes/CommonCryptoSwift' }

end
