//
//  AddShopPriceViewModel.swift
//  ComparePrices
//
//  Created by ororo on 2021/04/25.
//

import Foundation
import Combine

final class AddShopPriceViewModel : ObservableObject, Identifiable {
    
    @Injected var commodityPriceRepository: CommodityPriceRepository
    
    @Published private (set) var isButtonEnabled : Bool = false
    
    @Published var price : Int? = 0
    
    @Published var selectedShop : Shop? = nil
    
    @Published var showStoreSheet = false
    
    @Published var showList = false

    private (set) var finishedAddShopPrice = PassthroughSubject<Void, Never>()
    
    private var cancellables: [AnyCancellable] = []
    
    func addShopPrice(commodityId: UUID) {
        isButtonEnabled = false
        
            commodityPriceRepository.addCommodityPrice(CommodityPrice(commodityId: commodityId, shopId: selectedShop!.id, price: price!))
                .sink(receiveCompletion: { result in
            switch result {
            case .failure(let error):
                print(error)
            case .finished:
                self.finishedAddShopPrice.send(())
            }
            self.isButtonEnabled = true
        }){ _ in }
        .store(in: &cancellables)
    }
    
    init() {
        // Validation
        Publishers.CombineLatest($selectedShop, $price)
            .receive(on: RunLoop.main)
            .map{ (selectedShop, price) in
                return price != nil && price! > 0 && selectedShop != nil
            }.print(self.isButtonEnabled.description).assign(to: \.isButtonEnabled, on: self).store(in: &cancellables)
    }
}
