//
//  AreasViewModel.swift
//  Meatz
//
//  Created by Mohamed Zead on 4/13/21.
//

import Foundation

final class AreasViewModel {
    private var areas : [AreaModel] = []
    private var coordinator : Coordinator?
    var reloadData: Observable<Bool> = Observable.init(false)
    var didSelectCityWith : ((_ city : CityModel) -> Void)!
    init(_ areas : [AreaModel],_ coordinator : Coordinator?) {
        self.areas = areas
        self.coordinator = coordinator
    }
}

extension AreasViewModel : AreasVMProtocol{
    var numberOfAreas: Int{
        return areas.count
    }
    
    func citiesCount(at seciton: Int) -> Int {
        return areas[seciton].cities.count
    }
    func numberOfCitiesInArea(at index: Int) -> Int {
        let area = areas[index]
        return area.isExpanded ? area.cities.count : 0
    }
    func titleForArea(at index: Int) -> String {
        return areas[index].name
    }
    func titleForCity(at index: IndexPath) -> String {
        return areas[index.section].cities[index.row].name
    }
    func didSelectArea(at index: Int) {
        let flag = areas[index].isExpanded
        areas[index].isExpanded = !flag
       // reloadData.value = true
    }
    
    func didSelectCity(at index: IndexPath) {
        let city = areas[index.section].cities[index.row]
        didSelectCityWith(city)
        coordinator?.dismiss(true, nil)
    }
    
    func isExpanded(at index: Int) -> Bool {
        return areas[index].isExpanded
    }
    
}

protocol AreasVMProtocol{
    var numberOfAreas : Int{get}
    var reloadData : Observable<Bool>{get set}
    func numberOfCitiesInArea(at index : Int) -> Int
    func citiesCount(at seciton : Int) -> Int
    func titleForArea(at index : Int) -> String
    func titleForCity(at index : IndexPath) -> String
    func didSelectCity(at index : IndexPath)
    func didSelectArea(at index : Int)
    func isExpanded(at index : Int) -> Bool
}
