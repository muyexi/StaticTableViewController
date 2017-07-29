
[![CocoaPods](https://img.shields.io/cocoapods/v/StaticTableViewController.svg?maxAge=2592000)](http://cocoadocs.org/docsets/StaticTableViewController)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![license](https://img.shields.io/github/license/mashape/apistatus.svg?maxAge=2592000)](https://github.com/muyexi/StaticTableViewController/blob/master/LICENSE)

Hide cells of static UITableViewController

## Installation

### CocoaPods

```
pod 'StaticTableViewController'
```

### Carthage

```
github "muyexi/StaticTableViewController"
```

## Usage

Show/hide cells with outlet connections

```
cell(outletStaticCell1, hidden: true)
cells([outletStaticCell1, outletStaticCell2], hidden: true)

reloadDataAnimated(true)
```

## License

StaticTableViewController is released under the MIT license. See LICENSE for details.
