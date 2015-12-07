//
//  GameViewController.swift
//  FlappyShibe
//
//  Created by Tae Hwan Lee on 10/20/15.
//  Copyright (c) 2015 ChapmanCPSC370. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
    
    //Variable to store if the user touched the screen yet to start the game
    var userStarted = false

    override func viewDidLoad() {
        super.viewDidLoad()

        if let scene = GameScene(fileNamed:"GameScene") {
            // Configure the view.
            let skView = self.view as! SKView
            skView.showsFPS = true
            skView.showsNodeCount = true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill
            
            skView.presentScene(scene)
            skView.paused = true
            
            //if the user touched the screen to start the game
            if userStarted {
                skView.paused = false
            }
            
        }
    }
    
    //if the user touches the screen anywhere
    override func touchesBegan(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        
        if userStarted == false {
            userStarted = true
            viewDidLoad()
        }
        
    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
