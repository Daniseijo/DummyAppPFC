//
//  RangeViewController.swift
//  DummyBeaconApp
//
//  Created by Daniel Seijo Sánchez on 29/8/15.
//  Copyright (c) 2015 Daniel Seijo Sánchez. All rights reserved.
//

import UIKit
import CoreLocation

class RangeViewController: UIViewController, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    let region = CLBeaconRegion(proximityUUID: NSUUID(UUIDString: "E2C56DB5-DFFB-48D2-B060-D0F5A71096E0"), identifier: "Estimotes");
    let colors = [
        1: UIColor(red: 84/255, green: 77/255, blue: 160/255, alpha: 1),
        2: UIColor(red: 142/255, green: 212/255, blue: 220/255, alpha: 1),
        3: UIColor(red: 162/255, green: 213/255, blue: 181/255, alpha: 1)
    ];
    
    @IBOutlet weak var proximityImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        locationManager.delegate = self;
        
        if (CLLocationManager.authorizationStatus() != CLAuthorizationStatus.AuthorizedWhenInUse) {
            locationManager.requestWhenInUseAuthorization();
        }
        
        locationManager.startRangingBeaconsInRegion(region);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Location Manager Delegate
    
    func locationManager(manager: CLLocationManager!, didRangeBeacons beacons: [AnyObject]!, inRegion region: CLBeaconRegion!) {
        //println(beacons);
        let knownBeacons = beacons.filter{ $0.proximity != CLProximity.Unknown }
        
        if (knownBeacons.count > 0) {
            let closestBeacon = knownBeacons[0] as! CLBeacon;
            var frame:CGRect = self.proximityImage.frame
            println(self.view.frame.size.height + CGFloat(closestBeacon.accuracy.distanceTo(0.0)));
            //println(closestBeacon.accuracy.distanceTo(0.0));
            frame.origin.y = (self.view.frame.size.height - 60) + CGFloat((60*closestBeacon.accuracy.distanceTo(0.0)));
            self.proximityImage.frame = frame
            //self.view.backgroundColor = self.colors[closestBeacon.minor.integerValue]
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
