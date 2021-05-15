//  AddShopPriceViewModel.swift
//  ComparePrices
//
//  Created by ororo on 2021/04/25.
//

import Combine
import Foundation

final class AddShopPriceViewModel: ObservableObject, Identifiable {
    @Injected var commodityPriceRepository: CommodityPriceRepository
    @Injected var commodityRepository: CommodityRepository
    
    @Published private(set) var isButtonEnabled: Bool = false
    
    @Published var price: Int? = 0
    
    @Published var selectedShop: Shop?
    
    @Published var showStoreSheet = false
    
    @Published var showList = false

    private(set) var finishedAddShopPrice = PassthroughSubject<Void, Never>()
    
    private var cancellables: [AnyCancellable] = []
    
    func addShopPrice(commodity: Commodity) {
        isButtonEnabled = false
        
        commodityRepository.getCommodity(id: commodity.id)
            .map { [weak self] optionalCommodity -> Future<Void, Error> in
                if let commodityRepository = self?.commodityRepository, optionalCommodity == nil {
                    return commodityRepository.addCommodity(commodity)
                }
                return Future<Void, Error> { promise in promise(.success(())) }
            }.flatMap { [weak self] _ -> Future<Void, Error> in
                if let commodityPriceRepository = self?.commodityPriceRepository, let selectedShop = self?.selectedShop, let price = self?.price {
                    return commodityPriceRepository.addCommodityPrice(CommodityPrice(commodityId: commodity.id, shopId: selectedShop.id, price: price))
                }
                return Future<Void, Error> { promise in promise(.success(())) }
            }.sink(receiveCompletion: { result in
                switch result {
                case let .failure(error):
                    print(error)
                case .finished:
                    self.finishedAddShopPrice.send(())
                }
                self.isButtonEnabled = true
            }, receiveValue: {})
            .store(in: &cancellables)
    }

    init() {
        // Validation
        Publishers.CombineLatest($selectedShop, $price)
            .receive(on: RunLoop.main)
            .map { selectedShop, price in
                price != nil && price! > 0 && selectedShop != nil
            }.print(isButtonEnabled.description).assign(to: \.isButtonEnabled, on: self).store(in: &cancellables)
    }
}
