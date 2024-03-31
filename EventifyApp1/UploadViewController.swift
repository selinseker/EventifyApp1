//
//  UploadViewController.swift
//  EventifyApp1
//
//  Created by Selin Şeker on 30.03.2024.
//

import UIKit
import Photos
import PhotosUI
import FirebaseCore
import FirebaseStorage
import FirebaseFirestore
import FirebaseAuth

let uuid = UUID().uuidString

class UploadViewController: UIViewController, PHPickerViewControllerDelegate, UINavigationBarDelegate {
    
    @IBOutlet weak var yorumTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(gorselSec) )
        imageView.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func gorselSec(){
        var config = PHPickerConfiguration()
        config.selectionLimit = 1
        
        let PHPickerVC = PHPickerViewController(configuration: config)
        PHPickerVC.delegate = self
        self.present(PHPickerVC, animated: true)
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        guard let selectedImage = results.first else { return }
        
        selectedImage.itemProvider.loadObject(ofClass: UIImage.self) { (object, error) in
            if let error = error {
                print("Error loading image: \(error.localizedDescription)")
            } else if let image = object as? UIImage {
                DispatchQueue.main.async {
                    self.imageView.image = image
                }
            }
        }
        
        dismiss(animated: true)
        
    }
    
    @IBAction func imageUploadTiklandi(_ sender: Any){
        
        let storage = Storage.storage()
        let storageReferance = storage.reference()
        
        let mediaFolder = storageReferance.child("media")
        
        if let data = imageView.image?.jpegData(compressionQuality: 0.5){
            let imageReference = mediaFolder.child("\(uuid).jpg")
            imageReference.putData(data, metadata: nil) { storagemetadata, error in
                if error != nil{
                    self.hataMesajiGoster(title: "Hata", message: error?.localizedDescription ?? "Hata aldınız tekrar deneyiniz")
                } else{
                    imageReference.downloadURL { url, error in
                        if error == nil{
                            let imageUrl = url?.absoluteString
                            print(imageUrl ?? "defaultvalue")
                            
                            if let imageUrl = imageUrl{
                                let firestoreDatabase = Firestore.firestore()
                               
                                let firestorePost = ["gorselurl": imageUrl, "yorum": self.yorumTextField.text!,"email": Auth.auth().currentUser!.email!,"tarih": FieldValue.serverTimestamp()]
                                
                                firestoreDatabase.collection("Post").addDocument(data: firestorePost) { error in
                                    if error != nil{
                                        self.hataMesajiGoster(title: "Hata", message: error?.localizedDescription ?? "Hata aldınız tekrar deneyiniz")
                                    }
                                }
                            
                            }
                            
                        }
                    }
                }
            }
        }
    }
    
    func hataMesajiGoster(title: String,message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
}
