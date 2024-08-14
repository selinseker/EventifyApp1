//
//  MapVC.swift
//  EventifyApp1
//
//  Created by Selin Şeker on 14.08.2024.
//


import UIKit
import MapKit
import CoreLocation

class MapVC: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var MKMapView: MKMapView!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mapGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(konumSec(mapGestureRecognizer: )))
        
        MKMapView.delegate = self
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization() // Kullanıcıdan konum izni iste
        locationManager.startUpdatingLocation() // Konum güncellemelerini başlat
        MKMapView.addGestureRecognizer(mapGestureRecognizer)
        mapGestureRecognizer.minimumPressDuration = 1
                
        //Harita görünümünü yapılandır
        MKMapView.showsUserLocation = true

       
    }
    
    @objc func konumSec(mapGestureRecognizer : UILongPressGestureRecognizer) {
        
        if mapGestureRecognizer.state == .began{
            let dokunulanNokta = mapGestureRecognizer.location(in: MKMapView)
            let dokunulanKoordinat = MKMapView.convert(dokunulanNokta, toCoordinateFrom: MKMapView)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = dokunulanKoordinat
            MKMapView.addAnnotation(annotation)
        }
        
    }
    
    @objc func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        //print(locations[0].coordinate.latitude)
        //print(locations[0].coordinate.longitude)
        
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
