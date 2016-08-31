import UIKit

public class StaticTableViewController: UITableViewController {
    
    public var hideSectionsWithHiddenRows = false
    public var animateSectionHeaders = false
    
    public var insertTableViewRowAnimation: UITableViewRowAnimation = .Fade
    public var deleteTableViewRowAnimation: UITableViewRowAnimation = .Fade
    public var reloadTableViewRowAnimation: UITableViewRowAnimation = .Fade
    
    var originalTable: OriginalTable?
    
    override init(style: UITableViewStyle) {
        super.init(style: style)
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        originalTable = OriginalTable(tableView: tableView)
    }
    
    public func updateCell(cell: UITableViewCell) {
        let row = originalTable!.originalRowWithTableViewCell(cell)
        row.update()
    }
    
    public func updateCells(cells: [UITableViewCell]) {
        cells.forEach { cell in
            updateCell(cell)
        }
    }
    
    public func cell(cell: UITableViewCell, hidden: Bool) {
        let row = originalTable!.originalRowWithTableViewCell(cell)
        row.hidden = hidden
    }
    
    public func cells(cells: [UITableViewCell], hidden: Bool) {
        cells.forEach { c in
            cell(c, hidden: hidden)
        }
    }
    
    public func cell(cell: UITableViewCell, height: CGFloat) {
        let row = originalTable!.originalRowWithTableViewCell(cell)
        row.height = height
    }
    
    public func cells(cells: [UITableViewCell], height: CGFloat) {
        cells.forEach { c in
            cell(c, height: height)
        }
    }
    
    public func cellIsHidden(cell: UITableViewCell) -> Bool {
        return originalTable!.originalRowWithTableViewCell(cell).hidden
    }
    
    public func reloadDataAnimated(animated: Bool) {
        originalTable!.prepareUpdates()
        
        if animated {
            if animateSectionHeaders {
                originalTable?.deleteIndexPaths.forEach({ indexPath in
                    let cell = tableView.cellForRowAtIndexPath(indexPath)
                    cell?.layer.zPosition = -2
                    
                    tableView.headerViewForSection(indexPath.section)?.layer.zPosition = -1
                })
            }
            
            tableView.beginUpdates()
            
            tableView.reloadRowsAtIndexPaths(originalTable!.updateIndexPaths, withRowAnimation: reloadTableViewRowAnimation)
            tableView.insertRowsAtIndexPaths(originalTable!.insertIndexPaths, withRowAnimation: insertTableViewRowAnimation)
            tableView.deleteRowsAtIndexPaths(originalTable!.deleteIndexPaths, withRowAnimation: deleteTableViewRowAnimation)
            
            tableView.endUpdates()
            
            if !animateSectionHeaders {
                tableView.reloadData()
            }
        } else {
            tableView.reloadData()
        }
    }
    
    // MARK: UITableViewDataSource
    override public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if originalTable == nil {
            return super.numberOfSectionsInTableView(tableView)
        } else {
            return originalTable!.sections.filter { $0.rows?.count != 0 }.count
        }
    }
    
    override public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if originalTable == nil {
            return super.tableView(tableView, numberOfRowsInSection: section)
        } else {
            return originalTable!.sections[section].numberOfVissibleRows()
        }
    }
    
    override public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if originalTable == nil {
            return super.tableView(tableView, cellForRowAtIndexPath: indexPath)
        } else {
            let row = originalTable?.vissibleOriginalRowWithIndexPath(indexPath)
            return row!.cell!
        }
    }
    
    override public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if originalTable == nil {
            return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
        } else {
            let row = originalTable!.vissibleOriginalRowWithIndexPath(indexPath)
            
            if row.height != CGFloat.max {
                return row.height
            } else {
                return super.tableView(tableView, heightForRowAtIndexPath: row.originalIndexPath!)
            }
        }
    }
    
    override public func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let height = super.tableView(tableView, heightForHeaderInSection: section)
        
        return headerFooterHeightForSection(section, height: height)
    }
    
    override public func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let height = super.tableView(tableView, heightForFooterInSection: section)
        
        return headerFooterHeightForSection(section, height: height)
    }
    
    override public func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if tableView.dataSource?.tableView(tableView, numberOfRowsInSection: section) == 0 {
            return nil
        } else {
            return super.tableView(tableView, titleForHeaderInSection: section)
        }
    }
    
    override public func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if tableView.dataSource?.tableView(tableView, numberOfRowsInSection: section) == 0 {
            return nil
        } else {
            return super.tableView(tableView, titleForFooterInSection: section)
        }
    }
    
    func headerFooterHeightForSection(section: Int, height: CGFloat) -> CGFloat {
        let section = originalTable?.sections[section]
        if section?.numberOfVissibleRows() == 0 {
            return 0
        } else {
            return height
        }
    }

}
