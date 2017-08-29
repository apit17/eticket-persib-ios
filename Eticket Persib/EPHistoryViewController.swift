//
//  EPHistoryViewController.swift
//  Eticket Persib
//
//  Created by Apit on 6/10/17.
//  Copyright © 2017 Apit. All rights reserved.
//

import UIKit
import CoreData
import STPopup
import PKHUD


class EPHistoryViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, DetailHistoryDelegate {

    @IBOutlet weak var historyTableView: UITableView!
    var transaction = [Transaction]()
    var managedObjectContext: NSManagedObjectContext!
    var refreshControl:UIRefreshControl!
    var history = [History]()
    override func viewDidLoad() {
        super.viewDidLoad()

//        self.addSlideMenuButton()
        setupMenuButton()
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(loadData), for: .valueChanged)
        historyTableView.addSubview(refreshControl)
        
        managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        historyTableView.delegate = self
        historyTableView.dataSource = self
        loadData()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
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
//            let transactionRequest:NSFetchRequest<Transaction> = Transaction.fetchRequest()
//            do {
//                self.transaction = try self.managedObjectContext.fetch(transactionRequest)
//                self.historyTableView.reloadData()
//                self.refreshControl.endRefreshing()
//            }catch {
//                self.refreshControl.endRefreshing()
//                HUD.flash(.error)
//                print(error.localizedDescription)
//            }
            let userId = UserDefaults.standard.string(forKey: "userId")
            let parameter:[String:String] = ["user_id":userId!]
            WebService.currentController = self
            WebService.GET(url: WebService.getHistory, param: parameter, headers: [:], hud: true, hudString: "Load data", success: { (json) in
                let data = json["data"].arrayValue
                self.history = [History]()
                for datas in data {
                    let history = History()
                    history.matchName = datas["schedule"]["schedule_match"].stringValue
                    history.noResi = datas["transaction_resi_number"].stringValue
                    history.price = datas["transaction_price"].stringValue
                    history.status = datas["transaction_resi_status"].stringValue
                    history.matchDay = datas["schedule"]["schedule_date_match"].stringValue
                    history.orderDate = datas["transaction_date"].stringValue
                    history.startDate = datas["schedule"]["schedule_start_date"].stringValue
                    history.imgUrl = datas["transaction_proof_image"].stringValue
                    history.idTransaction = datas["id"].stringValue
                    history.categoryTicket = datas["ticket"]["ticket_name"].stringValue
                    self.history.append(history)
                }
                self.historyTableView.reloadData()
                self.refreshControl.endRefreshing()
            }) { (error) in
                let alert = UIAlertController(title: "", message: error.desc, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
                self.refreshControl.endRefreshing()
            }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return history.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! EPHistoryTableViewCell
        let transactionItem = history[indexPath.row]
        cell.matchNameLabel.text = "Pertandingan :" + transactionItem.matchName
        cell.ticketNameLabel.text = "Nomor Resi :" + transactionItem.noResi
        cell.ticketPriceLabel.text = "Harga Ticket :" + "Rp.\(transactionItem.price!)"
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let result = formatter.string(from: date)
        
        if transactionItem.status == "0" {
            cell.statusLabel.text = "Menunggu Pembayaran"
            cell.statusLabel.textColor = UIColor.red
        }else if transactionItem.status == "1" {
            cell.statusLabel.text = "Menunggu Verifikasi"
            cell.statusLabel.textColor = UIColor.yellow
        }else if transactionItem.status == "2" {
            cell.statusLabel.text = "Tiket Siap Ditukarkan"
            cell.statusLabel.textColor = UIColor.green
        }else if transactionItem.status == "3" {
            cell.statusLabel.text = "Tiket Sudah Ditukarkan"
            cell.statusLabel.textColor = UIColor.orange
        }
        if result > transactionItem.orderDate && transactionItem.status == "0" {
            cell.statusLabel.text = "Tiket Kadaluarsa"
            cell.statusLabel.textColor = UIColor.black
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let transactionItem = history[indexPath.row]
        let alert = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PopupDetailHistoryViewController") as! PopupDetailHistoryViewController
        let navbar = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EticketNavigationViewController") as! EticketNavigationViewController
        alert.history = transactionItem
        alert.delegate = self
        navbar.setViewControllers([alert], animated: true)
//        let popupController:STPopupController = STPopupController(rootViewController: alert)
//        popupController.navigationBar.isHidden = true
//        popupController.containerView.backgroundColor = UIColor.clear
//        popupController.present(in: self)
        present(alert, animated: true, completion: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func doneAlert() {
//        loadData()
    }
    
    @IBAction func onClickMenu(_ sender: Any) {
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
