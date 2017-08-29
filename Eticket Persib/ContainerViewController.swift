//
//  ContainerViewController.swift
//  Eticket Persib
//
//  Created by Apit on 8/10/17.
//  Copyright © 2017 Apit. All rights reserved.
//

import UIKit

class ContainerViewController: MFSideMenuContainerViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let tabbarController = mainStoryboard.instantiateViewController(withIdentifier: "EPTabBarController") as! UITabBarController
        
        let leftSidebarMenuController = mainStoryboard.instantiateViewController(withIdentifier: "SideMenuViewController") as! SideMenuViewController
        
        leftSidebarMenuController.containerViewController = self
        self.leftMenuViewController = leftSidebarMenuController
        self.centerViewController = tabbarController
        self.menuContainerViewController.panMode = MFSideMenuPanModeSideMenu;
        //        self.panMode = MFSideMenuPanModeNone
        ////        setupMenuBarButtonItems()
        // Do any additional setup after loading the view.
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // set the radius of the shadow
        self.shadow.radius = 1
        
        // set the color of the shadow
        self.shadow.color = UIColor.black
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden=true
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
