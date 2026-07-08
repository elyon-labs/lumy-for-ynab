//
//  Widgets.swift
//  Widgets
//
//  Created by Brandon Trautmann on 5/15/24.
//

import WidgetKit
import SwiftUI
import Charts
import AppIntents

/// The Metric that will appear in the Widget
struct MetricEntry: TimelineEntry {
    let date: Date
    let canBeShown: Bool
    let chartData: [ChartData]
    let statData: StatData
}

/// Information for the chart.
///
/// color: The color of chart elements (area and line)
/// spendPoints: Points to be plotted on the chart
struct ChartData : Decodable, Identifiable {
    let id = UUID()
    let colorLight: String
    let colorDark: String
    let points: [ChartPoint]
    let isDashed: Bool
}

/// A point on the chart where `X` is the day of the month and `Y` is the amount spent.
struct ChartPoint : Decodable, Identifiable {
    let id = UUID()
    let x: Int
    let y: Int
}

/// Information for the stat.
///
/// backgroundColor: The color of the stat's background
/// textColor: The color of the stat's text
/// value: The actual value of the stat
struct StatData : Decodable {
    let title: String
    let backgroundColor: String
    let textColor: String
    let value: String
}

/// The payload we expect from Flutter, consisting of everything we need
/// to render the Widget.
struct MetricPayload : Decodable {
    let canBeShown: Bool
    let chartData: [ChartData]
    let statData: StatData
}

/// The Intent passed to the various Provider functions indicating the user's Metric choice. Based on this Intent, we'll render
/// the appropriate data.
struct ChooseMetricIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Select Metric"
    static var description = IntentDescription("Select the metric to display")
    
    
    @Parameter(title: "Metric")
    var metric: Metric
    
    
    init(detail: Metric) {
        self.metric = detail
    }
    
    init() {}
}

/// The Metric object chosen by the user. We should use the `id` field to fetch the correct data from UserDefaults.
struct Metric: AppEntity {
    let id: String
    let name: String
    
    static var typeDisplayRepresentation: TypeDisplayRepresentation = "Metric"
    static var defaultQuery = MetricQuery()
    
    /// How the choice appears in the selection UI. Just showing the name.
    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(name)")
    }
    
    static let spentThisMonth: Metric = Metric(id: "spent_this_month", name: "Spent this month")
    static let leftToSpend: Metric = Metric(id: "left_to_spend", name: "Left to spend")
    static let ageOfMoney: Metric = Metric(id: "age_of_money", name: "Age of money")
    
    /// All metric choices to offer the user. In other words, all of the metrics supported by this Widget.
    static let allSupportedMetrics: [Metric] = [
        spentThisMonth, leftToSpend, ageOfMoney
    ]
}

struct MetricQuery: EntityQuery {
    func entities(for identifiers: [Metric.ID]) async throws -> [Metric] {
        Metric.allSupportedMetrics.filter { identifiers.contains($0.id) }
    }
    
    func suggestedEntities() async throws -> [Metric] {
        Metric.allSupportedMetrics
    }
    
    func defaultResult() async -> Metric? {
        try? await suggestedEntities().first
    }
}

struct Provider: AppIntentTimelineProvider {
    
    /// Define the entry type
    typealias Entry = MetricEntry
    typealias Intent = ChooseMetricIntent
    
    /// Fetch the payload from UserDefaults according to the currently selected Metric
    /// Returns `nil` if nothing is found
    func fetchMetricPayload(for key: String) -> MetricPayload? {
        print("Searching for key \(key)")
        if let data = UserDefaults(suiteName: "group.com.brandontrautmann.apps")?.string(forKey: key) {
            let decoder = JSONDecoder()
            print("Found data, decoding...")
            do {
                return try decoder.decode(MetricPayload.self, from: data.data(using: .utf8)!)
            } catch {
                print("Decoding error: \(error)")
                return nil
            }
        }
        print("No data for key \(key) was found")
        return nil
    }
    
