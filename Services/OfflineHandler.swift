//
//  OfflineHandler.swift
//  Color-TV-Project
//
//  Created by Dante Puglisi on 7/7/20.
//  Copyright © 2020 Dante Puglisi. All rights reserved.
//

import Foundation
import UIKit

class OfflineHandler {
	let userDefaults = UserDefaults.standard
	
	func getKeyFromModel(_ model: WeatherModel) -> String {
		return String(model.coord.lat) + "|" + String(model.coord.lon)
	}
	
	func addInstance(model: WeatherModel) {
		try? userDefaults.set(PropertyListEncoder().encode(model), forKey: getKeyFromModel(model))
	}
	
	func getNearestModel(lat: Double, lon: Double) -> WeatherModel? {
		let dict = userDefaults.dictionaryRepresentation()
		if dict.count == 1 {
			return dict.first!.value as? WeatherModel
		} else if dict.count == 0 {
			return nil
		}
		var nearest: (model: WeatherModel, distance: Double)?
		for (key, value) in userDefaults.dictionaryRepresentation() {
			guard let modelData = value as? Data, let model = try? PropertyListDecoder().decode(WeatherModel.self, from: modelData) else { break }
			let keyComponents = key.components(separatedBy: "|")
			let keyLat = keyComponents.first!
			let keyLon = keyComponents.last!
			guard let latDouble = Double(keyLat), let lonDouble = Double(keyLon) else { continue }
			
			if let prevNearest = nearest {
				let newDistance = distanceBetweenCoordinates(a: (x: lat, y: lon), b: (x: latDouble, y: lonDouble))
				if newDistance < prevNearest.distance {
					nearest = (model: model, distance: newDistance)
				}
			} else {
				nearest = (model: model, distance: distanceBetweenCoordinates(a: (x: lat, y: lon), b: (x: latDouble, y: lonDouble)))
			}
		}
		return nearest?.model
	}
	
	fileprivate func distanceBetweenCoordinates(a: (x: Double, y: Double), b: (x: Double, y: Double)) -> Double {
		let xDistance = a.x - b.x
		let yDistance = a.y - b.y
		return sqrt(xDistance * xDistance + yDistance * yDistance)
	}
}
