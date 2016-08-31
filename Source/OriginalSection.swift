import UIKit

class OriginalSection {
    
    var rows: [OriginalRow]?
    
    func numberOfVissibleRows() -> Int {
        return (rows?.filter { !$0.hidden }.count)!
    }
    
    func vissibleRowIndexWithTableViewCell(cell: UITableViewCell) -> Int {
        return rows!.flatMap { $0.cell }.filter { !$0.hidden }.indexOf(cell)!
    }
    
}
