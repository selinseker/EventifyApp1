import UIKit
import FirebaseFirestore
import FirebaseAuth
import SDWebImage

struct FeedData {
    var username: String
    var yorum: String
    var gorselUrl: String
}

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var feedDataArray = [FeedData]()

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
            if let error = error {
                self.hataMesaji(title: "Hata", message: error.localizedDescription)
            } else if let snapshot = snapshot {
                self.feedDataArray.removeAll()

                for document in snapshot.documents {
                    if let gorselurl = document.get("gorselurl") as? String,
                       let yorum = document.get("yorum") as? String,
                       let uid = document.get("uid") as? String {
                       self.getUsernameAndAddToFeedData(uid: uid, gorselurl: gorselurl, yorum: yorum)
                    }
                }
            }
        }
    }

    func getUsernameAndAddToFeedData(uid: String, gorselurl: String, yorum: String) {
        let firestoreDatabase = Firestore.firestore()

        firestoreDatabase.collection("Users").document(uid).getDocument { document, error in
            if let error = error {
                print("Kullanıcı adı alınamadı: \(error.localizedDescription)")
                return
            }

            if let document = document, document.exists {
                if let username = document.get("username") as? String {
                    let feedData = FeedData(username: username, yorum: yorum, gorselUrl: gorselurl)
                    self.feedDataArray.append(feedData)
                    DispatchQueue.main.async {
                        self.feedTableView.reloadData()
                    }
                }
            } else {
                print("Belge bulunamadı.")
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedDataArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
            let cell = feedTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedCell
            let feedData = feedDataArray[indexPath.row]
            cell.YorumText.text = feedData.yorum
            cell.feedUsernameField.text = feedData.username
            cell.postImageView.sd_setImage(with: URL(string: feedData.gorselUrl))
            return cell
        
        
    }
    
    func hataMesaji(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    
}
