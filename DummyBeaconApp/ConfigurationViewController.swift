//
//  ConfigurationViewController.swift
//  DummyBeaconApp
//
//  Created by Daniel Seijo Sánchez on 25/4/15.
//  Copyright © 2015 Daniel Seijo Sánchez. All rights reserved.
//

import UIKit

class ConfigurationViewController: UIViewController {
    
    @IBOutlet weak var infoLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func chooseA(sender: AnyObject) {
        infoLabel.text = "Hola Mamá"
    }
    
    @IBAction func chooseB(sender: AnyObject) {
        
    }
    
    @IBAction func chooseC(sender: AnyObject) {
        
    }
    
    @IBAction func chooseD(sender: AnyObject) {
        
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
