//
//  BarChart.swift
//  DisruptedXAxisChartDemo
//
//  Created by Michael Rommel on 31.05.22.
//

import SwiftUI
import Charts

struct LatencyBarChart: UIViewRepresentable {

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
        chartView.leftYAxisRenderer = LatencyYAxisRenderer(
            viewPortHandler: chartView.viewPortHandler,
            axis: chartView.leftAxis,
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
        leftAxis.enabled = true
        leftAxis.drawAxisLineEnabled = false
        leftAxis.drawGridLinesEnabled = true
        leftAxis.axisMinimum = 0
        // leftAxis.spaceTop = 0.05
        leftAxis.labelFont = .systemFont(ofSize: 10)
        leftAxis.drawZeroLineEnabled = false

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

        if value >= 150 {
            return "-"
        }

        let intValue = Int(value)
        return "\(intValue)"
    }
}

class LatencyXAxisRenderer: XAxisRenderer {

    private var axisLineSegmentsBuffer = [CGPoint](repeating: .zero, count: 2)

    override func renderAxisLine(context: CGContext) {

        guard
            axis.isEnabled,
            axis.isDrawAxisLineEnabled
        else { return }

        guard axis.labelPosition == .bottom
                || axis.labelPosition == .bottomInside
                || axis.labelPosition == .bothSided
        else { return }

        context.saveGState()
        defer { context.restoreGState() }

        context.setStrokeColor(axis.axisLineColor.cgColor)
        context.setLineWidth(axis.axisLineWidth)
        if axis.axisLineDashLengths != nil {
            context.setLineDash(phase: axis.axisLineDashPhase, lengths: axis.axisLineDashLengths)
        } else {
            context.setLineDash(phase: 0.0, lengths: [])
        }

        let leftSplit = viewPortHandler.contentRight - 15
        let rightSplit = viewPortHandler.contentRight - 12

        axisLineSegmentsBuffer[0].x = viewPortHandler.contentLeft
        axisLineSegmentsBuffer[0].y = viewPortHandler.contentBottom
        axisLineSegmentsBuffer[1].x = leftSplit
        axisLineSegmentsBuffer[1].y = viewPortHandler.contentBottom
        context.strokeLineSegments(between: axisLineSegmentsBuffer)

        axisLineSegmentsBuffer[0].x = rightSplit
        axisLineSegmentsBuffer[0].y = viewPortHandler.contentBottom
        axisLineSegmentsBuffer[1].x = viewPortHandler.contentRight
        axisLineSegmentsBuffer[1].y = viewPortHandler.contentBottom
        context.strokeLineSegments(between: axisLineSegmentsBuffer)

        context.saveGState()
        defer { context.restoreGState() }

        context.setStrokeColor(axis.axisLineColor.cgColor)
        context.setLineWidth(axis.axisLineWidth)
        if axis.axisLineDashLengths != nil {
            context.setLineDash(phase: axis.axisLineDashPhase, lengths: axis.axisLineDashLengths)
        } else {
            context.setLineDash(phase: 0.0, lengths: [])
        }

        axisLineSegmentsBuffer[0].x = leftSplit - 2
        axisLineSegmentsBuffer[0].y = viewPortHandler.contentBottom + 4
        axisLineSegmentsBuffer[1].x = leftSplit + 2
        axisLineSegmentsBuffer[1].y = viewPortHandler.contentBottom - 4
        context.strokeLineSegments(between: axisLineSegmentsBuffer)

        axisLineSegmentsBuffer[0].x = rightSplit - 2
        axisLineSegmentsBuffer[0].y = viewPortHandler.contentBottom + 4
        axisLineSegmentsBuffer[1].x = rightSplit + 2
        axisLineSegmentsBuffer[1].y = viewPortHandler.contentBottom - 4
        context.strokeLineSegments(between: axisLineSegmentsBuffer)
    }

    override func renderGridLines(context: CGContext) {
        guard
            let transformer = self.transformer,
            axis.isEnabled,
            axis.isDrawGridLinesEnabled
            else { return }

        context.saveGState()
        defer { context.restoreGState() }

        context.clip(to: self.gridClippingRect)

        context.setShouldAntialias(axis.gridAntialiasEnabled)
        context.setStrokeColor(axis.gridColor.cgColor)
        context.setLineWidth(axis.gridLineWidth)
        context.setLineCap(axis.gridLineCap)

        if axis.gridLineDashLengths != nil {
            context.setLineDash(phase: axis.gridLineDashPhase, lengths: axis.gridLineDashLengths)
        } else {
            context.setLineDash(phase: 0.0, lengths: [])
        }

        let valueToPixelMatrix = transformer.valueToPixelMatrix

        var position = CGPoint.zero

        let entries = axis.entries

        for entry in entries {

            guard entry != 0.0 else {
                continue
            }

            position.x = CGFloat(entry)
            position.y = CGFloat(entry)
            position = position.applying(valueToPixelMatrix)

            drawGridLine(context: context, x: position.x, y: position.y)
        }
    }
}

class LatencyYAxisRenderer: YAxisRenderer {

    override func renderGridLines(context: CGContext) {

        guard axis.isEnabled else { return }

        if axis.drawGridLinesEnabled {
            let positions = transformedPositions()

            context.saveGState()
            defer { context.restoreGState() }
            context.clip(to: self.gridClippingRect)

            context.setShouldAntialias(axis.gridAntialiasEnabled)
            context.setStrokeColor(axis.gridColor.cgColor)
            context.setLineWidth(axis.gridLineWidth)
            context.setLineCap(axis.gridLineCap)

            if axis.gridLineDashLengths != nil {
                context.setLineDash(phase: axis.gridLineDashPhase, lengths: axis.gridLineDashLengths)
            } else {
                context.setLineDash(phase: 0.0, lengths: [])
            }

            // draw the grid ...
            positions.enumerated().forEach { (index, point) in

                // .. but skip the zero line (seems to be a bug)
                guard index != 0 else {
                    return
                }

                drawGridLine(context: context, position: point)
            }
        }
    }
}

struct BarChart_Previews: PreviewProvider {

    static var previews: some View {

        VStack {
            Text("Latency")
                .font(.title3)

            HStack {
                Text("abs. frequency")
                    .font(.caption2)
                    .padding(.leading, 4)

                Spacer()
            }
            .padding(.bottom, -20)

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

            HStack {
                Spacer()

                Text("latency [ms]")
                    .font(.caption2)
            }

            Spacer()
        }
    }
}
