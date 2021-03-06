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
    @Injected private var purchaseResultRepository: PurchaseResultRepository
    @Injected private var shopRepository: ShopRepository
    
    private var cancellables: [AnyCancellable] = []
    
    @Published private(set) var shopPriceList: [ShopPriceListRow] = []
    
    func observeShopPrices(commodityId: UUID) {
        purchaseResultRepository.observePurchaseResults(commodityId)
            .compactMap { $0 }
            .map { $0.sorted(by: { lhs, rhs -> Bool in
                lhs.price < rhs.price
            }) }
            .sink(receiveCompletion: { result in
                switch result {
                case let .failure(error):
                    print(error)
                default:
                    break
                }
            }, receiveValue: { [weak self] purchaseResults in
                self?.convertToShopPricesFromPurchaseResults(purchaseResults: purchaseResults)
            }).store(in: &cancellables)
    }
    
    private func convertToShopPricesFromPurchaseResults(purchaseResults: [PurchaseResult]) {
        var list: [ShopPriceListRow] = []
        var rank = 1
        
        purchaseResults.publisher
            .compactMap { [weak self] commodityPrice in
                self?.shopRepository.getShop(commodityPrice.shopId).flatMap { shop in
                    Just(ShopPriceListRow(purchaseResultId: commodityPrice.id, rank: rank, shop: shop, price: commodityPrice.price, purchaseDate: commodityPrice.purchaseDate))
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
    
    func deletePurchaseResult(shopPriceListRow: ShopPriceListRow) {
        purchaseResultRepository.getPurchaseResult(shopPriceListRow.purchaseResultId)
            .compactMap { [weak self] purchaseResult in
                self?.purchaseResultRepository.deletePurchaseResult(purchaseResult).eraseToAnyPublisher()
            }
            .flatMap { $0 }
            .sink(receiveCompletion: { result in
                switch result {
                case .finished:
                    break
                case let .failure(error):
                    print(error)
                }
            }, receiveValue: { _ in }).store(in: &cancellables)
    }
    
    init() {}
}
