//
//  BarChart.swift
//  DisruptedXAxisChartDemo
//
//  Created by Michael Rommel on 31.05.22.
//

import SwiftUI
import Charts

struct BarChart: UIViewRepresentable {

    typealias UIViewType = BarChartView

    var entries: [BarChartDataEntry]

    func makeUIView(context: Context) -> BarChartView {

        let chartView = BarChartView()

        chartView.data = addData()

        chartView.drawValueAboveBarEnabled = false
        chartView.drawBarShadowEnabled = false
        chartView.xAxisRenderer = LatencyXAxisRenderer(
            viewPortHandler: chartView.viewPortHandler,
            axis: chartView.xAxis,
            transformer: chartView.getTransformer(forAxis: .left)
        )

        // xAxis
        let xAxis = chartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.drawGridLinesEnabled = false
        xAxis.valueFormatter = LatencyAxisValueFormatter()
        // xAxis.render

        // rightAxis
        let rightAxis = chartView.rightAxis
        rightAxis.enabled = false

        // leftAxis
        let leftAxis = chartView.leftAxis
        leftAxis.enabled = false

        // legend
        let legend = chartView.legend
        legend.enabled = false

        return chartView
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {

    }

    func addData() -> BarChartData {

        let data = BarChartData()

        let dataSet = BarChartDataSet(entries: entries)
        dataSet.label = "Latency"

        var colors: [NSUIColor] = []

        // color based on latency value
        for entry in entries {
            if entry.x < 10 {
                colors.append(NSUIColor(red: 69.3 / 255.0, green: 147.3 / 255.0, blue: 0.0, alpha: 1.0))
            } else if entry.x < 150 {
                colors.append(NSUIColor(red: 114.0 / 255.0, green: 200.1 / 255.0, blue: 15.8 / 255.0, alpha: 1.0))
            } else {
                colors.append(NSUIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0))
            }
        }

        dataSet.colors = colors
        dataSet.drawValuesEnabled = false
        data.append(dataSet)

        return data
    }
}

class LatencyAxisValueFormatter: AxisValueFormatter {

    func stringForValue(_ value: Double, axis: AxisBase?) -> String {

        let intValue = Int(value)
        return "\(intValue)"
    }
}

class LatencyXAxisRenderer: XAxisRenderer {

    private var axisLineSegmentsBuffer = [CGPoint](repeating: .zero, count: 2)

    override func renderAxisLine(context: CGContext) {

        super.renderAxisLine(context: context)

        context.saveGState()
        defer { context.restoreGState() }

        context.setStrokeColor(axis.axisLineColor.cgColor)
        context.setLineWidth(axis.axisLineWidth)
        if axis.axisLineDashLengths != nil {
            context.setLineDash(phase: axis.axisLineDashPhase, lengths: axis.axisLineDashLengths)
        } else {
            context.setLineDash(phase: 0.0, lengths: [])
        }

        if axis.labelPosition == .bottom
            || axis.labelPosition == .bottomInside
            || axis.labelPosition == .bothSided {
            axisLineSegmentsBuffer[0].x = viewPortHandler.contentRight - 20
            axisLineSegmentsBuffer[0].y = viewPortHandler.contentBottom + 4
            axisLineSegmentsBuffer[1].x = viewPortHandler.contentRight - 12
            axisLineSegmentsBuffer[1].y = viewPortHandler.contentBottom - 4
            context.strokeLineSegments(between: axisLineSegmentsBuffer)

            axisLineSegmentsBuffer[0].x = viewPortHandler.contentRight - 16
            axisLineSegmentsBuffer[0].y = viewPortHandler.contentBottom + 4
            axisLineSegmentsBuffer[1].x = viewPortHandler.contentRight - 8
            axisLineSegmentsBuffer[1].y = viewPortHandler.contentBottom - 4
            context.strokeLineSegments(between: axisLineSegmentsBuffer)
        }
    }
}

struct BarChart_Previews: PreviewProvider {

    static var previews: some View {

        VStack {
            BarChart(entries: [
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
