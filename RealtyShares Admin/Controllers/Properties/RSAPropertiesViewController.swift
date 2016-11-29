//
//  RSAPropertiesViewController.swift
//  RealtyShares Admin
//
//  Created by Nikolay Galkin on 09.03.16.
//  Copyright © 2016 RealtyShares. All rights reserved.
//

import UIKit
import CoreData

class RSAPropertiesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    var refreshControl: UIRefreshControl!
    var properties: [Property]! = []
    var coreDataStack: CoreDataStack!
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Property")
    let sortDescriptor = NSSortDescriptor(key: "created", ascending: false)
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add pull-to-refresh control to the table view.
        let tableViewController = UITableViewController()
        tableViewController.tableView = tableView
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.refreshPropertiesList), for: UIControlEvents.valueChanged)
        tableViewController.refreshControl = refreshControl
        
        // Configure fetch request.
        fetchRequest.sortDescriptors = [sortDescriptor]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchPropertiesAndReloadTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Refresh properties list with refreshing animation.
        refreshControl.beginRefreshing()
        tableView.setContentOffset(CGPoint(x: 0, y: -refreshControl.frame.size.height), animated: true)
        refreshPropertiesList()
    }
    
    // MARK: - Self Methods
    // MARK: Public
    // MARK: Private
    
    func refreshPropertiesList() {
        RSAAPI.sharedAPI.getPropertiesListWithCompletion { (properties) -> Void in
            self.refreshControl.endRefreshing()
            if (properties != nil) {
                var savedPropertiesCount = 0
                
                let entity = NSEntityDescription.entity(forEntityName: "Property", in: self.coreDataStack.context)
                for propertyDictionary in properties! {
                    if let pid = propertyDictionary["pid"] as? String {
                        let findFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Property")
                        let predicate = NSPredicate(format: "pid == %@", pid)
                        findFetchRequest.predicate = predicate
                        
                        do {
                            var property: Property
                            let results = try self.coreDataStack.context.fetch(findFetchRequest)
                            if (results.count == 0) {
                                property = Property(entity: entity!, insertInto: self.coreDataStack.context)
                            } else {
                                property = results.first as! Property
                            }
                            property.pid = pid

                            if let title = propertyDictionary["title"] as? String {
                                property.title = title
                            }
                            if let message = propertyDictionary["message"] as? String {
                                property.message = message
                            }
                            if let url = propertyDictionary["url"] as? String {
                                property.url = url
                            }
                            if let created = propertyDictionary["created"] as? NSNumber {
                                property.created = created
                            }
                            savedPropertiesCount = savedPropertiesCount + 1;
                        } catch let error as NSError {
                            print("Could not fetch \(error), \(error.userInfo)")
                        }
                    } else {
                        print("Error: property MUST have \"pid\" parameter.")
                    }
                }
                
                self.coreDataStack.saveContext()
                print("Downloaded \(properties!.count) properties. Saved \(savedPropertiesCount) properties.")
                self.fetchPropertiesAndReloadTableView()
            }
        }
    }
    
    fileprivate func fetchPropertiesAndReloadTableView() {
        do {
            properties = try coreDataStack.context.fetch(fetchRequest) as! [Property]
            tableView.reloadData()
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    // MARK: - UITableViewDataSource & Delegate
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return properties.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RSAPropertyTableViewCell.self)) as! RSAPropertyTableViewCell
        let property = properties[indexPath.row]
        cell.titleLabel.text = property.title
        cell.messageLabel.text = property.message
        cell.urlLabel.text = property.url
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Actions
    
    @IBAction func addPropertyButtonPressed(_ sender: UIBarButtonItem) {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: String(describing: RSAAddPropertyViewController.self))
        let navigationController = UINavigationController(rootViewController: viewController!)
        self.navigationController?.present(navigationController, animated: true, completion: nil)
    }
}
