import { newMockEvent } from "matchstick-as"
import { ethereum, Address } from "@graphprotocol/graph-ts"
import { BookAction, BorrowAction } from "../generated/BookLibrary/BookLibrary"

export function createBookActionEvent(
  isbn: string,
  bookAction: i32
): BookAction {
  let bookActionEvent = changetype<BookAction>(newMockEvent())

  bookActionEvent.parameters = new Array()

  bookActionEvent.parameters.push(
    new ethereum.EventParam("isbn", ethereum.Value.fromString(isbn))
  )
  bookActionEvent.parameters.push(
    new ethereum.EventParam(
      "bookAction",
      ethereum.Value.fromUnsignedBigInt(BigInt.fromI32(bookAction))
    )
  )

  return bookActionEvent
}

export function createBorrowActionEvent(
  isbn: string,
  borrowerAddress: Address,
  borrowAction: i32
): BorrowAction {
  let borrowActionEvent = changetype<BorrowAction>(newMockEvent())

  borrowActionEvent.parameters = new Array()

  borrowActionEvent.parameters.push(
    new ethereum.EventParam("isbn", ethereum.Value.fromString(isbn))
  )
  borrowActionEvent.parameters.push(
    new ethereum.EventParam(
      "borrowerAddress",
      ethereum.Value.fromAddress(borrowerAddress)
    )
  )
  borrowActionEvent.parameters.push(
    new ethereum.EventParam(
      "borrowAction",
      ethereum.Value.fromUnsignedBigInt(BigInt.fromI32(borrowAction))
    )
  )

  return borrowActionEvent
}
