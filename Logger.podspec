#
# Be sure to run `pod lib lint Logger.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "Logger"
  s.version          = "0.2.6"
  s.summary          = "Multiple logger to console, flurry and alert (optional)"
  s.description      = <<-DESC
                        This library is created for simple unified logging successful and unsuccessful events.
                        Using any of these tools is optional, and can be adjusted
                        DESC
  s.homepage         = "https://github.com/vsdyachkov/Logger"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Victor" => "vsdyachkov@rambler.ru" }
  s.source           = { :git => "https://github.com/vsdyachkov/Logger.git", :commit => "9aa225a8859988fe2041ba35d1e7c2e97eeadc52", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform     = :ios, '6.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/*'
  # s.resources = 'Pod/Assets/*.png'

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
  s.dependency "FlurrySDK"
end
