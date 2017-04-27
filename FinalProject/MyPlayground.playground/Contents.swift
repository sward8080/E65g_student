//: Playground - noun: a place where people can play

import UIKit

var completionHandlers: [() -> Void] = []
func someFunctionWithEscapingClosure(completionHandler: @escaping () -> Void) {
    completionHandlers.append(completionHandler)
}

func someFunctionWithNonescapingClosure(closure: () -> Void) {
    closure()
}

class SomeClass {
    var x = 10
    func doSomething() {
        someFunctionWithEscapingClosure { self.x = 100 }
        someFunctionWithNonescapingClosure { x = 200 }
    }
}

let instance = SomeClass()

print(instance.x)
instance.doSomething()
print(instance.x)
// Prints "200"

//completionHandlers.first?()
//print(instance.x)
// Prints "100

completionHandlers.count