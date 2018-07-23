#
# Be sure to run `pod lib lint iOSLaTeX.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
    s.name             = 'iOSLaTeX'
    s.version          = '0.1.0'
    s.summary          = 'iOSLaTeX uses MathJax to render LaTeX in iOS'
    
    s.description      = 'iOSLaTeX provides a LaTeX Renderer which loads a minified version of MathJax in a WkWebView to render LaTeX in iOS. It returns image which can be used universally in iOS. It is also accompanied by a LaTeXImageView class.'
    
    s.homepage         = 'https://github.com/shujew/iOSLaTeX'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'shujew' => 'shuaib.jewon@slader.com' }
    s.source           = { :git => 'https://github.com/shujew/iOSLaTeX.git', :tag => s.version.to_s }
    
    s.ios.deployment_target = '9.0'
    
    s.source_files = 'iOSLaTeX/Classes/**/*'
    
    s.resources = ['iOSLaTeX/External/mathjax', 'iOSLaTeX/Assets/*']
    
    s.frameworks = 'WebKit'
    
    s.swift_version = '3.2'
end
