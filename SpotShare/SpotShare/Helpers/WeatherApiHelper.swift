//
//  WeatherApiHelper.swift
//  SpotShare
//
//  Created by 김희중 on 2020/03/12.
//  Copyright © 2020 김희중. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import GoogleMaps

class WeatherApiHelper {
    static let shared = WeatherApiHelper()
    
    // https://github.com/joeseonmi/woosan_weather
    private func getCurrunt(base parameter:[String:String], completed: @escaping (_ curruntData:[JSON]) -> Void) {

        let url = WeatherData.weatherApi
        AF.request(url, method: .get, parameters: parameter, encoding: URLEncoding.default, headers: nil)
            .responseJSON { (response) in
                switch response.result {
                case .success :
                    guard let weatherData = response.data else { return }
                    let data = JSON(weatherData)
                    let dataArray = data["response"]["body"]["items"]["item"].arrayValue
                    completed(dataArray)
                case .failure( _) : break
                }
        }
    }
    
    // https://github.com/joeseonmi/woosan_weather
    func getCurrentWeather(lat: String, long: String, completed: @escaping (_ todayinfo: CurrentWeather) -> Void) {
        getCurrunt(base: makeCurruntAPIParameter(lat: lat, lon: long)) { (dataArray) in
            print("날씨 받아오기 시작")
            let now = Date()
            let dateFommater = DateFormatter()
            let timeFommater = DateFormatter()
            let minFommater = DateFormatter()
            dateFommater.dateFormat = "yyyyMMdd"
            timeFommater.dateFormat = "HH"
            minFommater.dateFormat = "mm"
            //한국시간으로 맞춰주기
            dateFommater.timeZone = TimeZone(secondsFromGMT: 9 * 60 * 60)
            // time은 hour단위
            var time:String = timeFommater.string(from: now)
            let min:String = minFommater.string(from: now)
            let temp = CurrentWeather.empty
            
            var weatherInfo: [String:String] = [:]
            var totalWeatherInfo: [String:[String:String]] = [:]
            
            if dataArray.count == 0 {
                completed(temp)
            } else {
                for i in 0...dataArray.count - 1 {
                    let fcstTime = dataArray[i]["fcstTime"].stringValue
                    switch dataArray[i]["category"].stringValue {
                    case Constants.api_presentTemp :
                        let value = dataArray[i]["fcstValue"].stringValue
                        weatherInfo[Constants.today_key_presentTemp] = self.roundedTemperature(from: value)
                        totalWeatherInfo[fcstTime] = weatherInfo
                    case Constants.api_sky :
                        guard let dayNightTime = Int(time) else { return }
                        let value = dataArray[i]["fcstValue"].stringValue
                        switch value {
                        case "1":
                            // 맑음
                            if dayNightTime > 07 && dayNightTime < 20 {
                                // 낮
                                weatherInfo[Constants.today_key_Sky] = Weather.Sunny.convertName().subs
                                weatherInfo[Constants.today_key_SkyCode] = Weather.Sunny.convertName().code
                                weatherInfo[Constants.today_key_ImageCode] = Weather.Sunny.convertName().code
                                totalWeatherInfo[fcstTime] = weatherInfo
                            } else {
                                // 밤
                                weatherInfo[Constants.today_key_Sky] = Weather.ClearNight.convertName().subs
                                weatherInfo[Constants.today_key_SkyCode] = Weather.ClearNight.convertName().code
                                weatherInfo[Constants.today_key_ImageCode] = Weather.ClearNight.convertName().code
                                totalWeatherInfo[fcstTime] = weatherInfo
                            }
                        case "2":
                            // 구름조금 (2019.06.04 이후 삭제됨)
                            if dayNightTime > 07 && dayNightTime < 20 {
                                // 낮
                                weatherInfo[Constants.today_key_Sky] = Weather.LittleCloudy.convertName().subs
                                weatherInfo[Constants.today_key_SkyCode] = Weather.LittleCloudy.convertName().code
                                weatherInfo[Constants.today_key_ImageCode] = Weather.LittleCloudy.convertName().code
                                totalWeatherInfo[fcstTime] = weatherInfo
                            } else {
                                // 밤
                                weatherInfo[Constants.today_key_Sky] = Weather.LittleCloudyNight.convertName().subs
                                weatherInfo[Constants.today_key_SkyCode] = Weather.LittleCloudyNight.convertName().code
                                weatherInfo[Constants.today_key_ImageCode] = Weather.LittleCloudyNight.convertName().code
                                totalWeatherInfo[fcstTime] = weatherInfo
                            }
                        case "3":
                            // 구름많음
                            weatherInfo[Constants.today_key_Sky] = Weather.MoreCloudy.convertName().subs
                            weatherInfo[Constants.today_key_SkyCode] = Weather.MoreCloudy.convertName().code
                            weatherInfo[Constants.today_key_ImageCode] = Weather.MoreCloudy.convertName().code
                            totalWeatherInfo[fcstTime] = weatherInfo
                        case "4":
                            // 흐림
                            weatherInfo[Constants.today_key_Sky] = Weather.Cloudy.convertName().subs
                            weatherInfo[Constants.today_key_SkyCode] = Weather.Cloudy.convertName().code
                            weatherInfo[Constants.today_key_ImageCode] = Weather.Cloudy.convertName().code
                            totalWeatherInfo[fcstTime] = weatherInfo
                        default:
                            weatherInfo[Constants.today_key_Sky] = "정보 없음"
                            totalWeatherInfo[fcstTime] = weatherInfo
                        }
                    case Constants.api_rainform :
                        let value = dataArray[i]["fcstValue"].stringValue
                        switch value {
                        case "0":
                            weatherInfo[Constants.today_key_Rainform] = ""
                            weatherInfo[Constants.today_key_RainCode] = ""
                            totalWeatherInfo[fcstTime] = weatherInfo
                        case "1":
                            weatherInfo[Constants.today_key_Rainform] = Weather.Rainy.convertName().subs
                            weatherInfo[Constants.today_key_RainCode] = Weather.Rainy.convertName().code
                            weatherInfo[Constants.today_key_ImageCode] = Weather.Rainy.convertName().code
                            totalWeatherInfo[fcstTime] = weatherInfo
                        case "2":
                            weatherInfo[Constants.today_key_Rainform] = Weather.Sleet.convertName().subs
                            weatherInfo[Constants.today_key_RainCode] = Weather.Sleet.convertName().code
                            weatherInfo[Constants.today_key_ImageCode] = Weather.Sleet.convertName().code
                            totalWeatherInfo[fcstTime] = weatherInfo
                        case "3":
                            weatherInfo[Constants.today_key_Rainform] = Weather.Snow.convertName().subs
                            weatherInfo[Constants.today_key_RainCode] = Weather.Snow.convertName().code
                            weatherInfo[Constants.today_key_ImageCode] = Weather.Snow.convertName().code
                            totalWeatherInfo[fcstTime] = weatherInfo
                        default:
                            weatherInfo[Constants.today_key_Rainform] = "정보 없음"
                            totalWeatherInfo[fcstTime] = weatherInfo
                        }
                    default:
                        continue
                    }
                }
                
                var timeString = ""
                // 현재 시각에 따라 불러지는 데이터 형식이 달라지는것에 대비.
                if Int(min)! < 30 {
                    let setTime = Int(time)!
                    if setTime < 10 {
                        time = "0"+"\(setTime)"
                    }
                }
                else {
                    let setTime = Int(time)! + 1
                    if setTime > 24 {
                        time = "0000"
                    } else if setTime < 10 {
                        time = "0"+"\(setTime)"
                    } else {
                        time = "\(setTime)"
                    }
                }
                
                timeString = time + "00"
                
                guard let temp = totalWeatherInfo[timeString]?["today_key_presentTemp"] else {return}
                guard let imageString = totalWeatherInfo[timeString]?["today_key_ImageCode"] else {return}

                let todayWeatherInfo: CurrentWeather = CurrentWeather(temp: temp, imageString: imageString)
                completed(todayWeatherInfo)
                
                var weatherCache:[String:String] = [:]
                weatherCache["temp"] = temp
                weatherCache["imageString"] = imageString
                UserDefaults.standard.set(weatherCache, forKey: "weatherCache")
                print("날씨 cache 완료")
            }
        }
    }
    
    
    func getYesterdayWeather(lat: String, long: String, completed: @escaping (_ yesterdayinfo: YesterdayWeather) -> Void) {
        getCurrunt(base: makeYesterdatyAPIParameter(lat: lat, lon: long)) { (dataArray) in
            print("어제 날씨 받아오기 시작")
            let now = Date()
            let dateFommater = DateFormatter()
            let timeFommater = DateFormatter()
            let minFommater = DateFormatter()
            dateFommater.dateFormat = "yyyyMMdd"
            timeFommater.dateFormat = "HH"
            minFommater.dateFormat = "mm"
            //한국시간으로 맞춰주기
            dateFommater.timeZone = TimeZone(secondsFromGMT: 9 * 60 * 60)
            // time은 hour단위
            var time:String = timeFommater.string(from: now)
            let yesterday = now.addingTimeInterval(-24 * 60 * 60)
            var timeYesterday:String = timeFommater.string(from: yesterday)
            // 공공데이터포털의 데이터 특성 때문..
            timeYesterday = String(Int(timeYesterday)! + 2)
            let min:String = minFommater.string(from: now)
            let temp = YesterdayWeather.empty
            
            var weatherInfo: [String:String] = [:]
            var totalWeatherInfo: [String:[String:String]] = [:]
            
            if dataArray.count == 0 {
                completed(temp)
            } else {
                for i in 0...dataArray.count - 1 {
                    let fcstTime = dataArray[i]["fcstTime"].stringValue
                    switch dataArray[i]["category"].stringValue {
                    case Constants.api_presentTemp :
                        let value = dataArray[i]["fcstValue"].stringValue
                        weatherInfo[Constants.today_key_presentTemp] = self.roundedTemperature(from: value)
                        totalWeatherInfo[fcstTime] = weatherInfo
                    default:
                        continue
                    }
                }
                
                var timeString = ""
                // 현재 시각에 따라 불러지는 데이터 형식이 달라지는것에 대비.
                if Int(min)! < 30 {
                    let setTime = Int(timeYesterday)!
                    if setTime < 10 {
                        timeYesterday = "0"+"\(setTime)"
                    }
                }
                else {
                    let setTime = Int(timeYesterday)!
                    if setTime > 23 {
                        timeYesterday = "0000"
                    } else if setTime < 10 {
                        timeYesterday = "0"+"\(setTime)"
                    } else {
                        timeYesterday = "\(setTime)"
                    }
                }
                
                timeString = timeYesterday + "00"
                
                guard let temp = totalWeatherInfo[timeString]?["today_key_presentTemp"] else {return}
                let yesterdayWeatherInfo: YesterdayWeather = YesterdayWeather(yesterday_temp: temp)
                completed(yesterdayWeatherInfo)

            }
        }
    }
    
    
    private func roundedTemperature(from temperature:String) -> String {
        var result:String = ""
        if let doubleTemperature:Double = Double(temperature) {
            let intTemperature:Int = Int(doubleTemperature.rounded())
            result = "\(intTemperature)"
        }
        return result
    }
    
    
    //MARK: - 위도경도 좌표변환뻘짓 함수. 기상청이 제공한 소스를 swift 버전으로 수정해본것.
    private func convertGrid(code:String, v1:Double, v2:Double) -> [String:Double] {
        // LCC DFS 좌표변환을 위한 기초 자료
        let RE = 6371.00877 // 지구 반경(km)
        let GRID = 5.0 // 격자 간격(km)
        let SLAT1 = 30.0 // 투영 위도1(degree)
        let SLAT2 = 60.0 // 투영 위도2(degree)
        let OLON = 126.0 // 기준점 경도(degree)
        let OLAT = 38.0 // 기준점 위도(degree)
        let XO = 43 // 기준점 X좌표(GRID)
        let YO = 136 // 기1준점 Y좌표(GRID)
        //
        //
        // LCC DFS 좌표변환 ( code : "toXY"(위경도->좌표, v1:위도, v2:경도), "toLL"(좌표->위경도,v1:x, v2:y) )
        //
        let DEGRAD = Double.pi / 180.0
        let RADDEG = 180.0 / Double.pi

        let re = RE / GRID
        let slat1 = SLAT1 * DEGRAD
        let slat2 = SLAT2 * DEGRAD
        let olon = OLON * DEGRAD
        let olat = OLAT * DEGRAD

        var sn = tan(Double.pi * 0.25 + slat2 * 0.5) / tan(Double.pi * 0.25 + slat1 * 0.5)
        sn = log(cos(slat1) / cos(slat2)) / log(sn)
        var sf = tan(Double.pi * 0.25 + slat1 * 0.5)
        sf = pow(sf, sn) * cos(slat1) / sn
        var ro = tan(Double.pi * 0.25 + olat * 0.5)
        ro = re * sf / pow(ro, sn)
        var rs:[String:Double] = [:]
        var theta = v2 * DEGRAD - olon
        if (code == "toXY") {

            rs["lat"] = v1
            rs["lng"] = v2
            var ra = tan(Double.pi * 0.25 + (v1) * DEGRAD * 0.5)
            ra = re * sf / pow(ra, sn)
            if (theta > Double.pi) {
                theta -= 2.0 * Double.pi
            }
            if (theta < -Double.pi) {
                theta += 2.0 * Double.pi
            }
            theta *= sn
            rs["nx"] = floor(ra * sin(theta) + Double(XO) + 0.5)
            rs["ny"] = floor(ro - ra * cos(theta) + Double(YO) + 0.5)
        }
        else {
            rs["nx"] = v1
            rs["ny"] = v2
            let xn = v1 - Double(XO)
            let yn = ro - v2 + Double(YO)
            let ra = sqrt(xn * xn + yn * yn)
            if (sn < 0.0) {
                sn - ra
            }
            var alat = pow((re * sf / ra), (1.0 / sn))
            alat = 2.0 * atan(alat) - Double.pi * 0.5

            if (abs(xn) <= 0.0) {
                theta = 0.0
            }
            else {
                if (abs(yn) <= 0.0) {
                    let theta = Double.pi * 0.5
                    if (xn < 0.0){
                        xn - theta
                    }
                }
                else{
                    theta = atan2(xn, yn)
                }
            }
            let alon = theta / sn + olon
            rs["lat"] = alat * RADDEG
            rs["lng"] = alon * RADDEG
        }
        return rs
    }


