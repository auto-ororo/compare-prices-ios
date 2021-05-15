//
//  AddPurchaseResultViewModel.swift
//  ComparePrices
//
//  Created by ororo on 2021/05/15.
//

import Combine
import Foundation

final class AddPurchaseResultViewModel: ObservableObject, Identifiable {
    @Injected var commodityPriceRepository: CommodityPriceRepository
    @Injected var commodityRepository: CommodityRepository
    @Injected var shopRepository: ShopRepository
    
    @Published private(set) var isButtonEnabled: Bool = false
    @Published private(set) var isUpdatingPurchaseResult: Bool = false
    
    @Published var price: Int? = 0
    
    @Published var selectedCommodity: Commodity?
    var isNewCommodity = false
    
    @Published var selectedShop: Shop?
    var isNewShop = false
    
    @Published var showShopSheet = false
    @Published var showCommoditySheet = false

    private(set) var finishedAddShopPrice = PassthroughSubject<Void, Never>()
    
    private var cancellables: [AnyCancellable] = []
    
    func addPurchaseResult() {
        isUpdatingPurchaseResult = false
        
        guard let selectedCommodity = selectedCommodity, let selectedShop = selectedShop, let price = self.price else { return }
        
        let addCommodityPublisher = commodityRepository.addCommodity(selectedCommodity)
        let addShopPublisher = shopRepository.addShop(selectedShop)
        let addCommodityPricePublisher = commodityPriceRepository.addCommodityPrice(CommodityPrice(commodityId: selectedCommodity.id, shopId: selectedShop.id, price: price))
        
        Publishers.Zip3(
            isNewCommodity ? addCommodityPublisher : .init { promise in promise(.success(())) },
            isNewShop ? addShopPublisher : .init { promise in promise(.success(())) },
            addCommodityPricePublisher
        )
        .sink(receiveCompletion: { [weak self] result in
            switch result {
            case let .failure(error):
                print(error)
            case .finished:
                self?.finishedAddShopPrice.send(())
            }
            self?.isUpdatingPurchaseResult = true
        }, receiveValue: { _ in }).store(in: &cancellables)
    }
    
    func setSelectedCommodityIfParamExists(commodity: Commodity?) {
        guard let commodity = commodity else { return }
        selectedCommodity = commodity
        isNewCommodity = false
    }

    init() {
        // Validation
        Publishers.CombineLatest4($selectedCommodity, $selectedShop, $price, $isUpdatingPurchaseResult)
            .receive(on: RunLoop.main)
            .map { commodity, selectedShop, price, isUpdatingPurchaseResult in
                commodity != nil && price != nil && price! > 0 && selectedShop != nil && !isUpdatingPurchaseResult
            }.print(isButtonEnabled.description).assign(to: \.isButtonEnabled, on: self).store(in: &cancellables)
    }
}
