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
    let region = CLBeaconRegion(proximityUUID: UUID(uuidString: "0018B4CC-1937-4981-B893-9D7191B22E35")!, identifier: "BeaconA");
    let colors = [
        CLProximity.immediate: UIColor(red: 84/255, green: 77/255, blue: 160/255, alpha: 1),
        CLProximity.near: UIColor(red: 142/255, green: 212/255, blue: 220/255, alpha: 1),
        CLProximity.far: UIColor(red: 162/255, green: 213/255, blue: 181/255, alpha: 1)];
    let TAG_NUMBER_CIRCLES = 53456
    
    @IBOutlet weak var proximityLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        locationManager.delegate = self;
        if (CLLocationManager.authorizationStatus() != CLAuthorizationStatus.authorizedWhenInUse) {
            locationManager.requestWhenInUseAuthorization();
        }
        
        locationManager.startRangingBeacons(in: region);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Additional Methods
    
    func addProxCircle (_ withHeight: CGFloat, andDiameter: CGFloat) {
        // Sumamos 10 al diametro, que luego se restará en la vista, porque si no, se ve el borde del círculo al pintarlo
        let diametro = andDiameter + 10;
        
        // Eliminamos el anterior círculo si es que había
        removeProxCircle()
        
        // Creamos la posición del nuevo círculo
        let circleView = ProxRangeView(frame: CGRect (x: ((self.view.frame.width - diametro) / 2), y: withHeight, width: diametro, height: diametro))
        
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
    
    func CLProximity2String(_ proximity: CLProximity) -> String {
        switch proximity {
        case .far:
            return "Far";
        case .immediate:
            return "Immediate";
        case .near:
            return "Near";
        case .unknown:
            return "Unknown";
        }
    }
    
}

// MARK: - Location Manager Delegate
extension RangeViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        //println(beacons);
        let knownBeacons = beacons.filter{ $0.proximity != CLProximity.unknown }
        
        if (knownBeacons.count > 0) {
            let totalHeight = self.view.frame.size.height - self.tabBarController!.tabBar.frame.size.height;
            var navBarHeight:CGFloat = 0
            if let navController = self.navigationController {
                 navBarHeight = navController.navigationBar.frame.size.height + 20; // 20 es del status bar
            } else {
                navBarHeight = 20
            }
            let closestBeacon = knownBeacons[0] ;
            let distance = -(closestBeacon.accuracy.distance(to: 0.0));
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
            self.proximityLabel.text = "Proximity: " + CLProximity2String(CLProximity.unknown);
            self.distanceLabel.text = "Distance: Unknown"
        }
    }
    
}
