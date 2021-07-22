//
//  DataManager.swift
//  myRadio_iOS_Swift
//
//  Created by Add on 21.07.2021.
//

import Foundation
import UIKit

struct DataManager {
    //*****************************************************************
    // Helper struct to get either local or remote JSON
    //*****************************************************************
    
    static func getStationDataWithSuccess(success: @escaping ((_ metaData: Data?) -> Void)) {
        DispatchQueue.global(qos: .userInitiated).async {
            getDataFromFileWithSuccess() { data in
                success(data)
            }
        }
    }
    
    //*****************************************************************
    // Load local JSON Data
    //*****************************************************************
    
    static func getDataFromFileWithSuccess(success: (_ data: Data?) -> Void) {
        guard let filePathURL = Bundle.main.url(forResource: "stations", withExtension: "json") else {
            // if kDebugLog { print("The local JSON file could not be found") }
            success(nil)
            return
        }
        
        do {
            let data = try Data(contentsOf: filePathURL, options: .uncached)
            success(data)
        } catch {
            fatalError()
        }
    }
    
}
