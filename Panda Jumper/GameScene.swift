//
//  GameScene.swift
//  Panda Jumper
//
//  Created by Nayna on 6/16/20.
//  Copyright © 2020 Nayna. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    let panda = SKSpriteNode(imageNamed: "mypanda")
     var lastUpdateTime: TimeInterval = 0
     var dt: TimeInterval = 0
     let pandaMovePointsPerSec: CGFloat = 480.0
     var velocity = CGPoint.zero
     let playableRect: CGRect
     var lastTouchLocation: CGPoint?
    // let pandaMove: SKAction
    // let pandaAnimation: SKAction
    
    // let jumpSound: SKAction = SKAction.playSoundFileNamed(
      // "jumpSound.wav", waitForCompletion: false)
    // let enemyCollisionSound: SKAction = SKAction.playSoundFileNamed(
    //   "loselifeSound.wav", waitForCompletion: false)
     var invincible = false

     var lives = 3
     var gameOver = false
     let cameraNode = SKCameraNode()
     let cameraMovePointsPerSec: CGFloat = 200.0

     let livesLabel = SKLabelNode(fontNamed: "Chalkduster")

       
        /*   override init(size: CGSize) {
       let maxAspectRatio:CGFloat = 16.0/9.0
       let playableHeight = size.width / maxAspectRatio
       let playableMargin = (size.height-playableHeight)/2.0
       playableRect = CGRect(x: 0, y: playableMargin,
                             width: size.width,
                             height: playableHeight)
       
       // 1
      var textures:[SKTexture] = []
       // 2
        for i in 1...12 {
            textures.append(SKTexture(imageNamed: "mypanda\(i)"))
          }
       // 3
       textures.append(textures[2])
       textures.append(textures[1])

       // 4
       pandaAnimation = SKAction.animate(with: textures,
    timePerFrame: 0.1)
       pandaMove = SKAction.moveBy(x: 0 + panda.size.width, y: 0, duration: 1.5)
     
       super.init(size: size)
     } */
    override init(size: CGSize) {
     let maxAspectRatio:CGFloat = 16.0/9.0 // 1
     let playableHeight = size.width / maxAspectRatio // 2
     let playableMargin = (size.height-playableHeight)/2.0 // 3
     playableRect = CGRect(x: 0, y: playableMargin,
     width: size.width,
     height: playableHeight) // 4
     super.init(size: size) // 5
    }

     required init(coder aDecoder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
     }
    
  /*
     var cameraRect : CGRect {
       let x = cameraNode.position.x - size.width/2
           + (size.width - playableRect.width)/2
       let y = cameraNode.position.y - size.height/2
           + (size.height - playableRect.height)/2
       return CGRect(
         x: x,
         y: y,
         width: playableRect.width,
         height: playableRect.height)
     }*/
    
     func debugDrawPlayableArea() {
       let shape = SKShapeNode()
       let path = CGMutablePath()
       path.addRect(playableRect)
       shape.path = path
       shape.strokeColor = SKColor.red
       shape.lineWidth = 4.0
       addChild(shape)
     }
    override func didMove(to view: SKView) {
       backgroundColor = SKColor.black
       let background = SKSpriteNode(imageNamed: "bakground")
        background.anchorPoint = CGPoint(x: 0.5, y: 0.5) // default
        background.position = CGPoint(x: size.width/2, y: size.height/1.4)
        background.setScale(2)
       // background.zRotation = CGFloat(M_PI) / 8
       background.zPosition = -1
       addChild(background)
       
       let mySize = background.size
       print("Size: \(mySize)")
       
       panda.position = CGPoint(x: 350, y: 350)
        panda.setScale(5)
    //   zombie.setScale(2) // SKNode method
       addChild(panda)
       debugDrawPlayableArea()
        go()
     }
    
    func go(){

    
        let moveRight = SKAction.move(to: CGPoint(x: playableRect.width, y:  320), duration: 2)

        let RPL = SKAction.scaleX(to: panda.xScale * -1, duration: 0)

        let moveLeft = SKAction.move(to: CGPoint(x: 0, y:  320), duration: 2)

        let RPR = SKAction.scaleX(to: panda.xScale , duration: 0)



panda.run(SKAction.repeatForever(SKAction.sequence([moveRight, RPL, moveLeft, RPR])))

    }
    
    
    override func update(_ currentTime: TimeInterval) {
        if lastUpdateTime > 0 {
         dt = currentTime - lastUpdateTime
        } else {
         dt = 0
        }
        lastUpdateTime = currentTime
    move(sprite: panda, velocity: velocity)
        print("\(dt*1000) milliseconds since last update")
        boundsCheckPanda()
        //rotate(sprite: panda, direction: velocity)
    }
    
    func move(sprite: SKSpriteNode, velocity: CGPoint) {
     // 1
     let amountToMove = CGPoint(x: velocity.x * CGFloat(dt),
     y: velocity.y * CGFloat(dt))
     print("Amount to move: \(amountToMove)")
     // 2
     sprite.position = CGPoint(
     x: sprite.position.x + amountToMove.x,
     y: sprite.position.y + amountToMove.y)
    }
    
    
    func movePandaToward(location: CGPoint) {
     let offset = CGPoint(x: location.x - panda.position.x,
     y: location.y - panda.position.y)
        let length = sqrt(
        Double(offset.x * offset.x + offset.y * offset.y))
        let direction = CGPoint(x: offset.x / CGFloat(length),
         y: offset.y / CGFloat(length))
        velocity = CGPoint(x: direction.x * pandaMovePointsPerSec, y: direction.y * pandaMovePointsPerSec)
    }
    func sceneTouched(touchLocation:CGPoint) {
     //movePandaToward(location: touchLocation)
    }
    override func touchesBegan(_ touches: Set<UITouch>,
     with event: UIEvent?) {
     guard let touch = touches.first else {
     return
     }
        
     let touchLocation = touch.location(in: self)
     sceneTouched(touchLocation: touchLocation)
    }
    override func touchesMoved(_ touches: Set<UITouch>,
     with event: UIEvent?) {
     guard let touch = touches.first else {
     return
     }
     let touchLocation = touch.location(in: self)
     sceneTouched(touchLocation: touchLocation)
    }
    func boundsCheckPanda() {
    let bottomLeft = CGPoint(x: 0, y: playableRect.minY)
     let topRight = CGPoint(x: size.width, y: playableRect.maxY)

     if panda.position.x <= bottomLeft.x {
     panda.position.x = bottomLeft.x
     velocity.x = -velocity.x
     }
     if panda.position.x >= topRight.x {
     panda.position.x = topRight.x
     velocity.x = -velocity.x
     }
     if panda.position.y <= bottomLeft.y {
     panda.position.y = bottomLeft.y
     velocity.y = -velocity.y
     }
     if panda.position.y >= topRight.y {
     panda.position.y = topRight.y
     velocity.y = -velocity.y
     }
    }
    func rotate(sprite: SKSpriteNode, direction: CGPoint) {
   sprite.xScale = sprite.xScale * -1;
   //     sprite.zRotation = CGFloat(
    //atan2(Double(direction.y), Double(direction.x)))
    }
    
    /*
       func moveCamera() {
          let backgroundVelocity =
            CGPoint(x: cameraMovePointsPerSec, y: 0)
          let amountToMove = backgroundVelocity * CGFloat(dt)
          cameraNode.position += amountToMove
          
          enumerateChildNodes(withName: "bakground") { node, _ in
            let background = node as! SKSpriteNode
            if background.position.x + background.size.width <
                self.cameraRect.origin.x {
              background.position = CGPoint(
                x: background.position.x + background.size.width*2,
                y: background.position.y)
            }
          }
          
        }
       func backgroundNode() -> SKSpriteNode {
         // 1
         let backgroundNode = SKSpriteNode()
         backgroundNode.anchorPoint = CGPoint.zero
         backgroundNode.name = "bakground"
           backgroundNode.zPosition = -1

         // 2
         let background1 = SKSpriteNode(imageNamed: "bakground")
         background1.anchorPoint = CGPoint.zero
         background1.position = CGPoint(x: 0, y: 0)
         backgroundNode.addChild(background1)
         
         // 3
         let background2 = SKSpriteNode(imageNamed: "bakground")
         background2.anchorPoint = CGPoint.zero
         background2.position =
           CGPoint(x: background1.size.width, y: 0)
         backgroundNode.addChild(background2)

         // 4
         backgroundNode.size = CGSize(
           width: background1.size.width + background2.size.width,
           height: background1.size.height)
         return backgroundNode
       }
     func spawnEnemy() {
       let enemy = SKSpriteNode(imageNamed: "spikes")
       enemy.position = CGPoint(
         x: cameraRect.maxX + enemy.size.width/2,
         y: cameraRect.minY + 80)
       enemy.zPosition = 50
       enemy.name = "spikes"
       enemy.setScale(0.7)
       addChild(enemy)
       
       let actionMove =
         SKAction.moveBy(x: -(size.width + enemy.size.width), y: 0, duration: 4.0)
       let actionRemove = SKAction.removeFromParent()
       enemy.run(SKAction.sequence([actionMove, actionRemove]))
     }
       func move(sprite: SKSpriteNode, velocity: CGPoint) {
         let amountToMove = CGPoint(x: velocity.x * CGFloat(dt),
                                    y: velocity.y * CGFloat(dt))
         sprite.position += amountToMove
       }
     override func didMove(to view: SKView) {

      // playBackgroundMusic(filename: "BgSound.wav")
     
       for i in 0...1 {
         let background = backgroundNode()
         background.anchorPoint = CGPoint.zero
         background.position =
           CGPoint(x: CGFloat(i)*background.size.width, y: 0)
         background.name = "bakground"
         background.zPosition = -1
         addChild(background)
       }
       
       panda.position = CGPoint(x: 460, y: 460)
       panda.zPosition = 100
       addChild(panda)
       panda.run(SKAction.repeatForever(pandaAnimation))
       panda.run(SKAction.repeatForever(pandaMove))
       
       run(SKAction.repeatForever(
         SKAction.sequence([SKAction.run() { [weak self] in
                         self?.spawnEnemy()
                       },
                       SKAction.wait(forDuration: 2.0)])))

     
       
       // debugDrawPlayableArea()
       
       addChild(cameraNode)
       camera = cameraNode
       cameraNode.position = CGPoint(x: size.width/2, y: size.height/2)
       
       livesLabel.text = "Lives: X"
       livesLabel.fontColor = SKColor.black
       livesLabel.fontSize = 100
       livesLabel.zPosition = 150
       livesLabel.horizontalAlignmentMode = .left
       livesLabel.verticalAlignmentMode = .bottom
       livesLabel.position = CGPoint(
           x: -playableRect.size.width/2 + CGFloat(20),
           y: -playableRect.size.height/2 + CGFloat(20))
       cameraNode.addChild(livesLabel)
       
       
       
     }
      func marioHit(enemy: SKSpriteNode) {
         invincible = true
         let blinkTimes = 10.0
         let duration = 3.0
         let blinkAction = SKAction.customAction(withDuration: duration) { node, elapsedTime in
           let slice = duration / blinkTimes
           let remainder = Double(elapsedTime).truncatingRemainder(
             dividingBy: slice)
           node.isHidden = remainder > slice / 2
         }
         let setHidden = SKAction.run() { [weak self] in
           self?.panda.isHidden = false
           self?.invincible = false
         }
         panda.run(SKAction.sequence([blinkAction, setHidden]))
         
        // run(enemyCollisionSound)
         
       
         lives -= 1
       
       }
       func checkCollisions() {

         if invincible {
           return
         }
        
         var hitEnemies: [SKSpriteNode] = []
         enumerateChildNodes(withName: "spikes") { node, _ in
           let enemy = node as! SKSpriteNode
           if node.frame.insetBy(dx: 20, dy: 20).intersects(
             self.panda.frame) {
             hitEnemies.append(enemy)
           }
         }
         for enemy in hitEnemies {
           marioHit(enemy: enemy)
         }
       }
     func sceneTouched(touchLocation:CGPoint) {
       let actionJump : SKAction
       actionJump = SKAction.moveBy(x: 0, y: 350, duration: 0.7)
       let jumpSequence = SKAction.sequence([actionJump, actionJump.reversed()])
       panda.run(jumpSequence)
       
       }
       override func touchesBegan(_ touches: Set<UITouch>,
            with event: UIEvent?) {
          guard let touch = touches.first else {
            return
          }
          let touchLocation = touch.location(in: self)
          sceneTouched(touchLocation: touchLocation)
        }
      
     override func update(_ currentTime: TimeInterval) {
     
       if lastUpdateTime > 0 {
         dt = currentTime - lastUpdateTime
       } else {
         dt = 0
       }
       lastUpdateTime = currentTime
     
       
        move(sprite: panda, velocity: velocity)
       moveCamera()
       livesLabel.text = "Lives: \(lives)"
       checkCollisions()
     
        
       if lives <= 0 && !gameOver {
         gameOver = true
         print("You lose!")
         backgroundMusicPlayer.stop()
         
         // 1
       
       
     }
     
       }
     
    
     
    
*/
       
    
}
