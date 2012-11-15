Pod::Spec.new do |s|
  s.name         = "JWLayoutViews"
  s.version      = "0.0.1"
  s.summary      = "better(?) layout systems for iOS."
  s.description  = <<-DESC
                      'Real' layout controls for iOS

                      Currently have two layout systems, a wrapping layout view 
                      and a constraint based system.
                      DESC
  s.homepage     = "https://github.com/jweinberg/JWLayoutViews/"
  s.license      = 'BSD'
  s.author       = { "Joshua Weinberg" => "joshuacweinberg@gmail.com" }
  s.source       = { :git => "https://github.com/jweinberg/JWLayoutViews.git", :tag => '0.0.1' }
  s.platform     = :ios, '4.0'
  s.source_files = 'Classes', 'Classes/**/*.{h,m}'
  s.frameworks = 'Foundation', 'UIKit', 'CoreGraphics'
  s.requires_arc = false
end
