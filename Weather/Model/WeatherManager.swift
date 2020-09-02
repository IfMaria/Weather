//
//  WeatherManager.swift
//  Weather
//
//  Created by Maria Kramer on 01.09.2020.
//  Copyright © 2020 Maria Kramer. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithWeather(error: Error)
}

struct WeatherManager {
    
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=c8950c425bdea8dcc248903b10985992&units=metric"
    
    var delegate : WeatherManagerDelegate?
    
    func fetchWeather (cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
        
    }
    
    func fetchWeather (latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
    }
    
    func performRequest (with urlString: String) {
// 1. Create a URL
        if let url = URL(string: urlString){
// 2. Create a URLSession
        let session = URLSession(configuration: .default)
// 3. Give the session a task
        let task = session.dataTask(with: url) { (data, response, error) in
            if error != nil {
                self.delegate?.didFailWithWeather(error: error!)
                    return
                }
            if let safeData = data {
                if let weather = self.parseJSON(safeData){
                    self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
// 4. Start the task
            task.resume()
        }
        
    }
    
    func parseJSON (_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            return weather
        } catch {
            delegate?.didFailWithWeather(error: error)
            return nil
        }
    }
}
