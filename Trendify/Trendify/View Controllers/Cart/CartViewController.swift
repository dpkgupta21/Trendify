//
//  CartViewController.swift
//  Trendify
//
//  Created by Akash Deep Kaushik on 16/10/17.
//  Copyright © 2017 Akash Deep Kaushik. All rights reserved.
//

import UIKit

class CartViewController: UIViewController, UITableViewDelegate,UITableViewDataSource{

    @IBOutlet weak var TblVW: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TblVW.estimatedRowHeight = 50;
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartTVCell") as! CartTVCell
        return cell;
    }
}
