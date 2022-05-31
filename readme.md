## Sample project to show a disrupted xaxis

![ScreenShot](https://github.com/mrommel/DisruptedXAxisChartDemo/raw/main/Screenshots/Chart_with_disrupted_xaxis.png)

<code>
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
</code>
