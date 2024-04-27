import random

reviews = []
with open('reviews.txt', 'r') as file:
    for line in file:
        review = tuple(line.strip().replace("'", "''").replace('"', "'").split(';'))
        reviews.append(review)

query = 'INSERT INTO reviews VALUES ({}, {}, {}, {});'


combinations = []
for _ in reviews:
    user_id = random.randint(0,3)
    book_id = random.randint(0,210)
    review = reviews[random.randint(0,len(reviews)-1)]
    while (user_id, book_id) in combinations:
        user_id = random.randint(0,3)
        book_id = random.randint(0,210)
    print(query.format(user_id, book_id, int(review[1]), review[0]))
    combinations.append((user_id, book_id))
