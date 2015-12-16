//
//  GameScene.swift
//  FlappyShibe
//
//  Created by Tae Hwan Lee on 10/20/15.
//  Copyright (c) 2015 ChapmanCPSC370. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    // MARK: Global variables
    
    var score = 0;
    
    // Everything that appears on the screen is considered to be a node
    var instructionLabel = SKLabelNode();
    var pButton = SKSpriteNode();
    var scoreLabel = SKLabelNode();
    var gameoverLabel = SKLabelNode();
    var doge = SKSpriteNode();
    var background = SKSpriteNode();
    var ground = SKSpriteNode();
    var pipe1 = SKSpriteNode();
    var pipe2 = SKSpriteNode();
    var movingObjects = SKSpriteNode();
    var labelContainer = SKSpriteNode();
    enum ColliderType: UInt32 {
        
        case Doge = 1;
        case Object = 2;
        case Gap = 4;
        
    }
    
    var gameOver = false;
    
    // MARK: Functions to create Sprites
    
    func createGround() {
        
        let backgroundTexture = SKTexture(imageNamed: "Background.png");
        background = SKSpriteNode(texture: backgroundTexture);
        background.position = CGPoint(x: self.size.width / 2, y: self.size.height / 1.9);
        background.zPosition = -20;
        movingObjects.addChild(background);
        
        // Scrolling ground
        let groundTexture = SKTexture(imageNamed: "Ground.png");
        let moveLeft = SKAction.moveByX(-groundTexture.size().width, y: 0, duration: 6);
        let moveReset = SKAction.moveByX(groundTexture.size().width, y: 0, duration: 0);
        let moveGroundForever = SKAction.repeatActionForever(SKAction.sequence([moveLeft, moveReset]));
        
        for (var i: CGFloat = 0; i < 3; ++i) {
            ground = SKSpriteNode(texture: groundTexture);
            ground.position = CGPoint(x: groundTexture.size().width / 2 + groundTexture.size().width * i, y: 57);
            ground.zPosition = 20;
            ground.runAction(moveGroundForever);
            movingObjects.addChild(ground);
        }
        
        // Ground physicsBody
        let groundPhysics = SKNode();
        groundPhysics.position = CGPointMake(0, 112);
        groundPhysics.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(self.frame.size.width, 1));
        groundPhysics.physicsBody!.dynamic = false;
        
        groundPhysics.physicsBody!.categoryBitMask = ColliderType.Object.rawValue;
        groundPhysics.physicsBody!.contactTestBitMask = ColliderType.Object.rawValue;
        groundPhysics.physicsBody!.collisionBitMask = ColliderType.Object.rawValue;
        
        self.addChild(groundPhysics);
    }

    func createPipes() {
        
        // Gap between the two pipes
        let gapHeight = doge.size.height * 3.6;
        
        // Random pipe gap locations
        let movementAmount = arc4random() % UInt32(self.frame.size.height / 2);
        let pipeOffset = CGFloat(movementAmount) - self.frame.size.height / 8 - 38;
        
        // Making pipes appear and disappear
        let movePipes = SKAction.moveByX(-self.frame.size.width * 2, y: 0, duration: NSTimeInterval(self.frame.size.width / 50));
        let removePipes = SKAction.removeFromParent();
        let moveAndRemovePipes = SKAction.sequence([movePipes, removePipes]);
        
        let pipe1Texture = SKTexture(imageNamed: "PipeDown.png");
        let pipe1 = SKSpriteNode(texture: pipe1Texture);
        pipe1.position = CGPoint(x: CGRectGetMidX(self.frame) + self.frame.size.width/2, y: CGRectGetMidY(self.frame) + pipe1Texture.size().height/2 + gapHeight / 2 + pipeOffset);
        pipe1.zPosition = -10;
        pipe1.runAction(moveAndRemovePipes);
        
        pipe1.physicsBody = SKPhysicsBody(rectangleOfSize: pipe1Texture.size());
        pipe1.physicsBody!.dynamic = false;
        pipe1.physicsBody!.categoryBitMask = ColliderType.Object.rawValue;
        pipe1.physicsBody!.contactTestBitMask = ColliderType.Object.rawValue;
        pipe1.physicsBody!.collisionBitMask = ColliderType.Object.rawValue;
        
        movingObjects.addChild(pipe1);
        
        let pipe2Texture = SKTexture(imageNamed: "PipeUp.png");
        let pipe2 = SKSpriteNode(texture: pipe2Texture);
        pipe2.position = CGPoint(x: CGRectGetMidX(self.frame) + self.frame.size.width/2, y: CGRectGetMidY(self.frame) - pipe2Texture.size().height/2 - gapHeight / 2 + pipeOffset);
        pipe2.zPosition = -10;
        pipe2.runAction(moveAndRemovePipes);
        
        pipe2.physicsBody = SKPhysicsBody(rectangleOfSize: pipe2Texture.size());
        pipe2.physicsBody!.dynamic = false;
        pipe2.physicsBody!.categoryBitMask = ColliderType.Object.rawValue;
        pipe2.physicsBody!.contactTestBitMask = ColliderType.Object.rawValue;
        pipe2.physicsBody!.collisionBitMask = ColliderType.Object.rawValue;
        
        movingObjects.addChild(pipe2);
        
        // PhysicsBody for the gap between the two pipes -- used for scoring
        let gap = SKNode()
        gap.position = CGPoint(x: CGRectGetMidX(self.frame) + self.frame.size.width/2 + pipe1Texture.size().width / 2, y: CGRectGetMidY(self.frame) + pipeOffset);
        gap.runAction(moveAndRemovePipes);
        gap.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(pipe1.size.width, gapHeight));
        gap.physicsBody!.dynamic = false;
        
        gap.physicsBody!.categoryBitMask = ColliderType.Gap.rawValue;
        gap.physicsBody!.contactTestBitMask = ColliderType.Doge.rawValue;
        gap.physicsBody!.collisionBitMask = ColliderType.Gap.rawValue;
        
        movingObjects.addChild(gap);
    }
    
    func createScoreLabel() {
        
        // Display score
        scoreLabel.fontName = "MrsKate";
        scoreLabel.fontSize = 60;
        scoreLabel.text = "0";
        scoreLabel.position = CGPointMake(CGRectGetMidX(self.frame), self.frame.size.height - 80);
        scoreLabel.zPosition = 100;
        self.addChild(scoreLabel);
    }
    
    func createButton() {
        
        pButton = SKSpriteNode(imageNamed: "Button.png");
        pButton.setScale(2.5);
        pButton.position = CGPointMake(CGRectGetMidX(self.frame) - 170, self.frame.size.height - 50);
        pButton.zPosition = 100;
        pButton.name = "pauseButton";
        self.addChild(pButton);
    }
    
    func createInstLabel() {
        
        instructionLabel.fontName = "MrsKate";
        instructionLabel.fontSize = 30;
        instructionLabel.text = "Tap to fly!";
        instructionLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        self.addChild(instructionLabel);
    }
    
    override func didMoveToView(view: SKView) {
        
        self.view?.paused = true;
        self.physicsWorld.contactDelegate = self;
        
        self.addChild(movingObjects);
        self.addChild(labelContainer);
        
        createGround();
        createScoreLabel();
        createButton();
        createInstLabel();

        let dogeTexture1 = SKTexture(imageNamed: "Doge1.png");
        let dogeTexture2 = SKTexture(imageNamed: "Doge2.png");
        
        // Animating Sprites
        let animation = SKAction.animateWithTextures([dogeTexture1, dogeTexture2], timePerFrame: 0.1);
        let dogeRepeatAnimation = SKAction.repeatActionForever(animation);
        
        doge = SKSpriteNode(texture: dogeTexture1);
        
        // Position is set to the middle of the screen
        doge.position = CGPoint(x: CGRectGetMidX(self.frame) - 100, y: CGRectGetMidY(self.frame) + 200);
        doge.runAction(dogeRepeatAnimation);
        
        // Add physics simulation to a node
        doge.physicsBody = SKPhysicsBody(circleOfRadius: dogeTexture1.size().height / 2);
        
        // Apply gravity and collisions with other objects
        doge.physicsBody!.dynamic = true;
        
        // Collision detection
        doge.physicsBody!.categoryBitMask = ColliderType.Doge.rawValue;
        doge.physicsBody!.contactTestBitMask = ColliderType.Object.rawValue;
        doge.physicsBody!.collisionBitMask = ColliderType.Object.rawValue;
        
        doge.physicsBody!.allowsRotation = false;
        
        self.addChild(doge);
        
        // Executed every 3 seconds
        let delay = SKAction.waitForDuration(NSTimeInterval(3));
        let spawn = SKAction.runBlock({()in self.createPipes()})
        let spawnAndDelay = SKAction.repeatActionForever(SKAction.sequence([spawn, delay]));
        runAction(spawnAndDelay);
    }
    
    // MARK: Gameplay
    
    func didBeginContact(contact: SKPhysicsContact) {
        
        // Check for the category types of the objects that are colliding
        if contact.bodyA.categoryBitMask == ColliderType.Gap.rawValue || contact.bodyB.categoryBitMask == ColliderType.Gap.rawValue {
            score++;
            scoreLabel.text = String(score);
            
        } else {
            
            if gameOver == false {
                gameOver = true;
                self.speed = 0;
                gameoverLabel.fontName = "MrsKate";
                gameoverLabel.fontSize = 30;
                gameoverLabel.text = "Game Over! Tap to play again";
                gameoverLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
                labelContainer.addChild(gameoverLabel);
            }
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        instructionLabel.hidden = true;
        self.view?.paused = false;
        
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self);
            if (pButton.containsPoint(location)) {
                if (self.view?.paused == true) {
                    self.view?.paused = false;
                }
                else if (self.view?.paused == false) {
                    self.view?.paused = true;
                }
            }
        }
        
        if (gameOver == false) {
            doge.physicsBody!.velocity = CGVectorMake(0, 0);
            doge.physicsBody!.applyImpulse(CGVectorMake(0, 43));
        } else {
            score = 0;
            scoreLabel.text = "0";
            doge.position = CGPointMake(CGRectGetMidX(self.frame) - 100, CGRectGetMidY(self.frame) + 200);
            doge.physicsBody!.velocity = CGVectorMake(0, 0);
            movingObjects.removeAllChildren();
            createGround();
            self.speed = 1;
            gameOver = false;
            labelContainer.removeAllChildren();
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
