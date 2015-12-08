//
//  LocationViewController.swift
//  WeatherOrNot
//
//  Created by Karan Shah on 12/8/15.
//  Copyright © 2015 Karan Shah. All rights reserved.
//

import UIKit
import CoreLocation

class LocationViewController: UIViewController, UITextFieldDelegate {
    
    enum LocationStatus {
        case Found(city: String)
        case Updating
        case Failed(message: String)
    }
    
    @IBOutlet var currentLocationButton: UIButton!
    @IBOutlet var manualCityTextField: UITextField!
    @IBOutlet var stackViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet var topStackView: UIStackView!
    
    let locationManager = CLLocationManager()
    var currentLocationStatus: LocationStatus = .Updating
    var weatherCity: String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateCurrentLabelButtonLabel()
//        setupLocationManager()
        manualCityTextField.delegate = self
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil);
    }
    
    @IBAction func viewCurrentLocationWeather(sender: UIButton) {
//        if case .Found(let city) = currentLocationStatus {
//            weatherCity = city
//            performSegueWithIdentifier("WeatherDetailSegue", sender: nil)
//        }
    }
    
    @IBAction func weaatherDetailsForManullyEnteredCity(sender: UIButton) {
//        if let manualCityInfo = manualCityTextField.text {
//            weatherCity = manualCityInfo
//            performSegueWithIdentifier("WeatherDetailSegue", sender: nil)
//        }
    }
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if let wdc = segue.destinationViewController as? WeatherDetailViewController where segue.identifier == "WeatherDetailSegue" {
//            if weatherCity.characters.count > 0 {
//                wdc.city = weatherCity
//            }
//            weatherCity = ""
//        }
//    }
    
    func updateCurrentLabelButtonLabel() {
        let currentButtonText: String
        switch currentLocationStatus {
        case .Found(let cityString):
            currentButtonText = "View Weather for \(cityString)"
        case .Updating:
            currentButtonText = "Updating Current Location..."
        case .Failed(let failureMessage):
            currentButtonText = failureMessage
        }
        currentLocationButton.setTitle(currentButtonText, forState: .Normal)
        
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        if let info = notification.userInfo {
            let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
            UIView.animateWithDuration(0.8, animations: { () -> Void in
                self.topStackView.hidden = true
                self.stackViewBottomConstraint.constant = keyboardFrame.size.height + 20
            })
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        UIView.animateWithDuration(0.8) { () -> Void in
            self.stackViewBottomConstraint.constant = 20
            self.topStackView.hidden = false            
        }
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }
}


