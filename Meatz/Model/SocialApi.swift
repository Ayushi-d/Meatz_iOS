//
//  SocialApi.swift
//  electra
//
//  Created by Khaled kamal on 4/23/20.
//  Copyright © 2020 Khaled kamal. All rights reserved.
//

import CoreLocation
import UIKit

enum SocialApi {
    case link(String)
    case Twitter(String)
    case Facebook(String)
    case Telegram(String)
    case Youtube(String)
    case Clubhouse(String)
    case Call(String)
    case WhatsApp(String)
    case SnapChat(String)
    case Instgram(String)
    case Mail(String)
    case Map
    case AppStore(String)

    fileprivate var url: URL? {
        switch self {
        case let .Twitter(value),let .Youtube(value), let .Clubhouse(value),let .Telegram(value), let .Facebook(value), let .SnapChat(value), let .Instgram(value), let .AppStore(value), let .link(value):
            return value.asUrl
        case let .Call(value): return value.callUrl
        case let .Mail(value): return value.mailUrl
        case let .WhatsApp(value): return value.whatsUrl
        default: return nil
        }
    }

    func openUrl() {
        guard let urlPath = url else {
            return
        }
        if UIApplication.shared.canOpenURL(urlPath) {
            print(urlPath)
            UIApplication.shared.open(urlPath, options: [:], completionHandler: nil)
        }
    }
}

extension String {
    var asUrl: URL? {
        return URL(string: self)
    }

    var callUrl: URL? {
        return URL(string: "tel://\(self)")
    }

    var mailUrl: URL? {
        return URL(string: "mailto:\(self)")
    }

    var whatsUrl: URL? {
        return URL(string: "https://wa.me/\(self)")
    }
}
