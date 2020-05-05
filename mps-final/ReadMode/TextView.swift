//
//  TextView.swift
//  mps-final
//
//  Created by Carl Rustung on 4/24/18.
//  Copyright © 2018 Carl Rustung. All rights reserved.
//

import SpriteKit

class TextView: SKNode {
    
    let bg:SKShapeNode
    //let words:Paragraph
    let marginLeft:CGFloat = 60
    let paragraphSpacing:CGFloat = 30
    
    var pageCenter:CGFloat = 0
    var firstParagraphHeight:CGFloat = 0
    
    var pageText:Array<Paragraph>
    var pageTextGroup:SKNode = SKNode()
    
    override init(){
        self.bg = SKShapeNode( rect: CGRect( x: 0, y: 0, width: 790, height: 1024 ) )
        self.bg.fillColor = .init( red: 244/255, green: 239/255, blue: 230/255, alpha: 1 )
        self.pageCenter = 512
        
        self.pageText = Array<Paragraph>()
        
        super.init()
        
        addChild( self.bg )
        addChild( self.pageTextGroup )
    }
    
    func reset( setText: String ) {
        pageTextGroup.run( SKAction.fadeOut(withDuration: 0.5 ) ) {
            self.pageTextGroup.removeAllChildren()
            self.pageText.removeAll()
            
            self.pageTextGroup.position.y = 0
            self.pageTextGroup.alpha = 1
            self.addText( setText )
        }
    }
    
    func addText(_ txt:String ) {
        let words = Paragraph( txt );
        
        if pageText.count == 0 {
            firstParagraphHeight = words.frame.height * -0.5
        }
        
        var pageTextHeight:CGFloat = 0
        for text in pageText {
            pageTextHeight += text.frame.height + paragraphSpacing
        }
        
        words.position = CGPoint( x: marginLeft, y: pageCenter - pageTextHeight - firstParagraphHeight )
        
        words.alpha = 0
        
        pageText.append( words );
        pageTextGroup.addChild( words )
        
        words.run( SKAction.fadeIn( withDuration: 0.5 ) )
        
        if pageText.count > 1 {
            let scoot:SKAction = SKAction.moveTo( y: pageTextHeight * 0.5 + paragraphSpacing, duration: 0.5 )
            scoot.timingMode = .easeInEaseOut
            pageTextGroup.run( scoot )
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError( "init(coder:) has not been implemented" )
    }
}
