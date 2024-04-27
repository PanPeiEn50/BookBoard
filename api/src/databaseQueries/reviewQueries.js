const db = require("../db");

const readBookReviewsById = {
    text: "SELECT username, stars, content, created_at FROM reviews, users WHERE reviews.book_id = $1 AND reviews.user_id = users.user_id ORDER BY created_at DESC",

    values: [],
};

async function createReview(userId, bookId, stars, content) {
    try {
        await db.query(
            "INSERT INTO reviews (user_id, book_id, stars, content) \
            VALUES ($1, $2, $3, $4) ON CONFLICT (user_id, book_id) \
            DO UPDATE SET content = EXCLUDED.content, stars = EXCLUDED.stars WHERE \
            EXCLUDED.user_id = reviews.user_id",
            [userId, bookId, stars, content]
        );
    } catch ({ message, code, detail }) {
        return { message, code, detail };
    }

    return true;
}

async function bookReviewsById(id, stars) {
    //Working with copy for text and value modification
    const query = structuredClone(readBookReviewsById);
    query.values = [id];

    if (stars !== undefined && stars !== "") {
        query.text += " AND reviews.stars = $2;";
        query.values.push(stars);
    } else {
        query.text += ";";
    }
    const { rows } = await db.query(query);
    return rows;
}

module.exports = {
    bookReviewsById,
    createReview,
};
