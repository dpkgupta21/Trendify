//
//  HomeViewController.swift
//  Trendify
//
//  Created by Akash Deep Kaushik on 21/09/17.
//  Copyright © 2017 Akash Deep Kaushik. All rights reserved.
//

import UIKit
import SDWebImage

class HomeViewController: UIViewController , UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    
    @IBOutlet weak var MenuBtn: UIBarButtonItem!
    
    @IBOutlet weak var CollectionVW: UICollectionView!
    var categoryItems:[HomeResponseModel] = [HomeResponseModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.revealViewController().rearViewRevealOverdraw=0;
        self.revealViewController().rearViewRevealWidth = self.view.frame.width-50;
        GetItems()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func GetItems(){
        Utility.showProgressHud(text: "")
        HomeResponseModel.GetItems() { (data, error) in
            DispatchQueue.main.async {
                Utility.hideProgressHud()
                
                if(data != nil){
                    self.categoryItems = data!
                    
                    self.CollectionVW.reloadData();
                }else{
                    let info = ["title":"Error",
                                "message":error,
                                "cancel":"Ok"]
                    Utility.showAlertWithInfo(infoDic: info as NSDictionary)
                }
            }
        }
    
    }
    
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return categoryItems.count;
    }
    
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCVCell", for: indexPath) as! HomeCVCell
        cell.ImgIcon.sd_setImage(with: URL(string: "http://trendyfy.com" + (categoryItems[indexPath.row].image1?.replacingOccurrences(of: "~", with: ""))!), placeholderImage: UIImage(named: "placeholder"))
        return cell;
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        if(indexPath.row < 2){
            let height = (collectionView.frame.width / 2  - 10);
            let size = CGSize(width: collectionView.frame.width, height: height)
            return size
        }else{
            let width = collectionView.frame.width / 2  - 10;
            let size = CGSize(width: width, height: width)
            return size
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        AppNavigation.ChangeToProductVC(oldVC: self,
                                        pageType: categoryItems[indexPath.row].pageType!,
                                        categoryid: String(describing: categoryItems[indexPath.row].categoryid),
                                        itemType: categoryItems[indexPath.row].itemType!)
    }
    
    
    @IBAction func MenuClicked(_ sender: Any) {
        
        if self.revealViewController() != nil {
            self.revealViewController().revealToggle(self);
            
        }
        
    }
    
}
