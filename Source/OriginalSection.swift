import UIKit

class OriginalSection {
    
    var rows: [OriginalRow]?
    
    func numberOfVissibleRows() -> Int {
        return (rows?.filter { !$0.hidden }.count)!
    }
    
    func vissibleRowIndexWithTableViewCell(_ cell: UITableViewCell) -> Int {
        return rows!.flatMap { $0.cell }.filter { !$0.isHidden }.index(of: cell)!
    }
    
}
