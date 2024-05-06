//
//  SettingsViewController.swift
//  instagramCloneApp
//
//  Created by Dilara Büker on 6.05.2024.
//

import UIKit
import Firebase

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func logoutBtn(_ sender: Any) {
        
        do {
            try Auth.auth().signOut()
            self.performSegue(withIdentifier: "toVC", sender: nil)
        } catch {
            print ("error")
        }
    }
}
