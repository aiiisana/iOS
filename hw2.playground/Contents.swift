import Foundation


//Problem 1: FizzBuzz

func fizzBuzz(){
    for i in 1...100 {
        if i.isMultiple(of: 3) && i.isMultiple(of: 5) {
            print("FizzBuzz")
        } else if i.isMultiple(of: 3) {
            print("Fizz")
        } else if i.isMultiple(of: 5) {
            print("Buzz")
        } else {
            print(i)
        }
    }
}

//fizzBuzz()


//Problem 2: Prime Numbers

func isPrime(_ number: Int) -> Bool {
    guard number > 1 else { return false }
    let sqrtValue = Int(Double(number).squareRoot())
    for i in 2...max(2, sqrtValue) {
        if number % i == 0 && number != i {
            return false
        }
    }
    return true
}

func primeToHundred() {
    for i in 1...100 where isPrime(i) {
        print(i, terminator: " ")
    }
}

//primeToHundred()





//Problem 3: Temperature Converter


func convertTemperature(_ temp: Double, from unit: String, to target: String) -> Double {
    var celsius: Double
    
    switch unit.uppercased() {
    case "C":
        celsius = temp
    case "F":
        celsius = (temp - 32) * 5 / 9
    case "K":
        celsius = temp - 273.15
    default:
        print("Invalid input unit")
        return Double.nan
    }
    
    switch target.uppercased() {
    case "C":
        return celsius
    case "F":
        return celsius * 9 / 5 + 32
    case "K":
        return celsius + 273.15
    default:
        print("Invalid target unit")
        return Double.nan
    }
}


func runConverter() {
    print("Temperature сonverter")
    
    let tempValue: Double = 100
    let inputUnit: String = "C"
    
    print("Input: \(tempValue)°\(inputUnit)")
    
    let toC = convertTemperature(tempValue, from: inputUnit, to: "C")
    let toF = convertTemperature(tempValue, from: inputUnit, to: "F")
    let toK = convertTemperature(tempValue, from: inputUnit, to: "K")
    
    print("Celsius: \(toC)")
    print("Fahrenheit: \(toF)")
    print("Kelvin: \(toK)")
}

//runConverter()


//Problem 4: Shopping List Manager

func shopping() {
    var shoppingList: [String] = []

    func addItem(_ item: String) {
        shoppingList.append(item)
        print("\(item) was added to your list.")
    }

    func removeItem(_ item: String) {
        if let idx = shoppingList.firstIndex(of: item) {
            shoppingList.remove(at: idx)
            print("\(item) was removed.")
        } else {
            print("\(item) is not on the list.")
        }
    }

    func showList() {
        if shoppingList.isEmpty {
            print("Your shopping list is empty.")
        } else {
            print("Current shopping list:")
            for (i, item) in shoppingList.enumerated() {
                print("\(i + 1). \(item)")
            }
        }
    }

    
    addItem("Milk")
    addItem("Eggs")
    addItem("Bread")
    showList()
    
    removeItem("Eggs")
    showList()
    
    addItem("Butter")
    showList()
}

//shopping()

//Problem 5: Word Frequency Counter

func wordCount() {
    func wordFrequency(from sentence: String) -> [String: Int] {
        let cleaned = sentence.lowercased()
            .components(separatedBy: CharacterSet.punctuationCharacters)
            .joined()
        
        let words = cleaned.split(separator: " ").map { String($0) }
        
        var frequency: [String: Int] = [:]
        for word in words {
            frequency[word, default: 0] += 1
        }
        return frequency
    }
    
    let text = "Hello, hello! Swift is great. Swift is fun, and Swift is cool."
    let result = wordFrequency(from: text)
    
    print("Word frequencies:")
    for (word, count) in result {
        print("\(word): \(count)")
    }
}

//wordCount()


//Problem 6: Fibonacci Sequence

func fibonacci(_ n: Int) -> [Int] {
    guard n > 0 else { return [] }
    if n == 1 { return [0] }
    if n == 2 { return [0, 1] }
    
    var sequence = [0, 1]
    for i in 2..<n {
        sequence.append(sequence[i - 1] + sequence[i - 2])
    }
    return sequence
}

//print("Fibonacci(10):", fibonacci(10))



//Problem 7: Grade Calculator
func avgScore(){
    let students: [String: Int] = [
        "Alice": 85,
        "Bob": 92,
        "Charlie": 76,
        "Diana": 89
    ]

    let scores = Array(students.values)
    let average = Double(scores.reduce(0, +)) / Double(scores.count)
    let highest = scores.max() ?? 0
    let lowest = scores.min() ?? 0

    print("Average score: \(average)")
    print("Highest score: \(highest)")
    print("Lowest score: \(lowest)")

    for (name, score) in students {
        let status = Double(score) >= average ? "above" : "below"
        print("\(name): \(score) (\(status) average)")
    }
}

//avgScore()



//Problem 8: Palindrome Checker
func isPalindrome(_ text: String) -> Bool {
    let cleaned = text.lowercased().filter { $0.isLetter || $0.isNumber }
    return cleaned == String(cleaned.reversed())
}

//print(isPalindrome("Racecar"))
//print(isPalindrome("Hello"))
//print(isPalindrome("A man, a plan, a canal: Panama"))



//Problem 9: Simple Calculator
func add(_ a: Double, _ b: Double) -> Double { a + b }
func subtract(_ a: Double, _ b: Double) -> Double { a - b }
func multiply(_ a: Double, _ b: Double) -> Double { a * b }
func divide(_ a: Double, _ b: Double) -> Double {
    b == 0 ? Double.nan : a / b
}

let x = 10.0
let y = 5.0

//print("Addition: \(x) + \(y) = \(add(x, y))")
//print("Subtraction: \(x) - \(y) = \(subtract(x, y))")
//print("Multiplication: \(x) * \(y) = \(multiply(x, y))")
//print("Division: \(x) / \(y) = \(divide(x, y))")

//Problem 10: Unique Characters
func hasUniqueCharacters(_ text: String) -> Bool {
    var seen = Set<Character>()
    for char in text {
        if seen.contains(char) {
            return false
        }
        seen.insert(char)
    }
    return true
}

//print(hasUniqueCharacters("Swift"))
//print(hasUniqueCharacters("Programming"))
//print(hasUniqueCharacters("abcABC"))
