//
//  EticketNavigationViewController.swift
//  Eticket Persib
//
//  Created by Apit on 8/8/17.
//  Copyright © 2017 Apit. All rights reserved.
//

import UIKit

class EticketNavigationViewController: UINavigationController {

    var leftButtonItem:UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()

//        self.title = "Eticket Persib"
//        setupMenuButton()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func infoButton() {
        let alertController = UIAlertController(title: "", message: "Apakah anda yakin ingin keluar dari aplikasi ?", preferredStyle: .actionSheet)
        let info = UIAlertAction(title: "Info Stadion", style: .default) { (alert) in
            print("Info Stadion")
        }
        let cara = UIAlertAction(title: "Cara penukaran ticket", style: .default) { (alert) in
            print("Cara penukaran ticket")
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(info)
        alertController.addAction(cara)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func setupMenuButton() {
        let logoutButton = UIButton(frame: CGRect(x:0, y:0, width:25, height:25))
        logoutButton.addTarget(self, action: #selector(infoButton), for: UIControlEvents.touchUpInside)
        logoutButton.setBackgroundImage(UIImage(named: "about"), for: UIControlState.normal)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: logoutButton)
    }
    
    //MARK: - action
    /**
     method for open side menu when icon on left bar button item press
     
     - parameter sender: sender UI
     */
    func leftSideMenuButtonPressed(sender: Any) {
        let leftSideMenuController = self.menuContainerViewController.leftMenuViewController as! SideMenuViewController
        leftSideMenuController.viewWillAppear(true)
        self.menuContainerViewController.toggleLeftSideMenuCompletion(nil)
        self.menuContainerViewController.shadow.enabled = true
        self.menuContainerViewController.shadow.radius = 10.0
        self.menuContainerViewController.shadow.color = UIColor.black
        self.menuContainerViewController.shadow.opacity = 0.75
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
