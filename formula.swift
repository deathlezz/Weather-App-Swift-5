//
//  Weather App (formula)
//
//  Created by deathlezz on 16/08/2021.
//
//  Targets -> Signing & Capabilities -> Location
//  System Preferences -> Security & Privacy -> Enable Location Services

import CoreLocation

// specify how the JSON file looks like
struct json: Codable {
    let name: String
    let main: [String: Double]
    let wind: [String: Double]
}

// create function
func locationManager(_ manager: CLLocationManager, _ status: CLAuthorizationStatus) {
    
    do {
        // get user current location coordinates
        let location = manager.location!.coordinate
        // create url
        let url = URL(string: "http://api.openweathermap.org/data/2.5/weather?lat=\(location.latitude)&lon=\(location.longitude)&appid={API key}")
        // make http (get) call
        let contents = try String(contentsOf: url!)
        // specify decoding format
        let data = contents.data(using: .utf8)
        // decode json data
        let weatherData = try JSONDecoder().decode(json.self, from: data!)
        // output
        print("City: \(weatherData.name)")
        print("Temperature: \(weatherData.main["temp"]!) K")
        print("Feels like: \(weatherData.main["feels_like"]!) K")
        print("Wind: \(weatherData.wind["speed"]!) m/s")
        print("Pressure: \(weatherData.main["pressure"]!) hPa")
        print("Humidity: \(weatherData.main["humidity"]!) %")
        
    } catch {
        // error handling
        print("* Some error *")
    }
}

// enable location service
let manager = CLLocationManager()
// get user current location
manager.startUpdatingLocation()
// one second delay
sleep(1)

// call the function
locationManager(CLLocationManager(), CLAuthorizationStatus.authorized)
