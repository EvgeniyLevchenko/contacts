//
//  InfoViewController.swift
//  contacts
//
//  Created by QwertY on 10.11.2021.
//

import UIKit

class InfoViewController: UIViewController, UINavigationControllerDelegate {
    
    @IBOutlet weak var avatarImage: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var mobileLabel: UILabel!
    
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var notesLabel: UILabel!
    
    var personInfo = Person()
    
    var isGoingForward: Bool = false
    
    var callback: ((Person) -> Void)?
    
    @IBAction func editButtonTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let editContactViewController = storyboard.instantiateViewController(identifier: "editContactViewController") as? EditContactViewController {
            var personInfoToPass = Person()
            if let name = nameLabel.text,
               let mobile = mobileLabel.text,
               let email = emailLabel.text,
               let notes = notesLabel.text,
               let avatar = avatarImage.image {
                personInfoToPass = Person(name: name, phoneNumber: mobile, email: email, notes: notes, avatar: avatar)
            }
            
            editContactViewController.personInfo = personInfoToPass
            
            editContactViewController.callback = { person in
                self.nameLabel.text = person.name
                self.mobileLabel.text = person.phoneNumber
                self.emailLabel.text = person.email
                self.notesLabel.text = person.notes
                self.avatarImage.image = person.avatar
            }
            isGoingForward = true
            show(editContactViewController, sender: nil)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        avatarImage.image = personInfo.avatar
        nameLabel.text = personInfo.name
        mobileLabel.text = personInfo.phoneNumber
        emailLabel.text = personInfo.email
        notesLabel.text = personInfo.notes
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if !isGoingForward {
            if let avatar = avatarImage.image,
               let name = nameLabel.text,
               let mobile = mobileLabel.text,
               let email = emailLabel.text,
               let notes = notesLabel.text {
                let person = Person(name: name, phoneNumber: mobile, email: email, notes: notes, avatar: avatar)
                callback?(person)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        isGoingForward = false
    }
}
