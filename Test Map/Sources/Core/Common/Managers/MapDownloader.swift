//
//  MapDownloader.swift
//  Test Map
//
//  Created by Melany Gulianovych on 03.07.2023.
//

import Foundation

extension Constants.Strings {
   static let LoadData = "LoadDataNotification"
}

class MapDownloader: Operation, URLSessionDelegate, URLSessionDownloadDelegate, URLSessionTaskDelegate {
    var country: CountryRepresentation
    var index: IndexPath

    var session: URLSession?
    var downloadTask: URLSessionDownloadTask?

    
    init(_ countryRepresentation: CountryRepresentation, indexPath: IndexPath) {
        self.country = countryRepresentation
        self.index = indexPath
        super.init()
        self.session = configureSession()
    }
    
    func configureSession() -> URLSession {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.sessionSendsLaunchEvents = true
        configuration.isDiscretionary = true
        let session = URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
        return session
    }
    
    override var isExecuting: Bool {
        return session != nil
    }
    
    override var isFinished: Bool {
        return session == nil
    }
    
    override var isAsynchronous: Bool {
        return false
    }
    
    override func start() {
        willChangeValue(forKey: "isExecuting")
        if isCancelled {
            return
        }
        if let url = country.url {
            downloadTask = session?.downloadTask(with: URLRequest(url: url))
        }
        didChangeValue(forKey: "isExecuting")
        if isCancelled {
            return
        }
        downloadTask?.resume()
    }
    
    func finish() {
        willChangeValue(forKey: "isExecuting")
        willChangeValue(forKey: "isFinished")
        session = nil
        downloadTask = nil
        
        didChangeValue(forKey: "isExecuting")
        didChangeValue(forKey: "isFinished")
    }
    
    override func cancel() {
        super.cancel()
        if downloadTask?.state == .running {
            downloadTask?.cancel()
            country.progress = 0
            country.state = .new
            performSelector(onMainThread: #selector(updateData), with: index, waitUntilDone: false)
            print("cancellsed")
        }
        finish()
    }
    
    func urlSession(_ session: URLSession,
                    downloadTask: URLSessionDownloadTask,
                    didWriteData bytesWritten: Int64,
                    totalBytesWritten: Int64,
                    totalBytesExpectedToWrite: Int64) {
        self.downloadTask = downloadTask
        
        if isCancelled {
            cancel()
            return
        }
        let progress = (Float(totalBytesWritten) / 1024) / (Float(totalBytesExpectedToWrite) / 1024)
        if isCancelled {
            cancel()
            return
        }
        country.progress = progress
        country.state = .downloaded
        performSelector(onMainThread: #selector(updateData), with: index, waitUntilDone: false)
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        self.downloadTask = downloadTask
        if isCancelled {
            cancel()
            return
        }
        let data = try? Data(contentsOf: location)
        country.mapData = data
        country.state = .finished

        finish()
        performSelector(onMainThread: #selector(updateData), with: index, waitUntilDone: false)
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if isCancelled {
            cancel()
            return
        }
        if error != nil {
            cancel()
        }
    }
    
    @objc func updateData() {
        NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: Constants.Strings.LoadData), object: index))
    }
}
