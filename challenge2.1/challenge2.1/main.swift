//
//  main.swift
//  challenge2.1
//
//  Created by Hoang Khoa on 11/1/24.
//

import Foundation

struct Product {
    let name: String
    let price: Double
    let quantity: Int
}

struct Store {
    var inventory = [
        Product(name: "Laptop", price: 999.99, quantity: 5),
        Product(name: "Smartphone", price: 499.99, quantity: 10),
        Product(name: "Tablet", price: 299.99, quantity: 0),
        Product(name: "Smartwatch", price: 199.99, quantity: 3)
    ]
    
    func printInventory() {
        inventory.forEach { product in
            print("\(product.name): \(product.price) - \(product.quantity)")
        }
    }
    
    func calculateTotalValue() -> Double {
        return inventory.reduce(0) { $0 + $1.price * Double($1.quantity) }
    }
    
    func findMostExpensiveProduct() -> Product? {
        return inventory.max(by: { $0.price < $1.price })
    }
    
    func checkIfProductInStock(productName: String) -> Bool {
        return inventory.first(where: { $0.name == productName })?.quantity ?? 0 > 0
    }
    
    mutating func sortInventory(by property: String, ascending: Bool = true) {
            switch property.lowercased() {
            case "name":
                inventory.sort { ascending ? $0.name < $1.name : $0.name > $1.name }
            case "price":
                inventory.sort { ascending ? $0.price < $1.price : $0.price > $1.price }
            case "quantity":
                inventory.sort { ascending ? $0.quantity < $1.quantity : $0.quantity > $1.quantity }
            default:
                print("Invalid property: \(property)")
            }
        }
}

var store = Store()
var exitFlag = false
while !exitFlag {
    print("""
        Menu:
        1. Print inventory
        2. Calculate total inventory value
        3. Print most expensive product
        4. Check if product in stock
        5. Sort
        6. Exit
        """)
    let input = readLine(strippingNewline: true)!
    switch input {
    case "1":
        store.printInventory()
    case "2":
        print(String(format: "%.02f", store.calculateTotalValue()))
    case "3":
        print(store.findMostExpensiveProduct()?.name ?? "No products in stock")
    case "4":
        print("Enter product name: ")
        let productName = readLine(strippingNewline: true)!
        print(store.checkIfProductInStock(productName: productName))
    case "5":
        print("Sort by (Name, Price, Quantity): ")
        let sortBy = readLine(strippingNewline: true)!
        print("""
    "Ascending:
     1. True
     2. False
    """)
        let ascending = readLine(strippingNewline: true)!
        store.sortInventory(by: sortBy, ascending: ascending == "1")
    case "6":
        exitFlag = true
    default:
        print("Invalid input")
    }
}
