import Foundation

let firstName: String = "Aisana"
let lastName: String = "Ondassyn"
let age: Int = currentYear - birthYear
let birthYear: Int = 2005
let currentYear: Int = 2025
let isStudent: Bool = true
let height: Double = 167.0
let favoriteEmoji: String = "😋"

let city: String = "Almaty"
let country: String = "Kazakhstan"

let hobby: String = "DYI projects"
let numberOfHobbies: Int = 1
let favoriteNumber: Int = 15
let isHobbyCreative: Bool = false
let favoriteFood: String = "Beshbarmak"

var lifeStory: String = """
My name is \(firstName) \(lastName). I am \(age) years old, born in \(birthYear).
I currently live in \(city), \(country). I am \(isStudent ? "currently a student" : "not a student").
My height is \(height) meters.
I enjoy \(hobby), which is \(isHobbyCreative ? "a creative hobby" : "not a creative hobby").
I have \(numberOfHobbies) hobbies in total, and my favorite number is \(favoriteNumber).
Also, my favorite food is \(favoriteFood).
"""

let futureGoals: String = "In the future, I wanna become a millionaire and live in Bali as a freelancer😋"

lifeStory += "\n" + futureGoals

print(lifeStory)
