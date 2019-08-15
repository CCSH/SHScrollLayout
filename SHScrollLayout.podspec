Pod::Spec.new do |s|
    s.name         = "SHScrollLayout"
    s.version      = "2.0.1"
    s.summary      = "仿淘宝、京东、半糖、闲鱼、微博等首页界面布局 一个文件实现"
    s.license      = "MIT"
    s.authors      = { "CSH" => "624089195@qq.com" }
    s.platform     = :ios, "8.0"
    s.requires_arc = true
    s.homepage     = "https://github.com/CCSH/SHScrollLayout"
    s.source       = { :git => "https://github.com/CCSH/SHScrollLayout.git", :tag => s.version }
    s.source_files = "SHScrollLayout/*.{h,m}"
end
