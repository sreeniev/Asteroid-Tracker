//
//  GraphViewController.swift
//  Asteroid
//
//  Created by Sreeni E V on 06/09/22.
//

import UIKit
import FLCharts

class GraphViewController: UIViewController {

    var graphdata : [MultiPlotable] = []
    var dates = [String]()
    var counts = [CGFloat]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        for i in 0..<dates.count{
            var s = MultiPlotable(name: "", values: [])
            s.name = dates[i]
            s.values = [counts[i]]
            graphdata.append(s)
        }
        
        let chartData = FLChartData(title: "Asteroids",
                                    data: graphdata,
                                    legendKeys: [
                        Key(key: "F1", color: .Gradient.purpleCyan),
                        Key(key: "F2", color: .green),
                        Key(key: "F3", color: .Gradient.sunset)],
                                     unitOfMeasure: "Count")
        
        let chart = FLChart(data: chartData, type: .bar())
        
        let card = FLCard(chart: chart, style: .rounded)
        card.showAverage = true
        card.showLegend = false
        
        view.addSubview(card)
        card.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
          card.centerYAnchor.constraint(equalTo: view.centerYAnchor),
          card.centerXAnchor.constraint(equalTo: view.centerXAnchor),
          card.heightAnchor.constraint(equalToConstant: 350),
          card.widthAnchor.constraint(equalToConstant: view.frame.width-20)
        ])
    }
    
}
