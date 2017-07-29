import UIKit

open class StaticTableViewController: UITableViewController, OriginalTableConfig {
    
    open var animateSectionHeaders = false
    
    open var insertTableViewRowAnimation: UITableViewRowAnimation = .fade
    open var deleteTableViewRowAnimation: UITableViewRowAnimation = .fade
    open var reloadTableViewRowAnimation: UITableViewRowAnimation = .fade
    
    var originalTable: OriginalTable?
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        originalTable = OriginalTable(tableView: tableView, config: self)
    }
    
    open func update(cells: UITableViewCell...) {
        cells.forEach { cell in
            let row = originalTable!.originalRowWithTableViewCell(cell)
            row.update()
        }
    }
    
    open func set(cells: UITableViewCell..., hidden: Bool) {
        cells.forEach { cell in
            let row = originalTable!.originalRowWithTableViewCell(cell)
            row.set(hidden: hidden)
        }
    }
    
    open func set(cells: UITableViewCell..., height: CGFloat) {
        cells.forEach { cell in
            let row = originalTable!.originalRowWithTableViewCell(cell)
            row.height = height
        }
    }
    
    open func isHidden(cell: UITableViewCell) -> Bool {
        return originalTable!.originalRowWithTableViewCell(cell).hiddenReal
    }
    
    open func reloadData(animated: Bool) {
        originalTable!.reloadRows(animated: animated)
    }
    
    // MARK: UITableViewDataSource
    override open func numberOfSections(in tableView: UITableView) -> Int {
        if originalTable == nil {
            return super.numberOfSections(in: tableView)
        } else {
            return originalTable!.sections.filter { $0.rows.count != 0 }.count
        }
    }
    
    override open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if originalTable == nil {
            return super.tableView(tableView, numberOfRowsInSection: section)
        } else {
            return originalTable!.sections[section].numberOfVissibleRows()
        }
    }
    
    override open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if originalTable == nil {
            return super.tableView(tableView, cellForRowAt: indexPath)
        } else {
            let row = originalTable?.vissibleOriginalRowWithIndexPath(indexPath)
            return row!.cell
        }
    }
    
    override open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if originalTable == nil {
            return super.tableView(tableView, heightForRowAt: indexPath)
        } else {
            let row = originalTable!.vissibleOriginalRowWithIndexPath(indexPath)
            
            if row.height != CGFloat.greatestFiniteMagnitude {
                return row.height
            } else {
                return super.tableView(tableView, heightForRowAt: row.originalIndexPath)
            }
        }
    }
    
    override open func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let height = super.tableView(tableView, heightForHeaderInSection: section)
        
        return headerFooterHeightForSection(section, height: height)
    }
    
    override open func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let height = super.tableView(tableView, heightForFooterInSection: section)
        
        return headerFooterHeightForSection(section, height: height)
    }
    
    override open func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if tableView.dataSource?.tableView(tableView, numberOfRowsInSection: section) == 0 {
            return nil
        } else {
            return super.tableView(tableView, titleForHeaderInSection: section)
        }
    }
    
    override open func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if tableView.dataSource?.tableView(tableView, numberOfRowsInSection: section) == 0 {
            return nil
        } else {
            return super.tableView(tableView, titleForFooterInSection: section)
        }
    }
    
    func headerFooterHeightForSection(_ section: Int, height: CGFloat) -> CGFloat {
        let section = originalTable?.sections[section]
        if section?.numberOfVissibleRows() == 0 {
            return 0
        } else {
            return height
        }
    }

}
