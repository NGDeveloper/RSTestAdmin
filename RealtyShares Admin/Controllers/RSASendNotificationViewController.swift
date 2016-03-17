//
//  RSASendNotificationViewController.swift
//  RealtyShares Admin
//
//  Created by Nikolay Galkin on 01.02.16.
//  Copyright © 2016 RealtyShares. All rights reserved.
//

import UIKit
import Alamofire

class RSASendNotificationViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var segmentTextField: UITextField!
    @IBOutlet weak var fillByDefaultButton: UIButton!
    @IBOutlet weak var fillForDeveloperButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var sendButton: UIButton!
    var activeTextField: UITextField!
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure UI elements.
        self.fillByDefaultButton.layer.cornerRadius = 3.0
        self.fillByDefaultButton.clipsToBounds = true
        self.fillForDeveloperButton.layer.cornerRadius = 3.0
        self.fillForDeveloperButton.clipsToBounds = true
        self.clearButton.layer.cornerRadius = 3.0
        self.clearButton.clipsToBounds = true
        self.sendButton.layer.cornerRadius = 3.0
        self.sendButton.clipsToBounds = true
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.registerForKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.deregisterForKeyboardNotifications()
    }
    
    deinit {
        self.deregisterForKeyboardNotifications()
    }
    
    private func registerForKeyboardNotifications() {
        let center = NSNotificationCenter.defaultCenter()
        center.addObserverForName(UIKeyboardWillShowNotification, object: nil, queue: nil) { (notification) -> Void in
            if let userInfo = notification.userInfo {
                if let keyboardSizeEnd = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue() {
                    let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSizeEnd.height, right: 0.0)
                    self.scrollView.contentInset = contentInsets;
                    self.scrollView.scrollIndicatorInsets = contentInsets
                }
            }
        }
        
        center.addObserverForName(UIKeyboardWillHideNotification, object: nil, queue: nil) { (notification) -> Void in
            let contentInsets = UIEdgeInsetsZero
            self.scrollView.contentInset = contentInsets
            self.scrollView.scrollIndicatorInsets = contentInsets
        }
    }
    
    private func deregisterForKeyboardNotifications() {
        let center = NSNotificationCenter.defaultCenter()
        center.removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        center.removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    // MARK: - Self Methods
    // MARK: Public
    // MARK: Private
    
    // MARK: - Actions
    
    @IBAction func fillByDefaultButton(sender: UIButton) {
        self.titleTextField.text = "RealtyShares"
        self.messageTextField.text = "Hello!";
        self.urlTextField.text = "https://www.realtyshares.com/";
        self.segmentTextField.text = "All";
    }
    
    @IBAction func fillForDeveloperButtonPressed(sender: UIButton) {
        self.titleTextField.text = "Test title"
        self.messageTextField.text = "Test message";
        self.urlTextField.text = "https://www.google.ru/";
        self.segmentTextField.text = "iOS Developer";
    }
    
    @IBAction func clearButtonPressed(sender: UIButton) {
        self.titleTextField.text = ""
        self.messageTextField.text = "";
        self.urlTextField.text = "";
        self.segmentTextField.text = "";
    }
    
    @IBAction func sendButtonPressed(sender: UIButton) {
        let notificationJSON = ["app_id" : "13b3b0ab-6b1a-4d8d-97e8-7c2ffb4fefdd",
            "included_segments" : [self.segmentTextField.text!],
            "data" : ["URL" : self.urlTextField.text!],
            "contents" : ["en" : self.messageTextField.text!],
            "headings" : ["en" : self.titleTextField.text!],
            "content_available" : true]
        
        let headers = ["Authorization" : "Basic NDQyNmJkZGUtMTk5Ny00NGZkLWFlZWItYzJhYmI4MjVlOTIw"]
        
        Alamofire.request(.POST,
            "https://onesignal.com/api/v1/notifications",
            parameters: notificationJSON,
            encoding: ParameterEncoding.JSON,
            headers: headers)
        .validate()
        .responseJSON { (response) -> Void in
            switch response.result {
            case .Success(let value):
                print(value)
                let alertController = UIAlertController(title: nil, message: "Success!", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.navigationController?.presentViewController(alertController, animated: true, completion: nil)
            case .Failure(let error):
                print(error)
                let alertController = UIAlertController(title: nil,
                    message: error.localizedDescription,
                    preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.navigationController?.presentViewController(alertController, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func viewTappedWithGestureRecognizer(sender: UITapGestureRecognizer) {
        if (self.activeTextField != nil) {
            self.activeTextField.resignFirstResponder()
        }
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldDidBeginEditing(textField: UITextField) {
        self.activeTextField = textField
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        self.activeTextField = nil
    }
}
