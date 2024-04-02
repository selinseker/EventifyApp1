import UIKit
import FirebaseFirestore

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var gorselDizisi = [String]()
    var yorumDizisi = [String]()
    var usernameDizisi = [String]()

    
    @IBOutlet weak var feedTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        if yorumDizisi.count >= usernameDizisi.count {
            firebaseVerileriAl()
        } else{
            hataMesaji(title: "Hata", message: "Hata oluştu")
        }
            
        feedTableView.delegate = self
        feedTableView.dataSource = self
    }
    
    func firebaseVerileriAl(){
        let firestoreDatabase = Firestore.firestore()
        
        firestoreDatabase.collection("Users").addSnapshotListener { snapshot, error in
            if error != nil {
                self.hataMesaji(title: "Hata", message: error?.localizedDescription ?? "Hata oluştu.")
            } else {
                if snapshot?.isEmpty != true && snapshot != nil{
                    for document in snapshot!.documents{
                        if let username = document.get("username") as? String{
                            self.usernameDizisi.append(username)
                        }
                    }
                }
            }
            
            
            firestoreDatabase.collection("Post").addSnapshotListener { snapshot, error in
                if error != nil {
                    self.hataMesaji(title: "Hata", message: error?.localizedDescription ?? "Hata oluştu.")
                } else{
                    if snapshot?.isEmpty != true && snapshot != nil {
                        for document in snapshot!.documents {
                            if let gorselUrl = document.get("gorselUrl") as? String{
                                self.gorselDizisi.append(gorselUrl)
                            }
                            if let yorum = document.get("yorum") as? String{
                                self.yorumDizisi.append(yorum)
                            }
                            
                        }
                        DispatchQueue.main.async {
                            self.feedTableView.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return yorumDizisi.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = feedTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedCell
        cell.YorumText.text = yorumDizisi[indexPath.row]
        cell.feedUsernameField.text = usernameDizisi[indexPath.row]
        cell.postImageView.image = UIImage(named: "ekle")
        return cell
    }
    
    func hataMesaji(title: String,message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
}
