//
//  ViewController.swift
//  PlaceAutocomplete
//
//  Created by Kaveh Vossoughi on 5/15/17.
//  Copyright © 2017 Kaveh Vossoughi. All rights reserved.
//

import UIKit
import GooglePlaces

class ViewController: UIViewController {
    
    @IBOutlet weak var imageIcon: UIImageView!
    
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var cityNameLabel: UILabel!
    
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var imageDescriptionLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var feelsLikeLabel: UILabel!
    @IBOutlet weak var visibilityLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    
    @IBOutlet weak var searchCityButton: UIButton!
    @IBOutlet weak var tempUnitButton: UIButton!
    
    var conditionDictionary: [String : Any]!
    var isCelsius: Bool = false
    var isCityPicked: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
        hideLabels(true)
        
    }
    
    // Present the Autocomplete view controller when the button is pressed.
    @IBAction func autocompleteClicked(_ sender: UIButton) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }
}

extension ViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name)")
        print("Place address: \(String(describing: place.formattedAddress))")
        print("Place attributions: \(String(describing: place.attributions))")
            
        // Get URL
        let parameters = ["q" : place.name]
        let url = ApixuDBURLs.URLForResource(resource: ApixuDB.CurrentResources.Current, parameters: parameters)
        
        print("\(url)")
        
        let task = URLSession.shared.dataTask(with: url) {
            data, response, error in
            
            // No data, return an empty array
            guard let data = data else {
                print ("Error with Json: \(String(describing: error))")
                return
            }
            
            // MARK: - Location Inforamtion
            let locationDictionary = ModelStore.jsonDictionaryFromData(data, keyForResult: ApixuDB.CurrentResources.Location)
            let localtime = locationDictionary[ApixuDB.Keys.LocalTime] as! String
            self.dateTimeLabel.text = localtime
            
            // MARK: - Change Day and Night
            var hourOfTime: Int!
            let time = localtime.substring(from: localtime.index(localtime.startIndex, offsetBy: 11))
            if let colon = time.characters.index(of: ":") {
                let hourOfTimeStr = String(time.characters.prefix(upTo: colon))
                hourOfTime = Int(hourOfTimeStr)!
            }
            
            if (hourOfTime < 6 || hourOfTime > 19) {
                let background = UIImage(named: "NightBackground")
                self.view.backgroundColor = UIColor(patternImage: background!)
                
                self.dateTimeLabel.textColor = UIColor(red: 1.0, green: 0.8, blue: 0.8, alpha: 1.0)
                self.cityNameLabel.textColor = self.dateTimeLabel.textColor
                
                self.tempLabel.textColor = UIColor(red: 0.9, green: 1.0, blue: 0.7, alpha: 1.0)
                self.imageDescriptionLabel.textColor = UIColor(red: 0.8, green: 1.0, blue: 0.8, alpha: 1.0)
                self.windLabel.textColor = self.imageDescriptionLabel.textColor
                self.humidityLabel.textColor = self.imageDescriptionLabel.textColor
                self.feelsLikeLabel.textColor = self.imageDescriptionLabel.textColor
                self.visibilityLabel.textColor = self.imageDescriptionLabel.textColor
                self.pressureLabel.textColor = self.imageDescriptionLabel.textColor
                
                self.searchCityButton.tintColor = UIColor.white
                self.tempUnitButton.tintColor = UIColor.white
                
            } else {
                let background = UIImage(named: "DayBackground")
                self.view.backgroundColor = UIColor(patternImage: background!)
                
                self.dateTimeLabel.textColor = UIColor(red: 0.2, green: 0.1, blue: 0.1, alpha: 1.0)
                self.cityNameLabel.textColor = self.dateTimeLabel.textColor
                
                self.tempLabel.textColor = UIColor(red: 0.6, green: 0.4, blue: 0.2, alpha: 1.0)
                self.imageDescriptionLabel.textColor = self.tempLabel.textColor
                self.windLabel.textColor = UIColor(red: 0.1, green: 0.2, blue: 0.2, alpha: 1.0)
                self.humidityLabel.textColor = self.windLabel.textColor
                self.feelsLikeLabel.textColor = self.windLabel.textColor
                self.visibilityLabel.textColor = self.windLabel.textColor
                self.pressureLabel.textColor = self.windLabel.textColor
                
                self.searchCityButton.tintColor = UIColor.black
                self.tempUnitButton.tintColor = UIColor.black
            }
            
            self.cityNameLabel.text = place.formattedAddress
            
            // MARK: - Current Condition Imperial
            self.conditionDictionary = ModelStore.jsonDictionaryFromData(data, keyForResult: ApixuDB.CurrentResources.Current)
            
            self.setUnitToCelsius(self.isCelsius)
            self.isCityPicked = true
            
            // MARK: - Image Description
            let condition = self.conditionDictionary[ApixuDB.Keys.Condition] as! [String : Any]
            let imageDescription = condition[ApixuDB.Keys.ImageDescription] as! String
            self.imageDescriptionLabel.text = imageDescription
            
            // MARK: - Image
            let imageUrlString = "https:" + (condition[ApixuDB.Keys.IconURL] as! String)
            // var resultImage: UIImage!
            
            if let imageUrl = URL(string: imageUrlString) {
                
                // Create task
                let task = URLSession.shared.dataTask(with: imageUrl, completionHandler: {
                    data, response, error in
                    
                    if let error = error {
                        print(error)
                    }
                    
                    if let data = data, let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self.imageIcon.image = image
                        }
                    }
                })
                
                task.resume()
            }

        }
        
        task.resume()
        
        hideLabels(false)
        dismiss(animated: true, completion: nil)
    }

    @IBAction func changeUnits(_ sender: Any) {
        if (!self.isCityPicked) {
            return
        }
        
        self.isCelsius = !self.isCelsius
        setUnitToCelsius(isCelsius)
    }
    
    func setUnitToCelsius( _ celsius: Bool) {
        
        if (celsius) {
            // MARK: - Current Condition Meetric
            
            let temp = conditionDictionary[ApixuDB.Keys.TemperatureC] as! Float
            self.tempLabel.text = "\(temp) °C"
            
            let wind = conditionDictionary[ApixuDB.Keys.WindKph] as! Float
            self.windLabel.text = "Wind: \(wind) kph"
            
            let feelsLike = conditionDictionary[ApixuDB.Keys.FeelsLikeC] as! Float
            self.feelsLikeLabel.text = "Feels Like: \(feelsLike) °C"
            
            let visibility = conditionDictionary[ApixuDB.Keys.VisibilityKm] as! Int
            self.visibilityLabel.text = "Visibility: \(visibility) km"
            
            let pressure = conditionDictionary[ApixuDB.Keys.PressureMilibars] as! Float
            self.pressureLabel.text = "Pressure: \(pressure) mb"

        } else {
            let temp = self.conditionDictionary[ApixuDB.Keys.TemperatureF] as! Float
            self.tempLabel.text = "\(temp) °F"
            
            let wind = self.conditionDictionary[ApixuDB.Keys.WindMph] as! Float
            self.windLabel.text = "Wind: \(wind) mph"
            
            let feelsLike = self.conditionDictionary[ApixuDB.Keys.FeelsLikeF] as! Float
            self.feelsLikeLabel.text = "Feels Like: \(feelsLike) °F"
            
            let visibility = self.conditionDictionary[ApixuDB.Keys.VisibilityMile] as! Int
            self.visibilityLabel.text = "Visibility: \(visibility) mile"
            
            let pressure = self.conditionDictionary[ApixuDB.Keys.PressureInchesOfMercury] as! Float
            self.pressureLabel.text = "Pressure: \(pressure) inHg"
        }
        
        let humidity = self.conditionDictionary[ApixuDB.Keys.Humidity] as! Int
        self.humidityLabel.text = "Humidity: \(humidity) %"
        
    }
    
    func hideLabels(_ hidden: Bool) {
        self.cityNameLabel.isHidden = hidden
        self.dateTimeLabel.isHidden = hidden
        self.tempLabel.isHidden = hidden
        self.imageDescriptionLabel.isHidden = hidden
        self.windLabel.isHidden = hidden
        self.humidityLabel.isHidden = hidden
        self.feelsLikeLabel.isHidden = hidden
        self.visibilityLabel.isHidden = hidden
        self.pressureLabel.isHidden = hidden
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}
