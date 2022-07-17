//
//  HomeModel.swift
//  Meatz
//
//  Created by Mohamed Zead on 3/30/21.
//

import Foundation

// MARK: - HomeResponse
struct HomeResponse: Codable {
    let status, message: String?
    let data: HomeData?
}

// MARK: - DataClass
struct HomeData: Codable {
    let categories: [Category]?
    let sliders: [Slider]?
    let featured: [Featured]?
    let boxes: [Box]?
}

// MARK: - Box
struct Box: Codable {
    let id: Int?
    let name, price: String?
    let priceBefore: String?
    let persons: Int?
    let image: String?
    let stocks: Int?

    enum CodingKeys: String, CodingKey {
        case id, name, price
        case priceBefore = "price_before"
        case persons, image, stocks
    }
}

// MARK: - Category
struct Category: Codable {
    let id: Int?
    let name: String?
    let image: String?
    let subcategories : [SubCategoryModel]?

}


struct CategoryModel: Equatable  {
    static func == (lhs: CategoryModel, rhs: CategoryModel) -> Bool {
        if lhs.id != rhs.id {
            return false
        }
        if let lhsBody = lhs.subcategories as? [SubCategoryModel], let rhsBody = rhs.subcategories as? [SubCategoryModel]{
            return true
        } else {
            return false
        }
    }
    
    let id: Int
    let name: String
    let image: String
    let subcategories : [SubCategoryModel]?
    var selected: Bool = false
    
    init(model: Category?) {
        id = model?.id ?? 0
        name = model?.name ?? ""
        image = model?.image ?? ""
        subcategories = model?.subcategories
    }
}

struct SubCategory: Codable{
    let id : Int?
    let subcategory_name : SubCategoryName?
    let image : String
}


struct SubCategoryModel : Codable{
    let id: Int
    let subcategory_name: SubCategoryName?
    let image: String
    
    init(model: SubCategory?) {
        id = model?.id ?? 0
        subcategory_name = model?.subcategory_name
        image = model?.image ?? ""
    }
}

struct SubCategoryName: Codable {
    let ar : String
    let en : String
    
    init(model: SubCategoryName?) {
        ar = model?.ar ?? ""
        en = model?.en ?? ""
    }
}








// MARK: - Featured
struct Featured: Codable {
    let id: Int?
    let name: String?
    let logo: String?
    let color: String?
}

// MARK: - Slider
struct Slider: Codable {
    let id, status, sort: Int?
    let title : String?
    let model: SliderType?
    let modelID: Int?
    let image: String?

    enum CodingKeys: String, CodingKey {
        case id, status, sort, title, model
        case modelID = "model_id"
        case image
    }
}
enum SliderType : String , Codable{
    case box
    case product
    case store
    case none
}


struct HomeModel{
    
    let categories: [CategoryModel]
    let sliders : [SliderModel]
    let featured: [FeaturedModel]
    let boxes: [BoxModel]
    
    init(_ res : HomeResponse?) {
        let data = res?.data
        sliders = (data?.sliders ?? []).map({return SliderModel($0)})
        featured = (data?.featured ?? []).map({return FeaturedModel($0)})
        boxes = (data?.boxes ?? []).map({return BoxModel($0)})
        categories = res?.data?.categories?.map({CategoryModel(model: $0)}) ?? []
    }
}

struct SliderModel{
    let id, status, sort: Int
    let title : String
    let type: SliderType
    let modelID: Int
    let image: String

    init(_ slider : Slider?) {
        id =  slider?.id ?? 0
        status = slider?.status ?? 0
        sort = slider?.sort ?? 0
        title = slider?.title ?? ""
        type = slider?.model ?? .product
        modelID = slider?.modelID ?? 0
        image = slider?.image ?? ""
    }
    
}

struct FeaturedModel : Listable{
    let id: Int
    let name: String
    let logo: String
    let color: String
    
    init(_ feat : Featured?) {
        id = feat?.id ?? 0
        name = feat?.name ?? ""
        logo = feat?.logo ?? ""
        color = feat?.color ?? ""
    }
    
    var itemName: String{
        return name
    }
    
    var imageLink: String{
        return logo
    }
    
    
}


struct BoxModel : OurBoxViewModel{
    let id: Int
    let name, price: String
    let priceBefore: String
    let persons: Int
    let image: String
    init(_ box : Box?) {
        id = box?.id ?? 0
        name = box?.name ?? ""
        price = box?.price ?? ""
        priceBefore = box?.priceBefore ?? ""
        persons = box?.persons ?? 0
        image = box?.image ?? ""
    }
    
    var boxName: String{
        return name
    }
    
    var cost: String{
        return price + " " + R.string.localizable.kwd()
    }
    
    var costBefore: String{
        return priceBefore
    }
    var logoImage: String{
        return image
    }
    
    var personsCount: String{
        return persons.toString + " " + R.string.localizable.persons()
    }
    
}


protocol OurBoxViewModel{
    var boxName : String{get}
    var cost : String{get}
    var costBefore: String{get}
    var logoImage : String{get}
    var personsCount : String{get}
}



struct SliderInput : ZSliderSource{
    private var link : String
    init(link: String) {
        self.link = link
    }
    
    var urlString: String?{
        return link
    }
    
    var source: ZImageSourceType
    {
        return .url
    }
    
}

