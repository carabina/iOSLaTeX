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
    @IBOutlet weak var textfield: UITextField!
    
    let exampleLaTeXArray = [
        "$$(a_1 + a_2)^2 = a_1^2 + 2a_1a_2 + a_2^2$$",
        "$$x = \\frac{-b \\pm \\sqrt{b^2-4ac}}{2a}$$",
        "$$\\sigma = \\sqrt{\\frac{1}{N}\\sum_{i=1}^N (x_i - \\mu)^2}$$",
        "$$\\neg(P\\land Q) \\iff (\\neg P)\\lor(\\neg Q)$$",
        "$$\\log_b(x) = \\frac{\\log_a(x)}{\\log_a(b)}$$",
        "$$\\cos(\\theta + \\varphi) = \\cos(\\theta)\\cos(\\varphi) - \\sin(\\theta)\\sin(\\varphi)$$"
    ]
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.generateLaTeXButtonTapped(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func renderLaTeX(_ laTeX: String){
        self.view.endEditing(true)
        laTeXImageView.backgroundColorWhileRenderingLaTeX = self.view.backgroundColor
        laTeXImageView.laTeX = laTeX
    }
    
    @IBAction func generateLaTeXButtonTapped(_ sender: Any) {
        let textfieldText = textfield.text
        
        if let laTeX = textfieldText?.trimmingCharacters(in: .whitespaces), !laTeX.isEmpty, !exampleLaTeXArray.contains(laTeX) {
            renderLaTeX(laTeX)
        } else {
            let randomNum:UInt32 = arc4random_uniform(UInt32(exampleLaTeXArray.count))
            let defaultLaTeXText = exampleLaTeXArray[Int(randomNum)]
            
            textfield.text = defaultLaTeXText
            renderLaTeX(defaultLaTeXText)
        }
    }
}

