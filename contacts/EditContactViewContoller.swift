//
//  editContactViewContoller.swift
//  contacts
//
//  Created by QwertY on 21.11.2021.
//

import UIKit

class EditContactViewController: UIViewController, UINavigationControllerDelegate {
    
    @IBOutlet private weak var scrollView: UIScrollView!

    @IBOutlet private weak var avatarImageView: UIImageView!
    
    @IBOutlet weak var addOrEditPhotoButton: UIButton!
    
    @IBOutlet private weak var nameTextField: UITextField!
    
    @IBOutlet private weak var mobileTextField: UITextField!
    
    @IBOutlet private weak var emailTextField: UITextField!
    
    @IBOutlet private weak var notesTextView: UITextView!
    
    @IBOutlet private weak var doneButton: UIBarButtonItem!
    
    @IBOutlet weak var deleteButton: UIButton!
    
    var personInfo = Person()
    
    var picker = UIImagePickerController()
    
    var callback: ((Person) -> Void)?
    
    
    @IBAction private func doneButtonTapped(_ sender: Any) {
        if let name = nameTextField.text,
           let mobile = mobileTextField.text,
           let email = emailTextField.text,
           let notes = notesTextView.text,
           let avatar = avatarImageView.image {
            let person = Person(name: name, phoneNumber: mobile, email: email, notes: notes, avatar: avatar)
            callback?(person)
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction private func addPhotoButtonTapped(_ sender: Any) {
        present(picker, animated: true)
    }
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        let dialogMessage = UIAlertController(title: "Confirm deletion", message: "Are you sure you want to delete this contact?", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            if let name = self.nameTextField.text,
               let mobile = self.mobileTextField.text,
               let email = self.emailTextField.text,
               let notes = self.notesTextView.text,
               let avatar = self.avatarImageView.image {
                let contact = Person(name: name, phoneNumber: mobile, email: email, notes: notes, avatar: avatar)
                if let index = recent.firstIndex(where: {
                                                    $0.avatar == contact.avatar &&
                                                        $0.name == contact.name &&
                                                        $0.phoneNumber == contact.phoneNumber &&
                                                        $0.email == contact.email &&
                                                        $0.notes ==  contact.notes }) {
                    recent.remove(at: index)
                }
                
                if let index = friends.firstIndex(where: {
                                                    $0.avatar == contact.avatar &&
                                                        $0.name == contact.name &&
                                                        $0.phoneNumber == contact.phoneNumber &&
                                                        $0.email == contact.email &&
                                                        $0.notes ==  contact.notes }) {
                    friends.remove(at: index)
                }
                self.navigationController?.popToRootViewController(animated: true)
            }
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        dialogMessage.addAction(okAction)
        dialogMessage.addAction(cancelAction)
        
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        avatarImageViewSetUp()
        
        delegatesSetUp()
        
        notesTextViewSetUp()
        
        hideKeyboardOnTap()
        
        setKeyboardObservers()
                
        fillPersonInfo()
        
        deleteButtonSetUp()
    }
    
    private func avatarImageViewSetUp() {
        avatarImageView.image = personInfo.avatar
    }
    
    private func delegatesSetUp() {
        picker.delegate = self
    }
    
    private func notesTextViewSetUp() {
        notesTextView.layer.borderColor = UIColor.systemGray.cgColor
        notesTextView.layer.borderWidth = 1
        notesTextView.layer.cornerRadius = 10
    }
    
    private func fillPersonInfo() {
        nameTextField.text = personInfo.name
        mobileTextField.text = personInfo.phoneNumber
        emailTextField.text = personInfo.email
        notesTextView.text = personInfo.notes
        avatarImageView.image = personInfo.avatar
    }
    
    private func deleteButtonSetUp() {
        deleteButton.layer.cornerRadius = 5
    }
}

extension EditContactViewController {

    func hideKeyboardOnTap() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    func setKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc private func keyboardWillShow(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            var keyboardFrame: CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
            keyboardFrame = self.view.convert(keyboardFrame, from: nil)

            var contentInset: UIEdgeInsets = self.scrollView.contentInset
            contentInset.bottom = keyboardFrame.size.height + 40
            scrollView.contentInset = contentInset
        }
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        let contentInset: UIEdgeInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
    }
}

extension EditContactViewController: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let image = info[.originalImage] as? UIImage {
            avatarImageView.image = image
        }
    }
}
