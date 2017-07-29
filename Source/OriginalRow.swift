import UIKit

enum BatchOperation {
    case none, insert, delete, update
}

class OriginalRow {
    
    init(cell: UITableViewCell, originalIndexPath: IndexPath){
        self.cell = cell
        self.originalIndexPath = originalIndexPath
    }
    
    var hiddenReal: Bool = false

    var hiddenPlanned: Bool = false
    
    var batchOperation: BatchOperation = .none
    
    var cell: UITableViewCell
    
    var originalIndexPath: IndexPath
    
    var height: CGFloat = CGFloat.greatestFiniteMagnitude
    
    func update() {
        if !hiddenPlanned && batchOperation == .none {
            batchOperation = .update
        }
    }
    
    func set(hidden: Bool) {
        if !hiddenReal && hidden {
            batchOperation = .delete
        } else if hiddenReal && !hidden {
            batchOperation = .insert
        }
        
        hiddenPlanned = hidden
    }
    
}
