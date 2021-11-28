//
//  ViewController.swift
//  contacts
//
//  Created by QwertY on 10.11.2021.
//

import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate {

    @IBOutlet weak var contactsTableView: UITableView!
//FIX-ME: - action < viewDidLoad
// ?
    @IBAction private func addContact(_ sender: Any) {
        let storyboardName = "Main"
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        let vcIndentifier = "addContactViewController"
        if let addContactViewController = storyboard.instantiateViewController(identifier: vcIndentifier) as? AddContactViewController {
            addContactViewController.callback = { person in
                friends.append(person)
                friends.sort(by: {
                    $0.name < $1.name
                })
                self.contactsTableView.reloadData()
            }
            show(addContactViewController, sender: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contactsTableViewSetUp()
        
        friends.sort(by: {
            $0.name < $1.name
        })
    }
    
    private func reloadRecents(indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            recent.insert(recent[indexPath.row], at: 0)
            recent.remove(at: indexPath.row + 1)
        case 1:
            if let index = recent.firstIndex(where: { $0 == friends[indexPath.row] }) {
                recent.insert(recent[index], at: 0)
                recent.remove(at: index + 1)
            } else {
                if recent.count < 5 {
                    recent.insert(friends[indexPath.row], at: 0)
                } else {
                    recent.insert(friends[indexPath.row], at: 0)
                    recent.remove(at: recent.endIndex - 1)
                }
            }
        default:
            break
        }
        
        contactsTableView.reloadData()
    }
    
    private func passDataToInfoVC(from indexPath: IndexPath) {
        let storyboardName = "Main"
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        let vcIdentifier = "infoViewController"
        if let infoViewController = storyboard.instantiateViewController(identifier: vcIdentifier) as? InfoViewController {
            switch indexPath.section {
            case 0:
                infoViewController.personInfo = recent[indexPath.row]
                infoViewController.callback = {
                    if let index = friends.firstIndex(where: { $0 == recent[indexPath.row] }) {
                        friends[index] = $0
                        recent[indexPath.row] = $0
                    }
                    
                    self.contactsTableView.reloadData()
                }
            case 1:
                infoViewController.personInfo = friends[indexPath.row]
                infoViewController.callback = { person in
                    if let index = recent.firstIndex(where: { $0 == friends[indexPath.row] }) {
                        recent[index] = person
                        friends[indexPath.row] = person
                    }
                    
                    self.contactsTableView.reloadData()
                }
            default:
                break
            }
            self.contactsTableView.reloadData()
            show(infoViewController, sender: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.contactsTableView.reloadData()
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    private func contactsTableViewSetUp() {
        contactsTableView.delegate = self
        contactsTableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let recentsTitle = "Recents"
        let friendsTitle = "Friends"
        switch section {
        case 0: return recentsTitle
        case 1: return friendsTitle
        default: return ""
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return recent.isEmpty ? 1 : recent.count
        case 1: return friends.count
        default: return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "contactCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        switch indexPath.section {
        case 0:
            if recent.isEmpty {
                let recentCellText = "No recents yet"
                cell.textLabel?.text = recentCellText
            } else {
                cell.imageView?.image = recent[indexPath.row].avatar
                cell.textLabel?.text = recent[indexPath.row].name
                cell.accessoryType = .detailDisclosureButton
            }
        case 1:
            cell.imageView?.image = friends[indexPath.row].avatar
            cell.textLabel?.text = friends[indexPath.row].name
            cell.accessoryType = .detailDisclosureButton
        default:
            break
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        reloadRecents(indexPath: indexPath)
        passDataToInfoVC(from: indexPath)
    }
}

