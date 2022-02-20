//
//  FilterViewController.swift
//  musicity
//
//  Created by Brian Friess on 28/12/2021.
//

import UIKit
import MapKit

class FilterViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var sliderKm: UISlider!
    @IBOutlet weak var labelKm: UILabel!
    @IBOutlet weak var segmentedFilter: UISegmentedControl!
    @IBOutlet weak var mapKit: MKMapView!
    
    
    var latitude = 0.0
    var longitude = 0.0
    var circle = MKCircle()

    
    override func viewDidLoad() {
        //we check if our segue have already a distance value for display at the start
        if UserInfo.shared.filter["Distance"] != nil{
            sliderKm.value = Float(UserInfo.shared.filter["Distance"] as! Double / 100)
        }
        labelKm.text = "\(Int(sliderKm.value * 100)) Km"
        displaySegmentedAtStart()
        chooseSegmentedFilter()

        mapKit.delegate = self
        displayLocation()
    }
    
    
    func displayLocation() {
        mapKit.showsUserLocation = true
        let location = CLLocation(latitude: latitude, longitude: longitude)
        print(Double(sliderKm.value) * 100)
        let regionLatitudeMeters : CLLocationDistance = Double(sliderKm.value + 0.01) * 100000
        let regionLongitudeMeters : CLLocationDistance = Double(sliderKm.value + 0.01) * 100000
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionLatitudeMeters, longitudinalMeters: regionLongitudeMeters)
        mapKit.setRegion(coordinateRegion, animated: true)
        addCircle()
    }
    

    
    func addCircle(){
        mapKit.removeOverlay(circle)
        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        circle = MKCircle(center: location, radius: Double(sliderKm.value) * 100000 / 2)
        mapKit.addOverlay(circle)
    }
    
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        var circleRenderer = MKCircleRenderer()
        if let overlay = overlay as? MKCircle {
            circleRenderer = MKCircleRenderer(circle: overlay)
            circleRenderer.fillColor = UIColor.blue
            circleRenderer.strokeColor = .black
            circleRenderer.alpha = 0.2
        }
        return circleRenderer
    }
    
    
    // we check in our segue if we have already a value for our filter for display in our segment
    func displaySegmentedAtStart(){
        if let bandOrMusician = UserInfo.shared.filter["Search"]{
            if bandOrMusician as! String == "Band"{
                segmentedFilter.selectedSegmentIndex = 0
            } else if bandOrMusician as! String == "Musician"{
                segmentedFilter.selectedSegmentIndex = 1
            } else {
                segmentedFilter.selectedSegmentIndex = 2
            }
        } else {
            segmentedFilter.selectedSegmentIndex = 2
        }
    }
    
    
    //we set and display the value of the slider
    @IBAction func sliderValueChanged(_ sender: Any) {
        labelKm.text = "\(Int(sliderKm.value * 100)) Km"
        displayLocation()
    }
    
    
    //when we choose a new segment, we call the function chooseSegmentedFilter
    @IBAction func changeSegmentedFilter(_ sender: Any) {
        chooseSegmentedFilter()
    }
    
    
    //when we choose a new segment, we get the value at our segue
    func chooseSegmentedFilter(){
        switch segmentedFilter.selectedSegmentIndex{
        case 0:
            UserInfo.shared.filter["Search"] = "Band"
        case 1:
            UserInfo.shared.filter["Search"] = "Musician"
        case 2:
            UserInfo.shared.filter["Search"] = "All"
        default:
            break
        }
    }
    
    
    //when we push the button filter, we get the value of the slider in our segue
    @IBAction func filterButton(_ sender: Any) {
        UserInfo.shared.filter["Distance"] = Double(sliderKm.value * 100)
            dismiss(animated: true, completion: nil)
    }
    
}


    
    

