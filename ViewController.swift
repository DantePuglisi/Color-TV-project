//
//  ViewController.swift
//  Color-TV-Project
//
//  Created by Dante Puglisi on 7/7/20.
//  Copyright © 2020 Dante Puglisi. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {

	var webService: WebService!
	var offlineHandler: OfflineHandler!
	
	let locationManager = CLLocationManager()
	
	var canShowNewVC = true
	
	@IBOutlet weak var mapView: MKMapView!
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
			mapView.showsUserLocation = true
		} else {
			locationManager.requestWhenInUseAuthorization()
		}
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		removeDoubleTapFromMap()
	}
	
	func removeDoubleTapFromMap() {
		guard let mapGestures = mapView.subviews[0].gestureRecognizers else { return }
		for gesture in mapGestures {
			if let tapGesture = gesture as? UITapGestureRecognizer {
				if tapGesture.numberOfTapsRequired == 2 {
					mapView.subviews[0].removeGestureRecognizer(tapGesture)
				}
			}
		}
	}

	@IBAction func doubleTapRecognized(_ sender: UITapGestureRecognizer) {
		guard canShowNewVC else { return }
		canShowNewVC = false
		let touchLocation = sender.location(in: mapView)
		let locationCoordinate = mapView.convert(touchLocation, toCoordinateFrom: mapView)
		fetchWeather(withLoc: locationCoordinate)
	}
	
	fileprivate func fetchWeather(withLoc loc: CLLocationCoordinate2D) {
		webService.getWeather(lat: "\(loc.latitude)", lon: "\(loc.longitude)", onResult: { [weak self] weatherModel in
			self?.offlineHandler.addInstance(model: weatherModel)
			self?.fetchIconAndSegue(withModel: weatherModel)
		}) { [weak self] in
			self?.canShowNewVC = true
			self?.fetchStoredWeather(withLoc: loc)
		}
	}
	
	fileprivate func fetchIconAndSegue(withModel model: WeatherModel) {
		if let weatherData = model.getWeatherData() {
			webService.getIcon(withID: weatherData.icon, onResult: { [weak self] image in
				self?.runSegue(withModel: model, image: image)
			}) { [weak self] in
				self?.canShowNewVC = true
				print("Error! Couldn't get image")
			}
		} else {
			runSegue(withModel: model)
		}
	}
	
	/// If there's any issue getting the weather data from the server we try to get the weather data for the closest location we have saved
	fileprivate func fetchStoredWeather(withLoc loc: CLLocationCoordinate2D) {
		guard let modelToUse = offlineHandler.getNearestModel(lat: loc.latitude, lon: loc.longitude) else { displayAlert(withMessage: "Couldn't fetch weather data from the server and we don't have anything stored"); return }
		
		displayAlert(withMessage: "We couldn't fetch weather data for that location but we will show you the weather data for the nearest location we have saved!", completion: { [weak self] in
			self?.runSegue(withModel: modelToUse)
		})
	}
	
	func runSegue(withModel model: WeatherModel, image: UIImage? = nil) {
		self.performSegue(withIdentifier: "weatherSegue", sender: (model: model, image: image))
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		guard let tuple = sender as? (model: WeatherModel, image: UIImage?) else { canShowNewVC = true; return }
		guard let newVC = segue.destination as? WeatherViewController else { canShowNewVC = true; return }
		newVC.presentationController?.delegate = self
		newVC.weatherModel = tuple.model
		if let image = tuple.image {
			newVC.image = image
		}
	}
	
	fileprivate func displayAlert(withMessage message: String, completion: (() -> ())? = nil) {
		DispatchQueue.main.async {
			let alert = UIAlertController(title: "Error!", message: message, preferredStyle: .alert)
			alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
				completion?()
			}))
			self.present(alert, animated: true, completion: nil)
		}
	}
}

extension ViewController: UIAdaptivePresentationControllerDelegate {
	func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
		canShowNewVC = true
	}
}
