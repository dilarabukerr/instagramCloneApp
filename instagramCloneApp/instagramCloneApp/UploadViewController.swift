//
//  UploadViewController.swift
//  instagramCloneApp
//
//  Created by Dilara Büker on 6.05.2024.
//

import UIKit
import Firebase
import FirebaseStorage

class UploadViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var commentText: UITextField!
    @IBOutlet weak var uploadBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Görüntü görüntüleyicisinin kullanıcı etkileşimlerine izin vermek için özelliği true olarak ayarla.
        imageView.isUserInteractionEnabled = true
        
        //Bir dokunma tanıyıcı (UITapGuestureRecognizer) oluştur.
        //Bu tanıyıcı, kullanıcı bir dokunma algılandığında "chooseImage" modunu çağıracak.
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
        imageView.addGestureRecognizer(gestureRecognizer)

    }
    
    @objc func chooseImage () {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true, completion: nil)
    }
    
    // Fotoğraf seçici bir medya seçildiğinde çağırılan metod

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Seçilen medyanın orijinal resmini image görüntüleyicisine atar.
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    
    func makeAlert(titleInput: String, messageInput: String) {
            let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
            let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
            alert.addAction(okButton)
            self.present(alert, animated: true, completion: nil)
        }
    
    @IBAction func actionUploadBtn(_ sender: Any) {
        
        // Firebase Storage'e erişim sağlama
        let storage = Storage.storage()
        let storageReference = storage.reference()

        // "media" adında bir klasör oluşturma veya var olanına erişim sağlama
        let mediaFolder = storageReference.child("media")

        // Eğer imageView'da bir resim varsa, onu veriye dönüştür
        if let data = imageView.image?.jpegData(compressionQuality: 0.5) {
            /* Buradaki "0.5" değeri, JPEG sıkıştırma kalitesinin yüzde 50'sini temsil eder. Genelde, bu değer 0 ile 1 arasında olur. 1'e ne kadar yakınsa, o kadar az sıkıştırma uygulanır ve resim o kadar yüksek kalitede olur.*/
        
            // Resim dosyası için benzersiz bir UUID oluşturma
            let uuid = UUID().uuidString
            
            // Resim dosyasını media klasörüne eklemek için bir referans oluşturma
            let imageReference = mediaFolder.child("\(uuid).jpg")
            
            // Resim verisini Firebase Storage'a yükleme
            imageReference.putData(data, metadata: nil) { metadata, error in
                if error != nil {
                    // Hata oluştuğunda kullanıcıyı bilgilendirme
                    self.makeAlert(titleInput: "Error!", messageInput: error?.localizedDescription ?? "Error")
                } else {
                    // Resim başarıyla yüklendiyse, indirme URL'sini al
                    imageReference.downloadURL { (url, error) in
                        if error == nil {
                            let imageUrl = url?.absoluteString
                             
                            //DATABASE
                            
                            // Firebase Firestore veritabanına erişim sağlama
                            let firestoreDatabase = Firestore.firestore()
                            var firestoreReference: DocumentReference? = nil //Firestore'da yeni bir belge oluşturulduğunda atanan belge referansı

                                                                
                            // Firestore'a eklenecek post verileri
                            let firestorePost = [
                                "imageUrl": imageUrl!,
                                "postedBy": Auth.auth().currentUser!.email!,
                                "postComment": self.commentText.text!,
                                "date": FieldValue.serverTimestamp(),
                                "likes": 0
                            ] as [String : Any]
                            
                            // Firestore'a yeni bir belge ekleyerek postu kaydetme
                            firestoreReference = firestoreDatabase.collection("Posts").addDocument(data: firestorePost, completion: { (error) in
                                if error != nil {
                                    // Hata oluştuğunda kullanıcıyı bilgilendirme
                                    self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                                } else {
                                    self.imageView.image = UIImage(named: "select.png")
                                    self.commentText.text = ""
                                    self.tabBarController?.selectedIndex = 0
                                }
                            })
                        }
                    }
                }
            }
        }


    }
}
