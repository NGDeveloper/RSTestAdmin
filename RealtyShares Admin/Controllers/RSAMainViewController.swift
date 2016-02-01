//
//  RSAMainViewController.swift
//  RealtyShares Admin
//
//  Created by Nikolay Galkin on 28.01.16.
//  Copyright © 2016 RealtyShares. All rights reserved.
//

import UIKit
import Alamofire

class RSAMainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - UITableViewDataSource & Delegate
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("RSABasicTableViewCell")
        cell?.textLabel?.text = "Send notification"
        cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        return cell!
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Notifications"
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if let viewController = self.storyboard?.instantiateViewControllerWithIdentifier(String(RSASendNotificationViewController.self)) {
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
}
