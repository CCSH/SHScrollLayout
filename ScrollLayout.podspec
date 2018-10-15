Pod::Spec.new do |s|
    s.name         = "ScrollLayout"
    s.version      = "1.0.0"
    s.summary      = "标签页"
    s.license      = "MIT"
    s.authors      = { "CSH" => "624089195@qq.com" }
    s.platform     = :ios, "6.0"
    s.requires_arc = true
    s.homepage     = "https://github.com/CCSH/ScrollLayout"
    s.source       = { :git => "https://github.com/CCSH/ScrollLayout.git", :tag => s.version }
    s.source_files = "ScrollLayout/*.{h,m}"
end
