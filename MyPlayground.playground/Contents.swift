//: Playground - noun: a place where people can play

import UIKit

protocol Drivable {
    var topSpeed: Int { get }
}

protocol Reversible {
    var reverseSpeed: Int { get }
}

protocol Transport {
    var seatCount: Int { get }
}

extension Drivable{

    func isfasterThan(item:Drivable) -> Bool{
    
    return self.topSpeed > item.topSpeed
    
    }

}
extension Drivable where Self:Transport{

    func hasLargerSeatsThan(item:Self)-> Bool{
    
    return self.seatCount > item.seatCount
    
    }

}


struct Car: Drivable, Reversible, Transport {
    var topSpeed = 250
    var reverseSpeed = 20
    var seatCount = 5
}

let sedan = Car()
let sportsCar = Car(topSpeed: 180, reverseSpeed: 60, seatCount: 6)
sedan.isfasterThan(sportsCar)

sedan.hasLargerSeatsThan(sportsCar)

