//
//  SpiralAnalyticsDataStore.swift
//  Nimble
//
//  Created by Ron Soffer on 9/12/23.
//

import Foundation

public class SpiralAnalyticsDataStore {
    
    static let spiralSdkDir = "spiral_sdk"
    static let analyticsDbFile = "spiral_analytics.sqlite3"
    
    static let shared = SpiralAnalyticsDataStore()
    
    var dbQueue: DatabaseQueue? = nil
    
    private init() {
        if let appSupportDir = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first {
            let dirPath = appSupportDir.appendingPathComponent(Self.spiralSdkDir)
            
            do {
                if !FileManager.default.fileExists(atPath: dirPath.path) {
                    try FileManager.default.createDirectory(atPath: dirPath.path, withIntermediateDirectories: true, attributes: nil)
                }
                let dbPath = dirPath.appendingPathComponent(Self.analyticsDbFile).path
                
                var shouldCreateDb = false
                if !FileManager.default.fileExists(atPath: dbPath) {
                    shouldCreateDb = true
                }
                
                dbQueue = try DatabaseQueue(path: dbPath)
                
                if shouldCreateDb {
                    createTables()
                }
                
            } catch {
                dbQueue = nil
                print("SpiralAnalyticsDataStore init error: \(error)")
            }
        } else {
            dbQueue = nil
        }
        
        let allEvents = getEvents()
        print(allEvents)
    }
    
    private func createTables() {
        do {
            try dbQueue?.write { db in
                try db.create(table: "events") { t in
                    t.primaryKey("id", .text)
                    t.column("event", .text).notNull()
                    t.column("properties", .text).notNull()
                    t.column("time", .date).notNull()
                }
            }
        }
        catch {
            print("SpiralAnalyticsDataStore createTables error: \(error)")
        }
    }
    
    public func addEvents(events: [SpiralAnalyticsEvent]) {
        do {
            try dbQueue?.write { db in
                try events.forEach { try $0.insert(db) }
            }
        } catch {
            print("SpiralAnalyticsDataStore addEvents error: \(error)")
        }
    }
    
    public func addEvent(event: SpiralAnalyticsEvent) {
        addEvents(events: [event])
    }
    
    public func deleteEvents(events: [SpiralAnalyticsEvent]) {
        do {
            try dbQueue?.write { db in
                try events.forEach { try $0.delete(db) }
            }
        } catch {
            print("SpiralAnalyticsDataStore deleteEvents error: \(error)")
        }
    }
    
    public func deleteEvent(event: SpiralAnalyticsEvent) {
        deleteEvents(events: [event])
    }
    
    public func getEvents() -> [SpiralAnalyticsEvent] {
        do {
            let events: [SpiralAnalyticsEvent]? = try dbQueue?.read { db in
                try SpiralAnalyticsEvent.fetchAll(db)
            }
            return events ?? []
        } catch {
            print("SpiralAnalyticsDataStore getEvents error: \(error)")
            return []
        }
    }
}

public struct SpiralAnalyticsEvent: Codable, FetchableRecord, PersistableRecord {
    public static var databaseTableName = "events"
    
    public static var jsonEncoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        return encoder
    }()
    
    var id: String
    var event: String
    var properties: String
    var time: Date
    
    init(id: String = UUID().uuidString, event: String, properties: [String: AnyCodable], date: Date = Date()) {
        self.id = id
        self.event = event
        self.time = date
                
        if let jsonData = try? SpiralAnalyticsEvent.jsonEncoder.encode(properties),
           let jsonText = String(data: jsonData,
                                    encoding: String.Encoding.ascii) {
            self.properties = jsonText
        } else {
            self.properties = "{}"
        }
    }
    
    init(sdkEvent: SpiralSDKEvent, properties: [String: AnyCodable]) {
        self.init(event: sdkEvent.rawValue, properties: properties)
    }
}
