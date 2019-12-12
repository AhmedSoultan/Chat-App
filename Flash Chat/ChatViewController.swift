//
//  ViewController.swift
//  Flash Chat
//
//  Created by Angela Yu on 29/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit
import Firebase
import ChameleonFramework


class ChatViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    // Declare instance variables here
    var messages = [Message]()
    // We've pre-linked the IBOutlets
    @IBOutlet var heightConstraint: NSLayoutConstraint!
    @IBOutlet var sendButton: UIButton!
    @IBOutlet var messageTextfield: UITextField!
    @IBOutlet var messageTableView: UITableView!
   
    override func viewDidLoad() {
        super.viewDidLoad()
       // print(Auth.auth().currentUser?.email)
        //TODO: Set yourself as the delegate and datasource here:
        messageTableView.delegate = self
        messageTableView.dataSource = self
        //TODO: Set yourself as the delegate of the text field here:
        messageTextfield.delegate = self
        //TODO: Set the tapGesture here:
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ChatViewController.tableViewTapped))
        messageTableView.addGestureRecognizer(tapGesture)

        //TODO: Register your MessageCell.xib file here:
        messageTableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "customMessageCell")
        tableViewConfiguration()
        retrieveMessages()
    }
    //MARK: - TableView DataSource Methods
    //TODO: Declare cellForRowAtIndexPath here:
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = messageTableView.dequeueReusableCell(withIdentifier: "customMessageCell", for: indexPath) as! CustomMessageCell
        cell.messageBody.text = messages[indexPath.row].messageBody
        cell.senderUsername.text = messages[indexPath.row].sender
        cell.avatarImageView.image = UIImage(named: "egg")
        if cell.senderUsername.text == Auth.auth().currentUser?.email {
            cell.avatarImageView.backgroundColor = UIColor.flatMint()
            cell.messageBackground.backgroundColor = UIColor.flatSkyBlue()
        } else {
            cell.avatarImageView.backgroundColor = UIColor.flatWatermelon()
            cell.messageBackground.backgroundColor = UIColor.flatGray()
        }
        return cell
    }
    
    //TODO: Declare numberOfRowsInSection here:
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
       // return 4
    }
    //TODO: Declare tableViewTapped here:
    @objc func tableViewTapped() {
        messageTextfield.endEditing(true)
    }
    //TODO: Declare configureTableView here:
    func tableViewConfiguration() {
        messageTableView.rowHeight = UITableView.automaticDimension
        messageTableView.estimatedRowHeight = 120
    }
    //MARK:- TextField Delegate Methods
    //TODO: Declare textFieldDidBeginEditing here:
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5) {
            self.heightConstraint.constant = 360 + 34
            self.view.layoutIfNeeded()
            
        }
    }
    //TODO: Declare textFieldDidEndEditing here:
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.heightConstraint.constant = 50
        self.view.layoutIfNeeded()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        messageTextfield.resignFirstResponder()
        return true
    }
    //MARK: - Send & Recieve from Firebase
    @IBAction func sendPressed(_ sender: AnyObject) {
        //TODO: Send the message to Firebase and save it in our database
        messageTextfield.endEditing(true)
        sendButton.isEnabled = false
        messageTextfield.isEnabled = false
        let messageDB = Database.database().reference().child("Messages")
        let message = ["Sender" : Auth.auth().currentUser?.email, "MessageBody" : messageTextfield.text!]
        messageDB.childByAutoId().setValue(message) {
            (error, refrence) in
            if error != nil {
                print(error!)
            } else {
                print("message saved")
            self.sendButton.isEnabled = true
            self.messageTextfield.isEnabled = true
            self.messageTextfield.text = ""
            }
            self.messageTextfield.text = ""
            self.sendButton.isEnabled = true
            self.messageTextfield.isEnabled = true
        }
    }
    //TODO: Create the retrieveMessages method here:
    func retrieveMessages() {
        let messageDB = Database.database().reference().child("Messages")
        messageDB.observe(.childAdded) { (snapshot) in
            let snapshotValue = snapshot.value as! [String:String]
            let text = snapshotValue["MessageBody"]!
            let sender = snapshotValue["Sender"] ?? ""
            let message = Message()
            message.sender = sender
            message.messageBody = text
            self.messages.append(message)
            self.messageTableView.reloadData()
            self.tableViewConfiguration()
        }
    }
    @IBAction func logOutPressed(_ sender: AnyObject) {
        //TODO: Log out the user and send them back to WelcomeViewController
        do {
           try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
           } catch {
            print("error")
        }
    }
}