    func makeCurruntAPIParameter(lat:String, lon:String) -> [String:String] {
        let now = Date()
        let dateFommater = DateFormatter()
        let timeFommater = DateFormatter()
        let minFommater = DateFormatter()
        let yesterday = now.addingTimeInterval(-24 * 60 * 60)
        var nx = ""
        var ny = ""

        dateFommater.dateFormat = "yyyyMMdd"
        timeFommater.dateFormat = "HH"
        minFommater.dateFormat = "mm"

        dateFommater.timeZone = TimeZone(secondsFromGMT: 9 * 60 * 60)

        var date:String = dateFommater.string(from: now)
        var time:String = timeFommater.string(from: now)
        let min:String = minFommater.string(from: now)
        let setYesterday = dateFommater.string(from: yesterday)

        if let lat = Double(lat), let lon = Double(lon) {
            nx = "\(Int(convertGrid(code: "toXY", v1: lat, v2: lon)["nx"]!))"
            ny = "\(Int(convertGrid(code: "toXY", v1: lat, v2: lon)["ny"]!))"
        }

        // 데이터 불러오는 특성때문(공공데이터 특성)
        if Int(min)! < 30 {
            let setTime = Int(time)! - 1
            if setTime < 0 {
                date = setYesterday
                time = "23"
            } else if setTime < 10 {
                time = "0"+"\(setTime)"
            } else {
                time = "\(setTime)"
            }
        }
        time = time + "00"
        
        let appid = WeatherData.appKey
        let parameter = ["ServiceKey":appid.removingPercentEncoding!,
                         "base_date":date,
                         "base_time":time,
                         "pageNo": "1",
                         "numOfRows": "999",
                         "nx":nx,
                         "ny":ny,
                         "dataType":"JSON"]
    //    UserDefaults.standard.setValue(parameter, forKey: DataShare.parameterCurrunt)
        return parameter
    }
    
