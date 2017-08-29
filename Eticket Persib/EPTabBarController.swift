//
//  EPTabBarController.swift
//  Eticket Persib
//
//  Created by Apit on 6/3/17.
//  Copyright © 2017 Apit. All rights reserved.
//

import UIKit

class EPTabBarController: UITabBarController {

    var userData = UserData()
    override func viewDidLoad() {
        super.viewDidLoad()

        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EPScheduleViewController") as! EPScheduleViewController
        controller.userData = self.userData
        self.present(controller, animated: true, completion: nil)
        print ("--------\(userData.address)")
        
//        self.tabBar.items![0].selectedImage = UIImage(named: "home_on")?.imageScaled(to: CGSize(width:30, height:30)).withRenderingMode(UIImageRenderingMode.alwaysOriginal)
//        self.tabBar.items![0].image = UIImage(named: "home_off")?.imageScaled(to: CGSize(width:30, height:30)).withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        
        self.tabBar.items![0].selectedImage = UIImage(named: "home_on")?.imageScaled(to: CGSize(width:30, height:30)).withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        self.tabBar.items![0].image = UIImage(named: "home_off")?.imageScaled(to: CGSize(width:30, height:30)).withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        
        self.tabBar.items![1].selectedImage = UIImage(named: "timeline_on")?.imageScaled(to: CGSize(width:30, height:30)).withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        self.tabBar.items![1].image = UIImage(named: "timeline_off")?.imageScaled(to: CGSize(width:30, height:30)).withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        
        self.tabBar.items![2].selectedImage = UIImage(named: "calendar_on")?.imageScaled(to: CGSize(width:30, height:30)).withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        self.tabBar.items![2].image = UIImage(named: "calendar_off")?.imageScaled(to: CGSize(width:30, height:30)).withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
