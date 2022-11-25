import {
  BookAction as BookActionEvent,
  BorrowAction as BorrowActionEvent
} from "../generated/BookLibrary/BookLibrary"
import { BookAction, BorrowAction } from "../generated/schema"

export function handleBookAction(event: BookActionEvent): void {
  let entity = new BookAction(
    event.transaction.hash.concatI32(event.logIndex.toI32())
  )
  entity.isbn = event.params.isbn
  entity.bookAction = event.params.bookAction

  entity.blockNumber = event.block.number
  entity.blockTimestamp = event.block.timestamp
  entity.transactionHash = event.transaction.hash

  entity.save()
}

export function handleBorrowAction(event: BorrowActionEvent): void {
  let entity = new BorrowAction(
    event.transaction.hash.concatI32(event.logIndex.toI32())
  )
  entity.isbn = event.params.isbn
  entity.borrowerAddress = event.params.borrowerAddress
  entity.borrowAction = event.params.borrowAction

  entity.blockNumber = event.block.number
  entity.blockTimestamp = event.block.timestamp
  entity.transactionHash = event.transaction.hash

  entity.save()
}
