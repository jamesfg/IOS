//
//  DetailViewController.swift
//  Exercise8
//
//  Created by ubicomp3 on 11/6/14.
//  Copyright (c) 2014 CPL. All rights reserved.
//

import Foundation
import UIKit
class DetailViewController: UIViewController {
    var reminder: Reminder?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .Plain, target: self, action: "getBack")
        titleLabel.text = reminder?.title
        locationLabel.text = reminder?.location
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func getBack() {
        self.navigationController?.popViewControllerAnimated(true)
    }

    @IBAction func careBearShare(sender: UIButton) {
        let activityViewController : UIActivityViewController = UIActivityViewController(nibName: reminder?.title, bundle: nil)
        self.presentViewController(activityViewController, animated: true, completion: nil)
    }
}