//
//  ViewController.swift
//  iOSLaTeX
//
//  Created by shujew on 07/23/2018.
//  Copyright (c) 2018 shujew. All rights reserved.
//

import UIKit
import iOSLaTeX

class ViewController: UIViewController {

    @IBOutlet weak var laTeXImageView: LaTeXImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        laTeXImageView.contentMode = .scaleAspectFit
        laTeXImageView.laTeX = """
        [math]y=4x[/math]
        
        [math]3x-y=1[/math]
        
        Now plug 4x into y.
        
        [math]3x-4x=1[/math]
        
        Subtract.
        
        [math]-x=1[/math]
        
        Divide/multiply by -1.
        
        [math]\\dfrac{-x}{-1}=\\dfrac{1}{-1}[/math]
        
        [math]x=-1[/math]
        
        If you're solving for y as well, plug -1 into y=4x.
        
        [math]y=4x[/math]
        
        [math]y=4(-1)[/math]
        
        [math]y=-4[/math]
        """
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

