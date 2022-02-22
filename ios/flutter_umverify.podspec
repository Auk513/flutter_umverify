#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint flutter_umverify.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'flutter_umverify'
  s.version          = '0.0.1'
  s.summary          = '友盟一键登录'
  s.description      = <<-DESC
友盟一键登录
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'witchan028@126.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.platform = :ios, '9.0'
  s.dependency 'UMVerify'
  s.dependency 'UMCommon'
  s.dependency 'YYKit'
  s.static_framework = true
  s.resources = ['Assets/*']
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'VALID_ARCHS[sdk=iphonesimulator*]' => 'x86_64' }

end
