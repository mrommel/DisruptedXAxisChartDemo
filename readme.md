## Sample project to show a disrupted xaxis

![ScreenShot](https://github.com/mrommel/DisruptedXAxisChartDemo/raw/main/Screenshots/Chart_with_disrupted_xaxis.png)

```
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
}
```
