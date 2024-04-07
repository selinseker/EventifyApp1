//
//  SignupVC.swift
//  EventifyApp1
//
//  Created by Selin Şeker on 2.04.2024.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore


class SignupVC: UIViewController {
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    
    @IBAction func signupTiklandi(_ sender: Any) {
        
        
        print("Signup button tapped")
        
        if emailTextField.text != "" && passwordTextField.text != "" && nameTextField.text != "" {
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { authdataresult, error in
                if error != nil{
                    self.hataMesaji(titleInput: "Hata", messageInput: error?.localizedDescription ?? "Lütfen gerekli bilgileri doldurup tekrar deneyin")
                }
                else {
                    let user = authdataresult?.user
                    
                    let db = Firestore.firestore()
                    
                    let userData = [
                        "name": self.nameTextField.text!,
                        "username": self.usernameTextField.text!,
                        "email": self.emailTextField.text!,
                        "uid": user!.uid
                    ]
                    
                    db.collection("Users").document(user!.uid).setData(userData) { [self] error in
                        if error != nil{
                            hataMesaji(titleInput: "Hata", messageInput: error?.localizedDescription ?? "Hata aldınız tekrar deneyiniz")
                        } else{
                            
                            self.nameTextField.text = ""
                            self.emailTextField.text = ""
                            self.passwordTextField.text = ""
                            self.usernameTextField.text = ""
                            
                            
                            self.performSegue(withIdentifier: "signupToFeedVC", sender: nil)
                        }
                    }
                    
                }
                    
                }
            }
        }
    
    func hataMesaji(titleInput: String, messageInput:String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    


}
