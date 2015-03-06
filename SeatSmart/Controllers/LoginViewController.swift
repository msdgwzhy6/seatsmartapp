//
//  LoginControllerViewController.swift
//  SeatSmart
//
//  Created by Huey Ly on 2/22/15.
//  Copyright (c) 2015 SeatSmart. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, FBLoginViewDelegate {
    
    @IBOutlet weak var loginEmailField: UITextField!
    @IBOutlet weak var loginPasswordField: UITextField!
    @IBOutlet var fbLoginView : FBLoginView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setFieldStyles()
        
        self.fbLoginView.delegate = self
        self.fbLoginView.readPermissions = ["public_profile", "email", "user_friends"]
        
        let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let isLoggedIn:Int = prefs.integerForKey("ISLOGGEDIN") as Int
        if (isLoggedIn != 1) {

        } else {

        }
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
    
    @IBAction func logoutTapped(sender : UIButton) {
        
        let appDomain = NSBundle.mainBundle().bundleIdentifier
        NSUserDefaults.standardUserDefaults().removePersistentDomainForName(appDomain!)
        
        self.performSegueWithIdentifier("goto_login", sender: self)
    }

    // MARK - Facebook funcs
    func loginViewShowingLoggedInUser(loginView : FBLoginView!) {
        println("User Logged In")
        println("Perform a segue.")
    }
    
    func loginViewFetchedUserInfo(loginView : FBLoginView!, user: FBGraphUser){
        println("User Facebook Id: \(user.objectID)")
        println("Full Name: \(user.name)")
        var userEmail = user.objectForKey("email") as String
        println("User Email: \(userEmail)")
        
        var prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        prefs.setObject(user.name, forKey: "USERNAME")
        prefs.setInteger(1, forKey: "ISLOGGEDIN")
        prefs.synchronize()
    }
    
    func loginViewShowingLoggedOutUser(loginView : FBLoginView!) {
        println("User Logged Out")
    }
    
    func loginView(loginView : FBLoginView!, handleError:NSError) {
        println("Error: \(handleError.localizedDescription)")
    }
}
