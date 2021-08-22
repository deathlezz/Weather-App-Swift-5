//
//  Weather App
//
//  Created by deathlezz on 17/08/2021.
//
//  Targets -> Signing & Capabilities -> Location
//  System Preferences -> Security & Privacy -> Enable Location Services

import CoreLocation

// specify how the JSON file looks like
struct Json: Codable {
    let name: String
    let main: [String: Double]
    let wind: [String: Double]
}

// create parse json function
func parseJSON(url: String) {
    do {
        // create url
        let url = URL(string: url)
        // make http (get) call
        let contents = try String(contentsOf: url!)
        // specify decoding format
        let data = contents.data(using: .utf8)
        // decode json data
        let weatherData = try JSONDecoder().decode(Json.self, from: data!)
        // output
        print("City: \(weatherData.name)")
        print("Temperature: \(Int(weatherData.main["temp"]! - 273.15)) °C")
        print("Feels like: \(Int(weatherData.main["feels_like"]! - 273.15)) °C")
        print("Wind: \(Int(weatherData.wind["speed"]! * 3.6)) km/h")
        print("Pressure: \(Int(weatherData.main["pressure"]!)) hPa")
        print("Humidity: \(Int(weatherData.main["humidity"]!)) %")
        
    } catch {
        // error handling
        print("* City not found *")
    }
}

// create location manager function
func locationManager(_ manager: CLLocationManager, _ status: CLAuthorizationStatus) {
    
    // enable location service
    let manager = CLLocationManager()
    // get user current location
    manager.startUpdatingLocation()
    // one second delay
    sleep(1)
    // get user current location coordinates
    let location = manager.location!.coordinate
    // call the function
    parseJSON(url: "http://api.openweathermap.org/data/2.5/weather?lat=\(location.latitude)&lon=\(location.longitude)&appid=410d1a69fc7442938ca824dce73c9cdf")
}

print("* Welcome to Weather App *")
print()
print("Select operation:")
print("[1] Show current weather for your location")
print("[2] Show current weather for specific city")

let input = Int(readLine()!)

if input == 1 {

    // call the function
    locationManager(CLLocationManager(), CLAuthorizationStatus.authorized)

} else if input == 2 {
    
    print("Enter city:")
    
    // city input
    let city = readLine()
    // check if city doesn't start and doesn't end with whitespace
    if !city!.hasPrefix(" ") && !city!.hasSuffix(" ") {
    
        // replace whitespace between words with "%20" (e.g. New York = New%20York)
        let replace = city!.replacingOccurrences(of: " ", with: "%20")
        // call the function
        parseJSON(url: "http://api.openweathermap.org/data/2.5/weather?q=\(replace)&appid=410d1a69fc7442938ca824dce73c9cdf")
    } else {
        print("* Avoid whitespaces *")
    }

} else {
    print("* Enter 1 or 2 *")
}
