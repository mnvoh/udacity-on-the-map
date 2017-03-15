//
//  ButtonWithPadding.swift
//  OnTheMap
//
//  Created by Milad Nozari on 3/15/17.
//  Copyright © 2017 Nozary. All rights reserved.
//

import UIKit

@IBDesignable class ButtonWithPadding: UIButton {

    @IBInspectable var topPadding: CGFloat = 0 {
        didSet {
            setup()
        }
    }
    @IBInspectable var rightPadding: CGFloat = 16 {
        didSet {
            setup()
        }
    }
    @IBInspectable var bottomPadding: CGFloat = 0 {
        didSet {
            setup()
        }
    }
    @IBInspectable var leftPadding: CGFloat = 16 {
        didSet {
            setup()
        }
    }
    @IBInspectable var cornerRadius: CGFloat = 6 {
        didSet {
            setup()
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        let contentInset = UIEdgeInsets(top: topPadding, left: leftPadding, bottom: bottomPadding, right: rightPadding)
        contentEdgeInsets = contentInset
        
        layer.cornerRadius = cornerRadius
        clipsToBounds = true
        
        setNeedsDisplay()
    }
    
}
