//
//  MenuViewController.swift
//  Trendify
//
//  Created by Akash Deep Kaushik on 19/09/17.
//  Copyright © 2017 Akash Deep Kaushik. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController,UITableViewDelegate,UITableViewDataSource
{
    @IBOutlet var ViewLogin: UIView!
    
    @IBOutlet var lblCustomerName: UILabel!
    
    @IBOutlet var lblCustomerBalance: UILabel!
    @IBOutlet var lblCustomerEmail: UILabel!
    
    @IBOutlet var lblSingleLetter: UILabel!
    @IBOutlet weak var BtnHome: UIButton!
    @IBOutlet weak var MenuTbl: UITableView!
    @IBOutlet weak var TopVwHeight: NSLayoutConstraint!
    
    var categoryItems:[CategoryItem] = [CategoryItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData();
        // Do any additional setup after loading the view.
        updateLogin()
        NotificationCenter.default.addObserver(self, selector: #selector(MenuViewController.updateLogin), name: Notification.Name("loadedPost"), object: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
     @IBAction func BtnLoginClicked(_ sender: Any) {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "HomeNavVC") as! UINavigationController
        self.revealViewController().frontViewController = VC;
        let VC1 = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController")
        VC.topViewController?.navigationController?.pushViewController(VC1!, animated: true)
         self.revealViewController().revealToggle(self);
    }
    
    @IBAction func BtnHomeClicked(_ sender: Any) {
        AppNavigation.ChangeToHomeVC(oldVC: self)
        self.revealViewController().revealToggle(self);
    }
    
    func  loadData()  {
       CategoryItem.GetMenuItems { (data) in
            self.categoryItems = data
            DispatchQueue.main.async {
                self.MenuTbl.reloadData()};
        }
    }
    
    
    func updateLogin() {
        if(UserDeafultsManager.SharedDefaults.IsLoggedIn==true)
        {
            lblCustomerName.text=UserDeafultsManager.SharedDefaults.FirstName;
            lblCustomerEmail.text=UserDeafultsManager.SharedDefaults.Username;
            lblSingleLetter.text = String(describing: lblCustomerName.text!.characters.first!).uppercased()
       
            self.ViewLogin.isHidden=false;
            
        }
        else{
            self.ViewLogin.isHidden=true
        }
        AppNavigation.ChangeToHomeVC(oldVC: self)
        self.revealViewController().revealToggle(self);
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if(UserDeafultsManager.SharedDefaults.IsLoggedIn==true){
        return categoryItems.count;
        }
        else{
            return categoryItems.count-2;
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40;
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuTVCell") as! MenuTVCell
        cell.congfigureCell(item: categoryItems[section]);
        cell.BtnHeader.tag = section;
        cell.BtnHeader.addTarget(self, action: #selector(HeaderTapped), for: .touchUpInside)
        return cell;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  categoryItems[section].isExpanded ? (categoryItems[section].subCategoryList?.count)! : 0;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuTVCell") as! MenuTVCell
        cell.Configure(title: (categoryItems[indexPath.section].subCategoryList?[indexPath.row])!, isbold: true);
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        switch(indexPath.section){
        case 0,1,2,3,4,5,6:
//            if(categoryItems[indexPath.section].categoryNameForWebservice! != "Settings"){
                AppNavigation.ChangeToProductVC(oldVC: self,
                                                pageType: categoryItems[indexPath.section].categoryNameForWebservice!,
                                                categoryid: "",
                                                itemType: (categoryItems[indexPath.section].subCategoryListForWebservice?[indexPath.row])!)
                self.revealViewController().revealToggle(self);
           // }
                        break;
        case 7:
            break;
        case 8:
            break;
        case 9:
            switch(indexPath.row){
            case 0:
                
                break;
            case 1:
                UserDeafultsManager.SharedDefaults.IsLoggedIn=false;
                UserDeafultsManager.SharedDefaults.AddressWithCity = "";
                UserDeafultsManager.SharedDefaults.Username = "";
                UserDeafultsManager.SharedDefaults.Password = "";
                tableView.reloadData()
                updateLogin()
                break;
            default:
                break;
            }
            break;
            
        default:
            break;
        }
    }
    
    func HeaderTapped(_ sender: Any) {
        let state = categoryItems[(sender as! UIView).tag].isExpanded;
        for item in categoryItems {
            item.isExpanded = false;
        }
        categoryItems[(sender as! UIView).tag].isExpanded = !state;
        self.MenuTbl.reloadData();
        
    }
    
}
