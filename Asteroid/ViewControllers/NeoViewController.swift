//
//  ViewController.swift
//  Asteroid
//
//  Created by Sreeni E V on 05/09/22.
//

import UIKit

class NeoViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var titleLabel: UILabel!
    var startDate = String()
    var endDate = String()
    var activityView: UIActivityIndicatorView?
    var neoModel:NeoModel?
    
    let dateFormatter = DateFormatter()
    
    var maxVelocityArray:[Double] = []
    var minDistanceArray:[Double] = []
    var datesArray = [String]()
    
    var graph_XValus = [String]()
    var graph_YValus = [CGFloat]()
    
    var fastesAsteroid: FastestAsteroid?
    var closestAsteroid: ClosestAsteroid?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showActivityIndicator()
        registerCustomCells()

        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date_startDate = dateFormatter.date(from: startDate)
        let date_endDate = dateFormatter.date(from: endDate)
        
        
        let datesBetweenArray = Date.dates(from: date_startDate!, to: date_endDate!)
        
        datesArray = datesBetweenArray.map{ dateFormatter.string(from: $0) }
        print(datesArray)
        
        getGraphXValues()
        
        getData()
        tableView.backgroundColor = .clear
        view.backgroundColor = UIColor(patternImage: UIImage(named: "space.png")!)
        titleLabel.text = "Asteroids between \(startDate) & \(endDate)"
    }

    func getGraphXValues(){
        
        
      graph_XValus = datesArray.map { String($0.suffix(2)) }
        
        print("graph_XValus",graph_XValus)
         
    }
    
    func reloadUI(){
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.hideActivityIndicator()
        }
    }
    
    func showActivityIndicator() {
        activityView = UIActivityIndicatorView(style: .large)
        activityView?.center = self.view.center
        self.view.addSubview(activityView!)
        activityView?.startAnimating()
    }

    func hideActivityIndicator(){
        if (activityView != nil){
            activityView?.stopAnimating()
        }
    }

    
    func registerCustomCells() {
        
        let nib = UINib(nibName: "AsteroidCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "cell")
        let nib2 = UINib(nibName: "GraphCell", bundle: nil)
        tableView.register(nib2, forCellReuseIdentifier: "graphcell")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destination = segue.destination as! GraphViewController
        destination.dates = graph_XValus
        destination.counts = graph_YValus
    }
    
    func getData() {
        let urlstring = "https://api.nasa.gov/neo/rest/v1/feed?start_date=\(startDate)&end_date=\(endDate)&api_key=DEMO_KEY"
        guard let url = URL(string: urlstring) else {return}
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                error == nil,
                let data = data
            else {
                print(error ?? "Unknown error")
                return
            }
            
            do {
                let neo = try JSONDecoder().decode(NeoModel.self, from: data)
                
                self.neoModel = neo
                self.getFastestAsteroid(neo)
                self.getClosestAsteroid(neo)
                self.reloadUI()
                
            }catch {
                print(error)
            }
        }
        task.resume()
    }
    
    func getFastestAsteroid(_ neo:NeoModel) {
        
        for date in datesArray {
        let asteroidsInADay = neo.nearEarthObjects[date] ?? []
        self.graph_YValus.append(CGFloat(asteroidsInADay.count))
            
        let speed = asteroidsInADay.map{ $0.closeApproachData[0].relativeVelocity.kilometersPerHour }
            
        let fastestInADay = speed.compactMap(Double.init).max() ?? 0
//        print("fastestInADay=",fastestInADay)
        self.maxVelocityArray.append(fastestInADay)

        }
        
        print(maxVelocityArray)
        
        let fast = maxVelocityArray.max()
        print("fastest=",fast ?? 0)
        let speed_string = String(fast ?? 0)
        
        for date in datesArray {
        let asteroidsInADay = neo.nearEarthObjects[date] ?? []
            
        let index = asteroidsInADay.firstIndex(where: { $0.closeApproachData[0].relativeVelocity.kilometersPerHour == speed_string })
            
            if let i = index {
                print(i)
                let myid = asteroidsInADay[i].id
                let myname = asteroidsInADay[i].name
                
                let min_dia =  asteroidsInADay[i].estimatedDiameter.kilometers.estimatedDiameterMin
                let max_dia =  asteroidsInADay[i].estimatedDiameter.kilometers.estimatedDiameterMax
                
                self.fastesAsteroid = FastestAsteroid(id: myid, name: myname, speed: speed_string,size: (min_dia+max_dia)/2)
                break
            }
        }

    }
    
    func getClosestAsteroid(_ neo:NeoModel) {

        for date in datesArray {
        let asteroidsInADay = neo.nearEarthObjects[date] ?? []
        
        let distance = asteroidsInADay.map{ $0.closeApproachData[0].missDistance.astronomical }
            
        let closestInADay = distance.compactMap(Double.init).min() ?? 0
        print("closestInADay=",closestInADay)
        self.minDistanceArray.append(closestInADay)

        }
        
        print(minDistanceArray)
        
        let slow = minDistanceArray.min()
        print("slow=",slow ?? 0)
        let distance_string = String(slow ?? 0)
        
        for date in datesArray {
        let asteroidsInADay = neo.nearEarthObjects[date] ?? []
            
        let index = asteroidsInADay.firstIndex(where: { $0.closeApproachData[0].missDistance.astronomical == distance_string })
            
            if let i = index {
                print(i)
                let myid = asteroidsInADay[i].id
                let myname = asteroidsInADay[i].name
                
                let min_dia =  asteroidsInADay[i].estimatedDiameter.kilometers.estimatedDiameterMin
                let max_dia =  asteroidsInADay[i].estimatedDiameter.kilometers.estimatedDiameterMax
                
                self.closestAsteroid = ClosestAsteroid(id: myid, name: myname, distance: distance_string,size: (min_dia+max_dia)/2)
                break
            }
        }
    }

}

//MARK:- UITABLEVIEW DATASOURCE
extension NeoViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
        return 2
        } else if neoModel == nil {
        return 0
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 40
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Fast & Close !!"
        }
        return "Chart"
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
        return 250
        } else {
            return 400
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! AsteroidCell
            
            if indexPath.row == 0 {
                cell.titleLabel.text = "Fastest Asteroid"
                cell.idLabel.text = "ID: "+(fastesAsteroid?.id ?? "")
                cell.nameLAbel.text = "  NAME: "+(fastesAsteroid?.name ?? "")
                cell.speedLabel.text = "SPEED: "+(fastesAsteroid?.speed ?? "")+" Km/h"
                
                if let size = fastesAsteroid?.size {
                    
                    cell.sizeLabel.text = "AVERAGE SIZE: \(size) Km"
                }
                
                
            } else if indexPath.row == 1 {
                
                cell.titleLabel.text = "Closest Asteroid"
                
                cell.idLabel.text = "ID: "+(closestAsteroid?.id ?? "")
                cell.nameLAbel.text = "  NAME: "+(closestAsteroid?.name ?? "")
                cell.speedLabel.text = "DISTANCE: "+(closestAsteroid?.distance ?? "")+" Astronomical"
                if let size = closestAsteroid?.size {
                    
                    cell.sizeLabel.text = "AVERAGE SIZE: \(size) Km"
                }
            }
            cell.selectionStyle = .none
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "graphcell") as! GraphCell
            cell.configureCell(dates: graph_XValus, count: graph_YValus)
            cell.selectionStyle = .none
            return cell
        }
        
    }

}
