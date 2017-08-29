//
//  EPScheduleViewController.swift
//  Eticket Persib
//
//  Created by Apit on 6/8/17.
//  Copyright © 2017 Apit. All rights reserved.
//

import UIKit
import SDWebImage
import CoreData
import PKHUD

class EPScheduleViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var scheduleTableView: UITableView!
    var refreshControl: UIRefreshControl!
    var schedule:[Schedule] = [Schedule]()
    var date: [String] = ["GBLA, Jumat 11 Juni 2017", "GBLA, Kamis 17 Juni 2017"]
    var time: [String] = ["20.30 WIB", "20.30 WIB"]
    var teamHomeName: [String] = ["Persib", "Persiba"]
    var teamAwayName: [String] = ["Persiba", "Persib"]
    var teamHome: [UIImage] = [UIImage(named: "Logo_Persib")!, UIImage(named: "Persiba")!]
    var teamAway: [UIImage] = [UIImage(named: "Persiba")!, UIImage(named: "Logo_Persib")!]
    var test: String!
    var userData = UserData()
    var user = [User]()
    var managedObjectContext: NSManagedObjectContext!
    override func viewDidLoad() {
        super.viewDidLoad()

//        self.addSlideMenuButton()
        loadData()
        setupMenuButton()
        scheduleTableView.delegate = self
        scheduleTableView.dataSource = self
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        scheduleTableView.addSubview(refreshControl)
        managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
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
        
        print ("----/88----\(userData.address)\(test)")
        WebService.currentController = self
        WebService.GET(url: WebService.urlAPI + "schedule", param: [:], headers: [:], hud: true, hudString: "Load data", success: { (json) in
            let data = json["data"].arrayValue
            self.schedule = [Schedule]()
            for datas in data {
                let schedule = Schedule()
                schedule.matchDescripction = datas["schedule_stadion"].stringValue
                schedule.logoHome = datas["schedule_home_image"].stringValue
                schedule.logoAway = datas["schedule_away_image"].stringValue
                schedule.title = datas["schedule_match"].stringValue
                schedule.date = datas["schedule_date_match"].stringValue
                schedule.id = datas["id"].stringValue
                schedule.startDate = datas["schedule_start_date"].stringValue
                self.schedule.append(schedule)
            }
            self.scheduleTableView.reloadData()
            self.refreshControl.endRefreshing()
        }) { (error) in
            let alert = UIAlertController(title: "", message: error.desc, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            self.refreshControl.endRefreshing()
        }
    }
    
    func loadUserData() {
        do {
            let userRequest:NSFetchRequest<User> = User.fetchRequest()
            user = try managedObjectContext.fetch(userRequest)
            if user.count > 0 {
                print("----\(user.count)")
            }
        }catch {
            print(error.localizedDescription)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return schedule.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! EPScheduleTableViewCell
        cell.dateLabel.text = schedule[indexPath.row].matchDescripction
        cell.timeMatchLabel.text = schedule[indexPath.row].date
        cell.teamAwayLabel.text = schedule[indexPath.row].title
        let url = URL(string: WebService.baseUrl + "images/" + schedule[indexPath.row].logoHome.replacingOccurrences(of: " ", with: "%20"))!
        let url1 = URL(string: WebService.baseUrl + "images1/" + schedule[indexPath.row].logoAway.replacingOccurrences(of: " ", with: "%20"))!
        cell.teamHomeImageView.sd_setImage(with: url)
        cell.teamAwayImageView.sd_setImage(with: url1)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        self.performSegue(withIdentifier: "toDetail", sender: nil)
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indexPath = self.scheduleTableView.indexPathForSelectedRow
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let result = formatter.string(from: date)
        if schedule[(indexPath?.row)!].date < result {
            let alertController = UIAlertController(title: "", message: "Mohon maaf untuk pertandingan ini sudah berlangsung", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
        }else {
            if segue.identifier == "toDetail" {
                let vc = segue.destination as! EPDetailScheduleViewController
                vc.teamAwayImg = schedule[(indexPath?.row)!].logoHome
                vc.teamHomeImg = schedule[(indexPath?.row)!].logoAway
                vc.teamHomeName = schedule[(indexPath?.row)!].title
                vc.date = schedule[(indexPath?.row)!].matchDescripction
                vc.time = schedule[(indexPath?.row)!].date
                vc.scheduleId = schedule[(indexPath?.row)!].id
                vc.schedule = schedule[(indexPath?.row)!]
                vc.userData = userData
                //            self.present(vc, animated: true, completion: nil)
                print(vc.userData.address)
                
            }
        }
    }
 
    func pullToRefresh() {
        loadData()
    }

}
