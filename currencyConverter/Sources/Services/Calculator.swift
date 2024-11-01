import Foundation

class Calculate {
    func evaluate(_ oexpression: String) throws -> Double {
        let expression = oexpression + "$"
        var numberStack = Stack<Double>()
        var operatorStack = Stack<Character>()
        var buffer = ""
        for char in expression {
            if char.isNumber || char == "." || char == "," {
                buffer.append(char)
            } else {
                if !buffer.isEmpty || char == "$" {
                    guard let parsedNumber = Double(buffer.filter { $0 != "," }) else {
                        throw CalculateError.invalidExpression
                    }
                    numberStack.push(parsedNumber)
                    buffer = ""
                    if char == "$" { break }
                }
                while operatorStack.peek() != nil
                    && operatorPriority(char) <= operatorPriority(operatorStack.peek()!)
                {
                    let op = operatorStack.pop()!
                    guard let b = numberStack.pop() else { throw CalculateError.invalidExpression }
                    guard let a = numberStack.pop() else { throw CalculateError.invalidExpression }
                    numberStack.push(try caluculate(a, operator: op, b))
                }
                operatorStack.push(char)
            }

        }
        while let op = operatorStack.pop() {
            guard let b = numberStack.pop() else { throw CalculateError.invalidExpression }
            guard let a = numberStack.pop() else { throw CalculateError.invalidExpression }
            numberStack.push(try caluculate(a, operator: op, b))
        }
        return numberStack.pop()!
    }

    private func caluculate(_ a: Double, operator c: Character, _ b: Double) throws -> Double {
        switch c {
        case "+":
            return a + b
        case "-":
            return a - b
        case "*":
            return a * b
        case "%":
            return a.remainder(dividingBy: b)
        case "/":
            if b == 0 { throw CalculateError.divideByZero }
            return a / b
        default:
            throw CalculateError.invalidExpression
        }
    }

    private func operatorPriority(_ c: Character) -> Int {
        switch c {
        case "+", "-":
            return 1
        case "*", "/" , "%":
            return 2
        default:
            return -1
        }
    }
}

enum CalculateError: Error {
    case invalidExpression
    case divideByZero
}

