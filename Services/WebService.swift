//
//  WebService.swift
//  Color-TV-Project
//
//  Created by Dante Puglisi on 7/7/20.
//  Copyright © 2020 Dante Puglisi. All rights reserved.
//

import Foundation
import UIKit

class WebService {
	let APIKey = "608e5eeea362da0e2c8c9c20d04ff68b"
	
	func getWeather(lat: String, lon: String, onResult: @escaping (WeatherModel) -> (), onError: @escaping () -> ()) {
		guard let url = URL(string: "http://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&units=imperial&appid=\(APIKey)") else { return }
		URLSession.shared.dataTask(with: url) {(data, response, error) in
			do {
				if let weatherData = data {
					let decodedData = try JSONDecoder().decode(WeatherModel.self, from: weatherData)
					DispatchQueue.main.async {
						onResult(decodedData)
					}
				} else {
					onError()
				}
			} catch {
				onError()
			}
		}.resume()
	}
	
	func getIcon(withID id: String, onResult: @escaping (UIImage) -> (), onError: @escaping () -> ()) {
		guard let url = URL(string: "http://openweathermap.org/img/wn/\(id)@2x.png") else { return }
		URLSession.shared.dataTask(with: url) {(data, response, error) in
			if let imageData = data, let image = UIImage(data: imageData) {
				DispatchQueue.main.async {
					onResult(image)
				}
			} else {
				onError()
			}
		}.resume()
	}
}
