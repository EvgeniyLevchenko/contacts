//
//  AddContactViewController.swift
//  contacts
//
//  Created by QwertY on 13.11.2021.
//

import UIKit

class AddContactViewController: UIViewController, UINavigationControllerDelegate {
    
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var mobileTextField: UITextField!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var notesTextView: UITextView!
    @IBOutlet private weak var doneButton: UIBarButtonItem!
    
    var picker = UIImagePickerController()
    var callback: ((Person) -> Void)?
    
    @IBAction private func doneButtonTapped(_ sender: Any) {
        passDataToMainVC()
    }
    
    @IBAction private func addPhotoButtonTapped(_ sender: Any) {
        showImagePicker()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad() 
        
        avatarImageViewSetUp()
        delegatesSetUp()
        notesTextViewSetUp()
        hideKeyboardOnTap()
        setKeyboardObservers()
        setNameTextViewObserver()
    }
    
    private func avatarImageViewSetUp() {
        avatarImageView.image = Person().avatar
    }
    
    private func delegatesSetUp() {
        picker.delegate = self
    }
    
    private func notesTextViewSetUp() {
        notesTextView.layer.borderColor = UIColor.systemGray.cgColor
        notesTextView.layer.borderWidth = 1
        notesTextView.layer.cornerRadius = 10
    }
    
    private func passDataToMainVC() {
        if let name = nameTextField.text,
           let phone = mobileTextField.text,
           let email = emailTextField.text,
           let notes = notesTextView.text,
           let avatar = avatarImageView.image {
            let person = Person(name: name, phoneNumber: phone, email: email, notes: notes, avatar: avatar)
            callback?(person)
            self.navigationController?.popToRootViewController(animated: true)
            
        }
    }
    
    private func showImagePicker() {
        present(picker, animated: true)
    }
}

extension AddContactViewController {

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

extension AddContactViewController: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let image = info[.originalImage] as? UIImage {
            avatarImageView.image = image
        }
    }
}

extension AddContactViewController {
    
    func setNameTextViewObserver() {
        nameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    @objc private func textFieldDidChange() {
        if let text = nameTextField.text {
            if !text.isEmpty {
                doneButton.isEnabled = true
            }
        }
    }
}
