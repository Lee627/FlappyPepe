//
//  GameScene.swift
//  FlappyShibe
//
//  Created by Tae Hwan Lee on 10/20/15.
//  Copyright (c) 2015 ChapmanCPSC370. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    // Everything that appears on the screen is considered to be a node
    var doge = SKSpriteNode();
    var background = SKSpriteNode();
    
    override func didMoveToView(view: SKView) {
        
        // Create texture
        let backgroundTexture = SKTexture(imageNamed: "Background.png");

        // Scrolling background
        let moveBackground = SKAction.moveByX(-backgroundTexture.size().width, y: 0, duration: 8);
        let replaceBackground = SKAction.moveByX(backgroundTexture.size().width, y: 0, duration: 0);
        let moveBackgroundForever = SKAction.repeatActionForever(SKAction.sequence([moveBackground, replaceBackground]));
        
        for var i: CGFloat = 0; i < 4; i++ {
            
            // Apply texture to that particular sprite node
            background = SKSpriteNode(texture: backgroundTexture);
            background.position = CGPoint(x: backgroundTexture.size().width / 2 + backgroundTexture.size().width * i, y: CGRectGetMidY(self.frame));
            
            // Set height equal to the height of the screen
            background.size.height = self.frame.height;
            background.runAction(moveBackgroundForever);
            self.addChild(background);
            
        }
        
        let dogeTexture = SKTexture(imageNamed: "Block.png");
        doge = SKSpriteNode(texture: dogeTexture);
        
        // Position is set to the middle of the screen
        doge.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame));
        self.addChild(doge);
        
        
    }
    

    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        
  
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
