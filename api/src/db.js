const { Client } = require("pg");

const connectionConfig = {
    host: "postgres",
    port: 5432,
    database: "bookboard",
    user: "postgres",
    password: "postgres",
};

const client = new Client(connectionConfig);
client.connect();

const query = (text, params) => {
    return client.query(text, params);
}


module.exports = {query};
