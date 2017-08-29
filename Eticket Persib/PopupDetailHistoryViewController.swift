//
//  PopupDetailHistoryViewController.swift
//  Eticket Persib
//
//  Created by Apit on 8/15/17.
//  Copyright © 2017 Apit. All rights reserved.
//

import UIKit
import PKHUD

protocol DetailHistoryDelegate {
    func doneAlert()
}

class PopupDetailHistoryViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var matchLabel: UILabel!
    @IBOutlet weak var resiNumberLabel: UILabel!
    @IBOutlet weak var categoryTiketLabel: UILabel!
    @IBOutlet weak var dateOrderLabel: UILabel!
    @IBOutlet weak var matchDayLabel: UILabel!
    @IBOutlet weak var subtotalLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var addImageButton: UIButton!
    @IBOutlet weak var imgView: UIImageView!
    var backButtonItem:UIBarButtonItem!
    var ticketName: String!
    var history = History()
    var delegate: DetailHistoryDelegate!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backArrow = UIButton(frame: CGRect(x:0, y:0, width:25, height:25))
        backArrow.addTarget(self, action: #selector(backTouchUp), for: UIControlEvents.touchUpInside)
        backArrow.setBackgroundImage(UIImage(named: "back_arrow"), for: UIControlState.normal)
        backButtonItem = UIBarButtonItem(customView: backArrow)
        self.navigationItem.leftBarButtonItem = backButtonItem

//        contentSizeInPopup = CGSize(width: 330, height: 500)
        loadData()
        // Do any additional setup after loading the view.
    }
    
    func loadData() {
        matchLabel.text = history.matchName
        resiNumberLabel.text = "No. Resi : " + history.noResi
        categoryTiketLabel.text = "Kategori Ticket : " + history.categoryTicket
        dateOrderLabel.text = "Tanggal Pemesanan : " + history.orderDate
        matchDayLabel.text = "Tanggal Pertandingan : " + history.matchDay
        subtotalLabel.text = "Subtotal : " + history.price
        if history.status == "0" {
            statusLabel.text = "Menunggu Pembayaran"
            statusLabel.textColor = UIColor.red
        }else if history.status == "1" {
            statusLabel.text = "Menunggu Verifikasi"
            statusLabel.textColor = UIColor.yellow
        }else if history.status == "2" {
            statusLabel.text = "Tiket Siap Ditukarkan"
            statusLabel.textColor = UIColor.green
            deleteButton.isHidden = true
            uploadButton.isHidden = true
            addImageButton.isEnabled = false
        }else if history.status == "3" {
            statusLabel.text = "Tiket Sudah Ditukarkan"
            statusLabel.textColor = UIColor.orange
            deleteButton.isHidden = true
            uploadButton.isHidden = true
            addImageButton.isEnabled = false
        }
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let result = formatter.string(from: date)
        if result > history.orderDate && history.status == "0" {
            statusLabel.text = "Tiket Kadaluarsa"
            statusLabel.textColor = UIColor.black
            deleteButton.isHidden = true
            uploadButton.isHidden = true
            addImageButton.isEnabled = false
        }
        if self.history.noResi == "" {
            uploadButton.isHidden = true
        }
        if history.imgUrl != "" {
            let url = URL(string: WebService.baseUrl + "images/" + history.imgUrl.replacingOccurrences(of: " ", with: "%20"))!
            imgView.sd_setImage(with: url)
        }else {
            imgView.image = UIImage(named: "add_photo")
        }
    }
    
    func backTouchUp() {
        dismissAlert()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func onClickClose(sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onClickDelete(sender: Any) {
        UIView.animate(withDuration: 0.2) { 
            self.imgView.image = UIImage(named: "add_photo")
            self.deleteButton.isHidden = true
            self.uploadButton.isHidden = true
        }
    }
    
    @IBAction func onClickUpload(sender: Any) {
        uploadToAPI()
    }
    
    @IBAction func onClickAddImage(sender: Any) {
        let alertController = UIAlertController(title: nil, message: "Choose Photo", preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action) in
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = UIImagePickerControllerSourceType.camera
            self.present(picker, animated: true, completion: nil)
        }
        let galleryAction = UIAlertAction(title: "Gallery", style: .default) { (action) in
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            self.present(picker, animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            // ...
        }
        alertController.addAction(cameraAction)
        alertController.addAction(galleryAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.imgView.contentMode = .scaleAspectFit
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        history.imgTransaction = image
        self.imgView.image = image
        self.deleteButton.isHidden = false
        if imgView.image != nil {
            self.uploadButton.isHidden = false
        }
        self.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func uploadToAPI() {
        HUD.flash(.systemActivity, delay: 2.0) { _ in
            let image = self.imageToBase64(image: self.history.imgTransaction)
            let parameter: [String: Any] = ["image": image, "id": self.history.idTransaction!]
            WebService.currentController = self
            WebService.POST(url: WebService.uploadImage, queryString: parameter, headers: [:], success: { (json) in
                HUD.flash(.success)
                self.dismiss(animated: true, completion: {
                    self.dismissAlert()
                })
            }) { (error) in
                HUD.flash(.error)
            }
        }
    }
    
    func dismissAlert() {
        popupController?.dismiss(completion: { 
            self.delegate.doneAlert()
        })
    }
    
    func imageToBase64(image:UIImage)->String{
        let data = UIImageJPEGRepresentation(image, 0.2)
        if data == nil{
            return ""
        }
        let string = data!.base64EncodedString()
        return string
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
