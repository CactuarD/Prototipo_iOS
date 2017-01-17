//
//  Registro_UsuariosViewController.swift
//  Prototipo_iOS_DesMovil
//
//  Created by MacBookPro on 16/01/17.
//  Copyright © 2017 Integra IT. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class Registro_UsuariosViewController: UIViewController, CLLocationManagerDelegate {

    //Variables del MapKit y LocationManager
    @IBOutlet weak var mapRegistro: MKMapView!
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Opciones adicionales despues de cargar la vista
    }
    
    // MARK: - Obtención de la ubicación actual del usuario
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        //Variable que guarda la ultima locación conocida
        let location = locations.last! as CLLocation
        
        //Detiene la actualización de la ubicación permitiendo el desplazamiento del mapa fuera de la zona
        manager.stopUpdatingLocation()
        
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        self.mapRegistro.setRegion(region, animated: true)
    }

    
    // MARK: - Administrador de locación para solicitar la autorización correspondiente
    func checkLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            mapRegistro.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkLocationAuthorizationStatus()
    }

}
