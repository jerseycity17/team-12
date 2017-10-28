//
//  SendViewController.swift
//  RescueSec
//
//  Created by Zenun Vucetovic on 10/27/17.
//  Copyright © 2017 Zenun Vucetovic. All rights reserved.
//

import UIKit
import Firebase

class SendViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textView: UITextView!
    
    var ref: DatabaseReference!

    var broadcasts = [String]()
    
    var currentRegion = "europe"
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        var ref2 = Database.database().reference().child("/feed")
        
        
        var refHandle = ref2.observe(DataEventType.value, with: { (snapshot) in
            print("ADDED SAFETY CHECK")
            
            self.broadcasts.removeAll()
            
                var values = snapshot.value as? [String: [String:String]]
                var hello = values!.sorted{ $0.key > $1.key }
            
            for i in hello {
                    var size = hello.count - 1
                    var cnt = 0
                
                    var message = hello.first!.value["body"]!
                
                hello.remove(at: 0)
            
                    self.broadcasts.append(message)
                }
            
            // ...
            self.tableView.reloadData()
            
        })
        
    
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        sendButton.layer.cornerRadius = 5
        textView.layer.cornerRadius = 5
        textView.clipsToBounds = true
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return broadcasts.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath)
        
        cell.textLabel?.text = broadcasts[indexPath.row]
        cell.textLabel?.numberOfLines = 0
        
        return cell
    }
    
    @IBAction func sendMessageButtonTapped(_ sender: Any) {
        
//        var ref2 = Database.database().reference().child("/feed")
//
//        
//        if textView.text != "" {
//            
//            ref2.setValue(textView.text!)
//        }
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
