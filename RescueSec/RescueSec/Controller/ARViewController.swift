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

        var backButton = UIButton(frame: CGRect(x: 30, y: 30, width: 80, height: 50))
        backButton.layer.cornerRadius = 7
        backButton.setTitle("Back", for: .normal)
        backButton.backgroundColor = UIColor(hexString: "FEC903")
        backButton.addTarget(self, action: #selector(backButtonTapped(_:)), for: .touchUpInside)

        sceneLocationView.run()
        view.addSubview(sceneLocationView)
        view.addSubview(backButton)
        view.bringSubview(toFront: backButton)
        
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
    
    @objc func backButtonTapped(_ sender: Any) {
        

        self.navigationController?.popViewController(animated: true)
        
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

extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.characters.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}
