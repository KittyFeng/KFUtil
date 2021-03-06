Pod::Spec.new do |s|

  s.name         = "KFUtil"
  s.version      = "0.0.1"
  s.summary      = "KFUtil is a useful tool for you to create an application efficiently."

  s.description  = <<-DESC
KFUtil is a useful tool for you to create an application efficiently.
                   DESC

  s.homepage     = "https://github.com/KittyFeng/KFUtil"

  s.license      = "MIT"
  s.author             = { "KittyFeng" => "kitty_feng@icloud.com" }


  s.source       = { :git => "https://github.com/KittyFeng/KFUtil.git",
                     :tag => s.version,
                     :submodules => true }


  s.source_files  = "KFUtil/KFUtil.h"
  s.public_header_files = "KFUtil/KFUtil.h"
  s.platform      = :ios, '7.0'
  s.requires_arc  = true
#  s.dependency "AFNetworking", "~> 2.0"

    s.subspec 'DebugUtil' do |ss|
    ss.public_header_files = 'KFUtil/DebugUtil/*.h'
    ss.source_files = 'KFUtil/DebugUtil/*.{h,m}'
    end

    s.subspec 'FoundationUtil' do |ss|
    ss.public_header_files = 'KFUtil/FoundationUtil/*.h'
    ss.source_files = 'KFUtil/FoundationUtil/*.{h,m}'
    end



    s.subspec 'UIViewUtil' do |ss|
    ss.public_header_files = 'KFUtil/UIViewUtil/*.h'
    ss.source_files = 'KFUtil/UIViewUtil/*.{h,m}'

    s.subspec 'KFNetworking' do |ss|
    ss.public_header_files = 'KFUtil/KFNetworking/*.h'
    ss.source_files = 'KFUtil/KFNetworking/*.{h,m}'
    ss.dependency "AFNetworking", "~> 3.0"
    end
end



end
