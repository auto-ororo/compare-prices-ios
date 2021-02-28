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

    @Published private (set) var isButtonEnabled : Bool = false
    
    @Published var commodityName : String = ""
    @Published var price : Int? = 0
    @Published var storeName : String = ""
    
    private (set) var finishedAddCommodity = PassthroughSubject<Void, Never>()

    private var cancellables: [AnyCancellable] = []

    func addCommotity() {
        guard let price = price else { return }
        isButtonEnabled = false
        commodityRepository.addCommodity(Commodity(name: commodityName, price: price, store: storeName))
            .sink(receiveCompletion: { result in
                switch result {
                case .failure(let error):
                    print(error)
                case .finished:
                    self.finishedAddCommodity.send(())
                }
                self.isButtonEnabled = true
            }){}.store(in: &cancellables)
    }

    init() {
        // Validation
        Publishers.CombineLatest3($commodityName, $storeName, $price)
            .receive(on: RunLoop.main)
            .map{ (commodityName, storeName, price) in
                return !commodityName.isEmpty && !storeName.isEmpty && price != nil && price! > 0
            }.print(self.isButtonEnabled.description).assign(to: \.isButtonEnabled, on: self).store(in: &cancellables)
    }

}
