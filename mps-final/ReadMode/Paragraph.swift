//
//  Paragraph.swift
//  mps-final
//
//  Created by Carl Rustung on 5/4/18.
//  Copyright © 2018 Carl Rustung. All rights reserved.
//

import SpriteKit

class Paragraph: SKLabelNode {
    init( _ words: String ) {
        super.init()
        
        self.text = words
        
        self.preferredMaxLayoutWidth = 670
        self.numberOfLines = 0
        
        self.verticalAlignmentMode = .top
        self.horizontalAlignmentMode = .left
        self.lineBreakMode = .byWordWrapping
        
        self.fontName = "MiloSerifOT"
        self.fontSize = 36
        self.fontColor = .init( red: 88/255, green: 66/255, blue: 61/255, alpha: 1 )
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
