//
//  FilterViewController.swift
//  musicity
//
//  Created by Brian Friess on 28/12/2021.
//

import UIKit

class FilterViewController: UIViewController {

    @IBOutlet weak var sliderKm: UISlider!
    @IBOutlet weak var labelKm: UILabel!
    @IBOutlet weak var segmentedFilter: UISegmentedControl!

    
    override func viewDidLoad() {
        //we check if our segue have already a distance value for display at the start
        if UserInfo.shared.filter["Distance"] != nil{
            sliderKm.value = Float(UserInfo.shared.filter["Distance"] as! Double / 100)
        }
        labelKm.text = "\(Int(sliderKm.value * 100)) Km"
        displaySegmentedAtStart()
        chooseSegmentedFilter()
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


    
    

