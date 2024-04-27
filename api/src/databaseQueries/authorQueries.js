const db = require("../db");

const getAuthorQuery = {
    text: `SELECT first_name, last_name, date_of_birth, number_of_books
           FROM authors, book_author
           WHERE book_author.book_id = $1 
             AND authors.author_id = book_author.author`,
    values: [],
};


async function getAuthor(bookId) {
    const { rows } = await db.query(getAuthorQuery, [bookId]);
    return rows[0];
}

module.exports = { getAuthor };