//
//  ProfileViewController.swift
//  EventifyApp1
//
//  Created by Selin Şeker on 9.04.2024.
//

import UIKit
import FirebaseAuth


class ProfileViewController: UIViewController, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        UICollectionViewCell()
    }
    

    @IBOutlet weak var collecitonView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collecitonView.dataSource = self
        
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
    

