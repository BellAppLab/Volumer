Pod::Spec.new do |s|
  s.name             = "Volumer"
  s.version          = "0.1.1"
  s.summary          = "A Swifty way to take control over the volume buttons on iOS."

  s.description      = <<-DESC
A Swifty way to take control over the volume buttons on iOS. Inspired by: https://github.com/jpsim/JPSVolumeButtonHandler
                       DESC

  s.homepage         = "https://github.com/BellAppLab/Volumer"
  s.license          = 'MIT'
  s.author           = { "Bell App Lab" => "apps@bellapplab.com" }
  s.source           = { :git => "https://github.com/BellAppLab/Volumer.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/BellAppLab'

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'

  s.frameworks = 'UIKit', 'MediaPlayer'
end
