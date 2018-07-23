//
//  LaTeXRenderer.swift
//  iOSLaTeX
//
//  Created by Shuaib Jewon on 7/23/18.
//  Copyright © 2018 shujew. All rights reserved.
//

import Foundation
import WebKit

public protocol LaTeXRendererDelegate: class {
    func LaTeXRendererDidComplete(image: UIImage)
    func LaTeXRendererDidFail(_ message: String)
}

public class LaTeXRenderer: NSObject {
    static var mathJaxInLineMathPlaceholder: String = "{mathJaxInLineMathConfig placeholder}"
    static var htmlPlaceholder: String = "{latex placeholder}"
    
    static var mathJaxCallbackHandler: String = "callbackHandler"
    static var mathJaxInLineMathConfig: String = "[['$','$'],['\\(','\\)'], ['[math]','[/math]']]"
    
    static var timeoutInSeconds: Double = 10.0
    static var delayInMilliseconds: Int = 100 /* see comments to understand usage */
    
    weak var delegate: LaTeXRendererDelegate?
    weak private var parentView: UIView?
    
    private var webView: WKWebView?
    private var timeoutTimer: Timer?
    
    private var hidingView: UIView? /* used to hide WkWebView while rendering LaTeX */
    
    public func render(_ laTeX: String, forView parentView: UIView) {
        self.reset()
        
        self.parentView = parentView
        
        self.setupWebView()
        
        guard let webView = self.webView else {
            self.handleLaTeXRenderingFailure("Failure initializing WkWebView")
            return
        }
        
        let bundle = Bundle(for: type(of: self))
        
        guard let path = bundle.path(forResource: "MathJaxRenderer", ofType: "html"),
            let htmlTemplate = try? String(contentsOfFile: path) else {
                
                self.handleLaTeXRenderingFailure("Failure loading MathJax HTML template")
                return
        }
        
        let htmlDirectory = bundle.bundlePath
        let baseUrl = URL(fileURLWithPath: htmlDirectory, isDirectory: true)
        
        self.hidingView = UIView(frame: parentView.bounds)
        self.hidingView?.backgroundColor = parentView.backgroundColor
        
        /*
         * Need to add WkWebView to view hierarchy to improve loading time (Apple bug)
         * If not added, complex/long LaTeX will take ages to render
         */
        parentView.addSubview(self.hidingView!)
        parentView.addSubview(webView)
        parentView.sendSubview(toBack: webView)
        
        /*
         * Figure out why delay is needed here
         * If no delay, webview will appear for a split second
         */
        
        let delay = DispatchTime.now() + .milliseconds(LaTeXRenderer.delayInMilliseconds)
        DispatchQueue.main.asyncAfter(deadline: delay) {
            let html = htmlTemplate
                .replacingOccurrences(of: LaTeXRenderer.mathJaxInLineMathPlaceholder, with: LaTeXRenderer.mathJaxInLineMathConfig)
                .replacingOccurrences(of: LaTeXRenderer.htmlPlaceholder, with: laTeX)
            
            webView.navigationDelegate = self
            webView.uiDelegate = self
            
            webView.loadHTMLString(html, baseURL: baseUrl)
        }
        
        timeoutTimer = Timer.scheduledTimer(
            timeInterval: LaTeXRenderer.timeoutInSeconds,
            target: self,
            selector: #selector(self.renderTimeout),
            userInfo: nil,
            repeats: false
        )
    }
    
    fileprivate func handleLaTeXRenderingSuccess(message: Any) {
        self.timeoutTimer?.invalidate()
        
        guard let data = (message as? String)?.data(using: .utf8),
            let json = try? JSONSerialization.jsonObject(with: data),
            let jsonDict = json as? [String: CGFloat],
            let widthFloat = jsonDict["width"],
            let heightFloat = jsonDict["height"] else {
                
                self.handleLaTeXRenderingFailure("Failure processing MathJax Signal")
                return
        }
        
        self.getLaTeXImage(withWidth: Int(widthFloat), withHeight: Int(heightFloat)) { [weak self] (image, error) in
            guard let strongSelf = self else { return }
            
            if let error = error {
                strongSelf.handleLaTeXRenderingFailure(error)
                return
            }
            
            guard let image = image else {
                strongSelf.handleLaTeXRenderingFailure("Failure grabbing image data from WkWebView")
                return
            }
            
            strongSelf.delegate?.LaTeXRendererDidComplete(image: image)
            
            strongSelf.reset()
        }
    }
    
