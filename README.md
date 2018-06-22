
[![CocoaPods](https://img.shields.io/cocoapods/v/StaticTableViewController.svg)](https://img.shields.io/cocoapods/v/StaticTableViewController.svg)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![license](https://img.shields.io/github/license/mashape/apistatus.svg?maxAge=2592000)](https://github.com/muyexi/StaticTableViewController/blob/master/LICENSE)

Hide cells of static UITableViewController

## Installation

### CocoaPods

```ruby
pod 'StaticTableViewController'
```

### Carthage

```ogdl
github "muyexi/StaticTableViewController"
```

### Swift Package Manager

```swift
dependencies: [
    .Package(url: "https://github.com/muyexi/StaticTableViewController.git", majorVersion: 0)
]
```

## Usage

Show/hide cells with outlet connections

```swift
cell(outletStaticCell1, hidden: true)
cells([outletStaticCell1, outletStaticCell2], hidden: true)

reloadDataAnimated(true)
```

## License

StaticTableViewController is released under the MIT license. See LICENSE for details.
