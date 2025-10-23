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
