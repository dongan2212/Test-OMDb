//
//  ServiceFacade.swift
//  Test-SmartDev-ODMB
//
//  Created by Vo The Dong An on 17/03/2023.
//

import Swinject
import UIKit

class ServiceFacade {
    static let applicationService: ApplicationConfigurable = ApplicationServiceConfiguration()
    static let loadingServiceable: LoadingServiceable = LoadingServiceableImplement()
    
    static func registerDefaultService(with application: UIApplication, and window: UIWindow?) {
        ServiceFacade.initializeService()
        applicationService.applicationRoute(from: window.unwrapped(or: UIWindow()))
    }
    
    static func getService<T>(_ type: T.Type) -> T? {
        return Container.default.resolve(type)
    }
    
    private static func initializeService() {
        Container.default.register(LoadingServiceable.self) { (_) -> LoadingServiceable in
            return ServiceFacade.loadingServiceable
        }
    }
}
