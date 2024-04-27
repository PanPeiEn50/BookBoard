module.exports = Book;

class Book {
    constructor(id, isbn, title, description, genre, fiction) {
        this.id = id;
        this.isbn = isbn;
        this.title = title;
        this.description = description;
        this.genre = genre;
        this.fiction = fiction;
    }
}