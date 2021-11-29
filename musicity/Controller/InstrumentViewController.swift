//
//  InstrumentViewController.swift
//  musicity
//
//  Created by Brian Friess on 27/11/2021.
//

import UIKit

class InstrumentViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var row = 0
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return musicInstruments.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InstrumentsCell", for: indexPath)
        cell.textLabel?.text = musicInstruments[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
        UserInfo.shared.addSingleInfo(musicInstruments[indexPath.row], .instrument, String(row))
        print(UserInfo.shared.instrument)
        dismiss(animated: true, completion: nil)
    }
    
}


