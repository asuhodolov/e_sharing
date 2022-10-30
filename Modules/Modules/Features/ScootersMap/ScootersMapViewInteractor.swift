//
//  ScootersMapViewInteractor.swift
//  
//
//  Created by Aliaksandr Sukhadolau on 25.10.22.
//

import Foundation
import MapKit
import Services

protocol ScootersMapViewInteractorInput {
    func viewDidLoad()
    func userDidSelectItem(with itemId: MapItemId)
    func userLocationUpdated()
    func userDidTapReloadButton()
}

final class ScootersMapViewInteractor {
    private let presenter: ScootersMapViewPresenterInput
    var presentedDetails: UIViewController?
    var presentModalView: PresentModalView?
    var dismissModalView: DismissModalView?
    
    private var visibleMapRegion: MKCoordinateRegion?
    private let vehiclesProvider: VehiclesProviderProtocol
    private let locationManager = CLLocationManager()
    private var mapItems = [MapItem]()
    private var userLocationObtained = false
    private var mapItemsObtained = false
    private var nearestMapItemHighlighted = false
    
    init(visibleMapRegion: MKCoordinateRegion? = nil,
         vehiclesProvider: VehiclesProviderProtocol,
         presenter: ScootersMapViewPresenterInput) {
        self.visibleMapRegion = visibleMapRegion
        self.vehiclesProvider = vehiclesProvider
        self.presenter = presenter
    }
    
    fileprivate func loadMapItems() {
        Task {
            let loadedItems: [MapItem]
            do {
                loadedItems = try await vehiclesProvider.retrieveMapItems()
            } catch (let error) {
                print("Can not load vehicles: \(error)")
                loadedItems = []
                await MainActor.run {
                    presenter.setReloadButtonHidden(hidden: false)
                }
            }
            
            await MainActor.run { [weak self, loadedItems] in
                guard let self = self else { return }
                self.mapItems = loadedItems
                self.presenter.showVehicles(from: loadedItems)
                self.mapItemsObtained = true
                self.highlightNearestMapItem()
            }
        }
    }
    
    fileprivate func requestLocationPermissions() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    private func highlightNearestMapItem() {
        guard userLocationObtained,
              mapItemsObtained,
              !nearestMapItemHighlighted,
              let currentLocation = locationManager.location
        else { return }
        
        nearestMapItemHighlighted = true
        let itemsWithDistances = self.mapItems.compactMap { mapItem -> (MapItem, Double)? in
            guard case let .vehicle(attributes) = mapItem.type else { return nil }
            let vehicleLocation = CLLocation(latitude: attributes.latitude,
                                             longitude: attributes.longitude)
            return (mapItem, currentLocation.distance(from: vehicleLocation))
        }
        let nearestItem = itemsWithDistances.min { $0.1 < $1.1 }
        guard let nearestItem = nearestItem else { return }
        
        presenter.highlight(mapItem: nearestItem.0)
        displayItemDetails(with: nearestItem.0.id)
    }
    
    //This presentation logic should be moved to a separate Router class
    //It is simplified just in case it is a short test project
    private func displayItemDetails(with itemId: MapItemId) {
        let mapItem = mapItems.first { $0.id == itemId }
        guard let mapItem = mapItem,
              case let .vehicle(attributes) = mapItem.type
        else { return }
        
        let vehicleDetails = VehicleDetails(id: mapItem.id,
                                            vehicleAttributes: attributes)
        let viewController = VehicleDetailsSheetAssemly.assemble(with: vehicleDetails)
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.modalPresentationStyle = .pageSheet
        let sheetController = navigationController.sheetPresentationController
        sheetController?.detents = [.medium(), .large()]
        sheetController?.selectedDetentIdentifier = .medium
        sheetController?.largestUndimmedDetentIdentifier = .medium
        sheetController?.prefersGrabberVisible = true
        
        let animated: Bool
        if let _ = presentedDetails {
            dismissModalView?(false)
            animated = false
        } else {
            animated = true
        }
        
        presentedDetails = navigationController
        presentModalView?(navigationController, animated)
    }
}

//MARK: - ScootersMapViewInteractorInput

extension ScootersMapViewInteractor: ScootersMapViewInteractorInput {
    func userLocationUpdated() {
        userLocationObtained = true
        highlightNearestMapItem()
    }
    
    func userDidTapReloadButton() {
        loadMapItems()
        presenter.setReloadButtonHidden(hidden: true)
    }
    
    func viewDidLoad() {
        requestLocationPermissions()
        loadMapItems()
    }
    
    func userDidSelectItem(with itemId: MapItemId) {
        displayItemDetails(with: itemId)
    }
}
