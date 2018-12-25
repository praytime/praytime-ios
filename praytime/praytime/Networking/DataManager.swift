//
//  DataManager.swift
//  praytime
//
//  Created by Sameer on 12/23/18.
//  Copyright © 2018 praytime. All rights reserved.
//

import UIKit
import Firebase

class DataManager: NSObject {

    /// Singleton instance of DataManager
    static let shared = DataManager()
    /// The Firestore database for praytime
    private let database = Firestore.firestore()
        
    /// Start up and configure database connection
    class func configure() {
        FirebaseApp.configure()
        let settings = DataManager.shared.database.settings
        settings.areTimestampsInSnapshotsEnabled = true
        DataManager.shared.database.settings = settings
    }
    
    /// Get the events array from the database.
    /// - Parameters:
    ///     - completion: The closure that returns and optional error, or an optional array of events
    func getEvents(completion: @escaping (_ error: Error?, _ events: [Event]?) -> ()) {
        database.collection(Strings.events).getDocuments { (snapshot, error) in
            if let error = error {
                completion(error, nil)
            }
            else if let snapshot = snapshot {
                var events: [Event] = []
                snapshot.documents.forEach {
                    var data = self.firebaseJSONValueToDict(data: $0.data(), type: GeoPoint.self)
                    data = self.firebaseJSONValueToDict(data: data, type: Timestamp.self)
                    if let jsonData = try? JSONSerialization.data(withJSONObject: data, options: .prettyPrinted),
                        let event = try? JSONDecoder().decode(Event.self, from: jsonData) {
                        events.append(event)
                    }
                }
                completion(nil, events)
            }
        }
    }
    
    /// Firebase returns a dictionary. Some of the values in the dictionary are not JSON encodable. Use this method to ensure the returned firebase values are JSONSerializable.
    /// - Parameters:
    ///     - data: The data returned from Firestore
    ///     - type: The generic type being being changed from [String, Any] to JSONSerializable
    /// - Returns:
    ///     - [String: Any] that is JSONSerializable
    func firebaseJSONValueToDict<T: Codable>(data: [String: Any], type: T.Type) -> [String: Any] {
        var data = data
        for key in data.keys {
            if let val = data[key] as? T,
                let firData = try? JSONEncoder().encode(val) {
                data[key] = try? JSONSerialization.jsonObject(with: firData, options: .allowFragments)
            }
        }
        return data
    }
}

extension DataManager {
    struct Strings {
        static let events = "Events"
    }
}
