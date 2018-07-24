//
//  LaTeXImageView.swift
//  iOSLaTeX
//
//  Created by Shuaib Jewon on 7/23/18.
//  Copyright © 2018 shujew. All rights reserved.
//

import Foundation

public class LaTeXImageView: UIImageView {
    private var laTeXRenderer: LaTeXRenderer!
    
    public override init(image: UIImage?, highlightedImage: UIImage?) {
        super.init(image: image, highlightedImage: highlightedImage)
        self.laTeXRenderer = LaTeXRenderer(parentView: self, delegate: self)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.laTeXRenderer = LaTeXRenderer(parentView: self, delegate: self)
    }
    
    public override init(image: UIImage?) {
        super.init(image: image)
        self.laTeXRenderer = LaTeXRenderer(parentView: self, delegate: self)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.laTeXRenderer = LaTeXRenderer(parentView: self, delegate: self)
    }
    
    public var backgroundColorWhileRenderingLaTeX: UIColor? = .white
    
    public var laTeX: String? {
        didSet {
            if let laTeX = laTeX {
                self.renderLaTeX(laTeX)
            }
        }
    }
    
    private func renderLaTeX(_ laTeX: String) {
        guard self.laTeXRenderer.isReady else { return }
        
        self.backgroundColor = self.backgroundColorWhileRenderingLaTeX
        self.laTeXRenderer.render(laTeX)
    }
}

extension LaTeXImageView: LaTeXRendererDelegate {
    public func LaTeXRendererDidComplete(image: UIImage) {
        self.image = image
    }
    
    public func LaTeXRendererDidFail(_ message: String) {
        print("LaTeXImageView failed to render LaTeX")
    }
}


