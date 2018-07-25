# iOSLaTeX

iOSLaTeX provides a LaTeXRenderer which loads a minified version of MathJax in a WkWebView to render LaTeX into native UIImage objects.

## Usage

LaTeXImageView is a subclass of `UIImageView` which uses a `LaTeXRenderer` object instance to render LaTeX text. It can be added programatically or through the Storyboard. Simply set the `latex` property on the object and it will handle the rest. 

LaTeXRenderer provides an easy to use `render(_ laTeX:, completion:)` function which can be used to render LaTeX. Note that LaTeXRenderer needs to be initialized with a parent view present in the view hierarchy else LaTeX rendering will be slow or timeout.

See example project for example code

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Installation

iOSLaTeX is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'iOSLaTeX', :git => 'https://github.com/shujew/iOSLaTeX.git'
```

## Author

shujew, shuaib.jewon@slader.com

## License

iOSLaTeX is available under the MIT license. See the LICENSE file for more info.
