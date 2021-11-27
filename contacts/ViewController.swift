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
    @IBAction private func addContact(_ sender: Any) {
//FIX-ME: - literals
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let addContactViewController = storyboard.instantiateViewController(identifier: "addContactViewController") as? AddContactViewController {
            addContactViewController.callback = { person in
                friends.append(person)
//FIX-ME: - enter?
                friends.sort(by: {
                    $0.name < $1.name
                })
//FIX-ME: - enter?
                self.contactsTableView.reloadData()
            }
            show(addContactViewController, sender: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//FIX-ME: - method
        contactsTableView.delegate = self
        contactsTableView.dataSource = self
        
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
            if let index = recent.firstIndex(where: {
//FIX-ME: - Equatable
                $0.name == friends[indexPath.row].name &&
                    $0.phoneNumber == friends[indexPath.row].phoneNumber &&
                    $0.email == friends[indexPath.row].email
            }) {
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
//FIX-ME: - literals
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        if let infoViewController = storyboard.instantiateViewController(identifier: "infoViewController") as? InfoViewController {
            switch indexPath.section {
            case 0:
                infoViewController.personInfo = recent[indexPath.row]
//FIX-ME: - callback
                infoViewController.callback = { person in
                    if let index = friends.firstIndex(where: {
//FIX-ME: - Equatable
                        $0.name == recent[indexPath.row].name &&
                        $0.phoneNumber == recent[indexPath.row].phoneNumber &&
                        $0.email == recent[indexPath.row].email
                    }) {
                        friends[index] = person
                        recent[indexPath.row] = person
                    }
                    
                    self.contactsTableView.reloadData()
                }
            case 1:
                infoViewController.personInfo = friends[indexPath.row]
                infoViewController.callback = { person in
                    if let index = recent.firstIndex(where: {
//FIX-ME: - Equatable
                        $0.name == friends[indexPath.row].name &&
                        $0.phoneNumber == friends[indexPath.row].phoneNumber &&
                        $0.email == friends[indexPath.row].email
                    }) {
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
//FIX-ME: - literals
        case 0: return "Recents"
        case 1: return "Friends"
        default: return ""
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
//FIX-ME: - case style?
        case 0:
            if recent.isEmpty {
                return 1
            } else {
                return recent.count
            }
        case 1: return friends.count
        default: return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//FIX-ME: - default ceell
//FIX-ME: - literals
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath)

        cell.textLabel?.font = UIFont(name: "System", size: 25)
        
        switch indexPath.section {
        case 0:
            if recent.isEmpty {
//FIX-ME: - literals
                cell.textLabel?.text = "No recents yet"
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
//FIX-ME: - ???
            cell.textLabel?.text = ""
        }
        
        return cell
    }

    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        reloadRecents(indexPath: indexPath)
        passDataToInfoVC(from: indexPath)
    }
}

