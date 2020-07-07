//
//  WeatherViewController.swift
//  Color-TV-Project
//
//  Created by Dante Puglisi on 7/7/20.
//  Copyright © 2020 Dante Puglisi. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController {

	var weatherModel: WeatherModel!
	var image: UIImage?
	
	@IBOutlet weak var cityTitleLabel: UILabel!
	@IBOutlet weak var latLabel: UILabel!
	@IBOutlet weak var lonLabel: UILabel!
	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var tempLabel: UILabel!
	@IBOutlet weak var weatherTypeLabel: UILabel!
	@IBOutlet weak var weatherDescriptionLabel: UILabel!
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		setupView()
	}
	
	fileprivate func setupView() {
		tempLabel.text = String(Int(weatherModel.mainTemp.temp.rounded())) + "°"
		cityTitleLabel.text = weatherModel.name != "" ? weatherModel.name : "Unknown city"
		latLabel.text = "Lat: \(weatherModel.coord.lat)"
		lonLabel.text = "Lon: \(weatherModel.coord.lon)"
		weatherTypeLabel.text = weatherModel.getWeatherData()?.main.capitalized ?? ""
		weatherDescriptionLabel.text = weatherModel.getWeatherData()?.weatherDescription.capitalized ?? ""
		
		if let image = image {
			imageView.image = image
		}
	}
}
