//
//  BookingTicketViewController.swift
//  Eticket Persib
//
//  Created by Apit on 6/8/17.
//  Copyright © 2017 Apit. All rights reserved.
//

import UIKit
import CoreData
import PKHUD

protocol BookingAlertDelegate {
    func doneAlert()
}
class BookingTicketViewController: UIViewController {

    
    @IBOutlet weak var matchNameLabel: UILabel!
    @IBOutlet weak var ticketNameLabel: UILabel!
    @IBOutlet weak var priceTicketLabel: UILabel!
    @IBOutlet weak var adminPriceLabel: UILabel!
    var delgate: BookingAlertDelegate!
    var matchName: String!
    var ticketName: String!
    var price: String!
    var adminPrice: String!
    var ticketId: String!
    var user = [User]()
    var userData = UserData()
    var schedule = Schedule()
    var email: String!
    var password: String!
    var transaction = [Transaction]()
    var isOrder = false
    var managedObjectContext: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        contentSizeInPopup = CGSize(width: 300, height: 300)
        loadData()
//        loadUserData()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadData() {
        matchNameLabel.text = matchName
        ticketNameLabel.text = ticketName
        priceTicketLabel.text = price
        adminPriceLabel.text = adminPrice
//        print ("--------\(userData.address)")
        let address = UserDefaults.standard.string(forKey: "address")
        print ("--------\(address)")
    }

    @IBAction func onClickConfirm(_ sender: Any) {
//        HUD.flash(.label("Sending request…"), delay: 2.0) { _ in
//            let transaction = Transaction(context: self.managedObjectContext)
//            transaction.matchName = self.matchName
//            transaction.ticketName = self.ticketName
//            transaction.ticketPrice = self.price
//            do {
//                try self.managedObjectContext.save()
//                self.backTouch()
//                HUD.flash(.success, delay: 1.0)
//            }catch{
//                HUD.flash(.error, delay: 1.0)
//                print("---------\(error.localizedDescription)")
//            }
//        }
        HUD.flash(.label("Sending request…"), delay: 2.0) { _ in
            let userId = UserDefaults.standard.string(forKey: "userId")
            let parameter:[String:String] = ["user_id":userId!, "ticket_id":self.ticketId!]
            
            WebService.currentController = self
            WebService.POST(url: WebService.booking, queryString: parameter, headers: [:], success: { (json) in
                let message = json["data"]["message"].stringValue
                let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: { (aler) in
                    self.dismissAlert()
                })
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            }) { (error) in
                print("====\(error)")
            }
        }
    }
    
    func loadUserData() {
        do {
            let userRequest:NSFetchRequest<User> = User.fetchRequest()
            user = try managedObjectContext.fetch(userRequest)
            for users in user {
                userData.email = users.email
                password = users.password
            }
        }catch {
            print(error.localizedDescription)
        }
    }
    
    func backTouch() {
        popupController?.dismiss()
    }
    
    func dismissAlert() {
        popupController?.dismiss(completion: { 
            self.delgate.doneAlert()
        })
    }

    @IBAction func onClickCancel(_ sender: Any) {
        popupController?.dismiss()
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
