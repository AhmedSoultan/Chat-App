//
//  LogInViewController.swift
//  Flash Chat
//
//  This is the view controller where users login


import UIKit
import Firebase
import SVProgressHUD


class LogInViewController: UIViewController {
    //Textfields pre-linked with IBOutlets
    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet var passwordTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("view will appear")
    }
    @IBAction func logInPressed(_ sender: AnyObject) {
        //TODO: Log in the user
        Auth.auth().signIn(withEmail: emailTextfield.text ?? "", password: passwordTextfield.text ?? "") { (user, error) in
            SVProgressHUD.show()
            if error != nil {
                print(error!)
                let alert = UIAlertController(title: "Error!", message: "\(error?.localizedDescription ?? "")", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else {
                self.performSegue(withIdentifier: "goToChat", sender: self)
                UserDefaults.standard.set(true, forKey: "savelogedin")
            }
            SVProgressHUD.dismiss()
        }
    }
}  
