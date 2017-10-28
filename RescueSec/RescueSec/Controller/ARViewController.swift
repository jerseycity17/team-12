//
//  ARViewController.swift
//  RescueSec
//
//  Created by Zenun Vucetovic on 10/28/17.
//  Copyright © 2017 Zenun Vucetovic. All rights reserved.
//

import UIKit
import ARCL
import CoreLocation
import Firebase

class ARViewController: UIViewController {

    var sceneLocationView = SceneLocationView()
    var currentRegion = "europe"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        sceneLocationView.run()
        view.addSubview(sceneLocationView)
        
        var ref = Database.database().reference().child("/important zones/regions/\(currentRegion)")
        
        var handle = ref.observe(DataEventType.value) { (snapshot) in
            
            var values = snapshot.value as? [String: [String:String]]

            
            
            for val in values! {
                
                var long = Double(val.value["longitude"]!)!
                var lat = Double(val.value["lattitude"]!)!
                let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                let location = CLLocation(coordinate: coordinate, altitude: 10)
                
                var image = UIImage(named: "security-on")!

                
                if val.value["dangerLevel"] == "Dangerous" {
                 image = UIImage(named: "warning-signal")!

                } else if val.value["dangerLevel"] == "Cautious" {
                     image = UIImage(named: "danger")!
                    
                } else if val.value["dangerLevel"] == "Safe" {
                     image = UIImage(named: "security-on")!
                    
                } else {
                     image = UIImage(named: "security-on")!
                }
                
                

                
                let annotationNode = LocationAnnotationNode(location: location, image: image)
                //annotationNode.scaleRelativeToDistance = true
                self.sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: annotationNode)
                
                
            }
            
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        sceneLocationView.frame = view.bounds
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
