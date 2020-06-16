//
//  demo.swift
//  Panda Jumper
//
//  Created by Nayna on 6/16/20.
//  Copyright © 2020 Nayna. All rights reserved.
//
/*
import Foundation
 let panda = SKSpriteNode(imageNamed: "panda")

       var lastUpdateTime: TimeInterval = 0

       var dt: TimeInterval = 0

       let zombieMovePointsPerSec: CGFloat = 480.0

       var velocity = CGPoint.zero

       let playableRect: CGRect

     

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

       let background = SKSpriteNode(imageNamed: "background")

        background.anchorPoint = CGPoint(x: 0.5, y: 0.5) // default

        background.position = CGPoint(x: size.width/2, y: size.height/1.7)

       // background.zRotation = CGFloat(M_PI) / 8

       background.zPosition = -1

       addChild(background)

        

       let mySize = background.size

       print("Size: \(mySize)")

    

        panda.setScale(5)

       panda.position = CGPoint(x: 400, y: 320)

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

           boundsCheckZombie()

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

       func moveZombieToward(location: CGPoint) {

        let offset = CGPoint(x: location.x - panda.position.x,

        y: location.y - panda.position.y)

           let length = sqrt(

           Double(offset.x * offset.x + offset.y * offset.y))

           let direction = CGPoint(x: offset.x / CGFloat(length),

            y: offset.y / CGFloat(length))

           velocity = CGPoint(x: direction.x * zombieMovePointsPerSec, y: direction.y * zombieMovePointsPerSec)

       }

       func sceneTouched(touchLocation:CGPoint) {

        

       }

       override func touchesBegan(_ touches: Set<UITouch>,

        with event: UIEvent?) {

        guard let touch = touches.first else {

        return

        }

        let touchLocation = touch.location(in: self)

        sceneTouched(touchLocation: touchLocation)

        jump()

       }

    func jump(){

        panda.removeAllActions()

        let jumpUp = SKAction.moveBy(x: 0, y: 50, duration: 0.3)

        let fallBack = SKAction.moveBy(x: 0, y: -50, duration: 0.3)

            // making the player jump

        panda.run(SKAction.sequence([jumpUp, fallBack]))

    }

       override func touchesMoved(_ touches: Set<UITouch>,

        with event: UIEvent?) {

        guard let touch = touches.first else {

        return

        }

        let touchLocation = touch.location(in: self)

        sceneTouched(touchLocation: touchLocation)

       }

       func boundsCheckZombie() {

       let bottomLeft = CGPoint(x: 0, y: playableRect.minY)

        let topRight = CGPoint(x: size.width, y: playableRect.maxY)



        if panda.position.x <= bottomLeft.x {

        panda.position.x = bottomLeft.x

        velocity.x = -velocity.x

        rotate(sprite: panda, direction: velocity)

        }

        if panda.position.x >= topRight.x {

        panda.position.x = topRight.x

        velocity.x = -velocity.x

        rotate(sprite: panda, direction: velocity)

        }

        if panda.position.y <= bottomLeft.y {

        panda.position.y = bottomLeft.y

        velocity.y = -velocity.y

        rotate(sprite: panda, direction: velocity)

        }

        if panda.position.y >= topRight.y {

        panda.position.y = topRight.y

        velocity.y = -velocity.y

        rotate(sprite: panda, direction: velocity)

        }

       }

       func rotate(sprite: SKSpriteNode, direction: CGPoint) {

       sprite.xScale = sprite.xScale * -1;

       }

}
*/