    func makeYesterdatyAPIParameter(lat:String, lon:String) -> [String:String] {
        let now = Date()
        let dateFommater = DateFormatter()
        let timeFommater = DateFormatter()
        let minFommater = DateFormatter()
        let yesterday = now.addingTimeInterval(-24 * 60 * 60)
        let twodaysBefore = now.addingTimeInterval(-48 * 60 * 60)
        var nx = ""
        var ny = ""

        dateFommater.dateFormat = "yyyyMMdd"
        timeFommater.dateFormat = "HH"
        minFommater.dateFormat = "mm"

        dateFommater.timeZone = TimeZone(secondsFromGMT: 9 * 60 * 60)

        let min:String = minFommater.string(from: now)
        let today = dateFommater.string(from: now)
        var setYesterday = dateFommater.string(from: yesterday)
        var timeYesterday:String = timeFommater.string(from: yesterday)
        timeYesterday = String(Int(timeYesterday)! + 1)

        if let lat = Double(lat), let lon = Double(lon) {
            nx = "\(Int(convertGrid(code: "toXY", v1: lat, v2: lon)["nx"]!))"
            ny = "\(Int(convertGrid(code: "toXY", v1: lat, v2: lon)["ny"]!))"
        }
        
        // 데이터 불러오는 특성때문(공공데이터 특성)
        if Int(min)! < 30 {
            let setTime = Int(timeYesterday)!
            if setTime > 23 {
                setYesterday = today
                timeYesterday = "00"
            } else if setTime < 10 {
                timeYesterday = "0"+"\(timeYesterday)"
            } else {
                timeYesterday = "\(timeYesterday)"
            }
        }
        timeYesterday = timeYesterday + "00"
        
        let appid = WeatherData.appKey
        let parameter = ["ServiceKey":appid.removingPercentEncoding!,
                         "base_date":setYesterday,
                         "base_time":timeYesterday,
                         "pageNo": "1",
                         "numOfRows": "999",
                         "nx":nx,
                         "ny":ny,
                         "dataType":"JSON"]
    //    UserDefaults.standard.setValue(parameter, forKey: DataShare.parameterCurrunt)
        return parameter
    }
}








