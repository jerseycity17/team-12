//
//  MainViewController.swift
//  RescueSec
//
//  Created by Zenun Vucetovic on 10/27/17.
//  Copyright © 2017 Zenun Vucetovic. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation

class MainViewController: UIViewController {
   
    
    
    var ref: DatabaseReference!
    
    var UID = "123456789"
    
    var currentRegion = "europe"
    
    var firstView = 1
    

    override func viewDidLoad() {
        super.viewDidLoad()

        ref = Database.database().reference()

        
        var ref2 = Database.database().reference().child("/safety checks/regions/\(currentRegion)")
        
        
        var refHandle = ref2.observe(DataEventType.value, with: { (snapshot) in
            print("ADDED SAFETY CHECK")
            
            
                if self.firstView != 1 {
                var values = snapshot.value as? [String: [String:String]]
                var hello = values!.sorted{ $0.key > $1.key }
            
                var size = hello.count - 1
                var cnt = 0
                
                    let alertController = UIAlertController(title: hello.first!.value["title"]!, message: hello.first!.value["message"]!, preferredStyle: .alert)
                            let safeAction = UIAlertAction(title: "SAFE", style: .default, handler: { (action) in
                                //send back i am safe
                                ref2.child("\(hello.first!.key)/isSafe").setValue("true")
                                self.dismiss(animated: true, completion: nil)
                            })
                            let notSafe = UIAlertAction(title: "NOT SAFE", style: .default, handler: { (action) in
                                ref2.child("\(hello.first!.key)/isSafe").setValue(false)
                            })
                            
                            alertController.addAction(safeAction)
                            alertController.addAction(notSafe)
                            
                            
                            self.present(alertController, animated: true, completion: nil)
                        
                    
                    
                
                
            }
            // ...
            
            
            if self.firstView == 1 {
                self.firstView = self.firstView + 1
            }
        })
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sendLocationButtonTapped(_ sender: Any) {
        
        self.ref.child("users/\(UID)/locations/current").setValue("78.12312, -19.123123")

        
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
