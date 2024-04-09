import UIKit
import FirebaseFirestore
import FirebaseAuth
import SDWebImage

struct FeedData {
    var username: String
    var yorum: String
    var gorselUrl: String
    var uid: String
}

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var feedTableView: UITableView!
    var feedDataArray = [FeedData]()

  

    override func viewDidLoad() {
        super.viewDidLoad()

        feedTableView.delegate = self
        feedTableView.dataSource = self
        firebaseVerileriAl()
        
        let headerHeight: CGFloat = 80
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: feedTableView.frame.width, height: headerHeight))

        headerView.backgroundColor = UIColor(red: 15/255, green: 34/255, blue: 45/255, alpha: 1.0)
        
        let logoImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.image = UIImage(named: "saydamLogo")
        logoImageView.center = headerView.center

        
        headerView.addSubview(logoImageView)

        feedTableView.tableHeaderView = headerView

    }

    func firebaseVerileriAl() {
        let firestoreDatabase = Firestore.firestore()

        firestoreDatabase.collection("Post").order(by: "tarih", descending: true).addSnapshotListener { snapshot, error in
            if let error = error {
                self.hataMesaji(title: "Hata", message: error.localizedDescription)
            } else if let snapshot = snapshot {

                self.feedDataArray.removeAll()

                for document in snapshot.documents {
                    if let gorselurl = document.get("gorselurl") as? String,
                       let yorum = document.get("yorum") as? String,
                       let uid = document.get("uid") as? String {
                       let feedData = FeedData(username: "", yorum: yorum, gorselUrl: gorselurl, uid: uid) // Kullanıcı ID'sini feedData yapısına ekledik
                       self.feedDataArray.append(feedData)
                    }
                }

                DispatchQueue.main.async {
                    self.feedTableView.reloadData()
                    // Verileri aldıktan sonra kullanıcı adlarını güncelle
                    self.updateUsernames()
                }
            }
        }
    }

    func updateUsernames() {
        let firestoreDatabase = Firestore.firestore()

        for (index, feedData) in feedDataArray.enumerated() {
            let uid = feedData.uid

            firestoreDatabase.collection("Users").document(uid).getDocument { document, error in
                if let error = error {
                    print("Kullanıcı adı alınamadı: \(error.localizedDescription)")
                    return
                }

                if let document = document, document.exists {
                    if let username = document.get("username") as? String {
                        self.feedDataArray[index].username = username
                        DispatchQueue.main.async {
                            self.feedTableView.reloadData()
                        }
                    }
                } else {
                    print("Belge bulunamadı.")
                }
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
