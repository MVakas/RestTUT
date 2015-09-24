//
//  MasterViewController.swift
//  RestingEasy
//
//  Created by Vakas Zia on 26/08/2015.
//  Copyright (c) 2015 VeeSoft. All rights reserved.
//

import UIKit


let kCLIENTID = "XSKG5GZAZH5FRFDMKCPNSJTM1DRZDOBSCCYU1HSQJLPHWOUK"
let kCLIENTSECRET = "4W1KW2YJ0UD5D4QCP4JD1FOGYZB12FU05BHSNB23LIO4XEZP"

class MasterViewController: UITableViewController {

    var venues = []
    //var objects = [AnyObject]()


    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureRestKit()
        
        self.loadVenues()
        // Do any additional setup after loading the view, typically from a nib.
//        self.navigationItem.leftBarButtonItem = self.editButtonItem()
//
//        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "insertNewObject:")
//        self.navigationItem.rightBarButtonItem = addButton
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

//    func insertNewObject(sender: AnyObject) {
//        objects.insert(NSDate(), atIndex: 0)
//        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
//        self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Left )
//    }

    // MARK: - Segues

//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if segue.identifier == "showDetail" {
//            if let indexPath = self.tableView.indexPathForSelectedRow() {
//                let object = objects[indexPath.row] as! NSDate
//            (segue.destinationViewController as! DetailViewController).detailItem = object
//            }
//        }
//    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.venues.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) 

        //let object = objects[indexPath.row] as! NSDate
        //cell.textLabel!.text = object.description
        
        
        let venue: Venue = self.venues[indexPath.row] as! Venue
        cell.textLabel?.text = venue.name
        cell.detailTextLabel?.text = String(stringInterpolationSegment: venue.location!.distance)
        
        //cell.detailTextLabel?.text = venue.location?.distance?.description
        
        return cell
    }

//    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
//        // Return false if you do not want the specified item to be editable.
//        return true
//    }
//
//    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
//        if editingStyle == .Delete {
//            objects.removeAtIndex(indexPath.row)
//            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
//        } else if editingStyle == .Insert {
//            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
//        }
//    }
    
    
    func configureRestKit() {
        
        let baseURL = NSURL(string: "https://api.foursquare.com")
        
        //let baseURL = NSURL(string: "http://192.168.1.205/FacultyWebAPI/api/Teacher/GetCourses/c1eecf86-902d-457b-ad4d-f290a496fb83")
        let client = AFHTTPClient(baseURL: baseURL)
        let objectManager = RKObjectManager(HTTPClient: client)
        
        let venueMapping = RKObjectMapping(forClass: Venue.self)
        let locationMapping = RKObjectMapping(forClass: Location.self)
        
        //let classMapping = RKObjectMapping(forClass: Course.self)
        
        
        venueMapping.addAttributeMappingsFromArray(["name"])
        
        locationMapping.addAttributeMappingsFromArray(["address", "city", "country", "crossStreet", "postalCode", "state", "distance", "lat", "lng"])
        
        venueMapping.addPropertyMapping(RKRelationshipMapping(fromKeyPath: "location", toKeyPath: "location", withMapping: locationMapping))
        
        let responseDescriptor = RKResponseDescriptor(mapping: venueMapping, method: RKRequestMethod.GET, pathPattern: "/v2/venues/search", keyPath: "response.venues", statusCodes: NSIndexSet(index: 200))
        
        //let responseDescriptor = RKResponseDescriptor(mapping: classMapping, method: RKRequestMethod.GET, pathPattern: nil, keyPath: nil, statusCodes: NSIndexSet(index: 200))
        
        
        objectManager.addResponseDescriptor(responseDescriptor)
        
    }
    
    func loadVenues() {
        
        let lat_long = "37.33,-122.03"
        let clientID = kCLIENTID
        let clientSecret = kCLIENTSECRET
        
        let queryParams = ["ll" : lat_long,
            "client_id" : clientID,
            "client_secret" : clientSecret,
            "categoryId" : "4bf58dd8d48988d1e0931735",
            "v" : "20140118"]
        
        RKObjectManager.sharedManager().getObjectsAtPath("/v2/venues/search", parameters: queryParams,
            
            success: { operation, mappingResult in
            
                self.venues = mappingResult.array()
                self.tableView.reloadData()
                
            },
            failure: { operation, error in
        
                print(error.localizedDescription)
        
            }
        )
        
    }


}

