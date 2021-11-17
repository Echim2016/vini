//
//  JGProgressHUDWrapper.swift
//  vini
//
//  Created by Yi-Chin Hsu on 2021/11/13.
//

import Foundation
import JGProgressHUD

enum HUDType {

    case success(String)

    case failure(String)
}

class VProgressHUD {

    static let shared = VProgressHUD()

    private init() { }

    let hud = JGProgressHUD(style: .dark)

    static func show(type: HUDType) {

        switch type {

        case .success(let text):

            showSuccess(text: text)

        case .failure(let text):

            showFailure(text: text)
        }
    }

    static func showSuccess(text: String = "成功！") {

        if !Thread.isMainThread {

            DispatchQueue.main.async {
                showSuccess(text: text)
            }

            return
        }

        shared.hud.textLabel.text = text

        shared.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
        
        let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate

        shared.hud.show(in: sceneDelegate?.window ?? UIView())

        shared.hud.dismiss(afterDelay: 1.0)
    }

    static func showFailure(text: String = "哎呀！出現了一點錯誤") {

        if !Thread.isMainThread {

            DispatchQueue.main.async {
                showFailure(text: text)
            }

            return
        }

        shared.hud.textLabel.text = text

        shared.hud.indicatorView = JGProgressHUDErrorIndicatorView()

        let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate

        shared.hud.show(in: sceneDelegate?.window ?? UIView())

        shared.hud.dismiss(afterDelay: 1.5)
    }

    static func show() {

        if !Thread.isMainThread {

            DispatchQueue.main.async {
                show()
            }

            return
        }

        shared.hud.indicatorView = JGProgressHUDIndeterminateIndicatorView()

        shared.hud.textLabel.text = "Loading..."

        let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate

        shared.hud.show(in: sceneDelegate?.window ?? UIView())
    }

    static func dismiss() {

        if !Thread.isMainThread {

            DispatchQueue.main.async {
                dismiss()
            }

            return
        }

        shared.hud.dismiss()
    }
}
