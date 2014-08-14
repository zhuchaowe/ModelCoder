Pod::Spec.new do |s|
  s.name                  = "ModelCoder"
  s.version               = "1.0"
  s.summary               = "ModelCoder can Automatic generate Objective-C code by JSON string"
  s.homepage              = "https://github.com/zhuchaowe/ModelCoder"
  s.social_media_url      = "https://swift.08dream.com"
  s.platform     = :osx,'10.7'
  s.license               = { :type => "MIT", :file => "LICENSE" }
  s.author                = { "zhuchao" => "zhuchaowe@163.com" }
  s.source                = { :git => "https://github.com/zhuchaowe/ModelCoder.git",:tag=>"1.0"}
  s.requires_arc          = true
  s.source_files = 'Base/MakeFile/*.{h,m}'
  s.subspec 'JSONKit' do |sp|
    sp.source_files = 'Base/JSONKit/*.{h,m}'
    sp.requires_arc = false
    sp.prefix_header_contents = '#import "JSONKit.h"'
  end
    
end
