//
//  FeedCell.swift
//  instagramCloneApp
//
//  Created by Dilara Büker on 8.05.2024.
//

import UIKit
import Firebase

class FeedCell: UITableViewCell {
    @IBOutlet weak var usermailLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var documentIDLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func likeBtn(_ sender: Any) {
        
        // Firestore veritabanına erişmek için bir referans oluşturuyoruz
        let fireStoreDatabase = Firestore.firestore()

        // Eğer likeLabel'deki metni bir tamsayıya dönüştürebiliyorsak devam ediyoruz
        if let likeCount = Int(likeLabel.text!) {
            // Like sayısını bir artırıp yeni bir sözlük oluşturuyoruz
            let likeStore = ["Likes": likeCount + 1] as [String: Any]
            
            // Belirli bir belgeyi güncellemek veya oluşturmak için setData metodunu kullanıyoruz
            // "merge" parametresi true olarak ayarlandığında, belirtilen alanlar varsa güncellenir veya yoksa eklenir
            fireStoreDatabase.collection("Posts").document(documentIDLabel.text!).setData(likeStore, merge: true)
        }

        
    }
    
}
