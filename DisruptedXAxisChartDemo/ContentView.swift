//
//  ContentView.swift
//  DisruptedXAxisChartDemo
//
//  Created by Michael Rommel on 31.05.22.
//

import SwiftUI
import Charts

struct ContentView: View {

    var body: some View {

        VStack {
            LatencyBarChart(entries: [
                BarChartDataEntry(x: 1, y: 0),
                BarChartDataEntry(x: 2, y: 2),
                BarChartDataEntry(x: 3, y: 7),
                BarChartDataEntry(x: 4, y: 24),
                BarChartDataEntry(x: 5, y: 52),
                BarChartDataEntry(x: 6, y: 13),
                BarChartDataEntry(x: 7, y: 2),
                BarChartDataEntry(x: 8, y: 7),
                BarChartDataEntry(x: 9, y: 12),
                BarChartDataEntry(x: 10, y: 27),
                BarChartDataEntry(x: 11, y: 3),
                BarChartDataEntry(x: 12, y: 15),
                BarChartDataEntry(x: 13, y: 2),
                BarChartDataEntry(x: 23, y: 2),
                BarChartDataEntry(x: 52, y: 2),
                BarChartDataEntry(x: 150, y: 17)
            ])
            .frame(height: 200)

            Spacer()
        }
    }
}

struct ContentView_Previews: PreviewProvider {

    static var previews: some View {
        ContentView()
    }
}
