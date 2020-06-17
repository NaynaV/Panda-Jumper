//
//  gameOver.swift
//  Panda Jumper
//
//  Created by Nayna on 6/16/20.
//  Copyright © 2020 Nayna. All rights reserved.
//

import Foundation
import SpriteKit
class gameOver:SKScene
{
    
    let won:Bool
    init(size: CGSize, won: Bool) {
    self.won = won
    super.init(size: size)
    }

    required init(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        
        let label = SKLabelNode(fontNamed: "Chalkduster");
        label.fontSize = 100
        label.color = .white
        label.position = CGPoint(x:size.width/2,
                                 y:size.height/2)
        if(won)
        {
            label.text = "YOU WIN"
        }
        else
        {
            label.text = "YOU LOSE"
        }
        addChild(label)
    }
}
