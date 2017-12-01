//
//  ParentViewController.swift
//  Trendify
//
//  Created by Ghanshyam Jain on 08/11/17.
//  Copyright © 2017 Akash Deep Kaushik. All rights reserved.
//

import UIKit

class ParentViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func calculateTotalCartItems(){
        // Iterate through the keys of the dictionary sum up the quantity
        var total:Int = 0
        var cartItemCount = 0
        let cartImage = UIImage(named: "shopping_cart_white")
        let userImage = UIImage(named: "user_menu")
        
        for cartItem in CategoryItem.cartItemsArray{
            total += cartItem.orderQty
        }
        cartItemCount = total
        
        
        // Create a view
        let view = UIView(frame: CGRect(x:0, y:0, width: 30, height: 30))
        
        // Create a button
        let button: UIButton = UIButton(type: .custom)
        button.setImage(cartImage, for: .normal)
        button.addTarget(self, action: #selector(CartDetail), for: .touchUpInside)
        button.frame = CGRect(x: 5, y: 0, width: 30, height: 30)
        
        let view1 = UIView(frame: CGRect(x:20, y:0, width: 12, height: 12))
        
        // Create a label
        let label: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 12, height: 12))
        label.font = UIFont(name: "Helvetica-Bold", size: 9)
        label.text = "\(cartItemCount)"
        label.textColor=UIColor.white
        
        label.textAlignment=NSTextAlignment.center
        view1.backgroundColor=UIColor.blue
        view1.layer.cornerRadius=6.0;
        view1.layer.borderColor=UIColor.clear.cgColor
        view1.layer.borderWidth=0.5;
        view1.clipsToBounds=true
        
        // Add the button and label to the view
        
        view.addSubview(button)
        view1.addSubview(label)
        view.addSubview(view1)
        
        // Set the view as the bar button item
        let cartButton = UIBarButtonItem(customView: view)
        
        let abc:NSMutableArray = NSMutableArray()
        abc.add(cartButton)
        
        if(UserDeafultsManager.SharedDefaults.IsLoggedIn==true)
        {
            // Create a button
            let button1: UIButton = UIButton(type: .custom)
            button1.setImage(userImage, for: .normal)
            button1.addTarget(self, action: #selector(editProfile), for: .touchUpInside)
            button1.frame = CGRect(x: 0, y: 5, width: 25, height: 25)
            let cartButton1 = UIBarButtonItem(customView: button1)
            abc.add(cartButton1)
        }
        
        self.navigationItem.setRightBarButtonItems(abc as! [UIBarButtonItem], animated: true)
        
        
    }
    
    func CartDetail() {
        
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "CartViewController")
        self.navigationController?.pushViewController(VC!, animated: true)
        
    }
    
    func editProfile() {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "SignUpViewController")
        self.navigationController?.pushViewController(VC!, animated: true)
        
    }
    
    
}
