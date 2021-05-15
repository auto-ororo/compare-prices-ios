//
//  AddCommodityViewModel.swift
//  ComparePrices
//
//  Created by Ryo Narisawa on 2021/02/28.
//

import Combine
import Foundation

final class AddCommodityViewModel: ObservableObject, Identifiable {
    @Injected var commodityRepository: CommodityRepository
    
    @Published private(set) var isButtonEnabled: Bool = false
    @Published private(set) var selectedCommodity: Commodity?

    @Published var commodityName: String = ""

    private var cancellables: [AnyCancellable] = []
    
    func selectCommodity() {
        isButtonEnabled = false
        
        commodityRepository.getCommodity(name: commodityName)
            .sink(receiveCompletion: { [weak self] result in
                      switch result {
                      case let .failure(error):
                          print(error)
                      case .finished:
                          break
                      }
                      self?.isButtonEnabled = true
                  },
                  receiveValue: { [weak self] commodity in
                      if let commodityName = self?.commodityName {
                          self?.selectedCommodity = commodity ?? Commodity(id: UUID(), name: commodityName)
                      }
                  })
            .store(in: &cancellables)
    }
    
    init() {
        // Validation
        $commodityName
            .receive(on: RunLoop.main)
            .map { commodityName in
                !commodityName.isEmpty
            }
            .assign(to: \.isButtonEnabled, on: self)
            .store(in: &cancellables)
    }
}
