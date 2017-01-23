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

class Registro_UsuariosViewController: UIViewController, CLLocationManagerDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate{
    
    // MARK: Declaracione de outlets y variables

    
    //Picker y array de items del picker
    @IBOutlet weak var pickrReg: UIPickerView!
    var pickerData: [String] = [String]()
    
    //Campos de texto
    @IBOutlet weak var txtNombre: UITextField!
    @IBOutlet weak var txtDireccion: UITextField!
    @IBOutlet weak var txtRazonSoc: UITextField!
    @IBOutlet weak var txtTelefono: UITextField!
    @IBOutlet weak var txtCiudad: UITextField!
    
    // MARK: Variables del MapKit y LocationManager
    @IBOutlet weak var mapRegistro: MKMapView!
    let regionRadius: CLLocationDistance = 1000
    let locationManager = CLLocationManager()
    var pinUsuario = MKPointAnnotation()
    // MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Delegados de los textfield
        txtNombre.delegate = self
        txtDireccion.delegate = self
        txtRazonSoc.delegate = self
        txtTelefono.delegate = self
        txtCiudad.delegate = self
        
        //Solicitar Autorización para geolocalización
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        
        let theLocation: MKUserLocation = mapRegistro.userLocation
        theLocation.title = "Ubicación actual"
        
        //Mostrar y ubicar la ubicación del usuario
        self.mapRegistro.showsUserLocation = true
        mapRegistro.setUserTrackingMode(MKUserTrackingMode.follow, animated: true)

        // Opciones adicionales despues de cargar la vista
        
        // Conexión de datos del picker:
        self.pickrReg.delegate = self
        self.pickrReg.dataSource = self
        
        //Datos que conforman el picker
        pickerData = ["Particular","Empresa"]
        
        //Focus de los textfield despues del return
        self.txtNombre.sigCampo = self.txtDireccion
        self.txtDireccion.sigCampo = self.txtRazonSoc
        self.txtRazonSoc.sigCampo = self.txtTelefono
        self.txtTelefono.sigCampo = self.txtCiudad
    }
    
    // MARK: - Boton para registrar nuevo usuario
    
    @IBAction func regNuevoUsr(_ sender: Any) {
        
        let errorEncontrado = checkForErrors()
        
        if !errorEncontrado
        {
            self.performSegue(withIdentifier: "segueLoginInic", sender: self)
        }
    }
    
    // MARK: - Obtención de la ubicación actual del usuario y dirección
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        
        //Variable que guarda la ultima locación conocida
        let usrLocation = locations.last! as CLLocation
        
        
        //Detiene la actualización de la ubicación permitiendo el desplazamiento del mapa fuera de la zona
        manager.stopUpdatingLocation()
        
        let center = CLLocationCoordinate2D(latitude: usrLocation.coordinate.latitude, longitude: usrLocation.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        self.mapRegistro.setRegion(region, animated: true)

        
    }
    
    //Cambia las coordenadas de la ubicación al mantener presionado en el mapa
    @IBAction func addUsrPin(_ sender: UILongPressGestureRecognizer) {
        
        let ubicacion = sender.location(in: self.mapRegistro)
        let pinCoord = self.mapRegistro.convert(ubicacion, toCoordinateFrom: self.mapRegistro)
        
        pinUsuario.coordinate = pinCoord
        pinUsuario.title = txtCiudad.text
        pinUsuario.subtitle = txtDireccion.text
        
        self.mapRegistro.removeAnnotations(mapRegistro.annotations)
        self.mapRegistro.addAnnotation(pinUsuario)
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
    
    // MARK: - Validaciones de los campos de texto
    //Funcionalidad del boton return en los campos de texto
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.sigCampo?.becomeFirstResponder()
        
        if textField == txtCiudad {
            textField.resignFirstResponder()
        }
        
        if textField == txtCiudad {
            let location = self.txtDireccion.text!+" "+self.txtCiudad.text!
            let geocoder = CLGeocoder()
            geocoder.geocodeAddressString(location) { [weak self] placemarks, error in
                if let placemark = placemarks?.first, let location = placemark.location {
                    let mark = MKPlacemark(placemark: placemark)    
                    
                    if var region = self?.mapRegistro.region {
                        region.center = location.coordinate
                        region.span.longitudeDelta /= 8.0
                        region.span.latitudeDelta /= 8.0
                        self?.mapRegistro.setRegion(region, animated: true)
                        self?.mapRegistro.addAnnotation(mark)
                    }
                }
            }
        }
        return true
    }
    
    //Realizar validaciones correspondientes
    
    func checkForErrors() -> Bool
    {
        var errors = false
        let title = "Error"
        var message = ""
        
        if (txtNombre.text?.isEmpty)! {
            errors = true
            message += "El campo de nombre esta vacio"
            alertWithTitle(title: title, message: message, ViewController: self, toFocus:self.txtNombre)
            
        }
        else if (txtDireccion.text?.isEmpty)!
        {
            errors = true
            message += "La direcciòn esta vacia"
            alertWithTitle(title: title, message: message, ViewController: self, toFocus:self.txtDireccion)
        }
        else if (txtRazonSoc.text?.isEmpty)!
        {
            errors = true
            message += "Razón social vacia"
            alertWithTitle(title: title, message: message, ViewController: self, toFocus:self.txtRazonSoc)
            
        }
        else if (txtTelefono.text?.isEmpty)!
        {
            errors = true
            message += "Numero de telefono vacio"
            alertWithTitle(title: title, message: message, ViewController: self, toFocus:self.txtTelefono)
        }
        else if (txtCiudad.text?.isEmpty)!
        {
            errors = true
            message += "Ciudad no especificada"
            alertWithTitle(title: title, message: message, ViewController: self, toFocus:self.txtCiudad)
        }
        
        return errors
    }
    
    //Funcion para crear alertas en caso de campo vacio
    
    func alertWithTitle(title: String!, message: String, ViewController: UIViewController, toFocus:UITextField) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel,handler: {_ in
            toFocus.becomeFirstResponder()
        });
        alert.addAction(action)
        ViewController.present(alert, animated: true, completion:nil)
    }
    
    

}
