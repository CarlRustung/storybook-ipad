import UIKit
import SpriteKit
import GameplayKit

import Starscream
import SocketIO

class GameViewController: UIViewController {
    
    var scene: DeviceConnection!
    //let mpController:MultiPlayerController = MultiPlayerController.comm
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Configure the view
        let skView = view as! SKView
        skView.isMultipleTouchEnabled = false
        
        // Create and configure the scene
        scene = DeviceConnection( size: skView.bounds.size )
        scene.scaleMode = .aspectFill
        
        // Present the scene
        skView.presentScene( scene )
        skView.showsFPS = true
        skView.showsNodeCount = true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
