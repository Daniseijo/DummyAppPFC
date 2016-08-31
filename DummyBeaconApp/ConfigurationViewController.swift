//
//  ConfigurationViewController.swift
//  DummyBeaconApp
//
//  Created by Daniel Seijo Sánchez on 25/4/15.
//  Copyright © 2015 Daniel Seijo Sánchez. All rights reserved.
//

import UIKit
import CoreLocation
import CoreBluetooth

class ConfigurationViewController: UIViewController, CBPeripheralManagerDelegate {
    
    @IBOutlet weak var infoLabel: UILabel!
    
    var name:String!
    let uuid:String = "0018B4CC-1937-4981-B893-9D7191B22E35"
    var major:CLBeaconMajorValue!
    var minor:CLBeaconMinorValue!
    
    let power:NSNumber = -60
    var peripheralData:NSDictionary!
    var peripheralManager:CBPeripheralManager!
    var region:CLBeaconRegion!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func chooseA(sender: UIButton) {
        name = "BeaconA"
        major = 2
        minor = 1
        activateBeacon()
    }
    
    @IBAction func chooseB(sender: UIButton) {
        name = "BeaconB"
        major = 1
        minor = 1
        activateBeacon()
    }
    
    @IBAction func chooseC(sender: UIButton) {
        name = "BeaconC"
        major = 1
        minor = 3
        activateBeacon()
    }
    
    @IBAction func chooseD(sender: UIButton) {
        name = "BeaconD"
        major = 1
        minor = 4
        activateBeacon()
    }
    
    func activateBeacon() {
        infoLabel.text = "UUID: \(uuid) | Major: \(major) | Minor: \(minor)"
        
        if region != nil {
            stopLocalBeacon()
        }
        
        let uuidConverted = NSUUID(UUIDString: uuid)!
        region = CLBeaconRegion(proximityUUID: uuidConverted, major: major, minor: minor, identifier: name)
        
        peripheralData = region.peripheralDataWithMeasuredPower(nil)
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil, options: nil)
    }
    
    func stopLocalBeacon() {
        peripheralManager.stopAdvertising()
        peripheralManager = nil
        peripheralData = nil
        region = nil
    }
    
    func peripheralManagerDidUpdateState(peripheral: CBPeripheralManager) {
        if peripheral.state == .PoweredOn {
            peripheralManager.startAdvertising(peripheralData as! [String: AnyObject]!)
        } else if peripheral.state == .PoweredOff {
            peripheralManager.stopAdvertising()
        }
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
