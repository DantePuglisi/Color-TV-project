//
//  WeatherModel.swift
//  Color-TV-Project
//
//  Created by Dante Puglisi on 7/7/20.
//  Copyright © 2020 Dante Puglisi. All rights reserved.
//

import Foundation

struct WeatherModel: Codable {
	let coord: Coord
	let weather: [Weather]
	let base: String
	let mainTemp: MainTemp
	let name: String
	
	enum CodingKeys: String, CodingKey {
		case coord
		case weather
		case base
		case name
		case mainTemp = "main"
	}
	
	func getWeatherData() -> Weather? {
		return weather.first
	}
}

struct Coord: Codable {
	let lon, lat: Double
}

struct MainTemp: Codable {
	let temp: Double
	
	enum CodingKeys: String, CodingKey {
		case temp
	}
}

struct Weather: Codable {
	let icon, main, weatherDescription: String
	
	enum CodingKeys: String, CodingKey {
		case main
		case weatherDescription = "description"
		case icon
	}
}
