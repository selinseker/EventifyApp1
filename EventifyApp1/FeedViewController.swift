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

           let headerHeight: CGFloat = 135
           let headerView = UIView(frame: CGRect(x: 0, y: 0, width: feedTableView.frame.width, height: headerHeight))

           headerView.backgroundColor = UIColor(red: 15/255, green: 34/255, blue: 45/255, alpha: 1.0)

           let logoImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 120, height: 120))
           logoImageView.contentMode = .scaleAspectFit
           logoImageView.image = UIImage(named: "saydamLogo")
           logoImageView.center = CGPoint(x: headerView.center.x, y: headerHeight * 0.4)
           headerView.addSubview(logoImageView)

           // Ayrı bölümün eklenmesi
        let sectionView = UIView(frame: CGRect(x: 0, y: logoImageView.frame.maxY , width: headerView.frame.width, height: 20))

        let etkinlikLabel = UILabel(frame: CGRect(x: 0, y: 0, width: sectionView.frame.width / 2, height: sectionView.frame.height))
        etkinlikLabel.center.y = sectionView.frame.height / 2 - 15
        etkinlikLabel.textAlignment = .center
        etkinlikLabel.textColor = .white
        etkinlikLabel.text = "Etkinlikler"
        sectionView.addSubview(etkinlikLabel)

        let ozelLabel = UILabel(frame: CGRect(x: sectionView.frame.width / 2, y: 0, width: sectionView.frame.width / 2, height: sectionView.frame.height))
        ozelLabel.center.y = sectionView.frame.height / 2 - 15
        ozelLabel.textAlignment = .center
        ozelLabel.textColor = .white
        ozelLabel.text = "Sana Özel"
        sectionView.addSubview(ozelLabel)

        headerView.addSubview(sectionView)

        feedTableView.tableHeaderView = headerView

        etkinlikLabel.isUserInteractionEnabled = true
        let etkinlikTapGesture = UITapGestureRecognizer(target: self, action: #selector(etkinlikLabelTapped))
        etkinlikLabel.addGestureRecognizer(etkinlikTapGesture)

        ozelLabel.isUserInteractionEnabled = true
        let ozelTapGesture = UITapGestureRecognizer(target: self, action: #selector(ozelLabelTapped))
        ozelLabel.addGestureRecognizer(ozelTapGesture)
        
       }
    
    @objc func etkinlikLabelTapped(){
        print("etkinliklabel tıklandı")
        if let sectionView = feedTableView.tableHeaderView?.subviews.first as? UIView {
            // Burada sectionView kullanılabilir
            if let etkinlikLabel = sectionView.subviews.first(where: { ($0 as? UILabel)?.text == "Etkinlikler" }) as? UILabel {
                etkinlikLabel.backgroundColor = .yellow
            }
        }
    }
    
    @objc func ozelLabelTapped(){
        print("ozelLabel tıklandı")
        if let sectionView = feedTableView.tableHeaderView,
                  let ozelLabel = sectionView.subviews.first(where: { ($0 as? UILabel)?.text == "Sana Özel" }) as? UILabel {
                   ozelLabel.backgroundColor = .yellow
               }
        
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
