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
    @Published private (set) var addedCommodity : Commodity?

    @Published var commodityName : String = ""

    private var cancellables: [AnyCancellable] = []
    
    func addCommotity() {
        isButtonEnabled = false
        
        let commodity = Commodity(id: UUID(), name: commodityName)
        
        commodityRepository.addCommodity(commodity)
            .sink(receiveCompletion: { [weak self] result in
                switch result {
                case .failure(let error):
                    print(error)
                case .finished:
                    self?.addedCommodity = commodity
                }
                self?.isButtonEnabled = true
            }){ _ in }
            .store(in: &cancellables)
    }
    
    init() {
        // Validation
        $commodityName
            .receive(on: RunLoop.main)
            .map{ commodityName in
                return !commodityName.isEmpty
            }
            .assign(to: \.isButtonEnabled, on: self)
            .store(in: &cancellables)
        
    }
}
