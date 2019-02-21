import UIKit

open class StaticTableViewController: UITableViewController, TableViewConfigDelegate {
    
    open var animateSectionHeaders = false
    
    open var insertAnimation: UITableView.RowAnimation = .fade
    open var deleteAnimation: UITableView.RowAnimation = .fade
    open var reloadAnimation: UITableView.RowAnimation = .fade
    
    var tableViewWrapper: TableViewWrapper?
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewWrapper = TableViewWrapper(tableView: tableView, configDelegate: self)
    }
    
    open func update(cells: UITableViewCell...) {
        update(cells: cells)
    }
    
    open func set(cells: UITableViewCell..., hidden: Bool) {
        set(cells: cells, hidden: hidden)
    }
    
    open func set(cells: UITableViewCell..., height: CGFloat) {
        set(cells: cells, height: height)
    }
    
    open func update(cells: [UITableViewCell]) {
        cells.forEach { cell in
            tableViewWrapper?.row(with: cell).update()
        }
    }
    
    open func set(cells: [UITableViewCell], hidden: Bool) {
        cells.forEach { (cell: UITableViewCell) in
            tableViewWrapper?.row(with: cell).hiding = hidden
        }
    }
    
    open func set(cells: [UITableViewCell], height: CGFloat) {
        cells.forEach { (cell: UITableViewCell) in
            tableViewWrapper?.row(with: cell).height = height
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
        if let wrapper = tableViewWrapper {
            return wrapper.sections.filter { $0.rows.count != 0 }.count
        } else {
            return super.numberOfSections(in: tableView)
        }
    }
    
    override open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let wrapper = tableViewWrapper {
            return wrapper.sections[section].numberOfVisibleRows()
        } else {
            return super.tableView(tableView, numberOfRowsInSection: section)
        }
    }
    
    override open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let wrapper = tableViewWrapper {
            return wrapper.visibleRow(with: indexPath).cell
        } else {
            return super.tableView(tableView, cellForRowAt: indexPath)
        }
    }
    
    override open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let wrapper = tableViewWrapper {
            let row = wrapper.visibleRow(with: indexPath)

            if row.height != CGFloat.greatestFiniteMagnitude {
                return row.height
            } else {
                return super.tableView(tableView, heightForRowAt: row.indexPath)
            }
        } else {
            return super.tableView(tableView, heightForRowAt: indexPath)
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

    func isSectionEmpty(_ section: Int) -> Bool {
        return tableView.dataSource?.tableView(tableView, numberOfRowsInSection: section) == 0
    }
    
    override open func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if isSectionEmpty(section) {
            return nil
        } else {
            return super.tableView(tableView, titleForHeaderInSection: section)
        }
    }
    
    override open func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if isSectionEmpty(section) {
            return nil
        } else {
            return super.tableView(tableView, titleForFooterInSection: section)
        }
    }
    
    func headerFooterHeightForSection(_ section: Int, height: CGFloat) -> CGFloat {
        let section = tableViewWrapper?.sections[section]
        if section?.numberOfVisibleRows() == 0 {
            return 0
        } else {
            return height
        }
    }

}
