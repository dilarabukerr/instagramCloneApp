//
//  ViewController.swift
//  instagramCloneApp
//
//  Created by Dilara Büker on 6.05.2024.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    @IBOutlet weak var mailText: UITextField!
    @IBOutlet weak var poasswordText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func loginBtn(_ sender: Any) {
        //performSegue(withIdentifier: "toFeedVC", sender: nil)
        if mailText.text != "" && poasswordText.text != "" {
            Auth.auth().signIn(withEmail: mailText.text!, password: poasswordText.text!) { authdata, error in
                if error != nil { //giriş yapamadı
                    self.makeAlert(titleInput: "Error!", messageInput: error?.localizedDescription ?? "Error") //firebase'in kendi hata mesajını verecek.
                } else { //kullanıcı gerçekten giriş yapacak
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
            
            
        } else { // kullanıcı giriş yapamadı mail veya şifre boş.
            makeAlert(titleInput: "Error!", messageInput: "Username/Password?")
        }
    }
    
    @IBAction func signBtn(_ sender: Any) { // Kullanıcı oluşturalım.
        if mailText.text != "" && poasswordText.text != "" {
            Auth.auth().createUser(withEmail: mailText.text!, password: poasswordText.text!) { authdata, error in
                if error != nil { //kullanıcı oluşturulamadı
                    self.makeAlert(titleInput: "Error!", messageInput: error?.localizedDescription ?? "Error") //firebase'in kendi hata mesajını verecek.
                } else { //kullanıcı gerçekten oluşturuldu
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
        } else { // mail veya şifre boş bırakıldıysa
            makeAlert(titleInput: "Error!", messageInput: "Username/Password?")
        }
        
    }
    
    func makeAlert(titleInput:String, messageInput:String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okBtn = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okBtn)
        self.present(alert, animated: true, completion: nil)
    }
}

