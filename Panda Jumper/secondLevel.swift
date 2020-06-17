//
//  secondLevel.swift
//  Panda Jumper
//
//  Created by Nayna on 6/16/20.
//  Copyright © 2020 Nayna. All rights reserved.
//

import Foundation
import SpriteKit

class secondLevel : SKScene
{
    
    let panda = SKSpriteNode(imageNamed: "mypanda")
       let playableRect:CGRect
       let maxMovePerSecond = 100
       var dt:TimeInterval = 0
       var lastUpdateTime:TimeInterval = 0
       var velocity:CGPoint = .zero
       
       var lives = 3
       
       var coinEarned = 0
       var exitShown = false
       
       var lastChanged = 0
       
       
       let labelNode = SKLabelNode(fontNamed: "Chalkduster")
       
    
    
    override init(size: CGSize) {
         let maxAspectRatio : CGFloat = 16.0/9.0
                let playableHeight = size.height / maxAspectRatio
                let playableMargin = (size.height - playableHeight) / 2.0
                
                playableRect = CGRect(x:0.0,
                                      y:playableMargin,
                                      width: size.width,
                                      height: playableHeight)
        
        super.init(size: size)
    }

       required init(coder aDecoder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
       }
       
    
    override func didMove(to view: SKView) {
          let background = SKSpriteNode(imageNamed: "bakground")
              background.anchorPoint = .zero
              background.zPosition = -1
              addChild(background)
              //debugDrawPlayableArea()
              
              panda.position = CGPoint(x:100,
                                       y:150)
              panda.setScale(3.0)
        
        velocity = CGPoint(x:maxMovePerSecond, y:0)
         addChild(panda)
        
         
         spawnSpikes()
       
         spawnCoin()
      
        spawnPlatform()
        spawnCoin()
         
         
         
         labelNode.text = "Lives: \(lives)"
         labelNode.fontColor = .black
         labelNode.fontSize = 100
         labelNode.zPosition = 1300
         labelNode.position = CGPoint(x:300,
                                      y:500)
         addChild(labelNode)
         
    }
    
    
     //:= Override Update Function.
        
        override func update(_ currentTime: TimeInterval) {
            
               if(lastUpdateTime>0)
               {
                    dt = currentTime - lastUpdateTime
                }
                lastUpdateTime = currentTime
              boundsCheck()
            move(sprite: panda, velocity:velocity )
          collideSpike()
            labelNode.text = "Lives \(lives)"
       
            if lives<=0
            {
                let gameOverScene = gameOver(size: size, won: false)
                let reveal = SKTransition.flipHorizontal(withDuration: 1.0)
                view?.presentScene(gameOverScene,transition: reveal )
            }
            
            if coinEarned>=2 && !exitShown
            {
                spawnExit()
                exitShown = true
            }
           
          
        }
        

    
    func move(sprite:SKSpriteNode, velocity:CGPoint)
        {
            let amountToMove = CGPoint(x:velocity.x * CGFloat(dt),
                                       y:velocity.y * CGFloat(dt))
            sprite.position += amountToMove
            
            
            
            
            
    //       // run(SKAction.repeatForever(SKAction.run(){
    //         //   sprite.position.x += CGFloat(400)
    //        }))
            
            
            
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

    
    
    func boundsCheck()
    {
        let bottomLeft:CGPoint = CGPoint(x:0,
                                         y:playableRect.minY)
        let topRight:CGPoint = CGPoint(x:size.width,
                                       y:playableRect.maxY)
        if panda.position.x >= topRight.x
        {
            velocity.x = -velocity.x
        }
        if panda.position.x <= bottomLeft.x
        {
            velocity.x = abs(velocity.x)
            print("PANDA IS OUT VIA LEFT")
        }
        
    }
    
    
    
    //JUMP
    
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
        
        var platforms:[SKSpriteNode] = []
        enumerateChildNodes(withName: "platform"){
            node, _ in
            
            let platform = node as! SKSpriteNode
            platforms.append(platform)
        }
        
        
    
        let goUp = SKAction.moveBy(x: xVal, y: 200, duration: 0.5)
        let goDown = SKAction.moveBy(x: xVal, y: -200, duration: 0.5)
        
        let sequence:[SKAction] = [goUp, goDown]
        
        
        
        panda.run(SKAction.sequence(sequence))
        
    }
    
    
    func spawnSpikes()
    {
        let spike = SKSpriteNode(imageNamed: "spikes")
        spike.position = CGPoint(x: CGFloat.random(min: playableRect.minX + 150,
                                                   max:playableRect.maxX - 150),
                                y:130 )
       spike.setScale(2.0)
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
        y:100 )
        coin.name = "exit"
        coin.setScale(0.3)
        addChild(coin)
    }
    
    func spawnPlatform()
       {
           let coin = SKSpriteNode(imageNamed: "platform")
           coin.position = CGPoint(x: 200,
           y:200 )
           coin.name = "platform"
          let platform = SKSpriteNode(imageNamed: "platform")
        platform.position = CGPoint(x: 600,
        y:200 )
           addChild(coin)
        addChild(platform)
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
                self.coinEarned += 1
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
                
                let levelTwo = gameOver(size:self.size, won:true)
                let reveal = SKTransition.reveal(with: .up, duration: 1.0)
                self.view?.presentScene(levelTwo, transition: reveal)
            }
            
            
        }
        //reset()
    }
    
    func reset()
    {
        
             panda.position = CGPoint(x:100,
                                      y:150)
    }


}
