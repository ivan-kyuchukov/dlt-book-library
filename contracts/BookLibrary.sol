// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
pragma abicoder v2;
import '@openzeppelin/contracts/access/Ownable.sol';

contract BookLibrary is Ownable {
    struct Book {
        string isbn;
        string title;
        uint16 quantity;
        mapping(address => bool) borrowers;
    }

    mapping(string => Book) public booksMap;
    mapping(string => bool) private insertedBooks;
    string[] private bookKeysArr;

    enum BookActions { Created, Updated }
    event BookAction(string indexed isbn, BookActions indexed bookAction);

    enum BorrowActions { Borrowed, Returned }
    event BorrowAction(string indexed isbn, address borrowerAddress, BorrowActions indexed borrowAction);

    function insertBook(string calldata _isbn, string calldata _title, uint16 _quantity) private {
        booksMap[_isbn].isbn = _isbn;
        booksMap[_isbn].title = _title;
        booksMap[_isbn].quantity = _quantity;

        if (!insertedBooks[_isbn]) {
            insertedBooks[_isbn] = true;
            bookKeysArr.push(_isbn);
        }
    }

    function getSize() external view returns (uint) {
        return bookKeysArr.length;
    }

    function getBook(uint _index) external view returns (string memory, string memory, uint16) {
        return (booksMap[bookKeysArr[_index]].isbn, booksMap[bookKeysArr[_index]].title, booksMap[bookKeysArr[_index]].quantity);
    }

    function AddUpdateBook(string calldata _isbn, string calldata _title, uint16 _quantity) external onlyOwner {
        require(bytes(_isbn).length > 0, "ISBN cannot be empty");
        require(bytes(_title).length > 0, "Title cannot be empty");
        require(_quantity >= 0, "Quantity cannot be less than 0");

        Book storage book = booksMap[_isbn];
        if (bytes(book.title).length > 0) { // if the books exists
            require(_quantity >= book.quantity, "You cannot remove books");
            book.isbn = _isbn;
            book.title = _title;
            book.quantity = _quantity;
            emit BookAction(_isbn, BookActions.Created);
        }
        else {
            insertBook(_isbn, _title, _quantity);
            emit BookAction(_isbn, BookActions.Updated);
        }
    }

    function BorrowBook(string calldata _isbn) external {
        require(bytes(_isbn).length > 0, "ISBN cannot be empty");
        require(insertedBooks[_isbn], "The book with this ISBN does not exist");
        require(!booksMap[_isbn].borrowers[msg.sender], "You cannot borrow the same book more than once");
        require(booksMap[_isbn].quantity > 0, "We dont have available copies of that book right now");

        booksMap[_isbn].quantity--;
        booksMap[_isbn].borrowers[msg.sender] = true;

        emit BorrowAction(_isbn, msg.sender, BorrowActions.Borrowed);
    }

    function ReturnBook(string calldata _isbn) external {
        require(bytes(_isbn).length > 0, "ISBN cannot be empty");
        require(insertedBooks[_isbn], "The book with this ISBN does not exist");
        require(booksMap[_isbn].borrowers[msg.sender], "You did not borrow that book from us");

        booksMap[_isbn].quantity++;
        booksMap[_isbn].borrowers[msg.sender] = false;

        emit BorrowAction(_isbn, msg.sender, BorrowActions.Returned);
    }
}
