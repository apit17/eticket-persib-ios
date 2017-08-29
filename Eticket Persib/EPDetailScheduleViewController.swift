//
//  EPDetailScheduleViewController.swift
//  Eticket Persib
//
//  Created by Apit on 6/8/17.
//  Copyright © 2017 Apit. All rights reserved.
//

import UIKit
import STPopup

class EPDetailScheduleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, BookingAlertDelegate {

    var teamAwayImg: String!
    var teamHomeImg: String!
    var teamAwayName: String!
    var teamHomeName: String!
    var scheduleId: String!
    var date: String!
    var time: String!
    var ticket: [Ticket] = [Ticket]()
    var userData = UserData()
    var schedule = Schedule()
    var startDate: String!
    var refreshControl: UIRefreshControl!
    @IBOutlet weak var teamAwayImage: UIImageView!
    @IBOutlet weak var teamAwayNameLabel: UILabel!
    @IBOutlet weak var teamHomeNameLabel: UILabel!
    @IBOutlet weak var teamHomeImage: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var ticketTableView: UITableView!
    var dateAvailable: [String] = ["23 Mei 2017 - 08 Juni 2017", "10 Juni 2017 - 14 Juni 2017"]
    var seatCategory: [String] = ["VIP Bawah", "VIP Atas"]
    var ticketPrice: [String] = ["Rp. 208.000", "Rp. 190.000"]
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Booking Tiket"
        ticketTableView.delegate = self
        ticketTableView.dataSource = self
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        ticketTableView.addSubview(refreshControl)
        loadData()
        // Do any additional setup after loading the view.
    }
    
    func configView() {
        let schedule = Schedule()
        let url = URL(string: WebService.baseUrl + "images/" + schedule.logoHome!.replacingOccurrences(of: " ", with: "%20"))!
        let url1 = URL(string: WebService.baseUrl + "images1/" + schedule.logoAway!.replacingOccurrences(of: " ", with: "%20"))!
        teamAwayImage.sd_setImage(with: url1)
        teamHomeImage.sd_setImage(with: url)
        teamHomeNameLabel.text = schedule.matchDescripction
        dateLabel.text = schedule.date
        timeLabel.text = schedule.date
    }

    func loadData() {
        print ("--------\(userData.address)")
        WebService.currentController = self
        WebService.GET(url: WebService.getTicket, param: ["id":scheduleId!], headers: [:], hud: true, hudString: "Load data", success: { (json) in
            let data = json["data"]["schedule_detail"]["tickets"].arrayValue
            let schedule = Schedule()
            let schedules = json["data"]["schedule_detail"]
            schedule.matchDescripction = schedules["schedule_stadion"].stringValue
            schedule.title = schedules["schedule_match"].stringValue
            schedule.date = schedules["schedule_date_match"].stringValue
            schedule.logoAway = schedules["schedule_away_image"].stringValue
            schedule.logoHome = schedules["schedule_home_image"].stringValue
            schedule.startDate = schedules["schedule_start_date"].stringValue
            let url = URL(string: WebService.baseUrl + "images/" + schedule.logoHome!.replacingOccurrences(of: " ", with: "%20"))!
            let url1 = URL(string: WebService.baseUrl + "images1/" + schedule.logoAway!.replacingOccurrences(of: " ", with: "%20"))!
            self.teamAwayImage.sd_setImage(with: url1)
            self.teamHomeImage.sd_setImage(with: url)
            self.teamHomeNameLabel.text = schedule.title
            self.dateLabel.text = schedule.matchDescripction
            self.timeLabel.text = schedule.date
            self.startDate = schedule.startDate
            self.ticket = [Ticket]()
            for datas in data {
                let ticket = Ticket()
                ticket.category = datas["ticket_name"].stringValue
                ticket.match = json["data"]["schedule_detail"]["schedule_match"].stringValue
                ticket.price = datas["ticket_price"].intValue
                ticket.ticketId = datas["id"].stringValue
                ticket.stock = datas["ticket_stock"].intValue
                self.ticket.append(ticket)
            }
            self.ticketTableView.reloadData()
            self.refreshControl.endRefreshing()
        }) { (error) in
            let alert = UIAlertController(title: "", message: error.desc, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            self.refreshControl.endRefreshing()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ticket.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! EPTicketTableViewCell
        cell.dateAvailable.text = "Stock Tiket :  \(ticket[indexPath.row].stock!)"
        cell.seatCategoryLabel.text = ticket[indexPath.row].category
        let price = ticket[indexPath.row].price.formattedWithSeparator
        cell.priceLabel.text = "Rp. \(price)"
        if ticket[indexPath.row].stock > 10 {
            cell.stockStatus.backgroundColor = UIColor.green
        }else if ticket[indexPath.row].stock > 1{
            cell.stockStatus.backgroundColor = UIColor.yellow
        }else if ticket[indexPath.row].stock < 1{
            cell.stockStatus.backgroundColor = UIColor.red
        }
        cell.readyOnLabel.text = "Ready on\n"+self.startDate!
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if ticket[indexPath.row].stock < 1 {
            let alert = UIAlertController(title: "", message: "Mohon maaf stok tiket untuk kategori ini sudah habis, silahkan pilih kategori tiket yang lain", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                self.loadData()
            })
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }else {
            let alert = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BookingTicketViewController") as! BookingTicketViewController
            let popupController:STPopupController = STPopupController(rootViewController: alert)
            alert.matchName = teamHomeName
            alert.ticketName = ticket[indexPath.row].category
            let price = ticket[indexPath.row].price.formattedWithSeparator
            alert.price = "Rp. \(price)"
            alert.ticketId = ticket[indexPath.row].ticketId
            alert.adminPrice = "Rp. 5000"
            alert.schedule = schedule
            alert.delgate = self
            popupController.navigationBar.isHidden = true
            popupController.containerView.backgroundColor = UIColor.clear
            popupController.present(in: self)
        }
//        let userId = UserDefaults.standard.string(forKey: "userId")
//        let isOrder = UserDefaults.standard.string(forKey: "isOrder")
//        if isOrder ==  userId{
//            let alert = UIAlertController(title: "", message: "Mohon maaf anda hanya bisa membeli 1 tiket", preferredStyle: .alert)
//            let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
//            alert.addAction(okAction)
//            self.present(alert, animated: true, completion: nil)
//            tableView.deselectRow(at: indexPath, animated: true)
//        }else{
//            popupController.navigationBar.isHidden = true
//            popupController.containerView.backgroundColor = UIColor.clear
//            popupController.present(in: self)
//            tableView.deselectRow(at: indexPath, animated: true)
//        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    

    func pullToRefresh() {
        loadData()
    }
    
    func doneAlert() {
        loadData()
    }

}

extension Formatter {
    static let withSeparator: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = "."
        formatter.numberStyle = .decimal
        return formatter
    }()
}

extension Integer {
    var formattedWithSeparator: String {
        return Formatter.withSeparator.string(for: self) ?? ""
    }
}
