Pod::Spec.new do |s|
  s.name         = "HNetworkManager"
  s.version      = "0.0.8"
  s.summary      = "A network manager framework"
  s.homepage     = "https://github.com/KerwinLan/HNetworkManager"
  s.license      = "MIT"
  s.author             = { "KerwinLAN" => "kerwinlan56@gmail.com" }
  s.social_media_url   = "https://github.com/KerwinLan/HNetworkManager"
  s.platform     = :ios, "8.0"
  s.requires_arc = true
  s.source       = { :git => "https://github.com/KerwinLan/HNetworkManager.git", :tag => "#{s.version}" }
  s.source_files  = "HNetworkManager/*.{h,m}"

end
