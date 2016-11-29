//
//  RSAAddPropertyViewController.swift
//  RealtyShares Admin
//
//  Created by Nikolay Galkin on 15.03.16.
//  Copyright © 2016 RealtyShares. All rights reserved.
//

import UIKit

class RSAAddPropertyViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet var tapGestureRecognizer: UITapGestureRecognizer!
    var activeTextField: UITextField!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure UI elements
        addButton.layer.cornerRadius = 3.0
        addButton.clipsToBounds = true
        
        cancelButton.layer.cornerRadius = 3.0
        cancelButton.clipsToBounds = true
        
        // Fill text fields with sample text.
//        self.titleTextField.text = "RealtyShares"
//        self.messageTextField.text = "Message from server"
//        self.urlTextField.text = "http://realtyshares.com"
        
        activityIndicatorView.stopAnimating()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        registerForKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        deregisterForKeyboardNotifications()
    }
    
    deinit {
        deregisterForKeyboardNotifications()
    }
    
    fileprivate func registerForKeyboardNotifications() {
        let center = NotificationCenter.default
        center.addObserver(forName: NSNotification.Name.UIKeyboardWillShow, object: nil, queue: nil) { (notification) -> Void in
            if let userInfo = notification.userInfo {
                if let keyboardSizeEnd = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                    let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSizeEnd.height, right: 0.0)
                    self.scrollView.contentInset = contentInsets;
                    self.scrollView.scrollIndicatorInsets = contentInsets
                }
            }
        }
        
        center.addObserver(forName: NSNotification.Name.UIKeyboardWillHide, object: nil, queue: nil) { (notification) -> Void in
            let contentInsets = UIEdgeInsets.zero
            self.scrollView.contentInset = contentInsets
            self.scrollView.scrollIndicatorInsets = contentInsets
        }
    }
    
    fileprivate func deregisterForKeyboardNotifications() {
        let center = NotificationCenter.default
        center.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        center.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    // MARK: - Actions
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
        let title = titleTextField.text!
        let message = messageTextField.text!
        let url = urlTextField.text!
        if (title != "" && message != "" && url != "") {
            activityIndicatorView.startAnimating()
            RSAAPI.sharedAPI.createPropertyWithTitle(title, message: message, url: url) { (error) -> Void in
                self.activityIndicatorView.stopAnimating()
                if (error == nil) {
                    self.navigationController?.dismiss(animated: true, completion: nil)
                }
            }
        } else {
            let alertView = UIAlertController(title: "Warning", message: "All text fields must have values", preferredStyle: UIAlertControllerStyle.alert)
            alertView.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            navigationController?.present(alertView, animated: true, completion: nil)
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func viewTappedWithGestureRecognizer(_ sender: UITapGestureRecognizer) {
        if (activeTextField != nil) {
            activeTextField.resignFirstResponder()
        }
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeTextField = nil
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField == titleTextField) {
            messageTextField.becomeFirstResponder()
        } else if (textField == messageTextField) {
            urlTextField.becomeFirstResponder()
        } else if (textField == urlTextField) {
            urlTextField.resignFirstResponder()
        }
        return false
    }
}