    /// Builds a `MetricEntry` for the given `Metric`. If the data for the `Metric` is not in `UserDefaults`,
    /// it will return a fallback `MetricEntry` with dummy values.
    func buildInternal(for metric: Metric) -> MetricEntry {
        if let payload = fetchMetricPayload(for: metric.id) {
            return MetricEntry(
                date: Date(),
                canBeShown: payload.canBeShown,
                chartData: payload.chartData,
                statData: payload.statData
            )
        } else {
            // Fallback placeholder data
            let spendPoints = [
                ChartPoint(x: 1, y: 10),
                ChartPoint(x: 2, y: 20),
                ChartPoint(x: 3, y: 15)
            ]
            
            let chartData = [
                ChartData(
                    colorLight: "#3498db",
                    colorDark: "#3498db",
                    points: spendPoints,
                    isDashed: false
                )
            ]
            
            let statData = StatData(
                title: "LTS",
                backgroundColor: "#2ecc71",
                textColor: "#ffffff",
                value: "$123.45"
            )
            
            return MetricEntry(
                date: Date(),
                canBeShown: true,
                chartData: chartData,
                statData: statData
            )
        }
    }
    
    // Provide a placeholder entry (for the widget gallery)
    func placeholder(in context: Context) -> MetricEntry {
        return buildInternal(for: Metric.leftToSpend)
    }
    
    // Provide a snapshot entry (for the widget configuration preview)
    func snapshot(for configuration: ChooseMetricIntent, in context: Context) async -> MetricEntry {
        return buildInternal(for: configuration.metric)
    }
    
    // Provide the timeline entries
    func timeline(for configuration: ChooseMetricIntent, in context: Context) async -> Timeline<MetricEntry> {
        let entries: [MetricEntry]
        if let payload = fetchMetricPayload(for: configuration.metric.id) {
            let entry = MetricEntry(
                date: Date(),
                canBeShown: payload.canBeShown,
                chartData: payload.chartData,
                statData: payload.statData
            )
            entries = [entry]
        } else {
            entries = [buildInternal(for: configuration.metric)]
        }
        let timeline = Timeline(entries: entries, policy: .atEnd)
        return timeline
    }
}

struct WidgetsEntryView : View {
    var entry: Provider.Entry
    
    init(entry: Provider.Entry) {
        self.entry = entry
        CTFontManagerRegisterFontsForURL(bundle.appending(path: "/assets/fonts/Quicksand-Regular.ttf") as CFURL, CTFontManagerScope.process, nil)
    }
    
    var bundle: URL {
        let bundle = Bundle.main
        if bundle.bundleURL.pathExtension == "appex" {
            // Peel off two directory levels - MY_APP.app/PlugIns/MY_APP_EXTENSION.appex
            var url = bundle.bundleURL.deletingLastPathComponent().deletingLastPathComponent()
            url.append(component: "Frameworks/App.framework/flutter_assets")
            return url
        }
        return bundle.bundleURL
    }
    
    var body: some View {
        ZStack {
            ChartView(entry: entry)
            VStack {
                HStack {
                    Text(entry.canBeShown ? entry.statData.title : "")
                    Spacer()
                }.padding()
                Spacer()
                HStack {
                    Spacer()
                    Text(entry.statData.value).foregroundColor(Color(hex: entry.statData.textColor))
                        .padding(4)
                        .background(Color(hex: entry.statData.backgroundColor))
                        .cornerRadius(10)
                        .shadow(radius: 5)
                    
                    
                }.padding()
            }
        }.widgetURL(URL(string: "metricWidget://?isRequestingUpgrade=\(!entry.canBeShown)&homeWidget"))
        
    }
}

struct ChartView: View {
    let entry: MetricEntry
    @Environment(\.colorScheme) var colorScheme
    
    private func maxXValue(for data: [ChartData]) -> Int {
        return data.flatMap { $0.points }.map { $0.x }.max() ?? 1
    }
    
    private func maxYValue(for data: [ChartData]) -> Int {
        return data.flatMap { $0.points }.map { $0.y }.max() ?? 0
    }
    
    private func color(for data: ChartData) -> Color {
        return colorScheme == .dark ? Color(hex: data.colorDark) : Color(hex: data.colorLight)
    }
    
