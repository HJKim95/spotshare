//
//  WeatherModel.swift
//  SpotShare
//
//  Created by 김희중 on 2020/03/12.
//  Copyright © 2020 김희중. All rights reserved.
//

import Foundation

struct Constants {
    
    //- for API
    
    static let api_presentTemp:String = "T1H"
    static let api_sky:String = "SKY"
    static let api_rainform:String = "PTY"
    
    //- today
    static let today_key_presentTemp = "today_key_presentTemp"
    static let today_key_Sky:String = "today_key_Sky"
    static let today_key_SkyCode:String = "today_key_Code"
    static let today_key_Rainform:String = "today_key_RainForm"
    static let today_key_RainCode:String = "today_key_RainCode"
    static let today_key_ImageCode:String = "today_key_ImageCode"
    
    //- yesterday
    static let yesterday_key_Max:String = "yesterday_key_Max"
    static let yesterday_key_Min:String = "yesterday_key_Min"
    static let yesterday_key_Sky:String = "yesterday_key_Sky"
    static let yesterday_key_Rainform:String = "yesterday_key_RainForm"
    
}

struct CurrentWeather {
    let temp: String
    let imageString: String
    
    static let empty = CurrentWeather(temp: "0", imageString: "")
}

struct YesterdayWeather {
    let yesterday_temp: String
    
    static let empty = YesterdayWeather(yesterday_temp: "0")
}


enum Weather {
    case Sunny
    case LittleCloudy
    case MoreCloudy
    case Cloudy
    case ClearNight
    case LittleCloudyNight
    case Rainy
    case Sleet
    case Snow
    
    func convertName() -> (code:String, subs:String){
        switch self {
        case .Sunny:
            return ("SKY_D01","맑음")
        case .LittleCloudy:
            return ("SKY_D02","구름 조금")
        case .MoreCloudy:
            return ("SKY_D03","구름 많음")
        case .Cloudy:
            return ("SKY_D04","흐림")
        case .ClearNight:
            return ("SKY_D08","맑음")
        case .LittleCloudyNight:
            return ("SKY_D09","구름 조금")
        case .Rainy:
            return ("RAIN_D01","비")
        case .Sleet:
            return ("RAIN_D02","진눈깨비")
        case .Snow:
            return ("RAIN_D03","눈")
        }
    }
}
