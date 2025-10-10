import Foundation

let laptop = Product(id: "p1", name: "MacBook Air", price: 999.99, category: .electronics, description: "Powerful laptop")!
let book = Product(id: "p2", name: "Swift Programming", price: 39.99, category: .books, description: "Learn Swift from scratch")!
let headphones = Product(id: "p3", name: "AirPods Pro", price: 249.99, category: .electronics, description: "Noise-cancelling earbuds")!

print("Created products:")
print("- \(laptop.name): \(laptop.displayPrice)")
print("- \(book.name): \(book.displayPrice)")
print("- \(headphones.name): \(headphones.displayPrice)\n")

let cart = ShoppingCart()
cart.addItem(product: laptop, quantity: 1)
cart.addItem(product: book, quantity: 2)

print("Cart after adding products:")
print("Subtotal: \(cart.subtotal)")
print("Item count: \(cart.itemCount)\n")

cart.addItem(product: laptop, quantity: 1)
print("After adding same product again (MacBook):")
if let laptopItem = cart.items.first(where: { $0.product.id == laptop.id }) {
    print("Laptop quantity:", laptopItem.quantity)
}
print()

print("Subtotal: \(cart.subtotal)")
print("Item count: \(cart.itemCount)\n")

cart.discountCode = "SAVE10"
print("Applied discount SAVE10")
print("Discount amount: \(cart.discountAmount)")
print("Total with discount: \(cart.total)\n")

cart.removeItem(productId: book.id)
print("After removing book:")
print("Item count:", cart.itemCount)
print("Subtotal:", cart.subtotal)
print()

func modifyCart(_ cart: ShoppingCart) {
    print("Adding headphones inside function")
    cart.addItem(product: headphones, quantity: 1)
}
modifyCart(cart)

print("After function call:")
print("Cart item count:", cart.itemCount)
print("Contains AirPods:", cart.items.contains { $0.product.id == headphones.id })
print("The same cart was modified (class = reference type)\n")

let item1 = CartItem(product: laptop, quantity: 1)
var item2 = item1
item2.updateQuantity(5)

print("Struct value type behavior:")
print("item1 quantity:", item1.quantity)
print("item2 quantity:", item2.quantity)
print("item1 not affected by changes to item2\n")

let address = Address(street: "123 Main St", city: "Almaty", zipCode: "050000", country: "Kazakhstan")
let order = Order(from: cart, shippingAddress: address)

print("Created order:")
print("Order ID:", order.orderId)
print("Order total:", order.total)
print("Shipping to:\n\(order.shippingAddress.formattedAddress)\n")

cart.clearCart()
print("Cart cleared after order")
print("Cart items count:", cart.itemCount)
print("Order items count:", order.itemCount)
print("Order snapshot remains unchanged\n")
