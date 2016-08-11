#
# Be sure to run `pod lib lint CQPopupKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'CQPopupKit'
  s.version          = '1.0.7'
  s.summary          = 'A popup kit for creating highly customizable popup view, based on Swift 2.2'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
This library is a highly customizable popup kit, contains alert view, action sheet, and other iOS components (picker, tableView, etc),
all of them can popup over the existing view controller, this kit also provides a lot of configuration for you to customize your style.
Meanwhile, it is expandable, you can implement your own view, and put the view in the popup, that's it.
                       DESC

  s.homepage         = 'https://github.com/Cunqi/CQPopupKit'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'cunqi' => 'notice.xiao@gmail.com' }
  s.source           = { :git => 'https://github.com/Cunqi/CQPopupKit.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'CQPopupKit/**/*'

  # s.resource_bundles = {
  #   'CQPopupKit' => ['CQPopupKit/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
