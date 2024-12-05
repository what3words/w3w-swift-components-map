import XCTest
import CoreLocation
import W3WSwiftCore
@testable import W3WSwiftComponentsMap

final class w3w_swift_components_mapTests: XCTestCase {

  let filledCountSoap = W3WBaseSquare(words: "filled.count.soap", coordinates: CLLocationCoordinate2D(latitude: 1.0, longitude: 1.0))
  let indexHomeRaft = W3WBaseSquare(words: "index.home.raft", coordinates: CLLocationCoordinate2D(latitude: 2.0, longitude: 2.0))

  func testMarrkerLists() throws {
    
    let lists = W3WMarkersLists()

    // add a fun list
    XCTAssertTrue(lists.add(listName: "fun", color: .aqua))
    XCTAssertTrue(lists.add(square: filledCountSoap, listName: "fun"))
    XCTAssertTrue(lists.add(square: indexHomeRaft, listName: "fun"))

    // add a no fun list
    XCTAssertTrue(lists.add(listName: "nofun", color: .red))
    XCTAssertTrue(lists.add(square: filledCountSoap, listName: "nofun"))
    XCTAssertTrue(lists.add(square: indexHomeRaft, listName: "nofun"))

    // add to missing list
    XCTAssertFalse(lists.add(square: filledCountSoap, listName: "non exantant list"))
    
    // remove no fun
    XCTAssertTrue(lists.remove(listName: "nofun"))
    XCTAssertFalse(lists.remove(listName: "nofun"))

    // remove filled soap
    XCTAssertTrue(lists.remove(square: filledCountSoap, listName: "fun"))
    XCTAssertFalse(lists.remove(square: filledCountSoap, listName: "fun"))
  }
  
}
