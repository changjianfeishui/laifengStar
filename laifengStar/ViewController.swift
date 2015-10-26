//
//  ViewController.swift
//  laifengStar
//
//  Created by XB on 15/10/26.
//  Copyright © 2015年 XB. All rights reserved.
//

import UIKit
import CoreMotion
class ViewController: UIViewController {

    
    @IBOutlet weak var playerView: UIView!
    
    var animator:UIDynamicAnimator!
    var gravity: UIGravityBehavior!
    var collision: UICollisionBehavior!
    
    let motionQueue = NSOperationQueue()
    let motionManager = CMMotionManager()
    
    override func viewDidDisappear(animated: Bool)  {
        super.viewDidDisappear(animated)
        NSLog("Stopping gravity")
        motionManager.stopDeviceMotionUpdates()
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.motionManager.gyroUpdateInterval = 0.1
        self.motionManager.startDeviceMotionUpdatesToQueue(self.motionQueue) { (motion: CMDeviceMotion?, error: NSError?) -> Void in
            let grav : CMAcceleration = motion!.gravity;
            
            let x = CGFloat(grav.x);
            let y = CGFloat(grav.y);
            
            if (error != nil) {
                NSLog("\(error)")
            }
            

            
            let v = CGVectorMake(x, 0 - y);
            self.gravity.gravityDirection = v;
        }
        
        self.animator = UIDynamicAnimator(referenceView: self.playerView)
        self.gravity = UIGravityBehavior()
        self.collision = UICollisionBehavior()
        self.animator.addBehavior(self.gravity)
        self.animator.addBehavior(self.collision)
        self.collision.translatesReferenceBoundsIntoBoundary = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func fire(sender: UIButton) {
        sender.enabled = false
        let imgv = UIImageView(image: UIImage(named: "phyx_star"))
        self.playerView.addSubview(imgv)
        

        self.gravity.addItem(imgv)
        self.collision.addItem(imgv)
        
        
        let push = UIPushBehavior(items: [imgv], mode: UIPushBehaviorMode.Instantaneous)
        push.setAngle(20, magnitude:2)
        self.animator.addBehavior(push)
        
        sender.enabled = true
    }
    
    @IBAction func clear(sender: AnyObject) {

        print(self.playerView.subviews.count)
        
        for (_, value) in self.playerView.subviews.enumerate(){
            self.collision.removeItem(value)
            value.removeFromSuperview()

        }
    }
    


}

