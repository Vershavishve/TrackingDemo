//
//  ViewController.swift
//  TrackingSwiftAssignment
//
//  Created by Versha Vishavkarma on 03/05/21.
//  Copyright © 2021 Versha Vishve. All rights reserved.
//
import CoreData
import CoreLocation
import UIKit
import MapKit

class ViewController: UIViewController,CLLocationManagerDelegate {

    var locationManager: CLLocationManager?
    var startedTracking:Bool = true
    var locations: [NSManagedObject] = []
    var startTime:Date?
    var endTime:Date?
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
           locationManager = CLLocationManager()
           locationManager?.delegate = self
           locationManager?.desiredAccuracy = kCLLocationAccuracyBestForNavigation
       //    locationManager?.distanceFilter = 5
           locationManager?.allowsBackgroundLocationUpdates = true
           locationManager?.requestAlwaysAuthorization()
        
        // Do any additional setup after loading the view.
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            print("New location is \(location)")
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            self.mapView.setRegion(region, animated: true)
//            let annotation = MKPointAnnotation()
//            annotation.coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
//            self.mapView.clearsContextBeforeDrawing = true
//            self.mapView.addAnnotation(annotation)
            self.getAddressFromLatLon(pdblLatitude: center.latitude, withLongitude: center.longitude)
            saveLocation(location: location)
        }
    }
    func saveLocation(location:CLLocation)
    {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Location", in: context)!
        let newEntity = NSManagedObject(entity: entity, insertInto: context)
        newEntity.setValue(location.coordinate.latitude, forKey: "latitude")
        newEntity.setValue(location.coordinate.longitude, forKey: "longitude")
        newEntity.setValue(location.timestamp, forKey: "timestamp")
//        if let start = startTime
//        {
//           newEntity.setValue(start, forKey: "starttimestamp")
//        }
//        if let end = endTime
//        {
//           newEntity.setValue(end, forKey: "endtimestamp")
//        }
        do {
          try context.save()
          locations.append(newEntity)
        } catch let error as NSError {
          print("Could not save. \(error), \(error.userInfo)")
        }
    }
    @IBAction func btnToStartTrackingClicked(_ sender: Any) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Location", in: context)!
        let newEntity = NSManagedObject(entity: entity, insertInto: context)
        
        
        if startedTracking
        {
            
           // startTime = Date()
            newEntity.setValue(Date(), forKey: "starttimestamp")
            locationManager?.startUpdatingLocation()
            if let button = self.view.viewWithTag(100) as? UIButton
            {
                button.setTitle("Stop Tracking", for: .normal)
            }
            
        }
        else
        {
            //endTime = Date()
            newEntity.setValue(Date(), forKey: "endtimestamp")
            locationManager?.stopUpdatingLocation()
            if let button = self.view.viewWithTag(100) as? UIButton
            {
                button.setTitle("Start Tracking", for: .normal)
            }
            
        }
        startedTracking = !startedTracking
        do {
          try context.save()
        } catch let error as NSError {
          print("Could not save. \(error), \(error.userInfo)")
        }
        
    }
    func getAddressFromLatLon(pdblLatitude: Double, withLongitude pdblLongitude: Double)  {
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
     //   let lat: Double = Double("\(pdblLatitude)")!
        //21.228124
      //  let lon: Double = Double("\(pdblLongitude)")!
        //72.833770
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = pdblLatitude
        center.longitude = pdblLongitude

        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
        

        ceo.reverseGeocodeLocation(loc, completionHandler:
            {(placemarks, error) in
                if (error != nil)
                {
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                }
                let pm = placemarks! as [CLPlacemark]

                if pm.count > 0 {
                    let pm = placemarks![0]
                    var addressString : String = ""
                    if pm.subLocality != nil {
                        addressString = addressString + pm.subLocality! + ", "
                    }
                    if pm.thoroughfare != nil {
                        addressString = addressString + pm.thoroughfare! + ", "
                    }
                    if pm.locality != nil {
                        addressString = addressString + pm.locality! + ", "
                    }
                    if pm.country != nil {
                        addressString = addressString + pm.country! + ", "
                    }
                    if pm.postalCode != nil {
                        addressString = addressString + pm.postalCode! + " "
                    }


                    print(addressString)
                    let annotation = MKPointAnnotation()
                    annotation.title = addressString
                        annotation.coordinate = CLLocationCoordinate2D(latitude: pdblLatitude, longitude: pdblLongitude)
                        self.mapView.clearsContextBeforeDrawing = true
                        self.mapView.addAnnotation(annotation)
                    
              }
                
        })
      
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let vc = segue.destination as? LogsVC else {
            return
        }
    }
}

