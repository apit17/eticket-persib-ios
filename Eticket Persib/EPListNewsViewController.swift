//
//  EPListNewsViewController.swift
//  Eticket Persib
//
//  Created by Apit on 6/6/17.
//  Copyright © 2017 Apit. All rights reserved.
//

import UIKit
import CoreData

class EPListNewsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var present = [Present]()
    var managedObjectContext: NSManagedObjectContext!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buttonNew: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        let logoutButton = UIButton(frame: CGRect(x:0, y:0, width:25, height:25))
        logoutButton.addTarget(self, action: #selector(logout), for: UIControlEvents.touchUpInside)
        logoutButton.setBackgroundImage(UIImage(named: "back_arrow"), for: UIControlState.normal)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: logoutButton)
        managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        loadData()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.addSubview(buttonNew)
        buttonNew.layer.cornerRadius = 0.5 * buttonNew.bounds.size.width
        buttonNew.layer.shadowOffset = CGSize(width: 3.0, height: 3.0)
        buttonNew.layer.shadowOpacity = 3.0
        buttonNew.layer.shadowColor = UIColor.gray.cgColor
        buttonNew.isEnabled = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func logout() {
        print("logout")
    }
    
    func loadData() {
        let presentRequest:NSFetchRequest<Present> = Present.fetchRequest()
        do {
            present = try managedObjectContext.fetch(presentRequest)
            self.tableView.reloadData()
        }catch {
            print(error.localizedDescription)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return present.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! EPListNewsTableViewCell
        let presentItem = present[indexPath.row]
        if let presentImage = UIImage(data: presentItem.image! as Data) {
            cell.imageNews.image = presentImage
        }
        cell.personNews.text = presentItem.person
        cell.titleNews.text = presentItem.presentName
        return cell
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            picker.dismiss(animated: true, completion: { 
                self.createItem(with: image)
            })
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func createItem(with image: UIImage) {
        let presentItem = Present(context: managedObjectContext)
        presentItem.image = NSData(data: UIImageJPEGRepresentation(image, 0.3)!)
        let inputAlert = UIAlertController(title: "New Present", message: "Enter a person and a present", preferredStyle: .alert)
        inputAlert.addTextField { (textField) in
            textField.placeholder = "Person"
        }
        inputAlert.addTextField { (textField) in
            textField.placeholder = "Present"
        }
        inputAlert.addAction(UIAlertAction(title: "Save", style: .default, handler: { (action) in
            let personTextField = inputAlert.textFields?.first
            let presentTextField = inputAlert.textFields?.last
            if personTextField?.text != "" && presentTextField?.text != "" {
                presentItem.person = personTextField?.text
                presentItem.presentName = presentTextField?.text
                do {
                    try self.managedObjectContext.save()
                    self.loadData()
                }catch{
                    print("---------\(error.localizedDescription)")
                }
            }
        }))
        inputAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(inputAlert, animated: true, completion: nil)
    }
    
    @IBAction func addPresent(_ sender: Any) {
        let alert = UIAlertController(title: "", message: "Select Photo", preferredStyle: .actionSheet)
        let photoAction = UIAlertAction(title: "Library", style: .default) { (action) in
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action) in
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            self.present(imagePicker, animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            
        }
        alert.addAction(photoAction)
        alert.addAction(cameraAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
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
