//
//  HomeViewController.swift
//  Trendify
//
//  Created by Akash Deep Kaushik on 21/09/17.
//  Copyright © 2017 Akash Deep Kaushik. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var MenuBtn: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.revealViewController().rearViewRevealOverdraw=0;
        self.revealViewController().rearViewRevealWidth = self.view.frame.width-50;
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func MenuClicked(_ sender: Any) {

        if self.revealViewController() != nil {
            self.revealViewController().revealToggle(self);
        
        }
    }
}
