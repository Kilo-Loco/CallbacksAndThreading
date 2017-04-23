//
//  ViewController.swift
//  CallbacksThreading
//
//  Created by Kyle Lee on 4/22/17.
//  Copyright © 2017 Kyle Lee. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var userNames = [String]()

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        getUsers()
//        getUsers {
//            print("HELLO WORLD")
//        }
        getUsers { (success, response, error) in
            if success {
                print("GET USERS BLOCK CALLED")
                guard let names = response as? [String] else { return }
                self.userNames = names
                self.tableView.reloadData()
                print("RELOAD CALLED")
            } else if let error = error {
                print(error)
            }
        }
        
    }
    
    func getUsers(completion: @escaping (Bool, Any?, Error?) -> Void) {
        print("GET USERS FUNCTION")
        DispatchQueue.global().asyncAfter(deadline: .now() + 3) {
            print("DISPATCH FINISHED")
            guard let path = Bundle.main.path(forResource: "someJSON", ofType: "txt") else { return }
            let url = URL(fileURLWithPath: path)
            do {
                let data = try Data(contentsOf: url)
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                guard let array = json as? [[String: Any]] else { return }
                var names = [String]()
                for user in array {
                    guard let name = user["name"] as? String else { continue }
                    names.append(name)
                }
                DispatchQueue.main.async {
                    completion(true, names, nil)
                }
                //            print(names)
            } catch {
                print(error)
                DispatchQueue.main.async {
                    completion(false, nil, error)
                }
            }
        }
        
    }
    
    

}

extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.userNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = userNames[indexPath.row]
        return cell
    }
}

