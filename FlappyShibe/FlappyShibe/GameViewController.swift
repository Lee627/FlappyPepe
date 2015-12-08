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
    
    //Variable to store if the game has been paused or not
    var gamePaused = true
    
    //Has the user started their first game yet
    var start = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let skView = self.view as! SKView

        if let scene = GameScene(fileNamed:"GameScene") {
            
            if !start{
                
            // Configure the view.
            skView.showsFPS = true
            skView.showsNodeCount = true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill
                
            skView.presentScene(scene)
                
            //Pause initially
            skView.paused = true
                
            //The user started their first game
            start = true
                
            let button   = UIButton(type: UIButtonType.System) as UIButton
            button.frame = CGRectMake(30, 30, 30, 30)
            button.backgroundColor = UIColor.blackColor()
            button.setTitle("||", forState: UIControlState.Normal)
            button.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
                
            self.view.addSubview(button)
                
            }
            
        }
        
        //If game is paused, pause the view
        if gamePaused {
            
            skView.paused = true
        }
        
        //If game is not paused, unpause the view
        if !gamePaused {
            
            skView.paused = false
            
        }
    }
    
    //If the user presses the pause button
    @IBAction func buttonAction(sender: AnyObject) {
        
        gamePaused = true
        viewDidLoad()
        
    }
    
    //If the user touches the screen anywhere
    override func touchesBegan(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        
        if gamePaused == true {
            
            gamePaused = false
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
