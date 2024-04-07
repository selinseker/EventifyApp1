import UIKit
import FirebaseFirestore
import FirebaseAuth
import SDWebImage

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var gorselDizisi = [String]()
    var yorumDizisi = [String]()
    var usernameDizisi = [String]()
   

    @IBOutlet weak var feedTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        firebaseVerileriAl()
        feedTableView.delegate = self
        feedTableView.dataSource = self
    }

    func firebaseVerileriAl() {
        let firestoreDatabase = Firestore.firestore()

        firestoreDatabase.collection("Post").addSnapshotListener { snapshot, error in
            if error != nil {
                self.hataMesaji(title: "Hata", message: error?.localizedDescription ?? "Hata oluştu.")
            } else {
                if let snapshot = snapshot, !snapshot.isEmpty {
                    self.gorselDizisi.removeAll()
                    self.yorumDizisi.removeAll()
                    

                    for document in snapshot.documents {
                        if let gorselurl = document.get("gorselurl") as? String {
                            self.gorselDizisi.append(gorselurl)
                        }
                        if let yorum = document.get("yorum") as? String {
                            self.yorumDizisi.append(yorum)
                        }
                        if let uid = document.get("uid") as? String {
                            self.getUsernameForUID(uid)
                        }
                       
                    }
                    DispatchQueue.main.async {
                         self.feedTableView.reloadData()
                                       }
                }
            }
        }
    }
    
    func getUsernameForUID(_ uid: String) {
        let firestoreDatabase = Firestore.firestore()
        firestoreDatabase.collection("Users").whereField("uid", isEqualTo: uid).getDocuments { snapshot, error in
            if let error = error {
                print("Hata oluştu: \(error.localizedDescription)")
                return
            }
            
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    if let username = document.get("username") as? String {
                        self.usernameDizisi.append(username)
                    }
                }
            } else {
                print("Belge bulunamadı.")
            }
        }
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return yorumDizisi.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = feedTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedCell
        cell.YorumText.text = yorumDizisi[indexPath.row]
        
        if indexPath.row < usernameDizisi.count {
                cell.feedUsernameField.text = usernameDizisi[indexPath.row]
                } else {
                    cell.feedUsernameField.text = ""
                }
        
        cell.postImageView.sd_setImage(with: URL(string: self.gorselDizisi[indexPath.row]))
        return cell
    }

    func hataMesaji(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
}
