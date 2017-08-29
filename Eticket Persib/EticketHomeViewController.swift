//
//  EticketHomeViewController.swift
//  Eticket Persib
//
//  Created by Apit on 8/8/17.
//  Copyright © 2017 Apit. All rights reserved.
//

import UIKit
import PKHUD

class EticketHomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var containerController:EticketHomeContainerViewController!
    var tableType:String!
    var array = [Any]()
    var schedule = [Schedule]()
    var history = [History]()
    @IBOutlet weak var tblView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadData()
    }

    func loadData() {
        if tableType == "Dashboard" {
            
        }else if tableType == "Schedule" {
            HUD.flash(.label("Requesting Data…"), delay: 2.0) { _ in
                WebService.currentController = self
                WebService.GET(url: WebService.urlAPI + "schedule", param: [:], headers: [:], hud: true, hudString: "Load data", success: { (json) in
                    let data = json["data"].arrayValue
                    self.schedule = [Schedule]()
                    for datas in data {
                        let schedule = Schedule()
                        schedule.matchDescripction = datas["description"].stringValue
                        schedule.logoHome = datas["image1"].stringValue
                        schedule.logoAway = datas["image2"].stringValue
                        schedule.title = datas["title"].stringValue
                        schedule.date = datas["date"].stringValue
                        let ticketId = datas["id"].stringValue
                        UserDefaults.standard.set(ticketId, forKey: "ticketId")
                        self.array.append(schedule)
                    }
                    self.tblView.reloadData()
                }) { (error) in
                    let alert = UIAlertController(title: "", message: error.desc, preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }else if tableType == "History" {
            HUD.flash(.label("Requesting Data…"), delay: 2.0) { _ in
                let userId = UserDefaults.standard.string(forKey: "userId")
                let parameter:[String:String] = ["user_id":userId!]
                WebService.currentController = self
                WebService.GET(url: WebService.urlAPI + "transaction", param: parameter, headers: [:], hud: true, hudString: "Load data", success: { (json) in
                    let data = json["data"].arrayValue
                    self.history = [History]()
                    for datas in data {
                        let history = History()
                        history.matchName = datas["code"].stringValue
                        history.ticketName = datas["no_resi"].stringValue
                        history.price = datas["total"].stringValue
                        self.history.append(history)
                    }
                    self.tblView.reloadData()
                }) { (error) in
                    let alert = UIAlertController(title: "", message: error.desc, preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }else {
            
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableType == "Dashboard" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as! EPListNewsTableViewCell
            cell.personNews.text = ""
            cell.titleNews.text = ""
            return cell
        }else if tableType == "Schedule" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleCell", for: indexPath) as! EPScheduleTableViewCell
            let schedule = array[indexPath.row] as! Schedule
            cell.dateLabel.text = schedule.matchDescripction
            cell.timeMatchLabel.text = schedule.date
            cell.teamAwayLabel.text = schedule.title
            let url = URL(string: WebService.baseUrl + "images/" + schedule.logoHome.replacingOccurrences(of: " ", with: "%20"))!
            let url1 = URL(string: WebService.baseUrl + "images1/" + schedule.logoAway.replacingOccurrences(of: " ", with: "%20"))!
            cell.teamHomeImageView.sd_setImage(with: url)
            cell.teamAwayImageView.sd_setImage(with: url1)
            return cell
        }else if tableType == "History" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath) as! EPHistoryTableViewCell
            let transactionItem = array[indexPath.row] as! History
            cell.matchNameLabel.text = "Code Transaksi " + transactionItem.matchName
            cell.ticketNameLabel.text = "Nomor Resi " + transactionItem.ticketName
            cell.ticketPriceLabel.text = "Harga Ticket " + "Rp.\(transactionItem.price!)"
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! EPListNewsTableViewCell
            cell.personNews.text = ""
            cell.titleNews.text = ""
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
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
