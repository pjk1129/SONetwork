# SONetwork
SONetwork is an HTTP networking library based URLSession written  in Swift.


## Usage

### 1.Installation

#### a. 通过pod管理：SONetwork is available through [CocoaPods](http://cocoapods.org). To install it, simply add the following line to your Podfile:

```ruby
pod 'SONetwork', '~> 0.1.0'
```
#### b. 直接引用SONetwork类文件到您的工程中

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
### 3.Demo工程说明
#### 示例工程首页使用某个项目中的api展示，在源代码中api和host作了匿名处理；
#### 该工程结构可作为一个基础的iOS开发框架使用，文件组织示例代码对初级工程师有些许参考价值，大神绕道忽略

## Author

iJecky <http://weibo.com/rubbishpicker>

## License

SONetwork is available under the MIT license. See the [LICENSE](LICENSE) file for more info.
