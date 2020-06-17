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
   let maxMovePerSecond = 100
     var lastTouchLocation: CGPoint?
  
     var invincible = false

    
    var lives = 3
     var coinCollected = 0
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
               background.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        background.position = CGPoint(x: size.width/2, y: size.height/1.4)
               background.zPosition = -1
               addChild(background)
         background.setScale(2)
               //debugDrawPlayableArea()
               
               panda.position = CGPoint(x:350,
                                        y:350)
               panda.setScale(5.0)
               
            //   velocity = CGPoint(x:maxMovePerSecond, y:0)
               addChild(panda)
        
        spawnSpikes()
                     spawnSpikes()
                     spawnCoin()
                     
       /*  let background = SKSpriteNode(imageNamed: "bakground")
            background.anchorPoint = CGPoint(x: 0.5, y: 0.5) // default
            background.position = CGPoint(x: size.width/2, y: size.height/1.4)
            background.setScale(2)
           // background.zRotation = CGFloat(M_PI) / 8
           background.zPosition = -1
           addChild(background)
            

           
           panda.position = CGPoint(x: 350, y: 400)
            panda.setScale(5)
        addChild(panda)*/
       
      // debugDrawPlayableArea()
go()
    
         livesLabel.text = "Lives: \(lives)"
              livesLabel.fontColor = .black
              livesLabel.fontSize = 100
              livesLabel.zPosition = 1300
              livesLabel.position = CGPoint(x:300,
                                           y:500)
              addChild(livesLabel)
        
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
        
        override func update(_ currentTime: TimeInterval) {
            
               if(lastUpdateTime>0)
               {
                    dt = currentTime - lastUpdateTime
                }
                lastUpdateTime = currentTime
              boundsCheckPanda()
            move(sprite: panda, velocity:velocity)
          collideSpike()
            livesLabel.text = "Lives \(lives)"
       /*
            if lives<=0
            {
                let gameOverScene = gameOver(size: size, won: false)
                let reveal = SKTransition.flipHorizontal(withDuration: 1.0)
                view?.presentScene(gameOverScene,transition: reveal )
            }
            
            if coinCollected>=1 && !exitShown
            {
                spawnExit()
                exitShown = true
            }
           
          */
        }
        
        
        func move(sprite:SKSpriteNode, velocity:CGPoint)
        {
            let amountToMove = CGPoint(x:velocity.x * CGFloat(dt),
                                       y:velocity.y * CGFloat(dt))
            sprite.position += amountToMove
             
            
        }
        
    func collideSpike()
    {
        var spikes:[SKSpriteNode] = []
        enumerateChildNodes(withName: "spike")
        {
            node, _ in
            let spike = node as! SKSpriteNode
            if spike.frame.insetBy(dx: 30, dy: 30).intersects(self.panda.frame.insetBy(dx: 20, dy: 20))
            {
                //self.lastChanged -= 1
                spikes.append(spike)
                spike.removeFromParent()
                self.lives -= 1
                self.panda.position = CGPoint(x:100,
                                                    y:150)
               
                
                
             
            }
            
           
        }
        for spike in spikes
        {
            spike.removeFromParent()
             self.spawnSpikes()
            
        }
       
        enumerateChildNodes(withName: "coin")
        {node ,_ in
                     
            let coin = node as! SKSpriteNode
                if coin.frame.intersects(self.panda.frame)
            {
                self.coinCollected += 1
                coin.removeFromParent()
            }
        
        }
       
        
        enumerateChildNodes(withName: "exit")
        {
            node, _ in
            
            let exit = node as! SKSpriteNode
            if exit.frame.insetBy(dx: 50   , dy: 50).intersects(self.panda.frame)
            {
                self.panda.removeFromParent()
                
                let levelTwo = secondLevel(size:self.size)
                let reveal = SKTransition.reveal(with: .up, duration: 1.0)
                self.view?.presentScene(levelTwo, transition: reveal)
            }
            
            
        }
        //reset()
    }
    
   override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       
       jump(panda: panda, velocity: velocity)
       print("TOUCH HAPPENED")
   }
   
    
    
    func jump(panda:SKSpriteNode, velocity:CGPoint)
       {
           var xVal:CGFloat = 100.0
           if velocity.x <= 0
           {
               print("Going Right")
               xVal = -xVal
           }
           else
           {
               xVal = CGFloat(abs(xVal))
               print("Going Left")
           }
           
       
           let goUp = SKAction.moveBy(x: xVal, y: 600, duration: 0.5)
           let goDown = SKAction.moveBy(x: xVal, y: -600, duration: 0.5)
           
           let sequence:[SKAction] = [goUp, goDown]
           
           
           
           panda.run(SKAction.sequence(sequence))
           
       }
    

   func spawnSpikes()
   {
       let spike = SKSpriteNode(imageNamed: "spikes")
       spike.position = CGPoint(x: CGFloat.random(min: playableRect.minX + 150,
                                                  max:playableRect.maxX - 150),
                               y:300 )
      spike.setScale(3.0)
       spike.name = "spike"
       addChild(spike)
       
   }
   
   func spawnCoin()
   {
       let coin = SKSpriteNode(imageNamed: "coin")
       coin.position = CGPoint(x: CGFloat.random(min: playableRect.minX + 150,
                          max:playableRect.maxX - 150),
       y:300 )
       coin.name = "coin"
       coin.setScale(0.3)
       addChild(coin)
   }
   
   func spawnExit()
   {
       let coin = SKSpriteNode(imageNamed: "exit")
       coin.position = CGPoint(x: CGFloat.random(min: playableRect.minX + 150,
                          max:playableRect.maxX - 150),
       y:300 )
       coin.name = "exit"
       coin.setScale(0.3)
       addChild(coin)
   }
   
   
    
    
    
    func go(){

    
        let moveRight = SKAction.move(to: CGPoint(x: playableRect.width, y:  320), duration: 5)

        let RPL = SKAction.scaleX(to: panda.xScale * -1, duration: 0)

        let moveLeft = SKAction.move(to: CGPoint(x: 0, y:  320), duration: 5)

        let RPR = SKAction.scaleX(to: panda.xScale , duration: 0)



panda.run(SKAction.repeatForever(SKAction.sequence([moveRight, RPL, moveLeft, RPR])))

    }
    
        func reset()
           {
               
                    panda.position = CGPoint(x:100,
                                             y:150)
           }

   func sceneTouched(touchLocation:CGPoint) {
    //movePandaToward(location: touchLocation)
   }
   
    
 
             

       }

       
    
