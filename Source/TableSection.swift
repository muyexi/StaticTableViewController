import UIKit

class TableSection {
    
    var rows: [TableRow] = []
    
    func numberOfVissibleRows() -> Int {
        return rows.filter { !$0.hiding }.count
    }
    
}
