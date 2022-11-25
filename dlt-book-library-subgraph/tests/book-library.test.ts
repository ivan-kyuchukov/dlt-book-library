import {
  assert,
  describe,
  test,
  clearStore,
  beforeAll,
  afterAll
} from "matchstick-as/assembly/index"
import { Address } from "@graphprotocol/graph-ts"
import { BookAction } from "../generated/schema"
import { BookAction as BookActionEvent } from "../generated/BookLibrary/BookLibrary"
import { handleBookAction } from "../src/book-library"
import { createBookActionEvent } from "./book-library-utils"

// Tests structure (matchstick-as >=0.5.0)
// https://thegraph.com/docs/en/developer/matchstick/#tests-structure-0-5-0

describe("Describe entity assertions", () => {
  beforeAll(() => {
    let isbn = "Example string value"
    let bookAction = 123
    let newBookActionEvent = createBookActionEvent(isbn, bookAction)
    handleBookAction(newBookActionEvent)
  })

  afterAll(() => {
    clearStore()
  })

  // For more test scenarios, see:
  // https://thegraph.com/docs/en/developer/matchstick/#write-a-unit-test

  test("BookAction created and stored", () => {
    assert.entityCount("BookAction", 1)

    // 0xa16081f360e3847006db660bae1c6d1b2e17ec2a is the default address used in newMockEvent() function
    assert.fieldEquals(
      "BookAction",
      "0xa16081f360e3847006db660bae1c6d1b2e17ec2a-1",
      "isbn",
      "Example string value"
    )
    assert.fieldEquals(
      "BookAction",
      "0xa16081f360e3847006db660bae1c6d1b2e17ec2a-1",
      "bookAction",
      "123"
    )

    // More assert options:
    // https://thegraph.com/docs/en/developer/matchstick/#asserts
  })
})
