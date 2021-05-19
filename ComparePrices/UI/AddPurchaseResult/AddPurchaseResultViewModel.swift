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
    
    @Published var priceString: String = ""
    @Published private var price: Int?

    @Published var selectedCommodity: Commodity?

    @Published var selectedShop: Shop?

    @Published var sheet = SelectSheet()
    
    struct SelectSheet {
        var isShown = false
        private(set) var targetItem = TargetItem.commodity
    }
    
    enum TargetItem {
        case commodity
        case shop
    }
    
    func showSelectCommoditySheet() {
        sheet = SelectSheet(isShown: true, targetItem: .commodity)
    }

    func showSelectShopSheet() {
        sheet = SelectSheet(isShown: true, targetItem: .shop)
    }

    private(set) var finishedAddShopPrice = PassthroughSubject<Void, Never>()
    
    private var cancellables: [AnyCancellable] = []
    
    func addPurchaseResult() {
        isUpdatingPurchaseResult = false
        
        guard let selectedCommodity = selectedCommodity, let selectedShop = selectedShop, let price = self.price else { return }
        
        commodityPriceRepository.addCommodityPrice(CommodityPrice(commodityId: selectedCommodity.id, shopId: selectedShop.id, price: price))
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
    }

    init() {
        $priceString.map { Int($0) }.assign(to: \.price, on: self).store(in: &cancellables)
        
        // Validation
        Publishers.CombineLatest4($selectedCommodity, $selectedShop, $price, $isUpdatingPurchaseResult)
            .receive(on: RunLoop.main)
            .map { commodity, selectedShop, price, isUpdatingPurchaseResult in
                commodity != nil && price != nil && selectedShop != nil && !isUpdatingPurchaseResult
            }.print(isButtonEnabled.description).assign(to: \.isButtonEnabled, on: self).store(in: &cancellables)
    }
}
