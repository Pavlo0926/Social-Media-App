//
//  ActionSheet.swift
//  VideoChatApp
//
//  Created by Apple on 01/05/2020.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation
import UIKit

class ActionSheet {
    
    func sheetPopUp(controller: UIViewController, options : [String], sheetTitle: String, onCompletion:@escaping (String) -> Void) {

        
        var actionSheetController: UIAlertController = UIAlertController(title: sheetTitle, message: nil, preferredStyle: .actionSheet)
        if sheetTitle.elementsEqual(""){
            actionSheetController.title = nil
        }
        
        
        for i in options {
            
            if i == "Block" {
                let btn = UIAlertAction(title: i, style: .destructive) { (action) in
                    print(i)
                    onCompletion(i)
                }
                actionSheetController.addAction(btn)
            }else {
                let btn = UIAlertAction(title: i, style: .default) { (action) in
                    print(i)
                    onCompletion(i)
                }
                actionSheetController.addAction(btn)
            }
            
        }
        let cancelBtn = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            print("Cancel")
            onCompletion("Cancel")
        }
        actionSheetController.addAction(cancelBtn)
        actionSheetController.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = UIColor.white
        
        controller.present(actionSheetController, animated: true, completion: nil)
    }
    
    
}
