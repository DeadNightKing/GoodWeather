//
//  ViewController.swift
//  GoodWeather
//
//  Created by Flow_RyanChou on 2022/7/21.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    @IBOutlet weak var cityNameTextField: UITextField!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var humidityLable: UILabel!
    
    let disposedBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.cityNameTextField.rx.controlEvent(.editingDidEndOnExit)
            .asObservable()
            .map{ self.cityNameTextField.text }
            .subscribe(onNext: { city in
                if let city = city {
                    if city.isEmpty {
                        self.displayWeather(nil)
                    }
                    else
                    {
                        self.fetchWeather(by: city)
                    }
                }
            })
            .disposed(by: disposedBag)
        
//        self.cityNameTextField.rx.value
//            .subscribe (onNext: { city in
//
//                if let city = city {
//                    if city.isEmpty {
//                        self.displayWeather(nil)
//                    }
//                    else
//                    {
//                        self.fetchWeather(by: city)
//                    }
//                }
//            })
//            .disposed(by: disposedBag)
        
    }
    
    private func displayWeather (_ weather: Weather?) {
        
        if let weather = weather {
            self.temperatureLabel.text = "\(weather.temp) ℃"
            self.humidityLable.text = "\(weather.humidity) ✱"
        }
        else {
            self.temperatureLabel.text = "😱"
            self.humidityLable.text = "😢"
        }
        
    }

    private func fetchWeather (by city: String) {
        
        guard let cityEncoded = city.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed),
              let url = URL.urlForWeatherAPI(city: cityEncoded)
        else { return }
        
        let resource = Resource<WeatherResult>(url: url)
        
//        let search = URLRequest.load(resource: resource)
//            .observeOn(MainScheduler.instance)
//            .asDriver(onErrorJustReturn: WeatherResult.empty)
        
        let search = URLRequest.load(resource: resource)
            .retry(3)
            .observeOn(MainScheduler.instance)
            .catchError { error in
                print(error.localizedDescription)
                return Observable.just(WeatherResult.empty)
            }
            .asDriver(onErrorJustReturn: WeatherResult.empty)
            
        search.map { "\($0.main.temp) ℃" }
            .drive(self.temperatureLabel.rx.text)
            .disposed(by: disposedBag)
        
        search.map { "\($0.main.humidity) ✱" }
            .drive(self.humidityLable.rx.text)
            .disposed(by: disposedBag)
    }

}

