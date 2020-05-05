import SpriteKit

class HotspotButton: SKSpriteNode {
    
    var dg : ButtonDelegate!
    
    init(_ imgName:String, delegate: ButtonDelegate ) {
        let upTexture: SKTexture = SKTexture( imageNamed: imgName )
        
        dg = delegate;
        
        super.init( texture: upTexture, color: UIColor.black, size: upTexture.size() )
        
        self.isUserInteractionEnabled = false
        self.name = imgName
        
        self.anchorPoint = CGPoint( x: 0.5, y: 0.5 )
    }
    
    func enable() {
        self.isUserInteractionEnabled = true
    }
    
    func disable() {
        self.isUserInteractionEnabled = false
    }
    
    override func touchesBegan( _ touches: Set<UITouch>, with event: UIEvent? ) {
        dg.buttonPressed( btnID: self.name! )
    }
    
    required init( coder aDecoder: NSCoder ) {
        fatalError( "init(coder:) has not been implemented" )
    }
}
