//
//  Alerts.swift
//  VideoChatApp
//
//  Created by Apple on 08/05/2020.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation
import UIKit

func alert(msg : String, controller: UIViewController) {
    let alert = UIAlertController(title: "Alert", message: msg, preferredStyle: UIAlertController.Style.alert)
    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
    controller.present(alert, animated: true, completion: nil)
}

func alertWithCompletion(msg : String, controller: UIViewController, onCompletion:@escaping (Bool) -> Void) {
    let alert = UIAlertController(title: "Alert", message: msg, preferredStyle: UIAlertController.Style.alert)
    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { (success) in
        onCompletion(true)
    }))
    controller.present(alert, animated: true, completion: nil)
}

func alertWithTF(controller: UIViewController, onCompletion:@escaping (Bool, String) -> Void) {
    let alert = UIAlertController(title: "Information", message: "Please suggest genre", preferredStyle: .alert)
    alert.addTextField(configurationHandler: { (textField) -> Void in
//        textField.text = "Genre"
    })
    
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (action) -> Void in
        let textField = alert?.textFields![0] as! UITextField
        print("Text field: \(textField.text)")
        onCompletion(true, textField.text!)
    }))
    
    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { [weak alert] (action) -> Void in
        print("cancel")
    }))

    controller.present(alert, animated: true, completion: nil)
}
