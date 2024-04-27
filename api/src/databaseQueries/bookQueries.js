const db = require("../db");

const readBookByID = {
    text: `SELECT books.book_id, title, first_name, last_name, genre, isbn, 
    description, COALESCE(ROUND(AVG(reviews.stars),2), 0) AS average_rating,  
    COUNT(reviews.book_id) AS review_count
           FROM books
           LEFT JOIN reviews ON books.book_id = reviews.book_id
           LEFT JOIN book_author ON books.book_id = book_author.book_id
           LEFT JOIN authors ON book_author.author = authors.author_id
           WHERE `,

    values: [],
};

const bookSearchQuery = {
    text: `SELECT DISTINCT books.book_id, title, first_name, last_name, genre, isbn, description, stars
           FROM books, book_author, authors, reviews
           WHERE books.book_id = book_author.book_id AND book_author.author = authors.author_id`,

    values: [],
};

const bookSearchViewQuery = {
    text: `SELECT books.book_id, title, first_name, last_name, genre, isbn, fiction,
                   description, COALESCE(ROUND(AVG(reviews.stars),2), 0) AS average_rating,
                   COUNT(reviews.book_id) AS review_count
           FROM books 
           LEFT JOIN reviews ON books.book_id = reviews.book_id
           LEFT JOIN book_author ON books.book_id = book_author.book_id
           LEFT JOIN authors ON book_author.author = authors.author_id`,
    values: [],
};



// TODO figure out filtering by avgRating
async function bookSearch(request) {
    const query = structuredClone(bookSearchViewQuery);
    const filterParams = {
        genre: "LOWER(books.genre) = LOWER(${param})",
        title: "similarity(LOWER(title), LOWER(${param})) * 100 >= 30",
        author: "similarity(LOWER(CONCAT(first_name, ' ', last_name)), LOWER(${param})) * 100 >= 70",
        fiction: "books.fiction = ${param}",
        // avgRating: "COALESCE(ROUND(AVG(reviews.stars),2), 0) >= ${param}",
    };

    const sortParams = {
        genre: "genre",
        title: "title",
        author: "last_name",
        avgRating: "average_rating",
    };

    var paramCount = 1;
    const mvattrfunc = (() => {

        return (template, value, chainKeyword) => {
            const arr = Array.isArray(value) ? value : [value];
            let chain = " ";

            arr.forEach((element) => {
                // if (template.includes("%")) {
                //     element.split(" ").forEach((str) => {
                //         template = template.replace(
                //             "${param}",
                //             str.toLowerCase()
                //         );
                //     });
                //     query.text += `${chain}${template}`;
                // } else {
                    query.text += `${chain}${template.replace(
                        "{param}",
                        paramCount.toString()
                    )}`;

                    query.values.push(element);
                    ++paramCount;
                // }

                chain = " " + chainKeyword + " ";
            });
        };
    })();

    var objectEntries = Object.entries(request);
    const filteredEntries = objectEntries.filter(([_, value]) => {
        return value;
    });

    const filters = filteredEntries.filter(([key, _]) => {
        return key in filterParams;
    });

    if (filters.length !== 0) {
        var filterCount = 0;
        query.text += " WHERE";

        filters.forEach(([key, value]) => {
            var templateChain = filterCount === 0 ? " " : " AND ";
            if (key === "title") {
                value = value.replace(" ", "%");
            }
            query.text += templateChain;
            mvattrfunc(filterParams[key], value, "OR");

            ++filterCount;
        });
    }

    query.text += " GROUP BY books.book_id, books.title, first_name, last_name";

    const { avgRating } = request;

    if (avgRating !== undefined && avgRating !== "") {
        query.text += ` HAVING COALESCE(ROUND(AVG(reviews.stars),2), 0) >= ${avgRating}`;
    }

    const { sortBy, asc } = request;
    const found = filteredEntries.find((arr) => arr.includes(sortBy));

    if (found && sortBy in sortParams) {
        query.text += ` ORDER BY ${sortParams[sortBy]} ${
            asc === "false" ? "DESC" : ""
        }`;
    }

    const { pagenum, pagesize } = request;
    query.text += ` LIMIT $${paramCount++} OFFSET $${paramCount++}`;
    
    if (pagesize !== undefined && pagesize !== "") {
        if (pagenum !== undefined && pagenum !== "") {
            query.values.push(pagesize, pagesize * pagenum);
        } else {
            query.values.push(pagesize, 0);
        }
    } else {
        query.values.push(25, 0);
    }

    console.log(query);
    const { rows } = await db.query(query);
    return rows;
}

async function bookByID(id) {
    const query = structuredClone(readBookByID);
    query.text += ' books.' + (id.length == 13 ? 'isbn' : 'book_id') + ' = $1';
    query.text += " GROUP BY books.book_id, books.title, first_name, last_name";
 
    const { rows } = await db.query(query, [id]);
    return rows;
}

module.exports = {
    bookByID,
    bookSearch,
};
