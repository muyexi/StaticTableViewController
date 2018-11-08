import XCTest
@testable import Demo

class DemoTests: XCTestCase {
    lazy var viewController: ViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let id = String(describing: ViewController.self)
        
        let viewController = storyboard.instantiateViewController(withIdentifier: id) as! ViewController
        return viewController
    }()
    
    override func setUp() {
        super.setUp()
        
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
    
    func testIsHidden() {
        viewController.set(cells: viewController.hideMeCell3, hidden: true)
        viewController.reloadData(animated: true)
        
        let isHidden = viewController.isHidden(cell: viewController.hideMeCell3)
        XCTAssert(isHidden)
    }
    
    func testChangeHeight() {
        viewController.set(cells: viewController.hideMeCell3, height: 90)
        viewController.reloadData(animated: true)
        
        let height = viewController.hideMeCell3.frame.size.height
        XCTAssert(height == 90)
    }
    
}
