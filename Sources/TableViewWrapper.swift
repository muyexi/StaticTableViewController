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

    init(tableView: UITableView, config: TableViewConfigDelegate) {
        sections = Array(repeating: TableSection(), count: tableView.numberOfSections)
        
        var totalNumberOfRows: Int = 0
        for i in 0..<tableView.numberOfSections {
            let section = TableSection()
            let numberOfRows = tableView.numberOfRows(inSection: i)
            
            totalNumberOfRows += numberOfRows
            
            for ii in 0..<numberOfRows {
                let indexPath = IndexPath(row: ii, section: i)
                let cell = tableView.dataSource!.tableView(tableView, cellForRowAt: indexPath)
                
                let row = TableRow(cell: cell, indexPath: indexPath)
                section.rows.append(row)
            }
            
            sections[i] = section
        }
        
        insertIndexPaths = Array(repeating: IndexPath(), count: totalNumberOfRows)
        deleteIndexPaths = Array(repeating: IndexPath(), count: totalNumberOfRows)
        reloadIndexPaths = Array(repeating: IndexPath(), count: totalNumberOfRows)
        
        self.tableView = tableView
        self.configDelegate = config
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
        
        allRows.forEach { (row) in
            if row.batchOperation == .delete {
                let indexPath = delete(row: row)
                deleteIndexPaths.append(indexPath)
            } else if row.batchOperation == .insert {
                let indexPath = insert(row: row)
                insertIndexPaths.append(indexPath)
            } else if row.batchOperation == .update {
                let indexPath = insert(row: row)
                reloadIndexPaths.append(indexPath)
            }
        }
        
        allRows.forEach { (row) in
            row.hidden = row.hiding
            row.batchOperation = BatchOperation.none
        }
    }
    
    func reloadRows(animated: Bool) {
        guard let config = configDelegate else {
            return
        }
        prepareUpdates()
        
        if animated {
            if config.animateSectionHeaders {
                deleteIndexPaths.forEach({ indexPath in
                    let cell = tableView.cellForRow(at: indexPath)
                    cell?.layer.zPosition = -2
                    
                    tableView.headerView(forSection: indexPath.section)?.layer.zPosition = -1
                })
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
