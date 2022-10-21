//
//  AppRouter.swift
//  
//
//  Created by Aliaksandr Sukhadolau on 11.10.22.
//

import Foundation
import UIKit

public final class ApplicationRouter: NSObject {
    let window: UIWindow
//    let services = Services()
    
    public required init(window: UIWindow) {
        self.window = window
    }
    
    public func presentRootController() {
        window.rootViewController = makeScootersMapStory()
        window.makeKeyAndVisible()
    }
    
    //MARK: JobsList Scene
    
    private func makeScootersMapStory() -> UIViewController {
        let mapController = UIViewController()
        mapController.view.backgroundColor = .yellow
        let navigationController = UINavigationController(rootViewController: mapController)
        return navigationController
    }
}
