# SONetwork
SONetwork is an HTTP networking library based URLSession written  in Swift.


## Usage

### 1.Installation

#### SONetwork is available through [CocoaPods](http://cocoapods.org). To install it, simply add the following line to your Podfile:


```ruby
pod 'SONetwork', '~> 0.1.0'
```
### 2.Requirements
#### iOS 9.0+ 
#### Swift 3.0+

### 3.Example
```objective-c
        SONetworking.request("POST", url: url, parameters: dic, success: { (jsonString) in
            let data = jsonString?.data(using: .utf8)!
            if let parsedData = try? JSONSerialization.jsonObject(with: data!) as! [String:Any] {
                let data = parsedData["data"] as? Array<[String:Any]>!
                var result = [SOGoodsItem]()
                for dic in data! {
                    let item = SOGoodsItem(dict: dic)
                    result.append(item)
                }
                success(result)
            } else {
                print("bad json - do some recovery")
            }
            
        }) { (error) in
            
        }
```

## Author

iJecky <http://weibo.com/rubbishpicker>

## License

SONetwork is available under the MIT license. See the [LICENSE](LICENSE) file for more info.
