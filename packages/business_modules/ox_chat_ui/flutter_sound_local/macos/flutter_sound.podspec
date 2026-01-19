#
# Stub podspec for flutter_sound on macOS
# This provides empty implementation to allow compilation
#
Pod::Spec.new do |s|
  s.name             = 'flutter_sound'
  s.version          = '9.23.1'
  s.summary          = 'Stub implementation for flutter_sound on macOS'
  s.description      = <<-DESC
  Stub package for flutter_sound on unsupported platforms (macOS).
  Provides empty implementations to allow compilation.
                       DESC
  s.homepage         = 'https://github.com/dooboolab/flutter_sound'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }

  s.source           = { :path => '.' }
  s.source_files     = 'Classes/**/*'
  s.dependency 'FlutterMacOS'

  s.platform = :osx, '10.11'
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }
  s.swift_version = '5.0'
end
