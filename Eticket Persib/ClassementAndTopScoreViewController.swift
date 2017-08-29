//
//  ClassementAndTopScoreViewController.swift
//  
//
//  Created by Apit on 7/15/17.
//
//

import UIKit
import PKHUD

class ClassementAndTopScoreViewController: BaseViewController {

    var classement = [Classement]()
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var image1: UIImageView!
    @IBOutlet weak var image2: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

//        self.addSlideMenuButton()
        loadData()
        setupMenuButton()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupMenuButton() {
        let infoButton = UIButton(frame: CGRect(x:0, y:0, width:25, height:25))
        infoButton.addTarget(self, action: #selector(onClickInfoButton), for: UIControlEvents.touchUpInside)
        infoButton.setBackgroundImage(UIImage(named: "about"), for: UIControlState.normal)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: infoButton)
        
        let logoutButton = UIButton(frame: CGRect(x:0, y:0, width:25, height:25))
        logoutButton.addTarget(self, action: #selector(logout), for: UIControlEvents.touchUpInside)
        logoutButton.setBackgroundImage(UIImage(named: "logout"), for: UIControlState.normal)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: logoutButton)
    }
    
    func onClickInfoButton() {
        let alertController = UIAlertController(title: "", message: "Info Eticket Persib", preferredStyle: .actionSheet)
        let info = UIAlertAction(title: "Info Stadion", style: .default) { (alert) in
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "InfoStadionViewController")
            self.present(controller, animated: true, completion: nil)
        }
        let cara = UIAlertAction(title: "Info Persib", style: .default) { (alert) in
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "InfoPersibViewController")
            self.present(controller, animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(info)
        alertController.addAction(cara)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func logout() {
        let alertController = UIAlertController(title: "", message: "Apakah anda yakin ingin keluar dari aplikasi ?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (alert) in
            HUD.flash(.label("Logout…"), delay: 2.0) { _ in
                let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "EPSignUpViewController")
                self.present(controller, animated: true, completion: nil)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }

    func loadData() {
        WebService.currentController = self
        WebService.GET(url: WebService.urlAPI + "classement", param: [:], headers: [:], hud: true, hudString: "Load data", success: { (json) in
            let data = json["data"]["all"].arrayValue
//            let image1 = data["image"].stringValue
//            let image2 = data["topscore"].stringValue
            self.classement = [Classement]()
            for datas in data {
                let classement = Classement()
                classement.image1 = datas["classement_image"].stringValue
                classement.image2 = datas["topscore_image"].stringValue
                self.classement.append(classement)
            }
            let url = URL(string: WebService.baseUrl + "images/" + self.classement[0].image1.replacingOccurrences(of: " ", with: "%20"))!
            let url1 = URL(string: WebService.baseUrl + "images1/" + self.classement[0].image2.replacingOccurrences(of: " ", with: "%20"))!
            self.image1.sd_setImage(with: url)
            self.image2.sd_setImage(with: url1)
//            self.refreshControl.endRefreshing()
        }) { (error) in
            let alert = UIAlertController(title: "", message: error.desc, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
//            self.refreshControl.endRefreshing()
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
