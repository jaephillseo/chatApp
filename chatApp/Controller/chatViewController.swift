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

class chatViewController : UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    
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
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        return 3
    }
    
    //TODO: cellForRowAt
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customMessageCell", for: indexPath) as! CustomMessageCell
        
        let messageArray = ["First", "Second", "Third"]
        
        cell.messageBody.text = messageArray[indexPath.row]
        
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
