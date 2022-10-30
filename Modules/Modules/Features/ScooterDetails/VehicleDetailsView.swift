//
//  VehicleDetailsView.swift
//  
//
//  Created by Aliaksandr Sukhadolau on 28.10.22.
//

import Foundation
import UIKit
import Services

final class VehicleDetailsView: UIViewController {
    private let vehicleDetails: VehicleDetails
    
    private lazy var stackView: UIStackView = { [weak self] in
        guard let self = self else { return UIStackView() }
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.alignment = .leading
        stack.isLayoutMarginsRelativeArrangement = true
        stack.spacing = UIStackView.spacingUseSystem
        stack.layoutMargins = UIEdgeInsets(top: 5.0,
                                           left: 8.0,
                                           bottom: 5.0,
                                           right: 5.0)
        return stack
    }()
    
    required init(vehicleDetails: VehicleDetails) {
        self.vehicleDetails = vehicleDetails
        super.init(nibName: nil,
                   bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareUI()
    }
    
    //MARK: - UI configuration
    
    private func prepareUI() {
        self.title = vehicleDetails.type.title
        prepareDetailsStack()
        view.backgroundColor = .white
    }
    
    private func prepareDetailsStack() {
        var frame = view.bounds
        frame.size.height = 200
        stackView.frame = frame
        stackView.addArrangedSubview(makeBatteryLevel())
        stackView.addArrangedSubview(makeMaxSpeedLabel())
        stackView.addArrangedSubview(makeHelmetBoxLabel())
        stackView.autoresizingMask = [.flexibleBottomMargin, .flexibleWidth]
        view.addSubview(stackView)
    }
    
    private func makeDetailsLabel() -> UILabel {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16.0)
        label.numberOfLines = 0
        label.contentMode = .left
        label.textColor = .label
        return label
    }
    
    private func makeBatteryLevel() -> UILabel {
        let label = makeDetailsLabel()
        let levelText = NSLocalizedString("VehicleDetails_label_battery",
                                          value:"Battery Level",
                                          comment: "Title for battery level details cell")
        label.text = levelText + ": " + String(vehicleDetails.batteryLevel)
        return label
    }
    
    private func makeMaxSpeedLabel() -> UILabel {
        let label = makeDetailsLabel()
        let speedText = NSLocalizedString("VehicleDetails_label_speed",
                                          value:"Max Speed",
                                          comment: "Title for max speed details cell")
        label.text = speedText + ": " + String(vehicleDetails.maxSpeed)
        return label
    }
    
    private func makeHelmetBoxLabel() -> UILabel {
        let label = makeDetailsLabel()
        let speedText = NSLocalizedString("VehicleDetails_label_helmetBox",
                                          value:"Has Helmet Box",
                                          comment: "Title for helmet box details cell")
        label.text = speedText + ": " + String(vehicleDetails.hasHelmetBox)
        return label
    }
}

fileprivate extension VehicleAttributes.VehicleType {
    var title: String {
        switch self {
        case .eScooter:
            return NSLocalizedString("VehicleType_escooter",
                                     value:"Electric Scooter",
                                     comment: "Title for eScooter vehicle type")
        case .eMoped:
            return NSLocalizedString("VehicleType_emoped",
                                     value:"Electric Moped",
                                     comment: "Title for eMoped vehicle type")
        case .eBicycle:
            return NSLocalizedString("VehicleType_bicycle",
                                     value:"Electric Bicycle",
                                     comment: "Title for eBicycle vehicle type")
        }
    }
}
