//
//  ViewController.swift
//  checkIn
//
//  Created by Nareg Khoshafian on 1/4/16.
//  Copyright © 2016 Intrepid. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Alamofire


class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate
    // I am abiding by these protocols
{

    @IBOutlet weak var mapView: MKMapView!
    // I control dragged the map in the view here and assigned it the name "mapView"
    
    let locationManager = CLLocationManager()
    // Step 2 of "Configure and use a CLLocationManager object to delever events"
    
    
    var inRegion = false
    // Tells us if the user is near Intrepid
    
    override func viewDidLoad()
    //This is just saying once the view loads do this. Method UIViewController
    {
        super.viewDidLoad()
        
        self.locationManager.delegate = self
        // This conforms it to the delegate method
        // Step 3 of "Configure and use a CLLocationManager object to delever events"
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        //setting desiredAccuracy set to AccuracyBest because we want exact location.
        
        self.locationManager.requestWhenInUseAuthorization()
        //We want the request to be authorized only when we are using the app. Not when it's in the background
        // Step 1 of "Configure and use a CLLocationManager object to delever events"
        
        self.locationManager.startUpdatingLocation()
        //This actually turns on the locationManager to go look for a location.
        
        self.mapView.showsUserLocation = true
        // This is the blue dot of where you are located
        
        let requestTypes = UIUserNotificationType.Alert
        let settingsRequest = UIUserNotificationSettings(forTypes: requestTypes, categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(settingsRequest)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Mark: - location Delegate Methods
    
    var centerMe: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 42.367010, longitude: -71.080210)
    
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last
        //didUpdateLocations will keep runnng over and over so we want the most current location and thats why we use .last
        print(location)
        centerMe = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        // Here we are getting the center of the "location" last above. Which is the lat and long from location variable
        // This is the users current location.
        let region = MKCoordinateRegion(center: centerMe, span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
        // The region is basically a circle that we want the map to zoom to. Which is what the MKCoordinateSapn is...1 is normal zoom 5 is zoomed out.
        self.mapView.setRegion(region, animated: true)
        //We set the mapView to the region above.
        // animated is true which result in the map zooming animation.
        self.locationManager.stopUpdatingLocation()
        //Since we have the users location and the map zoomed in onto it we can stop updatingLocation.
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError)
    {
        print("Errors: " + error.localizedDescription)
    }
    

    


    
    @IBAction func startMonitoring(sender: AnyObject)
    {
        // 42.367010 -71.080210 Intrepid Pursuits: 222 Third St #4000, Cambridge, MA 02141
        // 37.785863 -122.406541 Apple Store in SF: 1 Stockton St, San Francisco, CA
        let latitude: CLLocationDegrees = 37.785863
        let longitude: CLLocationDegrees = -122.406541
        let center: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        let radius: CLLocationDistance = CLLocationDistance(50.0)
        let identifier: String = "intrepid"
        let intrepidGeoLocation = CLCircularRegion(center:center, radius:radius, identifier:identifier)
        // intrepidGeoLocation is the region in which we want to check if the user is in.
        print(intrepidGeoLocation)
        
        print(intrepidGeoLocation.containsCoordinate(centerMe))
        // This lets us know if the user is in the area of Intrepid (intrepidGeoLocation) and returns true if he is and false if he isn't.
        inRegion = intrepidGeoLocation.containsCoordinate(centerMe)
        //This allows us to use notifications
        
        if inRegion{
            let notification = UILocalNotification()
//            let slackSlideAction = UIMutableUserNotificationAction()
//            slackSlideAction.identifier = slackSlideAction
            notification.fireDate = NSDate(timeIntervalSinceNow: 5)
            notification.alertBody = "Near Intrepid"
            notification.alertAction = "Check In"
            notification.soundName = UILocalNotificationDefaultSoundName
            notification.userInfo = ["customField1": "someValue"]
            
            UIApplication.sharedApplication().scheduleLocalNotification(notification)
            print("Notification works")
            
            //new code
            
            let parameters = [
                "foo": "bar",
                "baz": ["a", 1],
                "qux": [
                    "x": 1,
                    "y": 2,
                    "z": 3
                ]
            ]
            
            Alamofire.request(.POST, "https://httpbin.org/post", parameters: parameters)
            
            
        }
        
    }
    // Create a notifcation that has 2 buttons that say cancel or checkin
    // Download Cocoapods
    // Use alamofire to post on the slack api webook channel called #whose-there
    
    

}

