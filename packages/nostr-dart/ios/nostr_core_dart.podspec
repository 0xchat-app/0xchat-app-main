#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint nostr_core_dart.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'nostr_core_dart'
  s.version          = '0.0.1'
  s.summary          = 'A library for nostr protocol implemented in dart for flutter.'
  s.description      = <<-DESC
  A library for nostr protocol implemented in dart for flutter.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.platform = :ios, '11.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'

  s.dependency 'Flutter'
  s.dependency 'secp256k1Swift', '~> 0.7.4'

end
