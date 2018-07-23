//
//  LaTeXImageView.swift
//  iOSLaTeX
//
//  Created by Shuaib Jewon on 7/23/18.
//  Copyright © 2018 shujew. All rights reserved.
//

import Foundation

public class LaTeXImageView: UIImageView {
    fileprivate var renderer: LaTeXRenderer?
    
    public var laTeX: String? {
        didSet {
            if let laTeX = laTeX {
                self.renderLaTeX(laTeX)
            }
        }
    }
    
    private func renderLaTeX(_ laTeX: String) {
        if self.renderer == nil {
            self.renderer = LaTeXRenderer()
            self.renderer?.delegate = self
        }
        
        self.clipsToBounds = true
        self.backgroundColor = .white
        self.renderer?.render(laTeX, forView: self)
    }
}

extension LaTeXImageView: LaTeXRendererDelegate {
    public func LaTeXRendererDidComplete(image: UIImage) {
        self.image = image
        self.renderer = nil
    }
    
    public func LaTeXRendererDidFail(_ message: String) {
        print("LaTeXImageView failed to render LaTeX")
        print(message)
        self.renderer = nil
    }
}


