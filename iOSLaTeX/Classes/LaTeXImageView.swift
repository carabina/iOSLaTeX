//
//  LaTeXImageView.swift
//  iOSLaTeX
//
//  Created by Shuaib Jewon on 7/23/18.
//  Copyright © 2018 shujew. All rights reserved.
//

import Foundation

public class LaTeXImageView: UIImageView {
    private var laTeXRenderer: LaTeXRenderer?
    
    public func inject(laTeXRenderer: LaTeXRenderer){
        self.laTeXRenderer = laTeXRenderer
    }
    
    public var backgroundColorWhileRenderingLaTeX: UIColor? = .white
    
    public var laTeX: String? {
        didSet {
            if let laTeX = laTeX {
                self.renderLaTeX(laTeX)
            }
        }
    }
    
    public func renderLaTeX(_ laTeX: String, completion: ((String?)->())? = nil) {
        if self.laTeXRenderer == nil {
            self.laTeXRenderer = LaTeXRenderer(parentView: self)
        }
        
        self.image = nil
        self.backgroundColor = self.backgroundColorWhileRenderingLaTeX

        self.laTeXRenderer?.render(laTeX) { [weak self] (renderedLaTeX, error)  in
            guard let strongSelf = self else { return }
            
            strongSelf.image = renderedLaTeX
            
            completion?(error)
        }
    }
}


