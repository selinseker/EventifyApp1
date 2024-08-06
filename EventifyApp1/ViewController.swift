//
//  ViewController.swift
//  EventifyApp1
//
//  Created by Selin Şeker on 27.03.2024.
//

import UIKit
import FirebaseAuth


class ViewController: UIViewController {

    
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func loginTiklandi(_ sender: Any) {
        
        if emailTextField.text != "" && passwordTextField.text != "" {
            Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { authdataresult, error in
                if error != nil{
                    self.hataMesaji(titleInput: "Hata", messageInput: error?.localizedDescription ?? "Hata aldınız, tekrar deneyiniz")
                }
                else{
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
        }
        else{
            self.hataMesaji(titleInput: "Hata", messageInput: "Gerekli bilgileri giriniz")
        }
    }
    
    func hataMesaji(titleInput: String, messageInput:String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func toSignupTiklandi(_ sender: Any) {
        performSegue(withIdentifier: "toFeedVC", sender: nil)
    }
}

