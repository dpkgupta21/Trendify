//
//  SignUpViewController.swift
//  Trendify
//
//  Created by Ghanshyam Jain on 16/11/17.
//  Copyright © 2017 Akash Deep Kaushik. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource {

    @IBOutlet var txtCustomerName: UITextField!
    @IBOutlet var txtEmailID: UITextField!
    @IBOutlet var txtPassword: UITextField!
    @IBOutlet var txtConfirmPassword: UITextField!
    @IBOutlet var txtMobileNo: UITextField!
    @IBOutlet var txtState: UITextField!
    @IBOutlet var txtAddress: UITextView!
    @IBOutlet var txtCity: UITextField!
    @IBOutlet var txtPincode: UITextField!
    @IBOutlet var btnSignUp: UIButton!
    var arrState:NSMutableArray = NSMutableArray()
    var selectedState = 0;
    var selectedRow = 0;
    //Picker View Object
    let picker = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getStateList()
        // Do any additional setup after loading the view.
        
        picker.delegate = self
        picker.dataSource = self
        
        txtState.inputView = picker
        //Done Button function called
        doneButton();
        updateProfile();
    }
    
    func updateProfile()
    {
        if(UserDeafultsManager.SharedDefaults.IsLoggedIn==true && UserDeafultsManager.SharedDefaults.LoginData.characters.count>0){
            self.title = "Edit Profile"
            btnSignUp.setTitle("Update", for: UIControlState.normal)
            let str :String = UserDeafultsManager.SharedDefaults.LoginData
            let jsonObj:JSON = str.toJSON() as! JSON
            let login = LoginResponseModel(json: jsonObj)
            txtCustomerName.text = login?.name
             txtPassword.text = login?.password
            txtPassword.isUserInteractionEnabled=false
            txtConfirmPassword.isUserInteractionEnabled=false
            txtEmailID.text = login?.email
            txtAddress.text = login?.address
            txtMobileNo.text = login?.mobileNo
            txtCity.text = login?.city
            txtPincode.text = login?.pincode
            if arrState.count > 0 {
                let objstate:StateModel=arrState[selectedRow] as! StateModel;
                selectedState = objstate.a_Id!;
                txtState.text = objstate.name;
            }
            
        }
        else{
            self.title = "Sign Up"
            btnSignUp.setTitle("Sign Up", for: UIControlState.normal)
            txtPassword.isUserInteractionEnabled=true
            txtConfirmPassword.isUserInteractionEnabled=true
        }
    }
    
    
    
    @IBAction func btnActionSignUp(_ sender: Any) {
        if (isvalidate() == true) {
            SignUp()
        }
    }

    
    func SignUp()
    {
        let dictionary = [
            "CustomerName" : txtCustomerName.text!,
            "CustomerPassword" : txtPassword.text!,
            "CustomerEmail" : txtEmailID.text!,
            "Customeraddress" : txtAddress.text!,
            "CustomerMobileNo" : txtMobileNo.text!,
            "CustomerCity" : txtCity.text!,
            "Customerstate" : selectedState,
            "CustomerPincode" : txtPincode.text!,
            ] as [String : Any]
        
        WebserviceCommunication.defaultCommunicator().httpPOSTEncodedString(methodName: METHOD_SIGNUP ,body:dictionary as NSDictionary )
        { (data, statusCode, error) in
            
            if (data != nil)
            {
                let datastring = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                print(datastring!)
                
                
                if(statusCode==200)
                {
                    let info = ["title": "Trendify",
                                "message":"Registration save sucessfully. Login for further Process.",
                                "cancel":"Ok"]
                    Utility.showAlertWithInfo(infoDic: info as NSDictionary)
                        
                        self.navigationController?.popToRootViewController(animated: true)
                    
                }else{
                    
                    
                }
                
            }else{
                
            }
            
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func isvalidate() -> Bool {
        var valid:Bool=true;
        var str:String! = ""
        
        if ((txtCustomerName.text?.characters.count)! == 0) {
            valid=false;
            str="Please enter customer name."
        }
        else if ((txtEmailID.text?.characters.count)! == 0) {
            valid=false;
             str="Please enter username."
        }
        else if ((txtPassword.text?.characters.count)! == 0) {
            valid=false;
            str="Please enter password."
        }
        else if ((txtConfirmPassword.text?.characters.count)! == 0) {
            valid=false;
             str="Please enter confirm password."
        }
        else if ((txtMobileNo.text?.characters.count)! == 0) {
            valid=false;
            str="Please enter mobile number."
        }
        else if ((txtAddress.text?.characters.count)! == 0 ||  txtAddress.text=="Enter Address") {
            valid=false;
            str="Please enter address."
        }
        else if ((txtState.text?.characters.count)! == 0) {
            valid=false;
            str="Please select State"
        }
        else if ((txtCity.text?.characters.count)! == 0) {
            valid=false;
            str="Please enter city."
        }
        else if ((txtPincode.text?.characters.count)! == 0) {
            valid=false;
            str="Please enter pincode."
        }
        
        if valid==false {
            let info = ["title": str,
                        "message":nil,
                        "cancel":"Ok"]
            Utility.showAlertWithInfo(infoDic: info as NSDictionary)
        }
        
        return valid;
        
    }
    
     func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
    
    func getStateList(){
        
        StateModel.StateList(callback: { (data, error) in
            
            
            DispatchQueue.main.async {
                Utility.hideProgressHud()
                
                if(data != nil){
                    self.arrState=data as! NSMutableArray;
                    self.updateProfile()
                    
                }else{
                    let info = ["title":"Error",
                                "message":error,
                                "cancel":"Ok"]
                    Utility.showAlertWithInfo(infoDic: info as NSDictionary)
                }
                
            }
        })
    }

    
    
    public func numberOfComponents(in pickerView:  UIPickerView) -> Int  {
        return 1
    }
    
    public func pickerView(_ pickerView:UIPickerView,numberOfRowsInComponent component: Int) -> Int {
        return arrState.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let objstate:StateModel=arrState[row] as! StateModel;
        return objstate.name;
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedRow = row;
        
         let objstate:StateModel=arrState[row] as! StateModel;
        selectedState=objstate.a_Id!;
        txtState.text = objstate.name;
    }
    
    //begin  Doen Button function
    func doneButton(){
        
        let pickerView = picker
        pickerView.backgroundColor = .white
        pickerView.showsSelectionIndicator = true
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(SignUpViewController.donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(SignUpViewController.canclePicker))
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        txtState.inputView = pickerView
        txtState.inputAccessoryView = toolBar
    }
    
    
    func donePicker() {
        let objstate:StateModel=arrState[selectedRow] as! StateModel;
        selectedState=objstate.a_Id!;
        txtState.text = objstate.name;
        txtState.resignFirstResponder()
    }
    
    func canclePicker() {
        txtState.resignFirstResponder()
    }
    


}
