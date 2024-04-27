const express = require("express");
const router = express.Router();
const userQueries = require("../databaseQueries/userQueries")
const reviewQueries = require("../databaseQueries/reviewQueries");


router.post("/", async (req, res) => {
    const user = req.session.user || (await userQueries.readUserSession());
    const { book_id, stars, content } = req.body;
    const result = await reviewQueries.createReview(user.user_id, book_id, stars, content);
    console.log(result)
    res.status(200).send(result);
})

/**
 * @returns
 *  - username
 *  - star value
 *  - review content
 *
 * @usage
 *  - /api/reviews/[id]?{stars=[1-5]}
 *    where [id] is a book_id num, stars is optional 1-5 int filter
 */

router.get("/:id", async (req, res) => {
    const { id } = req.params;
    const { stars } = req.query;
    const result = await reviewQueries.bookReviewsById(id, stars);

    //Filter by star rating
    if(result == "" && (stars !== undefined && stars !== "")){
        res.status(400).send({ message: "No results found based on parsed star filter."});
        return;

    }else if(result == "" && (stars === undefined || stars === "")){
        res.status(400).send({ message: "Book ID not found."});
        return;

    }
    res.status(200).send(result);


});

module.exports = router;
