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
    
    
    @IBOutlet weak var feedTableView: UITableView!
    
    var feedDataArray = [FeedData]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firebaseVerileriAl()
        feedTableView.delegate = self
        feedTableView.dataSource = self
        
        setupHeaderCell()
        
    }
    
    private func setupHeaderCell() {
        let headerCell = UITableViewCell()
        headerCell.contentView.backgroundColor = .clear
        
        // Logo ImageView
        let logoImageView = UIImageView(image: UIImage(named: "saydamLogoFoto"))
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        // Search Button
        let searchButton = UIButton(type: .custom)
        searchButton.setImage(UIImage(named: "searchIcon"), for: .normal)
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        
        headerCell.contentView.addSubview(logoImageView)
        headerCell.contentView.addSubview(searchButton)
        
        NSLayoutConstraint.activate([
            // Logo constraints
            logoImageView.centerYAnchor.constraint(equalTo: headerCell.contentView.centerYAnchor),
            logoImageView.centerXAnchor.constraint(equalTo: headerCell.contentView.centerXAnchor, constant: -1), // Centered with an offset to the left
            logoImageView.widthAnchor.constraint(equalToConstant: 100), // Adjust width as needed
            logoImageView.heightAnchor.constraint(equalToConstant: 55), // Adjust height as needed

            // Search button constraints
            searchButton.centerYAnchor.constraint(equalTo: headerCell.contentView.centerYAnchor),
            searchButton.leadingAnchor.constraint(equalTo: logoImageView.trailingAnchor, constant: 8), // 8 points between logo and button
            searchButton.trailingAnchor.constraint(equalTo: headerCell.contentView.trailingAnchor, constant: -10), // 10 points from right edge
            searchButton.widthAnchor.constraint(equalToConstant: 27), // Adjust width as needed
            searchButton.heightAnchor.constraint(equalToConstant: 27) // Adjust height as needed
        ])
        
        // Header cell height
        let headerHeight: CGFloat = 65
        headerCell.frame = CGRect(x: 0, y: 0, width: feedTableView.frame.width, height: headerHeight)
        feedTableView.tableHeaderView = headerCell
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
        //

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
    
    func hataMesaji(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    
}
