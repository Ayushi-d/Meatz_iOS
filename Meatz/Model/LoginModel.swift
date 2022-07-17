//
//  LoginModel.swift
//  Meatz
//
//  Created by Mohamed Zead on 4/7/21.
//

import Foundation

// MARK: - LoginResponse

struct LoginResponse: Codable {
    let status, message: String?
    let data: LoginData?
}

// MARK: - DataClass

struct LoginData: Codable {
    let id: Int?
    let firstName, lastName: String?
    let username: String?
    let mobile, email, accessToken: String?
    let wallet: String?

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case username, mobile, email
        case accessToken = "access_token"
        case wallet
    }
}

struct AuthModel {
    let status: Bool
    let message: String
    let user: User
    init(_ res: LoginResponse?) {
        status = (res?.status ?? "") == "success"
        message = res?.message ?? ""
        user = User(res?.data)
    }
}

struct User: Codable {
    let id: Int
    let firstName, lastName: String
    let username: String
    let mobile, email, accessToken: String
    let wallet: String

    init(_ loginData: LoginData?) {
        id = loginData?.id ?? 0
        firstName = loginData?.firstName ?? ""
        lastName = loginData?.lastName ?? ""
        username = loginData?.username ?? ""
        mobile = loginData?.mobile ?? ""
        email = loginData?.email ?? ""
        accessToken = loginData?.accessToken ?? ""
        wallet = loginData?.wallet ?? ""
    }
}
