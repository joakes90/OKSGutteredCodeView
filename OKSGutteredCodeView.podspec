Pod::Spec.new do |s|
 
  # 1
  s.platform = :ios
  s.ios.deployment_target = '9.3'
  s.name = "OKSGutteredCodeView"
  s.summary = "A UIView subclass that contains a textview and a gutter for line numbers"
  s.requires_arc = true
 
  # 2
  s.version = "0.1.13"
 
  # 3
  s.license = { :type => "MIT", :file => "LICENSE" }
 
  # 4 - Replace with your name and e-mail address
  s.author = { "Oklasoft LLC" => "admin@oklasoftware.com" }
 
  # For example,
  # s.author = { "Joshua Greene" => "jrg.developer@gmail.com" }
 
 
  # 5 - Replace this URL with your own Github page's URL (from the address bar)
  s.homepage = "https://github.com/oklasoftLLC/OKSGutteredCodeView"
 
  # For example,
  # s.homepage = "https://github.com/JRG-Developer/RWPickFlavor"
 
 
  # 6 - Replace this URL with your own Git URL from "Quick Setup"
  s.source = { :git => "https://github.com/oklasoftLLC/OKSGutteredCodeView.git", :tag => "#{s.version}"}
 
  # For example,
  # s.source = { :git => "https://github.com/JRG-Developer/RWPickFlavor.git", :tag => "#{s.version}"}
 
 
  # 7
  s.framework = "UIKit"
 
  # 8
  s.source_files = "OKSGutteredCodeView/**/*.{swift}"
 
  # 9
  s.resources = "OKSGutteredCodeView/**/*.{png,jpeg,jpg,storyboard,xib}"
end
