//
//  ViewController.swift
//  EventifyApp1
//
//  Created by Selin Şeker on 27.03.2024.
//

import UIKit
import FirebaseCore
import FirebaseAuth

class ViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func signupTiklandi(_ sender: Any) {
        
        if emailTextField.text != " " && passwordTextField.text != " " {
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { authdataresult, error in
                if error != nil{
                    self.hataMesajı(titleInput: "Hata", messageInput: error?.localizedDescription ?? "Hata aldınız tekrar deneyin")
                }
                else{
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
        }
        else{
            hataMesajı(titleInput: "Hata", messageInput: "Email ve şifre giriniz")
        }
    }
    
    @IBAction func loginTiklandi(_ sender: Any) {
        
        if emailTextField.text != " " && passwordTextField.text != " " {
            Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { authdataresult, error in
                if error != nil{
                    self.hataMesajı(titleInput: "Hata", messageInput: error?.localizedDescription ?? "Hata aldınız, tekrar deneyiniz")
                }
                else{
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
        }
        else{
            self.hataMesajı(titleInput: "Hata", messageInput: "Hata aldınız tekrar deneyin")
        }
    }
    
    func hataMesajı(titleInput: String, messageInput:String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    
}

