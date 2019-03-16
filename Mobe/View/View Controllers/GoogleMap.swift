//
//  GoogleMap.swift
//  Mobe
//
//  Created by user on 06/03/19.
//  Copyright © 2019 MacBook-Pro-4. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import Alamofire
import SwiftyJSON
import CoreLocation


class GoogleMap: UIViewController, GMSMapViewDelegate,CLLocationManagerDelegate{
    
    @IBOutlet weak var txtStartLocation: UITextField!
    var zoom :Float = 15
    var lat1 = 10.088404
    var lat2 = 13.088404
    var long1 = 77.298873
    var long2 = 80.298873
    var orign = ""
    var destination = ""
    
    @IBOutlet weak var txtDestinationLocation: UITextField!
    @IBOutlet weak var viewForGoogleMap: GMSMapView!
    var locationManager:CLLocationManager!
    override func viewDidLoad() {
        super.viewDidLoad()
        if (CLLocationManager.locationServicesEnabled()){
            print("GPS ON ")
            navigationController?.hidesBarsOnTap = true
            orign = "\(lat1),\(long1)"
            destination = "\(lat2),\(long2)"
            txtStartLocation.text = orign
            txtDestinationLocation.text = destination
            print("originb",orign,destination)
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            
            if CLLocationManager.locationServicesEnabled(){
                locationManager.startUpdatingLocation()
            }
        }
        GMSServices.provideAPIKey("AIzaSyC907BQBnrZK0UjA2zARtE6Mq7L__yqw5Q")
        GMSPlacesClient.provideAPIKey("AIzaSyC907BQBnrZK0UjA2zARtE6Mq7L__yqw5Q")
        
        
        // Create a GMSCameraPosition that tells the map to display the
        
        let camera = GMSCameraPosition.camera(withLatitude: lat1,
                                              longitude: long1,
                                              zoom: 10.0,
                                              bearing: 30,
                                              viewingAngle: 40)
        //Setting the viewForGoogleMap
        self.viewForGoogleMap.camera = camera
        self.viewForGoogleMap.delegate = self
        self.viewForGoogleMap?.isMyLocationEnabled = true
        self.viewForGoogleMap.settings.myLocationButton = true
        self.viewForGoogleMap.settings.compassButton = true
        self.viewForGoogleMap.settings.zoomGestures = true
        self.viewForGoogleMap.animate(to: camera)
        self.view.addSubview(self.viewForGoogleMap)
        
        
        
        
        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(orign)&destination=\(destination))&mode=driving"
        print("url for google map",url)
        //Rrequesting Alamofire and SwiftyJSON
        Alamofire.request(url).responseJSON { response in
            print(response.request as Any)  // original URL request
            print(response.response as Any) // HTTP URL response
            print(response.data as Any)     // server data
            print(response.result)   // result of response serialization
            do{
                let json = try JSON(data: response.data!)
                let routes = json["routes"].arrayValue
                for route in routes
                {
                    let routeOverviewPolyline = route["overview_polyline"].dictionary
                    let points = routeOverviewPolyline?["points"]?.stringValue
                    let path = GMSPath.init(fromEncodedPath: points!)
                    let polyline = GMSPolyline.init(path: path)
                    polyline.strokeColor = UIColor.blue
                    polyline.strokeWidth = 2
                    polyline.map = self.viewForGoogleMap
                }
            }
            catch{
                print("nil json data for google map")
            }
            
            
            
        }
        
        
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: lat1, longitude: long1)
        marker.title = "Mobiloitte"
        marker.snippet = "India"
        //28.524555 77.275111   28.643091  77.218280
        marker.map = viewForGoogleMap
        
        //28.643091, 77.218280
        let marker1 = GMSMarker()
        marker1.position = CLLocationCoordinate2D(latitude: lat2, longitude: long2)
        marker1.title = "NewDelhi"
        marker1.snippet = "India"
        marker1.map = viewForGoogleMap
        draw()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Drawing straight line between two points.
    @objc func draw() {
        let path = GMSMutablePath()
        path.addLatitude(lat1, longitude:long1)
        path.addLatitude(lat2, longitude:long2)
        
        
        let polyline = GMSPolyline(path: path)
        polyline.strokeColor = .blue
        polyline.strokeWidth = 5.0
        polyline.geodesic = true
        polyline.map = self.viewForGoogleMap
        
        
    }
    
    @IBAction func zoomOut(_ sender: Any) {
        zoom = zoom - 1
        viewForGoogleMap.animate(toZoom: zoom)
       
    }
    
    @IBAction func zoomIn(_ sender: Any) {
        zoom = zoom + 1
        self.viewForGoogleMap.animate(toZoom: zoom)
    }
    
    
    // get current location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("hisafhskjfsdjgh")
        let userLocation :CLLocation = locations[0] as CLLocation
        print("user latitude = \(userLocation.coordinate.latitude)")
        print("user longitude = \(userLocation.coordinate.longitude)")
        
        
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(userLocation) { (placemarks, error) in
            if (error != nil){
                print("error in reverseGeocode")
            }
            let placemark = placemarks! as [CLPlacemark]
            if placemark.count>0{
                let placemark = placemarks![0]
                print(placemark.locality!)
                print(placemark.administrativeArea!)
                print(placemark.country!)
                print("CURRENT LOACTION","\(placemark.locality!), \(placemark.administrativeArea!), \(placemark.country!)")
                //self.labelAdd.text = "\(placemark.locality!), \(placemark.administrativeArea!), \(placemark.country!)"
            }
        }
        
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error)")
    }
    
    
}

