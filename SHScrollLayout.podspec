Pod::Spec.new do |s|
    s.name         = "SHScrollLayout"
    s.version      = "2.1.2"
    s.summary      = "仿淘宝、京东、半糖、闲鱼、微博等首页界面复杂布局 一个文件实现"
    s.license      = "MIT"
    s.authors      = { "CCSH" => "624089195@qq.com" }
    s.platform     = :ios, "8.0"
    s.requires_arc = true
    s.homepage     = "https://github.com/CCSH/#{s.name}"
    s.source       = { :git => "https://github.com/CCSH/#{s.name}.git", :tag => "#{s.version}" }
    s.source_files = "#{s.name}/*.{h,m}"
end
