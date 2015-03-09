//
//  RegisterViewController.swift
//  SeatSmart
//
//  Created by Huey Ly on 2/23/15.
//  Copyright (c) 2015 SeatSmart. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var fullNameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var zipcodeField: UITextField!
    
    @IBOutlet weak var eventDetailsField: UITextView!
    
    let seatsmartApi = SeatSmartApi()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.eventDetailsField.text = "Event Details: \n" +
            "Denver Nuggets at San Antonio Spurs \n\n" +
            "Location: AT&T Center \n" +
            "Date: Friday, Mar 06, 2015 7:30PM\n" +
            "Price: $45.00"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue:
        UIStoryboardSegue, sender: AnyObject?) {
        
        var fullname = self.fullNameField.text
        var email = self.emailField.text
        var password = self.passwordField.text
            
        println("Register submitted: ")
        println(fullname)
        println(email)
        println(password)
        
        self.seatsmartApi.registerUser(fullname, email: email, self.handlePostSubmitted)
            
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

    func handlePostSubmitted(response: AnyObject) {
        println("Post response: ")
        println(response)
    }
}
