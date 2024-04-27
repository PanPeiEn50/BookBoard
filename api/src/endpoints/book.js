const express = require("express");
const router = express.Router();
const bookQueries = require("../databaseQueries/bookQueries");

/**
 * @returns
 *  - Title
 *  - Author first name
 *  - Author last name
 *  - Genre
 *  - ISBN
 *  - Description
 *
 * @usage
 *  - /api/book/books?[genre=genrevalue&fiction=[true|false]&avgRating=[1-5]
 *                    &author=authorName&title=titleName
 *                    &sortBy=[genre | author | avgRating | title]&asc=[true|false]
 *                    &pagenum=[0-99]&pagesize=[25, 50]]
 * - For filtering: genre and author can have multiple values
 * - For sorting: only one value is allowed
 * 
 * If this is overly complicated talk to backend bois <3
 */
router.get("/books", async (req, res) => {
    // const user = req.session.user || (await userQueries.readUserSession());

    // if (!user) {
        // res.status(400).send({ message: "No user sessions currently active." });
        // return;
    // }

    const result = await bookQueries.bookSearch(req.query);

    if (result == "") {
        res.status(400).send({ message: "No results found." });
        return;
    }
    res.status(200).send(result);
});


/**
 * @returns
 *  - Title
 *  - Author first name
 *  - Author last name
 *  - Genre
 *  - ISBN
 *  - Description
 *
 * @usage
 *  - /api/book/[idnum]
 *    where idnum is a book_id number or book isbn
 */

router.get("/:id", async (req, res) => {
    const { id } = req.params;
    const result = await bookQueries.bookByID(id);

    if (result == "") {
        res.status(400).send({ message: "No book results found." });
        return;
    }
    res.status(200).send(result);
});

module.exports = router;
