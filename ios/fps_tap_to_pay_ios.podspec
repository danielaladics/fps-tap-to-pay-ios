Pod::Spec.new do |s|
  s.name             = 'fps_tap_to_pay_ios'
  s.version          = '1.0.0'
  s.summary          = "Apple's Tap to Pay on iPhone merchant education for Flutter."
  s.description      = <<-DESC
Presents the ProximityReaderDiscovery "How to Tap" sheet (iOS 18+) from Flutter.
                       DESC
  s.homepage         = 'https://github.com/danielaladics/fps-tap-to-pay-ios'
  s.license          = { :type => 'MIT', :file => '../LICENSE' }
  s.author           = { 'FPS APP' => 'danielaladics@gmail.com' }
  s.source           = { :path => '.' }
  s.source_files     = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform         = :ios, '13.0'
  s.weak_frameworks  = 'ProximityReader'
  s.swift_version    = '5.0'
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
end
