//
//  GameScene.swift
//  FlappyShibe
//
//  Created by Tae Hwan Lee on 10/20/15.
//  Copyright (c) 2015 ChapmanCPSC370. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var score = 0;
    
    // Everything that appears on the screen is considered to be a node
    var scoreLabel = SKLabelNode();
    var doge = SKSpriteNode();
    var background = SKSpriteNode();
    var pipe1 = SKSpriteNode();
    var pipe2 = SKSpriteNode();
    enum ColliderType: UInt32 {
        
        case Doge = 1;
        case Object = 2;
        case Gap = 4;
        
    }
    
    var gameOver = false;
    
    override func didMoveToView(view: SKView) {
        
        self.physicsWorld.contactDelegate = self;
        
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
        
        // Display score
        scoreLabel.fontName = "Helvetica";
        scoreLabel.fontSize = 60;
        scoreLabel.text = "0";
        scoreLabel.position = CGPointMake(CGRectGetMidX(self.frame), self.frame.size.height - 70);
        self.addChild(scoreLabel);
        
        let dogeTexture1 = SKTexture(imageNamed: "Doge1.png");
        let dogeTexture2 = SKTexture(imageNamed: "Doge2.png");
        
        // Animating Sprites
        let animation = SKAction.animateWithTextures([dogeTexture1, dogeTexture2], timePerFrame: 0.1);
        let dogeRepeatAnimation = SKAction.repeatActionForever(animation);
        
        doge = SKSpriteNode(texture: dogeTexture1);
        
        // Position is set to the middle of the screen
        doge.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame));
        doge.runAction(dogeRepeatAnimation);
        
        // Add physics simulation to a node
        doge.physicsBody = SKPhysicsBody(circleOfRadius: dogeTexture1.size().height / 2);
        
        // Apply gravity and collisions with other objects
        doge.physicsBody!.dynamic = true;
        
        // Collision detection
        doge.physicsBody!.categoryBitMask = ColliderType.Doge.rawValue;
        doge.physicsBody!.contactTestBitMask = ColliderType.Object.rawValue;
        doge.physicsBody!.collisionBitMask = ColliderType.Object.rawValue;
        
        self.addChild(doge);
        
        
        // Ground physicsBody
        var ground = SKNode();
        ground.position = CGPointMake(0, 0);
        ground.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(self.frame.size.width, 1));
        ground.physicsBody!.dynamic = false;
        
        ground.physicsBody!.categoryBitMask = ColliderType.Object.rawValue;
        ground.physicsBody!.contactTestBitMask = ColliderType.Object.rawValue;
        ground.physicsBody!.collisionBitMask = ColliderType.Object.rawValue;
        
        self.addChild(ground);
        
        // Executed every 3 seconds
        _ = NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: Selector("makePipes"), userInfo: nil, repeats: true);

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
        
        pipe1.physicsBody = SKPhysicsBody(rectangleOfSize: pipe1Texture.size());
        pipe1.physicsBody!.dynamic = false;
        pipe1.physicsBody!.categoryBitMask = ColliderType.Object.rawValue;
        pipe1.physicsBody!.contactTestBitMask = ColliderType.Object.rawValue;
        pipe1.physicsBody!.collisionBitMask = ColliderType.Object.rawValue;

        self.addChild(pipe1);
        
        var pipe2Texture = SKTexture(imageNamed: "Pipe2.png");
        var pipe2 = SKSpriteNode(texture: pipe2Texture);
        pipe2.position = CGPoint(x: CGRectGetMidX(self.frame) + self.frame.size.width, y: CGRectGetMidY(self.frame) - pipe2Texture.size().height/2 - gapHeight / 2 + pipeOffset);
        pipe2.runAction(moveAndRemovePipes);
        
        pipe2.physicsBody = SKPhysicsBody(rectangleOfSize: pipe2Texture.size());
        pipe2.physicsBody!.dynamic = false;
        pipe2.physicsBody!.categoryBitMask = ColliderType.Object.rawValue;
        pipe2.physicsBody!.contactTestBitMask = ColliderType.Object.rawValue;
        pipe2.physicsBody!.collisionBitMask = ColliderType.Object.rawValue;
        
        self.addChild(pipe2);
        
        // PhysicsBody for the gap between the two pipes -- used for scoring
        let gap = SKNode()
        gap.position = CGPoint(x: CGRectGetMidX(self.frame) + self.frame.size.width, y: CGRectGetMidY(self.frame) + pipeOffset);
        gap.runAction(moveAndRemovePipes);
        gap.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(pipe1.size.width, gapHeight));
        gap.physicsBody!.dynamic = false;
        
        gap.physicsBody!.categoryBitMask = ColliderType.Gap.rawValue;
        gap.physicsBody!.contactTestBitMask = ColliderType.Doge.rawValue;
        gap.physicsBody!.collisionBitMask = ColliderType.Gap.rawValue;
        
        self.addChild(gap);
        
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        // Check for the category types of the objects that are colliding
        if contact.bodyA.categoryBitMask == ColliderType.Gap.rawValue || contact.bodyB.categoryBitMask == ColliderType.Gap.rawValue {
            
            score++;
            
            scoreLabel.text = String(score);
            
        } else {
            
            if gameOver == false {
                
                gameOver = true;
                
                self.speed = 0;
            }
        }
    }
    

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        if (gameOver == false) {
            doge.physicsBody!.velocity = CGVectorMake(0, 0);
            doge.physicsBody!.applyImpulse(CGVectorMake(0, 45));
        }
    
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
