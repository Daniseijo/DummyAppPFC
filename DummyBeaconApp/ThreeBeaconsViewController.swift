//
//  ThreeBeaconsViewController.swift
//  DummyBeaconApp
//
//  Created by Daniel Seijo Sánchez on 8/11/16.
//  Copyright © 2016 Daniel Seijo Sánchez. All rights reserved.
//

import UIKit
import CoreLocation

class ThreeBeaconsViewController: UIViewController {
    
    let TAG_NUMBER_CIRCLES = 53456
    
    let locationManager = CLLocationManager()
    let model = Model()
    let region = CLBeaconRegion(proximityUUID: UUID(uuidString: "0018B4CC-1937-4981-B893-9D7191B22E35")!, identifier: "BeaconA")
    
    var x1:CGFloat = 0
    var y1:CGFloat = 0
    var x2:CGFloat = 0
    var y2:CGFloat = 0
    var x3:CGFloat = 0
    var y3:CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let totalHeight = self.view.frame.size.height - self.tabBarController!.tabBar.frame.size.height
        var navBarHeight:CGFloat = 0
        if let navController = self.navigationController {
            navBarHeight = navController.navigationBar.frame.size.height + 20 // 20 es del status bar
        } else {
            navBarHeight = 20
        }
        
        x1 = ((self.view.frame.width - 40) / 2)
        y1 = totalHeight - 100
        x2 = 0
        y2 = navBarHeight + 50
        x3 = self.view.frame.width - 50
        y3 = navBarHeight + 50
        
        addProxCircle(x1, Y: y1, diameter: 40, color: UIColor.black, andTag: 1)
        addProxCircle(x2, Y: y2, diameter: 40, color: UIColor.black, andTag: 2)
        addProxCircle(x3, Y: y3, diameter: 40, color: UIColor.black, andTag: 3)
        
        locationManager.delegate = self
        if (CLLocationManager.authorizationStatus() != CLAuthorizationStatus.authorizedWhenInUse) {
            locationManager.requestWhenInUseAuthorization()
        }
        
        locationManager.startRangingBeacons(in: region)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addProxCircle (_ withX: CGFloat, Y: CGFloat, diameter: CGFloat, color: UIColor, andTag: Int) {
        // Sumamos 10 al diametro, que luego se restará en la vista, porque si no, se ve el borde del círculo al pintarlo
        let diametro = diameter + 10
        
        // Eliminamos el anterior círculo si es que había
        removeProxCircle(andTag)
        
        // Creamos la posición del nuevo círculo
        let circleView = ProxRangeView(frame: CGRect (x: withX, y: Y, width: diametro, height: diametro))
        
        // Le ponemos el color elegido
        circleView.color = color
        
        // Le ponemos una tag para eliminar la vista después
        circleView.tag = TAG_NUMBER_CIRCLES + andTag
        
        // Lo añadimos a la vista
        view.addSubview(circleView)
    }
    
    func removeProxCircle (_ withTag: Int) {
        if let viewTag = self.view.viewWithTag(TAG_NUMBER_CIRCLES + withTag) {
            viewTag.removeFromSuperview()
        }
    }
}

// MARK: - Location Manager Delegate
extension ThreeBeaconsViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        //println(beacons)
        let knownBeacons = beacons.filter{ $0.proximity != CLProximity.unknown }
        
        if (knownBeacons.count >= 3) {
            var beacon1: CLBeacon? = nil
            var beacon2: CLBeacon? = nil
            var beacon3: CLBeacon? = nil
            
            for beacon in knownBeacons {
                print("UUID: \(beacon.proximityUUID); Major: \(beacon.major); Minor: \(beacon.minor)")
                if (beacon.major == 1) {
                    switch beacon.minor {
                    case 1:
                        beacon1 = beacon
                        break
                    case 2:
                        beacon2 = beacon
                        break
                    case 3:
                        beacon3 = beacon
                        break
                    default:
                        break
                    }
                }
            }
            
            if (beacon1 == nil || beacon2 == nil || beacon3 == nil) {
                removeProxCircle(0)
            } else {
                let pointBeacon1 = CGPoint.init(x: x1, y: y1)
                let pointBeacon2 = CGPoint.init(x: x2, y: y2)
                let pointBeacon3 = CGPoint.init(x: x3, y: y3)
                let point = getCoordinateWithBeacons(pointBeacon1, B: pointBeacon2, C: pointBeacon3,
                                                     dA: CGFloat(((beacon1?.accuracy)!*100)/2),
                                                     dB: CGFloat(((beacon2?.accuracy)!*100)/2),
                                                     dC: CGFloat(((beacon3?.accuracy)!*100)/2))
                addProxCircle(point.x, Y: point.y, diameter: 20, color: UIColor.blue, andTag: 0)
            }
        } else {
            removeProxCircle(0)
        }
    }
    
    func getCoordinateWithBeacons (_ A: CGPoint, B: CGPoint, C: CGPoint, dA: CGFloat, dB: CGFloat, dC: CGFloat) -> CGPoint {
        
        let dA2 = dA*dA
        let dB2 = dB*dB
        let dC2 = dC*dC
        let aX2 = A.x*A.x
        let bX2 = B.x*B.x
        let cX2 = C.x*C.x
        let aY2 = A.y*A.y
        let bY2 = B.y*B.y
        let cY2 = C.y*C.y
        
        let W = dA2 - dB2 - aX2 - aY2 + bX2 + bY2
        let Z = dB2 - dC2 - bX2 - bY2 + cX2 + cY2
    
        let x = (W*(C.y-B.y) - Z*(B.y-A.y)) / (2 * ((B.x-A.x)*(C.y-B.y) - (C.x-B.x)*(B.y-A.y)))
        let y = (W - 2*x*(B.x-A.x)) / (2*(B.y-A.y))
        
        return CGPoint.init(x: x, y: y)
    }
}



