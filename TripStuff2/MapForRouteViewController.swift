//
//  MapForRouteViewController.swift
//  TripStuff2
//
//  Created by SHAWN on 9/18/15.
//  Copyright © 2015 SHAWN. All rights reserved.
//

import UIKit
import MapKit


class MapForRouteViewController: UIViewController, MKMapViewDelegate, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource, UISearchBarDelegate, UITextFieldDelegate {
    
    struct Constant {
        static let Transportations = ["Walk","Bus","Taxi","Train","Subway"]
        static let IDcell = "searchResults"
        static let AnnotationReuseID = "waypoint"
        static let rowHeightForPickerView: CGFloat = 20

    }
    var waypoints = [EditableWaypoint]()
    var searchData = [EditableWaypoint]()

    var routeOverlay: MKOverlay?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchResultTable.hidden = true
    }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        let overlay = MKPolylineRenderer(overlay: overlay)
        overlay.strokeColor = UIColor.blueColor()
        overlay.lineWidth = 4
        return overlay
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var dateFrom: UIDatePicker!{
        didSet{
            dateFrom.datePickerMode = UIDatePickerMode.Time
            dateFrom.minuteInterval = 30
        }
    }

    
    @IBOutlet weak var dateTo: UIDatePicker!{
        didSet{
            dateTo.datePickerMode = UIDatePickerMode.Time
            dateTo.minuteInterval = 30
        }
    }

    
    
    @IBOutlet weak var price: UITextField!
    
    @IBOutlet weak var searchResultTable: UITableView!

    @IBOutlet weak var searchFrom: UISearchBar!{
        didSet{
            searchFrom.delegate = self
        }
    }
    
    @IBOutlet weak var placeFrom: UITextField!{
        didSet{
            placeFrom.delegate = self
        }
    }
    
    @IBOutlet weak var placeTo: UITextField!{
        didSet{
            placeTo.delegate = self
        }
    }
        
    @IBOutlet weak var mapView: MKMapView!{
        didSet{
            if #available(iOS 9.0, *) {
                mapView.showsCompass = true
                mapView.showsScale = true
            } else {
                // Fallback on earlier versions
            }
            mapView.mapType = .Standard
            mapView.delegate = self 
        }
    }
    
    @IBOutlet weak var chooseTransportation: UIPickerView!{
        didSet{
            chooseTransportation.delegate = self
            chooseTransportation.dataSource = self
            chooseTransportation.selectRow(2, inComponent: 0, animated: true)
        }
    }
    
    
    @IBAction func changeFromAndTo(sender: UIButton) {
    }
    
    @IBAction func done(sender: UIBarButtonItem) {
    }
    
    
    @IBAction func addAnnotationLongPress(sender: UILongPressGestureRecognizer) {
        if searchResultTable.hidden == true{
            if sender.state == UIGestureRecognizerState.Began{
                let location = sender.locationInView(mapView)
                let locationInMap = mapView.convertPoint(location, toCoordinateFromView: mapView)
                addAnnotation(locationInMap, title:"new")
            }
        }
    }
    
//MARK: set mapview
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        var view = mapView.dequeueReusableAnnotationViewWithIdentifier(Constant.AnnotationReuseID)
        if view == nil{
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: Constant.AnnotationReuseID)
        }else{
            view?.annotation = annotation
        }
        view!.canShowCallout = true
        let leftButton = UIButton(type: UIButtonType.RoundedRect)
        leftButton.setTitle("Delete", forState: UIControlState.Normal)
        leftButton.frame = CGRectMake(0, 0, 60, 40)
        view?.leftCalloutAccessoryView = leftButton
        view?.draggable = annotation is EditableWaypoint
        return view
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, didChangeDragState newState: MKAnnotationViewDragState, fromOldState oldState: MKAnnotationViewDragState) {
        if view.dragState == MKAnnotationViewDragState.Ending{
            if waypoints.count == 2{
                showRoute(waypoints[0], annotationDestination: waypoints[1])
            }
        }
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if view.leftCalloutAccessoryView != nil{
            for wp in waypoints{
                if wp.latitude == view.annotation?.coordinate.latitude && wp.longitude == view.annotation?.coordinate.longitude{
                    let indexInWaypoint = waypoints.indexOf(wp)
                    waypoints.removeAtIndex(indexInWaypoint!)
                    if placeFrom.text == wp.title{
                        placeFrom.text = ""
                    }else{
                        placeTo.text = ""
                    }
                }
            }
            mapView.removeAnnotation(view.annotation!)
            if (routeOverlay != nil){
                mapView.removeOverlay(routeOverlay!)
            }
        }
    }
    

//MARK: set textField
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        placeTo.resignFirstResponder()
        placeFrom.resignFirstResponder()
        dateFrom.resignFirstResponder()
        dateTo.resignFirstResponder()
        return true
    }
    
