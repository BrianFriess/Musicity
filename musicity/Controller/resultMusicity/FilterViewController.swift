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
        if UserInfo.shared.filter["Distance"] != nil{
            sliderKm.value = Float(UserInfo.shared.filter["Distance"] as! Double / 100)
        }
        labelKm.text = "\(Int(sliderKm.value * 100)) Km"
    }
    
    var infoUseInPickerView = [String]()
    
    
    //we set and display the value of the slider
    @IBAction func sliderValueChanged(_ sender: Any) {
        labelKm.text = "\(Int(sliderKm.value * 100)) Km"
    }
    
    
    @IBAction func changeSegmentedFilter(_ sender: Any) {
        chooseSegmentedFilter()
    }
    
    func chooseSegmentedFilter(){
        switch segmentedFilter.selectedSegmentIndex{
        case 0:
            UserInfo.shared.filter["Search"] = "Band"
        case 1:
            UserInfo.shared.filter["search"] = "Musician"
        case 2:
            UserInfo.shared.filter["search"] = "All"
        default:
            break
        }
    }
    
    
    @IBAction func filterButton(_ sender: Any) {
        UserInfo.shared.filter["Distance"] = Double(sliderKm.value * 100)
            dismiss(animated: true, completion: nil)
        
    }
    
}


    
    

