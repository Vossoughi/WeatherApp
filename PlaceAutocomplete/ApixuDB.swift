//
//  ApixuDB.swift
//  PlaceAutocomplete
//
//  Created by Kaveh Vossoughi on 5/22/17.
//  Copyright © 2017 Kaveh Vossoughi. All rights reserved.
//

import Foundation

struct ApixuDB {
    
    struct Constants {
        
        // MARK: - URLs
        static let ApiKey = "ab7bc174537444648a424046172305"
        static let BaseURL = "https://api.apixu.com/v1/"
        static let Json = ".json"
        
    }
    
    struct CurrentResources {
        
        // MARK: - Current
        static let Current = "current"
        
        // MARK: - Location
        static let Location = "location"
        
    }
    
    struct ForecastResources {
        
        // MARK: - Forecast
        static let Forecast = "forecast"
        
    }
    
    struct Keys {
        
        // MARK - Current Keys
        static let Cloud = "cloud"
        static let DayOrNight = "is_day"
        static let PressureInchesOfMercury = "pressure_in"
        static let PressureMilibars = "pressure_mb"
        static let FeelsLikeF = "feelslike_f"
        static let FeelsLikeC = "feelslike_c"
        static let VisibilityMile = "vis_miles"
        static let VisibilityKm = "vis_km"
        static let WindDirection = "wind_dir"
        static let Humidity = "humidity"
        static let WindMph = "wind_mph"
        static let WindKph = "wind_kph"
        static let TemperatureF = "temp_f"
        static let TemperatureC = "temp_c"
        static let Condition = "condition"
        
        // MARK: - Condition
        static let Code = "code"
        static let ImageDescription = "text"
        static let IconURL = "icon"
        
        // MARK: - Location Keys
        static let LocalTime = "localtime"
        
    }
    
}
