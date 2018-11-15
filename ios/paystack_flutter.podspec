#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'paystack_flutter'
  s.version          = '0.0.1'
  s.summary          = 'Paystack Flutter Plugin'
  s.description      = <<-DESC
Flutter plugin for Paystack. Accept payments on Android and iOS apps built with Flutter
                       DESC
  s.homepage         = 'https://github.com/itswisdomagain/paystack_flutter'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'itswisdomagain' => 'wisdom.arerosuoghene@gmail.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Paystack'
  s.dependency 'Flutter'

  s.ios.deployment_target = '8.0'
end

