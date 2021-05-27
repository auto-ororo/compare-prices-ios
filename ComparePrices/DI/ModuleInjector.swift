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
        DIContainer.shared.register(type: PurchaseResultRepository.self, component: MockPurchaseResultRepository())
        DIContainer.shared.register(type: ShopRepository.self, component: MockShopRepository())
        DIContainer.shared.register(type: AuthRepository.self, component: MockAuthRepository())
    }
}

final class DefaultModuleInjector: ModuleInjector {
    func inject() {
        DIContainer.shared.register(type: CommodityRepository.self, component: FirestoreCommodityRepository())
        DIContainer.shared.register(type: PurchaseResultRepository.self, component: FirestorePurchaseResultRepository())
        DIContainer.shared.register(type: ShopRepository.self, component: FirestoreShopRepository())
        DIContainer.shared.register(type: AuthRepository.self, component: FirebaseAuthRepository())
    }
}

enum InjectType {
    case mock
    case `default`
}
