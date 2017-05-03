//: Playground - noun: a place where people can play

import UIKit

var test = [
    [11, 11],
    [12, 11],
    [11, 12],
    [12, 12],
    [13, 12],
    [11, 13],
    [12, 13]
]

var result = test.flatMap { arr in arr.max() }.max()

print(result)


test.joined()