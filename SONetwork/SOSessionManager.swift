//
//  SOSessionManager.swift
//  SwiftOne
//
//  Created by JK.PENG on 2017/3/27.
//  Copyright © 2017年 XXXXX. All rights reserved.
//

import UIKit

/// A dictionary of headers to apply to a `URLRequest`.
public typealias HTTPHeaders = [String: String]

class SOSessionManager: NSObject {

    // The underlying session.
    open let session: URLSession
    
    // The operation queue on which delegate callbacks are run.
    open let operationQueue = OperationQueue()

    // MARK: - Properties
    
    /// A default instance of `SONetworking`, used by top-level SONetworking request methods, and suitable for use
    /// directly for any ad hoc requests.
    open static let `default`: SOSessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = SOSessionManager.defaultHTTPHeaders
        return SOSessionManager(configuration: configuration)
    }()
    
    /// Creates default values for the "Accept-Encoding", "Accept-Language" and "User-Agent" headers.
    open static let defaultHTTPHeaders: HTTPHeaders = {
        // Accept-Encoding HTTP Header; see https://tools.ietf.org/html/rfc7230#section-4.2.3
        let acceptEncoding: String = "gzip;q=1.0, compress;q=0.5"
        
        // Accept-Language HTTP Header; see https://tools.ietf.org/html/rfc7231#section-5.3.5
        let acceptLanguage = Locale.preferredLanguages.prefix(6).enumerated().map { index, languageCode in
            let quality = 1.0 - (Double(index) * 0.1)
            return "\(languageCode);q=\(quality)"
            }.joined(separator: ", ")
        
        // User-Agent Header; see https://tools.ietf.org/html/rfc7231#section-5.5.3
        let userAgent: String = {
            if let info = Bundle.main.infoDictionary {
                let executable = info[kCFBundleExecutableKey as String] as? String ?? "Unknown"
                let bundle = info[kCFBundleIdentifierKey as String] as? String ?? "Unknown"
                let appVersion = info["CFBundleShortVersionString"] as? String ?? "Unknown"
                let appBuild = info[kCFBundleVersionKey as String] as? String ?? "Unknown"
                
                let osNameVersion: String = {
                    let version = ProcessInfo.processInfo.operatingSystemVersion
                    let versionString = "\(version.majorVersion).\(version.minorVersion).\(version.patchVersion)"
                    
                    let osName: String = {
                        return "iOS"
                    }()
                    return "\(osName) \(versionString)"
                }()
                
                let alamofireVersion: String = {
                    guard
                        let afInfo = Bundle(for: SOSessionManager.self).infoDictionary,
                        let build = afInfo["CFBundleShortVersionString"]
                        else { return "Unknown" }
                    
                    return "SONetworking/\(build)"
                }()
                
                return "\(executable)/\(appVersion) (\(bundle); build:\(appBuild); \(osNameVersion)) \(alamofireVersion)"
            }
            return "SONetworking"
        }()
        
        return [
            "Accept-Encoding": acceptEncoding,
            "Accept-Language": acceptLanguage,
            "User-Agent": userAgent
        ]
    }()
    
    // MARK: - Lifecycle
    public init(configuration: URLSessionConfiguration = URLSessionConfiguration.default){
        operationQueue.maxConcurrentOperationCount = 1
        self.session = URLSession(configuration: configuration, delegate: nil, delegateQueue: operationQueue)
    }
    
    func request( _ method : String = "GET",
                  url : String ,
                  parameters : Dictionary<String,AnyObject> = [:],
                  headers: HTTPHeaders? = [:],
                  success : @escaping (_ data : Data?)->Void,
                  fail:@escaping (_ error : NSError?)->Void){
        var originalURL = url
        if method == "GET" {
            originalURL += "?" + buildParams(parameters)
        }
        
        let request = NSMutableURLRequest(url: URL(string: originalURL)!)
        request.httpMethod = method
        
        if method == "POST" {
            request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.httpBody = buildParams(parameters).data(using: String.Encoding.utf8)
        }
        
        //Sets the value of the given HTTP header field.
        for (field, value) in headers! where field != "Cookie" {
            request.setValue(value, forHTTPHeaderField: field)
        }
        
        print(request.description)
        
        let dataTask = self.session.dataTask(with: request as URLRequest) {data,response,error in
            if (error != nil) {
                fail(error as NSError?)
            } else {
                if (response as! HTTPURLResponse).statusCode  == 200{
                    success(data)
                }else{
                    fail(error as NSError?)
                }
            }
        }
        dataTask.resume()
    }
    
}

