//
//  ContentViewModel.swift
//  ComparePrices
//
//  Created by Ryo Narisawa on 2021/03/06.
//

import Combine
import Foundation

final class ContentViewModel: ObservableObject {
    static let shared = ContentViewModel()
    
    @Published var alert = Alert()
    @Injected private var authRepository: AuthRepository
    
    private var cancellables: [AnyCancellable] = []

    private init() {}

    func showAlert(title: String, message: String, buttonTitle: String = "OK", onOkClick: @escaping () -> Void = {}) {
        alert = Alert(
            isShown: true,
            type: .info,
            title: title,
            message: message,
            positiveButtonTitle: buttonTitle,
            onOkClick: onOkClick
        )
    }
    
    func showConfirm(
        isDestructive: Bool = false,
        title: String,
        message: String,
        positiveButtonTitle: String = "OK",
        negativeButtonTitle: String = "Cancel",
        onOkClick: @escaping () -> Void = {},
        onCancelClick: @escaping () -> Void = {}
    ) {
        let alertType: AlertType
        if isDestructive { alertType = .destructiveConfirm } else { alertType = .confirm }
        alert = Alert(
            isShown: true,
            type: alertType,
            title: title,
            message: message,
            positiveButtonTitle: positiveButtonTitle,
            negativeButtonTitle: negativeButtonTitle,
            onOkClick: onOkClick,
            onCaccelClick: onCancelClick
        )
    }

    struct Alert {
        var isShown: Bool = false
        var type: AlertType = .info
        var title: String = ""
        var message: String = ""
        var positiveButtonTitle: String = "OK"
        var negativeButtonTitle: String = "キャンセル"
        var onOkClick: () -> Void = {}
        var onCaccelClick: () -> Void = {}
    }
    
    enum AlertType {
        case info
        case confirm
        case destructiveConfirm
    }
}
