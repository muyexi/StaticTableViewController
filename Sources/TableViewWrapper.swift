import UIKit

protocol TableViewConfigDelegate: class {
    var insertAnimation: UITableView.RowAnimation { get set }
    var deleteAnimation: UITableView.RowAnimation { get set }
    var reloadAnimation: UITableView.RowAnimation { get set }

    var animateSectionHeaders: Bool  { get set }
}

class TableViewWrapper {

    var sections: [TableSection]
    
    var tableView: UITableView
    
    var insertIndexPaths: [IndexPath]
    
    var deleteIndexPaths: [IndexPath]
    
    var reloadIndexPaths: [IndexPath]
    
    weak var configDelegate: TableViewConfigDelegate?

    init(tableView: UITableView, configDelegate: TableViewConfigDelegate) {
        sections = (0..<tableView.numberOfSections).map { section in
            let tableSection = TableSection()
            tableSection.rows = (0..<tableView.numberOfRows(inSection: section)).map { row in
                let path = IndexPath(row: row, section: section)
                return TableRow(cell: tableView.dataSource!.tableView(tableView, cellForRowAt: path), indexPath: path)
            }
            return tableSection
        }
        let paths = sections.compactMap{_ in IndexPath()}

        insertIndexPaths = paths
        deleteIndexPaths = paths
        reloadIndexPaths = paths
        
        self.tableView = tableView
        self.configDelegate = configDelegate
    }
    
    func visibleRow(with indexPath: IndexPath) -> TableRow {
        let section = sections[indexPath.section]
        let visibleRows = section.rows.filter { !$0.hiding }
        
        return visibleRows[indexPath.row]
    }

    func row(with cell: UITableViewCell) -> TableRow {
        let allRows = sections.flatMap { $0.rows }
        
        return allRows.filter { $0.cell === cell }.first!
    }
    
    func insert(row: TableRow) -> IndexPath {
        let indexSection = row.indexPath.section
        var indexRow = row.indexPath.row
        
        let section = sections[indexSection]
        indexRow = section.rows[0..<indexRow].filter { !$0.hiding }.count
        
        return IndexPath(row: indexRow, section: indexSection)
    }
    
    func delete(row: TableRow) -> IndexPath {
        let indexSection = row.indexPath.section
        var indexRow = row.indexPath.row
        
        let section = sections[indexSection]
        indexRow = section.rows[0..<indexRow].filter { !$0.hidden }.count
        
        return IndexPath(row: indexRow, section: indexSection)
    }
    
    func prepareUpdates() {
        insertIndexPaths.removeAll()
        deleteIndexPaths.removeAll()
        reloadIndexPaths.removeAll()
        
        let allRows = sections.flatMap { $0.rows }
        
        allRows.forEach { row in
            switch row.batchOperation {
            case .delete:
                deleteIndexPaths.append(delete(row: row))
            case .insert:
                insertIndexPaths.append(insert(row: row))
            case .update:
                reloadIndexPaths.append(insert(row: row))
            case .none:
                break
            }
        }
        
        allRows.forEach { (row) in
            row.hidden = row.hiding
            row.batchOperation = .none
        }
    }
    
    func reloadRows(animated: Bool) {
        guard let config = configDelegate else {
            return
        }
        prepareUpdates()
        
        if animated {
            if config.animateSectionHeaders {
                deleteIndexPaths.forEach { indexPath in
                    tableView.cellForRow(at: indexPath)?.layer.zPosition = -2
                    tableView.headerView(forSection: indexPath.section)?.layer.zPosition = -1
                }
            }
            
            tableView.beginUpdates()
            
            tableView.reloadRows(at: reloadIndexPaths, with: config.reloadAnimation)
            tableView.insertRows(at: insertIndexPaths, with: config.insertAnimation)
            tableView.deleteRows(at: deleteIndexPaths, with: config.deleteAnimation)
            
            tableView.endUpdates()
            
            if !config.animateSectionHeaders {
                tableView.reloadData()
            }
        } else {
            tableView.reloadData()
        }
    }
    
}
