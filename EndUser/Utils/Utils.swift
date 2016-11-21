//
//  Utils.swift
//  DevBoy
//
//  Created by Ahmad Abdul-Gawad Mahmoud on 11/12/16.
//  Copyright © 2016 Ahmad Abdul-Gawad Mahmoud. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth
import Firebase
@objc class Utils: NSObject {
    
    
    static var locationsRef = FIRDatabase.database().reference().child("locations3")
    
    static var demoView: DemoView?
    
    override init() {
        
        super.init()

        print(Utils.locationsRef)
        
    }
    
    
    class func observeNewLocations() {
        
        locationsRef.observe(.childAdded) {(snapshot: FIRDataSnapshot) in
            
            print(snapshot.value ?? "Empty Location")
            
            if let dict = snapshot.value as? [String : String]  {
                
                if (demoView?.tracking)! {
                
                    NotificationCenter.default.post(name: NSNotification.Name("newLocationAdded"), object: dict)
                }
            }
        }
    
        

        
    }

}
