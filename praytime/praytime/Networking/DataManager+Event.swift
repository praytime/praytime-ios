//
//  DataManager+Event.swift
//  praytime
//
//  Created by Sameer on 12/24/18.
//  Copyright © 2018 praytime. All rights reserved.
//

import Foundation
import CoreLocation

extension DataManager {
    
    func filterEvents(for location: String) {
        guard let events = events else { return }
        self.delegate?.isloading(true)
        findLocation(from: location) { (error, location) in
            if let error = error {
                self.delegate?.eventsDidFail(error: error)
            }
            else if let location = location {
                let filteredEvents = events.filter {
                    return $0.distanceInMiles(from: location) < 50
                }
                let sortedEvents = filteredEvents.sorted {
                    return $0.location.distance(from: location) < $1.location.distance(from: location)
                }
                self.delegate?.isloading(false)
                self.delegate?.didReceieveFilteredEvents(events: sortedEvents)
            }
        }
    }
    
    func filterBookmaredEvents()  {
        guard let events = events else { return }
        self.delegate?.didReceieveFilteredEvents(events: events.filter { $0.bookmarked })
    }
    
    private func findLocation(from string: String, completion: @escaping (_ error: Error?, _ location: CLLocation?) -> () ) {
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(string) { (placemarks, error) in
            if let error = error {
                completion(error, nil)
            }
            else if let placemarks = placemarks {
                let location = placemarks.first?.location
                completion(nil, location)
            }
        }
    }

    func bookmarkEvent(event: Event) {
        var bookmarks: [String] = []
        if let arr: [String] = UserDefaults.standard.array(forKey: Strings.bookmarks) as? [String] {
            bookmarks = arr
        }
        bookmarks.append(event.uuid4)
        UserDefaults.standard.set(bookmarks, forKey: Strings.bookmarks)
    }
    
    func isEventBookmarked(event: Event) -> Bool {
        guard let arr: [String] = UserDefaults.standard.array(forKey: Strings.bookmarks) as? [String] else { return false }
        if arr.contains(event.uuid4) {
            return true
        }
        return false
    }
    
    func removeBookmark(event: Event) {
        var bookmarks: [String] = []
        if let arr: [String] = UserDefaults.standard.array(forKey: Strings.bookmarks) as? [String] {
            bookmarks = arr
        }
        bookmarks = bookmarks.filter {
            return $0 != event.uuid4
        }
        UserDefaults.standard.set(bookmarks, forKey: Strings.bookmarks)
    }
 
}
