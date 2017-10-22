//
//  LocationManager.swift
//  codechunks
//
//  Created by Artem Demchenko on 10/18/17.
//  Copyright © 2017 artdmk. All rights reserved.
//

import UIKit
import CoreLocation

typealias DoubleCoordinates = (latitude: Double, longitude: Double)

class LocationManager: NSObject, CLLocationManagerDelegate, TimerRepeatable {
    
    static let shared = LocationManager()
    
    var timer: Timer!
    var locationManager = CLLocationManager()
    var currentLocation: CLLocationCoordinate2D?
    
    private override init() {
        super.init()
        locationManager.delegate = self
    }
    
    private func checkAuthorizationStatus() {
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            let alertController = UIAlertController(
                title: "Геопозиция",
                message: "Приложение запрашивает информацию о геопозиции",
                preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            
            let openAction = UIAlertAction(title: "Настройки", style: .default) { (action) in
                if let url = URL(string: UIApplicationOpenSettingsURLString) {
                    UIApplication.shared.openURL(url)
                }
            }
            alertController.addAction(openAction)
            UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
        default:
            break
        }
    }
    
    func startUpdatingLocation(with desiredAccuracy: CLLocationAccuracy = kCLLocationAccuracyNearestTenMeters, timeInterval: TimeInterval = 20.0) {
        checkAuthorizationStatus()
        stopTimer()
        locationManager.desiredAccuracy = desiredAccuracy
        locationManager.startUpdatingLocation()
        startTimer(every: timeInterval)
    }
    
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
        stopTimer()
    }
    
    // MARK: - TimerRepeatable
    
    @objc func handlerAfterTick() {
        locationManager.startUpdatingLocation()
    }
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = manager.location?.coordinate {
            self.currentLocation = location
            NotificationCenter.default.post(name: UpdateLocationNotification, object: nil, userInfo: ["location": location])
        }
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error: " + error.localizedDescription, terminator: "")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            startUpdatingLocation()
        case .denied:
            stopUpdatingLocation()
        default:
            break
        }
    }
    
    deinit {
        print("\(classForCoder) deinit")
    }
}

extension CLLocationCoordinate2D {
    var double: DoubleCoordinates {
        return DoubleCoordinates(latitude, longitude)
    }
}
