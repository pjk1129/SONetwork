Pod::Spec.new do |s|

s.name         = "SONetwork"
s.version      = "0.1.0"
s.summary      = "SONetwork is an HTTP networking library based URLSession written in Swift."
s.description  = <<-DESC
                    SONetwork is an HTTP networking library based URLSession written in Swift..
                    DESC

s.homepage     = "https://github.com/pjk1129/SONetwork.git"
s.license          = { :type => 'MIT', :file => 'LICENSE' }

s.platform     = :ios, "9.0"
s.author       = { 'pjk1129' => 'pjk1129@qq.com' }

s.source       = { :git => "https://github.com/pjk1129/SONetwork.git", :tag => "0.1.0"}
s.source_files  = "SONetwork/**/*.{.swift}"

s.requires_arc = true

s.frameworks = 'Foundation', 'CoreGraphics', 'UIKit'

end
