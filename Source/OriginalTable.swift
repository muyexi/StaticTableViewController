import UIKit

class OriginalTable {

    var sections: [OriginalSection]
    
    var tableView: UITableView
    
    var insertIndexPaths: [NSIndexPath]
    
    var deleteIndexPaths: [NSIndexPath]
    
    var updateIndexPaths: [NSIndexPath]

    init(tableView: UITableView) {
        sections = Array(count: tableView.numberOfSections, repeatedValue: OriginalSection())
        
        var totalNumberOfRows: Int = 0
        for i in 0..<tableView.numberOfSections {
            let section = OriginalSection()
            let numberOfRows = tableView.numberOfRowsInSection(i)
            
            totalNumberOfRows += numberOfRows
            section.rows = Array(count: numberOfRows, repeatedValue: OriginalRow())
            
            for ii in 0..<numberOfRows {
                let indexPath = NSIndexPath(forRow: ii, inSection: i)
                let cell = tableView.dataSource!.tableView(tableView, cellForRowAtIndexPath: indexPath)
                
                let row = OriginalRow(cell: cell, originalIndexPath: indexPath)
                section.rows![ii] = row
            }
            
            sections[i] = section
        }
        
        insertIndexPaths = Array(count: totalNumberOfRows, repeatedValue: NSIndexPath())
        deleteIndexPaths = Array(count: totalNumberOfRows, repeatedValue: NSIndexPath())
        updateIndexPaths = Array(count: totalNumberOfRows, repeatedValue: NSIndexPath())
        
        self.tableView = tableView
    }
    
    func originalRowWithIndexPath(indexPath: NSIndexPath) -> OriginalRow {
        let section = sections[indexPath.section]
        let row = section.rows![indexPath.row]
        
        return row
    }
    
    func vissibleOriginalRowWithIndexPath(indexPath: NSIndexPath) -> OriginalRow {
        let section = sections[indexPath.section]
        let visibleRows = section.rows!.filter { !$0.hidden }
        
        return visibleRows[indexPath.row]
    }

    func originalRowWithTableViewCell(cell: UITableViewCell) -> OriginalRow {
        let allRows = sections.flatMap { $0.rows! }
        
        return allRows.filter { $0.cell === cell }.first!
    }
    
    func indexPathForInsertingOriginalRow(originalRow: OriginalRow) -> NSIndexPath {
        let indexSection = originalRow.originalIndexPath!.section
        var indexRow = originalRow.originalIndexPath!.row
        
        let section = sections[indexSection]
        indexRow = section.rows![0..<indexRow].filter { !$0.hidden }.count
        
        return NSIndexPath(forRow: indexRow, inSection: indexSection)
    }
    
    func indexPathForDeletingOriginalRow(originalRow: OriginalRow) -> NSIndexPath {
        let indexSection = originalRow.originalIndexPath!.section
        var indexRow = originalRow.originalIndexPath!.row
        
        let section = sections[indexSection]
        indexRow = section.rows![0..<indexRow].filter { !$0.hiddenReal }.count
        
        return NSIndexPath(forRow: indexRow, inSection: indexSection)
    }
    
    func prepareUpdates() {
        insertIndexPaths.removeAll()
        deleteIndexPaths.removeAll()
        updateIndexPaths.removeAll()
        
        let allRows = sections.flatMap { $0.rows! }
        
        insertIndexPaths = allRows.filter {
            $0.batchOperation == BatchOperation.Insert
        }.map {
            indexPathForInsertingOriginalRow($0)
        }
        deleteIndexPaths = allRows.filter {
            $0.batchOperation == BatchOperation.Delete
        }.map {
            indexPathForDeletingOriginalRow($0)
        }
        updateIndexPaths = allRows.filter {
            $0.batchOperation == BatchOperation.Update
        }.map {
            indexPathForInsertingOriginalRow($0)
        }
        
        allRows.forEach { row in
            row.hiddenReal = row.hiddenPlanned
            row.batchOperation = BatchOperation.None
        }
    }
    
}
