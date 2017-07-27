import UIKit

class OriginalTable {

    var sections: [OriginalSection]
    
    var tableView: UITableView
    
    var insertIndexPaths: [IndexPath]
    
    var deleteIndexPaths: [IndexPath]
    
    var updateIndexPaths: [IndexPath]

    init(tableView: UITableView) {
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
    }
    
    func originalRowWithIndexPath(_ indexPath: IndexPath) -> OriginalRow {
        let section = sections[indexPath.section]
        let row = section.rows[indexPath.row]
        
        return row
    }
    
    func vissibleOriginalRowWithIndexPath(_ indexPath: IndexPath) -> OriginalRow {
        let section = sections[indexPath.section]
        let visibleRows = section.rows.filter { !$0.hidden }
        
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
        indexRow = section.rows[0..<indexRow].filter { !$0.hidden }.count
        
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
        
        insertIndexPaths = allRows.filter {
            $0.batchOperation == BatchOperation.insert
        }.map {
            indexPathForInsertingOriginalRow($0)
        }
        deleteIndexPaths = allRows.filter {
            $0.batchOperation == BatchOperation.delete
        }.map {
            indexPathForDeletingOriginalRow($0)
        }
        updateIndexPaths = allRows.filter {
            $0.batchOperation == BatchOperation.update
        }.map {
            indexPathForInsertingOriginalRow($0)
        }
        
        allRows.forEach { row in
            row.hiddenReal = row.hiddenPlanned
            row.batchOperation = BatchOperation.none
        }
    }
    
}
