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
//FIX-ME: - action
    @IBAction private func doneButtonTapped(_ sender: Any) {
        passDataToInfoVC()
    }
//FIX-ME: - action
    @IBAction private func addPhotoButtonTapped(_ sender: Any) {
        showImagePicker()
    }
//FIX-ME: - action
    @IBAction func deleteButtonTapped(_ sender: Any) {
        showDialogMessage()
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
    
    private func passDataToInfoVC() {
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
    
    private func showImagePicker() {
        present(picker, animated: true)
    }
    
    private func showDialogMessage() {
        let dialogMessageTitle = "Confirm deletion"
        let message = "Are you sure you want to delete this contact?"
        let dialogMessage = UIAlertController(title: dialogMessageTitle, message: message, preferredStyle: .alert)
        
        let okActionTitle = "OK"
        let okAction = UIAlertAction(title: okActionTitle, style: .default, handler: { (action) -> Void in
            if let name = self.nameTextField.text,
               let mobile = self.mobileTextField.text,
               let email = self.emailTextField.text,
               let notes = self.notesTextView.text,
               let avatar = self.avatarImageView.image {
                let contact = Person(name: name, phoneNumber: mobile, email: email, notes: notes, avatar: avatar)
                if let index = recent.firstIndex(where: { $0 == contact }) {
                    recent.remove(at: index)
                }
                
                if let index = friends.firstIndex(where: { $0 == contact }) {
                    friends.remove(at: index)
                }
                self.navigationController?.popToRootViewController(animated: true)
            }
        })
        let cancelActionTitle = "Cancel"
        let cancelAction = UIAlertAction(title: cancelActionTitle, style: .cancel)
        
        dialogMessage.addAction(okAction)
        dialogMessage.addAction(cancelAction)
        
        self.present(dialogMessage, animated: true, completion: nil)
    }
}

extension EditContactViewController {

    private func hideKeyboardOnTap() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    private func setKeyboardObservers() {
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
