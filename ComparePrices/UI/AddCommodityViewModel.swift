//
//  AddCommodityViewModel.swift
//  ComparePrices
//
//  Created by Ryo Narisawa on 2021/02/28.
//

import Foundation
import Combine

final class AddCommodityViewModel : ObservableObject, Identifiable {
    
    @Injected var commodityRepository: CommodityRepository
    @Injected var commodityPriceRepository: CommodityPriceRepository
    
    @Published private (set) var isButtonEnabled : Bool = false
    
    @Published var commodityName : String = ""
    @Published var price : Int? = 0
    
    @Published var selectedShop : Shop? = nil
    
    @Published var showStoreSheet = false
    
    private (set) var finishedAddCommodity = PassthroughSubject<Void, Never>()
    
    private var cancellables: [AnyCancellable] = []
    
    func addCommotity() {
        isButtonEnabled = false
        
        let uuid = UUID()
        
        Publishers.Zip(
            commodityPriceRepository.addCommodityPrice(CommodityPrice(commodityId: uuid, shopId: selectedShop!.id, price: price!)),
            commodityRepository.addCommodity(Commodity(id: uuid, name: commodityName))
        ).sink(receiveCompletion: { result in
            switch result {
            case .failure(let error):
                print(error)
            case .finished:
                print("zip finished")
                self.finishedAddCommodity.send(())
            }
            self.isButtonEnabled = true
        }){ _ in }
        .store(in: &cancellables)
    }
    
    init() {
        // Validation
        Publishers.CombineLatest3($commodityName, $selectedShop, $price)
            .receive(on: RunLoop.main)
            .map{ (commodityName, selectedShop, price) in
                return !commodityName.isEmpty &&  price != nil && price! > 0 && selectedShop != nil
            }.print(self.isButtonEnabled.description).assign(to: \.isButtonEnabled, on: self).store(in: &cancellables)
    }
}
