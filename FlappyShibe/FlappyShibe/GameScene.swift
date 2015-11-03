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
    var pipe1 = SKSpriteNode();
    var pipe2 = SKSpriteNode();
    
    override func didMoveToView(view: SKView) {
        
        // Create texture
        let backgroundTexture = SKTexture(imageNamed: "Background.png");

        // Scrolling background
        let moveBackground = SKAction.moveByX(-backgroundTexture.size().width, y: 0, duration: 8);
        let replaceBackground = SKAction.moveByX(backgroundTexture.size().width, y: 0, duration: 0);
        let moveBackgroundForever = SKAction.repeatActionForever(SKAction.sequence([moveBackground, replaceBackground]));
        
        for var i: CGFloat = 0; i < 3; i++ {
            
            // Apply texture to that particular sprite node
            background = SKSpriteNode(texture: backgroundTexture);
            background.position = CGPoint(x: backgroundTexture.size().width / 2 + backgroundTexture.size().width * i, y: CGRectGetMidY(self.frame));
            
            // Set height equal to the height of the screen
            background.size.height = self.frame.height;
            background.zPosition = -5;
            background.runAction(moveBackgroundForever);
            self.addChild(background);
            
        }
        
        let dogeTexture = SKTexture(imageNamed: "Block.png");
        doge = SKSpriteNode(texture: dogeTexture);
        
        // Position is set to the middle of the screen
        doge.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame));
        
        // Add physics simulation to a node
        doge.physicsBody = SKPhysicsBody(circleOfRadius: dogeTexture.size().height / 2);
        
        // Apply gravity and collisions with other objects
        doge.physicsBody!.dynamic = true;
        
        self.addChild(doge);
        
        
        // Ground physicsBody
        var ground = SKNode();
        ground.position = CGPointMake(0, 0);
        ground.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(self.frame.size.width, 1));
        ground.physicsBody!.dynamic = false;
        
        self.addChild(ground);
        
        // Executed every 3 seconds
        _ = NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: Selector("makePipes"), userInfo: nil, repeats: true)

    }
    
    func makePipes() {
        
        // Gap between the two pipes
        let gapHeight = doge.size.height * 4;
        
        // Random pipe gap locations
        let movementAmount = arc4random() % UInt32(self.frame.size.height / 2);
        let pipeOffset = CGFloat(movementAmount) - self.frame.size.height / 4;
        
        // Making pipes appear and disappear
        let movePipes = SKAction.moveByX(-self.frame.size.width * 2, y: 0, duration: NSTimeInterval(self.frame.size.width / 100));
        let removePipes = SKAction.removeFromParent();
        let moveAndRemovePipes = SKAction.sequence([movePipes, removePipes]);
        
        var pipe1Texture = SKTexture(imageNamed: "pipe1.png");
        var pipe1 = SKSpriteNode(texture: pipe1Texture);
        pipe1.position = CGPoint(x: CGRectGetMidX(self.frame) + self.frame.size.width, y: CGRectGetMidY(self.frame) + pipe1Texture.size().height/2 + gapHeight / 2 + pipeOffset);
        pipe1.runAction(moveAndRemovePipes);

        self.addChild(pipe1);
        
        var pipe2Texture = SKTexture(imageNamed: "Pipe2.png");
        var pipe2 = SKSpriteNode(texture: pipe2Texture);
        pipe2.position = CGPoint(x: CGRectGetMidX(self.frame) + self.frame.size.width, y: CGRectGetMidY(self.frame) - pipe2Texture.size().height/2 - gapHeight / 2 + pipeOffset);
        pipe2.runAction(moveAndRemovePipes);
        
        self.addChild(pipe2);
        
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       
        doge.physicsBody!.velocity = CGVectorMake(0, 0);
        doge.physicsBody!.applyImpulse(CGVectorMake(0, 50));
        
  
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
