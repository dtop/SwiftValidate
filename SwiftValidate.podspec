Pod::Spec.new do |s|

  s.name         = "SwiftValidate"
  s.version      = "2.0.1"
  s.summary      = "A highly customizable validation library for swift"
  s.homepage     = "http://github.com/dtop/SwiftValidate"
  s.license      = "MIT"
  s.author       = { "Danilo Topalovic" => "danilo.topalovic@nerdsee.com" }
  s.ios.deployment_target = "8.0"
  s.ios.frameworks = 'UIKit', 'Foundation'
  s.source       = { :git => "https://github.com/dtop/SwiftValidate.git", :tag => s.version }
  s.source_files  = "validate/*.swift", "validate/**/*.swift"
end
