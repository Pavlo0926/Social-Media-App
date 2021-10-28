//
//  LocationScreen.swift
//  VideoChatApp
//
//  Created by Apple on 04/05/2020.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import Foundation
import CoreLocation
import MapKit


class LocationScreen: UIViewController,CLLocationManagerDelegate, UITextFieldDelegate {

    @IBOutlet weak var navigationHeightCons: NSLayoutConstraint!
    @IBOutlet weak var pageCountTopCons: NSLayoutConstraint!
    @IBOutlet weak var locationTF: UITextField!
    @IBOutlet weak var mapView:MKMapView!
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var btnSkip: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    var locationManager =  CLLocationManager()
    var city="Location"
    var loadingIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

  
        
        mapView.showsUserLocation=true
        if CLLocationManager.locationServicesEnabled()
        {

//            print(CLLocationManager.authorizationStatus())
            if CLLocationManager.authorizationStatus() == .notDetermined || CLLocationManager.authorizationStatus() == .restricted || CLLocationManager.authorizationStatus() == .denied
            {
                if locationManager != nil{
                    locationManager.requestWhenInUseAuthorization()
                }

            }
            else
            {
                if locationManager != nil{
                    locationManager.delegate=self
                    locationManager.desiredAccuracy = kCLLocationAccuracyBest
                    locationManager.startUpdatingLocation()
                }

            }
        }
        
        hideKeyboardWhenTappedAround()
        self.locationTF.delegate = self
        
    }
    override func viewWillAppear(_ animated: Bool) {
        if AuthenticationService.shared.boolOpenPageViewBySetting{
            self.btnContinue.setTitle("Update", for: .normal)
            self.btnSkip.isHidden = false
            self.btnBack.isHidden = true
        }else{
            self.navigationHeightCons.constant = 0.0
            self.pageCountTopCons.constant = 50.0
            self.btnContinue.setTitle("Continue", for: .normal)
            self.btnSkip.isHidden = true
            self.btnBack.isHidden = false
        }
//        startLoader()
    }
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
////        if string.elementsEqual(""){
////            if (textField.text?.count == 1){
////                self.locationTF.text = "Location"
////                self.view.endEditing(true)
////                return false
////            }
////        }
//        print("")
//        return true
//    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if locations != nil{
            let latitude=locations[0].coordinate.latitude
            let longitude=locations[0].coordinate.longitude
            let coordinates=CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let span=MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
            let region=MKCoordinateRegion(center: coordinates, span: span)


            //        let anotation=MKPointAnnotation()
            //        anotation.title="Current Location"
            //        anotation.coordinate=coordinates

            mapView.setRegion(region, animated: true)
            //mapView.addAnnotation(anotation)
            //        self.stopLoader()
            getAddressFromLatLon(pdblLatitude: "\(latitude)", withLongitude: "\(longitude)")
        }
 
        

    }
    
    
    func getAddressFromLatLon(pdblLatitude: String, withLongitude pdblLongitude: String) {
        
        
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let lat: Double = Double("\(pdblLatitude)")!

        let lon: Double = Double("\(pdblLongitude)")!

        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = lat
        center.longitude = lon

        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)


        ceo.reverseGeocodeLocation(loc, completionHandler:
            {(placemarks, error) in
                if (error != nil)
                {
                }

                if placemarks != nil
                {

                    let pm = placemarks! as [CLPlacemark]

                    if pm.count > 0 {

                        let pm = placemarks![0]

                        print(pm.country ?? "")
                        print(pm.locality ?? "")
                       print(pm.subLocality ?? "")
                       print(pm.thoroughfare ?? "")
                        print(pm.postalCode ?? "")
                        print(pm.subThoroughfare ?? "")
                        var addressString : String = ""
                        
                        self.locationTF.text=pm.locality
                        
                        
                        self.locationManager.stopUpdatingLocation()
                        
//                        if pm.subLocality != nil {
//                            addressString = addressString + pm.subLocality! + ", "
//                        }
//                        if pm.thoroughfare != nil {
//                            addressString = addressString + pm.thoroughfare! + ", "
//                        }
//                        if pm.locality != nil {
//                            addressString = addressString + pm.locality! + ", "
//                            if pm.country != nil {
//                                addressString = addressString + pm.country! + ", "
//                                //uuuuu
//                                if(location_city != pm.locality!.trimmingCharacters(in: .whitespaces))
//                                {
//                                    location_city=pm.locality!.trimmingCharacters(in: .whitespaces)
//                                      DispatchQueue.main.async{
//                                    self.GetBeeWatherDetails(district: pm.locality!, country: pm.country!)
//                                    }
//                                }
//                            }
//
//                        }

                        if pm.postalCode != nil {
                            addressString = addressString + pm.postalCode! + " "
                        }

                    }
                }
        })

    }
    
    func startLoader() {
        self.view.isUserInteractionEnabled = false
        loadingIndicator.frame = CGRect(x: (self.view.frame.width / 2) - 50, y: (self.view.frame.height / 2) - 25, width: 25, height: 50)
        loadingIndicator.center = self.view.center
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.gray
        loadingIndicator.startAnimating();
        self.view.addSubview(loadingIndicator)
    }
    
    func stopLoader() {
        loadingIndicator.stopAnimating()
        loadingIndicator.removeFromSuperview()
        self.view.isUserInteractionEnabled = true
    }
    
//    func locationManager(_ manager: CLLocationManager,
//                             didChangeAuthorization status: CLAuthorizationStatus) {
//
//            switch status {
//
//            case .notDetermined         : print("notDetermined")        // location permission not asked for yet
//            case .authorizedWhenInUse   : print("authorizedWhenInUse")  // location authorized
//            case .authorizedAlways      : print("authorizedAlways")     // location authorized
//            case .restricted            : print("restricted")           // TODO: handle
//            case .denied                : print("denied")               // TODO: handle
//            }
//
//    }
//
    
    @IBAction func continueBtnClicked(_ sender: Any) {
        if (self.locationTF.text?.elementsEqual(""))!
        {
            UserInfo.shared.location = "Location"
        }else{
           UserInfo.shared.location = locationTF.text
        }
        
        
        
        let parentVC = self.parent as! PageViewController
    parentVC.setViewControllers([Constants.shared.viewControllerArr[6]], direction: .forward, animated: true, completion: nil)
    }
    
    @IBAction func backBtnAction(_ sender: UIButton) {
        let parentVC = self.parent as! PageViewController
    parentVC.setViewControllers([Constants.shared.viewControllerArr[4]], direction: .reverse, animated: true, completion: nil)
    }
    @IBAction func skipBtnClicked(_ sender: Any) {
        let parentVC = self.parent as! PageViewController
        parentVC.setViewControllers([Constants.shared.viewControllerArr[6]], direction: .forward, animated: true, completion: nil)
    }
    @IBAction func backTOSettingBtn(_ sender: Any) {
      
           self.dismiss(animated: true, completion: nil)
       }
}
