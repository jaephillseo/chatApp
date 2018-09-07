//
//  chatViewController.swift
//  chatApp
//
//  Created by Jae Phil on 9/4/18.
//  Copyright © 2018 jaephillseo. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import SVProgressHUD
import ChameleonFramework

class chatViewController : UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    var messageArray : [Message] = [Message]()
    
    //IBOutlets
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var messageTableView: UITableView!
    @IBOutlet weak var sendButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //TODO: Set self as the delegate and datasource
        messageTableView.delegate = self
        messageTableView.dataSource = self
        
        //TODO: Set self as delegate of the text field
        messageTextField.delegate = self
        
        //TODO: Set tapGesture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
        messageTableView.addGestureRecognizer(tapGesture)
        
        //TODO: register xib file
        messageTableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "customMessageCell")
        
        configureTableView()
        retreiveMessages()
        
        messageTableView.separatorStyle = .none
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func sendButtonPressed(_ sender: Any) {
        messageTextField.endEditing(true)
        
        //TODO: Send Message to Firebase
        
        messageTextField.isEnabled = false
        sendButton.isEnabled = false
        
        let messagesDB = Database.database().reference().child("Messages")
        
        let messagesDictionary = ["Sender" : Auth.auth().currentUser?.email, "MessageBody": messageTextField.text!]
        
        messagesDB.childByAutoId().setValue(messagesDictionary){
            (error, reference) in
            
            if error != nil {
                print(error!)
            } else {
                print ("Message successfully saved!")
                
                self.messageTextField.isEnabled = true
                self.sendButton.isEnabled = true
                self.messageTextField.text = ""
            }
        } //create custom random key for our message
        
        
        
    }
    //TODO: Create the retreiveMessages method here:
    
    func retreiveMessages() {
        let messageDB = Database.database().reference().child("Messages")
        
        messageDB.observe(.childAdded) { (snapshot) in
            let snapshotValue = snapshot.value as! Dictionary<String,String>
            
            let text = snapshotValue["MessageBody"]!
            let sender = snapshotValue["Sender"]!
            
            print(text, sender)
            
            let newMessage = Message()
            newMessage.messageBody = text
            newMessage.sender = sender
            
            self.messageArray.append(newMessage)
            
            self.configureTableView()
            self.messageTableView.reloadData()
        }
        
    }
    
    @IBAction func logoutButtonPressed(_ sender: Any) {
        //TODO: Log out user
        print("Logout button pressed")
        do{
            try Auth.auth().signOut()
        }
        catch {
            print("Problem with signing out process")
        }
        //Go back to root view controller
        guard (navigationController?.popToRootViewController(animated: true)) != nil
            else {
                print("No View controllers to pop off")
                return
        }
    }
    //MARK: TextField Delegate Methods
    
    //TODO: Declare textFieldDidBeginEditing here:
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        
        UIView.animate(withDuration: 0.5) {
            self.heightConstraint.constant = 308
            self.view.layoutIfNeeded()
        }
    }
    
    //TODO: Declare textFieldDidEndEditing here:
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5) {
            self.heightConstraint.constant = 50
            self.view.layoutIfNeeded()
        }
    }
    //MARK: TableView Datasource Methods
    
    //TODO: numberOfRowsInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageArray.count
    }
    
    //TODO: cellForRowAt
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customMessageCell", for: indexPath) as! CustomMessageCell
        
        cell.messageBody.text = messageArray[indexPath.row].messageBody
        cell.senderUsername.text = messageArray[indexPath.row].sender
        cell.avatarImageView.image = UIImage(named: "egg")
        
        if cell.senderUsername.text == Auth.auth().currentUser?.email as String? {
            cell.avatarImageView.backgroundColor = UIColor.flatMint()
            cell.messageBackground.backgroundColor = UIColor.flatSkyBlue()
        } else {
            cell.avatarImageView.backgroundColor = UIColor.flatWatermelon()
            cell.messageBackground.backgroundColor = UIColor.flatGreen()
        }
        
        return cell
    }
    
    //TODO: TableViewTapped
    @objc func tableViewTapped() {
        messageTextField.endEditing(true)
    }
    
    //TODO: configureTableView
    func configureTableView()
    {
        messageTableView.rowHeight = UITableViewAutomaticDimension
        messageTableView.estimatedRowHeight = 120.0
    }
}
