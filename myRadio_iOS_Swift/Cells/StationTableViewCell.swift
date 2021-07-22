//
//  StationTableViewCell.swift
//  myRadio_iOS_Swift
//
//  Created by Add on 21.07.2021.
//

import UIKit

class StationTableViewCell: UITableViewCell {

    @IBOutlet weak var stationNameLabel: UILabel!
    @IBOutlet weak var stationDescLabel: UILabel!
    @IBOutlet weak var stationImageView: UIImageView!
    
    var downloadTask: URLSessionDownloadTask?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // set ImageView shadow
        stationImageView.applyShadow()
        
        // set table selection color
        let selectedView = UIView(frame: CGRect.zero)
        selectedView.backgroundColor = UIColor(red: 78/255, green: 82/255, blue: 93/255, alpha: 0.6)
        selectedBackgroundView  = selectedView
    }

    func configureStationCell(station: RadioStation) {
        
        // Configure the cell...
        stationNameLabel.text = station.name
        stationDescLabel.text = station.desc
        
        let imageURL = station.imageURL as NSString
        if imageURL.contains("http"), let url = URL(string: station.imageURL) {
            stationImageView.loadImageWithURL(url: url) { (image) in
                // station image loaded
            }
        } else if imageURL != "" {
            stationImageView.image = UIImage(named: imageURL as String)
        } else {
            stationImageView.image = UIImage(named: "stationImage")
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        downloadTask?.cancel()
        downloadTask = nil
        stationNameLabel.text  = nil
        stationDescLabel.text  = nil
        stationImageView.image = nil
    }
}

extension UIImageView {

    // APPLY DROP SHADOW
    func applyShadow() {
        let layer           = self.layer
        layer.shadowColor   = UIColor.black.cgColor
        layer.shadowOffset  = CGSize(width: 0, height: 1)
        layer.shadowOpacity = 0.4
        layer.shadowRadius  = 2
    }

}

extension UIImageView {
    
    func loadImageWithURL(url: URL, callback: @escaping (UIImage) -> ()) {
        let session = URLSession.shared
        
        let downloadTask = session.downloadTask(with: url, completionHandler: {
            [weak self] url, response, error in
            
            if error == nil && url != nil {
                if let data = NSData(contentsOf: url!) {
                    if let image = UIImage(data: data as Data) {
                        
                        DispatchQueue.main.async(execute: {
                            
                            if let strongSelf = self {
                                strongSelf.image = image
                                callback(image)
                            }
                        })
                    }
                }
            }
        })
        
        downloadTask.resume()
    }
}
