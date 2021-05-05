//
//  DetailVC.swift
//  TrackingSwiftAssignment
//
//  Created by Versha Vishavkarma on 04/05/21.
//  Copyright © 2021 Versha Vishve. All rights reserved.
//
import CoreData
import MapKit
import UIKit

class DetailVC: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    var selectedLocation: NSManagedObject?
    var address = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        if let lat = selectedLocation?.value(forKey: "latitude") as? Double,let long = selectedLocation?.value(forKey: "longitude") as? Double
        {
            let center = CLLocationCoordinate2D(latitude: lat, longitude: long)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
                self.mapView.setRegion(region, animated: true)
            self.getAddressFromLatLon(pdblLatitude: lat, withLongitude: long)
            
        }
        // Do any additional setup after loading the view.
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
                      //  self.mapView.clearsContextBeforeDrawing = true
                        self.mapView.addAnnotation(annotation)
                    self.address = addressString
                    
              }
                
        })
      
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
