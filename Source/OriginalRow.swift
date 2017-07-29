import UIKit

enum BatchOperation {
    case none, insert, delete, update
}

class OriginalRow {
    
    init(cell: UITableViewCell, originalIndexPath: IndexPath){
        self.cell = cell
        self.originalIndexPath = originalIndexPath
    }
    
    var hidden: Bool = false

    var hiding: Bool = false {
        willSet {
            if !hidden && newValue {
                batchOperation = .delete
            } else if hidden && !newValue {
                batchOperation = .insert
            }
        }
    }
    
    var batchOperation: BatchOperation = .none
    
    var cell: UITableViewCell
    
    var originalIndexPath: IndexPath
    
    var height: CGFloat = CGFloat.greatestFiniteMagnitude
    
    func update() {
        if !hiding && batchOperation == .none {
            batchOperation = .update
        }
    }
    
}
