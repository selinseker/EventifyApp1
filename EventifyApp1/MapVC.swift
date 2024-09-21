//
//  MapVC.swift
//  EventifyApp1
//
//  Created by Selin Şeker on 14.08.2024.
//


import UIKit
import MapKit
import CoreLocation

class MapVC: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var MKMapView: MKMapView!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mapGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(konumSec(mapGestureRecognizer:)))
        
        MKMapView.delegate = self
        locationManager.delegate = self
        searchBar.delegate = self
        
        locationManager.requestWhenInUseAuthorization() // Kullanıcıdan konum izni iste
        locationManager.startUpdatingLocation() // Konum güncellemelerini başlat
        MKMapView.addGestureRecognizer(mapGestureRecognizer)
        mapGestureRecognizer.minimumPressDuration = 1
                
        // Harita görünümünü yapılandır
        MKMapView.showsUserLocation = true
    }
    
    @objc func konumSec(mapGestureRecognizer: UILongPressGestureRecognizer) {
        if mapGestureRecognizer.state == .began {
            let dokunulanNokta = mapGestureRecognizer.location(in: MKMapView)
            let dokunulanKoordinat = MKMapView.convert(dokunulanNokta, toCoordinateFrom: MKMapView)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = dokunulanKoordinat
            MKMapView.addAnnotation(annotation)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder() // Klavyeyi kapat
        
        if let searchText = searchBar.text, !searchText.isEmpty {
            performGeocoding(with: searchText)
        }
    }
    
    
    func performGeocoding(with address: String) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { [weak self] (placemarks, error) in
            guard let self = self else { return }
            if let error = error {
                print("Geocoding error: \(error)")
                return
            }
            if let placemark = placemarks?.first, let location = placemark.location {
                let coordinate = location.coordinate
                
                // Harita görünümünü güncelle
                let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
                let region = MKCoordinateRegion(center: coordinate, span: span)
                self.MKMapView.setRegion(region, animated: true)
                
                // Yeni bir işaretçi ekle
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                annotation.title = address
                self.MKMapView.addAnnotation(annotation)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let coordinate = location.coordinate
              
            let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
            let region = MKCoordinateRegion(center: coordinate, span: span)
            
            MKMapView.setRegion(region, animated: true)
                
            // İlk güncellemede, konum yönetimini durdurabiliriz
            locationManager.stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation() // Kullanıcı konumuna izin verilirse konum güncellemelerini başlat
        }
    }
}
