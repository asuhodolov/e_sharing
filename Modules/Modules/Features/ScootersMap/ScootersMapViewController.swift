//
//  ScootersMapViewController.swift
//  
//
//  Created by Aliaksandr Sukhadolau on 12.10.22.
//

import Foundation
import UIKit
import MapKit
import Services

protocol ScootersMapViewControllerInput: AnyObject {
    func show(vehicles: [VehicleViewModel])
    func highlightMapItem(with itemId: String)
    func setReloadButtonHidden(hidden: Bool)
}

typealias PresentModalView = (_ viewToPresent: UIViewController, _ animated: Bool) -> Void
typealias DismissModalView = (_ animated: Bool) -> Void

protocol ScootersMapViewPresentation {
    var viewModalPresenter: PresentModalView { get }
    var viewModalDismisser: DismissModalView { get }
}

final class ScootersMapViewController: UIViewController, ScootersMapViewPresentation {
    lazy var viewModalPresenter: PresentModalView = { [weak self] (viewToPresent: UIViewController, animated: Bool) in
        self?.present(viewToPresent, animated: animated)
    }
    
    lazy var viewModalDismisser: DismissModalView = { [weak self] (animated: Bool) in
        self?.dismiss(animated: animated)
    }
    
    private var interactor: ScootersMapViewInteractorInput!
    fileprivate var vehicles = [VehicleViewModel]()
    
    private weak var mapView: MKMapView!
    private weak var reloadButton: UIButton!
    
    fileprivate struct Constants {
        static let vehicleAnnotationReusableIdentifier = "VehicleId"
        static let annotationClusteringIdentifier = "ClusteringId"
    }
    
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
        interactor.viewDidLoad()
    }
    
    private func prepareUI() {
        prepareMap()
        prepareReloadButton()
    }
    
    private func prepareMap() {
        let map = MKMapView(frame: view.bounds)
        map.autoresizingMask = [
            .flexibleHeight,
            .flexibleWidth]
        map.delegate = self
        map.showsUserLocation = true
        mapView = map
        view.addSubview(map)
    }
    
    private func prepareReloadButton() {
        let button = UIButton(type: .custom)
        let title = NSLocalizedString("Map_button_reloadVehicles",
                                      value:"Reload Vehicles",
                                      comment: "Title for reload vehicles button")
        button.backgroundColor = .white
        button.layer.cornerRadius = 5.0
        button.setTitle(title,
                        for: .normal)
        button.setTitleColor(.darkText,
                             for: .normal)
        button.isHidden = true
        button.addTarget(self,
                         action: #selector(userDidTapReloadButton),
                         for: .touchUpInside)
        view.addSubview(button)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            button.widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor)])
        reloadButton = button
    }
    
    //MARK: User's actions
    
    @objc
    private func userDidTapReloadButton() {
        interactor.userDidTapReloadButton()
    }
}

//MARK: - ScootersMapViewControllerInput

extension ScootersMapViewController: ScootersMapViewControllerInput {
    func show(vehicles: [VehicleViewModel]) {
        self.vehicles = vehicles
        mapView.removeAnnotations(mapView.annotations)
        let annotations = vehicles.map { vehicle -> VehicleAnnotation in
            let annotation = VehicleAnnotation(id: vehicle.id)
            annotation.coordinate = vehicle.location
            return annotation
        }
        mapView.addAnnotations(annotations)
    }
    
    func highlightMapItem(with itemId: String) {
        let annotation = mapView.annotations.first { ($0 as? VehicleAnnotation)?.id == itemId }
        guard let annotation = annotation else { return }
        
        let itemPoint = MKMapPoint(annotation.coordinate)
        let userPoint = MKMapPoint(mapView.userLocation.coordinate)
        let mapRect = MKMapRect(x: fmin(itemPoint.x, userPoint.x),
                                y: fmin(itemPoint.y, userPoint.y),
                                width: fabs(itemPoint.x - userPoint.x),
                                height: fabs(itemPoint.y - userPoint.y))
        let edgePadding = UIEdgeInsets(top: 30,
                                       left: 30,
                                       bottom: UIScreen.main.bounds.size.height / 2,
                                       right: 30)
        mapView.setVisibleMapRect(mapRect,
                                  edgePadding: edgePadding,
                                  animated: true)
    }
    
    func setReloadButtonHidden(hidden: Bool) {
        reloadButton.isHidden = hidden
    }
}

//MARK: - MKMapViewDelegate

extension ScootersMapViewController: MKMapViewDelegate {    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        interactor.userLocationUpdated()
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? VehicleAnnotation else { return nil }
        let vehicle = vehicles.first { $0.id == annotation.id }
        guard let vehicle = vehicle else { return nil }
        
        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: ScootersMapViewController.Constants.vehicleAnnotationReusableIdentifier)
            ?? MKAnnotationView(annotation: annotation,
                                reuseIdentifier: ScootersMapViewController.Constants.vehicleAnnotationReusableIdentifier)
        annotationView.image = vehicle.type.annotationPinImage
        annotationView.canShowCallout = false
        annotationView.clusteringIdentifier = ScootersMapViewController.Constants.annotationClusteringIdentifier
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, clusterAnnotationForMemberAnnotations memberAnnotations: [MKAnnotation]) -> MKClusterAnnotation {
        let annotation = MKClusterAnnotation(memberAnnotations: memberAnnotations)
        return annotation
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let vehicleAnnotation = view.annotation as? VehicleAnnotation else { return }
        interactor.userDidSelectItem(with: vehicleAnnotation.id)
    }
}

//MARK: - VehicleType extension

fileprivate extension VehicleAttributes.VehicleType {
    var annotationPinImage: UIImage? {
        switch self {
        case .eBicycle:
            return UIImage(named: "bike")
        case .eScooter:
            return UIImage(named: "scooter")
        case .eMoped:
            return UIImage(named: "moped")
        }
    }
}
