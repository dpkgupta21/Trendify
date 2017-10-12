//
//  HomeViewController.swift
//  Trendify
//
//  Created by Akash Deep Kaushik on 21/09/17.
//  Copyright © 2017 Akash Deep Kaushik. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController , UICollectionViewDelegate,UICollectionViewDataSource
{

    @IBOutlet weak var MenuBtn: UIBarButtonItem!
    
    var categoryItems:[HomeResponseModel] = [HomeResponseModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.revealViewController().rearViewRevealOverdraw=0;
        self.revealViewController().rearViewRevealWidth = self.view.frame.width-50;
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func GetItems(){
    
    
    }

    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return categoryItems.count;
    }
    

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCVCell", for: indexPath) as! HomeCVCell
        return cell;
    
    }
    
     func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    
    

    @IBAction func MenuClicked(_ sender: Any) {

        if self.revealViewController() != nil {
            self.revealViewController().revealToggle(self);
        
        }
        
        LoginResponseModel.Login(username: "dpk.gupta21@gmail.com", password: "123456") { (data, error) in
            
        }
        
    }
}
