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
    case Properties = 0
    case Notifications = 1
}

class RSAMainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    var coreDataStack: CoreDataStack!
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Clear database from old objects.
        let fetchRequest = NSFetchRequest(entityName: "Property")
        let predicate = NSPredicate(format: "created == nil")
        fetchRequest.predicate = predicate
        
        do {
            let results = try coreDataStack.context.executeFetchRequest(fetchRequest) as! [Property]
            for property in results {
                coreDataStack.context.deleteObject(property)
                print("Deleted property: \(property)")
            }
            try coreDataStack.context.save()
        } catch let error as NSError {
            print("Could not clear database from old objects. Error: \(error.localizedDescription)")
        }
    }
    
    // MARK: - UITableViewDataSource & Delegate
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = TableViewSection(rawValue: section)!
        switch section {
        case .Properties:
            return 1
        case .Notifications:
            return 1
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("RSABasicTableViewCell")
        let section = TableViewSection(rawValue: indexPath.section)!
        switch section {
        case .Properties:
            cell?.textLabel?.text = "Properties list"
            break
        case .Notifications:
            cell?.textLabel?.text = "Send notification"
            break
        }
        cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        return cell!
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = TableViewSection(rawValue: section)!
        switch section {
        case .Properties:
            return "Properties"
        case .Notifications:
            return "Notifications"
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let section = TableViewSection(rawValue: indexPath.section)!
        switch section {
        case .Properties:
            if let viewController = self.storyboard?.instantiateViewControllerWithIdentifier(String(RSAPropertiesViewController.self)) as! RSAPropertiesViewController? {
                viewController.coreDataStack = coreDataStack
                self.navigationController?.pushViewController(viewController, animated: true)
            }
            break
        case .Notifications:
            if let viewController = self.storyboard?.instantiateViewControllerWithIdentifier(String(RSASendNotificationViewController.self)) {
                self.navigationController?.pushViewController(viewController, animated: true)
            }
            break
        }
    }
}
