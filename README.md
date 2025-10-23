# HandyJSON


HandyJSON is a framework written in Swift which to make converting model objects( **pure classes/structs** ) to and from JSON easy on iOS.

Compared with others, the most significant feature of HandyJSON is that it does not require the objects inherit from NSObject(**not using KVC but reflection**), neither implements a 'mapping' function(**writing value to memory directly to achieve property assignment**).

HandyJSON is totally depend on the memory layout rules infered from Swift runtime code. We are watching it and will follow every bit if it changes.


## Sample Code

### Deserialization

```swift
class BasicTypes: HandyJSON {
    var int: Int = 2
    var doubleOptional: Double?
    var stringImplicitlyUnwrapped: String!

    required init() {}
}

let jsonString = "{\"doubleOptional\":1.1,\"stringImplicitlyUnwrapped\":\"hello\",\"int\":1}"
if let object = BasicTypes.deserialize(from: jsonString) {
    print(object.int)
    print(object.doubleOptional!)
    print(object.stringImplicitlyUnwrapped)
}
```

### Serialization

```swift

let object = BasicTypes()
object.int = 1
object.doubleOptional = 1.1
object.stringImplicitlyUnwrapped = “hello"

print(object.toJSON()!) // serialize to dictionary
print(object.toJSONString()!) // serialize to JSON string
print(object.toJSONString(prettyPrint: true)!) // serialize to pretty JSON string
```


# Features

* Serialize/Deserialize Object/JSON to/From JSON/Object

* Naturally use object property name for mapping, no need to specify a mapping relationship

* Support almost all types in Swift, including enum

* Support struct

* Custom transformations

* Type-Adaption, such as string json field maps to int property, int json field maps to string property

An overview of types supported can be found at file: [BasicTypes.swift](./HandyJSONTest/BasicTypes.swift)

# Requirements

* iOS 8.0+/OSX 10.9+/watchOS 2.0+/tvOS 9.0+

* Swift 3.0+ / Swift 4.0+ / Swift 5.0+

# Installation

**To use with Swift 5.0/5.1 ( Xcode 10.2+/11.0+ ), version == 5.0.2**

**To use with Swift 4.2 ( Xcode 10 ), version == 4.2.0**

**To use with Swift 4.0, version >= 4.1.1**

**To use with Swift 3.x, version >= 1.8.0**

