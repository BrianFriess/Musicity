//
//  FilterViewController.swift
//  musicity
//
//  Created by Brian Friess on 28/12/2021.
//

import UIKit
import MapKit

final class FilterViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var sliderKm: UISlider!
    @IBOutlet weak var labelKm: UILabel!
    @IBOutlet weak var segmentedFilter: UISegmentedControl!
    @IBOutlet weak var mapKit: MKMapView!
    
    var latitude = 0.0
    var longitude = 0.0
    
    private var circle = MKCircle()

    override func viewDidLoad() {
        //we check if our segue have already a distance value for display at the start
        if UserInfo.shared.filter[DataBaseAccessPath.distance.returnAccessPath] != nil {
            sliderKm.value = Float(UserInfo.shared.filter[DataBaseAccessPath.distance.returnAccessPath] as! Double / 100)
        }
        labelKm.text = "\(Int(sliderKm.value * 100)) Km"
        displaySegmentedAtStart()
        chooseSegmentedFilter()
        mapKit.delegate = self
        displayLocation()
    }
    
    //set our position in  a CLLocation and display out position on a map
    private func displayLocation() {
        mapKit.showsUserLocation = true
        let location = CLLocation(latitude: latitude, longitude: longitude)
        print(Double(sliderKm.value) * 100)
        let regionLatitudeMeters : CLLocationDistance = Double(sliderKm.value + 0.01) * 100000
        let regionLongitudeMeters : CLLocationDistance = Double(sliderKm.value + 0.01) * 100000
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionLatitudeMeters, longitudinalMeters: regionLongitudeMeters)
        mapKit.setRegion(coordinateRegion, animated: true)
        addCircle()
    }
    
    //add a cicle around our position
    private func addCircle() {
        mapKit.removeOverlay(circle)
        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        circle = MKCircle(center: location, radius: Double(sliderKm.value) * 100000 / 2)
        mapKit.addOverlay(circle)
    }
    
    //create the circle
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
    private func displaySegmentedAtStart() {
        if let bandOrMusician = UserInfo.shared.filter[DataBaseAccessPath.search.returnAccessPath] {
            if bandOrMusician as! String == DataBaseAccessPath.band.returnAccessPath {
                segmentedFilter.selectedSegmentIndex = 0
            } else if bandOrMusician as! String == DataBaseAccessPath.musician.returnAccessPath {
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
        //if we move the slider, we reload our new position in the map 
        displayLocation()
    }
    
    //when we choose a new segment, we call the function chooseSegmentedFilter
    @IBAction func changeSegmentedFilter(_ sender: Any) {
        chooseSegmentedFilter()
    }
    
    //when we choose a new segment, we get the value at our segue
    private func chooseSegmentedFilter() {
        switch segmentedFilter.selectedSegmentIndex {
        case 0:
            UserInfo.shared.filter[DataBaseAccessPath.search.returnAccessPath] = DataBaseAccessPath.band.returnAccessPath
         //   defaults.set("Band", forKey: "Search")
        case 1:
            UserInfo.shared.filter[DataBaseAccessPath.search.returnAccessPath] = DataBaseAccessPath.musician.returnAccessPath
       //     defaults.set("Musician", forKey: "Distance")
        case 2:
            UserInfo.shared.filter[DataBaseAccessPath.search.returnAccessPath] = DataBaseAccessPath.all.returnAccessPath
          //  defaults.set("All", forKey: "Distance")
        default:
            break
        }
    }
    
    //when we push the button filter, we get the value of the slider in our segue
    @IBAction func filterButton(_ sender: Any) {
        UserInfo.shared.filter[DataBaseAccessPath.distance.returnAccessPath] = Double(sliderKm.value * 100)
        //defaults.set(Double(sliderKm.value * 100), forKey: "Distance")
        dismiss(animated: true, completion: nil)
    }
    
}


    
    

