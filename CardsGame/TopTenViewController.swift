//
//  TopTenViewController.swift
//  CardsGame
//
//  Created by Amit Kremer  on 21/05/2021.
//

import UIKit
import MapKit

class TopTenViewController: UIViewController {
    
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var recordList: UITableView!
    var records : [Record]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        records = ScoresManager.instance.highScores!
        records?.reverse()
        if((records?.count ?? -1 ) > 0){
            let initialLocation = CLLocation(latitude: records![0].Location!.lat, longitude: records![0].Location!.lng)
            map.centerToLocation(initialLocation)
            
        }
        
        recordList.dataSource = self
        recordList.delegate = self
        
    }
    
    @IBAction func backClicked(_ sender: UIButton) {
        dismiss(animated: true, completion: nil);
        
    }
    
}


extension TopTenViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var c = 0
        if(records != nil){
            c = records!.count < 10 ? records!.count : 10
        }
        
        return c
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recordCell", for: indexPath) as! RecordCell
        cell.playerLBL.text = "Player Name: \(records?[indexPath.item].Name ?? "empty")"
        cell.locationLBL.text = "Game Location: \(records?[indexPath.item].Location?.toString ?? "empty")"
        cell.placeLBL.text = "~~ #\(indexPath.item + 1) ~~"
        cell.scoreLBL.text = "Score: \(records?[indexPath.item].gameDuration ?? 0)"
        if(records?[indexPath.item].Location != nil){
            cell.loc = CLLocation(latitude: records![indexPath.item].Location!.lat, longitude: records![indexPath.item].Location!.lng)
        }
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: records![indexPath.item].Location?.lat ?? 0, longitude: records![indexPath.item].Location?.lng ?? 0)
        map.addAnnotation(annotation)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell =  tableView.cellForRow(at: indexPath) as! RecordCell
        if (cell.loc != nil){
            self.map.centerToLocation(cell.loc!)
        }
        
    }
    
}

private extension MKMapView {
    func centerToLocation(
        _ location: CLLocation,
        regionRadius: CLLocationDistance = 1000
    ) {
        let coordinateRegion = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: regionRadius,
            longitudinalMeters: regionRadius)
        setRegion(coordinateRegion, animated: true)
    }
    
}

