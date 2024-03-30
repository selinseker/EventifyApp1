//
//  SettingsViewController.swift
//  EventifyApp1
//
//  Created by Selin Şeker on 30.03.2024.
//

import UIKit
import FirebaseAuth

class SettingsViewController: UIViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
