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
    var uuid:String!
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
        uuid = "AE4E2401-5DEB-4F8D-901C-86932A63ABF2"
        major = 1
        minor = 1
        activateBeacon()
    }
    
    @IBAction func chooseB(sender: UIButton) {
        name = "BeaconB"
        uuid = "FF47C188-D2DF-46A7-80E9-80A8D0A67136"
        major = 1
        minor = 1
        activateBeacon()
    }
    
    @IBAction func chooseC(sender: UIButton) {
        name = "BeaconC"
        uuid = "12BD4C44-D731-4474-AA16-7945C29A582D"
        major = 1
        minor = 1
        activateBeacon()
    }
    
    @IBAction func chooseD(sender: UIButton) {
        name = "BeaconD"
        uuid = "3F9B3CDB-6CB1-4A91-BF36-D3DFE25C6D11"
        major = 1
        minor = 1
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
