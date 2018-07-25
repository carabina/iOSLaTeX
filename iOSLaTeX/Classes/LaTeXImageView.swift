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
        self.laTeXRenderer = LaTeXRenderer(parentView: self)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.laTeXRenderer = LaTeXRenderer(parentView: self)
    }
    
    public override init(image: UIImage?) {
        super.init(image: image)
        self.laTeXRenderer = LaTeXRenderer(parentView: self)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.laTeXRenderer = LaTeXRenderer(parentView: self)
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
        self.image = nil
        self.backgroundColor = self.backgroundColorWhileRenderingLaTeX

        self.laTeXRenderer.render(laTeX) { [weak self] (renderedLaTeX, error)  in
            if let _ = error {
                print("LaTeX failed to render")
                return
            }
            
            self?.image = renderedLaTeX
        }
        
    }
}


