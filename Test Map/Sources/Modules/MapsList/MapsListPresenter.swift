//
//  MapsListPresenter.swift
//  Test Map
//
//  Created by Melany Gulianovych on 02.07.2023.
//

import Foundation

protocol MapsListPresentable: Presenter {
    var controller: MapsListViewControllable? { get set }
    func backPressed()
    var itemsCount: Int { get }
    
    func fill(item: PlainModelFillable, atIndex index: Int)
    func item(selectedAtIndex index: Int)
    func mapDownloadSelected(index: IndexPath)
}

class MapsListPresenter: MapsListPresentable {
    weak var controller: MapsListViewControllable?
    private var model: MapsListModellable
    var countrySelected: ((CountryRepresentation) -> Void)?
    var backSelected: Model.EmptyOptionalHandler = nil

    private var title: String = "Download Maps"
    
    private var mainScreen = true
    
    init(model: MapsListModel) {
        self.model = model
    }
    
    init(title: String, model: MapsListModel) {
        self.model = model
        self.title = title
        mainScreen = false
    }
    
    func viewLoaded() {
        if mainScreen {
            getFilesFreeSpace()
        } else {
            controller?.configureViews()
        }
        controller?.setUpUI(title: title)
        NotificationCenter.default.addObserver(self, selector: #selector(updateProgress(notification:)), name: Notification.Name(Constants.Strings.LoadData), object: nil)

    }
    
    func backPressed() {
        backSelected?()
    }
    
    var itemsCount: Int {
        return model.countries.count
    }
    
    func fill(item: PlainModelFillable, atIndex index: Int) {
        guard model.countries.indices.contains(index) else {
            return
        }
        
        let plainModel: CountryCellPlainModel = CountryCellPlainModel(from: model.countries[index], delegate: controller)
        item.fill(with: plainModel)
    }
    
    func item(selectedAtIndex index: Int) {
        guard model.countries.indices.contains(index) else {
            return
        }
        let country = model.countries[index]
        if country.regions.isEmpty == false {
            countrySelected?(country)
        }
    }
    
    func getFilesFreeSpace() {
        if let totalSpaceInBytes = getFileSize(for: .systemSize), let freeSpaceInBytes = getFileSize(for: .systemFreeSize) {
            let allGb = Units(bytes: totalSpaceInBytes).gigabytes
            let freeGb = Units(bytes: freeSpaceInBytes).gigabytes
            let formatted = ByteCountFormatter.string(fromByteCount: (freeSpaceInBytes), countStyle: .memory)
            let percent = freeGb / allGb
            controller?.setDeviceData(progress: Float(percent), freeSpace: "Free \(formatted)")
        } else {
            controller?.setDeviceData(progress: 0, freeSpace: "Free 0 GB")
        }
    }
    
     func getFileSize(for key: FileAttributeKey) -> Int64? {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)

        guard
            let lastPath = paths.last,
            let attributeDictionary = try? FileManager.default.attributesOfFileSystem(forPath: lastPath) else { return nil }

        if let size = attributeDictionary[key] as? NSNumber {
            return size.int64Value
        } else {
            return nil
        }
    }
    
    func mapDownloadSelected(index: IndexPath) {
        model.loadMap(index: index)
    }
    
    @objc func updateProgress(notification: Notification) {
        if let index = notification.object as? IndexPath {
            controller?.reloadCell(at: index)
        }

        
    }
}