//MARK: set searchBar
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        searchData.removeAll()
        let request = MKLocalSearchRequest()
            if searchFrom.text != ""{
                    request.naturalLanguageQuery = ""
                    request.naturalLanguageQuery = searchFrom.text
            }else{
                request.naturalLanguageQuery = "place"
            }
            
            let span = MKCoordinateSpan(latitudeDelta: 90, longitudeDelta: 180)
            
            request.region = MKCoordinateRegion(center:CLLocationCoordinate2D(latitude: 0, longitude: 0), span: span)
            
            //启动搜索,并且把返回结果保存在数组中
            let search = MKLocalSearch(request: request)
            search.startWithCompletionHandler { (response:MKLocalSearchResponse?, error:NSError?) -> Void in
                if response != nil {
                    for item in response!.mapItems{
                        let newAnnotation = EditableWaypoint(title: item.name!, latitude: (item.placemark.location?.coordinate.latitude)!, longitude: (item.placemark.location?.coordinate.longitude)!)
                        newAnnotation.title       = item.name!
                        newAnnotation.nation      = item.placemark.ISOcountryCode
                        newAnnotation.city        = item.placemark.locality
                        newAnnotation.info        = "new"
                        newAnnotation.dateAndTime = NSDate()
                        self.searchData.append(newAnnotation)
                    }
                    self.searchResultTable.reloadData()
                }else{
                    self.searchData.removeAll()
                    self.searchResultTable.reloadData()
                }
            
        }
    }
    
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        searchData.removeAll()
        searchResultTable.hidden = false
        searchResultTable.reloadData()
        return true
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchResultTable.hidden = true
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchFrom.resignFirstResponder()
        searchResultTable.hidden = true

    }
    
    
    
    
    
    
//MARK: set pickerview
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int{
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return Constant.Transportations.count
    }

    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Constant.Transportations[row]
    }
    
    func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return Constant.rowHeightForPickerView
    }

    
//MARK: set tableview
   
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return searchData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier(Constant.IDcell, forIndexPath: indexPath) as! SearchResultsTableViewCell
        if searchData[indexPath.row].city != nil{
            cell.country.text = searchData[indexPath.row].city
        }
        cell.place.text = searchData[indexPath.row].title
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if waypoints.count < 2{
            let loc = CLLocationCoordinate2D(latitude: searchData[indexPath.row].latitude!, longitude: searchData[indexPath.row].longitude!)
            addAnnotation(loc, title: searchData[indexPath.row].title)
            searchFrom.text = ""
            searchResultTable.hidden = true
        }else{
            print("there only can be 2 annotations in this version")
            searchResultTable.hidden = true
            searchFrom.text = ""
        }
        searchFrom.resignFirstResponder()
    }

    
//MARK: functions
    func addAnnotation(location: CLLocationCoordinate2D, title: String?){
        if waypoints.count < 3{
            let newAnnotation: EditableWaypoint?
                newAnnotation = EditableWaypoint(title: title!, latitude: location.latitude, longitude: location.longitude)
            waypoints.append(newAnnotation!)
            mapView.addAnnotation(newAnnotation!)
            if waypoints.count == 1{
                searchFrom.placeholder = "To"
                placeFrom.text = newAnnotation?.title

            }else{
                searchFrom.placeholder = "From"
                showRoute(mapView.annotations[0], annotationDestination: mapView.annotations[1])
                placeTo.text = newAnnotation?.title
            }
            mapView.showAnnotations(mapView.annotations, animated: true)
        }else{
            print("can not be more than 2 annotations")
        }
    }


    func showRoute(annotationSourse: MKAnnotation, annotationDestination: MKAnnotation){
        mapView.removeOverlays(mapView.overlays)
        
        let destinationPlaceMark = MKPlacemark(coordinate: annotationDestination.coordinate, addressDictionary: nil)
        let destination = MKMapItem(placemark: destinationPlaceMark)
        let destinationPlaceMark1 = MKPlacemark(coordinate: annotationSourse.coordinate, addressDictionary: nil)
        let source = MKMapItem(placemark: destinationPlaceMark1)
        let mapRequest = MKDirectionsRequest()
        
        let transportType = Constant.Transportations[chooseTransportation.selectedRowInComponent(0)]
        if transportType == "Walk"{
            mapRequest.transportType = MKDirectionsTransportType.Walking
        }else {
            mapRequest.transportType = MKDirectionsTransportType.Automobile
        }
        mapRequest.transportType = MKDirectionsTransportType.Automobile
        mapRequest.destination = destination
        mapRequest.source = source
        mapRequest.requestsAlternateRoutes = false
        let directions = MKDirections(request: mapRequest)
        
        directions.calculateDirectionsWithCompletionHandler { (response: MKDirectionsResponse?, error: NSError?) -> Void in
            if let res = response{
                for route in res.routes {
                    self.routeOverlay = route.polyline
                    self.mapView.addOverlay(route.polyline,
                        level: MKOverlayLevel.AboveRoads)
                }
            }else{
                print("there is no route between two annotations")
            }
        }
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
