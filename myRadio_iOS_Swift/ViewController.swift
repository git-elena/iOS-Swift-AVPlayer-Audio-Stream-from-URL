//
//  ViewController.swift
//  myRadio_iOS_Swift
//
//  Created by Add on 15.07.2021.
//

import UIKit

class ViewController: UIViewController {
    // MARK: - IB UI
    
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var switchOnOff: UISwitch!
    
    // MARK: - Properties
    
    private let radio = Radio_AVPlayer()
    
    // MARK: - Lists
    
    private  var stations = [RadioStation]() {
        didSet {
            
            stationsDidUpdate()
        }
    }
    
    // MARK: - UI
    
    var refreshControl: UIRefreshControl = {
        return UIRefreshControl()
    }()
    
    //*****************************************************************
    // MARK: - ViewDidLoad
    //*****************************************************************
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        urlTextField.text = "https://213.239.218.99:7096/stream"
        //urlTextField.text = "http://strm112.1.fm/acountry_mobile_mp3"
        
        // Load Data
        loadStationsFromJSON()
        
        // Setup TableView
        tableView.backgroundColor = .clear
        tableView.backgroundView = nil
        tableView.separatorStyle = .none

        
    }
    
    //*****************************************************************
    // MARK: - didToggleRadio UISwitch
    //*****************************************************************
    
    @IBAction func didToggleRadio(_ sender: UISwitch) {
        
        if sender.isOn {
            if !setRadioURL() { return }
        }
        
        radio.didToggle()
    }
    
    
    
    //*****************************************************************
    // MARK: - Actions
    //*****************************************************************
    
    @objc func refresh(sender: AnyObject) {
        // Pull to Refresh
        loadStationsFromJSON()
        
        // Wait 2 seconds then refresh screen
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.refreshControl.endRefreshing()
            self.view.setNeedsDisplay()
        }
    }
    //*****************************************************************
    // MARK: - Load Station Data
    //*****************************************************************
    
    func loadStationsFromJSON() {
        
        // Turn on network indicator in status bar
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
      
        // Get the Radio Stations
        DataManager.getStationDataWithSuccess() { (data) in

            // Turn off network indicator in status bar
            defer {
                DispatchQueue.main.async { UIApplication.shared.isNetworkActivityIndicatorVisible = false }
            }

            guard let data = data, let jsonDictionary = try? JSONDecoder().decode([String: [RadioStation]].self, from: data), let stationsArray = jsonDictionary["station"] else {
                return
            }
            self.stations = stationsArray
        }
    }
    
    //*****************************************************************
    // MARK: - Private helpers
    //*****************************************************************
    
    private func stationsDidUpdate() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            
        }
    }
    
    private func playingRadio(withID id: Int) {
        
        urlTextField.text = stations[id].streamURL
        
        if setRadioURL(), switchOnOff.isOn {
            radio.play()
        }
    }
    
    private func setRadioURL() -> Bool {
        guard let url = urlTextField.text else {
            return false
        }
        radio.radioURL = URL(string: url)
        return true
    }
}



//*****************************************************************
// MARK: - TableViewDataSource
//*****************************************************************

extension ViewController: UITableViewDataSource {
    
    @objc(tableView:heightForRowAtIndexPath:)
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90.0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       stations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StationCell", for: indexPath) as! StationTableViewCell
        
        // alternate background color
        cell.backgroundColor = (indexPath.row % 2 == 0) ? UIColor.clear : UIColor.black.withAlphaComponent(0.2)
        cell.configureStationCell(station: stations[indexPath.row])
        return cell
    }
}

//*****************************************************************
// MARK: - TableViewDelegate
//*****************************************************************

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        //performSegue(withIdentifier: "NowPlaying", sender: indexPath)
        
        playingRadio(withID: indexPath.row)
    }
}

class AnimationFrames {
    
    class func createFrames() -> [UIImage] {
    
        // Setup "Now Playing" Animation Bars
        var animationFrames = [UIImage]()
        for i in 0...3 {
            if let image = UIImage(named: "NowPlayingBars-\(i)") {
                animationFrames.append(image)
            }
        }
        
        for i in stride(from: 2, to: 0, by: -1) {
            if let image = UIImage(named: "NowPlayingBars-\(i)") {
                animationFrames.append(image)
            }
        }
        return animationFrames
    }

}
