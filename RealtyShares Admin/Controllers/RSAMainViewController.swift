//
//  RSAMainViewController.swift
//  RealtyShares Admin
//
//  Created by Nikolay Galkin on 28.01.16.
//  Copyright © 2016 RealtyShares. All rights reserved.
//

import UIKit
import Alamofire
import CoreData

enum TableViewSection : Int {
    case properties = 0
}

class RSAMainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    var coreDataStack: CoreDataStack!
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Clear database from old objects.
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Property")
        let predicate = NSPredicate(format: "created == nil")
        fetchRequest.predicate = predicate
        
        do {
            let results = try coreDataStack.context.fetch(fetchRequest) as! [Property]
            for property in results {
                coreDataStack.context.delete(property)
                print("Deleted property: \(property)")
            }
            try coreDataStack.context.save()
        } catch let error as NSError {
            print("Could not clear database from old objects. Error: \(error.localizedDescription)")
        }
    }
    
    // MARK: - UITableViewDataSource & Delegate
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = TableViewSection(rawValue: section)!
        switch section {
        case .properties:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RSABasicTableViewCell")
        let section = TableViewSection(rawValue: indexPath.section)!
        switch section {
        case .properties:
            cell?.textLabel?.text = "Properties list"
            break
        }
        cell?.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        return cell!
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = TableViewSection(rawValue: section)!
        switch section {
        case .properties:
            return "Properties"
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let section = TableViewSection(rawValue: indexPath.section)!
        switch section {
        case .properties:
            if let viewController = self.storyboard?.instantiateViewController(withIdentifier: String(describing: RSAPropertiesViewController.self)) as! RSAPropertiesViewController? {
                viewController.coreDataStack = coreDataStack
                self.navigationController?.pushViewController(viewController, animated: true)
            }
            break
        }
    }
}
