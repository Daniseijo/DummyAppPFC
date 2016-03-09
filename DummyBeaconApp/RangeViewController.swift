//
//  RangeViewController.swift
//  DummyBeaconApp
//
//  Created by Daniel Seijo Sánchez on 29/8/15.
//  Copyright © 2015 Daniel Seijo Sánchez. All rights reserved.
//

import UIKit
import CoreLocation

class RangeViewController: UIViewController {
    
    let locationManager = CLLocationManager()
    let model = Model()
    let region = CLBeaconRegion(proximityUUID: NSUUID(UUIDString: "E2C56DB5-DFFB-48D2-B060-D0F5A71096E0")!, identifier: "Estimotes");
    let colors = [
        CLProximity.Immediate: UIColor(red: 84/255, green: 77/255, blue: 160/255, alpha: 1),
        CLProximity.Near: UIColor(red: 142/255, green: 212/255, blue: 220/255, alpha: 1),
        CLProximity.Far: UIColor(red: 162/255, green: 213/255, blue: 181/255, alpha: 1)];
    let TAG_NUMBER_CIRCLES = 53456
    
    @IBOutlet weak var proximityLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
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
    
    // MARK: - Additional Methods
    func addProxCircle (withHeight: CGFloat, andDiameter: CGFloat) {
        // Sumamos 10 al diametro, que luego se restará en la vista, porque si no, se ve el borde del círculo al pintarlo
        let diametro = andDiameter + 10;
        
        // Eliminamos el anterior círculo si es que había
        removeProxCircle()
        
        // Creamos la posición del nuevo círculo
        let circleView = ProxRangeView(frame: CGRectMake (((self.view.frame.width - diametro) / 2), withHeight, diametro, diametro))
        
        // Le ponemos una tag para eliminar la vista después
        circleView.tag = TAG_NUMBER_CIRCLES
        
        // Lo añadimos a la vista
        view.addSubview(circleView)
    }
    
    func removeProxCircle () {
        if let viewTag = self.view.viewWithTag(TAG_NUMBER_CIRCLES) {
            viewTag.removeFromSuperview()
        }
    }
    
    func CLProximity2String(proximity: CLProximity) -> String {
        switch proximity {
        case .Far:
            return "Far";
        case .Immediate:
            return "Inmediate";
        case .Near:
            return "Near";
        case .Unknown:
            return "Unknown";
        }
    }
    
}

// MARK: - Location Manager Delegate
extension RangeViewController: CLLocationManagerDelegate {
    
    func locationManager(manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], inRegion region: CLBeaconRegion) {
        //println(beacons);
        let knownBeacons = beacons.filter{ $0.proximity != CLProximity.Unknown }
        
        if (knownBeacons.count > 0) {
            let totalHeight = self.view.frame.size.height - self.tabBarController!.tabBar.frame.size.height;
            let navBarHeight = self.navigationController!.navigationBar.frame.size.height + 20; // 20 es del status bar
            
            let closestBeacon = knownBeacons[0] ;
            let distance = -(closestBeacon.accuracy.distanceTo(0.0));
            let proximity = closestBeacon.proximity;
            
            let newHeight = CGFloat(model.meters2Point(
                distance,
                withMaxMeters: 10.0,
                inRangeMin: Float(navBarHeight),
                andMax: Float(totalHeight)));
            
            addProxCircle(newHeight, andDiameter: 20)
            self.proximityLabel.text = "Proximity: " + CLProximity2String(proximity);
            self.distanceLabel.text = "Distance: " + distance.description;
            
            self.view.backgroundColor = self.colors[closestBeacon.proximity]
        } else {
            removeProxCircle()
            self.proximityLabel.text = "Proximity: " + CLProximity2String(CLProximity.Unknown);
            self.distanceLabel.text = "Distance: Unknown"
        }
    }
    
}
