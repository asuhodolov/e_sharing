//
//  ScootersMapViewController.swift
//  
//
//  Created by Aliaksandr Sukhadolau on 12.10.22.
//

import Foundation
import UIKit
import MapKit

protocol ScootersMapViewControllerInput: AnyObject {
    
}

final class ScootersMapViewController: UIViewController {
    private var interactor: ScootersMapViewInteractorInput!
    
    private weak var mapView: MKMapView!
    
    init(interactor: ScootersMapViewInteractorInput!) {
        self.interactor = interactor
        super.init(nibName: nil,
                   bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareUI()
    }
    
    private func prepareUI() {
        prepareMap()
    }
    
    private func prepareMap() {
        let map = MKMapView(frame: view.bounds)
        map.autoresizingMask = [
            .flexibleHeight,
            .flexibleWidth]
        map.delegate = self
        map.showsUserLocation = true
        view.addSubview(mapView)
    }
}

//MARK: - ScootersMapViewController

extension ScootersMapViewController: ScootersMapViewControllerInput {
    
}

extension ScootersMapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        
    }
}
