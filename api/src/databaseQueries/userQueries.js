const db = require("../db");

const readUserQuery = {
    text: `SELECT user_id, username, password
           FROM users
           WHERE username = $1`,
    values: [],
};

const createUserQuery = {
    text: `INSERT INTO users (username, password) VALUES ($1, $2)`,
    values: [],
};

const updatePasswordQuery = {
    text: `UPDATE users SET password = $2 WHERE user_id = $1;`,
    values: [],
}

const deleteUserQuery = {
    text: `DELETE FROM users WHERE user_id = $1`,
    values: [],
};

const readUserShelfQuery = {
    text: `SELECT DISTINCT books.book_id, isbn, first_name, last_name, title, genre, 
                  description, read, COALESCE(ROUND(AVG(reviews.stars),2), 0) AS average_rating
           FROM books
           LEFT JOIN reviews ON books.book_id = reviews.book_id
           LEFT JOIN favorites ON books.book_id = favorites.book_id
           LEFT JOIN book_author ON books.book_id = book_author.book_id
           LEFT JOIN authors ON book_author.author = authors.author_id
           WHERE favorites.user_id = $1`,
    values: [],
};

const deleteUserShelfQuery = {
    text: "DELETE FROM favorites WHERE book_id = $1 AND user_id = $2;",

    values: [],
};

const addUserShelfQuery = {
    text: "INSERT INTO favorites VALUES ($1, $2, false);",

    values: [],
};

const modifyUserShelfQuery = {
    text: "UPDATE favorites SET read = true WHERE book_id = $1 AND user_id = $2;",

    values: [],
};

const createUserSessionQuery = {
    text: `INSERT INTO sessions VALUES ($1) ON CONFLICT DO NOTHING;`,
    values: [],
};

/* FIXME: Password */
async function readUser(user) {
    const query = structuredClone(readUserQuery);
    query.values = [user.username];

    if (user.password) {
        query.text += " AND password = $2";
        query.values.push(user.password);
    }

    const { rows } = await db.query(query);
    return rows[0];
}

async function createUser(user) {
    try {
        await db.query(createUserQuery, [user.username, user.password]);
    } catch ({ message, code, detail }) {
        return { message, code, detail };
    }

    return true;
}

async function updatePassword(user, password) {
    try {
        await db.query(updatePasswordQuery, [user.user_id, password]);
    } catch ({ message, code, detail }) {
        return { message, code, detail };
    }

    return true;
}

async function deleteUser(user) {
    await db.query(deleteUserQuery, [user.user_id]);
}

async function readUserShelf(user, book_id, read, pagenum, pagesize) {
    // Work on a copy of `readUserShelfQuery'
    var pgnum = 0;
    const query = structuredClone(readUserShelfQuery);
    query.values = [user.user_id];

    if (book_id !== undefined && book_id !== "") {
        query.text += " AND books.book_id = $2";
        query.values.push(book_id);
    }

    if (read !== undefined && read !== "") {
        query.text += " AND read = $3";
        query.values.push(read);
    }

    query.text += " GROUP BY books.book_id, first_name, last_name, favorites.read"

    //Cases where pagenum is 1 or below are indirectly covered by
    //pgnum being default value of 0
    if (pagenum !== undefined && pagenum !== "" && pagenum > 1) {
        pgnum = pagenum - 1;
    }

    if (pagesize !== undefined && pagesize !== "") {
        if (pgnum > 0) {
            var offsetVal = pgnum * pagesize;
            query.text += ` LIMIT ${pagesize} OFFSET ${offsetVal};`;
        } else {
            query.text += ` LIMIT ${pagesize};`;
        }
    }

    console.log(query)
    const { rows } = await db.query(query);
    return rows;
}

async function deleteUserShelf(id, uid) {
    await db.query(deleteUserShelfQuery, [id, uid]);
}

async function addUserShelf(id, uid) {
    await db.query(addUserShelfQuery, [uid, id]);
}

async function modifyUserShelf(id, uid) {
    await db.query(modifyUserShelfQuery, [id, uid]);
}

async function createUserSession(user) {
    await db.query(createUserSessionQuery, [user.user_id]);
}

async function deleteUserSession(user) {
    const result = await db.query(`DELETE FROM sessions WHERE user_id = $1`, [
        user.user_id,
    ]);

    return result.rowCount;
}

async function readUserSession() {
    const { rows } = await db.query(
        `SELECT user_id, username FROM users 
         WHERE user_id = (SELECT user_id FROM sessions)`
    );
    return rows[0];
}

module.exports = {
    readUser,
    createUser,
    updatePassword,
    deleteUser,
    readUserShelf,
    deleteUserShelf,
    addUserShelf,
    modifyUserShelf,
    createUserSession,
    deleteUserSession,
    readUserSession,
};