For Legacy Swift2.x support, take a look at the [swift2 branch](https://github.com/alibaba/HandyJSON/tree/master_for_swift_2x).

## Cocoapods

Add the following line to your `Podfile`:

```
pod 'HandyJSON', '~> 5.0.2'
```

Then, run the following command:

```
$ pod install
```

## Carthage

You can add a dependency on `HandyJSON` by adding the following line to your `Cartfile`:

```
github "alibaba/HandyJSON" ~> 5.0.2
```

## Manually

You can integrate `HandyJSON` into your project manually by doing the following steps:

* Open up `Terminal`, `cd` into your top-level project directory, and add `HandyJSON` as a submodule:

```
git init && git submodule add https://github.com/alibaba/HandyJSON.git
```

* Open the new `HandyJSON` folder, drag the `HandyJSON.xcodeproj` into the `Project Navigator` of your project.

* Select your application project in the `Project Navigator`, open the `General` panel in the right window.

* Click on the `+` button under the `Embedded Binaries` section.

* You will see two different `HandyJSON.xcodeproj` folders each with four different versions of the HandyJSON.framework nested inside a Products folder.
> It does not matter which Products folder you choose from, but it does matter which HandyJSON.framework you choose.

* Select one of the four `HandyJSON.framework` which matches the platform your Application should run on.

* Congratulations!

# Deserialization

## The Basics

To support deserialization from JSON, a class/struct need to conform to 'HandyJSON' protocol. It's truly protocol, not some class inherited from NSObject.

To conform to 'HandyJSON', a class need to implement an empty initializer.

```swift
class BasicTypes: HandyJSON {
    var int: Int = 2
    var doubleOptional: Double?
    var stringImplicitlyUnwrapped: String!

    required init() {}
}

let jsonString = "{\"doubleOptional\":1.1,\"stringImplicitlyUnwrapped\":\"hello\",\"int\":1}"
if let object = BasicTypes.deserialize(from: jsonString) {
    // …
}
```

## Support Struct

For struct, since the compiler provide a default empty initializer, we use it for free.

```swift
struct BasicTypes: HandyJSON {
    var int: Int = 2
    var doubleOptional: Double?
    var stringImplicitlyUnwrapped: String!
}

let jsonString = "{\"doubleOptional\":1.1,\"stringImplicitlyUnwrapped\":\"hello\",\"int\":1}"
if let object = BasicTypes.deserialize(from: jsonString) {
    // …
}
```

But also notice that, if you have a designated initializer to override the default one in the struct, you should explicitly declare an empty one(no `required` modifier need).

## Support Enum Property

To be convertable, An `enum` must conform to `HandyJSONEnum` protocol. Nothing special need to do now.

```swift
enum AnimalType: String, HandyJSONEnum {
    case Cat = "cat"
    case Dog = "dog"
    case Bird = "bird"
}

struct Animal: HandyJSON {
    var name: String?
    var type: AnimalType?
}

let jsonString = "{\"type\":\"cat\",\"name\":\"Tom\"}"
if let animal = Animal.deserialize(from: jsonString) {
    print(animal.type?.rawValue)
}
```

## Optional/ImplicitlyUnwrappedOptional/Collections/...

'HandyJSON' support classes/structs composed of `optional`, `implicitlyUnwrappedOptional`, `array`, `dictionary`, `objective-c base type`, `nested type` etc. properties.

```swift
class BasicTypes: HandyJSON {
    var bool: Bool = true
    var intOptional: Int?
    var doubleImplicitlyUnwrapped: Double!
    var anyObjectOptional: Any?

    var arrayInt: Array<Int> = []
    var arrayStringOptional: Array<String>?
    var setInt: Set<Int>?
    var dictAnyObject: Dictionary<String, Any> = [:]

    var nsNumber = 2
    var nsString: NSString?

    required init() {}
}

let object = BasicTypes()
object.intOptional = 1
object.doubleImplicitlyUnwrapped = 1.1
object.anyObjectOptional = "StringValue"
object.arrayInt = [1, 2]
object.arrayStringOptional = ["a", "b"]
object.setInt = [1, 2]
object.dictAnyObject = ["key1": 1, "key2": "stringValue"]
object.nsNumber = 2
object.nsString = "nsStringValue"

let jsonString = object.toJSONString()!

if let object = BasicTypes.deserialize(from: jsonString) {
    // ...
}
```

## Designated Path

`HandyJSON` supports deserialization from designated path of JSON.

```swift
class Cat: HandyJSON {
    var id: Int64!
    var name: String!

    required init() {}
}

let jsonString = "{\"code\":200,\"msg\":\"success\",\"data\":{\"cat\":{\"id\":12345,\"name\":\"Kitty\"}}}"

if let cat = Cat.deserialize(from: jsonString, designatedPath: "data.cat") {
    print(cat.name)
}
```

## Composition Object

Notice that all the properties of a class/struct need to deserialized should be type conformed to `HandyJSON`.

```swift
class Component: HandyJSON {
    var aInt: Int?
    var aString: String?

    required init() {}
}

class Composition: HandyJSON {
    var aInt: Int?
    var comp1: Component?
    var comp2: Component?

    required init() {}
}

let jsonString = "{\"num\":12345,\"comp1\":{\"aInt\":1,\"aString\":\"aaaaa\"},\"comp2\":{\"aInt\":2,\"aString\":\"bbbbb\"}}"

if let composition = Composition.deserialize(from: jsonString) {
    print(composition)
}
```

## Inheritance Object

A subclass need deserialization, it's superclass need to conform to `HandyJSON`.

```swift
class Animal: HandyJSON {
    var id: Int?
    var color: String?

    required init() {}
}

class Cat: Animal {
    var name: String?

    required init() {}
}

let jsonString = "{\"id\":12345,\"color\":\"black\",\"name\":\"cat\"}"

if let cat = Cat.deserialize(from: jsonString) {
    print(cat)
}
```

## JSON Array

If the first level of a JSON text is an array, we turn it to objects array.

```swift
class Cat: HandyJSON {
    var name: String?
    var id: String?

    required init() {}
}

let jsonArrayString: String? = "[{\"name\":\"Bob\",\"id\":\"1\"}, {\"name\":\"Lily\",\"id\":\"2\"}, {\"name\":\"Lucy\",\"id\":\"3\"}]"
if let cats = [Cat].deserialize(from: jsonArrayString) {
    cats.forEach({ (cat) in
        // ...
    })
}
```

## Mapping From Dictionary

`HandyJSON` support mapping swift dictionary to model.

```swift
var dict = [String: Any]()
dict["doubleOptional"] = 1.1
dict["stringImplicitlyUnwrapped"] = "hello"
dict["int"] = 1
if let object = BasicTypes.deserialize(from: dict) {
    // ...
}
```

## Custom Mapping

`HandyJSON` let you customize the key mapping to JSON fields, or parsing method of any property. All you need to do is implementing an optional `mapping` function, do things in it.

We bring the transformer from [`ObjectMapper`](https://github.com/Hearst-DD/ObjectMapper). If you are familiar with it, it’s almost the same here.

```swift
class Cat: HandyJSON {
    var id: Int64!
    var name: String!
    var parent: (String, String)?
    var friendName: String?

    required init() {}

    func mapping(mapper: HelpingMapper) {
        // specify 'cat_id' field in json map to 'id' property in object
        mapper <<<
            self.id <-- "cat_id"

        // specify 'parent' field in json parse as following to 'parent' property in object
        mapper <<<
            self.parent <-- TransformOf<(String, String), String>(fromJSON: { (rawString) -> (String, String)? in
                if let parentNames = rawString?.characters.split(separator: "/").map(String.init) {
                    return (parentNames[0], parentNames[1])
                }
                return nil
            }, toJSON: { (tuple) -> String? in
                if let _tuple = tuple {
                    return "\(_tuple.0)/\(_tuple.1)"
                }
                return nil
            })

        // specify 'friend.name' path field in json map to 'friendName' property
        mapper <<<
            self.friendName <-- "friend.name"
    }
}

let jsonString = "{\"cat_id\":12345,\"name\":\"Kitty\",\"parent\":\"Tom/Lily\",\"friend\":{\"id\":54321,\"name\":\"Lily\"}}"

if let cat = Cat.deserialize(from: jsonString) {
    print(cat.id)
    print(cat.parent)
    print(cat.friendName)
}
```

## Date/Data/URL/Decimal/Color

`HandyJSON` prepare some useful transformer for some none-basic type.

```swift
class ExtendType: HandyJSON {
    var date: Date?
    var decimal: NSDecimalNumber?
    var url: URL?
    var data: Data?
    var color: UIColor?

    func mapping(mapper: HelpingMapper) {
        mapper <<<
            date <-- CustomDateFormatTransform(formatString: "yyyy-MM-dd")

        mapper <<<
            decimal <-- NSDecimalNumberTransform()

        mapper <<<
            url <-- URLTransform(shouldEncodeURLString: false)

        mapper <<<
            data <-- DataTransform()

        mapper <<<
            color <-- HexColorTransform()
    }

    public required init() {}
}

let object = ExtendType()
object.date = Date()
object.decimal = NSDecimalNumber(string: "1.23423414371298437124391243")
object.url = URL(string: "https://www.aliyun.com")
object.data = Data(base64Encoded: "aGVsbG8sIHdvcmxkIQ==")
object.color = UIColor.blue

print(object.toJSONString()!)
// it prints:
// {"date":"2017-09-11","decimal":"1.23423414371298437124391243","url":"https:\/\/www.aliyun.com","data":"aGVsbG8sIHdvcmxkIQ==","color":"0000FF"}

let mappedObject = ExtendType.deserialize(from: object.toJSONString()!)!
print(mappedObject.date)
...
```


