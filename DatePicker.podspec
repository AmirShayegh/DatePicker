Pod::Spec.new do |s|
  s.name             = 'DatePicker'
  s.version          = '1.4'
  s.summary          = 'Date Picker for iOS'

  s.description      = 'A simple, elegant Date Picker library for iOS'

  s.homepage         = 'https://github.com/rursache/DatePicker'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'amirshayegh' => 'shayegh@me.com' , 'rursache' => 'radu [at] ursache dot ro' }
  s.source           = { :git => 'https://github.com/rursache/DatePicker.git', :tag => s.version.to_s }

  s.ios.deployment_target = '10.0'

  s.source_files = 'DatePicker/Classes/**/*.{swift}'
  
  s.resource_bundles = {
      'DatePicker' => ['DatePicker/Classes/**/*.{storyboard,xib}']
   }
end
