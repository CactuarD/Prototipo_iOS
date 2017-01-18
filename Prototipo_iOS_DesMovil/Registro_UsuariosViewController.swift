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

class Registro_UsuariosViewController: UIViewController, CLLocationManagerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    //Picker y array de items del picker
    @IBOutlet weak var pickrReg: UIPickerView!
    var pickerData: [String] = [String]()

    //Variables del MapKit y LocationManager
    @IBOutlet weak var mapRegistro: MKMapView!
    let regionRadius: CLLocationDistance = 1000
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Solicitar Autorización para geolocalización
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        
        //Mostrar y ubicar la ubicación del usuario
        self.mapRegistro.showsUserLocation = true
        mapRegistro.setUserTrackingMode(MKUserTrackingMode.follow, animated: true)

        // Opciones adicionales despues de cargar la vista
        
        // Conexión de datos del picker:
        self.pickrReg.delegate = self
        self.pickrReg.dataSource = self
        
        //Datos que conforman el picker
        pickerData = ["Particular","Empresa"]
    }
    
    // MARK: - Obtención de la ubicación actual del usuario
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        //Variable que guarda la ultima locación conocida
        manager.desiredAccuracy = kCLLocationAccuracyBest
        let usrLocation = locations.last! as CLLocation
        
        
        //Detiene la actualización de la ubicación permitiendo el desplazamiento del mapa fuera de la zona
        manager.stopUpdatingLocation()
        
        let center = CLLocationCoordinate2D(latitude: usrLocation.coordinate.latitude, longitude: usrLocation.coordinate.longitude)
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
    
    // MARK: - Funciones para formato y selección del pickerView
    // Numero de Columnas
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // Numero de Filas
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    // Los datos que conformaran el picker
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    // Capturar la selección del usuario
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // Se activa cuando el usuario ha hecho una selección en el picker
        // Parametros Row y Componente determinan que se seleccionó
    }

}