    var body: some View {
        Chart {
            if entry.canBeShown {
                ForEach(Array(entry.chartData.enumerated()), id: \.element.id) { index, data in
                    
                    ForEach(data.points) {point in
                        AreaMark(
                            x: .value("Day", point.x),
                            yStart:     .value("Spend", 0),
                            yEnd: .value("Spend", point.y)
                        )
                        .interpolationMethod(.monotone)
                        .foregroundStyle(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    color(for: data).opacity(0.7),
                                    color(for: data).opacity(0)
                                ]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .foregroundStyle(by: .value("Value", "Area \(index)"))
                        
                        LineMark(
                            x: .value("Day", point.x),
                            y: .value("Spent", point.y)
                        )
                        .interpolationMethod(.monotone)
                        .foregroundStyle(color(for: data))
                        .foregroundStyle(by: .value("Value", "Line \(index)"))
                        // Would be nice to conditionally call this instead of the conditional array
                        .lineStyle(StrokeStyle(lineWidth: 2, dash: data.isDashed ? [5, 5] : []))
                    }
                }
            }
        }
        .chartXAxis(.hidden)
        .chartYAxis(.hidden)
        .chartLegend(.hidden)
        .chartXScale(domain: 1...maxXValue(for: entry.chartData))
        .chartYScale(domain: 0...maxYValue(for: entry.chartData))
    }
}

struct MetricsWidget: Widget {
    let kind: String = "MetricsWidget"
    
    var body: some WidgetConfiguration {
        AppIntentConfiguration(
            kind: kind,
            intent: ChooseMetricIntent.self,
            provider: Provider()) { entry in
                if #available(iOS 17.0, *) {
                    WidgetsEntryView(entry: entry)
                        .containerBackground(.fill.tertiary, for: .widget)
                } else {
                    WidgetsEntryView(entry: entry).background()
                    
                }
                
            }
            .supportedFamilies([.systemSmall])
            .contentMarginsDisabled()
            .configurationDisplayName("Single Metric")
            .description("Keep track of a single budget metric")
    }
}

#Preview(as: .systemSmall) {
    MetricsWidget()
} timeline: {
    let chartPoints = [
        ChartPoint(x: 1, y: 10),
        ChartPoint(x: 2, y: 20),
        ChartPoint(x: 3, y: 45),
        ChartPoint(x: 4, y: 72),
        ChartPoint(x: 5, y: 98),
        ChartPoint(x: 6, y: 101),
        ChartPoint(x: 7, y: 150),
        ChartPoint(x: 8, y: 300),
        ChartPoint(x: 9, y: 450),
        ChartPoint(x: 10, y: 500),
        ChartPoint(x: 11, y: 550),
        ChartPoint(x: 12, y: 650),
        ChartPoint(x: 13, y: 900),
        ChartPoint(x: 14, y: 950),
        ChartPoint(x: 15, y: 975),
        ChartPoint(x: 16, y: 1000),
        ChartPoint(x: 17, y: 1050),
        ChartPoint(x: 18, y: 1250)
    ]
    
    let chartPoints2 = [
        ChartPoint(x: 1, y: 15),
        ChartPoint(x: 2, y: 25),
        ChartPoint(x: 3, y: 30),
        ChartPoint(x: 4, y: 35),
        ChartPoint(x: 5, y: 45),
        ChartPoint(x: 6, y: 50),
        ChartPoint(x: 7, y: 55),
        ChartPoint(x: 8, y: 65),
        ChartPoint(x: 9, y: 70),
        ChartPoint(x: 10, y: 72),
        ChartPoint(x: 11, y: 74),
        ChartPoint(x: 12, y: 78),
        ChartPoint(x: 13, y: 85),
        ChartPoint(x: 14, y: 95),
        ChartPoint(x: 15, y: 100),
        ChartPoint(x: 16, y: 150),
        ChartPoint(x: 17, y: 250),
        ChartPoint(x: 18, y: 300)
    ]
    
    let chartData = [
        ChartData(
            colorLight: "#484C53", // Grey
            colorDark: "#484C53", // Grey
            points: chartPoints2,
            isDashed: true
        ),
        ChartData(
            colorLight: "#5C43D6", // Purple
            colorDark: "#5C43D6", // Purple
            points: chartPoints,
            isDashed: false
        ),
    ]
    
    
    MetricEntry(
        date: Date(),
        canBeShown: true,
        chartData: chartData,
        statData: StatData(
            title: "STM",
            backgroundColor: "#3E9D36",
            textColor: "#ffffff",
            value: "$123.45"
        )
    )
    MetricEntry(
        date: Date(),
        canBeShown: false,
        chartData: chartData,
        statData: StatData(
            title: "",
            backgroundColor: "#3E9D36",
            textColor: "#ffffff",
            value: "Log in"
        )
    )
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
