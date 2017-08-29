//
//  EticketHomeContainerViewController.swift
//  Eticket Persib
//
//  Created by Apit on 8/8/17.
//  Copyright © 2017 Apit. All rights reserved.
//

import UIKit

class EticketHomeContainerViewController: UIViewController, CAPSPageMenuDelegate {

    private var pageMenu : CAPSPageMenu?
    @IBOutlet weak var containerView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        var controllerArray: [UIViewController] = []
        let storyboard: UIStoryboard = UIStoryboard(name: "Home", bundle: nil)
        var controller = storyboard.instantiateViewController(withIdentifier: "EticketHomeViewController") as! EticketHomeViewController
        controller.title = "Dashboard"
        controller.tableType = "Dashboard"
        controller.containerController = self
        controllerArray.append(controller)
        
        controller = storyboard.instantiateViewController(withIdentifier: "EticketHomeViewController") as! EticketHomeViewController
        controller.title = "Schedule"
        controller.tableType = "Schedule"
        controller.containerController = self
        controllerArray.append(controller)
        
        controller = storyboard.instantiateViewController(withIdentifier: "EticketHomeViewController") as! EticketHomeViewController
        controller.title = "History"
        controller.tableType = "History"
        controller.containerController = self
        controllerArray.append(controller)
        
        controller = storyboard.instantiateViewController(withIdentifier: "EticketHomeViewController") as! EticketHomeViewController
        controller.title = "Classement"
        controller.tableType = "Classement"
        controller.containerController = self
        controllerArray.append(controller)
        
        let parameters: [CAPSPageMenuOption] = [
            .MenuItemSeparatorWidth(0),
            .UseMenuLikeSegmentedControl(false),
            .MenuItemSeparatorPercentageHeight(0.1),
            .ViewBackgroundColor(UIColor.lightGray),
            .ScrollMenuBackgroundColor(UIColor.lightGray),
            .SelectedMenuItemLabelColor (UIColor.blue),
            .UnselectedMenuItemLabelColor (UIColor.blue),
            .SelectionIndicatorColor (UIColor.red),
            .MenuItemWidthBasedOnTitleTextWidth(true)
        ]
        
        // Initialize page menu with controller array, frame, and optional parameters
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRect(x:0.0, y:0.0, width:self.containerView.frame.width, height:self.containerView.frame.height), pageMenuOptions: parameters)
        
        pageMenu!.delegate = self
        // Lastly add page menu as subview of base view controller view
        // or use pageMenu controller in you view hierachy as desired
        self.containerView.addSubview(pageMenu!.view)
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
