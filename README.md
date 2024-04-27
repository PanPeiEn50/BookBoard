## About This Project
CSE412 Group Project

## Getting Started

### Prerequisites

- [Git](https://git-scm.com/)
- [Docker](https://www.docker.com/)
- [NodeJS](https://nodejs.org/en)

### Installation

1. Clone this repository and 

    ```sh
    git clone https://github.com/FigoFeras1/bookboard.git && cd bookboard
    ```

2. `npm install` in `client` and `api`

    ```sh
    (cd api && npm install) && (cd client && npm install)
    ```

3. Run the docker containers

   ```sh
   docker compose up --build -d postgres && sleep 10 && docker compose up --build -d
   ```

4. To shut down the containers, you can use the following command

    ```sh
    docker compose down --timeout 10
    ```


## Miscellaneous

1. To get the SQL dump of the database, you can do

    ```sh
    docker exec bookboard-postgres /bin/bash -c "pg_dump -U postgres -w -F p bookboard > dump.sql" 
    && docker cp bookboard-postgres:dump.sql dump.sql
    ```

