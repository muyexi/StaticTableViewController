import UIKit

open class StaticTableViewController: UITableViewController, TableViewConfig {
    
    open var animateSectionHeaders = false
    
    open var insertAnimation: UITableView.RowAnimation = .fade
    open var deleteAnimation: UITableView.RowAnimation = .fade
    open var reloadAnimation: UITableView.RowAnimation = .fade
    
    var tableViewWrapper: TableViewWrapper?
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewWrapper = TableViewWrapper(tableView: tableView, config: self)
    }
    
    open func update(cells: UITableViewCell...) {
        cells.forEach { cell in
            let row = tableViewWrapper!.row(with: cell)
            row.update()
        }
    }
    
    open func set(cells: UITableViewCell..., hidden: Bool) {
        cells.forEach { cell in
            let row = tableViewWrapper!.row(with: cell)
            row.hiding = hidden
        }
    }
    
    open func set(cells: UITableViewCell..., height: CGFloat) {
        cells.forEach { cell in
            let row = tableViewWrapper!.row(with: cell)
            row.height = height
        }
    }
    
    open func isHidden(cell: UITableViewCell) -> Bool {
        return tableViewWrapper!.row(with: cell).hidden
    }
    
    open func reloadData(animated: Bool) {
        tableViewWrapper!.reloadRows(animated: animated)
    }
    
    // MARK: UITableViewDataSource
    override open func numberOfSections(in tableView: UITableView) -> Int {
        if tableViewWrapper == nil {
            return super.numberOfSections(in: tableView)
        } else {
            return tableViewWrapper!.sections.filter { $0.rows.count != 0 }.count
        }
    }
    
    override open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableViewWrapper == nil {
            return super.tableView(tableView, numberOfRowsInSection: section)
        } else {
            return tableViewWrapper!.sections[section].numberOfVissibleRows()
        }
    }
    
    override open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableViewWrapper == nil {
            return super.tableView(tableView, cellForRowAt: indexPath)
        } else {
            let row = tableViewWrapper?.vissibleRow(with: indexPath)
            return row!.cell
        }
    }
    
    override open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableViewWrapper == nil {
            return super.tableView(tableView, heightForRowAt: indexPath)
        } else {
            let row = tableViewWrapper!.vissibleRow(with: indexPath)
            
            if row.height != CGFloat.greatestFiniteMagnitude {
                return row.height
            } else {
                return super.tableView(tableView, heightForRowAt: row.indexPath)
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
        let section = tableViewWrapper?.sections[section]
        if section?.numberOfVissibleRows() == 0 {
            return 0
        } else {
            return height
        }
    }

}