public func buildParams(_ parameters: [String: Any]) -> String {
    var components: [(String, String)] = []
    
    for key in parameters.keys.sorted(by: <) {
        let value = parameters[key]!
        components += queryComponents(fromKey: key, value: value)
    }
    
    return components.map { "\($0)=\($1)" }.joined(separator: "&")
}

/// Creates percent-escaped, URL encoded query string components from the given key-value pair using recursion.
///
/// - parameter key:   The key of the query component.
/// - parameter value: The value of the query component.
///
/// - returns: The percent-escaped, URL encoded query string components.
public func queryComponents(fromKey key: String, value: Any) -> [(String, String)] {
    var components: [(String, String)] = []
    
    if let dictionary = value as? [String: Any] {
        for (nestedKey, value) in dictionary {
            components += queryComponents(fromKey: "\(key)[\(nestedKey)]", value: value)
        }
    } else if let array = value as? [Any] {
        for value in array {
            components += queryComponents(fromKey: "\(key)[]", value: value)
        }
    } else if let value = value as? NSNumber {
        if value.isBool {
            components.append((escape(key), escape((value.boolValue ? "1" : "0"))))
        } else {
            components.append((escape(key), escape("\(value)")))
        }
    } else if let bool = value as? Bool {
        components.append((escape(key), escape((bool ? "1" : "0"))))
    } else {
        components.append((escape(key), escape("\(value)")))
    }
    
    return components
}

/// Returns a percent-escaped string following RFC 3986 for a query string key or value.
///
/// RFC 3986 states that the following characters are "reserved" characters.
///
/// - General Delimiters: ":", "#", "[", "]", "@", "?", "/"
/// - Sub-Delimiters: "!", "$", "&", "'", "(", ")", "*", "+", ",", ";", "="
///
/// In RFC 3986 - Section 3.4, it states that the "?" and "/" characters should not be escaped to allow
/// query strings to include a URL. Therefore, all "reserved" characters with the exception of "?" and "/"
/// should be percent-escaped in the query string.
///
/// - parameter string: The string to be percent-escaped.
///
/// - returns: The percent-escaped string.
public func escape(_ string: String) -> String {
    let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
    let subDelimitersToEncode = "!$&'()*+,;="
    
    var allowedCharacterSet = CharacterSet.urlQueryAllowed
    allowedCharacterSet.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
    
    var escaped = ""
    
    //==========================================================================================================
    //
    //  Batching is required for escaping due to an internal bug in iOS 8.1 and 8.2. Encoding more than a few
    //  hundred Chinese characters causes various malloc error crashes. To avoid this issue until iOS 8 is no
    //  longer supported, batching MUST be used for encoding. This introduces roughly a 20% overhead. For more
    //  info, please refer to:
    //
    //      - https://github.com/Alamofire/Alamofire/issues/206
    //
    //==========================================================================================================
    
    if #available(iOS 8.3, *) {
        escaped = string.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) ?? string
    } else {
        let batchSize = 50
        var index = string.startIndex
        
        while index != string.endIndex {
            let startIndex = index
            let endIndex = string.index(index, offsetBy: batchSize, limitedBy: string.endIndex) ?? string.endIndex
            let range = startIndex..<endIndex
            
            let substring = string.substring(with: range)
            
            escaped += substring.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) ?? substring
            
            index = endIndex
        }
    }
    
    return escaped
}

// MARK: - NSNumber extension
extension NSNumber {
    fileprivate var isBool: Bool { return CFBooleanGetTypeID() == CFGetTypeID(self) }
}

