//
//  LoginViewController.swift
//  Trendify
//
//  Created by Ghanshyam Jain on 12/11/17.
//  Copyright © 2017 Akash Deep Kaushik. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet var txtEmailID: UITextField!
    @IBOutlet var txtPassword: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnActionShowPassword(_ sender: Any) {
        if(txtPassword.isSecureTextEntry==true){
        txtPassword.isSecureTextEntry=false;
        }else
        {
            txtPassword.isSecureTextEntry=true;
        }
    }
    @IBAction func btnActionForgotPassword(_ sender: Any) {
        ForgotPasswordView()
    }

    @IBAction func btnActionLogin(_ sender: Any) {
        getLogin()
    }
   
    @IBAction func btnActionSignUp(_ sender: Any) {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "SignUpViewController")
        self.navigationController?.pushViewController(VC!, animated: true)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
    func ForgotPasswordView()
    {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordViewController")
        self.navigationController?.pushViewController(VC!, animated: true)
        
    }
    
    func getLogin(){
        Utility.showProgressHud(text: "")
        LoginResponseModel.Login(username: txtEmailID.text!, password: txtPassword.text!) { (data, error) in
           
            DispatchQueue.main.async {
                Utility.hideProgressHud()
                
                if(data != nil){
                    print(data!);
                    let json:NSDictionary = (data?.dictionaryRepresentation())!;
                    
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
                        // here "jsonData" is the dictionary encoded in JSON data
                        
                        let jsonString = String(data: jsonData, encoding: .ascii);
                            print(jsonString!);
                        UserDeafultsManager.SharedDefaults.LoginData=jsonString!
                        UserDeafultsManager.SharedDefaults.IsLoggedIn=true;
                        UserDeafultsManager.SharedDefaults.MemberID=(data?.a_Id)!
                        UserDeafultsManager.SharedDefaults.Username=(data?.email)!;
                        UserDeafultsManager.SharedDefaults.Password=(data?.password)!;
                        UserDeafultsManager.SharedDefaults.FirstName=(data?.name)!;
                        UserDeafultsManager.SharedDefaults.MobileNo=(data?.mobileNo)!;
                        UserDeafultsManager.SharedDefaults.AddressWithCity = String((data?.address)! + " " + (data?.city)!);
                        let notificationName = Notification.Name("loadedPost")
                    
                                            // Post notification
                        NotificationCenter.default.post(name: notificationName, object: nil)
                        
                        self.navigationController?.popViewController(animated: true);
                   
                        
                    } catch {
                        print(error.localizedDescription)
                    }
                }else{
                    let info = ["title":"Error",
                                "message":error,
                                "cancel":"Ok"]
                    Utility.showAlertWithInfo(infoDic: info as NSDictionary)
                }
              
            }
        }
        
    }
    
}
