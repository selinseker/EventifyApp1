//
//  SettingsViewController.swift
//  EventifyApp1
//
//  Created by Selin Şeker on 30.03.2024.
//

import UIKit
import FirebaseAuth

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var logoutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        logoutButton.layer.cornerRadius = 10
        logoutButton.layer.masksToBounds = true
    
        
    }
    
    
    @IBAction func logoutTiklandi(_ sender: Any) {
        
        
        do{
            try Auth.auth().signOut()
        } catch{
            print("Hata")
        }
        
        
        performSegue(withIdentifier: "toFirstViewController", sender: nil)
    }
    

}
