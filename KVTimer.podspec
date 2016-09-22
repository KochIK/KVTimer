
Pod::Spec.new do |spec|
spec.name         = 'KVTimer'
spec.version      = '0.6.0'
spec.license      = { :type => 'MIT', :file => 'LICENSE' }
spec.homepage     = 'https://github.com/KochIK/KVTimer'
spec.authors      = { 'Vlad Kochergin' => 'kargod@ya.ru' }
spec.summary      = 'The circular timer for iOS - KVTimer'
spec.source       = { :git => 'https://github.com/KochIK/KVTimer.git', :tag => '0.6.0' }
spec.platform = :ios
spec.ios.deployment_target  = '7.0'

spec.source_files       = 'Classes/*.{h,m}'
spec.ios.framework  = 'UIKit'
end

