//
//  API.swift
//  MovieDatabase
//
//  Created by Berk Pehlivanoğlu on 26.09.2022.
//

import Moya
import Alamofire

final class API {

    /// Whether internet is reachable or not.
    static var isReachable: Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }

    static let movieProvider = MoyaProvider<MovieService>()

}

