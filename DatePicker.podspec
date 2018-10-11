#
# Be sure to run `pod lib lint DatePicker.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'DatePicker'
  s.version          = '1.0.0'
  s.summary          = 'Date Picker for iOS'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = 'A simple, elegant Date Picker library for iOS'

  s.homepage         = 'https://github.com/FreshworksStudio/DatePicker'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'amirshayegh' => 'shayegh@me.com' }
  s.source           = { :git => 'https://github.com/FreshworksStudio/DatePicker.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'

  s.source_files = 'DatePicker/Classes/**/*.{swift}'
  
  s.resource_bundles = {
  #   'DatePicker' => ['DatePicker/Assets/*.png']
      'DatePicker' => ['DatePicker/Classes/**/*.{storyboard,xib}']
   }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'Extended', '~> 1.0.4'
end
