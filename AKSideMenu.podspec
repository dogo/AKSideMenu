Pod::Spec.new do |spec|
  spec.name         = "AKSideMenu"
  spec.version      = "1.4.3"
  spec.summary      = "Beautiful iOS side menu library with parallax effect. Written in Swift"
  spec.homepage     = "https://github.com/dogo/AKSideMenu"

  spec.license            		= { :type => "MIT", :file => "LICENSE" }
  spec.author             		= { "Diogo Autilio" => "diautilio@gmail.com" }
  spec.social_media_url   		= "http://twitter.com/di_autilio"
  spec.platform           		= :ios
  spec.frameworks             = "UIKit", "Foundation", "CoreGraphics", "QuartzCore"
  spec.ios.deployment_target	= "8.0"
  spec.swift_version 			    = '4.2'
  spec.swift_versions         = ['4.2', '5.0']
  spec.source             		= { :git => "https://github.com/dogo/AKSideMenu.git", :tag => spec.version.to_s }
  spec.source_files       		= "AKSideMenu/*.{swift}"
  spec.requires_arc       		= true
end
