import XCTest
@testable import Demo

class DemoTests: XCTestCase {
    var viewController: ViewController!
    
    override func setUp() {
        super.setUp()
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let id = String(describing: ViewController.self)
        
        viewController = storyboard.instantiateViewController(withIdentifier: id) as! ViewController
        viewController.viewDidLoad()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testHideAndShow() {
        viewController.set(cells: viewController.hideMeCell1, hidden: true)
        viewController.reloadData(animated: true)
        
        viewController.set(cells: viewController.hideMeCell1, hidden: false)
        viewController.set(cells: viewController.hideMeCell2, hidden: true)

        viewController.reloadData(animated: true)
        
        let number = viewController.tableView.numberOfRows(inSection: 1)
        XCTAssert(number == 1)
    }
    
    func testHideSectionRows() {
        viewController.set(cells: viewController.hideMeCell3, viewController.hideMeCell4, hidden: true)
        viewController.reloadData(animated: true)
        
        let number = viewController.tableView.numberOfRows(inSection: 2)
        XCTAssert(number == 0)
    }
    
}
