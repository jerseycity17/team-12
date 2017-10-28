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

class MainViewController: UIViewController, CLLocationManagerDelegate {
   
    
    
    var ref: DatabaseReference!
    
    var UID = "123456789"
    
    var currentRegion = "europe"
    
    var firstView = 1
    
    let locationManager = CLLocationManager()

    
    @IBOutlet weak var markedSafeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }

        markedSafeButton.layer.cornerRadius = 5
        
        ref = Database.database().reference()

        
        var ref2 = Database.database().reference().child("/safety checks/regions/\(currentRegion)")
        
        
//        var refHandle = ref2.observe(DataEventType.value, with: { (snapshot) in
//            print("ADDED SAFETY CHECK")
//
//
//                if self.firstView != 1 {
//                var values = snapshot.value as? [String: [String:String]]
//                var hello = values!.sorted{ $0.key > $1.key }
//                ref2.child("\(hello.first!.key)/isSafe").setValue("true")
//
//                var size = hello.count - 1
//                var cnt = 0
//
//                    let alertController = UIAlertController(title: hello.first!.value["title"]!, message: hello.first!.value["message"]!, preferredStyle: .alert)
//                            let safeAction = UIAlertAction(title: "SAFE", style: .default, handler: { (action) in
//                                //send back i am safe
//                                ref2.child("\(hello.first!.key)/isSafe").setValue("true")
//                                self.dismiss(animated: true, completion: nil)
//                            })
//                            let notSafe = UIAlertAction(title: "NOT SAFE", style: .default, handler: { (action) in
//                                ref2.child("\(hello.first!.key)/isSafe").setValue(false)
//                            })
//
//                            alertController.addAction(safeAction)
//                            alertController.addAction(notSafe)
//
//
//                            self.present(alertController, animated: true, completion: nil)
//
//
//
//
//
//            }
//            // ...
//
//
//            if self.firstView == 1 {
//                self.firstView = self.firstView + 1
//            }
//        })
//
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sendLocationButtonTapped(_ sender: Any) {
        
        var locValue:CLLocationCoordinate2D = locationManager.location!.coordinate
        self.ref.child("users/\(UID)/locations/current").setValue("\(locValue.latitude), \(locValue.longitude)")

        
        
    }
    
    
    @IBAction func arButtonTapped(_ sender: Any) {
        
        let arVC  = ARViewController()
        self.navigationController?.pushViewController(arVC, animated: true)
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        var locValue:CLLocationCoordinate2D = manager.location!.coordinate
    }
    
    
    @IBAction func markedSafeButtonTapped(_ sender: Any) {
        ref = Database.database().reference()
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        let resultDate = formatter.string(from: date)

        
        var ref2 = Database.database().reference().child("/safety checks/regions/\(currentRegion)")
        
        
        var refHandle = ref2.observe(DataEventType.value, with: { (snapshot) in
            print("ADDED SAFETY CHECK")
            
            
            
                var values = snapshot.value as? [String: [String:String]]
                var hello = values!.sorted{ $0.key > $1.key }
                ref2.child("\(hello.first!.key)/title").setValue("Safety Check")
                ref2.child("\(hello.first!.key)/body").setValue("Zenun marked himself safe on \(resultDate)")
                ref2.child("\(hello.first!.key)/region").setValue("Europe")


            
                
                var size = hello.count - 1
                var cnt = 0
                
                let alertController = UIAlertController(title: "Good job!", message: "You marked yourself safe!", preferredStyle: .alert)
                let safeAction = UIAlertAction(title: "Thanks", style: .default, handler: { (action) in
                    //send back i am safe
                    self.markedSafeButton.isHidden = true
                    self.dismiss(animated: true, completion: nil)
                })
            
                alertController.addAction(safeAction)
                
                
                self.present(alertController, animated: true, completion: nil)
                
                
                
                
                
            })
        
        
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
