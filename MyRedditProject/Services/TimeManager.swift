//
//  TimeManager.swift
//  MyRedditProject
//
//  Created by Zakhar Litvinchuk on 03.04.2024.
//

import Foundation


class TimeManager {
    
    private init() {}
    
    public static let manager = TimeManager()
    
    public func getTimeForTextLabel(createdUtc: Double) -> String {
        let currentUTC = Double(Date().timeIntervalSince1970)
        if (currentUTC - createdUtc)/60 < 1 { return "\(currentUTC - createdUtc)s" }
        else if (currentUTC - createdUtc)/3600 < 1 { return "\(Int((currentUTC - createdUtc)/60))m" }
        else if (currentUTC - createdUtc)/86400 < 1 { return "\(Int((currentUTC - createdUtc)/3600))h" }
        else if (currentUTC - createdUtc)/(86400 * 365) < 1 { return "\(Int((currentUTC - createdUtc)/86400))d" }
        else { return "\(Int((currentUTC - createdUtc)/(86400 * 365)))y" }
    }
}