    fileprivate func handleLaTeXRenderingFailure(_ message: String) {
        self.timeoutTimer?.invalidate()
        
        self.delegate?.LaTeXRendererDidFail(message)
        
        self.reset()
    }
    
    private func getLaTeXImage(withWidth width: Int, withHeight height: Int, completion: @escaping (UIImage?, String?) -> ()) {
        guard let webView = self.webView else {
            completion(nil, "WkWebView is null")
            return
        }
        
        webView.frame = CGRect(origin: webView.frame.origin, size: webView.scrollView.contentSize)
        
        /*
         * If no delay, webview's frame change will not have taken effect yet
         */
        let delay = DispatchTime.now() + .milliseconds(LaTeXRenderer.delayInMilliseconds)
        DispatchQueue.main.asyncAfter(deadline: delay) {
            UIGraphicsBeginImageContextWithOptions(webView.bounds.size, true, 0)
            webView.drawHierarchy(in: webView.bounds, afterScreenUpdates: true)
            
            guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
                completion(nil, "Failure while taking WKWebView snapshot")
                return
            }
            
            UIGraphicsEndImageContext()
            
            guard let croppedImage = self.crop(image, toWidth: width, andHeight: height) else {
                completion(nil, "Failure while cropping WKWebView snapshot")
                return
            }
            
            completion(croppedImage, nil)
        }
    }
    
    private func reset() {
        self.webView?.stopLoading()
        self.webView?.configuration.userContentController.removeScriptMessageHandler(forName: LaTeXRenderer.mathJaxCallbackHandler)
        
        self.webView?.uiDelegate = nil
        self.webView?.navigationDelegate = nil
        
        if let _ = self.webView?.superview, let _ = self.webView?.superview {
            self.webView?.removeFromSuperview()
        }
        
        if let _ = self.hidingView?.superview, let _ = self.hidingView?.superview {
            self.hidingView?.removeFromSuperview()
        }
        
        self.webView = nil
        self.hidingView = nil
        self.parentView = nil
        
        self.timeoutTimer?.invalidate()
        self.timeoutTimer = nil
    }
    
    @objc private func renderTimeout() {
        self.handleLaTeXRenderingFailure("Timed out while rendering LaTeX")
    }
    
    private func setupWebView() {
        guard let parentView = self.parentView else { return }
        
        let frame = parentView.bounds
        let contentController = WKUserContentController();
        let config = WKWebViewConfiguration()
        
        contentController.add(self, name: LaTeXRenderer.mathJaxCallbackHandler)
        config.userContentController = contentController
        
        let webViewFrame = CGRect(origin: frame.origin, size: CGSize(width: frame.size.width, height: frame.size.height))
        
        self.webView = WKWebView(frame: webViewFrame, configuration: config)
    }
    
    private func crop(_ image: UIImage, toWidth width: Int, andHeight height: Int) -> UIImage? {
        guard let cgImage = image.cgImage else {
            return nil
        }
        
        let cgImageWidth = cgImage.width
        let cgImageHeight = cgImage.height
        
        let cropWidth =  CGFloat(width) / image.size.width * CGFloat(cgImageWidth)
        let cropHeight =   CGFloat(height) / image.size.height * CGFloat(cgImageHeight)
        let cropRect = CGRect(x: 0, y: 0, width: cropWidth, height: cropHeight)
        
        guard let croppedCgImage = cgImage.cropping(to: cropRect) else {
            return nil
        }
        
        return UIImage(cgImage: croppedCgImage)
    }
}

extension LaTeXRenderer: WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler {
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if(message.name == LaTeXRenderer.mathJaxCallbackHandler) {
            self.handleLaTeXRenderingSuccess(message: message.body)
        }
    }
    
    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.handleLaTeXRenderingFailure("WKWebView navigation failed")
    }
}




