//
//  WeatherAPIService.swift
//  WeatherOrNot
//
//  Created by Karan Shah on 12/8/15.
//  Copyright © 2015 Karan Shah. All rights reserved.
//

import Foundation

struct WeatherAPIService {
    static let weatherQueryURLString = "http://api.openweathermap.org/data/2.5/weather?q="
    static let apiParamString = "&appid="
    static let apiKey = ""          // Enter your Open Weather Map API Key here (temp wrong key - 2ff42eb65394991792cdd95cf3a4447)
    
    enum JSONError: String, ErrorType {
        case NoData = "ERROR: no data"
        case ConversionFailed = "ERROR: conversion from JSON failed"
    }
    
    /**
     Get the weather data by city name
     :param: city City to get the weather data for.
     :param: completion a completeion block to handle the CityWeather object that is returned on success
     */
    static func weatherByCity(city: String, completion: (CityWeather) -> ()) throws {
        let trimmedCityString = city.stringByReplacingOccurrencesOfString(" ", withString: "")
        let urlPath = weatherQueryURLString + trimmedCityString + apiParamString + apiKey
        guard let endpoint = NSURL(string: urlPath) else {
            print("Error creating Weather API Url")
            throw JSONError.NoData
        }
        queryURL(endpoint) { (json) -> () in
            //            print(json)
            guard let cityName = json["name"] as? String,
                let main = json["main"],
//                let humidity = main["humidity"] as? Int,
                let temp = main["temp"] as? Double else { return }
            
            var weatherDescription = ""
            if let weatherObj = json["weather"], weatherArr = weatherObj[0], weatherDesc = weatherArr["description"] as? String {
                weatherDescription = weatherDesc
            }
            let cityWeather = CityWeather(cityName: cityName, currentTemp: temp, weatherDescription: weatherDescription)
            
            completion(cityWeather)
            
        }
    }
    
    static func queryURL(endpoint: NSURL, completion: (NSDictionary) -> ()) {
        let request = NSMutableURLRequest(URL:endpoint)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) -> Void in
            do {
                guard let rawData = data else { throw JSONError.NoData }
                guard let json = try NSJSONSerialization.JSONObjectWithData(rawData, options: []) as? NSDictionary else { throw JSONError.ConversionFailed }
                completion(json)
            } catch let error as JSONError {
                print(error.rawValue)
            } catch {
                print(error)
            }
        }
        task.resume()
    }
}