import SpriteKit
import GameplayKit

class ReadMode: SKScene, ButtonDelegate {
    
    var sceneScript: ReadModePageData!
    
    var currentPageNumber:Float = 1
    var currentPage:ReadModePage!
    
    let textView: TextView
    let illustration: SKSpriteNode
    //let illustrationView: IllustrationView   // TODO: Replace with simple SKSpriteNode
                                               // (might need to add special "readModeIllustration" data to JSON)
    var progressButton: SimpleButton!
    
    let hideProgressButton: SKAction = SKAction.moveTo( y: -100, duration: 0.3 )
    let showProgressButton: SKAction = SKAction.moveTo( y: 84, duration: 0.3 )
    
    override init( size: CGSize ) {
        print( "Welcome to Read Mode!" )
        
        self.textView = TextView()
        self.illustration = SKSpriteNode( imageNamed: "read-mode-placeholder" )
        
        super.init( size: size )
        
        self.illustration.anchorPoint = CGPoint( x: 0, y: 0 )
        self.illustration.position = CGPoint( x: 790, y: 0 )
        
        progressButton = SimpleButton( "progress", delegate: self )
        progressButton.position = CGPoint( x: 1280, y: -84 )
        
        addChild( self.textView )
        addChild( self.illustration )
        addChild( progressButton )
        
        MultiPlayerController.comm.setReadModeDelegate( self )
        loadSceneJSON( "readingData" )
    }
    
    func loadSceneJSON(_ fileName: String ) {
        if let path = Bundle.main.path( forResource: fileName, ofType: "json" ) {
            do {
                let readingData = try Data( contentsOf: URL( fileURLWithPath: path ), options: .mappedIfSafe )
                sceneScript = try! JSONDecoder().decode( ReadModePageData.self, from: readingData )
            } catch {
                //
            }
        }
        
        currentPage = getPageWithPageNo( currentPageNumber )
        loadPage( currentPage, newPage: true )
    }
    
    func getPageWithPageNo(_ pageNo:Float ) -> ReadModePage {
        return sceneScript.pages.filter{ $0.pageNo == pageNo }[0]
    }
    
    func loadPage( _ page:ReadModePage, newPage:Bool ) {
        switch page.ixType {
        
        // Paragraph
        case ReadModeInteractionType.paragraph.rawValue:
            print( "Page type: Paragraph" )
            if let t = page.text {
                textView.addText( t )
            }
            
            if let illName:String = page.illustration {
                illustration.texture = SKTexture( imageNamed: illName )
            }
            
            progressButton.run( showProgressButton ){
                self.progressButton.enable()
            }
            
            break
            
        // Hotspot page
        case ReadModeInteractionType.hotspots.rawValue:
            print( "Page type: Hotspots" )
            if let t = page.text {
                if newPage {
                    textView.reset( setText: t )
                } else {
                    textView.addText( t )
                }
            }
            
            if let illName:String = page.illustration {
                illustration.texture = SKTexture( imageNamed: illName )
            }
            
            break
            
        // Character select page
        case ReadModeInteractionType.charSelect.rawValue:
            print( "Page type: Character select" )
            
            if let t = page.text {
                textView.reset( setText: t ) // Character select is always new page
            }
            
            if let illName:String = page.illustration {
                illustration.texture = SKTexture( imageNamed: illName )
            }
            
            break
            
        // Character description page
        case ReadModeInteractionType.charDesc.rawValue:
            print( "Page type: Character description" )
            
            // Redirect to end page
            if let cds:CharacterDescriptions = page.descriptions {
                let charLook:String = StoryHandler.sharedInstance.flags[cds.lookFlag]!
                let charInterest:String = StoryHandler.sharedInstance.flags[cds.interestFlag]!
            
                let desc:CharacterDescription = cds.values.filter{ $0.look == charLook }[0]
                let redir:CharacterRedirect = desc.redirects.filter{ $0.interest == charInterest }[0]
                
                //textView.addText( dbi.characterDescription )
                //let page = getPageWithPageNo( redir.toPage )
                //loadPage( page, newPage: false )
                MultiPlayerController.comm.sendReadModePageNo( redir.toPage )
            }
            
            if let illName:String = page.illustration {
                illustration.texture = SKTexture( imageNamed: illName )
            }
            
            break
            
        // Triplet selector page
        case ReadModeInteractionType.tripletSelector.rawValue:
            print( "Page type: Triplet selector" )
            
            if let t = page.text {
                textView.reset( setText: t ) // Triplet selector is always new page
            }
            
            if let illName:String = page.illustration {
                illustration.texture = SKTexture( imageNamed: illName )
            }
            
            break
            
        // Flag redirect page
        case ReadModeInteractionType.flagRedirect.rawValue:
            print( "Page type: Flag redirect" )
            
            if let key:String = page.checkFlagKey {
                if let redirDataArray:Array<FlagRedirectData> = page.redirectByFlag {
                    let redirData:FlagRedirectData = redirDataArray.filter{ $0.flagValue == StoryHandler.sharedInstance.flags[key]}[0]
                    let redir:FlagRedirect = redirData.redirect.filter{ $0.flagValue == StoryHandler.sharedInstance.flags[redirData.redirectFlagKey]}[0]
                    
                    //let page = getPageWithPageNo( redir.toPage )
                    //loadPage( page, newPage: true )
                    MultiPlayerController.comm.sendReadModePageNo( redir.toPage )
                }
            }
            
            break
            
        // End page
        case ReadModeInteractionType.endPage.rawValue:
            print( "Page type: End page" )
            
            if let t = page.text {
                if newPage {
                    textView.reset( setText: t )
                } else {
                    textView.addText( t )
                }
            }
            
            if let illName:String = page.illustration {
                illustration.texture = SKTexture( imageNamed: illName )
            }
            
            progressButton.run( showProgressButton ){
                self.progressButton.enable()
            }
            
            break
            
        // End scene
        case ReadModeInteractionType.endScene.rawValue:
            print( "Page type: End scene" )
            
            if let t = page.text {
                if newPage {
                    textView.reset( setText: t )
                } else {
                    textView.addText( t )
                }
            }
            
            if let illName:String = page.illustration {
                illustration.texture = SKTexture( imageNamed: illName )
            }
            
            break
            
        // Default (probably an error)
        default:
            print( "Read mode interaction type not recognized (" + page.ixType + ")" )
            break
        }
    }
    
    // Button delegate function
    func buttonPressed( btnID: String ) {
        switch btnID {
        case "progress" :
            progressButton.disable()
            MultiPlayerController.comm.sendReadModePageTurn()
            break
        default :
            break
        }
    }
    
    //// SKScene Functions
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    required init?( coder aDecoder: NSCoder ) {
        fatalError( "NSCoder not supported" )
    }
}


//// MULTIPLAYER EVENTS

extension ReadMode: ReadModeMPDelegate {

    func turnPage() {
        progressButton.run( hideProgressButton )
        
        currentPageNumber += 1
        currentPage = getPageWithPageNo( currentPageNumber )
        
        loadPage( currentPage, newPage: true )
    }
    
    func setPage(_ pageNo: String) {
        print( "Received page no: " + pageNo )
        let page:ReadModePage = getPageWithPageNo( Float( pageNo )! )
        
        loadPage( page, newPage: false )
    }
}
