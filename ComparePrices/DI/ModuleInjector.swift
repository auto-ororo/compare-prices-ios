//
//  ModuleInjector.swift
//  ComparePrices
//
//  Created by Ryo Narisawa on 2021/04/18.
//

import Foundation

protocol ModuleInjector {
    func inject()
}

final class MockModuleInjector: ModuleInjector {
    func inject() {
        DIContainer.shared.register(type: CommodityRepository.self, component: MockCommodityRepository())
        DIContainer.shared.register(type: CommodityPriceRepository.self, component: MockCommodityPriceRepository())
        DIContainer.shared.register(type: ShopRepository.self, component: MockShopRepository())
        DIContainer.shared.register(type: AuthRepository.self, component: MockAuthRepository())
    }
}

final class DefaultModuleInjector: ModuleInjector {
    func inject() {
        DIContainer.shared.register(type: CommodityRepository.self, component: MockCommodityRepository())
        DIContainer.shared.register(type: CommodityPriceRepository.self, component: MockCommodityPriceRepository())
        DIContainer.shared.register(type: ShopRepository.self, component: MockShopRepository())
        DIContainer.shared.register(type: AuthRepository.self, component: FirebaseAuthRepository())
    }
}

enum InjectType {
    case mock
    case `default`
}
