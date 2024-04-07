import UIKit
import FirebaseFirestore
import FirebaseAuth
import SDWebImage

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var gorselDizisi = [String]()
    var yorumDizisi = [String]()
   

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
                       
                    }
                    DispatchQueue.main.async {
                         self.feedTableView.reloadData()
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

