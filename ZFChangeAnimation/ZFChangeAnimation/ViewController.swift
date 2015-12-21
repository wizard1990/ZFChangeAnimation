//
//  ViewController.swift
//  ZFChangeAnimation
//
//  Created by Yan Zhang on 12/21/15.
//  Copyright © 2015 Yan Zhang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private var animationView: ChangeAnimationView?

    override func viewDidLoad() {
        super.viewDidLoad()
        animationView = ChangeAnimationView(frame: CGRectMake(0, 150, view.bounds.width, 116))
        view.addSubview(animationView!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func startAnimation(sender: AnyObject) {
        animationView?.startAnimation()
    }

    @IBAction func pasueAnimation(sender: AnyObject) {
        animationView?.stopAnimation()
    }

    @IBAction func resumeAnimation(sender: AnyObject) {
        animationView?.resumeAnimation()
    }

}

