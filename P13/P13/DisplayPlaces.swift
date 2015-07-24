//
//  DisplayPlaces.swift
//  P13
//
//  Created by Team June on 7/18/15.
//  Copyright © 2015 Team June. All rights reserved.
//

import UIKit
import CoreLocation

class DisplayPlaces: UITableViewController, CLLocationManagerDelegate {
    
    var latestLocation = CLLocation()
    let locationManager  = CLLocationManager()
    var places = [PlaceModel]()
    var services = [ServiceModel]()
    var placeservices = Dictionary<Int, Any>()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    @IBAction func getPlaces(sender: AnyObject) {
        
        places = []
        services = []
        
        var searchPlaces = "http://45.55.94.99:8080"
        searchPlaces = searchPlaces + "/places/search/?ll=" + String(format: "%.4f", latestLocation.coordinate.latitude) + "," + String(format: "%.4f", latestLocation.coordinate.longitude)

        let request = NSURLRequest(URL: NSURL(string: searchPlaces)!)
        let urlSession = NSURLSession.sharedSession()
        
        let task = urlSession.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            if error != nil { print(error!.localizedDescription, appendNewline: false)
            }
            // Parse JSON data
            let output =  JSON(data: data!)

            if let placeArray = output["places"].array {
                
                for placeDict in placeArray {
                    
                    let place = PlaceModel()
                    
                    place.id = placeDict["id"].int!
                    place.name = placeDict["name"].string!
                    
                    if let serviceArray = placeDict["services"].array {
                        
                        for serviceDict in serviceArray {
                            //print(serviceDict)

                            let service = ServiceModel()
                            
                            service.name = serviceDict["name"].string!
                            service.identifier = serviceDict["identifier"].string!
                            service.service_id = serviceDict["service_id"].int!
                            self.services.append(service)
                            
                        }
                        
                        

                    }
                
                    self.places.append(place)

                    // TODO: Should add to PlaceServices only if there are available services for the Place
                    self.placeservices[place.id] = self.services
                    self.services = []
                }
            }
            
            //print(self.placeservices)
        
            // Reload table view
            dispatch_async(dispatch_get_main_queue(), {
                self.tableView.reloadData()
            })
        })
        task!.resume()

    
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //locationManager.stopUpdatingLocation()
        latestLocation = locations.last!
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return places.count
        
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)
        
        cell.textLabel?.text = places[indexPath.row].name
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //print("selected")
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        if segue.identifier == "getPlaceServices" {
            
            if let indexPath = self.tableView.indexPathForSelectedRow {
                
                let place_id = places[indexPath.row].id
                
                
                //print(places[indexPath.row].id)
                let destinationController = segue.destinationViewController as! DisplayPlaceServices
                destinationController.availableServices = placeservices[place_id] as! [ServiceModel]
                destinationController.place_id = place_id
            }
        }
        
    }



    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the specified item to be editable.
    return true
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
