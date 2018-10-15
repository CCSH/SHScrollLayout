Pod::Spec.new do |s|
    s.name         = "SHScrollLayout"
    s.version      = "1.0.1"
    s.summary      = "仿半糖、闲鱼、QQ联系人等界面布局"
    s.license      = "MIT"
    s.authors      = { "CSH" => "624089195@qq.com" }
    s.platform     = :ios, "6.0"
    s.requires_arc = true
    s.homepage     = "https://github.com/CCSH/SHScrollLayout"
    s.source       = { :git => "https://github.com/CCSH/SHScrollLayout.git", :tag => s.version }
    s.source_files = "SHScrollLayout/*.{h,m}"
end
