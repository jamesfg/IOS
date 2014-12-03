//
//  ViewController.swift
//  Exercise9
//
//  Created by ubicomp3 on 11/13/14.
//  Copyright (c) 2014 CPL. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var shapeView: UIView!
    @IBAction func shapeGesture(sender: UITapGestureRecognizer) {
        
        if(self.shapeView.layer.cornerRadius == 50.0){
            UIView.animateWithDuration(1, animations: {
                self.shapeView.layer.cornerRadius = 0.0
                self.shapeView.backgroundColor = self.getRandomColor()
            })
        }else{
            UIView.animateWithDuration(1, animations: {
                self.shapeView.layer.cornerRadius = 50.0
                self.shapeView.backgroundColor = self.getRandomColor()
            })
        }
    }

    @IBAction func screenGesture(sender: UITapGestureRecognizer) {
    }
    
    
    func getRandomColor() -> UIColor{
        
        var randomRed:CGFloat = CGFloat(drand48())
        
        var randomGreen:CGFloat = CGFloat(drand48())
        
        var randomBlue:CGFloat = CGFloat(drand48())
        
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
        
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        
        var touch : UITouch! = touches.anyObject() as UITouch
        
        var location = touch.locationInView(self.view)
        
        UIView.animateWithDuration(1, animations: {
            
            self.shapeView.center = location
            
            if(location.x<50){
                self.shapeView.center.x = 50
            }
            
            if(location.y<120){
                self.shapeView.center.y = 120
            }
            
            if(location.x>self.view.frame.width-50){
                self.shapeView.center.x = self.view.frame.width-50
            }
            
            if(location.y>self.view.frame.height-50){
                self.shapeView.center.y = self.view.frame.height-50
            }
            
            
        })
        
    }
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        
        var touch : UITouch! = touches.anyObject() as UITouch
        
        var location = touch.locationInView(self.view)
        
        self.shapeView.center = location
        
        if(location.x<50){
            self.shapeView.center.x = 50
        }
        
        if(location.y<120){
            self.shapeView.center.y = 120
        }
        
        if(location.x>self.view.frame.width-50){
            self.shapeView.center.x = self.view.frame.width-50
        }
        
        if(location.y>self.view.frame.height-50){
            self.shapeView.center.y = self.view.frame.height-50
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

