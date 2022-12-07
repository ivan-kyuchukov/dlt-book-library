// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
pragma abicoder v2;
import '@openzeppelin/contracts/access/Ownable.sol';

contract BookLibrary is Ownable {
    // Declarations
    struct Book {
        bytes32 id;
        string isbn;
        string title;
        uint16 quantity;
        mapping(address => bool) borrowers;
        address[] borrowersKeys;
    }

    mapping(bytes32 => Book) private books;
    mapping(bytes32 => bool) private insertedBooks;
    bytes32[] private bookKeys;

    enum BookActions { Created, Updated }
    event BookAction(bytes32 indexed id, string indexed isbn, BookActions indexed bookAction);

    enum BorrowActions { Borrowed, Returned }
    event BorrowAction(bytes32 indexed id, string indexed isbn, address borrowerAddress, BorrowActions indexed borrowAction);

    modifier validNewBook (string calldata _isbn, string calldata _title, uint16 _quantity) {
        if (bytes(_isbn).length == 0) revert IsbnEmpty(msg.sender, _isbn);
        if (bytes(_title).length == 0) revert TitleEmpty(msg.sender, _isbn, _title);
        if (_quantity < 0) revert QuantityLessThanZero(msg.sender, _isbn, _quantity);
        _;
    }

    error IsbnEmpty(address caller, string _isbn);
    error TitleEmpty(address caller, string _isbn, string _title);
    error QuantityLessThanZero(address caller, string _isbn, uint16 _quantity);
    error BookAttemptToBorrowTwice(address caller, bytes32 _bookId);
    error BookNotAvailableToBorrow(address caller, bytes32 _bookId);
    error BookWasntBorrowedFromUser(address caller, bytes32 _bookId);
    error CannotDecreaseBookQuantity(address caller, bytes32 _bookId, uint16 _oldQuantity, uint16 _newQuantity);
    // End declarations

    // this is public for testing purposes
    function hash(string calldata _stringToHash) public pure returns (bytes32) {
        return keccak256(abi.encodePacked(_stringToHash));
    }

    function getBookListSize() external view returns (uint) {
        return bookKeys.length;
    }

    function getBook(uint _index) external view returns (bytes32, string memory, string memory, uint16) {
        return (books[bookKeys[_index]].id, books[bookKeys[_index]].isbn, books[bookKeys[_index]].title, books[bookKeys[_index]].quantity);
    }

    function getBorrowersListSizePerBook(bytes32 _bookId) external view returns (uint) {
        return books[_bookId].borrowersKeys.length;
    }

    function getBorrower(bytes32 _bookId, uint _index) external view returns (address) {
        return books[_bookId].borrowersKeys[_index];
    }

    function AddUpdateBook(string calldata _isbn, string calldata _title, uint16 _quantity) external onlyOwner validNewBook(_isbn, _title, _quantity) {
        bytes32 bookId = hash(_isbn);
        Book storage book = books[bookId];
        if (insertedBooks[bookId] && _quantity < book.quantity) revert CannotDecreaseBookQuantity(msg.sender, bookId, book.quantity, _quantity);

        book.isbn = _isbn;
        book.title = _title;
        book.quantity = _quantity;
        if (!insertedBooks[bookId]) {
            insertedBooks[bookId] = true;
            bookKeys.push(bookId);

            emit BookAction(bookId, _isbn, BookActions.Created);
            return;
        }

        emit BookAction(bookId, _isbn, BookActions.Updated);
    }

    function BorrowBook(bytes32 _bookId) external {
        Book storage book = books[_bookId];
        if (books[_bookId].borrowers[msg.sender]) revert BookAttemptToBorrowTwice(msg.sender, _bookId);
        if (books[_bookId].quantity == 0) revert BookNotAvailableToBorrow(msg.sender, _bookId);

        book.quantity--;
        book.borrowers[msg.sender] = true;
        book.borrowersKeys.push(msg.sender);

        emit BorrowAction(_bookId, book.isbn, msg.sender, BorrowActions.Borrowed);
    }

    function ReturnBook(bytes32 _bookId, uint _index) external {
        Book storage book = books[_bookId];
        if (!book.borrowers[msg.sender]) revert BookWasntBorrowedFromUser(msg.sender, _bookId);

        book.quantity++;
        book.borrowers[msg.sender] = false;
        book.borrowersKeys[_index] = book.borrowersKeys[book.borrowersKeys.length - 1];
        book.borrowersKeys.pop();

        emit BorrowAction(_bookId, book.isbn, msg.sender, BorrowActions.Returned);
    }
}
