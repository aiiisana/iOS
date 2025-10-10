import Foundation

struct CartItem {
    var product: Product
    var quantity: Int
    
    var subtotal: Double {
        product.price * Double(quantity)
    }
    
    mutating func updateQuantity(_ newQuantity: Int) {
        if newQuantity > 0 {
            quantity = newQuantity
        }
    }
    
    mutating func increaseQuantity(by amount: Int) {
        if amount > 0 {
            quantity += amount
        }
    }
}

