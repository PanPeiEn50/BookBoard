const express = require("express");
const router = express.Router();
const userQueries = require("../databaseQueries/userQueries");

/**
 * @returns
 *  - user_id
 *  - username
 *  - password
 *
 * @usage
 *  - /api/user/
 *    Requires user be logged in via /api/user/login endpoint which
 *    needs user JSON object in body of request with username and/or
 *    password
 */
router.get("/", async (req, res) => {
    const user = req.session.user || (await userQueries.readUserSession());

    if (user) {
        const info = await userQueries.readUser(user);
        res.status(200).send(info);
    } else {
        res.status(400).send({ message: "No active session for user" });
    }
});

/**
 * Updates password of currently logged in user.
 *
 * @param password New password in req.body.
 *
 * @returns Success message if password was updated successfully,
 *          otherwise an error message.
 */
router.patch("/", async (req, res) => {
    const user = req.session.user || (await userQueries.readUserSession())
    const { password } = req.body;

    if (!password) {
        res.status(400).send({ message: "Missing parameter: password" });
        return;
    }

    if (user) {
        await userQueries.updatePassword(user, password);
        res.status(200).send({ message: "success" });
    } else {
        res.status(400).send({ message: "No active session for user" });
    }
})

// TBD
router.post("/", (req, res) => {
    const { username, password } = req.body;
    // create_or_fetch_user(username, password)
    console.log(username, password);
    res.status(200).send({ message: "success" });
});

/**
 * @returns
 *  - Shelf of logged in user
 *      - book_id
 *      - author first name
 *      - author last name
 *      - title
 *      - genre
 *      - description
 *      - read
 *
 * @usage
 *  - /api/user/shelf?{book_id}&{read=true/false}&{pagenum=[1-99]}&pagesize=[20,25,50]
 *    Where ?{} are optional flags and read being a filter
 */
router.get("/shelf", async (req, res) => {
    const user = req.session.user || (await userQueries.readUserSession());
    const { book_id, read, pagenum, pagesize } = req.query;

    if (!user) {
        res.status(400).send({ message: "No user sessions currently active." });
        return;
    }

    const shelf = await userQueries.readUserShelf(
        user,
        book_id,
        read,
        pagenum,
        pagesize
    );
    res.status(200).send(shelf);
});

/**
 * @returns
 *  -Confirmation message
 *
 * @usage
 *  - /api/user/shelf/[id]
 *    where [id] is a book_id num to be deleted
 */
router.delete("/shelf/:id", async (req, res) => {
    const user = req.session.user || (await userQueries.readUserSession());
    const { id } = req.params;

    if (!user) {
        res.status(400).send({ message: "No user sessions currently active." });
        return;
    }

    await userQueries.deleteUserShelf(id, user.user_id);
    res.status(200).send({ message: "Shelf item deleted successfully." });
});

/**
 * @returns
 *  - Confirmation message
 *
 * @usage
 *  - /api/users/[id]
 *    where [id] is a book_id num to be added
 */
router.post("/shelf/:id", async (req, res) => {
    const user = req.session.user || (await userQueries.readUserSession());
    const { id } = req.params;

    if (!user) {
        res.status(400).send({ message: "No user sessions currently active." });
        return;
    }

    await userQueries.addUserShelf(id, user.user_id);
    res.status(200).send({ message: "Shelf item added successfully." });
});

/**
 * @returns
 *  - Confirmation Message
 *
 * @usage
 *  - /api/users/[id]
 *    where [id] is a book_id to update related read flag
 */
router.put("/shelf/:id", async (req, res) => {
    const user = req.session.user || (await userQueries.readUserSession());
    const { id } = req.params;

    if (!user) {
        res.status(400).send({ message: "No user sessions currently active." });
        return;
    }

    await userQueries.modifyUserShelf(id, user.user_id);
    res.status(200).send({ message: "Shelf item updated." });
});

/**
 * Provided a username and password in a user JSON object, and if the user exists,
 * start a new session for the specified user.
 */

router.post("/login", async (req, res) => {
    const existing = req.session.user || (await userQueries.readUserSession());
    const { user } = req.body;

    if (existing) {
        userQueries.deleteUserSession(existing)
    }

    if (user && user.username && user.password) {
        const userInfo = await userQueries.readUser(user);

        if (!userInfo) {
            res.status(400).send({ message: "User does not exist." });
        } else {
            await userQueries.createUserSession(userInfo);
            req.session.user = userInfo;``

            res.status(200).send({ message: "Login successful." });
        }
    } else {
        res.status(400).send({
            message: `Failed to log in user: insufficient information supplied.`,
        });
    }
});

/**
 * End the current user session. No information is required for this.
 *
 */
router.get("/logout", async (req, res) => {
    const user = req.session.user || (await userQueries.readUserSession());

    if (user) {
        req.session.user = undefined;
        const rows = await userQueries.deleteUserSession(user);

        if (rows == 0) {
            res.status(400).send({ message: "No sessions currently exist." });
        }

        res.status(200).send({ message: "user session ended." });
    } else {
        res.status(400).send({ message: "No sessions currently exist." });
    }
});

/**
 * Provided a user with a user name and password, this will attempt to insert
 * the user to the database. The password length handling must be done on the
 * client-side.
 *
 */
router.post("/signup", async (req, res) => {
    const { user } = req.body;

    if (!user) {
        res.status(400).send({ message: "No user provided." });
        return;
    }

    const result = await userQueries.createUser(user);
    if (result === true) {
        res.status(200).send({ message: "User created successfully." });
        return;
    } else {
        res.status(400).send(result);
    }
});

/**
 * @returns
 *  - Confirmation Message
 *
 * @usage
 *  - /api/users/
 *    This will delete the user from the database and user will need to
 *    sign up again to log in
 */
router.delete("/", async (req, res) => {
    const user = req.session.user || (await userQueries.readUserSession());

    if (user) {
        const result = await userQueries.deleteUser(user);

        res.status(200).send({ message: "User successfully deleted." });
        return;
    } else {
        res.status(400).send({ message: "No user sessions currently active." });
    }
});

module.exports = router;
