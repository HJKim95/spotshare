//
//  WeatherCell.swift
//  SpotShare
//
//  Created by 김희중 on 21/07/2019.
//  Copyright © 2019 김희중. All rights reserved.
//

import UIKit
import GoogleMaps
import SwiftyJSON
import Alamofire
import Lottie

// https://github.com/SwiftyJSON/SwiftyJSON
// https://github.com/Alamofire/Alamofire

// https://github.com/joeseonmi/woosan_weather
// https://lottiefiles.com/1637-another-spinner#_=_//

class WeatherCell: UICollectionViewCell, CLLocationManagerDelegate {
    
    var locationManager = CLLocationManager()
    
    let weatherLabel: UILabel = {
        let lb = UILabel()
        // letter spacing 1.0
        lb.letterSpacing(text: "WEATHER TODAY", spacing: 1.0)
        lb.font = UIFont(name: "DMSans-Medium", size: 12)
        lb.textColor = .lightGray
        lb.textAlignment = .left
        return lb
    }()
    
    let weatherImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    let degreeLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = .darkGray
        lb.font = UIFont(name: "DMSans-Medium", size: 36)
        lb.textAlignment = .center
        lb.sizeToFit()
        lb.adjustsFontSizeToFitWidth = true
        return lb
    }()
    
    let doCeeLabel: UILabel = {
        let lb = UILabel()
        lb.text = "°C"
        lb.textColor = .darkGray
        lb.font = UIFont(name: "DMSans-Regular", size: 14)
        lb.textAlignment = .center
        return lb
    }()
    
    let locationLabel: UILabel = {
        let lb = UILabel()
        // letter spacing -0.3
        lb.textColor = .darkGray
        lb.font = UIFont(name: "DMSans-Medium", size: 20)
        lb.textAlignment = .left
        return lb
    }()
    
    let compareLabel: UILabel = {
        let lb = UILabel()
//        lb.text = "It's 2°C lower than yesterday."
        lb.textColor = .gray
        lb.font = UIFont(name: "DMSans-Regular", size: 12)
        lb.textAlignment = .left
        return lb
    }()
    
    let fineDustImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(named: "fineDust")
        return iv
    }()
    
    let fineDustLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = .darkGray
        lb.text = "Fine Dust"
        lb.font = UIFont(name: "DMSans-Regular", size: 11)
        lb.textAlignment = .center
        return lb
    }()
    
    let fineDustDegreeLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = .lightGray
        lb.font = UIFont(name: "DMSans-Regular", size: 11)
        lb.textAlignment = .center
        return lb
    }()
    
    let UfineDustImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(named: "ultrafineDust")
        return iv
    }()
    
    let UfineDustLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = .darkGray
        lb.text = "Ultrafine Dust"
        lb.font = UIFont(name: "DMSans-Regular", size: 11)
        lb.textAlignment = .center
        return lb
    }()
    
    let UfineDustDegreeLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = .lightGray
        lb.font = UIFont(name: "DMSans-Regular", size: 11)
        lb.textAlignment = .center
        return lb
    }()
    
    lazy var refreshImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "refresh")
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(refreshWeather)))
        return iv
    }()
    
    let animationView = AnimationView(name: "refresh_main")
    
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var weatherLabelConstraint: NSLayoutConstraint?
    var weatherImageViewConstraint: NSLayoutConstraint?
    var degreeLabelConstraint: NSLayoutConstraint?
    var doCeeLabelConstraint: NSLayoutConstraint?
    var locationLabelConstraint: NSLayoutConstraint?
    var compareLabelConstraint: NSLayoutConstraint?
    var fineDustImageViewConstraint: NSLayoutConstraint?
    var fineDustLabelConstraint: NSLayoutConstraint?
    var fineDustDegreeLabelConstraint: NSLayoutConstraint?
    var UfineDustImageViewConstraint: NSLayoutConstraint?
    var UfineDustLabelConstraint: NSLayoutConstraint?
    var UfineDustDegreeLabelConstraint: NSLayoutConstraint?
    var refreshImageViewConstraint: NSLayoutConstraint?
    var animationViewConstraint: NSLayoutConstraint?

    // total height 139 + 5(alpha)
    fileprivate func setupViews() {
        backgroundColor = .white

        setupLayouts()
        
        getCacheData()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    fileprivate func setupLayouts() {
        addSubview(weatherLabel)
        addSubview(weatherImageView)
        addSubview(degreeLabel)
        addSubview(doCeeLabel)
        addSubview(locationLabel)
        addSubview(compareLabel)
        addSubview(fineDustImageView)
        addSubview(fineDustLabel)
        addSubview(fineDustDegreeLabel)
        addSubview(UfineDustImageView)
        addSubview(UfineDustLabel)
        addSubview(UfineDustDegreeLabel)
        addSubview(refreshImageView)
        addSubview(animationView)
        animationView.alpha = 0
        

        // constraint 적용하기전 addSubView를 미리 해주어야함.
        weatherLabelConstraint = weatherLabel.anchor(self.topAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, topConstant: 32, leftConstant: 24, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 18).first
        weatherImageViewConstraint = weatherImageView.anchor(weatherLabel.bottomAnchor, left: self.leftAnchor, bottom: nil, right: nil, topConstant: 5, leftConstant: 16, bottomConstant: 0, rightConstant: 0, widthConstant: 60, heightConstant: 60).first
        degreeLabelConstraint = degreeLabel.anchor(weatherLabel.bottomAnchor, left: weatherImageView.rightAnchor, bottom: nil, right: nil, topConstant: 10, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 32, heightConstant: 47).first
        doCeeLabelConstraint = doCeeLabel.anchor(weatherLabel.bottomAnchor, left: degreeLabel.rightAnchor, bottom: nil, right: nil, topConstant: 14.4, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 15, heightConstant: 18).first
        refreshImageViewConstraint = refreshImageView.anchor(weatherLabel.bottomAnchor, left: nil, bottom: nil, right: self.rightAnchor, topConstant: 20, leftConstant: 0, bottomConstant: 0, rightConstant: 18, widthConstant: 24, heightConstant: 24).first
        animationViewConstraint = animationView.anchor(weatherLabel.bottomAnchor, left: nil, bottom: nil, right: self.rightAnchor, topConstant: 20, leftConstant: 0, bottomConstant: 0, rightConstant: 18, widthConstant: 24, heightConstant: 24).first
        locationLabelConstraint = locationLabel.anchor(weatherLabel.bottomAnchor, left: doCeeLabel.rightAnchor, bottom: nil, right: self.rightAnchor, topConstant: 12, leftConstant: 15, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 28).first
        compareLabelConstraint = compareLabel.anchor(locationLabel.bottomAnchor, left: doCeeLabel.rightAnchor, bottom: nil, right: self.rightAnchor, topConstant: 2, leftConstant: 15, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 16).first
        
        fineDustImageViewConstraint = fineDustImageView.anchor(weatherImageView.bottomAnchor, left: self.leftAnchor, bottom: nil, right: nil, topConstant: 8, leftConstant: 24, bottomConstant: 0, rightConstant: 0, widthConstant: 16, heightConstant: 16).first
        fineDustLabelConstraint = fineDustLabel.anchor(weatherImageView.bottomAnchor, left: fineDustImageView.rightAnchor, bottom: nil, right: nil, topConstant: 9, leftConstant: 6, bottomConstant: 0, rightConstant: 0, widthConstant: 48, heightConstant: 14).first
        fineDustDegreeLabelConstraint = fineDustDegreeLabel.anchor(weatherImageView.bottomAnchor, left: fineDustLabel.rightAnchor, bottom: nil, right: nil, topConstant: 9, leftConstant: 4, bottomConstant: 0, rightConstant: 0, widthConstant: 54, heightConstant: 14).first
        
        UfineDustImageViewConstraint = UfineDustImageView.anchor(weatherImageView.bottomAnchor, left: fineDustDegreeLabel.rightAnchor, bottom: nil, right: nil, topConstant: 8, leftConstant: 14, bottomConstant: 0, rightConstant: 0, widthConstant: 16, heightConstant: 16).first
        UfineDustLabelConstraint = UfineDustLabel.anchor(weatherImageView.bottomAnchor, left: UfineDustImageView.rightAnchor, bottom: nil, right: nil, topConstant: 9, leftConstant: 6, bottomConstant: 0, rightConstant: 0, widthConstant: 70, heightConstant: 14).first
        UfineDustDegreeLabelConstraint = UfineDustDegreeLabel.anchor(weatherImageView.bottomAnchor, left: UfineDustLabel.rightAnchor, bottom: nil, right: nil, topConstant: 9, leftConstant: 4, bottomConstant: 0, rightConstant: 0, widthConstant: 54, heightConstant: 14).first
        
        
        
    }
    
    fileprivate func getCacheData() {
        
        let myData = UserDefaults.standard
        guard let weatherCache = myData.dictionary(forKey: "weatherCache") else {return}
        guard let dustCache = myData.dictionary(forKey: "dustCache") else {return}
        
        print("날씨 cache 불러오는중")
        let imageString = weatherCache["imageString"] as! String
        let temp = weatherCache["temp"] as! String
        let location = dustCache["location"] as! String
        let subLocation = dustCache["sublocation"] as! String
        print("미세먼지 cache 불러오는중")
        let pm10Value = dustCache["dustPM10Value"] as! String
        let pm25Value = dustCache["dustPM25Value"] as! String
        let pm10Comment = dustCache["dustPM10Comment"] as! String
        let pm25Comment = dustCache["dustPM25Comment"] as! String
        
        self.weatherImageView.image = UIImage(named: imageString)
        self.degreeLabel.letterSpacing(text: temp, spacing: -0.67)
        self.locationLabel.letterSpacing(text: subLocation + ", " + location, spacing: -0.3)
        self.fineDustDegreeLabel.text = pm10Value + " " + pm10Comment
        self.UfineDustDegreeLabel.text = pm25Value + " " + pm25Comment
        
    }
    
    var myLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 37.551672, longitude: 126.924952)
    
    fileprivate func getWeatherData(location: CLLocationCoordinate2D) {
        // https://github.com/joeseonmi/woosan_weather
        
        let lat = String(format: "%.6f", location.latitude)
        let long = String(format: "%.6f", location.longitude)
        
        WeatherApiHelper.shared.getCurrentWeather(lat: lat, long: long) { [weak self] (weather) in
            print("날씨 불러오기 완료.")
            self?.weatherImageView.image = UIImage(named: weather.imageString)
            self?.degreeLabel.letterSpacing(text: weather.temp, spacing: -0.67)
            guard let today_temp = Int(weather.temp) else {return}
            WeatherApiHelper.shared.getYesterdayWeather(lat: lat, long: long) { [weak self] (weather) in
                guard let yesterday_temp = Int(weather.yesterday_temp) else {return}
                let temp_Differ = today_temp - yesterday_temp
                if temp_Differ > 0 {
                    self?.compareLabel.text = "어제보다 \(temp_Differ)°C 높아요."
                }
                else if temp_Differ == 0 {
                    self?.compareLabel.text = "어제랑 기온이 비슷해요."
                }
                else {
                    self?.compareLabel.text = "어제보다 \(-temp_Differ)°C 낮아요."
                }
            }
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error while get location \(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // 대한민국 위도 범위: 38.61 ~ 33.11
        // 대한민국 경도 범위: 124.663890 ~ 131.871783
        
        let location = locations.last
        guard let lat = location?.coordinate.latitude else {return}
        guard let long = location?.coordinate.longitude else {return}
        let convertLocation = CLLocationCoordinate2D(latitude: lat, longitude: long)
        self.myLocation = convertLocation
        if convertLocation.latitude > 33.11 && convertLocation.latitude < 38.62 {
            if convertLocation.longitude > 124 && convertLocation.longitude < 132 {
                getGeoLocation(location: convertLocation)
                getWeatherData(location: convertLocation)
            }
            
            else {
                showError()
                return
            }
        }
        
        else {
            showError()
            return
        }
        
        
        
        self.locationManager.stopUpdatingLocation()
    }
    
    fileprivate func getGeoLocation(location: CLLocationCoordinate2D) {
        let geocoder = GMSGeocoder()
        
        // 광진구, 서울 이렇게 할지 고민중.
        geocoder.reverseGeocodeCoordinate(location) { [weak self] (response, error) in
            guard let address = response?.firstResult() else {return}
            // administrativeArea 도시
            guard let admin = address.administrativeArea else {return}
            // subLocality 구
            guard let sublocal = address.subLocality else {return}
            self?.locationLabel.letterSpacing(text: sublocal + ", " + admin, spacing: -0.3)
            // 하기 전 info.plist에 설정해주어야함.
            // https://blowmj.tistory.com/entry/iOS-iOS9-App-Transport-Security-설정법
            DustApiHelper.shared.todayDustInfo(cityName: admin, subLocalName: sublocal) { [weak self] (todayDust) in
                print("미세먼지 불러오기 완료.")
                self?.fineDustDegreeLabel.text = todayDust.dust10Value + " " + todayDust.dustPM10Comment
                self?.UfineDustDegreeLabel.text = todayDust.dust25Value + " " + todayDust.dustPM25Comment
                self?.animationView.stop()
                self?.animationView.alpha = 0
                self?.refreshImageView.alpha = 1
                self?.refreshImageView.isUserInteractionEnabled = true
            }
        }
    }
    
    @objc fileprivate func refreshWeather() {
        print("refreshing weather data")

        refreshImageView.alpha = 0
        animationView.alpha = 1
        animationView.play()
        refreshImageView.isUserInteractionEnabled = false
        
        
        if myLocation.latitude > 33.11 && myLocation.latitude < 38.62 {
            if myLocation.longitude > 124 && myLocation.longitude < 132 {
                getGeoLocation(location: myLocation)
                getWeatherData(location: myLocation)
            }
            
            else {
                showError()
            }
        }
        
        else {
            showError()
        }
        
    }
    
    fileprivate func showError() {
        self.weatherImageView.image = UIImage(named: "")
        self.degreeLabel.letterSpacing(text: "", spacing: -0.67)
        self.locationLabel.letterSpacing(text: "지원하지 않는 장소입니다.", spacing: -0.3)
        self.refreshImageView.alpha = 0
        self.fineDustDegreeLabel.text = ""
        self.UfineDustDegreeLabel.text = ""
    }
    
}


