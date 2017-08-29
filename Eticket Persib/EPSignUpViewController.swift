//
//  EPSignUpViewController.swift
//  Eticket Persib
//
//  Created by Apit on 6/7/17.
//  Copyright © 2017 Apit. All rights reserved.
//

import UIKit
import CoreData
import PKHUD

class EPSignUpViewController: UIViewController {

    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var cityTextfield: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var ktpTextField: UITextField!
    @IBOutlet weak var handphoneTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var signUpView: UIView!
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var loginEmailTextField: UITextField!
    @IBOutlet weak var loginPasswordTextField: UITextField!
    var email: String!
    var password: String!
    var user = [User]()
    var userData = UserData()
    var managedObjectContext: NSManagedObjectContext!
    var scheduleController: EPScheduleViewController!
    override func viewDidLoad() {
        super.viewDidLoad()

        signUpView.isHidden = true
        managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadData() {
        do {
            let userRequest:NSFetchRequest<User> = User.fetchRequest()
            user = try managedObjectContext.fetch(userRequest)
            for users in user {
                email = users.email
                password = users.password
            }
        }catch {
            print(error.localizedDescription)
        }
    }
    
    func getAPILogin()
    {
        let param: [String: String] = ["email": self.loginEmailTextField.text!, "password": self.loginPasswordTextField.text!]
        WebService.currentController = self
        WebService.POST(url: WebService.login, queryString: param, headers: [:], success: { (json) in
            let message = json["data"]["message"].stringValue
            let data = json["data"]["user_data"]
            if message == "Success"{
                let storyBoard = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EPTabBarController") as! EPTabBarController
                let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EPScheduleViewController") as! EPScheduleViewController
                HUD.flash(.success, delay: 1.0)
                self.userData = UserData()
                self.userData.address = data["customer_address"].stringValue
                self.userData.city = data["customer_city"].stringValue
                self.userData.email = data["customer_email"].stringValue
                self.userData.fullName = data["customer_name"].stringValue
                self.userData.handphone = data["customer_handphone"].stringValue
                self.userData.ktp = data["customer_ktp"].stringValue
                self.userData.userId = data["id"].stringValue
                UserDefaults.standard.set(self.userData.userId, forKey: "userId")
                controller.userData = self.userData
                controller.test = self.userData.address
//                storyBoard.viewControllers = [controller]
                storyBoard.userData = self.userData
                self.present(storyBoard, animated: true, completion: nil)
            }else{
                let alert = UIAlertController(title: "Error", message: "Email atau password salah", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            }
        }) { (error) in
            print(error)
        }
    }
    
    
    func signUpCustomer() {
        let param: [String: String] = ["email": self.emailTextField.text!, "password": self.passwordTextField.text!, "city": self.cityTextfield.text!, "address": self.addressTextField.text!, "ktp": self.ktpTextField.text!, "phone": self.handphoneTextField.text!, "name": self.fullNameTextField.text!]
        WebService.currentController = self
        WebService.POST(url: WebService.urlAPI + "user/signup", queryString: param, headers: [:], success: { (json) in
            
            
        }) { (error) in
            print(error)
        }
    }
    
    @IBAction func onClickLogin(_ sender: Any) {
        HUD.flash(.label("Requesting Login…"), delay: 2.0) { _ in
//            self.loadData()
            if self.loginEmailTextField.text != "" && self.loginPasswordTextField.text != ""{
                self.getAPILogin()
            }else{
                HUD.flash(.error, delay: 1.0)
                let alert = UIAlertController(title: "Error", message: "Email atau Password tidak boleh kosong", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func onFirstLogin(_ sender: Any) {
        loginView.isHidden = false
        signUpView.isHidden = true
    }
    
    @IBAction func onFirstSignUp(_ sender: Any) {
        loginView.isHidden = true
        signUpView.isHidden = false
    }
    
    @IBAction func onClickSignUp(_ sender: Any) {
        HUD.flash(.label("Sending…"), delay: 1.0) { _ in
            var error = ""
            if self.fullNameTextField.text == "" {
                error = "Nama lengkap harus diisi"
            }else if self.addressTextField.text == "" {
                error = "Alamat harus diisi"
            }else if self.cityTextfield.text == "" {
                error = "Kota harus diisi"
            }else if self.emailTextField.text == "" {
                error = "Email harus diisi"
            }else if self.ktpTextField.text == "" {
                error = "Nomor ktp harus diisi"
            }else if self.handphoneTextField.text == "" {
                error = "Nomor handphone harus diisi"
            }else if self.passwordTextField.text == "" {
                error = "Password harus diisi"
            }else if self.confirmPasswordTextField.text == "" {
                error = "Confirm password harus diisi"
            }else if self.passwordTextField.text != self.confirmPasswordTextField.text {
                error = "Password yang anda masukan salah"
            }
            if error == "" {
                let userItem = User(context: self.managedObjectContext)
                userItem.fullName = self.userData.fullName
                userItem.address = self.userData.address
                userItem.email = self.userData.email
                userItem.handphone = self.userData.handphone
                userItem.ktp = self.userData.ktp
                userItem.password = self.userData.password
                userItem.city = self.userData.city
                userItem.uid = self.userData.userId
                do {
                    self.signUpCustomer()
                    try self.managedObjectContext.save()
                    self.loginView.isHidden = false
                    self.signUpView.isHidden = true
                    HUD.flash(.success, delay: 1.0)
                }catch{
                    print("---------\(error.localizedDescription)")
                }
            }else{
                HUD.flash(.error, delay: 1.0)
                let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
