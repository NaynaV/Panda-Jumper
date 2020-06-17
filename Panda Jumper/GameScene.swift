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
    let spikes = SKSpriteNode(imageNamed: "spikes")
     var lastUpdateTime: TimeInterval = 0
     var dt: TimeInterval = 0
     let pandaMovePointsPerSec: CGFloat = 480.0
     var velocity = CGPoint.zero
     let playableRect: CGRect
    var coinCollected = 0
     var lastTouchLocation: CGPoint?
    // let pandaMove: SKAction
  //  let pandaAnimation: SKAction
    
    // let jumpSound: SKAction = SKAction.playSoundFileNamed(
      // "jumpSound.wav", waitForCompletion: false)
    // let enemyCollisionSound: SKAction = SKAction.playSoundFileNamed(
    //   "loselifeSound.wav", waitForCompletion: false)
     var invincible = false

    
    var lives = 5
      let livesLabel = SKLabelNode(fontNamed: "Chalkduster")
    
      let scoresLabel = SKLabelNode(fontNamed: "Chalkduster")
      let levelLabel = SKLabelNode(fontNamed: "Chalkduster")
   
     var gameOver = false
     let cameraNode = SKCameraNode()
     let cameraMovePointsPerSec: CGFloat = 200.0

    

       
    
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
       
       panda.position = CGPoint(x: 350, y: 400)
        panda.setScale(5)
        
        run(SKAction.repeatForever(SKAction.sequence([SKAction.run() { [weak self] in
                          self?.spawnEnemy()
                        },SKAction.wait(forDuration: 3.0)])))

        spawnCat()
          spawnCat2()
        
        
        //spikes.setScale(3)

          //     spikes.position = CGPoint(x: 800, y: 310)

            //   spikes.name = "spikes"
   
       addChild(panda)
      //  addChild(spikes)
       debugDrawPlayableArea()
        go()
     //   spawnCoin()
      //  spawnEnemy()
        
        livesLabel.text = "Lives:\(lives)"
               livesLabel.fontColor = SKColor.black
               livesLabel.fontSize = 100
               livesLabel.zPosition = 100
               livesLabel.horizontalAlignmentMode = .left
               livesLabel.verticalAlignmentMode = .bottom
              livesLabel.position = CGPoint(x: 100, y: 1220)
               addChild(livesLabel)
        
     }
    
    
    
    
    
    func spawnEnemy() {
         let enemy = SKSpriteNode(imageNamed: "spikes")
         enemy.position = CGPoint(
           x: playableRect.maxX + enemy.size.width/2,
           y: playableRect.minY + 100)
         enemy.zPosition = 50
        enemy.setScale(5)
         enemy.name = "enemy"
         addChild(enemy)
         
         let actionMove =
           SKAction.moveBy(x: -(size.width + enemy.size.width), y: 5, duration: 2.0)
         let actionRemove = SKAction.removeFromParent()
        // enemy.run(SKAction.sequence([actionMove, actionRemove]))
       }
       
       func spawnCat() {
         // 1
         let coin = SKSpriteNode(imageNamed: "coin2")
         coin.name = "coin"
         coin.position = CGPoint(
           x: playableRect.minX + 700,
           y: playableRect.minY + 100)
         coin.zPosition = 50
         coin.setScale(0)
         addChild(coin)
         // 2
         let appear = SKAction.scale(to: 1.0, duration: 0.2)

         let actions = [appear]
         coin.run(SKAction.sequence(actions))
       }
       func spawnExit() {
         // 1
         let exit = SKSpriteNode(imageNamed: "exit")
         exit.name = "exit"
         exit.position = CGPoint(
           x: playableRect.maxX - 150,
           y: playableRect.minY + 100)
         exit.zPosition = 50
         exit.setScale(5)
         addChild(exit)
         // 2
         let appear = SKAction.scale(to: 1.0, duration: 0.5)

         let actions = [appear]
         exit.run(SKAction.sequence(actions))
       }
       
       func spawnCat2() {
         // 1
         let coin = SKSpriteNode(imageNamed: "coin2")
         coin.name = "coin"
         coin.position = CGPoint(
           x: playableRect.minX + 1300,
           y: playableRect.minY + 100)
         coin.zPosition = 50
         coin.setScale(5)
         addChild(coin)
         // 2
         let appear = SKAction.scale(to: 1.0, duration: 0.5)

         let actions = [appear]
         coin.run(SKAction.sequence(actions))
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
        
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    
    func touchDown(atPoint pos: CGPoint) {
            print("jump")
            jump()
        }

        func jump() {
           // playBackgroundMusic(filename: "jumpSound.wav")
            let jumpUpAction = SKAction.moveBy(x: 0, y: 800, duration: 0.3)
            // move down 20
            let jumpDownAction = SKAction.moveBy(x: 0, y: -800, duration: 0.6)
            // sequence of move yup then down
            let jumpSequence = SKAction.sequence([jumpUpAction, jumpDownAction])

            // make player run sequence
            panda.run(jumpSequence)
   
        }

        override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
            for t in touches { self.touchUp(atPoint: t.location(in: self)) }
        }

        func touchUp(atPoint pos: CGPoint) {
            panda.texture = SKTexture(imageNamed: "mypanda")
           // backgroundMusicPlayer.stop()
            //playBackgroundMusic(filename: "BgSound.wav")
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
    }
    
    
    
    func moveTrain() {
    
      var trainCount = 0
      var targetPosition = panda.position
      
      enumerateChildNodes(withName: "train") { node, stop in
        trainCount += 1
        if !node.hasActions() {
          let actionDuration = 0.3
          let offset = targetPosition - node.position
          let direction = offset.normalized()
          let amountToMovePerSec = direction * self.pandaMovePointsPerSec
          let amountToMove = amountToMovePerSec * CGFloat(actionDuration)
          let moveAction = SKAction.moveBy(x: amountToMove.x, y: amountToMove.y, duration: actionDuration)
          node.run(moveAction)
        }
        targetPosition = node.position
      }
      
      if trainCount >= 2 && !gameOver {
        gameOver = true
        print("You win!")
      //  backgroundMusicPlayer.stop()
        
        // 1
       //   let gameOverScene = GameOverScene(size: size, won: true, score: coinCollected)
      //  gameOverScene.scaleMode = scaleMode
        // 2
      //
        let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
        // 3
        //view?.presentScene(gameOverScene, transition: reveal)
      }
      
    }
    
    func loseCats() {
      // 1
      var loseCount = 0
      enumerateChildNodes(withName: "train") { node, stop in
        // 2
        var randomSpot = node.position
        randomSpot.x += CGFloat.random(min: -100, max: 100)
        randomSpot.y += CGFloat.random(min: -100, max: 100)
        // 3
        node.name = ""
        node.run(
          SKAction.sequence([
            SKAction.group([
              SKAction.rotate(byAngle: π*4, duration: 1.0),
              SKAction.move(to: randomSpot, duration: 1.0),
              SKAction.scale(to: 0, duration: 1.0)
              ]),
            SKAction.removeFromParent()
          ]))
        // 4
        loseCount += 1
        if loseCount >= 2 {
          stop[0] = true
        }
      }
    }
    
    
    func pandaHit(enemy: SKSpriteNode) {

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

         

       

         lives -= 1

       

       }

       

       func pandaCollect(coin: SKSpriteNode) {

           coin.removeFromParent()

           coinCollected += 1

       

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

           pandaHit(enemy: enemy)

         }

           

           var hitCoins: [SKSpriteNode] = []

           enumerateChildNodes(withName: "coin") { node, _ in

             let coin = node as! SKSpriteNode

               

               if node.frame.insetBy(dx: 20, dy: 20).intersects(

                 self.panda.frame) {

                 hitCoins.append(coin)

               }

             }

             for coin in hitCoins {

               pandaCollect(coin: coin)

             }

           

             

       }

       
    
    
    
    
    /*
    
    func pandaHit(coin: SKSpriteNode) {
         coin.name = "train"
         coin.removeAllActions()
         coin.setScale(1.0)
         coin.zRotation = 0
         
         let turnGreen = SKAction.colorize(with: SKColor.green, colorBlendFactor: 1.0, duration: 0.2)
         coin.run(turnGreen)
           coin.isHidden = true
         coinCollected+=1
        // run(CollisionSound)
       }
       
       func pandaHit(enemy: SKSpriteNode) {
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
           
           loseCats()
           lives -= 1
         }
       
       func checkCollisions() {
         var hitCats: [SKSpriteNode] = []
         enumerateChildNodes(withName: "cat") { node, _ in
           let cat = node as! SKSpriteNode
           if cat.frame.intersects(self.panda.frame) {
             hitCats.append(cat)
           }
         }
         
         for cat in hitCats {
               pandaHit(cat: cat)
             }
             
         if invincible {
           return
         }
        
         var hitEnemies: [SKSpriteNode] = []
         enumerateChildNodes(withName: "enemy") { node, _ in
           let enemy = node as! SKSpriteNode
           if node.frame.insetBy(dx: 10, dy: 10).intersects(
             self.panda.frame) {
             hitEnemies.append(enemy)
           }
         }
         for enemy in hitEnemies {
           pandaHit(enemy: enemy)
         }
       }
       
       override func didEvaluateActions() {
         checkCollisions()
       }
      
       func startpandaAnimation() {
         if panda.action(forKey: "animation") == nil {
           panda.run(
             SKAction.repeatForever(pandaAnimation),
             withKey: "animation")
         }
       }

       func stoppandaAnimation() {
         panda.removeAction(forKey: "animation")
       }
        */
       
  
       
    
}
