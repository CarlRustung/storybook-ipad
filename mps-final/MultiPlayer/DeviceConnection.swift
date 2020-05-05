import SpriteKit
import GameplayKit

class DeviceConnection: SKScene, MultiPlayerDelegate {
    
    var companionCode: SKLabelNode!
    var bgImage, spinner: SKSpriteNode!
    
    required init?( coder aDecoder: NSCoder ) {
        fatalError( "NSCoder not supported" )
    }
    
    override init( size: CGSize ) {
        super.init( size: size )
        
        self.backgroundColor = UIColor.black
        
        bgImage = SKSpriteNode( imageNamed: "iPad_connecting" )
        bgImage.position = CGPoint( x: 0, y: 0 )
        bgImage.anchorPoint = CGPoint( x: 0, y: 0 )
        bgImage.isUserInteractionEnabled = false
        bgImage.name = "background"
        addChild( bgImage )
        
        spinner = SKSpriteNode( imageNamed: "spinner_large" )
        spinner.position = CGPoint( x: 564, y: 460 )
        spinner.anchorPoint = CGPoint( x: 0.5, y: 0.5 )
        spinner.isUserInteractionEnabled = false
        spinner.zRotation = 0
        addChild( spinner )
        
        companionCode = SKLabelNode( text: "" )
        companionCode.fontName = "MiloSerifOT-Bold"
        companionCode.fontSize = 144.0
        companionCode.fontColor = UIColor( red: 68/255, green: 218/255, blue: 1, alpha: 1 )
        companionCode.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        companionCode.position = CGPoint( x: 180, y: 280 )
        addChild( companionCode )
        
        MultiPlayerController.comm.setDelegate( self )
        MultiPlayerController.comm.connect();
    }
    
    override func update(_ currentTime: TimeInterval) {
        spinner.zRotation -= 0.05
    }
    
    func receiveMPData(_ data: MPData) {
        switch data.event {
        case "connectionCode"?:
            companionCode.text = data.message
            bgImage.texture = SKTexture( imageNamed: "iPad_connected" )
            spinner.alpha = 0
            break
        case "dyadConnected"?:
            companionCode.run( SKAction.fadeOut( withDuration: 1 ) )
            bgImage.texture = SKTexture( imageNamed: "iPad_complete" )
            bgImage.run( SKAction.fadeOut( withDuration: 1 ) ) {
                let nextScene = ReadMode( size: self.size )
                nextScene.scaleMode = .aspectFit
                self.view?.presentScene( nextScene )
            }
            break
        default:
            break
        }
    }
}
