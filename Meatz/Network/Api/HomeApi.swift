//
//  HomeApi.swift
//  Asnan Tower
//
//  Created by Mohamed Zead on 1/25/21.
//  Copyright © 2021 Spark Cloud. All rights reserved.
//
//  com.app.meatz1234
//  kw.com.app.meatz

//test@android.com
//Android@10

import Alamofire
import Foundation

enum HomeApi: BaseRequstBuilder {
    case ads
    case home
    case shops(Int) /// category ID
    case shopDetails(Int, Parameters)
    case featured
    case ourBoxes
    case box(Int)
    case product(Int)
    case search(Parameters)
    case profile
    case editProfile(Parameters)
    case changePass(Parameters)
    case whishList(Int) // page number
    case productLike(Int)/// productID
    case addresses
    case deleteAddress(Int)
    case addAddress(Parameters)
    case updateAddress(Int,Parameters)
    case areas
    case orders
    case orderDetails(Int)
    // Boxes
    case myBoxes
    case deleteBox(Int)
    case addBoxToCart(Int)
    case addBox(Parameters)
    case boxProducts(Int)
    case deleteProductFromBox(Int, Parameters)
    case contacts
    case clearBox(Int)
    case offers(Parameters)
    case offerDetails(Int)
    //Settings
    case settings
    case page(Int)
    case contactUs(Parameters)
   // Cart
    case addToCart(Parameters)
    case notifications
    case addToBoxes(Parameters)
    case cart(Parameters?)
    case deleteCartItem(Parameters)
    case clearCart
    case coupon(Parameters)
    case checkout(Parameters)
    case chekcoutDetails
    case reorder(Int)
    case terms
    // wallet
    case myWallet
    case rechargeWallet(Parameters)
    case cancelOrder(orderId: Int)
    
    
    //lgout
    case logout
    
    // payment
    case parsePayment(String)
    
    var urlPath: String {
        switch self {
        case .home:
            return "home"
        case .shops(let id):
            return "stores?category_id=\(id)"
        case .shopDetails(let id, _):
            return "stores/\(id)"
        case .featured:
            return "featured_stores"
        case .ads:
            return "ads"
        case .ourBoxes:
            return "our_boxes"
        case .product(let id), .box(let id):
            return "product/\(id)"
        case .search:
            return "search"
        case .addToCart:
            return "add_to_cart"
        case .profile:
            return "profile"
        case .editProfile:
            return "edit_profile"
        case .changePass:
            return "change_password"
        case .whishList(let page):
            return "likes?page=\(page)"
        case .productLike(let id):
            return "product/\(id)/like"
        case .addresses:
            return "addresses"
        case .deleteAddress(let id):
            return "addresses/\(id)"
        case .addAddress:
            return "addresses"
        case .areas:
            return "areas"
        case .myBoxes:
            return "boxes"
        case .deleteBox(let id):
            return "boxes/\(id)"
        case .addBoxToCart(let id):
            return "boxes/\(id)/add_to_cart"
        case .addBox:
            return "boxes"
        case .boxProducts(let id):
            return "boxes/\(id)"
        case .deleteProductFromBox(let id, _):
            return "boxes/\(id)/remove_item"
        case .updateAddress(let id, _):
            return "addresses/\(id)"
        case .orders:
            return "orders"
        case .orderDetails(let id):
            return "orders/\(id)"
        case .settings:
            return "pages"
        case .contacts:
            return "contacts"
        case .page(let id):
            return "pages/\(id)"
        case .contactUs:
            return "contactus"
        case .notifications:
            return "notifications"
        case .addToBoxes:
            return "add_item_to_boxes"
        case .cart:
            return "cart"
        case .deleteCartItem:
            return "remove_from_cart"
        case .clearBox(let id):
            return "boxes/\(id)/clear_items"
        case .clearCart:
            return "clear_cart"
        case .coupon:
            return "check_copon"
        case .checkout:
            return "new_order"
        case .reorder(let id):
            return "orders/\(id)/reorder"
        case .terms:
            return "terms"
            
        case .offers:
            return "special_boxes"
        case .offerDetails(let id):
            return "special_boxes/\(id)"
        case .myWallet:
            return "wallet_cards"
        case .rechargeWallet:
            return "wallet_charge"
        case .cancelOrder(let orderId):
            return "orders/\(orderId)/cancel_request"
        case .chekcoutDetails:
            return "new_order"
            
        case .logout:
            return "logout"
            
        case .parsePayment:
            return ""
        }
    }
    
    var mainPath: String {
        switch self {
        case .parsePayment(let link):
            return link
        default:
            //return "http://88.208.227.238/api/"
            //return "http://meatz.testingjunction.tech/api/"
            return "http://meatz-app.com/api/"
        }
        
    }
    
    var hettpMethod: HTTPMethod {
        switch self {
        case .addToCart,.editProfile,.changePass,.addAddress,.updateAddress, .addBox, .deleteProductFromBox,.coupon, .contactUs,.addToBoxes, .deleteCartItem,.checkout, .rechargeWallet:
          return .post
        case .deleteAddress, .deleteBox:
            return .delete
        default:
            return .get
        }
    }
    
    var paramter: [String: Any]? {
        switch self {
        case .shopDetails(_, let params):
            return params.body
        case .search(let params),.addToCart(let params),.editProfile(let params),.changePass(let params),
             .addAddress(let params), .addBox(let params), .deleteProductFromBox(_, let params), .contactUs(let params),.addToBoxes(let params), .deleteCartItem(let params),.coupon(let params),.checkout(let params), .cart(let params?):
            return params.body
        case .updateAddress(_, let params):
            var parameters = params.body
            parameters["_method"] = "put"
            return parameters
            
        case .offers(let parameters):
            return parameters.body
            
        case .rechargeWallet(let parameters):
            return parameters.body
        default:
            return nil
        }
    }
    
    var headers: HTTPHeaders {
        return SHeaders.shared.headers
    }
    
    var encoding: ParameterEncoding {
        switch self{
        case .addToCart:
            return JSONEncoding.default
        case .offers:
            return URLEncoding.queryString
        default:
            return URLEncoding.default
        }
    }
}


//Url :Optional(http://meatz.testingjunction.tech/api/signup) parm:Optional(["password": "12345678", "last_name": "Saleem", "email": "m@gmail.com", "first_name": "Mohd", "mobile": "00000000"])
