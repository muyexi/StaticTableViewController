import UIKit

protocol OriginalTableConfig {
    var insertTableViewRowAnimation: UITableViewRowAnimation { get set }
    var deleteTableViewRowAnimation: UITableViewRowAnimation { get set }
    var reloadTableViewRowAnimation: UITableViewRowAnimation { get set }

    var animateSectionHeaders: Bool  { get set }
}

class OriginalTable {

    var sections: [OriginalSection]
    
    var tableView: UITableView
    
    var insertIndexPaths: [IndexPath]
    
    var deleteIndexPaths: [IndexPath]
    
    var updateIndexPaths: [IndexPath]
    
    var config: OriginalTableConfig

    init(tableView: UITableView, config: OriginalTableConfig) {
        sections = Array(repeating: OriginalSection(), count: tableView.numberOfSections)
        
        var totalNumberOfRows: Int = 0
        for i in 0..<tableView.numberOfSections {
            let section = OriginalSection()
            let numberOfRows = tableView.numberOfRows(inSection: i)
            
            totalNumberOfRows += numberOfRows
            
            for ii in 0..<numberOfRows {
                let indexPath = IndexPath(row: ii, section: i)
                let cell = tableView.dataSource!.tableView(tableView, cellForRowAt: indexPath)
                
                let row = OriginalRow(cell: cell, originalIndexPath: indexPath)
                section.rows.append(row)
            }
            
            sections[i] = section
        }
        
        insertIndexPaths = Array(repeating: IndexPath(), count: totalNumberOfRows)
        deleteIndexPaths = Array(repeating: IndexPath(), count: totalNumberOfRows)
        updateIndexPaths = Array(repeating: IndexPath(), count: totalNumberOfRows)
        
        self.tableView = tableView
        self.config = config
    }
    
    func originalRowWithIndexPath(_ indexPath: IndexPath) -> OriginalRow {
        let section = sections[indexPath.section]
        let row = section.rows[indexPath.row]
        
        return row
    }
    
    func vissibleOriginalRowWithIndexPath(_ indexPath: IndexPath) -> OriginalRow {
        let section = sections[indexPath.section]
        let visibleRows = section.rows.filter { !$0.hiddenPlanned }
        
        return visibleRows[indexPath.row]
    }

    func originalRowWithTableViewCell(_ cell: UITableViewCell) -> OriginalRow {
        let allRows = sections.flatMap { $0.rows }
        
        return allRows.filter { $0.cell === cell }.first!
    }
    
    func indexPathForInsertingOriginalRow(_ originalRow: OriginalRow) -> IndexPath {
        let indexSection = originalRow.originalIndexPath.section
        var indexRow = originalRow.originalIndexPath.row
        
        let section = sections[indexSection]
        indexRow = section.rows[0..<indexRow].filter { !$0.hiddenPlanned }.count
        
        return IndexPath(row: indexRow, section: indexSection)
    }
    
    func indexPathForDeletingOriginalRow(_ originalRow: OriginalRow) -> IndexPath {
        let indexSection = originalRow.originalIndexPath.section
        var indexRow = originalRow.originalIndexPath.row
        
        let section = sections[indexSection]
        indexRow = section.rows[0..<indexRow].filter { !$0.hiddenReal }.count
        
        return IndexPath(row: indexRow, section: indexSection)
    }
    
    func prepareUpdates() {
        insertIndexPaths.removeAll()
        deleteIndexPaths.removeAll()
        updateIndexPaths.removeAll()
        
        let allRows = sections.flatMap { $0.rows }
        
        allRows.forEach { (row) in
            if row.batchOperation == .delete {
                let indexPath = indexPathForDeletingOriginalRow(row)
                deleteIndexPaths.append(indexPath)
            } else if row.batchOperation == .insert {
                let indexPath = indexPathForInsertingOriginalRow(row)
                insertIndexPaths.append(indexPath)
            } else if row.batchOperation == .update {
                let indexPath = indexPathForInsertingOriginalRow(row)
                updateIndexPaths.append(indexPath)
            }
        }
        
        allRows.forEach { (row) in
            row.hiddenReal = row.hiddenPlanned
            row.batchOperation = BatchOperation.none
        }
    }
    
    func reloadRows(animated: Bool) {
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
            
            tableView.reloadRows(at: updateIndexPaths, with: config.reloadTableViewRowAnimation)
            tableView.insertRows(at: insertIndexPaths, with: config.insertTableViewRowAnimation)
            tableView.deleteRows(at: deleteIndexPaths, with: config.deleteTableViewRowAnimation)
            
            tableView.endUpdates()
            
            if !config.animateSectionHeaders {
                tableView.reloadData()
            }
        } else {
            tableView.reloadData()
        }
    }
    
}
