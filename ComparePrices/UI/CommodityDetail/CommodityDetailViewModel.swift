//
//  CommodityDetailViewModel.swift
//  ComparePrices
//
//  Created by ororo on 2021/04/24.
//

import Combine
import Foundation

final class CommodityDetailViewModel: ObservableObject, Identifiable {
    @Injected private var commodityRepository: CommodityRepository
    @Injected private var commodityPriceRepository: CommodityPriceRepository
    @Injected private var shopRepository: ShopRepository
    
    private var cancellables: [AnyCancellable] = []
    
    @Published private(set) var shopPriceList: [ShopPriceListRow] = []
    
    func getShopPrices(commodityId: UUID) {
        var list: [ShopPriceListRow] = []
        var rank = 1
        
        commodityPriceRepository.getCommodityPrices(commodityId)
            .compactMap { $0 }
            .map { $0.sorted(by: { lhs, rhs -> Bool in
                lhs.price < rhs.price
            }) }
            .flatMap(maxPublishers: .max(1)) { commodities in commodities.publisher }
            .compactMap { [weak self] commodityPrice in
                self?.shopRepository.getShop(commodityPrice.shopId).flatMap { shop in
                    Just(ShopPriceListRow(rank: rank, shop: shop, price: commodityPrice.price, purchaseDate: commodityPrice.purchaseDate))
                }
            }.flatMap { $0 }
            .handleEvents(receiveOutput: { _ in rank += 1 })
            .sink(receiveCompletion: { [weak self] result in
                switch result {
                case .finished:
                    self?.shopPriceList = list
                case let .failure(error):
                    print(error)
                }
            }, receiveValue: { shopPriceListRow in
                list.append(shopPriceListRow)
            }).store(in: &cancellables)
    }
    
    init() {}
}
