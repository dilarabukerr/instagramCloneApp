//
//  FeedViewController.swift
//  instagramCloneApp
//
//  Created by Dilara Büker on 6.05.2024.
//

import UIKit
import Firebase
import SDWebImage

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    

    
    
    @IBOutlet weak var tableView: UITableView!
    
    var userEmailArray = [String]()
    var userCommentArray = [String]()
    var likeArray = [Int]()
    var userImageArray = [String]()
    var documentIdArray = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        getDataFromFirestore()
        
    }
    
    func getDataFromFirestore() {
        // Firestore veritabanına erişmek için bir referans oluşturuyoruz
        let fireStoreDatabase = Firestore.firestore()
        
        // "Posts" koleksiyonundan verileri alırken "date" alanına göre sıralıyoruz
        // En yeni veriler en üstte olacak şekilde sıralama yapılıyor
        fireStoreDatabase.collection("Posts").order(by: "date", descending: true).addSnapshotListener { (snapshot,error) in
            // Hata var mı kontrol ediyoruz
            if error != nil {
                // Hata varsa hatayı yazdırıyoruz
                print(error?.localizedDescription)
            } else {
                // Hata yoksa ve snapshot boş değilse devam ediyoruz : snapshot, veritabanındaki belgelerin anlık görüntüsünü temsil ediyor.
                if snapshot?.isEmpty != true && snapshot != nil {
                    // Verileri saklamak için kullandığınız dizileri temizliyoruz
                    self.userImageArray.removeAll(keepingCapacity: false)
                    self.userEmailArray.removeAll(keepingCapacity: false)
                    self.userCommentArray.removeAll(keepingCapacity: false)
                    self.likeArray.removeAll(keepingCapacity: false)
                    self.documentIdArray.removeAll(keepingCapacity: false)
                    
                    // Her belgeyi döngüye alıyoruz
                    for document in snapshot!.documents {
                        let documentID = document.documentID
                        // Belge kimliğini saklıyoruz
                        self.documentIdArray.append(documentID)
                        
                        // "postedBy" alanından kullanıcı e-postasını alıyoruz
                        if let postedBy = document.get("postedBy") as? String {
                            self.userEmailArray.append(postedBy)
                        }
                        
                        // "postComment" alanından yorumu alıyoruz
                        if let postComment = document.get("postComment") as? String {
                            self.userCommentArray.append(postComment)
                        }
                        
                        // "likes" alanından beğeni sayısını alıyoruz
                        if let likes = document.get("likes") as? Int {
                            self.likeArray.append(likes)
                        }
                        
                        // "imageUrl" alanından resmin URL'sini alıyoruz
                        if let imageUrl = document.get("imageUrl") as? String {
                            self.userImageArray.append(imageUrl)
                        }
                    }
                    
                    // Veri alındıktan sonra tabloyu yeniliyoruz
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return userEmailArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Hücreyi "Cell" kimliğiyle yeniden kullanarak oluşturuyoruz
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedCell
        
        // Kullanıcı e-postasını ilgili hücrenin kullanıcı e-posta etiketine ayarlıyoruz
        cell.usermailLabel.text = userEmailArray[indexPath.row]
        
        // Beğeni sayısını ilgili hücrenin beğeni etiketine ayarlıyoruz
        cell.likeLabel.text = String(likeArray[indexPath.row])
        
        // Yorumu ilgili hücrenin yorum etiketine ayarlıyoruz
        cell.commentLabel.text = userCommentArray[indexPath.row]
        
        // Kullanıcının resmini ilgili hücrenin resim görüntüleyicisine yükleyerek gösteriyoruz
        cell.userImageView.sd_setImage(with: URL(string: self.userImageArray[indexPath.row]))
        
        // Belge kimliğini ilgili hücrenin belge kimliği etiketine ayarlıyoruz
        cell.documentIDLabel.text = documentIdArray[indexPath.row]
        
        // Oluşturulan hücreyi döndürüyoruz
        return cell
    }

    

}
