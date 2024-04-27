const express = require("express");
const session = require("express-session");
const cors = require("cors");
const { getAuthor } = require("./databaseQueries/authorQueries");
const userQueries = require("./databaseQueries/userQueries");
const user = require("./endpoints/user");
const book = require("./endpoints/book");
const review = require("./endpoints/reviews");

const app = express();
app.use(cors());
app.use(express.json());
app.use(session({
    secret: 'Hennessey and Sailor Moon',
    resave: false,
    saveUninitialized: false,
}));

app.use('/api/user', user);
app.use('/api/book', book);
app.use("/api/review", review);
app.get("/", (req, res) => {});

app.post("/create/user", async (req, res) => {
    res.send({ message: "You successfully contacted the api." });
});

app.get("/read/user", async (_, res) => {
    const result = await userQueries.readUserShelf(
        { id: 0, username: "feras", password: "password" },
        false
    );
    res.send(result);
});

module.exports = { app };

const port = 3001;
app.listen(port, () => console.log(`Server running on port ${port}`));
