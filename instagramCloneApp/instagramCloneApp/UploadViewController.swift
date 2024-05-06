//
//  UploadViewController.swift
//  instagramCloneApp
//
//  Created by Dilara Büker on 6.05.2024.
//

import UIKit
import Firebase

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
    
    @IBAction func actionUploadBtn(_ sender: Any) {
        
        
    }
}
