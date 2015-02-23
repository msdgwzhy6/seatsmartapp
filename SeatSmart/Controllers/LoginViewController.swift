//
//  LoginControllerViewController.swift
//  SeatSmart
//
//  Created by Huey Ly on 2/22/15.
//  Copyright (c) 2015 SeatSmart. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginEmailField: UITextField!
    @IBOutlet weak var loginPasswordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setFieldStyles()
    }

    func setFieldStyles() {
        loginEmailField.textColor = UIColor.whiteColor()
        loginPasswordField.textColor = UIColor.whiteColor()
        
        loginEmailField.placeholder = "Email"
        loginPasswordField.placeholder = "Password"
        
        let loginEmailLeftPadding = UIView(frame: CGRect(x: 0, y: 0, width: 45, height: 0))
        loginEmailLeftPadding.backgroundColor = UIColor.clearColor()
        loginEmailField.leftView = loginEmailLeftPadding
        loginEmailField.leftViewMode = .Always
        
        let loginPasswordLeftPadding = UIView(frame: CGRect(x: 0, y: 0, width: 45, height: 0))
        loginPasswordLeftPadding.backgroundColor = UIColor.clearColor()
        loginPasswordField.leftView = loginPasswordLeftPadding
        loginPasswordField.leftViewMode = .Always
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}
