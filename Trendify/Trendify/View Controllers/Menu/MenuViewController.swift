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
    
    @IBOutlet weak var BtnHome: UIButton!
    @IBOutlet weak var MenuTbl: UITableView!
    @IBOutlet weak var TopVwHeight: NSLayoutConstraint!
    
    var categoryItems:[CategoryItem] = [CategoryItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData();
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func BtnHomeClicked(_ sender: Any) {
        self.revealViewController().revealToggle(self);
    }
    
    func  loadData()  {
        DataManager.getTopAppsDataFromFileWithSuccess { (data) -> Void in
            
            // 1
            var json: (Any)? = nil
            do {
                json = try JSONSerialization.jsonObject(with: data)
            } catch {
            }
            
            let dictionary = json as? [Any]
            
            // 2
            for item in dictionary!{
                self.categoryItems.append(CategoryItem(json: item as! [String : Any])!)
            }
            DispatchQueue.main.async {
                self.MenuTbl.reloadData()};
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return categoryItems.count;
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
        self.revealViewController().revealToggle(self);
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
