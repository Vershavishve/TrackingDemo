//
//  LogsVC.swift
//  TrackingSwiftAssignment
//
//  Created by Versha Vishavkarma on 03/05/21.
//  Copyright © 2021 Versha Vishve. All rights reserved.
//
import CoreData
import UIKit

class LogsVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tblVw: UITableView!
    var locations: [NSManagedObject] = []
    var selectedItem:NSManagedObject?
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        tblVw.reloadData()
        // Do any additional setup after loading the view.
    }
    func fetchData()
    {
        guard let appDelegate =
          UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext =
          appDelegate.persistentContainer.viewContext
        
        //2
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Location")
        let sort = NSSortDescriptor(key: #keyPath(Location.timestamp.timeIntervalSinceNow), ascending: false)
        let sort2 = NSSortDescriptor(key: #keyPath(Location.starttimestamp.timeIntervalSinceNow), ascending: false)
         let sort3 = NSSortDescriptor(key: #keyPath(Location.endtimestamp.timeIntervalSinceNow), ascending: false)
        fetchRequest.sortDescriptors = [sort,sort2,sort3]
        //3
        do {
          locations = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
          print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.locations.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "LogsCell", for: indexPath) as! LogsCell
        if let lat = locations[indexPath.row].value(forKey: "latitude") as? Double
        {
            cell.lblLatitude.text  = "Latitude : \(lat)"
        }
        else
        {
            cell.lblLatitude.text  = ""
        }
        if let long = locations[indexPath.row].value(forKey: "longitude") as? Double
        {
            cell.lblLongitude.text  = "LOngitude : \(long)"
        }
        else
        {
            cell.lblLongitude.text  = ""
        }
        if let time = locations[indexPath.row].value(forKey: "timestamp") as? Date
        {
            cell.lblTimestamp.text  = "TImestamp : \(time)"
        }
        else
        {
            cell.lblTimestamp.text  = ""
        }
        if let starttime = locations[indexPath.row].value(forKey: "starttimestamp") as? Date
        {
            cell.lblStart.text  = "Start Time : \(starttime)"
        }
        else
        {
            cell.lblStart.text  = ""
        }
        if let endtime = locations[indexPath.row].value(forKey: "endtimestamp") as? Date
        {
            cell.lblEnd.text  = "End Time : \(endtime)"
        }
        else
        {
            cell.lblEnd.text  = ""
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DetailVC") as? DetailVC
        vc?.selectedLocation = locations[indexPath.row]
        self.navigationController?.pushViewController(vc!, animated: true)
        
    }
    
    

}
