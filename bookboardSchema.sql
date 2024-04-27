SET TIME ZONE 'MST';

CREATE TABLE IF NOT EXISTS users
(
    user_id  SERIAL PRIMARY KEY,
    username VARCHAR(32) NOT NULL UNIQUE,
    password VARCHAR(256) NOT NULL
);

CREATE TABLE IF NOT EXISTS authors
(
    author_id       SERIAL PRIMARY KEY,
    first_name      VARCHAR(64),
    last_name       VARCHAR(128),
    date_of_birth   VARCHAR(64),
    number_of_books INT NOT NULL
);

CREATE TABLE IF NOT EXISTS books
(
    book_id     SERIAL PRIMARY KEY,
    isbn        BIGINT NOT NULL UNIQUE,
    title       TEXT NOT NULL,
    description TEXT NOT NULL,
    genre       VARCHAR(64) NOT NULL,
    fiction     BOOLEAN NOT NULL
);

CREATE TABLE IF NOT EXISTS book_author
(
    book_id     INT NOT NULL,
    author      INT NOT NULL,
    PRIMARY KEY (book_id, author),
    FOREIGN KEY (book_id) REFERENCES books(book_id),
    FOREIGN KEY (author) REFERENCES authors(author_id)
);

-- TODO: Rename this to shelf, allows any combination of read/favorite
CREATE TABLE IF NOT EXISTS favorites
(
    user_id     INT NOT NULL,
    book_id     INT NOT NULL,
    read        BOOLEAN DEFAULT FALSE,
    PRIMARY KEY (user_id, book_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (book_id) REFERENCES books(book_id)
);

CREATE TABLE IF NOT EXISTS reviews
(
    user_id INT NOT NULL,
    book_id INT NOT NULL,
    stars      SMALLINT NOT NULL CHECK (stars >= 1 AND stars <= 5),
    content    TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT now(),
    updated_at TIMESTAMP DEFAULT now(),
    PRIMARY KEY (user_id, book_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (book_id) REFERENCES books(book_id)
);



-- CREATE VIEW BookAuthorReviewView AS 
--     SELECT DISTINCT books.book_id, title, first_name, last_name, genre, isbn, 
--                     description, stars
--     FROM books, book_author, authors, reviews
--     WHERE books.book_id = book_author.book_id 
--       AND book_author.author = authors.author_id;

-- Create a function to update updated_at when a row is updated
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create a trigger to call the function on update
CREATE TRIGGER update_review
BEFORE UPDATE ON reviews
FOR EACH ROW
EXECUTE FUNCTION update_updated_at();

CREATE EXTENSION pg_trgm;

INSERT INTO users (user_id, username, password) VALUES (0, 'feras', 'password');
INSERT INTO users (username, password) VALUES ('trevor', 'password');
INSERT INTO users (username, password) VALUES ('david', 'password');
INSERT INTO users (username, password) VALUES ('dave', 'password');
INSERT INTO users (username, password) VALUES ('mary', 'password');
INSERT INTO users (username, password) VALUES ('karen', 'password');
INSERT INTO users (username, password) VALUES ('john', 'password');
INSERT INTO users (username, password) VALUES ('bill', 'password');
INSERT INTO users (username, password) VALUES ('mark', 'password');
INSERT INTO users (username, password) VALUES ('rory', 'password');
INSERT INTO users (username, password) VALUES ('cory', 'password');
INSERT INTO users (username, password) VALUES ('raj', 'password');
INSERT INTO users (username, password) VALUES ('mr bean', 'password');
INSERT INTO users (username, password) VALUES ('booklover123', 'password');
INSERT INTO users (username, password) VALUES ('fictionreader7000', 'password');


INSERT INTO books VALUES (DEFAULT, 9781598048889, 'Official Congressional Directory', 'Book digitized by Google from the library of the University of Michigan and uploaded to the Internet Archive by user tpb.', 'architecture', false);
INSERT INTO authors VALUES (DEFAULT, 'US', 'GOVERNMENT', 'July 4, 1776', 23669);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'Official Congressional Directory') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'US' AND last_name = 'GOVERNMENT') AS a1;
INSERT INTO books VALUES (DEFAULT, 9781000334234, 'Analysing Architecture', 'Analysing Architecture offers a unique notebook of architectural strategies to present an engaging introduction to elements and concepts in architectural design. Beautifully illustrated throughout with the authors original drawings, examples are drawn from across the world, and from many periods architectural history (from prehistoric times to the very recent past), to illustrate analytical themes and to show how drawing can be used to study architecture.In this second edition the framework for analysis has been revised and enlarged, and further case studies added. Many new drawings have been included, illustrating further examples of the themes explored. The link between analysis and learning about the possibilities of design has been reinforced, and the bibliography of recommended supplementary reading has been expanded.Simon Unwin clearly identifies the key elements of architecture and conceptual themes apparent in buildings, and other works of architecture such as gardens and cities. He describes ideas for use in the active process of design. Breaking down the grammar of architecture into themes and moves, Unwin exposes its underlying patterns to reveal the organisational strategies that lie beneath the superficial appearances of buildings. Exploring buildings as results of the interaction of people with the world around them, Analysing Architecture offers a definition of architecture as identification of place and provides a greater understanding of architecture as a creative discipline. This book presents a powerful impetus for readers to develop their own capacities for architectural design.', 'architecture', false);
INSERT INTO authors VALUES (DEFAULT, 'Simon', 'Unwin', '1952', 27);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'Analysing Architecture') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Simon' AND last_name = 'Unwin') AS a1;
INSERT INTO books VALUES (DEFAULT, 9781441856920, 'Creepers', '"Creepers" are urban explorers who illegally enter sealed buildings.', 'architecture', true);
INSERT INTO authors VALUES (DEFAULT, 'David', 'Morrell', '1943', 96);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'Creepers') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'David' AND last_name = 'Morrell') AS a1;
INSERT INTO books VALUES (DEFAULT, 9780500201770, 'The Classical Language of Architecture', 'Sir John Summersons short (roughly 80 page) classic is an informal yet trenchant explanation of the classical grammar that has shaped Western architecture from antiquity through the current age. Various architectural elements and styles are explained in a delightful prose that engages and informs.', 'architecture', false);
INSERT INTO authors VALUES (DEFAULT, 'Summerson, John', 'Newenham', '1904', 48);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'The Classical Language of Architecture') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Summerson, John' AND last_name = 'Newenham') AS a1;
INSERT INTO books VALUES (DEFAULT, 9780340844021, 'Castle (Stephen Biestys Cross-Sections)', 'Describes medieval castles and what life was like for the knights who lived in them.', 'architecture', false);
INSERT INTO authors VALUES (DEFAULT, 'Stephen', 'Biesty', '1961-01-27', 36);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'Castle (Stephen Biestys Cross-Sections)') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Stephen' AND last_name = 'Biesty') AS a1;
INSERT INTO books VALUES (DEFAULT, 9780808507666, 'Cathedral', 'The Gothic cathedral is one of mans most magnificent expressions as well as one of his grandest architectural achievements. Built to the glory of God, each cathedral was created by the ingenuity, skill, and hard work of generations of dedicated people. Text and detailed drawings follow the planning and construction of a magnificent Gothic cathedral in the imaginary French town of Chutreaux during the thirteenth century. - Publisher.', 'architecture', false);
INSERT INTO authors VALUES (DEFAULT, 'David', 'Macaulay', '2 December 1946', 99);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'Cathedral') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'David' AND last_name = 'Macaulay') AS a1;
INSERT INTO books VALUES (DEFAULT, 9781435201453, 'Castle', 'Text and detailed drawings follow the planning and construction of a "typical" castle and adjoining town in thirteenth-century Wales.', 'architecture', false);
INSERT INTO authors VALUES (DEFAULT, 'David', 'Macaulay', '2 December 1946', 99);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'Castle') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'David' AND last_name = 'Macaulay') AS a1;
INSERT INTO books VALUES (DEFAULT, 9780641611162, 'Art Through the Ages', 'Contains:

 - Volume I: [Ancient, Medieval, and Non-European Art](https://openlibrary.org/works/OL18151172W/Ancient_Medieval_and_Non-European_Art)
 - Volume II: [Renaissance and Modern Art](https://openlibrary.org/works/OL15125458W/Renaissance_and_Modern_Art)
 - Book B: [The Middle Ages](https://openlibrary.org/works/OL17551781W/The_Middle_Ages)
 - Book D: [Renaissance and Baroque](https://openlibrary.org/works/OL16584968W/Renaissance_and_Baroque)
 - Book E: [Modern Europe and America](https://openlibrary.org/works/OL17527112W/Modern_Europe_and_America)
 - Book F: [Non-Western Art to 1300](https://openlibrary.org/works/OL3002702W/Non-Western_Art_to_1300)

Since publication of the first edition in 1926, Helen Gardner’s Art through the Ages has been a favorite with generations of students and general readers, who have found it an exciting and informative survey. Miss Gardner’s enthusiasm, knowledge, and humanity have made it possible for the beginner to learn how to see and thereby to penetrate the seeming mysteries of even the most complex artistic achievements. Every effort has been made in this volume to preserve her freshness and simplicity of style and, above all, her sympathetic approach to individual works of art and to the styles of which they are a part.', 'art history', false);
INSERT INTO authors VALUES (DEFAULT, 'Gardner,', 'Helen', '1878', 19);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'Art Through the Ages') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Gardner,' AND last_name = 'Helen') AS a1;
INSERT INTO books VALUES (DEFAULT, 9780155037595, 'Ancient, Medieval, and Non-European Art', 'Volume I of [Gardners Art Through the Ages](https://openlibrary.org/works/OL3002703W/Gardners_Art_Through_the_Ages)', 'art history', false);
INSERT INTO authors VALUES (DEFAULT, 'Gardner,', 'Helen', '1878', 19);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'Ancient, Medieval, and Non-European Art') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Gardner,' AND last_name = 'Helen') AS a1;
INSERT INTO books VALUES (DEFAULT, 9789638626950, 'Wie man leben soll', 'Karl »Charlie« Kolostrum ist jung und stellt sich die entscheidende Frage, wie man eigentlich leben soll. Als Teil einer völlig überspannten Familie und Sohn einer Mutter, deren Neigung zu Alkohol und Promiskuität den Vater beizeiten verjagte, war er früh sich selbst überlassen und beschäftigte sich hauptsächlich mit der eigenen Person und ihrer Wirkung auf andere. Jetzt scheint es ihm an der Zeit, ein paar Lebensregeln aufzustellen ...', 'art history', false);
INSERT INTO authors VALUES (DEFAULT, 'Thomas', 'Glavinic', '2. April 1972', 14);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'Wie man leben soll') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Thomas' AND last_name = 'Glavinic') AS a1;
INSERT INTO books VALUES (DEFAULT, 9788582850596, '陰翳礼讃 (Inei raisan)', '"This is a powerfully anti-modernist book, yet contains the most beautiful evocation of the traditional Japanese aesthetic, which cast such a spell on Ludwig Mies van der Rohe and Frank Lloyd Wright.

"The contradiction is easily explained: Tanizaki sees the empty Japanese wall as not empty at all, but a surface on which light continually traces its fugitive presence against encroaching shadow. He constructs a myth of the origin of the Japanese house: it began with a roof and overhanging eaves, which cast a shadow on the earth, calling forth a shelter."

Read more: http://www.bdonline.co.uk/story.asp?storycode=3159684&origin=BDweeklydigest#ixzz0iOulXDEW', 'design', false);
INSERT INTO authors VALUES (DEFAULT, 'Junʾichirō', 'Tanizaki', '1886', 142);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = '陰翳礼讃 (Inei raisan)') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Junʾichirō' AND last_name = 'Tanizaki') AS a1;
INSERT INTO books VALUES (DEFAULT, 9781118057384, 'Beginning JavaScript', 'JavaScript is a scripting language that enables you to enhance static web applications by providing dynamic, personalized, and interactive content. This improves the experience of visitors to your site and makes it more likely that they will visit again. You must have seen the flashy drop-down menus, moving text, and changing content that are now widespread on web sites--they are enabled through JavaScript. Supported by all the major browsers, JavaScript is the language of choice on the Web. It can even be used outside web applications--to automate administrative tasks, for example.  This book aims to teach you all you need to know to start experimenting with JavaScript: what it is, how it works, and what you can do with it. Starting from the basic syntax, youll move on to learn how to create powerful web applications. Dont worry if youve never programmed before--this book will teach you all you need to know, step by step. Youll find that JavaScript can be a great introduction to the world of programming: with the knowledge and understanding that youll gain from this book, youll be able to move on to learn newer and more advanced technologies in the world of computing.  In order to get the most out of this book, youll need to have an understanding of HTML and how to create a static web page. You dont need to have any programming experience.  This book will also suit you if you have some programming experience already, and would like to turn your hand to web programming. You will know a fair amount about computing concepts, but maybe not as much about web technologies.  Alternatively, you may have a design background and know relatively little about the Web and computing concepts. For you, JavaScript will be a cheap and relatively easy introduction to the world of programming and web application development.  Whoever you are, we hope that this book lives up to your expectations.  Youll begin by looking at exactly what JavaScript is, and taking your first steps with the underlying language and syntax. Youll learn all the fundamental programming concepts, including data and data types, and structuring your code to make decisions in your programs or to loop over the same piece of code many times.  Once youre comfortable with the basics, youll move on to one of the key ideas in JavaScript--the object. Youll learn how to take advantage of the objects that are native to the JavaScript language, such as dates and strings, and find out how these objects enable you to manage complex data and simplify your programs. Next, youll see how you can use JavaScript to manipulate objects made available to you in the browser, such as forms, windows, and other controls. Using this knowledge, you can start to create truly professional-looking applications that enable you to interact with the user.  Long pieces of code are very hard to get right every time--even for the experienced programmer--and JavaScript code is no exception. You look at common syntax and logical errors, how you can spot them, and how to use the Microsoft Script Debugger to aid you with this task. Also, you need to examine how to handle the errors that slip through the net, and ensure that these do not detract from the experience of the end user of your application.  From here, youll move on to more advanced topics, such as using cookies and jazzing up your web pages with dynamic HTML and XML. Finally, youll be looking at a relatively new and exciting technology, remote scripting. This allows your JavaScript in a HTML page to communicate directly with a server, and useful for, say, looking up information on...', 'design', false);
INSERT INTO authors VALUES (DEFAULT, 'Paul', 'Wilton', '1969', 9);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'Beginning JavaScript') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Paul' AND last_name = 'Wilton') AS a1;
INSERT INTO books VALUES (DEFAULT, 9780132809818, 'HTML for the World Wide Web with XHTML and CSS', 'Need to learn HTML fast? This best-selling references visual format and step-by-step, task-based instructions will have you up and running with HTML in no time. In this completely updated edition of our best-selling guide to HTML, Web expert and best-selling author Elizabeth Castro uses crystal-clear instructions and friendly prose to introduce you to all of todays HTML and XHTML essentials. Youll learn how to design, structure, and format your Web site. Youll create and use images, links, styles, lists, tables, frames, and forms, and youll add sound and movies to your site. Finally, you will test and debug your site, and publish it to the Web. Along the way, youll find extensive coverage of CSS techniques, current browsers (Opera, Safari, Firefox), creating pages for the mobile Web, and more. Visual QuickStart Guide--the quick and easy way to learn! Easy visual approach uses pictures to guide you through HTML and show you what to do. Concise steps and explanations get you up and running in no time. Page for page, the best content and value around. Companion Web site at www.cookwood.com/html offers examples, a lively question-and-answer area, updates, and more.', 'design', false);
INSERT INTO authors VALUES (DEFAULT, 'Elizabeth', 'Castro', '1965', 26);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'HTML for the World Wide Web with XHTML and CSS') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Elizabeth' AND last_name = 'Castro') AS a1;
INSERT INTO books VALUES (DEFAULT, 9781484412398, 'Eve & Adam', 'After being in a car accident, a patient recovering in her mothers research facility is given the task of creating the perfect boy using detailed simulation technologies.', 'design', true);
INSERT INTO authors VALUES (DEFAULT, 'Michael', 'Grant', 'July 26, 1954', 41);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'Eve & Adam') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Michael' AND last_name = 'Grant') AS a1;
INSERT INTO books VALUES (DEFAULT, 9783737202268, 'Treasure Island', 'Traditionally considered a coming-of-age story, Treasure Island is an adventure tale known for its atmosphere, characters and action, and also as a wry commentary on the ambiguity of morality — as seen in Long John Silver — unusual for childrens literature then and now. It is one of the most frequently dramatized of all novels. The influence of Treasure Island on popular perceptions of pirates is enormous, including treasure maps marked with an "X", schooners, the Black Spot, tropical islands, and one-legged seamen carrying parrots on their shoulders', 'fantasy', true);
INSERT INTO authors VALUES (DEFAULT, 'Robert Louis', 'Stevenson', '13 November 1850', 5142);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'Treasure Island') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Robert Louis' AND last_name = 'Stevenson') AS a1;
INSERT INTO books VALUES (DEFAULT, 9798408524822, 'Through the Looking-Glass', '*Through the Looking-Glass, and What Alice Found There* (1871) is a work of childrens literature by Lewis Carroll (Charles Lutwidge Dodgson), generally categorized in the fairy tale genre. It is the sequel to *Alices Adventures in Wonderland* (1865). Although it makes no reference to the events in the earlier book, the themes and settings of *Through the Looking-Glass* make it a kind of mirror image of Wonderland: the first book begins outdoors, in the warm month of May, uses frequent changes in size as a plot device, and draws on the imagery of playing cards; the second opens indoors on a snowy, wintry night exactly six months later, on November 4 (the day before Guy Fawkes Night), uses frequent changes in time and spatial directions as a plot device, and draws on the imagery of chess. In it, there are many mirror themes, including opposites, time running backwards, and so on. ([Wikipedia][1])


  [1]: http://en.wikipedia.org/wiki/Through_the_Looking-Glass', 'fantasy', true);
INSERT INTO authors VALUES (DEFAULT, 'Carroll,', 'Lewis', 'January 27, 1832', 5);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'Through the Looking-Glass') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Carroll,' AND last_name = 'Lewis') AS a1;
INSERT INTO books VALUES (DEFAULT, 9781719999854, 'Five Children and It', 'Havent you ever thought what you would wish for if you were granted three wishes? In Nesbits delightful classic, five siblings find a creature that grants their wishes, but as the old saying goes: be careful what you wish for, it might come true...', 'fantasy', true);
INSERT INTO authors VALUES (DEFAULT, 'E.', 'Nesbit', '15 August 1858', 32);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'Five Children and It') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'E.' AND last_name = 'Nesbit') AS a1;
INSERT INTO books VALUES (DEFAULT, 9798736670154, 'Phantastes', 'One of George MacDonalds most important works, Phantastes is the story of a young man named Anotos and his long dreamlike journey in Fairy Land. It is the fairy tale of deep spiritual insight as Anotos makes his way through moments of uncertainty and peril and mistakes that can have irreversible consequences. This is also his spiritual quest that is destined to end with the supreme surrender of the self. When he finally experiences the hard-won surrender, a wave of joy overwhelms him. His intense personal introspection is honest as he is offered the full range of symbolic choices--great beauty, horrifying ugliness, irritating goblins, nurturing spirits. Each confrontation in Fairy Land allows Anotos to learn many necessary lessons. As he continues on the journey, many shadowy beings threaten his spiritual well-being and compel him to sing. The songs are irresistible to a beautiful White Lady who is freed from inside a statue by the music, and Anotos remains captivated by her for a long time. He sees the world more objectively; his trek invites a natural descent into feelings of pride and egotism. But his losses and sorrows coalesce themselves into things of grace, and these experiences help his spiritual growth.     Please Note:  This book has been reformatted to be easy to read in true text, not scanned images that can sometimes be difficult to decipher.  The Microsoft eBook has a contents page linked to the chapter headings for easy navigation. The Adobe eBook has bookmarks at chapter headings and is printable up to two full copies per year.  Both versions are text searchable.', 'fantasy', true);
INSERT INTO authors VALUES (DEFAULT, 'MacDonald,', 'George', '1824', 19);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'Phantastes') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'MacDonald,' AND last_name = 'George') AS a1;
INSERT INTO books VALUES (DEFAULT, 9788845271403, 'The Hobbit', 'The Hobbit is a tale of high adventure, undertaken by a company of dwarves in search of dragon-guarded gold. A reluctant partner in this perilous quest is Bilbo Baggins, a comfort-loving unambitious hobbit, who surprises even himself by his resourcefulness and skill as a burglar.

Encounters with trolls, goblins, dwarves, elves, and giant spiders, conversations with the dragon, Smaug, and a rather unwilling presence at the Battle of Five Armies are just some of the adventures that befall Bilbo.

Bilbo Baggins has taken his place among the ranks of the immortals of children’s fiction. Written by Professor Tolkien for his children, The Hobbit met with instant critical acclaim when published.', 'fantasy', true);
INSERT INTO authors VALUES (DEFAULT, 'J. R. R.', 'Tolkien', '3 January 1892', 680);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'The Hobbit') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'J. R. R.' AND last_name = 'Tolkien') AS a1;
INSERT INTO books VALUES (DEFAULT, 9781689585019, 'Ozma of Oz', 'When a storm blows Dorothy to the land of Ev where lunches grow on trees, she meets the Scarecrow, the Tin Woodman, the Cowardly Lion, and Princess Ozma, and together they set out to free the Queen of Ev and her ten children.', 'fantasy', false);
INSERT INTO authors VALUES (DEFAULT, 'Baum, L.', 'Frank', '15 May 1856', 1);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'Ozma of Oz') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Baum, L.' AND last_name = 'Frank') AS a1;
INSERT INTO books VALUES (DEFAULT, 9798405386553, 'The Emerald City of Oz', 'From the book:Perhaps I should admit on the title page that this book is "By L. Frank Baum and his correspondents," for I have used many suggestions conveyed to me in letters from children. Once on a time I really imagined myself "an author of fairy tales," but now I am merely an editor or private secretary for a host of youngsters whose ideas I am requestsed to weave into the thread of my stories. These ideas are often clever. They are also logical and interesting. So I have used them whenever I could find an opportunity, and it is but just that I acknowledge my indebtedness to my little friends.', 'fantasy', true);
INSERT INTO authors VALUES (DEFAULT, 'Baum, L.', 'Frank', '15 May 1856', 1);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'The Emerald City of Oz') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Baum, L.' AND last_name = 'Frank') AS a1;
INSERT INTO books VALUES (DEFAULT, 9781408883730, 'Harry Potter and the Philosophers Stone', 'Harry Potter #1

When mysterious letters start arriving on his doorstep, Harry Potter has never heard of Hogwarts School of Witchcraft and Wizardry.

They are swiftly confiscated by his aunt and uncle.

Then, on Harry’s eleventh birthday, a strange man bursts in with some important news: Harry Potter is a wizard and has been awarded a place to study at Hogwarts.

And so the first of the Harry Potter adventures is set to begin.
([source][1])


  [1]: https://www.jkrowling.com/book/harry-potter-philosophers-stone/', 'fantasy', true);
INSERT INTO authors VALUES (DEFAULT, 'J. K.', 'Rowling', '31 July 1965', 471);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'Harry Potter and the Philosophers Stone') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'J. K.' AND last_name = 'Rowling') AS a1;
INSERT INTO books VALUES (DEFAULT, 9798507755530, 'The Road to Oz', 'Dorothy and her friends follow the enchanted road to Oz and arrive in time for Ozmas birthday party.', 'fantasy', true);
INSERT INTO authors VALUES (DEFAULT, 'Baum, L.', 'Frank', '15 May 1856', 1);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'The Road to Oz') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Baum, L.' AND last_name = 'Frank') AS a1;
INSERT INTO books VALUES (DEFAULT, 9789756446294, 'The Enchanted Castle', 'E. Nesbits classic story of how Gerald, Cathy and Jimmy find an enchanted garden and awake a princess from a hundred-year sleep, only to have her immediately made invisible by a magic ring. Her rescue is difficult, funny and sometimes frightening.', 'fantasy', true);
INSERT INTO authors VALUES (DEFAULT, 'E.', 'Nesbit', '15 August 1858', 32);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'The Enchanted Castle') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'E.' AND last_name = 'Nesbit') AS a1;
INSERT INTO books VALUES (DEFAULT, 9798569479252, 'The Lost Princess of Oz', 'When Princess Ozma and all the magic of the Land of Oz are mysteriously stolen away, Dorothy and the other residents of Oz are determined to find their missing ruler and the thief responsible for her disappearance.', 'fantasy', true);
INSERT INTO authors VALUES (DEFAULT, 'Baum, L.', 'Frank', '15 May 1856', 1);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'The Lost Princess of Oz') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Baum, L.' AND last_name = 'Frank') AS a1;
INSERT INTO books VALUES (DEFAULT, 9782035846495, 'Le Tour du Monde en Quatre-Vingts Jours', 'Phileas Fogg, a very punctual man had broken into an argument while conversing about the recent bank robbery. To keep his word of proving that he would travel around the world in 80 days and win the bet, he sets on a long trip, where he is joined by a few other people on the way. A wonderful adventure is about to begin!', 'fantasy', true);
INSERT INTO authors VALUES (DEFAULT, 'Jules', 'Verne', '8 February 1828', 4789);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'Le Tour du Monde en Quatre-Vingts Jours') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Jules' AND last_name = 'Verne') AS a1;
INSERT INTO books VALUES (DEFAULT, 9780844664958, 'The Patchwork Girl of Oz', '"Wheres the butter, Unc Nunkie?" asked Ojo.', 'fantasy', false);
INSERT INTO authors VALUES (DEFAULT, 'Baum, L.', 'Frank', '15 May 1856', 1);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'The Patchwork Girl of Oz') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Baum, L.' AND last_name = 'Frank') AS a1;
INSERT INTO books VALUES (DEFAULT, 9788324019403, 'The Phoenix and the Carpet', 'Five British children discover in their new carpet an egg, which hatches into a phoenix that takes them on a series of fantastic adventures around the world.', 'fantasy', true);
INSERT INTO authors VALUES (DEFAULT, 'E.', 'Nesbit', '15 August 1858', 32);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'The Phoenix and the Carpet') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'E.' AND last_name = 'Nesbit') AS a1;
INSERT INTO books VALUES (DEFAULT, 9781977043863, 'The Sea Fairies', 'This is a tale of life beneath the sea, of mermaids and sea serpents and other strange inhabitants of the ocean depths. A little girl named Trot and Capn Bill, an old sailor, are invited by several mermaids to come and visit their under-water home. Baum wrote this story in the hope of interesting his readers in something other than Oz; in the preface he writes: "I hope my readers who have so long followed Dorothys adventures in the Land of Oz will be interested in Trots equally strange experiences." Of course, he did not succeed in distracting his fans from Oz, yet the book was eagerly read; the result of this attempt was that he was forced to introduce Trot and Capn Bill into the later Oz stories.', 'fantasy', true);
INSERT INTO authors VALUES (DEFAULT, 'Baum, L.', 'Frank', '15 May 1856', 1);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'The Sea Fairies') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Baum, L.' AND last_name = 'Frank') AS a1;
INSERT INTO books VALUES (DEFAULT, 9798770757804, 'The Tin Woodman of Oz', 'From the book:The Tin Woodman sat on his glittering tin throne in the handsome tin hall of his splendid tin castle in the Winkie Country of the Land of Oz. Beside him, in a chair of woven straw, sat his best friend, the Scarecrow of Oz. At times they spoke to one another of curious things they had seen and strange adventures they had known since first they two had met and become comrades. But at times they were silent, for these things had been talked over many times between them, and they found themselves contented in merely being together, speaking now and then a brief sentence to prove they were wide awake and attentive. But then, these two quaint persons never slept. Why should they sleep, when they never tired?', 'fantasy', true);
INSERT INTO authors VALUES (DEFAULT, 'Baum, L.', 'Frank', '15 May 1856', 1);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'The Tin Woodman of Oz') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Baum, L.' AND last_name = 'Frank') AS a1;
INSERT INTO books VALUES (DEFAULT, 9798408503575, 'Sky Island', 'Button-Brights adventures begin when he finds a magic umbrella that will carry him anywhere in the world.', 'fantasy', false);
INSERT INTO authors VALUES (DEFAULT, 'Baum, L.', 'Frank', '15 May 1856', 1);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'Sky Island') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Baum, L.' AND last_name = 'Frank') AS a1;
INSERT INTO books VALUES (DEFAULT, 9781688845763, 'Rinkitink in Oz', 'When all the inhabitants of Pingaree are kidnapped by the mongrel hordes of twin island kingdoms, Prince Inga and his friend King Rinkitink decide to go to the rescue.', 'fantasy', true);
INSERT INTO authors VALUES (DEFAULT, 'Baum, L.', 'Frank', '15 May 1856', 1);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'Rinkitink in Oz') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Baum, L.' AND last_name = 'Frank') AS a1;
INSERT INTO books VALUES (DEFAULT, 9781016307345, 'Glinda of Oz', 'The Sorceress and Wizard of Oz attempt to save Princess Ozma and Dorothy from the dangers which threaten them when they try to bring peace to two warring tribes.', 'fantasy', true);
INSERT INTO authors VALUES (DEFAULT, 'Baum, L.', 'Frank', '15 May 1856', 1);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'Glinda of Oz') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Baum, L.' AND last_name = 'Frank') AS a1;
INSERT INTO books VALUES (DEFAULT, 9781089574781, 'The Magic City', 'An extremely unhappy ten-year-old magically escapes into a city he has built out of books, chessmen, candlesticks, and other household items.', 'fantasy', true);
INSERT INTO authors VALUES (DEFAULT, 'E.', 'Nesbit', '15 August 1858', 32);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'The Magic City') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'E.' AND last_name = 'Nesbit') AS a1;
INSERT INTO books VALUES (DEFAULT, 9788475888781, 'Мастер и Маргарита', 'The battle of competing translations, a new publishing phenomenon which began with One Day in the Life of Ivan Denisovich, now offers two rival American editions of Mikhail Bulgakovs The Master and Margarita. Mirra Ginsburgs (Grove Press) version is pointedly grotesque: she delights in the sharp, spinning, impressionistic phrase. Her Bulgakov reminds one of the virtuoso effects encountered in Zamyatin and Babel, as yell as the early Pasternaks bizarre tale of Heine in Italy. Translator Michael Glenny, on the other hand, almost suggests Tolstoy. His (Harper & Row) version is simpler, softer, and more humane. The Bulgakov fantasy is less striking here, but less strident, too. Glenny: ""There was an oddness about that terrible day...It was the hour of the day when people feel too exhausted to breathe, when Moscow glows in a dry haze..."" Ginsburg: ""Oh, yes, we must take note of the first strange thing...At that hour, when it no longer seemed possible to breathe, when the sun was tumbling in a dry haze..."" In any case, The Master and Margarita, a product of intense labor from 1928 till Bulgakovs death in 1940, is a distinctive and fascinating work, undoubtedly a stylistic landmark in Soviet literature, both for its aesthetic subversion of ""socialist realism"" (like Zamyatin, Bulgakov apparently believed that true literature is created by visionaries and skeptics and madmen), and for the purity of its imagination. Essentially the anti-scientific, vaguely anti-Stalinist tale presents a resurrected Christ figure, a demonic, tricksy foreign professor, and a Party poet, the bewildered Ivan Homeless, plus a bevy of odd or romantic types, all engaged in socio-political exposures, historical debates, and supernatural turnabouts. A humorous, astonishing parable on power, duplicity, freedom, and love.', 'fantasy', true);
INSERT INTO authors VALUES (DEFAULT, 'Mikhail Afanasʹevich', 'Bulgakov', '15 May 1891', 270);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'Мастер и Маргарита') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Mikhail Afanasʹevich' AND last_name = 'Bulgakov') AS a1;
INSERT INTO books VALUES (DEFAULT, 9798360896395, 'The Story of Doctor Dolittle', 'There are some of us now reaching middle age who discover themselves to be lamenting the past in one respect if in none other, that there are no books written now for children comparable with those of thirty years ago.  I say written FOR children because the new psychological business of writing ABOUT them as though they were small pills or hatched in some especially scientific method is extremely popular today.', 'fantasy', true);
INSERT INTO authors VALUES (DEFAULT, 'Hugh', 'Lofting', '14 January 1886', 147);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'The Story of Doctor Dolittle') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Hugh' AND last_name = 'Lofting') AS a1;
INSERT INTO books VALUES (DEFAULT, 9781536923346, 'The Princess and the Goblin', 'There was once a little princess whose father was king over a great country full of mountains and valleys. His palace was built upon one of the mountains, and was very grand and beautiful. The princess, whose name was Irene, was born there, but she was sent soon after her birth, because her mother was not very strong, to be brought up by country people in a large house, half castle, half farmhouse, on the side of another mountain, about half-way between its base and its peak.', 'fantasy', true);
INSERT INTO authors VALUES (DEFAULT, 'MacDonald,', 'George', '1824', 19);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'The Princess and the Goblin') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'MacDonald,' AND last_name = 'George') AS a1;
INSERT INTO books VALUES (DEFAULT, 9781662707681, 'The Call of the Wild', 'As Buck, a mixed breed dog, is taken away from his home, instead of facing a feast for breakfast and the comforts of home, he faces the hardships of being a sled dog. Soon he lands in the wrong hands, being forced to keep going when it is too rough for him and the other dogs in his pack. He also fights the urges to run free with his ancestors, the wolves who live around where he is pulling the sled.', 'history', true);
INSERT INTO authors VALUES (DEFAULT, 'Jack', 'London', '12 January 1876', 2733);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'The Call of the Wild') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Jack' AND last_name = 'London') AS a1;
INSERT INTO books VALUES (DEFAULT, 9798756217643, 'Candide', 'Brought up in the household of a powerful Baron, Candide is an open-minded young man, whose tutor, Pangloss, has instilled in him the belief that all is for the best. But when his love for the Barons rosy-cheeked daughter is discovered, Candide is cast out to make his own way in the world.

And so he and his various companions begin a breathless tour of Europe, South America and Asia, as an outrageous series of disasters befall them - earthquakes, syphilis, a brush with the Inquisition, murder - sorely testing the young heros optimism.', 'history', true);
INSERT INTO authors VALUES (DEFAULT, 'Voltaire', 'Voltaire', '21 November 1694', 2072);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'Candide') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Voltaire' AND last_name = 'Voltaire') AS a1;
INSERT INTO books VALUES (DEFAULT, 9798588005265, 'Jane Eyre', 'The novel is set somewhere in the north of England. Janes childhood at Gateshead Hall, where she is emotionally and physically abused by her aunt and cousins; her education at Lowood School, where she acquires friends and role models but also suffers privations and oppression; her time as the governess of Thornfield Hall, where she falls in love with her Byronic employer, Edward Rochester; her time with the Rivers family, during which her earnest but cold clergyman cousin, St John Rivers, proposes to her. Will she or will she not marry him?', 'history', true);
INSERT INTO authors VALUES (DEFAULT, 'Brontë,', 'Charlotte', '1816', 746);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'Jane Eyre') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Brontë,' AND last_name = 'Charlotte') AS a1;
INSERT INTO books VALUES (DEFAULT, 9780606010672, 'The Merchant of Venice', 'In this lively comedy of love and money in sixteenth-century Venice, Bassanio wants to impress the wealthy heiress Portia but lacks the necessary funds. He turns to his merchant friend, Antonio, who is forced to borrow from Shylock, a Jewish moneylender. When Antonios business falters, repayment becomes impossible--and by the terms of the loan agreement, Shylock is able to demand a pound of Antonios flesh. Portia cleverly intervenes, and all ends well (except of course for Shylock).', 'history', true);
INSERT INTO authors VALUES (DEFAULT, 'William', 'Shakespeare', '20 April 1564', 9649);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'The Merchant of Venice') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'William' AND last_name = 'Shakespeare') AS a1;
INSERT INTO books VALUES (DEFAULT, 9798460372973, 'The Secret Garden', 'A ten-year-old orphan comes to live in a lonely house on the Yorkshire moors where she discovers an invalid cousin and the mysteries of a locked garden.', 'history', true);
INSERT INTO authors VALUES (DEFAULT, 'Frances Hodgson', 'Burnett', 'November 24, 1849', 998);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'The Secret Garden') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Frances Hodgson' AND last_name = 'Burnett') AS a1;
INSERT INTO books VALUES (DEFAULT, 9781017979435, 'The Prince and the Pauper', 'When young Edward VI of England and a poor boy who resembles him exchange places, each learns something about the others very different station in life. Includes a brief biography of the author.', 'history', true);
INSERT INTO authors VALUES (DEFAULT, 'Mark', 'Twain', '30 November 1835', 23);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'The Prince and the Pauper') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Mark' AND last_name = 'Twain') AS a1;
INSERT INTO books VALUES (DEFAULT, 9781515425175, 'Julius Caesar', 'Presents the original text of Shakespeares play side by side with a modern version, discusses the author and the theater of his time, and provides quizzes and other study activities.', 'history', true);
INSERT INTO authors VALUES (DEFAULT, 'William', 'Shakespeare', '20 April 1564', 9649);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'Julius Caesar') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'William' AND last_name = 'Shakespeare') AS a1;
INSERT INTO books VALUES (DEFAULT, 9798487115096, 'Anne of Avonlea', '"A tall, slim girl, "half-past sixteen," with serious gray eyes and hair which her friends called auburn, had sat down on the broad red sandstone doorstep of a Prince Edward Island farmhouse one ripe afternoon in August, firmly resolved to construe so many lines of Virgil. But an August afternoon, with blue hazes scarfing the harvest slopes, little winds whispering elfishly in the poplars, and a dancing slendor of red poppies outflaming against the dark coppice of young firs in a corner of the cherry orchard, was fitter for dreams than dead languages. The Virgil soon slipped unheeded to the ground, and Anne, her chin propped on her clasped hands, and her eyes on the splendid mass of fluffy clouds that were heaping up just over Mr. J. A. Harrisons house like a great  white mountain, was far away in a delicious world where a certain school-teacher was doing a wonderful work, shaping the destinies of future statesmen, and inspiring youthful minds and hearts with high and lofty ambitions."', 'history', true);
INSERT INTO authors VALUES (DEFAULT, 'Montgomery, L. M. (Lucy Maud),', '1874-1942', '30 November 1874', 993);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'Anne of Avonlea') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Montgomery, L. M. (Lucy Maud),' AND last_name = '1874-1942') AS a1;
INSERT INTO books VALUES (DEFAULT, 9786055541590, 'War and Peace', 'War and Peace delineates in graphic detail events surrounding the French invasion of Russia, and the impact of the Napoleonic era on Tsarist society, as seen through the eyes of five Russian aristocratic families.
The novel begins in the year 1805 during the reign of Tsar Alexander I and leads up to the 1812 French invasion of Russia by Napoleon. The era of Catherine the Great (1762–1796), when the royal court in Paris was the centre of western European civilization,[16] is still fresh in the minds of older people. Catherine, fluent in French and wishing to reshape Russia into a great European nation, made French the language of her royal court. For the next one hundred years, it became a social requirement for members of the Russian nobility to speak French and understand French culture.[16] This historical and cultural context in the aristocracy is reflected in War and Peace. Catherines grandson, Alexander I, came to the throne in 1801 at the age of 24. In the novel, his mother, Marya Feodorovna, is the most powerful woman in the Russian court.

War and Peace tells the story of five aristocratic families — the Bezukhovs, the Bolkonskys, the Rostovs, the Kuragins and the Drubetskoys—and the entanglements of their personal lives with the history of 1805–1813, principally Napoleons invasion of Russia in 1812. The Bezukhovs, while very rich, are a fragmented family as the old Count, Kirill Vladimirovich, has fathered dozens of illegitimate sons. The Bolkonskys are an old established and wealthy family based at Bald Hills. Old Prince Bolkonsky, Nikolai Andreevich, served as a general under Catherine the Great, in earlier wars. The Moscow Rostovs have many estates, but never enough cash. They are a closely knit, loving family who live for the moment regardless of their financial situation. The Kuragin family has three children, who are all of questionable character. The Drubetskoy family is of impoverished nobility, and consists of an elderly mother and her only son, Boris, whom she wishes to push up the career ladder.', 'history', true);
INSERT INTO authors VALUES (DEFAULT, 'Tolstoy,', 'Leo', '9 September 1828', 1);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'War and Peace') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Tolstoy,' AND last_name = 'Leo') AS a1;
INSERT INTO books VALUES (DEFAULT, 9798487094599, 'The Moonstone', 'One of the first English detective novels, this mystery involves the disappearance of a valuable diamond, originally stolen from a Hindu idol, given to a young woman on her eighteenth birthday, and then stolen again. A classic of 19th-century literature.', 'history', true);
INSERT INTO authors VALUES (DEFAULT, 'Collins,', 'Wilkie', '8 Jan 1824', 799);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'The Moonstone') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Collins,' AND last_name = 'Wilkie') AS a1;
INSERT INTO books VALUES (DEFAULT, 9798574841143, 'Narrative of the life of Frederick Douglass, an American slave', 'Published in 1845, this pre-eminent American slave narrative powerfully details the life of the internationally famous abolitionist Frederick Douglass from his birth into slavery in 1818 to his escape to the North in 1838—how he endured the daily physical and spiritual brutalities of his owners and drivers, how he learned to read and write, and how he grew into a man who could only live free or die.', 'history', true);
INSERT INTO authors VALUES (DEFAULT, 'Douglass,', 'Frederick', '1818', 1);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'Narrative of the life of Frederick Douglass, an American slave') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Douglass,' AND last_name = 'Frederick') AS a1;
INSERT INTO books VALUES (DEFAULT, 9798415291786, 'The Scarlet Pimpernel', 'The Scarlet Pimpernel (1905) is a play and adventure novel by Baroness Emmuska Orczy set during the Reign of Terror following the start of the French Revolution.', 'history', true);
INSERT INTO authors VALUES (DEFAULT, 'Orczy, Emmuska', 'Orczy', '23 September 1865', 1);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'The Scarlet Pimpernel') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Orczy, Emmuska' AND last_name = 'Orczy') AS a1;
INSERT INTO books VALUES (DEFAULT, 9780847707294, 'Divina Commedia', 'Belonging in the immortal company of the great works of literature, Dante Alighieri’s poetic masterpiece, *The Divine Comedy* (Italian: *Divina Commedia),* is a moving human drama, an unforgettable visionary journey through the infinite torment of Hell, up the arduous slopes of Purgatory, and on to the glorious realm of Paradise—the sphere of universal harmony and eternal salvation.', 'history', false);
INSERT INTO authors VALUES (DEFAULT, 'Dante', 'Alighieri', '1265', 1598);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'Divina Commedia') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Dante' AND last_name = 'Alighieri') AS a1;
INSERT INTO books VALUES (DEFAULT, 9781790854950, 'The Railway Children', 'When Father mysteriously goes away, the children and their mother leave their happy life in London to go and live in a small cottage in the country. The Three Chimneys lies beside a railway track - a constant source of enjoyment to all three. They make friends with the Station Master and Perks the Porter, as well as the jovial Old Gentleman who waves to them everyday from the train. But the mystery remains: where is Father, and will he ever return?', 'history', true);
INSERT INTO authors VALUES (DEFAULT, 'E.', 'Nesbit', '15 August 1858', 32);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'The Railway Children') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'E.' AND last_name = 'Nesbit') AS a1;
INSERT INTO books VALUES (DEFAULT, 9798473654479, 'Three men in a boat (to say nothing of the dog)', 'Three feckless young men take a rowing holiday on the Thames river in 1888.

Referenced by [Robert A. Heinlein][1] in [Have Spacesuit Will Travel][2] as Kips fathers favorite book. Inspired [To Say Nothing of the Dog][3] by [Connie Willis][4].


  [1]: https://openlibrary.org/authors/OL28641A/Robert_A._Heinlein
  [2]: https://openlibrary.org/works/OL59727W/Have_Space_Suit_Will_Travel
  [3]: https://openlibrary.org/works/OL14858398W/To_Say_Nothing_of_the_Dog_or_how_we_found_the_bishops_bird_stump_at_last#about/about
  [4]: https://openlibrary.org/authors/OL20934A/Connie_Willis', 'history', true);
INSERT INTO authors VALUES (DEFAULT, 'Jerome, Jerome', 'K.', '2 May 1859', 0);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'Three men in a boat (to say nothing of the dog)') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Jerome, Jerome' AND last_name = 'K.') AS a1;
INSERT INTO books VALUES (DEFAULT, 9781730999871, 'The Story of the Treasure Seekers being the adventures of the Bastable children in search of a fortune', 'The six Bastable children try to restore their familys fortune using a variety of schemes taken from books, including finding buried treasure, rescuing someone from bandits, and starting a newspaper.', 'history', true);
INSERT INTO authors VALUES (DEFAULT, 'E.', 'Nesbit', '15 August 1858', 32);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'The Story of the Treasure Seekers being the adventures of the Bastable children in search of a fortune') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'E.' AND last_name = 'Nesbit') AS a1;
INSERT INTO books VALUES (DEFAULT, 9788424907181, 'Aeneis', '"A prose translation of Vergils Aeneid with new illustrations and informational appendices"--Provided by publisher.', 'history', false);
INSERT INTO authors VALUES (DEFAULT, 'Virgil.', 'Virgil.', '15 October 70 BCE', 20);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'Aeneis') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Virgil.' AND last_name = 'Virgil.') AS a1;
INSERT INTO books VALUES (DEFAULT, 9781096415466, 'La père Goriot', 'SCOTT (copy 1): The Hédi Bouraoui Collection in Maghrebian and Franco-Ontario Literatures is the gift of University Professor Emeritus Hédi Bouraoui.', 'history', true);
INSERT INTO authors VALUES (DEFAULT, 'Honoré de', 'Balzac', '20 May 1799', 5138);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'La père Goriot') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Honoré de' AND last_name = 'Balzac') AS a1;
INSERT INTO books VALUES (DEFAULT, 9780333690987, 'King Henry IV. Part 1', 'Presents the original text of Shakespeares play side by side with a modern version, discusses the author and the theater of his time, and provides quizzes and other study activities.', 'history', true);
INSERT INTO authors VALUES (DEFAULT, 'William', 'Shakespeare', '20 April 1564', 9649);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'King Henry IV. Part 1') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'William' AND last_name = 'Shakespeare') AS a1;
INSERT INTO books VALUES (DEFAULT, 9798585784859, 'The Woman in White', 'The Woman in White famously opens with Walter Hartrights eerie encounter on a moonlit London road. Engaged as a drawing master to the beautiful Laura Fairlie, Walter is drawn into the sinister intrigues of Sir Percival Glyde and his charming friend Count Fosco, who has a taste for white mice, vanilla bonbons and poison. Pursuing questions of identity and insanity along the paths and corridors of English country houses and the madhouse, The Woman in White is the first and most influential of the Victorian genre that combined Gothic horror with psychological realism.', 'history', true);
INSERT INTO authors VALUES (DEFAULT, 'Collins,', 'Wilkie', '8 Jan 1824', 799);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'The Woman in White') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Collins,' AND last_name = 'Wilkie') AS a1;
INSERT INTO books VALUES (DEFAULT, 9781795416092, 'Jude the Obscure', 'Hardys last work of fiction, Jude the Obscure is also one of his most gloomily fatalistic, depicting the lives of individuals who are trapped by forces beyond their control. Jude Fawley, a poor villager, wants to enter the divinity school at Christminster. Sidetracked by Arabella Donn, an earthy country girl who pretends to be pregnant by him, Jude marries her and is then deserted. He earns a living as a stonemason at Christminster; there he falls in love with his independent-minded cousin, Sue Bridehead. Out of a sense of obligation, Sue marries the schoolmaster Phillotson, who has helped her. Unable to bear living with Phillotson, she returns to live with Jude and eventually bears his children out of wedlock. Their poverty and the weight of societys disapproval begin to take a toll on Sue and Jude; the climax occurs when Judes son by Arabella hangs Sue and Judes children and himself. In penance, Sue returns to Phillotson and the church. Jude returns to Arabella and eventually dies miserably. The novels sexual frankness shocked the public, as did Hardys criticisms of marriage, the university system, and the church. Hardy was so distressed by its reception that he wrote no more fiction, concentrating solely on his poetry.Please Note:  This book is easy to read in true text, not scanned images that can sometimes be difficult to decipher.  The Microsoft eBook has a contents page linked to the chapter headings for easy navigation. The Adobe eBook has bookmarks at chapter headings and is printable up to two full copies per year.  Both versions are text searchable.', 'history', true);
INSERT INTO authors VALUES (DEFAULT, 'Hardy,', 'Thomas', '2 June 1840', 8);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'Jude the Obscure') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Hardy,' AND last_name = 'Thomas') AS a1;
INSERT INTO books VALUES (DEFAULT, 9780582287273, 'Antony and Cleopatra', 'A magnificent drama of love and war, this riveting tragedy presents one of Shakespeares greatest female characters--the seductive, cunning Egyptian queen Cleopatra.  The Roman leader Mark Antony, a virtual prisoner of his passion for her, is a man torn between pleasure and virtue, between sensual indolence and duty . . . between an empire and love.  Bold, rich, and splendid in its setting and emotions, Antony And Cleopatra ranks among Shakespeares supreme achievements.From the Paperback edition.and the narrator vinay has explained what the intension in the relationship between antony and cleopatra', 'history', true);
INSERT INTO authors VALUES (DEFAULT, 'William', 'Shakespeare', '20 April 1564', 9649);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'Antony and Cleopatra') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'William' AND last_name = 'Shakespeare') AS a1;
INSERT INTO books VALUES (DEFAULT, 9781387764921, 'Carmilla', 'https://openlibrary.org/works/OL2895536W', 'horror', true);
INSERT INTO authors VALUES (DEFAULT, 'Joseph Sheridan Le', 'Fanu', '28 Aug 1814', 191);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'Carmilla') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Joseph Sheridan Le' AND last_name = 'Fanu') AS a1;
INSERT INTO books VALUES (DEFAULT, 9783453003125, 'Skeleton Crew', 'From the Flap:

The Master at his scarifying best! From heart-pounding terror to the eeriest of whimsy--tales from the outer limits of one of the greatest imaginations of our time!

Evil that breathes and walks and shrieks, brave new worlds and horror shows, human desperation bursting into deadly menace--such are the themes of these astounding works of fiction. In the tradition of Poe and Stevenson, of Lovecraft and The Twilight Zone, Stephen King has fused images of fear as old as time with the iconography of contemporary American life to create his own special brand of horror--one that has kept millions of readers turning the pages even as they gasp.

In the book-length story "The Mist," a supermarket becomes the last bastion of humanity as a peril beyond dimension invades the earth. . .

Touch "The Man Who Would Not Shake Hands," and say your prayers . . .

There are some things in attics which are better left alone, things like "The Monkey" . . .

The most sublime woman driver on earth offers a man "Mrs. Todds Shortcut" to paradise . . .

A boys sanity is pushed to the edge when hes left alone with the odious corpse of "Gramma" . . .

If you were stunned by Gremlins, the Fornits of "The Ballad of the Flexible Bullet" will knock your socks off . . .

Trucks that punish and beautiful teen demons who seduce a young man to massacre; curses whose malevolence grows through the years; obscene presences and angels of grace--here, indeed, is a night-blooming bouquet of chills and thrills.
([source][1])


----------
Contains:

 - [The Mist](https://openlibrary.org/works/OL149144W/The_Mist)
 - Here There Be Tygers
 - [The Monkey](https://openlibrary.org/works/OL149146W/The_Monkey)
 - Cain Rose Up
 - [Mrs. Todds Shortcut](https://openlibrary.org/works/OL149148W/Mrs._Todds_Shortcut)
 - [The Jaunt](https://openlibrary.org/works/OL20663554W/The_Jaunt)
 - The Wedding Gig
 - Paranoid: a Chant
 - The Raft
 - [Word Processor of the Gods](https://openlibrary.org/works/OL20666372W/The_Word_Processor)
 - The Man Who Would Not Shake Hands
 - Beachworld
 - The Reapers Image
 - [Nona](https://openlibrary.org/works/OL20666488W/Nona)
 - For Owen
 - Survivor Type
 - Uncle Ottos Truck
 - Morning Deliveries (Milkman No. 1)
 - Big Wheels: a Tale of the Laundry Game (Milkman No. 2)
 - Gramma
 - The Ballad of the Flexible Bullet
 - The Reach

  [1]: https://stephenking.com/library/story_collection/skeleton_crew_flap.html', 'horror', true);
INSERT INTO authors VALUES (DEFAULT, 'Stephen', 'King', 'September 21, 1947', 663);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'Skeleton Crew') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Stephen' AND last_name = 'King') AS a1;
INSERT INTO books VALUES (DEFAULT, 9788412198867, 'The Exorcist', 'The Exorcist is a 1971 horror novel by American writer William Peter Blatty. The book details the demonic possession of eleven-year-old Regan MacNeil, the daughter of a famous actress, and the two priests who attempt to exorcise the demon. Published by Harper & Row, the novel was the basis of a highly successful film adaptation released two years later, whose screenplay was also written and produced by Blatty, and part of The Exorcist franchise.

The novel was inspired by a 1949 case of demonic possession and exorcism that Blatty heard about while he was a student in the class of 1950 at Georgetown University. As a result, the novel takes place in Washington, D.C., near the campus of Georgetown University. In September 2011, the novel was reprinted by Harper Collins to celebrate its fortieth anniversary, with slight revisions made by Blatty as well as interior title artwork by Jeremy Caniglia.', 'horror', true);
INSERT INTO authors VALUES (DEFAULT, 'William Peter', 'Blatty', '1928', 27);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'The Exorcist') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'William Peter' AND last_name = 'Blatty') AS a1;
INSERT INTO books VALUES (DEFAULT, 9780606019170, 'The Dead Zone', 'The Dead Zone is a science fiction thriller novel by Stephen King published in 1979. The story follows Johnny Smith, who awakens from a coma of nearly five years and, apparently as a result of brain damage, now experiences clairvoyant and precognitive visions triggered by touch. When some information is blocked from his perception, Johnny refers to that information as being trapped in the part of his brain that is permanently damaged, "the dead zone." The novel also follows a serial killer in Castle Rock, and the life of rising politician Greg Stillson, both of whom are evils Johnny must eventually face.

Though earlier King books were successful, The Dead Zone was the first of his novels to rank among the ten best-selling novels of the year in the United States. The book was nominated for the Locus Award in 1980 and was dedicated to Kings son Owen. The Dead Zone is the first story by King to feature the fictional town of Castle Rock, which serves as the setting for several later stories and is referenced in others. The TV series Castle Rock takes place in this fictional town and makes references to the Strangler whom Johnny helped track down in The Dead Zone.

The Dead Zone is Kings seventh novel and the fifth under his own name. The book spawned a 1983 film adaptation as well as a television series.', 'horror', true);
INSERT INTO authors VALUES (DEFAULT, 'Stephen', 'King', 'September 21, 1947', 663);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'The Dead Zone') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Stephen' AND last_name = 'King') AS a1;
INSERT INTO books VALUES (DEFAULT, 9781668009925, 'Firestarter', 'Firestarter is a science fiction-horror thriller novel by Stephen King, first published in September 1980. In July and August 1980, two excerpts from the novel were published in Omni. In 1981, Firestarter was nominated as Best Novel for the British Fantasy Award, Locus Poll Award, and Balrog Award.


----------
Also contained in:
[Ominbus](https://openlibrary.org/works/OL25080326W)', 'horror', true);
INSERT INTO authors VALUES (DEFAULT, 'Stephen', 'King', 'September 21, 1947', 663);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'Firestarter') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Stephen' AND last_name = 'King') AS a1;
INSERT INTO books VALUES (DEFAULT, 9781583429938, 'Something Wicked This Way Comes', 'Few American novels written this century have endured in the heart and memory as has Ray Bradburys unparalleled literary classic SOMETHING WICKED THIS WAY COMES. For those who still dream and remember, for those yet to experience the hypnotic power of its dark poetry, step inside. The show is about to begin.

The carnival rolls in sometime after midnight, ushering in Halloween a week early. The shrill siren song of a calliope beckons to all with a seductive promise of dreams and youth regained. In this season of dying, Cooger & Darks Pandemonium Shadow Show has come to Green Town, Illinois, to destroy every life touched by its strange and sinister mystery. And two boys will discover the secret of its smoke, mazes, and mirrors; two friends who will soon know all too well the heavy cost of wishes. . .and the stuff of nightmare.', 'horror', true);
INSERT INTO authors VALUES (DEFAULT, 'Ray', 'Bradbury', '22 August 1920', 639);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'Something Wicked This Way Comes') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Ray' AND last_name = 'Bradbury') AS a1;
INSERT INTO books VALUES (DEFAULT, 9788484505785, 'If There Be Thorns', '*If There Be Thorns* is a novel by Virginia Andrews which was published in 1981. It is the third book in the Dollanganger series. The story takes place in the year 1982.

The book is narrated by two half-brothers, Jory and Bart Sheffield. Jory is a handsome, talented young man who wants to follow his mother Cathy in her career in the ballet, while Bart, who is unattractive and clumsy, feels he is outshone by Jory. By now, Cathy and Chris live together as common-law husband and wife. To hide their history, they tell the boys and other people they know that Chris was Pauls younger brother. Unable to have more children, Cathy secretly adopts Cindy, the daughter of one her former dance students, who was killed in an accident, because she longs to have a child that is hers and Chriss. Initially against it, Chris comes to accept the child.

Lonely from all the attention Jory and Cindy are receiving, Bart befriends an elderly neighbor that moved in next door, who invites him over for cookies and ice cream and encourages him to call her "Grandmother." Jory also visits the old lady next door, and she reveals that she is actually his grandmother. Jory initially doesnt believe her, and avoids her at all costs. The old woman and Bart, on the other hand, soon develop an affectionate friendship, and the woman does her best to give Bart whatever he wants, provided that Bart promises to keep her gifts—-and their relationship-—a secret from his mother.


----------
Also contained in:
[If There Be Thorns / Seeds of Yesterday](https://openlibrary.org/works/OL16526063W)', 'horror', true);
INSERT INTO authors VALUES (DEFAULT, 'V. C.', 'Andrews', '6 June 1923', 229);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'If There Be Thorns') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'V. C.' AND last_name = 'Andrews') AS a1;
INSERT INTO books VALUES (DEFAULT, 9781501177217, 'The Eyes of the Dragon', 'The Eyes of the Dragon is a fantasy novel by American writer Stephen King, first published as a limited edition slipcased hardcover by Philtrum Press in 1984, illustrated by Kenneth R. Linkhauser. The novel would later be published for the mass market by Viking in 1987, with illustrations by David Palladini. This trade edition was slightly revised for publication. The 1995 French edition did not reproduce the American illustrations; it included brand new illustrations by Christian Heinrich, and a 2016 new French version also included brand new illustrations, by Nicolas Duffaut.

At the time of publication, it was a deviation from the norm for King, who was best known for his horror fiction. The book is a work of epic fantasy in a quasi-medieval setting, with a clearly established battle between good and evil, and magic playing a lead role. The Eyes of the Dragon was originally titled The Napkins.


----------
Also contained in:
[Ominbus](https://openlibrary.org/works/OL25080326W)', 'horror', true);
INSERT INTO authors VALUES (DEFAULT, 'Stephen', 'King', 'September 21, 1947', 663);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'The Eyes of the Dragon') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Stephen' AND last_name = 'King') AS a1;
INSERT INTO books VALUES (DEFAULT, 9780671042141, 'Hearts in Atlantis', 'Hearts in Atlantis (1999) is a collection of two novellas and three short stories by Stephen King, all connected to one another by recurring characters and taking place in roughly chronological order.

The stories are about the Baby Boomer Generation, specifically Kings view that this generation (to which he belongs) failed to live up to its promise and ideals. Significantly, the opening epigraph of the collection is the Peter Fonda line from the end of Easy Rider: "We blew it." All of the stories are about the 1960s and the war in Vietnam, and in all of them the members of that generation fail profoundly, or are paying the costs of some profound failure on their part.

In this collection:

 - Blind Willie
 - Hearts in Atlantis
 - Heavenly Shades of Night Are Falling
 - Low Men in Yellow Coats
 - Why Were in Vietnam', 'horror', true);
INSERT INTO authors VALUES (DEFAULT, 'Stephen', 'King', 'September 21, 1947', 663);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'Hearts in Atlantis') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Stephen' AND last_name = 'King') AS a1;
INSERT INTO books VALUES (DEFAULT, 9781668018071, 'Christine', 'A love triangle involving 17-year-old misfit Arnie Cunningham, his new girlfriend and a haunted 1958 Plymouth Fury. Dubbed Christine by her previous owner, Arnies first car is jealous, possessive and deadly.
([source][1])


  [1]: https://stephenking.com/library/novel/christine.html', 'horror', true);
INSERT INTO authors VALUES (DEFAULT, 'Stephen', 'King', 'September 21, 1947', 663);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'Christine') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Stephen' AND last_name = 'King') AS a1;
INSERT INTO books VALUES (DEFAULT, 9780340633687, 'Rose Madder', 'Rosie Daniels flees from her husband, Norman after fourteen years in an abusive marriage. During one bout of violence, Norman caused Rosie to miscarry their only child. Escaping to a distant city, Rosie establishes a new life and forges new relationships. Norman Daniels, a police officer with a reputation for cruelty, uses his law-enforcement connections to track his wayward wife.
([source][1])


  [1]: https://stephenking.com/library/novel/rose_madder.html', 'horror', true);
INSERT INTO authors VALUES (DEFAULT, 'Stephen', 'King', 'September 21, 1947', 663);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'Rose Madder') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Stephen' AND last_name = 'King') AS a1;
INSERT INTO books VALUES (DEFAULT, 9780340952269, 'Thinner', 'Thinner is a horror novel by American author Stephen King, published in 1984 by NAL under Kings pseudonym Richard Bachman. The story centers on lawyer Billy Halleck, who kills a crossing Romani woman in a road accident and escapes legal punishment because of his connections. However, the womans father places a curse on Halleck, which causes him to lose weight uncontrollably.', 'horror', true);
INSERT INTO authors VALUES (DEFAULT, 'Stephen', 'King', 'September 21, 1947', 663);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'Thinner') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Stephen' AND last_name = 'King') AS a1;
INSERT INTO books VALUES (DEFAULT, 9788497595896, 'Desperation', 'Located off a desolate stretch of Interstate 50, Desperation, Nevada has few connections with the rest of the world. It is a place, though, where the seams between worlds are thin. Miners at the China Pit have accidentally broken into another dimension and released a horrific creature known as Tak, who takes human form by hijacking some of the towns residents. The forces of good orchestrate a confrontation between this ancient evil and a group of unsuspecting travelers who are lured to the dying town. This rag-tag band of unwilling champions is led by a young boy who speaks to God.

([source][1])


  [1]: https://www.stephenking.com/library/novel/desperation.html', 'horror', true);
INSERT INTO authors VALUES (DEFAULT, 'Stephen', 'King', 'September 21, 1947', 663);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'Desperation') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Stephen' AND last_name = 'King') AS a1;
INSERT INTO books VALUES (DEFAULT, 9788376481708, 'Danse Macabre', 'This is a non-fiction study of the horror genre including books, movies, television, etc.
([source][1])


----------
Also contained in:

 - [Works (Danse Macabre / Salems Lot / Shining](https://openlibrary.org/works/OL24233994W)

  [1]: https://stephenking.com/library/nonfiction/danse_macabre.html', 'horror', false);
INSERT INTO authors VALUES (DEFAULT, 'Stephen', 'King', 'September 21, 1947', 663);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'Danse Macabre') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Stephen' AND last_name = 'King') AS a1;
INSERT INTO books VALUES (DEFAULT, 9781587672316, 'The Passage', 'The Passage is a novel by Justin Cronin, published in 2010 by Ballantine Books, a division of Random House, Inc., New York. The Passage debuted at #3 on the New York Times hardcover fiction best seller list, and remained on the list for seven additional weeks. It is the first novel of a completed trilogy; the second book The Twelve was released in 2012, and the third book The City of Mirrors released in 2016.', 'horror', false);
INSERT INTO authors VALUES (DEFAULT, 'Justin', 'Cronin', '1962', 15);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'The Passage') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Justin' AND last_name = 'Cronin') AS a1;
INSERT INTO books VALUES (DEFAULT, 9785150003941, 'The Regulators', 'The Regulators is a novel by American author Stephen King, writing under the pseudonym Richard Bachman. It was published in 1996 at the same time as its "mirror" novel, Desperation. The two novels represent parallel universes relative to one another, and most of the characters present in one novels world also exist in the other novels reality, albeit in different circumstances. Additionally, the hardcover first editions of each novel, if set side by side, make a complete painting, and on the back of each cover is also a peek at the opposites cover.', 'horror', true);
INSERT INTO authors VALUES (DEFAULT, 'Stephen', 'King', 'September 21, 1947', 663);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'The Regulators') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Stephen' AND last_name = 'King') AS a1;
INSERT INTO books VALUES (DEFAULT, 9782266118996, 'The Queen of the Damned', 'The third book in The Vampire Chronicles, Queen of the Damned, follows three parallel storylines.

The rock star Vampire Lestat prepares for a concert in San Francisco, unaware that hundreds of vampires will be among the fans that night and that they are committed to destroying him for risking exposing them all.

The sleep of a group of men and women, vampires and mortals, around the world is disturbed by a mysterious dream of red-haired twins who suffer an unspeakable tragedy. The dreamers, as if pulled, move toward each other, the nightmare becoming clearer the closer they get. Some die on the way, some live to face they terrifying fate their pilgrimage is building to.

Lestats journey to a cavern deep beneath a Greek Island on his quest for the origins of the vampire race awakened Akasha, Queen of the Damed and mother of all vampires, from her 6,000 year sleep. Awake and angry, Akasha plans to save mankind from itself by elevating herself and her chosen son/lover to the level of the gods.

As these three threads wind seamlessly together, the origins and culture of vampires are revealed, as is the length and breadth of their effect on the mortal world. The threads are brought together in the twentieth century when the fate of the living and the living dead is rewritten.
([source][1])


  [1]: http://annerice.com/Bookshelf-QueenDamned.html', 'horror', true);
INSERT INTO authors VALUES (DEFAULT, 'Anne', 'Rice', '4 October 1941', 300);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'The Queen of the Damned') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Anne' AND last_name = 'Rice') AS a1;
INSERT INTO books VALUES (DEFAULT, 9788868362362, 'Dolores Claiborne', 'Suspected of killing Vera Donovan, her wealthy employer, Dolores Claiborne tells police the story of her life, harkening back to her disintegrating marriage and the suspicious death of her violent husband, Joe St. George, thirty years earlier. Dolores also tells of Veras physical and mental decline and of her loyalty to an employer who has become emotionally demanding in recent years.

([source][1])


  [1]: https://www.stephenking.com/library/novel/dolores_claiborne.html', 'horror', true);
INSERT INTO authors VALUES (DEFAULT, 'Stephen', 'King', 'September 21, 1947', 663);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'Dolores Claiborne') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Stephen' AND last_name = 'King') AS a1;
INSERT INTO books VALUES (DEFAULT, 9785170853120, 'Mr. Mercedes', 'In the frigid pre-dawn hours, in a distressed Midwestern city, hundreds of desperate unemployed folks are lined up for a spot at a job fair. Without warning, a lone driver plows through the crowd in a stolen Mercedes, running over the innocent, backing up, and charging again. Eight people are killed; fifteen are wounded. The killer escapes.

In another part of town, months later, a retired cop named Bill Hodges is still haunted by the unsolved crime. When he gets a crazed letter from someone who self-identifies as the "perk" and threatens an even more diabolical attack, Hodges wakes up from his depressed and vacant retirement, hell-bent on preventing another tragedy.

Brady Hartfield lives with his alcoholic mother in the house where he was born. He loved the feel of death under the wheels of the Mercedes, and he wants that rush again.

Only Bill Hodges, with a couple of highly unlikely allies, can apprehend the killer before he strikes again. And they have no time to lose, because Brady’s next mission, if it succeeds, will kill or maim thousands.

Mr. Mercedes is a war between good and evil, from the master of suspense whose insight into the mind of this obsessed, insane killer is chilling and unforgettable.', 'horror', true);
INSERT INTO authors VALUES (DEFAULT, 'Stephen', 'King', 'September 21, 1947', 663);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'Mr. Mercedes') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Stephen' AND last_name = 'King') AS a1;
INSERT INTO books VALUES (DEFAULT, 9782277021438, 'Fallen Hearts', 'With Fallen Hearts, V.C. Andrews returns again to the number one best-selling saga of the Casteels, continuing the story that was begun in Heaven and Dark Angel.

In Fallen Hearts, Heaven returns to her Winnerow and begins to live out her childhood dreams--she becomes a respected schoolteacher at the local school and marries her sweetheart, Logan Stonewall. After their wedding trip back to Farthinggale Manor, Tony Tatterton persuades Heaven and Logan to stay in Boston, offering Logan a fabulous job and promising to share with Heaven all the Tatterton wealth and privilege. But old ghosts begin to rise up once more, writhing around Heavens fragile happiness, threatening her precious love with scandal and jealousy. Once again, V.C. Andrews tells an enthralling tale of sinister passions and dangerous dreams.', 'horror', true);
INSERT INTO authors VALUES (DEFAULT, 'V. C.', 'Andrews', '6 June 1923', 229);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'Fallen Hearts') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'V. C.' AND last_name = 'Andrews') AS a1;
INSERT INTO books VALUES (DEFAULT, 9789501512274, 'The Voice of the Night', 'No one could understand why Colin and Roy were best friends. They were complete opposites. Colin was fascinated by Roy--and Roy was fascinated by death. Then one day Roy asked: "You ever killed anything?" And from that moment on, the two were bound together in a game to terrifying to imagine.', 'horror', true);
INSERT INTO authors VALUES (DEFAULT, 'Dean R.', 'Koontz', '9 July 1945', 17);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'The Voice of the Night') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Dean R.' AND last_name = 'Koontz') AS a1;
INSERT INTO books VALUES (DEFAULT, 9782724237443, 'My Sweet Audrina', 'My Sweet Audrina is a 1982 novel by V. C. Andrews. It was the only stand-alone novel published during Andrews lifetime and was a number-one best-selling novel in North America. The story takes place in the Mid-Atlantic United States during the 1960s and 1970s. The story features diverse subjects, such as brittle bone disease, rape, posttraumatic stress disorder and diabetes, in the haunting setting of a Victorian-era mansion near the fictitious River Lyle.', 'horror', true);
INSERT INTO authors VALUES (DEFAULT, 'V. C.', 'Andrews', '6 June 1923', 229);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'My Sweet Audrina') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'V. C.' AND last_name = 'Andrews') AS a1;
INSERT INTO books VALUES (DEFAULT, 9788466621793, 'Lasher', 'The Talamasca, documenters of paranormal activity, is on the hunt for the newly born Lasher. Mayfair women are dying from hemorrhages and a strange genetic anomaly has been found in Rowan and Michael. Lasher, born from Rowan, is another species altogether and now in the corporeal body, represents an incalcuable threat to the Mayfairs. Rowan and Lasher travel together to Houston and she becomes pregnant with another creature like him, a Taltos. Lasher seeks to reproduce his race in other women, but they cannot withstand it. Rowan escapes and becomes comatose as her fully-grown Taltos daughter is born. The Mayfairs declare all-out war on Lasher and try to nurse Rowan back to heatlth.

Michael remains entwined in the Mayfair family and learns how he comes by his strange powers. Michaels ghostly visiting from a long-dead Mayfair reveals the importance of destroying Lasher. In the investigation, Lashers origins are revealed, the new Taltos Emaleth returns, and the climax of death and life engulfs the family.
([source][1])


  [1]: http://annerice.com/Bookshelf-Lasher.html', 'horror', true);
INSERT INTO authors VALUES (DEFAULT, 'Anne', 'Rice', '4 October 1941', 300);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'Lasher') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Anne' AND last_name = 'Rice') AS a1;
INSERT INTO books VALUES (DEFAULT, 9798354315864, 'The Bell Jar', 'The Bell Jar is the only novel written by American poet Sylvia Plath. It is an intensely realistic and emotional record of a successful and talented young womans descent into madness.', 'mental health', true);
INSERT INTO authors VALUES (DEFAULT, 'Sylvia', 'Plath', '27 October 1932', 33);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'The Bell Jar') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Sylvia' AND last_name = 'Plath') AS a1;
INSERT INTO books VALUES (DEFAULT, 9781501133473, 'The Perks of Being a Wallflower', 'The Perks of Being a Wallflower is a young adult coming-of-age epistolary novel by American writer Stephen Chbosky, which was first published on February 1, 1999, by Pocket Books. Set in the early 1990s, the novel follows Charlie, an introverted observing teenager, through his freshman year of high school in a Pittsburgh suburb. The novel details Charlies unconventional style of thinking as he navigates between the worlds of adolescence and adulthood, and attempts to deal with poignant questions spurred by his interactions with both his friends and family.', 'mental health', true);
INSERT INTO authors VALUES (DEFAULT, 'Stephen', 'Chbosky', '1970', 7);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'The Perks of Being a Wallflower') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Stephen' AND last_name = 'Chbosky') AS a1;
INSERT INTO books VALUES (DEFAULT, 9798719874166, 'Power Through Repose', 'No matter what our work in life, whether scientific, artistic, or domestic, it is the same body through which the power is transmitted; and the same freedom in the conductors for impression and expression is needed, to whatever end the power may be moved, from the most simple action to the highest scientific or artistic attainment. The quality of power differs greatly; the results are widely different, but the laws of transmission are the same. So wonderful is the unity of life and its laws!', 'mental health', false);
INSERT INTO authors VALUES (DEFAULT, 'Annie Payson', 'Call', '1853', 13);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'Power Through Repose') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Annie Payson' AND last_name = 'Call') AS a1;
INSERT INTO books VALUES (DEFAULT, 9783426871812, 'The Wisdom of Insecurity', 'amazing insight. helps westerners step back and look at their actions and how they relate to the world around them. the mere desire to "be secure" is what actually makes you insecure.  all about time and pain.  most influential book ive ever read, and ive read a lot, high iq, etc.  from my point of view, a must read.', 'mental health', false);
INSERT INTO authors VALUES (DEFAULT, 'Alan', 'Watts', '1915', 108);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'The Wisdom of Insecurity') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Alan' AND last_name = 'Watts') AS a1;
INSERT INTO books VALUES (DEFAULT, 9789044511239, 'Leopardens öga', 'Arriving in newly independent Zambia in the hopes of fulfilling a friends missionary dream, Hans Olofson endeavors to make Africa his home while struggling with such past demons as his fathers alcoholism and a friends accident.', 'mental health', true);
INSERT INTO authors VALUES (DEFAULT, 'Henning', 'Mankell', '3 February 1948', 108);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'Leopardens öga') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Henning' AND last_name = 'Mankell') AS a1;
INSERT INTO books VALUES (DEFAULT, 9780380724246, 'Sometimes I Think I Hear My Name', 'It wasnt that thirteen-year-old Conrad didnt like living with his aunt and uncle in St. Louis. Its just that his mother and father both lived in New York and he hadnt seen them lately. And he had a few questions he needed to have answered. Thats how Conrad happened to spend the strangest week of his life in New York City with a girl he hardly knew--and getting more answers than he had questions...about his parents, himself, and what real families are all about.', 'mental health', true);
INSERT INTO authors VALUES (DEFAULT, 'Avi', 'Avi', '23 Dec 1937', 154);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'Sometimes I Think I Hear My Name') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Avi' AND last_name = 'Avi') AS a1;
INSERT INTO books VALUES (DEFAULT, 9780393339857, '"Surely Youre Joking, Mr. Feynman"', 'The biography of the physicist and Nobel prize winner Richard P. Feynman - a collection of short stories, chapters told to and written down by Ralph Leighton.
Feynman tells of his childhood and youth and goes into his adult life, both personally and professionally.', 'music', false);
INSERT INTO authors VALUES (DEFAULT, 'Richard Phillips', 'Feynman', '1918', 225);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = '"Surely Youre Joking, Mr. Feynman"') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Richard Phillips' AND last_name = 'Feynman') AS a1;
INSERT INTO books VALUES (DEFAULT, 9781481425803, 'Dragonsong', 'Menolly, a young fishers daughter, had dreamed all her life of learning the Harpers craft. Her musical talent is not valued in her fishing hold, especially by her parents the holders, as women in general tend to be less valued and have fewer choices than men in Pernese society. When her father denies her what she regards to be her destiny, she flees Half Circle Hold just as Pern is struck by the deadly danger of Threadfall, a deathly rain that falls from the sky. Menolly takes shelter in a cave by the sea and there, she makes a miraculous discovery that will change her life.', 'music', true);
INSERT INTO authors VALUES (DEFAULT, 'Anne', 'McCaffrey', '1 April 1926', 200);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'Dragonsong') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Anne' AND last_name = 'McCaffrey') AS a1;
INSERT INTO books VALUES (DEFAULT, 9780606090155, 'The Magic School Bus', 'To celebrate its 20th anniversary, Scholastic is re-releasing the ten original Magic School Bus titles in paperback. With updated scientific information, the bestselling science series ever is back!

The classroom is decorated as Dinosaur Land, but Ms. Frizzle-inspired by an archeological dig-craves a more authentic experience. The Magic School Bus turns into a time machine and transports the class back millions of years to an adventure where they learn about dinosaurs, their habitats and diets, and even a Maiasaura nesting ground', 'music', false);
INSERT INTO authors VALUES (DEFAULT, 'Qiaoanna', 'Keer', '1944', 190);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'The Magic School Bus') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Qiaoanna' AND last_name = 'Keer') AS a1;
INSERT INTO books VALUES (DEFAULT, 9780606090032, 'The Visitor', 'Rachel is still reeling from the news that the Earth is secretly under attack by parasitic aliens. And that she and her friends are the planets only defense.', 'music', true);
INSERT INTO authors VALUES (DEFAULT, 'Katherine', 'Applegate', '9 October 1956', 365);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'The Visitor') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Katherine' AND last_name = 'Applegate') AS a1;
INSERT INTO books VALUES (DEFAULT, 9781522705635, 'Teleny or the Reverse of the Medal', 'Camille Des Grieux, a French man, attends a classical concert with his mother. When a Hungarian piano player named Rène Teleny starts to play, Des Greiux begins to have shared visions of lust with the piano player. This book is story of two men and their journey to and from each other, their hearts only made for one another.', 'music', true);
INSERT INTO authors VALUES (DEFAULT, 'Oscar', 'Wilde', '16 October 1854', 3353);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'Teleny or the Reverse of the Medal') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Oscar' AND last_name = 'Wilde') AS a1;
INSERT INTO books VALUES (DEFAULT, 9780760765043, 'HARRY and the Lady Next Door', 'An early reading book.

The lady next door sings too loud and too high, and Harry, usually quite a friendly dog, cannot bear it! But what can he do?', 'music', true);
INSERT INTO authors VALUES (DEFAULT, 'Gene', 'Zion', '5 October 1913', 39);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'HARRY and the Lady Next Door') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Gene' AND last_name = 'Zion') AS a1;
INSERT INTO books VALUES (DEFAULT, 9789038898094, 'The Guts', '"The man who invented the Commitments back in the 1980s is now 47, with a loving wife, 4 kids...and bowel cancer. He isnt dying, he thinks, but he might be. Jimmy still loves his music, and he still loves to hustle--his new thing is finding old bands and then finding the people who loved them enough to pay money online for their resurrected singles and albums. On his path through Dublin, between chemo and work he meets two of the Commitments--Outspan Foster, whose own illness is probably terminal, and Imelda Quirk, still as gorgeous as ever. He is reunited with his long-lost brother, Les, and learns to play the trumpet.... This warm, funny novel is about friendship and family, about facing death and opting for life"--', 'music', true);
INSERT INTO authors VALUES (DEFAULT, 'Roddy', 'Doyle', '1958', 52);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'The Guts') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Roddy' AND last_name = 'Doyle') AS a1;
INSERT INTO books VALUES (DEFAULT, 9798779305723, 'The Sign of Four', 'The Sign of the Four (1890), also called The Sign of Four, is the second novel featuring Sherlock Holmes written by Sir Arthur Conan Doyle.


----------
Also contained in:
[Adventures of Sherlock Holmes](https://openlibrary.org/works/OL20624138W)
[Adventures of Sherlock Holmes](https://openlibrary.org/works/OL18191906W)
[Annotated Sherlock Holmes. 1/2](https://openlibrary.org/works/OL1518438W)
[Best of Sherlock Holmes](https://openlibrary.org/works/OL18195589W)
[Boys Sherlock Holmes](https://openlibrary.org/works/OL8696809W)
[Celebrated Cases of Sherlock Holmes](https://openlibrary.org/works/OL16076930W)
[Complete Sherlock Holmes](https://openlibrary.org/works/OL18188824W)
[Complete Sherlock Holmes](https://openlibrary.org/works/OL14929975W)
[Illustrated Sherlock Holmes](https://openlibrary.org/works/OL1518342W)
[Original Illustrated Strand Sherlock Holmes](https://openlibrary.org/works/OL262529W)
[Sherlock Holmes: His Most Famous Mysteries](https://openlibrary.org/works/OL14930414W)
[Sherlock Holmes: The Novels](https://openlibrary.org/works/OL16018654W)
[The Sign of the Four, A Scandal in Bohemia and Other Stories](https://openlibrary.org/works/OL20630338W)
[Sign of the Four and Other Stories](https://openlibrary.org/works/OL20628655W)
[Tales of Sherlock Holmes](https://openlibrary.org/works/OL1518350W)
[Tales of Sherlock Holmes](https://openlibrary.org/works/OL1518418W)
[Works](https://openlibrary.org/works/OL16173818W)', 'mystery and detective stories', true);
INSERT INTO authors VALUES (DEFAULT, 'Doyle, Arthur', 'Conan', '1859', 1);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'The Sign of Four') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Doyle, Arthur' AND last_name = 'Conan') AS a1;
INSERT INTO books VALUES (DEFAULT, 9788490019382, 'The Return of Sherlock Holmes', 'The Return of Sherlock Holmes is a 1905 collection of 13 Sherlock Holmes stories, originally published in 1903–1904, by Arthur Conan Doyle. The stories were published in the Strand Magazine in Britain and Colliers in the United States.

Contains:
[Adventure of the Empty House](https://openlibrary.org/works/OL1518119W/The_Adventure_of_the_Empty_House)
[Adventure of the Norwood Builder](https://openlibrary.org/works/OL262418W/Adventure_of_the_Norwood_Builder)
[Adventure of the Dancing Men](https://openlibrary.org/works/OL262417W/The_Dancing_Men)
[Adventure of the Solitary Cyclist](https://openlibrary.org/works/OL1518122W/Adventure_of_the_Solitary_Cyclist)
[Adventure of the Priory School](https://openlibrary.org/works/OL1518319W/Adventure_of_the_Priory_School)
Black Peter
[Adventure of Charles Augustus Milverton](https://openlibrary.org/works/OL20621973W/Adventure_of_Charles_Augustus_Milverton)
[Six Napoleons](https://openlibrary.org/works/OL20628495W)
[Adventure of the Three Students](https://openlibrary.org/works/OL1518368W/Adventure_of_the_Three_Students)
[Adventure of the Golden Pince-Nez](https://openlibrary.org/works/OL18191848W/Adventure_of_the_Golden_Pince-Nez)
[Adventure of the Missing Three-Quarter](https://openlibrary.org/works/OL18191816W/Adventure_of_the_Missing_Three_Quarter)
[Adventure of the Abbey Grange](https://openlibrary.org/works/OL17084226W/Adventure_of_the_Abbey_Grange)
[Second Stain](https://openlibrary.org/works/OL18191864W/Second_Stain)


----------
Also contained in:
[Celebrated Cases of Sherlock Holmes](https://openlibrary.org/works/OL16076930W)
[Illustrated Sherlock Holmes](https://openlibrary.org/works/OL1518342W)
[Original Illustrated Sherlock Holmes](https://openlibrary.org/works/OL1518150W)
[Original Illustrated Strand Sherlock Holmes](https://openlibrary.org/works/OL262529W)
[Short Stories](https://openlibrary.org/works/OL14929977W)
[Works](https://openlibrary.org/works/OL16173818W)', 'mystery and detective stories', true);
INSERT INTO authors VALUES (DEFAULT, 'Doyle, Arthur', 'Conan', '1859', 1);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'The Return of Sherlock Holmes') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Doyle, Arthur' AND last_name = 'Conan') AS a1;
INSERT INTO books VALUES (DEFAULT, 9781015520943, 'Memoirs of Sherlock Holmes [11 stories]', 'Contains:

[Silver Blaze](https://openlibrary.org/works/OL1518358W/Silver_Blaze)
[Adventure of the Yellow Face](https://openlibrary.org/works/OL20571966W/Adventure_of_the_Yellow_Face)
[Stock-Brokers Clerk](https://openlibrary.org/works/OL20619319W/Adventure_of_the_Stockbrokers_Clerk)
[Adventure of the Gloria Scott](https://openlibrary.org/works/OL20619337W/Adventure_of_the_Gloria_Scott)
[Adventure of the Musgrave Ritual](https://openlibrary.org/works/OL20619374W/Adventure_of_the_Musgrave_Ritual)
Adventure of the Reigate Squire
Crooked Man
[Adventure of the Resident Patient](https://openlibrary.org/works/OL16090759W)
Adventure of the Greek interpreter
[Naval Treaty](https://openlibrary.org/works/OL14930289W/The_Naval_Treaty)
Final Problem


----------
Also contained in:

 - [Adventures and Memoirs of Sherlock Holmes](https://openlibrary.org/works/OL1518128W)
 - [Celebrated Cases of Sherlock Holmes](https://openlibrary.org/works/OL16076930W)
 - [Complete Sherlock Holmes: Volume I](https://openlibrary.org/works/OL18188824W)
 - [Complete Sherlock Holmes, Volume I](https://openlibrary.org/works/OL14929975W)
 - [Short Stories](https://openlibrary.org/works/OL14929977W)
 - [Works](https://openlibrary.org/works/OL16173818W)', 'mystery and detective stories', true);
INSERT INTO authors VALUES (DEFAULT, 'Doyle, Arthur', 'Conan', '1859', 1);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'Memoirs of Sherlock Holmes [11 stories]') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Doyle, Arthur' AND last_name = 'Conan') AS a1;
INSERT INTO books VALUES (DEFAULT, 9781789503937, 'The Invisible Man', 'This book is the story of Griffin, a scientist who creates a serum to render himself invisible, and his descent into madness that follows.', 'mystery and detective stories', true);
INSERT INTO authors VALUES (DEFAULT, 'H. G.', 'Wells', '21 September 1866', 4555);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'The Invisible Man') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'H. G.' AND last_name = 'Wells') AS a1;
INSERT INTO books VALUES (DEFAULT, 9788490019351, 'The Case-Book of Sherlock Holmes', 'The Illustrious Client
The Blanched Soldier
The Adventure Of The Mazarin Stone
The Adventure of the Three Gables
The Adventure of the Sussex Vampire
The Adventure of the Three Garridebs
The Problem of Thor Bridge
The Adventure of the Creeping Man
The Adventure of the Lions Mane
The Adventure of the Veiled Lodger
The Adventure of Shoscombe Old Place
The Adventure of the Retired Colourman', 'mystery and detective stories', true);
INSERT INTO authors VALUES (DEFAULT, 'Doyle, Arthur', 'Conan', '1859', 1);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'The Case-Book of Sherlock Holmes') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Doyle, Arthur' AND last_name = 'Conan') AS a1;
INSERT INTO books VALUES (DEFAULT, 9782070335244, 'Tom Sawyer, Detective', 'Tom Sawyer, Detective follows Twains popular novels The Adventures of Tom Sawyer,  Adventures of Huckleberry Finn, and Tom Sawyer Abroad. In this novel, Tom turns detective, trying to solve a murder. Twain plays with and celebrates the detective novel, wildly popular at the time. This novel, like the others, is told through the first-person narrative of Huck Finn.', 'mystery and detective stories', true);
INSERT INTO authors VALUES (DEFAULT, 'Mark', 'Twain', '30 November 1835', 23);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'Tom Sawyer, Detective') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Mark' AND last_name = 'Twain') AS a1;
INSERT INTO books VALUES (DEFAULT, 9788374703727, 'The Big Sleep', 'Philip Marlowe, a private eye who operates in Los Angeless seamy underside during the 1930s, takes on his first case, which involves a paralyzed California millionaire, two psychotic daughters, blackmail, and murder', 'mystery and detective stories', true);
INSERT INTO authors VALUES (DEFAULT, 'Chandler,', 'Raymond', '1888', 339);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'The Big Sleep') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Chandler,' AND last_name = 'Raymond') AS a1;
INSERT INTO books VALUES (DEFAULT, 9780007716975, 'Nemesis', 'E-book exclusive extras:1) Christie biographer Charles Osbornes essay on Nemesis;2) "The Marples": the complete guide to all the cases of crime literatures foremost female detective.Even the unflappable Miss Marple is astounded as she reads the letter addressed to her on instructions from the recently deceased tycoon Mr Jason Rafiel, whom she had met on holiday in the West Indies (A Caribbean Mystery). Recognising in her a natural flair for justice and a genius for crime-solving, Mr Rafiel has bequeathed to Miss Marple a £20,000 legacy—and a legacy of an entirely different sort. For he has asked Miss Marple to investigate…his own murder. The only problem is, Mr Rafiel has failed to name a suspect or suspects. And, whoever they are, they will certainly be determined to thwart Miss Marple’s inquiries—no matter what it will take to stop her.Of note: Nemesis is the last Jane Marple mystery that Agatha Christie wrote—though not the last Marple published.', 'mystery and detective stories', true);
INSERT INTO authors VALUES (DEFAULT, 'Agatha', 'Christie', '15 September 1890', 1428);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'Nemesis') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Agatha' AND last_name = 'Christie') AS a1;
INSERT INTO books VALUES (DEFAULT, 9780396068198, 'Murder in Three Acts', 'Sir Charles Cartwright should have known better than to allow thirteen guests to sit down for dinner. For at the end of the evening one of them is dead—choked by a cocktail that contained no trace of poison.

Predictable, says Hercule Poirot, the great detective. But entirely unpredictable is that he can find absolutely no motive for murder.…', 'mystery and detective stories', true);
INSERT INTO authors VALUES (DEFAULT, 'Agatha', 'Christie', '15 September 1890', 1428);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'Murder in Three Acts') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Agatha' AND last_name = 'Christie') AS a1;
INSERT INTO books VALUES (DEFAULT, 9788482565415, 'They Came to Baghdad', 'E-book exclusive extras: Agatha Christie in Baghdad, extensive selections from Agatha Christie: An Autobiography. Plus: Christie biographer Charles Osbornes essay on They Came to Baghdad.Agatha Christie first visited Baghdad as a tourist in 1927; many years later she would become a resident of the exotic and then open city, and it was here, and while on archaeological digs throughout Iraq with her husband, Sir Max Mallowan, that Agatha Christie wrote some of her most important works.They Came to Baghdad is one of Agatha Christies highly successful forays into the spy thriller genre. In this novel, Baghdad is the chosen location for a secret superpower summit. But the word is out, and an underground organisation is plotting to sabotage the talks.Into this explosive situation stumbles Victoria Jones, a young woman with a yearning for adventure who gets more than she bargains for when a wounded secret agent dies in her hotel room. Now, if only she could make sense of his final words: Lucifer... Basrah... Lefarge...', 'mystery and detective stories', true);
INSERT INTO authors VALUES (DEFAULT, 'Agatha', 'Christie', '15 September 1890', 1428);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'They Came to Baghdad') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Agatha' AND last_name = 'Christie') AS a1;
INSERT INTO books VALUES (DEFAULT, 9786169015307, 'Breaking Dawn', 'When you loved the one who was killing you, it left you no options. How could you run, how could you fight, when doing so would hurt that beloved one? If your life was all you had to give, how could you not give it? If it was someone you truly loved? To be irrevocably in love with a vampire is both fantasy and nightmare woven into a dangerously heightened reality for Bella Swan. Pulled in one direction by her intense passion for Edward Cullen, and in another by her profound connection to werewolf Jacob Black, a tumultuous year of temptation, loss, and strife have led her to the ultimate turning point. Her imminent choice to either join the dark but seductive world of immortals or to pursue a fully human life has become the thread from which the fates of two tribes hangs.Now that Bella has made her decision, a startling chain of unprecedented events is about to unfold with potentially devastating, and unfathomable, consequences. Just when the frayed strands of Bellas life-first discovered in Twilight, then scattered and torn in New Moon and Eclipse-seem ready to heal and knit together, could they be destroyed... forever?The astonishing, breathlessly anticipated conclusion to the Twilight Saga, Breaking Dawn illuminates the secrets and mysteries of this spellbinding romantic epic that has entranced millions.', 'mystery and detective stories', true);
INSERT INTO authors VALUES (DEFAULT, 'Stephenie', 'Meyer', '24 December 1973', 168);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'Breaking Dawn') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Stephenie' AND last_name = 'Meyer') AS a1;
INSERT INTO books VALUES (DEFAULT, 9783842472594, 'Scarhaven Keep', 'Scarhaven. A beautiful English town by the ocean, or a harbor for murder and mystery? When a famous actor goes missing, the search leads playwright Richard Copplestone to the seaside town of Scarhaven. Every clue seems to raise more questions, and Copplestone uncovers layer after layer of dark secrets, many of them involving the attractive Audrey Greyle and her family. But the intrigue goes far deeper than anyone in Scarhaven suspects. If Copplestone does not discover the truth soon, he risks endangering the lives of the friends he has made in Scarhaven -- including Audreys. - Back cover.', 'mystery and detective stories', true);
INSERT INTO authors VALUES (DEFAULT, 'J. S.', 'Fletcher', '1863', 187);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'Scarhaven Keep') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'J. S.' AND last_name = 'Fletcher') AS a1;
INSERT INTO books VALUES (DEFAULT, 9798712496037, 'The Red House Mystery', 'This is probably one of the top classics of "golden age" detective fiction. Anyone whos read any mystery novels at all will be familiar with the tropes -- an English country house in the first half of the twentieth century, a locked room, a dead body, an amateur sleuth, a helpful sidekick, and all the rest.

Its a clever story, ingenious enough in its way, and an iconic example of Agatha Christie / Dorothy Sayers -type murder mysteries. If youve read more than a few of those kinds of books, you might find this one a little predictable, but its fun despite that.

Its particularly of note, however, because Raymond Chandler wrote about it extensively in his essay "The Simple Art of Murder." After praising it as "an agreeable book, light, amusing in the Punch style, written with a deceptive smoothness that is not as easy as it looks," he proceeds to take it sharply to task for its essential lack of realism. This book -- which Chandler admired to an extent -- was what he saw as the iconic example of what was wrong with the detective fiction of his day, and to which novels like "The Big Sleep" or "The Long Goodbye", with their hard-boiled, hard-hitting gumshoes and gritty realism, were a direct response.

So this books worth reading not just because its "an agreeable book, light, [and] amusing in the Punch style", but also because reading it will give a deepened appreciation for the later, more realistic detective fiction of writers like Hammett and Chandler.', 'mystery and detective stories', true);
INSERT INTO authors VALUES (DEFAULT, 'A. A.', 'Milne', '18 January 1882', 1114);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'The Red House Mystery') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'A. A.' AND last_name = 'Milne') AS a1;
INSERT INTO books VALUES (DEFAULT, 9788483308301, 'The Haunted Bookshop', 'The Haunted Bookshop by Christopher Morley is the delightful tale of the bookseller Roger Mifflin, the advertising man Aubrey Gilbert, and the lovely Titania Chapman who comes to work at Mifflins Brooklyn bookshop.', 'mystery and detective stories', true);
INSERT INTO authors VALUES (DEFAULT, 'Christopher', 'Morley', '1890', 174);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'The Haunted Bookshop') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Christopher' AND last_name = 'Morley') AS a1;
INSERT INTO books VALUES (DEFAULT, 9798616932099, 'The Boxcar Children', 'Orphaned siblings Henry, Jessie, Benny, and Violet are determined not to be separated after the deaths of their parents. Fearing being sent away to live with their cruel, frightening grandfather, they run away and discover an abandoned boxcar in the woods. They convert the boxcar into a safe, comfortable home and learn to take care of themselves. But when Violet becomes deathly ill, the children are forced to seek out help at the risk of their newfound freedom.

This original 1924 edition contains a few small difference from the revised 1942 edition most readers are familiar with, but the basic story beloved by children remains essentially untouched.', 'mystery and detective stories', true);
INSERT INTO authors VALUES (DEFAULT, 'Gertrude Chandler', 'Warner', '1890', 358);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'The Boxcar Children') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Gertrude Chandler' AND last_name = 'Warner') AS a1;
INSERT INTO books VALUES (DEFAULT, 9798593633057, 'The Adventure of the Speckled Band', 'The Adventure of the Speckled Band (SPEC) is a short story written by Arthur Conan Doyle first published in The Strand Magazine in february 1892. This is the 10th Sherlock Holmes story. Collected in The Adventures of Sherlock Holmes.


----------
Also contained in:

 - [21 Great Stories](https://openlibrary.org/works/OL5272353W)
 - [65 Great Spine Chillers](https://openlibrary.org/works/OL4113986W)
 - [Adventures of Sherlock Holmes](https://openlibrary.org/works/OL262421W/The_Adventures_of_Sherlock_Holmes)
 - [Bedside Book of Famous British Stories](https://openlibrary.org/works/OL12844W)
 - [Best of Sherlock Holmes](https://openlibrary.org/works/OL262571W)
 - [Boys Sherlock Holmes](https://openlibrary.org/works/OL8696809W)
 - [Casebook of Sherlock Holmes](https://openlibrary.org/works/OL18193108W)
 - [Century of Detection](https://openlibrary.org/works/OL20461540W)
 - [Classic Adventures of Sherlock Holmes](https://openlibrary.org/works/OL14929956W)
 - [Extraordinary Cases of Sherlock Holmes](https://openlibrary.org/works/OL14930075W)
 - [Favorite Sherlock Holmes Detective Stories](https://openlibrary.org/works/OL1518175W)
 - [Fiction 100](https://openlibrary.org/works/OL18160158W)
 - [Fictions](https://openlibrary.org/works/OL17733654W)
 - [Fireside Reader](https://openlibrary.org/works/OL16057038W)
 - [Librivox Short Story Collection 007](https://openlibrary.org/works/OL24977897W)
 - [Literature](https://openlibrary.org/works/OL20538101W)
 - [Obras completas de Conan Doyle: II](https://openlibrary.org/works/OL20787319W)
 - [Oxford Book of Gothic Tales](https://openlibrary.org/works/OL2963651W)
 - [Pearson Literature: California: Reading and Language](https://openlibrary.org/works/OL24540813W)
 - [Prentice Hall: Literature Silver](https://openlibrary.org/works/OL7962755W)
 - [Prentice Hall Literature: Timeless Voices, Timeless Themes: Readers Companion: Silver](https://openlibrary.org/works/OL24569568W)
 - [Prentice Hall Literature: Timeless Voices, Timeless Themes: Readers Companion: Silver Level](https://openlibrary.org/works/OL24558357W)
 - [Prentice Hall Literature: Timeless Voices, Timeless Themes: Silver Level](https://openlibrary.org/works/OL16823929W)
 - [Quatre aventures de Sherlock Holmes](https://openlibrary.org/works/OL20942665W)
 - [Selected Adventures of Sherlock Holmes](https://openlibrary.org/works/OL1518403W)
 - [Sherlock Holmes: The Published Apocrypha](https://openlibrary.org/works/OL1518264W/Sherlock_Holmes)
 - [Sherlock Holmes Investigates](https://openlibrary.org/works/OL1518416W)
 - [Sherlock Holmes Mysteries](https://openlibrary.org/works/OL1518392W)
 - [Sherlock Holmes Reader](https://openlibrary.org/works/OL14930658W)
 - [Short Stories](https://openlibrary.org/works/OL7562666W)
 - [Six Great Sherlock Holmes Stories](https://openlibrary.org/works/OL1518361W)
 - [Some Adventures of Sherlock Holmes](https://openlibrary.org/works/OL24168603W)
 - [Tales of Sherlock Holmes](https://openlibrary.org/works/OL1518418W)
 - [Treasury of Sherlock Holmes](https://openlibrary.org/works/OL262548W)
 - [World of Mystery Fiction](https://openlibrary.org/works/OL6798057W)', 'mystery and detective stories', true);
INSERT INTO authors VALUES (DEFAULT, 'Doyle, Arthur', 'Conan', '1859', 1);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'The Adventure of the Speckled Band') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Doyle, Arthur' AND last_name = 'Conan') AS a1;
INSERT INTO books VALUES (DEFAULT, 9781548024567, 'The Works of Edgar Allan Poe in Five Volumes', 'Contains:
[Assignation](https://openlibrary.org/works/OL15645797W)
[Berenice](https://openlibrary.org/works/OL15645808W)
[Black Cat](https://openlibrary.org/works/OL41068W)
[Cask of Amontillado](https://openlibrary.org/works/OL41016W)
[Descent into the Maelstrom](https://openlibrary.org/works/OL273476W)
[Domain of Arnheim](https://openlibrary.org/works/OL15645889W)
[Eleonora](https://openlibrary.org/works/OL14937980W)
[Facts in the Case of M. Valdemar](https://openlibrary.org/works/OL40987W)
[Fall of the House of Usher](https://openlibrary.org/works/OL41078W)
[Imp of the Perverse](https://openlibrary.org/works/OL15481077W)
[Island of the Fay](https://openlibrary.org/works/OL15645993W)
[Landors Cottage](https://openlibrary.org/works/OL15646005W)
[Masque of the Red Death](https://openlibrary.org/works/OL41050W)
[Mesmeric Revelation](https://openlibrary.org/works/OL15646037W)
[Pit and the Pendulum](https://openlibrary.org/works/OL273550W)
[Premature Burial](https://openlibrary.org/works/OL24583029W)
[Purloined Letter](https://openlibrary.org/works/OL41065W)
[Silence — A Fable](https://openlibrary.org/works/OL13370628W)
[Tell-tale Heart](https://openlibrary.org/works/OL41059W)
[Thousand-and-Second Tale of Scheherazade](https://openlibrary.org/works/OL15646039W)
[Von Kempelen and His Discovery](https://openlibrary.org/works/OL25111544W)
[William Wilson](https://openlibrary.org/works/OL16088822W)', 'mystery and detective stories', true);
INSERT INTO authors VALUES (DEFAULT, 'Poe, Edgar', 'Allan', '19 January 1809', 243);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'The Works of Edgar Allan Poe in Five Volumes') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Poe, Edgar' AND last_name = 'Allan') AS a1;
INSERT INTO books VALUES (DEFAULT, 9780833508911, 'My fathers dragon', 'A young boy runs away from home to rescue an abused baby dragon held captive to serve as a free twenty-four hour, seven-days-a-week ferry for the lazy wild animals living on Wild Island.', 'mystery and detective stories', true);
INSERT INTO authors VALUES (DEFAULT, 'Ruth Stiles', 'Gannett', '12 August 1923', 16);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'My fathers dragon') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Ruth Stiles' AND last_name = 'Gannett') AS a1;
INSERT INTO books VALUES (DEFAULT, 9782017072126, 'Five on a Treasure Island', 'Julian, Dick, Anne, George and Timmy the dog find excitement and adventure wherever they go in Enid Blytons most popular series. In their first adventure, the Famous Five find a shipwreck off Kirrin Island. But where is the treasure? The Famous Five are on the trail, looking for clues, but theyre not alone. Someone else has got the same idea! Time is running out for the Famous Five -- who will follow the clues and get to the treasure first?', 'mystery and detective stories', true);
INSERT INTO authors VALUES (DEFAULT, 'Enid', 'Blyton', '11 August 1897', 4234);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'Five on a Treasure Island') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Enid' AND last_name = 'Blyton') AS a1;
INSERT INTO books VALUES (DEFAULT, 9788484410348, 'Over Sea, Under Stone (The Dark Is Rising #1)', 'On holiday in Cornwall, the three Drew children discover an ancient map in the attic of the house that they are staying in. They know immediately that it is special. It is even more than that -- the key to finding a grail, a source of power to fight the forces of evil known as the Dark. And in searching for it themselves, the Drews put their very lives in peril.
This is the first volume of Susan Coopers brilliant and absorbing fantasy sequence known as The Dark Is Rising.', 'mystery and detective stories', true);
INSERT INTO authors VALUES (DEFAULT, 'Susan', 'Cooper', '1935', 50);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'Over Sea, Under Stone (The Dark Is Rising #1)') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Susan' AND last_name = 'Cooper') AS a1;
INSERT INTO books VALUES (DEFAULT, 9782724222326, 'Where are the children?', 'Nancy Harmon had fled the evil of her first marriage, the macabre deaths of her two little children, the hideous charges against her. She changed her name and moved across the country. Now she was married again, had two more lovely children, and her life was filled with happiness....

until the morning when she looked for her children and found only one tattered red mitten and knew that the nightmare was beginning again...', 'mystery and detective stories', true);
INSERT INTO authors VALUES (DEFAULT, 'Mary Higgins', 'Clark', '24 December 1927', 841);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'Where are the children?') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Mary Higgins' AND last_name = 'Clark') AS a1;
INSERT INTO books VALUES (DEFAULT, 9782070537969, 'The House with a Clock in Its Walls', 'When Lewis Barnavelt, an orphan, comes to stay with his uncle Jonathan, he expects to meet an ordinary person. But he is wrong. Uncle Jonathan and his next-door neighbor, Mrs. Zimmermann, are both magicians! Lewis is thrilled. At first, watching magic is enough. Then Lewis experiments with magic himself and unknowingly resurrects the former owner of the house: a woman named Selenna Izard. It seems that Selenna and her husband built a timepiece into the walls—a clock that could obliterate humankind. And only the Barnavelts can stop it!


----------
Also contained in:
[Best of John Bellairs](https://openlibrary.org/works/OL3338229W)', 'mystery and detective stories', true);
INSERT INTO authors VALUES (DEFAULT, 'John', 'Bellairs', '1938', 40);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'The House with a Clock in Its Walls') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'John' AND last_name = 'Bellairs') AS a1;
INSERT INTO books VALUES (DEFAULT, 9788491377665, 'Il sorriso di Monna Topisa', 'Geronimo investigates to see if the famous painting Mona Mousa holds a secret code.', 'painting', true);
INSERT INTO authors VALUES (DEFAULT, 'Gerónimo', 'Stilton', '1958-01-01', 0);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'Il sorriso di Monna Topisa') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Gerónimo' AND last_name = 'Stilton') AS a1;
INSERT INTO books VALUES (DEFAULT, 9788483463628, 'False Impression', 'Its September 10, 2001, and Lady Victoria Wentworth is sitting in spacious Wentworth Hall considering the sad state of family fortunes when a female intruder slips in, slashes her throat and cuts off her ear.  The next day in New York, art expert Anna Petrescu heads to her job as art wrangler for wealthy magnate Bryce Fenston of Fenston Finance.  The pairs offices are in the Twin towers, and when disaster strikes, each sees the tragedy as an opportunity to manipulate a transaction scheduled to transfer ownership of a legendary Van Gogh painting.', 'painting', true);
INSERT INTO authors VALUES (DEFAULT, 'Jeffrey', 'Archer', '1940', 169);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'False Impression') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Jeffrey' AND last_name = 'Archer') AS a1;
INSERT INTO books VALUES (DEFAULT, 9788408048947, 'Tom Clancys Net Force', 'Here comes a Clancy first: a new series of novels for young adults starring a team of troubleshooting teens--the Net Force Explorers--who know more about cutting edge technology than their teachers!', 'programming', true);
INSERT INTO authors VALUES (DEFAULT, 'Tom', 'Clancy', '12 April 1947', 767);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'Tom Clancys Net Force') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Tom' AND last_name = 'Clancy') AS a1;
INSERT INTO books VALUES (DEFAULT, 9781449388393, 'Hackers', 'Today, technology is cool. Owning the most powerful computer, the latest high-tech gadget, and the whizziest website is a status symbol on a par with having a flashy car or a designer suit. And a media obsessed with the digital explosion has reappropriated the term "computer nerd" so that its practically synonymous with "entrepreneur." Yet, a mere fifteen years ago, wireheads hooked on tweaking endless lines of code were seen as marginal weirdos, outsiders whose world would never resonate with the mainstream. That was before one pioneering work documented the underground computer revolution that was about to change our world forever.

With groundbreaking profiles of Bill Gates, Steve Wozniak, MITs Tech Model Railroad Club, and more, Steven Levys Hackers brilliantly captures a seminal moment when the risk takers and explorers were poised to conquer twentieth-century Americas last great frontier. And in the Internet age, "the hacker ethic" -- first espoused here -- is alive and well. - Back cover.', 'programming', false);
INSERT INTO authors VALUES (DEFAULT, 'Steven', 'Levy', '1951', 22);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'Hackers') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Steven' AND last_name = 'Levy') AS a1;
INSERT INTO books VALUES (DEFAULT, 9781449319267, 'Learning PHP, MySQL & JavaScript', 'Learning PHP, MySQL & JavaScript will teach you how to create responsive, data-driven websites with the three central technologies of PHP, MySQL and JavaScript - whether or not you know how to program. This simple, streamlined guide explains how the powerful combination of PHP and MySQL provides a painless way to build modern websites with dynamic data and user interaction. Youll also learn how to add JavaScript to create rich Internet websites and applications, and how to use Ajax to handle background communication with a web server. This book explains each technology separately, shows you how to combine them, and introduces valuable concepts in modern web programming, including objects, XHTML, cookies, regular expressions and session management.', 'programming', false);
INSERT INTO authors VALUES (DEFAULT, 'Robin', 'Nixon', '1961', 17);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'Learning PHP, MySQL & JavaScript') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Robin' AND last_name = 'Nixon') AS a1;
INSERT INTO books VALUES (DEFAULT, 9798528777009, 'Hard Times', 'Dickens scathing portrait of Victorian industrial society and its misapplied utilitarian philosophy, Hard Times features schoolmaster Thomas Gradgrind, one of his most richly dimensional, memorable characters. Filled with the details and wonders of small-town life, it is also a daring novel of ideas and ultimately, a celebration of love, hope, and limitless possibilities of the imagination.', 'psychology', true);
INSERT INTO authors VALUES (DEFAULT, 'Charles', 'Dickens', '7 February 1812', 4320);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'Hard Times') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Charles' AND last_name = 'Dickens') AS a1;
INSERT INTO books VALUES (DEFAULT, 9798598007266, 'Saint Francis of Assisi', 'G.K. Chesterton lends his witty, astute and sardonic prose to the much loved figure of Saint Francis of Assis. Grounding the man behind the myth he states "however wild and romantic his gyrations might appear to many, [Francis] always hung on to reason by one invisible and indestructible hair....The great saint was sane....He was not a mere eccentric because he was always turning towards the center and heart of the maze; he took the queerest and most zigzag shortcuts through the wood, but he was always going home."Review: "his opinions shine from every page. The reader is rewarded with many fresh perspectives on Francis..." -- Franciscan, May 2002', 'psychology', false);
INSERT INTO authors VALUES (DEFAULT, 'Chesterton, G.', 'K.', '29 May 1874', 2);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'Saint Francis of Assisi') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Chesterton, G.' AND last_name = 'K.') AS a1;
INSERT INTO books VALUES (DEFAULT, 9783423140577, 'Tender is the Night', 'A psychiatrist, Dick Diver, treats and eventually marries a wealthy patient, Nicole.  Eventually, this marriage destroys him.', 'psychology', true);
INSERT INTO authors VALUES (DEFAULT, 'F. Scott', 'Fitzgerald', '24 September 1896', 593);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'Tender is the Night') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'F. Scott' AND last_name = 'Fitzgerald') AS a1;
INSERT INTO books VALUES (DEFAULT, 9789754585728, 'The Curious Incident of the Dog in the Night-Time', 'This is Christophers murder mystery story. There are no lies in this story because Christopher cant tell lies. christopher does not like strangers or the colours yellow or brown or being touched. On the other hand, he knows all the countries in the world and their capital cities and every prime number up to 7507. When Christohper decides to find out who killed the neighbours dog, his mystery story becomes more complicated than he could ever have predicted.', 'psychology', true);
INSERT INTO authors VALUES (DEFAULT, 'Mark', 'Haddon', '26 September 1962', 96);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'The Curious Incident of the Dog in the Night-Time') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Mark' AND last_name = 'Haddon') AS a1;
INSERT INTO books VALUES (DEFAULT, 9780751527377, 'Tuesdays with Morrie', 'Tuesdays with Morrie is a memoir by American author Mitch Albom about a series of visits Albom made to his former sociology professor Morrie Schwartz, as Schwartz gradually dies of ALS. The book topped the New York Times Non-Fiction Best-Sellers List for 23 combined weeks in 2000, and remained on the New York Times best-selling list for more than four years after. In 2006, Tuesdays with Morrie was the bestselling memoir of all time.', 'psychology', false);
INSERT INTO authors VALUES (DEFAULT, 'Mitch', 'Albom', '23 May 1958', 46);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'Tuesdays with Morrie') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Mitch' AND last_name = 'Albom') AS a1;
INSERT INTO books VALUES (DEFAULT, 9780061908040, 'Zen and the Art of Motorcycle Maintenance', '"The real cycle youre working on is a cycle called yourself."One of the most important and influential books of the past half-century, Robert M. Pirsigs Zen and the Art of Motorcycle Maintenance is a powerful, moving, and penetrating examination of how we live and a meditation on how to live better. The narrative of a father on a summer motorcycle trip across Americas Northwest with his young son, it becomes a profound personal and philosophical odyssey into lifes fundamental questions. A true modern classic, it remains at once touching and transcendent, resonant with the myriad confusions of existence and the small, essential triumphs that propel us forward.', 'psychology', false);
INSERT INTO authors VALUES (DEFAULT, 'Robert M.', 'Pirsig', '6 Sep 1928', 4);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'Zen and the Art of Motorcycle Maintenance') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Robert M.' AND last_name = 'Pirsig') AS a1;
INSERT INTO books VALUES (DEFAULT, 9780583337144, 'Men are From Mars, Women are From Venus', 'Once upon a time Martians and Venusians met, fell in love, and had happy relationships together because they respected and accepted their differences. Then they came to Earth and amnesia set in: they forgot they were from different planets.Based on years of successful counseling of couples and individuals, Men Are from Mars, Women Are from Venus has helped millions of couples transform their relationships. Now viewed as a modern classic, this phenomenal book has helped men and women realize how different they really are and how to communicate their needs in such a way that conflict doesnt arise and intimacy is given every chance to grow.', 'psychology', false);
INSERT INTO authors VALUES (DEFAULT, 'Gray,', 'John', '28 Dec 1951', 18);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'Men are From Mars, Women are From Venus') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Gray,' AND last_name = 'John') AS a1;
INSERT INTO books VALUES (DEFAULT, 9781483077031, 'The Fountainhead', 'The Fountainhead is a 1943 novel by Ayn Rand. It was Rands first major literary success and brought her fame and financial success. More than 6.5 million copies of the book have been sold worldwide.', 'psychology', true);
INSERT INTO authors VALUES (DEFAULT, 'Ayn', 'Rand', 'February 2, 1905', 209);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'The Fountainhead') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Ayn' AND last_name = 'Rand') AS a1;
INSERT INTO books VALUES (DEFAULT, 9781721307852, 'Giovannis Room', 'Considered an audacious second novel, GIOVANNIS ROOM is set in the 1950s Paris of American expatriates, liaisons, and violence.  This now-classic story of a fated love triangle explores, with uncompromising clarity, the conflicts between desire, conventional morality and sexual identity.', 'psychology', true);
INSERT INTO authors VALUES (DEFAULT, 'Baldwin,', 'James', '2 August 1924', 1);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'Giovannis Room') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Baldwin,' AND last_name = 'James') AS a1;
INSERT INTO books VALUES (DEFAULT, 9781444110241, 'A View from the Bridge', 'In A View from the Bridge Arthur Miller explores the intersection between one mans self-delusion and the brutal trajectory of fate. Eddie Carbone is a Brooklyn longshoreman, a hard-working man whose life has been soothingly predictable. He hasnt counted on the arrival of two of his wifes relatives, illegal immigrants from Italy; nor has he recognized his true feelings for his beautiful niece, Catherine. And in due course, what Eddie doesnt knowabout her, about life, about his own heartwill have devastating consequences.', 'psychology', true);
INSERT INTO authors VALUES (DEFAULT, 'Miller,', 'Arthur', '1915', 1);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'A View from the Bridge') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Miller,' AND last_name = 'Arthur') AS a1;
INSERT INTO books VALUES (DEFAULT, 9780733612275, 'The 48 Laws of Power', 'Amoral, cunning, ruthless, and instructive, this piercing work distills three thousand years of the history of power in to forty-eight well explicated laws. As attention--grabbing in its design as it is in its content, this bold volume outlines the laws of power in their unvarnished essence, synthesizing the philosophies of Machiavelli, Sun-tzu, Carl von Clausewitz, and other great thinkers. Some laws teach the need for prudence ("Law 1: Never Outshine the Master"), the virtue of stealth ("Law 3: Conceal Your Intentions"), and many demand the total absence of mercy ("Law 15: Crush Your Enemy Totally"), but like it or not, all have applications in real life. Illustrated through the tactics of Queen Elizabeth I, Henry Kissinger, P. T. Barnum, and other famous figures who have wielded--or been victimized by--power, these laws will fascinate any reader interested in gaining, observing, or defending against ultimate control.', 'psychology', false);
INSERT INTO authors VALUES (DEFAULT, 'Robert', 'Greene', '14 May 1959', 59);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'The 48 Laws of Power') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Robert' AND last_name = 'Greene') AS a1;
INSERT INTO books VALUES (DEFAULT, 9789570521191, 'My Sisters Keeper', 'With her penetrating insight into the hearts and minds of real people, Jodi Picoults My Sisters Keeper examines what it means to be a good parent, a good sister, a good person, and what happens when emotions meet with scientific advances. ***Now a major film.***

Anna is not sick, but she might as well be. By age thirteen, she has undergone countless surgeries, transfusions and shots so that her older sister, Kate, can somehow fight the leukemia that has plagued her since childhood. **Anna was conceived as a bone marrow match for Kate a life and a role that she has never questioned until now.**

**Like most teenagers, Anna is beginning to ask herself who she truly is.** But unlike most teenagers, she has always been defined in terms of her sister - and so Anna makes a decision that for most would be unthinkable a decision that will tear her family apart and have **perhaps fatal consequences for the sister she loves.**

**Told from multiple points of view, My Sisters Keeper examines what it means to be a good parent, a good sister, a good person.** Is it morally correct to do whatever it takes to save a childs life . . . even if that means infringing upon the rights of another? Should you follow your own heart, or let others lead you?

**Once again, in My Sisters Keeper, *Jodi Picoult tackles a controversial real-life subject with grace, wisdom, and sensitivity.***', 'psychology', true);
INSERT INTO authors VALUES (DEFAULT, 'Jodi', 'Picoult', '19 May 1966', 307);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'My Sisters Keeper') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Jodi' AND last_name = 'Picoult') AS a1;
INSERT INTO books VALUES (DEFAULT, 9780385364140, 'Sophies Choice', 'The gripping, unforgettable story of Stingo, a 22-year-old writer; Sophie, a Polish-Catholic beauty who survived the Nazi concentration camp at Auschwitz; and Nathan, her mercurial lover. The three friends share magical, heart-warming times until doom overtakes them as Sophies and Nathans darkest secrets are revealed.', 'psychology', true);
INSERT INTO authors VALUES (DEFAULT, 'William', 'Styron', '1925', 121);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'Sophies Choice') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'William' AND last_name = 'Styron') AS a1;
INSERT INTO books VALUES (DEFAULT, 9782253123378, 'Liseys Story', 'Liseys Story is a novel by American writer Stephen King that combines elements of psychological horror and romance. The novel was released on October 24, 2006. It won the 2006 Bram Stoker Award for Best Novel, and was nominated for the World Fantasy Award in 2007. An early excerpt from the novel, a short story titled "Lisey and the Madman", was published in McSweeney’s Enchanted Chamber of Astonishing Stories (2004), and was nominated for the 2004 Bram Stoker Award for Best Long Fiction. King has stated that this is his favorite of the novels he has written.', 'psychology', true);
INSERT INTO authors VALUES (DEFAULT, 'Stephen', 'King', 'September 21, 1947', 663);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'Liseys Story') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Stephen' AND last_name = 'King') AS a1;
INSERT INTO books VALUES (DEFAULT, 9788525432186, 'Sapiens', 'New York Times Bestseller

A Summer Reading Pick for President Barack Obama, Bill Gates, and Mark Zuckerberg

From a renowned historian comes a groundbreaking narrative of humanity’s creation and evolution—a #1 international bestseller—that explores the ways in which biology and history have defined us and enhanced our understanding of what it means to be “human.”

One hundred thousand years ago, at least six different species of humans inhabited Earth. Yet today there is only one—homo sapiens. What happened to the others? And what may happen to us?

Most books about the history of humanity pursue either a historical or a biological approach, but Dr. Yuval Noah Harari breaks the mold with this highly original book that begins about 70,000 years ago with the appearance of modern cognition. From examining the role evolving humans have played in the global ecosystem to charting the rise of empires, Sapiens integrates history and science to reconsider accepted narratives, connect past developments with contemporary concerns, and examine specific events within the context of larger ideas.

Dr. Harari also compels us to look ahead, because over the last few decades humans have begun to bend laws of natural selection that have governed life for the past four billion years. We are acquiring the ability to design not only the world around us, but also ourselves. Where is this leading us, and what do we want to become?

Featuring 27 photographs, 6 maps, and 25 illustrations/diagrams, this provocative and insightful work is sure to spark debate and is essential reading for aficionados of Jared Diamond, James Gleick, Matt Ridley, Robert Wright, and Sharon Moalem.', 'psychology', false);
INSERT INTO authors VALUES (DEFAULT, 'Yuval N.', 'Harari', '24 February 1976', 68);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'Sapiens') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Yuval N.' AND last_name = 'Harari') AS a1;
INSERT INTO books VALUES (DEFAULT, 9780553479140, 'The long road home', 'Bestselling novelist Danielle Steel takes us on a harrowing journey into the heart of Americas hidden shame in a novel that explores the power of forgiveness, the dark side of childhood, and one womans unbreakable spirit.From her secret perch at the top of the stairs, Gabriella Harrison watches the guests arrive at her parents lavish Manhattan townhouse.  At seven, she knows she is an intruder in her parents party, in her parents life.  But she cant resist the magic.  Later, she waits for the click, click, click of her mothers high heels, the angry words, and the pain that will follow.  Gabriella already knows to hide her bruises, certain she is to blame for her mothers rage--and her fathers failure to protect her.  Her world is a confusing blend of terror, betrayal, and pain.  Her parents aristocratic world is no safeguard against the abuse that knows no boundaries, respects no person, no economic lines.  Gabriella knows that, try as she might, there is no safe place for her to hide.Even as a child, her only escape is through the stories she writes.  Only writing can dull the pain of her lonely world.  And when her parents marriage collapses, Gabriella is given her first reprieve, as her father disappears, and then her mother abandons her to a convent.  There, Gabriellas battered body and soul begin to mend.  Amid the quiet safety and hushed rituals of the nuns, Gabriella grows into womanhood in a safe, peaceful world.  Then a young priest comes into her life.  Father Joe Connors never questioned his vocation until Gabriella entered the confessional and shared her soul.  Confession leads to friendship.  And friendship grows dangerously into love.  Like Gabriella, Joe is haunted by the pain of his childhood, consumed by guilt over a family tragedy, for which he blames himself.  With Gabriella, Joe takes the first steps toward healing.  But their relationship leads to tragedy as Joe must choose between the priesthood and Gabriella, and life in the real world where he fears he does not belong, and cannot cope. Exiled and disgraced, and nearly destroyed, Gabriella struggles to survive on her own in New York.  There she seeks healing and escape through her writing again, this time as an adult, and her life as a writer begins.  But just when she thinks she is beyond hurt, Gabriella is once again betrayed by someone she trusts.  Brought to the edge of despair, physically attacked beyond recognition and belief, haunted by abuse in her present and her past, she nonetheless manages to find hope again, and the courage to face the past.  On a pilgrimage destined to bring her face-to-face with those who sought to destroy her in her early life, she finds forgiveness, freedom from guilt, and healing from abuse.  When Gabriella faces what was done to her, and why, she herself is free at last.  With profound insight, Danielle Steel has created a vivid portrait of an abused childs broken world, and the courage necessary to face it and free herself from the past.  A work of daring and compassion, a tale of healing that will shock and touch and move you to your very soul, it exposes the terror of child abuse, and opens the doors on a subject that affects us all.  The Long Road Home is more than riveting fiction.  It is an inspiration to us all.  A work of courage, hope, and love.From the Paperback edition.', 'psychology', true);
INSERT INTO authors VALUES (DEFAULT, 'Steel,', 'Danielle.', 'August 14, 1947', 1542);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'The long road home') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Steel,' AND last_name = 'Danielle.') AS a1;
INSERT INTO books VALUES (DEFAULT, 9781455546435, 'The switch', 'From #1 New York Times bestselling author Sandra Brown comes another masterful creation, a riveting novel of suspense, revenge, and unpredictable twists and turns...Identical twins Melina and Gillian Lloyd havent considered switching places since childhood. So when Melina proposes that Gillian take her place as a media escort to NASA astronaut Col. "Chief" Hart, she refuses...at first. The following morning Melina receives terrible news: her sister has been brutally murdered-and Chief, though innocent, is the prime suspect. He and Melina are determined to find the killer, a megalomaniac whose horrific schemes require Gillians replacement, her identical twin-Melina.', 'psychology', true);
INSERT INTO authors VALUES (DEFAULT, 'Brown,', 'Sandra', '1948', 160);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'The switch') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Brown,' AND last_name = 'Sandra') AS a1;
INSERT INTO books VALUES (DEFAULT, 9783436014223, 'Die Sexualität im Kulturkampf', '**Die Sexualität im Kulturkampf** ("sexuality in the culture war"), 1936 (published later in English as **The Sexual Revolution**), is a work by Wilhelm Reich. The subtitle is "zur sozialistischen Umstrukturierung des Menschen" ("for the socialist restructuring of humans"), the double title reflecting the two-part structure of the work.

The first part "analyzes the crisis of the bourgeois sexual morality" and the failure of the attempts of "sexual reform" that preserved the frame of capitalist society (marriage and family). The second part reconstructs the history of the sexual revolution that took place with the establishment of the Soviet Union since 1922, and which was opposed by Joseph Stalin in the late 1920s.

(Source: [Wikipedia](https://en.wikipedia.org/wiki/Die_Sexualit%C3%A4t_im_Kulturkampf))', 'psychology', false);
INSERT INTO authors VALUES (DEFAULT, 'Wilhelm', 'Reich', '24 March 1897', 118);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'Die Sexualität im Kulturkampf') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Wilhelm' AND last_name = 'Reich') AS a1;
INSERT INTO books VALUES (DEFAULT, 9789750830426, 'When We Were Orphans', 'You seldom read a novel that so convinces you it is extending the possibilities of fiction. Sunday TimesEngland, 1930s. Christopher Banks has become the countrys most celebrated detective, his cases the talk of London society. Yet one unsolved crime has always haunted him: the mysterious disappearance of his parents, in old Shanghai, when he was a small boy. Moving between London and Shanghai of the inter-war years, When We Were Orphans is a remarkable story of memory, intrigue and the need to return.', 'psychology', true);
INSERT INTO authors VALUES (DEFAULT, 'Kazuo', 'Ishiguro', '8 November 1954', 39);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'When We Were Orphans') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Kazuo' AND last_name = 'Ishiguro') AS a1;
INSERT INTO books VALUES (DEFAULT, 9781400044603, 'Memoria de mis putas tristes', '"Cuenta la vida de este anciano solitario, un apasionado de la música clásica, nada aficionado de las mascotas y lleno de manías. Por él sabremos cómo en todas sus aventuras sexuales (que no fueron pocas) siempre dio a cambio algo de dinero, pero nunca imaginó que de ese modo encontraría el verdadero amor."-- P. [4] of cover.', 'psychology', true);
INSERT INTO authors VALUES (DEFAULT, 'Gabriel Garcia', 'Marquez', '1927', 407);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'Memoria de mis putas tristes') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Gabriel Garcia' AND last_name = 'Marquez') AS a1;
INSERT INTO books VALUES (DEFAULT, 9780670410620, 'Critique of psychoanalysis', 'Extracted from Volumes 1, 8, and 18. Includes Jungs Foreword to Phenomènes Occultes (1939), "On the Psychology and Pathology of So-called Occult Phenomena," "The Psychological Foundations of Belief in Spirits," "The Soul and Death," "Psychology and Spiritualism," "On Spooks: Heresy or Truth?" and Foreword to Jaffé: Apparitions and Precognition.', 'psychology', false);
INSERT INTO authors VALUES (DEFAULT, 'Jung, C.', 'G.', '1875.07.26', 156);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'Critique of psychoanalysis') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Jung, C.' AND last_name = 'G.') AS a1;
INSERT INTO books VALUES (DEFAULT, 9783499170522, 'The Anatomy of Human Destructiveness', 'A study of man’s destructive nature that utilizes evidence from psychoanalysis, neurophysiology, animal psychology, paleontology, and anthropology and is documented with clinical examples.', 'psychology', false);
INSERT INTO authors VALUES (DEFAULT, 'Fromm,', 'Erich', '23 March 1900', 4);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'The Anatomy of Human Destructiveness') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Fromm,' AND last_name = 'Erich') AS a1;
INSERT INTO books VALUES (DEFAULT, 9781731550897, 'Sense and Sensibility', 'When Mr. Dashwood dies, he must leave the bulk of his estate to the son by his first marriage, which leaves his second wife and three daughters (Elinor, Marianne, and Margaret) in straitened circumstances. They are taken in by a kindly cousin, but their lack of fortune affects the marriageability of both practical Elinor and romantic Marianne. When Elinor forms an attachment for the wealthy Edward Ferrars, his family disapproves and separates them. And though Mrs. Jennings tries to match the worthy (and rich) Colonel Brandon to her, Marianne finds the dashing and fiery Willoughby more to her taste. Both relationships are sorely tried. But this is a romance, and through the hardships and heartbreak, true love and a happy ending will find their way for both the sister who is all sense and the one who is all sensibility. - Publisher.', 'romance', true);
INSERT INTO authors VALUES (DEFAULT, 'Austen,', 'Jane', 'December 16, 1775', 1242);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'Sense and Sensibility') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Austen,' AND last_name = 'Jane') AS a1;
INSERT INTO books VALUES (DEFAULT, 9781493724949, 'Women in Love', 'Dark, but filled with bright genius, Women in Love is a prophetic masterpiece steeped in eroticism, filled with perceptions about sexual power and obsession that have proven to be timeless and true.', 'romance', true);
INSERT INTO authors VALUES (DEFAULT, 'Lawrence, D.', 'H.', '1885', 1);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'Women in Love') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Lawrence, D.' AND last_name = 'H.') AS a1;
INSERT INTO books VALUES (DEFAULT, 9788886229982, 'Heart of Darkness', 'Heart of Darkness (1899) is a novella by Polish-English novelist Joseph Conrad, about a voyage up the Congo River into the Congo Free State, in the heart of Africa, by the storys narrator Charles Marlow. Marlow tells his story to friends aboard a boat anchored on the River Thames. Joseph Conrad is one of the greatest English writers, and Heart of Darkness is considered his best.  His readers are brought to face our psychological selves to answer, ‘Who is the true savage?’. Originally published in 1902, Heart of Darkness remains one of this century’s most enduring works of fiction. Written several years after Joseph Conrad’s grueling sojourn in the Belgian Congo, the novel is a complex meditation on colonialism, evil, and the thin line between civilization and barbarity.', 'romance', true);
INSERT INTO authors VALUES (DEFAULT, 'Conrad,', 'Joseph', '3 December 1857', 10);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'Heart of Darkness') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Conrad,' AND last_name = 'Joseph') AS a1;
INSERT INTO books VALUES (DEFAULT, 9798481068572, 'The Age of Innocence', 'Edith Whartons most famous novel, written immediately after the end of the First World War, is a brilliantly realized anatomy of New York society in the 1870s, the world in which she grew up, and from which she spent her life escaping. Newland Archer, Whartons protagonist, charming, tactful, enlightened, is a thorough product of this society; he accepts its standards and abides by its rules but he also recognizes its limitations. His engagement to the impeccable May Welland assures him of a safe and conventional future, until the arrival of Mays cousin Ellen Olenska puts all his plans in jeopardy. Independent, free-thinking, scandalously separated from her husband, Ellen forces Archer to question the values and assumptions of his narrow world. As their love for each other grows, Archer has to decide where his ultimate loyalty lies. - Back cover.', 'romance', true);
INSERT INTO authors VALUES (DEFAULT, 'Edith', 'Wharton', '24 January 1862', 1091);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'The Age of Innocence') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Edith' AND last_name = 'Wharton') AS a1;
INSERT INTO books VALUES (DEFAULT, 9780007250264, 'Poirot investigates', 'First there was the mystery of the film star and the diamond… then came the ‘suicide’ that was murder… the mystery of the absurdly chaep flat… a suspicious death in a locked gun-room… a million dollar bond robbery… the curse of a pharoah’s tomb… a jewel robbery by the sea… the abduction of a Prime Minister… the disappearance of a banker… a phone call from a dying man… and, finally, the mystery of the missing will.  What links these fascinating cases? Only the brilliant deductive powers of Hercule Poirot!', 'romance', true);
INSERT INTO authors VALUES (DEFAULT, 'Agatha', 'Christie', '15 September 1890', 1428);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'Poirot investigates') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Agatha' AND last_name = 'Christie') AS a1;
INSERT INTO books VALUES (DEFAULT, 9783423144544, 'The Portrait Of A Lady', 'Een rijke Amerikaanse jonge vrouw met een sterke drang naar onafhankelijkheid blijft, ondanks alles wat ze in de loop van haar huwelijk over hem te weten komt, haar onbekrompen maar oppervlakkige echtgenoot trouw.', 'romance', true);
INSERT INTO authors VALUES (DEFAULT, 'James,', 'Henry', '15 April 1843', 99);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'The Portrait Of A Lady') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'James,' AND last_name = 'Henry') AS a1;
INSERT INTO books VALUES (DEFAULT, 9780593685365, 'The Mystery of the Blue Train', 'Bound for the Riviera, detective Hercule Poirot has boarded Le Train Bleu, an elegant, leisurely means of travel, free of intrigue. Then he meets Ruth Kettering. The American heiress bailing out of a doomed marriage is en route to reconcile with her former lover. But by morning, her private affairs are made public when she is found murdered in her luxury compartment. The rumour of a strange man loitering in the victims shadow is all Poirot has to go on. Until Mrs. Ketterings secret life begins to unfold...', 'romance', true);
INSERT INTO authors VALUES (DEFAULT, 'Agatha', 'Christie', '15 September 1890', 1428);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'The Mystery of the Blue Train') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Agatha' AND last_name = 'Christie') AS a1;
INSERT INTO books VALUES (DEFAULT, 9780316065221, 'New Moon', 'Love stories. Horror fiction. Now in a Special Trade Demy Paperback Edition. The dramatic sequel to TWILIGHT, following the tale of Bella, a teenage girl whose love for a vampire gets her into trouble. I stuck my finger under the edge of the paper and jerked it under the tape. Shoot,  I muttered when the paper sliced my finger. A single drop of blood oozed from the tiny cut. It all happened very quickly then. No! Edward roared ... Dazed and disorientated, I looked up from the bright red blood pulsing out of my arm - and into the fevered eyes of the six suddenly ravenous vampires. For Bella Swan, there is one thing more important than life itself: Edward Cullen. But being in love with a vampire is more dangerous than Bella ever could have imagined. Edward has already rescued Bella from the clutches of an evil vampire but now, as their daring relationship threatens all that is near and dear to them, they realise their troubles may just be beginning.', 'romance', true);
INSERT INTO authors VALUES (DEFAULT, 'Stephenie', 'Meyer', '24 December 1973', 168);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'New Moon') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Stephenie' AND last_name = 'Meyer') AS a1;
INSERT INTO books VALUES (DEFAULT, 9787544805711, 'Eclipse', 'A beautifully written book by Stephanie Meyer. This book will take you on an adventure like no other, the epic romance of a 110 year old vampire frozen in the body of a 17 year old, an 18 year old human named Isabella Swan. Join Edward Cullen and Bella Swan on this action packed romance.', 'romance', true);
INSERT INTO authors VALUES (DEFAULT, 'Stephenie', 'Meyer', '24 December 1973', 168);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'Eclipse') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Stephenie' AND last_name = 'Meyer') AS a1;
INSERT INTO books VALUES (DEFAULT, 9780751558906, 'The Price of Salt', 'THE PRICE OF SALT is the famous lesbian love story by Patricia Highsmith, written under the pseudonym Claire Morgan. The author became notorious due to the storys latent lesbian content and happy ending, the latter having been unprecedented in homosexual fiction. Highsmith recalled that the novel was inspired by a mysterious woman she happened across in a shop and briefly stalked. Because of the happy ending (or at least an ending with the possibility of happiness) which defied the lesbian pulp formula and because of the unconventional characters that defied stereotypes about homosexuality, THE PRICE OF SALT was popular among lesbians in the 1950s. The book fell out of print but was re-issued and lives on today as a pioneering work of lesbian romance.', 'romance', true);
INSERT INTO authors VALUES (DEFAULT, 'Patricia', 'Highsmith', '19 Jan 1921', 132);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'The Price of Salt') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Patricia' AND last_name = 'Highsmith') AS a1;
INSERT INTO books VALUES (DEFAULT, 9780007873746, 'Flowers in the Attic', 'Flowers in the Attic is a 1979 Gothic novel by V. C. Andrews. It is the first book in the Dollanganger Series. The novel is written in the first-person, from the point of view of Cathy Dollanganger. In 1993, Flowers in the Attic was awarded the Secondary BILBY Award. In 2003 the book was listed on the BBCs The Big Read poll of the UKs 200 "best-loved novels."


----------
Also contained in:
[Flowers in the Attic / Petals on the Wind](https://openlibrary.org/works/OL16524231W)', 'romance', true);
INSERT INTO authors VALUES (DEFAULT, 'V. C.', 'Andrews', '6 June 1923', 229);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'Flowers in the Attic') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'V. C.' AND last_name = 'Andrews') AS a1;
INSERT INTO books VALUES (DEFAULT, 9781407224299, 'Der Vorleser', 'Hailed for its coiled eroticism and the moral claims it makes upon the reader, this mesmerizing novel is a story of love and secrets, horror and compassion, unfolding against the haunted landscape of postwar Germany.When he falls ill on his way home from school, fifteen-year-old Michael Berg is rescued by Hanna, a woman twice his age. In time she becomes his lover--then she inexplicably disappears. When Michael next sees her, he is a young law student, and she is on trial for a hideous crime. As he watches her refuse to defend her innocence, Michael gradually realizes that Hanna may be guarding a secret she considers more shameful than murder.', 'romance', true);
INSERT INTO authors VALUES (DEFAULT, 'Bernhard', 'Schlink', '6 July 1944', 63);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'Der Vorleser') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Bernhard' AND last_name = 'Schlink') AS a1;
INSERT INTO books VALUES (DEFAULT, 9781096931553, 'The Custom of the Country', 'Edith Whartons satiric anatomy of American society in the first decade of the twentieth century appeared in 1913; it both appalled and fascinated its first reviewers, and established her as a major novelist. It follows the career of Undine Spragg, recently arrived in New York from the Midwest and determined to conquer high society. Glamorous, selfish, mercenary, and manipulative, her principal assets are her striking beauty, her tenacity, and her fathers money. With her sights set on an advantageous marriage, Undine pursues her schemes in a world of shifting values, where triumph is swiftly followed by disillusion. Wharton was re-creating an environment she knew intimately, and Undines education for social success is chronicled in meticulous detail. The novel superbly captures the world of post-Civil War Ameria, as ruthless in its social ambitions as in its business and politics. - Back cover.', 'romance', true);
INSERT INTO authors VALUES (DEFAULT, 'Edith', 'Wharton', '24 January 1862', 1091);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'The Custom of the Country') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Edith' AND last_name = 'Wharton') AS a1;
INSERT INTO books VALUES (DEFAULT, 9789053335567, 'The God of Small Things', 'The God of Small Things is the debut novel of Indian writer Arundhati Roy. It is a story about the childhood experiences of fraternal twins whose lives are destroyed by the "Love Laws" that lay down "who should be loved, and how. And how much." The book explores how the small things affect peoples behavior and their lives. The book also reflects its irony against casteism, which is a major discrimination that prevails in India. It won the Booker Prize in 1997.', 'romance', true);
INSERT INTO authors VALUES (DEFAULT, 'Roy,', 'Arundhati.', '24 November 1961', 84);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'The God of Small Things') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Roy,' AND last_name = 'Arundhati.') AS a1;
INSERT INTO books VALUES (DEFAULT, 9785170357086, 'Night Over Water', 'On a bright September morning in 1939, two days after Britain declares war on Germany, a group of privileged but desperate people gather in Southhampton to board the largest, most luxurious airliner ever built, the Pan American Clipper bound for New York.', 'romance', true);
INSERT INTO authors VALUES (DEFAULT, 'Ken', 'Follett', '5 June 1949', 105);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'Night Over Water') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Ken' AND last_name = 'Follett') AS a1;
INSERT INTO books VALUES (DEFAULT, 9788418327537, 'Americanah', 'Americanah is a 2013 novel by the Nigerian author Chimamanda Ngozi Adichie, for which Adichie won the 2013 U.S. National Book Critics Circle Award for fiction. Americanah tells the story of a young Nigerian woman, Ifemelu, who immigrates to the United States to attend university. The novel traces Ifemelus life in both countries, threaded by her love story with high school classmate Obinze.', 'romance', true);
INSERT INTO authors VALUES (DEFAULT, 'Chimamanda Ngozi', 'Adichie', '1977', 44);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'Americanah') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Chimamanda Ngozi' AND last_name = 'Adichie') AS a1;
INSERT INTO books VALUES (DEFAULT, 9788433915955, 'Seta', 'France, 1861. When an epidemic threatens to wipe out the silk trade in France, silkworm breeder Herve Joncour has to travel overland to distant Japan, out of bounds to foreigners, to smuggle out healthy silkworms. In the course of his secret negotiations with the local baron, Joncours attention is arrested by the mans concubine, a girl who does not have oriental eyes. Although they are unable to exchange so much as a word, love blossoms between them.', 'romance', true);
INSERT INTO authors VALUES (DEFAULT, 'Alessandro', 'Baricco', '1958', 75);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'Seta') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Alessandro' AND last_name = 'Baricco') AS a1;
INSERT INTO books VALUES (DEFAULT, 9780751547498, 'The Notebook', 'A man with a faded, well-worn notebook open in his lap. A woman experiencing a morning ritual she doesnt understand. Until he begins to read to her. An achingly tender story about the enduring power of love.

A man with a faded, well-worn notebook open in his lap. A woman experiencing a morning ritual she doesnt understand. Until he begins to read to her. The Notebook is an achingly tender story about the enduring power of love, a story of miracles that will stay with you forever.

Set amid the austere beauty of coastal North Carolina in 1946, The Notebook begins with the story of Noah Calhoun, a rural Southerner returned home from World War II. Noah, thirty-one, is restoring a plantation home to its former glory, and he is haunted by images of the beautiful girl he met fourteen years earlier, a girl he loved like no other. Unable to find her, yet unwilling to forget the summer they spent together, Noah is content to live with only memories...until she unexpectedly returns to his town to see him once again.

Allie Nelson, twenty-nine, is now engaged to another man, but realizes that the original passion she felt for Noah has not dimmed with the passage of time. Still, the obstacles that once ended their previous relationship remain, and the gulf between their worlds is too vast to ignore. With her impending marriage only weeks away, Allie is forced to confront her hopes and dreams for the future, a future that only she can shape.

Like a puzzle within a puzzle, the story of Noah and Allie is just the beginning. As it unfolds, their tale miraculously becomes something different, with much higher stakes. The result is a deeply moving portrait of love itself, the tender moments and the fundamental changes that affect us all. Shining with a beauty that is rarely found in current literature, The Notebook establishes Nicholas Sparks as a classic storyteller with a unique insight into the only emotion that really matters.

"I am nothing special, of this I am sure. I am a common man with common thoughts and Ive led a common life. There are no monuments dedicated to me and my name will soon be forgotten, but Ive loved another with all my heart and soul, and to me, this has always been enough."

And so begins one of the most poignant and compelling love stories you will ever read...The Notebook', 'romance', true);
INSERT INTO authors VALUES (DEFAULT, 'Nicholas', 'Sparks', '31 December 1965', 384);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'The Notebook') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Nicholas' AND last_name = 'Sparks') AS a1;
INSERT INTO books VALUES (DEFAULT, 9780786022625, 'Riders of the Purple Sage', 'Riders of the Purple Sage is a novel that tells the story of a woman by the name of Jane Withersteen and her battle to overcome persecution by members of  her polygamous Mormon fundamentalist church. A leader of the church, Elder Tull, wants to marry her, but she has evaded him for years. Things get complicated when Bern Venters and Lassiter, a famous gunman and killer of Mormons help her look after her cattle and horses. She is blinded by her faith to see that her church men are the ones harming her. But when her adopted child disappears... she abandons her beliefs and discovers her true love. The plot deepens and it involves a horse race and a decision to whether to roll a large stone that forever closes off the only way in or out of her hiding place. A second plot involves a innocent girl Bern Venters accidentally shot…or is she innocent?! The lives of all these people intertwine ….past…present and future! Preceded by Zane Greys book: The Heritage of the West and Followed by Zane Greys book: The Rainbow Trail', 'romance', true);
INSERT INTO authors VALUES (DEFAULT, 'Zane', 'Grey', '31 January 1872', 1787);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'Riders of the Purple Sage') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Zane' AND last_name = 'Grey') AS a1;
INSERT INTO books VALUES (DEFAULT, 9780965739221, 'Oryx and Crake', 'Oryx and Crake is at once an unforgettable love story and a compelling vision of the future. Snowman, known as Jimmy before mankind was overwhelmed by a plague, is struggling to survive in a world where he may be the last human, and mourning the loss of his best friend, Crake, and the beautiful and elusive Oryx whom they both loved. In search of answers, Snowman embarks on a journey–with the help of the green-eyed Children of Crake–through the lush wilderness that was so recently a great city, until powerful corporations took mankind on an uncontrolled genetic engineering ride. Margaret Atwood projects us into a near future that is both all too familiar and beyond our imagining.', 'romance', true);
INSERT INTO authors VALUES (DEFAULT, 'Margaret Eleanor', 'Atwood', '18 November 1939', 411);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'Oryx and Crake') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Margaret Eleanor' AND last_name = 'Atwood') AS a1;
INSERT INTO books VALUES (DEFAULT, 9781870587174, 'The Dukes Children', '*The Palliser Novels*, book 6: *The Dukes Children*

Plantagenet Palliser, the Duke of Omnium and former Prime Minister of England, is widowed and wracked by grief. Struggling to adapt to life without his beloved Lady Glencora, he works hard to guide and support his three adult children. Palliser soon discovers, however, that his own plans for them are very different from their desires. Sent down from university in disgrace, his two sons quickly begin to run up gambling debts. His only daughter, meanwhile, longs passionately to marry the poor son of a county squire against her fathers will. But while the Dukes dearest wishes for the three are thwarted one by one, he ultimately comes to understand that parents can learn from their own children. The final volume in the Palliser novels, *The Dukes Children* (1880) is a compelling exploration of wealth, pride and ultimately the strength of love.', 'romance', true);
INSERT INTO authors VALUES (DEFAULT, 'Trollope,', 'Anthony', '1815', 0);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'The Dukes Children') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Trollope,' AND last_name = 'Anthony') AS a1;
INSERT INTO books VALUES (DEFAULT, 9789044924374, 'Lie Down With Lions', 'Ellis, the American. Jean-Pierre, the Frenchman. They were two men on opposite sides of the cold war, with a woman torn between them. Together, they formed a triangle of passion and deception, racing from terrorist bombs in Paris to the violence and intrigue of Afghanistan - to the moment of truth and deadly decision for all of them...

The intrigue surrounding Russian efforts to assassinate Masud, the leader of the Afghan guerrilla forces battling the Russians, sweeps a young Englishwoman, a French physician, and a roving American into its maelstrom', 'romance', true);
INSERT INTO authors VALUES (DEFAULT, 'Ken', 'Follett', '5 June 1949', 105);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'Lie Down With Lions') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Ken' AND last_name = 'Follett') AS a1;
INSERT INTO books VALUES (DEFAULT, 9798493105944, 'Frankenstein; or, The Modern Prometheus', '*Frankenstein; or, The Modern Prometheus* is an 1818 novel written by English author Mary Shelley. Frankenstein tells the story of Victor Frankenstein, a young scientist who creates a sapient creature in an unorthodox scientific experiment. Shelley started writing the story when she was 18, and the first edition was published anonymously in London on 1 January 1818, when she was 20. Her name first appeared in the second edition, which was published in Paris in 1821.', 'science fiction', true);
INSERT INTO authors VALUES (DEFAULT, 'Mary Wollstonecraft', 'Shelley', '30 August 1797', 468);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'Frankenstein; or, The Modern Prometheus') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Mary Wollstonecraft' AND last_name = 'Shelley') AS a1;
INSERT INTO books VALUES (DEFAULT, 9781543122183, 'The Time Machine', 'The Time Traveller, a dreamer obsessed with traveling through time, builds himself a time machine and, much to his surprise, travels over 800,000 years into the future. He lands in the year 802701: the world has been transformed by a society living in apparent harmony and bliss, but as the Traveler stays in the future he discovers a hidden barbaric and depraved subterranean class. Wellss transparent commentary on the capitalist society was an instant bestseller and launched the time-travel genre.', 'science fiction', true);
INSERT INTO authors VALUES (DEFAULT, 'H. G.', 'Wells', '21 September 1866', 4555);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'The Time Machine') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'H. G.' AND last_name = 'Wells') AS a1;
INSERT INTO books VALUES (DEFAULT, 9781522018575, 'The Lost World', 'Journalist Ed Malone is looking for an adventure, and thats exactly what he finds when he meets the eccentric Professor Challenger - an adventure that leads Malone and his three companions deep into the Amazon jungle, to a lost world where dinosaurs roam free.', 'science fiction', true);
INSERT INTO authors VALUES (DEFAULT, 'Doyle, Arthur', 'Conan', '1859', 1);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'The Lost World') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Doyle, Arthur' AND last_name = 'Conan') AS a1;
INSERT INTO books VALUES (DEFAULT, 9798744519681, 'The Iron Heel', 'https://en.wikipedia.org/wiki/The_Iron_Heel', 'science fiction', true);
INSERT INTO authors VALUES (DEFAULT, 'Jack', 'London', '12 January 1876', 2733);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'The Iron Heel') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Jack' AND last_name = 'London') AS a1;
INSERT INTO books VALUES (DEFAULT, 9798515519834, 'Flatland', 'Flatland: A Romance of Many Dimensions, though written in 1884, is still considered useful in thinking about multiple dimensions. It is also seen as a satirical depiction of Victorian society and its hierarchies. A square, who is a resident of the two-dimensional Flatland, dreams of the one-dimensional Lineland. He attempts to convince the monarch of Lineland of the possibility of another dimension, but the monarch cannot see outside the line. The square is then visited himself by a Sphere from three-dimensional Spaceland, who must show the square Spaceland before he can conceive it. As more dimensions enter the scene, the storys discussion of fixed thought and the kind of inhuman action which accompanies it intensifies.', 'science fiction', true);
INSERT INTO authors VALUES (DEFAULT, 'Edwin Abbott', 'Abbott', '20 Dec 1838', 110);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'Flatland') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Edwin Abbott' AND last_name = 'Abbott') AS a1;
INSERT INTO books VALUES (DEFAULT, 9783596200269, 'Brave New World', 'Originally published in 1932, this outstanding work of literature is more crucial and relevant today than ever before. Cloning, feel-good drugs, antiaging programs, and total social control through politics, programming, and media -- has Aldous Huxley accurately predicted our future? With a storytellers genius, he weaves these ethical controversies in a compelling narrative that dawns in the year 632 AF (After Ford, the deity). When Lenina and Bernard visit a savage reservation, we experience how Utopia can destroy humanity. A powerful work of speculative fiction that has enthralled and terrified readers for generations, Brave New World is both a warning to be heeded and thought-provoking yet satisfying entertainment. - Container.', 'science fiction', true);
INSERT INTO authors VALUES (DEFAULT, 'Aldous', 'Huxley', '26 July 1894', 798);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'Brave New World') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Aldous' AND last_name = 'Huxley') AS a1;
INSERT INTO books VALUES (DEFAULT, 9781548210823, 'The Secret Agent', '**The Secret Agent: A Simple Tale** is a novel by Joseph Conrad, first published in 1907. The story is set in London in 1886 and deals with Mr. Adolf Verloc and his work as a spy for an unnamed country (presumably Russia). The Secret Agent is one of Conrads later political novels in which he moved away from his former tales of seafaring. The novel is dedicated to H. G. Wells and deals broadly with anarchism, espionage, and terrorism. It also deals with exploitation of the vulnerable in Verlocs relationship with his brother-in-law Stevie, who has an intellectual disability. Conrad’s gloomy portrait of London depicted in the novel was influenced by Charles Dickens’ *Bleak House*.

(Source: [Wikipedia](https://en.wikipedia.org/wiki/The_Secret_Agent))', 'science fiction', true);
INSERT INTO authors VALUES (DEFAULT, 'Conrad,', 'Joseph', '3 December 1857', 10);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'The Secret Agent') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Conrad,' AND last_name = 'Joseph') AS a1;
INSERT INTO books VALUES (DEFAULT, 9798459325263, 'The Island of Dr. Moreau', 'See work: https://openlibrary.org/works/OL15308975W', 'science fiction', true);
INSERT INTO authors VALUES (DEFAULT, 'H. G.', 'Wells', '21 September 1866', 4555);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'The Island of Dr. Moreau') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'H. G.' AND last_name = 'Wells') AS a1;
INSERT INTO books VALUES (DEFAULT, 9798819971550, 'The Napoleon of Notting Hill', 'A witty and surreal novel of the future.

In a rather dull stuck-in-a-rut future, a prankster chosen randomly to be King of England revives the old ways and inadvertently arouses romantic patriotism and civil war between the boroughs of London.', 'science fiction', true);
INSERT INTO authors VALUES (DEFAULT, 'Chesterton, G.', 'K.', '29 May 1874', 2);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'The Napoleon of Notting Hill') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Chesterton, G.' AND last_name = 'K.') AS a1;
INSERT INTO books VALUES (DEFAULT, 9781521899359, 'When the Sleeper Awakes', 'A troubled insomniac in 1890s England falls suddenly into a sleep-like trance, from which he does not awake for over two hundred years. During his centuries of slumber, however, investments are made that make him the richest and most powerful man on Earth. But when he comes out of his trance he is horrified to discover that the money accumulated in his name is being used to maintain a hierarchal society in which most are poor, and more than a third of all people are enslaved. Oppressed and uneducated, the masses cling desperately to one dream – that the sleeper will awake, and lead them all to freedom.', 'science fiction', true);
INSERT INTO authors VALUES (DEFAULT, 'H. G.', 'Wells', '21 September 1866', 4555);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'When the Sleeper Awakes') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'H. G.' AND last_name = 'Wells') AS a1;
INSERT INTO books VALUES (DEFAULT, 9786257650762, 'In the days of the comet', 'H. G. Wells, in his 1906 In the Days of the Comet uses the vapors of a comet to trigger a deep and lasting change in humanitys perspective on themselves and the world. In the build-up to a great war, poor student William Leadford struggles against the harsh conditions the lower-class live under. He also falls in love with a middle-class girl named Nettie. But when he discovers that Nettie has eloped with a man of upper-class standing, William struggles with the betrayal, and in the disorder of his own mind decides to buy a revolver and kill them both. All through this a large comet lights the night sky with a green glow, bright enough that the street lamps are left unlit.', 'science fiction', true);
INSERT INTO authors VALUES (DEFAULT, 'H. G.', 'Wells', '21 September 1866', 4555);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'In the days of the comet') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'H. G.' AND last_name = 'Wells') AS a1;
INSERT INTO books VALUES (DEFAULT, 9788445013816, 'A Clockwork Orange', 'A Clockwork Orange is a dystopian satirical black comedy novel by English writer Anthony Burgess, published in 1962. It is set in a near-future society that has a youth subculture of extreme violence. The teenage protagonist, Alex, narrates his violent exploits and his experiences with state authorities intent on reforming him. The book is partially written in a Russian-influenced argot called "Nadsat", which takes its name from the Russian suffix that is equivalent to -teen in English. According to Burgess, it was a jeu desprit written in just three weeks.

In 2005, A Clockwork Orange was included on Time magazines list of the 100 best English-language novels written since 1923, and it was named by Modern Library and its readers as one of the 100 best English-language novels of the 20th century. The original manuscript of the book has been kept at McMaster Universitys William Ready Division of Archives and Research Collections in Hamilton, Ontario, Canada since the institution purchased the documents in 1971. It is considered one of the most influential dystopian books.

----------
Also contained in:

[A Clockwork Orange and Honey for the Bears](https://openlibrary.org/works/OL23787405W)
[A Clockwork Orange / The Wanting Seed](https://openlibrary.org/works/OL17306508W)', 'science fiction', true);
INSERT INTO authors VALUES (DEFAULT, 'Burgess,', 'Anthony', '25 February 1917', 153);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'A Clockwork Orange') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Burgess,' AND last_name = 'Anthony') AS a1;
INSERT INTO books VALUES (DEFAULT, 9780451155801, '2001', 'A novel that proposes an idea about how the human race might have begun and where it might be headed...given a little help from out there. A colaboration of ideas with director Stanley Kubrick in the late 1960s it begins at "the dawn of man" and then leaps to the year 2001 where a mission to Saturn (Jupiter in the film) is mounted to try and answer questions raised by the discovery of an ancient artifact dug up on the moon. Though not particularly fast paced, the science is good, and there are a few hair raising events. There are also interesting speculations about the future, such as the space shuttle, and a device eerily similar to an iPad. Leaving plenty of room for contemplation and the appreciation for the inevitable trials of space travel, this is one of the truly landmark pieces of hard science fiction.', 'science fiction', true);
INSERT INTO authors VALUES (DEFAULT, 'Arthur C.', 'Clarke', '16 December 1917', 743);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = '2001') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Arthur C.' AND last_name = 'Clarke') AS a1;
INSERT INTO books VALUES (DEFAULT, 9798575593997, 'The First Men in the Moon', 'When penniless businessman Mr Bedford retreats to the Kent coast to write a play, he meets by chance the brilliant Dr Cavor, an absent-minded scientist on the brink of developing a material that blocks gravity. Cavor soon succeeds in his experiments, only to tell a stunned Bedford the invention makes possible one of the oldest dreams of humanity: a journey to the moon. With Bedford motivated by money, and Cavor by the desire for knowledge, the two embark on the expedition. But neither are prepared for what they find - a world of freezing nights, boiling days and sinister alien life, on which they may be trapped forever.', 'science fiction', true);
INSERT INTO authors VALUES (DEFAULT, 'H. G.', 'Wells', '21 September 1866', 4555);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'The First Men in the Moon') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'H. G.' AND last_name = 'Wells') AS a1;
INSERT INTO books VALUES (DEFAULT, 9783125781535, 'The Hunger Games', 'The Hunger Games is a 2008 dystopian novel by the American writer Suzanne Collins. It is written in the perspective of 16-year-old Katniss Everdeen, who lives in the future, post-apocalyptic nation of Panem in North America. The Capitol, a highly advanced metropolis, exercises political control over the rest of the nation. The Hunger Games is an annual event in which one boy and one girl aged 12–18 from each of the twelve districts surrounding the Capitol are selected by lottery to compete in a televised battle royale to the death.

The book received critical acclaim from major reviewers and authors. It was praised for its plot and character development. In writing The Hunger Games, Collins drew upon Greek mythology, Roman gladiatorial games, and contemporary reality television for thematic content. The novel won many awards, including the California Young Reader Medal, and was named one of Publishers Weeklys "Best Books of the Year" in 2008.

The Hunger Games was first published in hardcover on September 14, 2008, by Scholastic, featuring a cover designed by Tim OBrien.', 'science fiction', true);
INSERT INTO authors VALUES (DEFAULT, 'Suzanne', 'Collins', '1962', 61);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'The Hunger Games') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Suzanne' AND last_name = 'Collins') AS a1;
INSERT INTO books VALUES (DEFAULT, 9798721858116, 'A Modern Utopia', 'Imagine a life without worries. You live in a perfect environment untouched by pollution. You have a job to do and play an important role in society. The politicians are watching out for your best interest. And, you get along with your neighbors. Wells’ utopia may not only be unattainable, it may be detrimental to humanity’s progress. Decide for yourself as you read this classic quest for social equality in the modern era.', 'science fiction', true);
INSERT INTO authors VALUES (DEFAULT, 'H. G.', 'Wells', '21 September 1866', 4555);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'A Modern Utopia') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'H. G.' AND last_name = 'Wells') AS a1;
INSERT INTO books VALUES (DEFAULT, 9780307291868, 'Contact', 'In December, 1999, a multinational team journeys out to the stars, to the most awesome encounter in human history. Who -- or what -- is out there?
In Cosmos, Carl Sagan explained the universe. In Contact, he predicts its future -- and our own.', 'science fiction', true);
INSERT INTO authors VALUES (DEFAULT, 'Carl', 'Sagan', '9 November 1934', 56);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'Contact') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Carl' AND last_name = 'Sagan') AS a1;
INSERT INTO books VALUES (DEFAULT, 9789731249759, 'Slaughterhouse-Five', 'Slaughterhouse-Five is one of the worlds great anti-war books. Centering on the infamous fire-bombing of Dresden, Billy Pilgrims odyssey through time reflects the mythic journey of our own fractured lives as we search for meaning in what we are afraid to know.', 'science fiction', true);
INSERT INTO authors VALUES (DEFAULT, 'Vonnegut,', 'Kurt.', '11 November 1922', 2);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'Slaughterhouse-Five') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Vonnegut,' AND last_name = 'Kurt.') AS a1;
INSERT INTO books VALUES (DEFAULT, 9789650722159, 'Do Androids Dream of Electric Sheep?', 'It was January 2021, and Rick Deckard had a license to kill.
Somewhere among the hordes of humans out there, lurked several rogue androids. Deckards assignment--find them and then..."retire" them. Trouble was, the androids all looked exactly like humans, and they didnt want to be found!', 'science fiction', true);
INSERT INTO authors VALUES (DEFAULT, 'Dick, Philip', 'K.', '16 December 1928', 488);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'Do Androids Dream of Electric Sheep?') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Dick, Philip' AND last_name = 'K.') AS a1;
INSERT INTO books VALUES (DEFAULT, 9788382025866, 'A Game of Thrones', 'A Game of Thrones is the first novel in A Song of Ice and Fire, a series of fantasy novels by the American author George R. R. Martin. It was first published on August 1, 1996. The novel won the 1997 Locus Award and was nominated for both the 1997 Nebula Award and the 1997 World Fantasy Award. The novella Blood of the Dragon, comprising the Daenerys Targaryen chapters from the novel, won the 1997 Hugo Award for Best Novella. In January 2011, the novel became a New York Times Bestseller and reached No. 1 on the list in July 2011.', 'science fiction', true);
INSERT INTO authors VALUES (DEFAULT, 'George R. R.', 'Martin', 'September 20, 1948', 439);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'A Game of Thrones') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'George R. R.' AND last_name = 'Martin') AS a1;
INSERT INTO books VALUES (DEFAULT, 9788484374633, 'The Blind Assassin', 'More than fifty years on, Iris Chase is remembering Lauras mysterious death. And so begins an extraordinary and compelling story of two sisters and their secrets. Set against a panoramic backdrop of twentieth-century history, The Blind Assassin is an epic tale of memory, intrigue and betrayal...', 'science fiction', true);
INSERT INTO authors VALUES (DEFAULT, 'Margaret Eleanor', 'Atwood', '18 November 1939', 411);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'The Blind Assassin') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Margaret Eleanor' AND last_name = 'Atwood') AS a1;
INSERT INTO books VALUES (DEFAULT, 9798672902401, 'Tales of space and time', 'Tales of Space and Time collects together two novellas and three short stories by the great science fiction writer H. G. Wells. First published in 1899, this absorbing and stimulating read contains:The Crystal Egg (short story)The Star (short story)A Story of the Stone Age (novella)A Story of the Days To Come" (novella)The Man Who Could Work Miracles (short story)', 'science fiction', true);
INSERT INTO authors VALUES (DEFAULT, 'H. G.', 'Wells', '21 September 1866', 4555);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'Tales of space and time') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'H. G.' AND last_name = 'Wells') AS a1;
INSERT INTO books VALUES (DEFAULT, 9783596905621, 'The Man in the High Castle', 'The Man in the High Castle is an alternate history novel by American writer Philip K. Dick. Published and set in 1962, the novel takes place fifteen years after an alternative ending to World War II, and concerns intrigues between the victorious Axis Powers—primarily, Imperial Japan and Nazi Germany—as they rule over the former United States, as well as daily life under the resulting totalitarian rule. The Man in the High Castle won the Hugo Award for Best Novel in 1963. Beginning in 2015, the book was adapted as a multi-season TV series, with Dicks daughter, Isa Dick Hackett, serving as one of the shows producers.

Reported inspirations include Ward Moores alternate Civil War history, Bring the Jubilee (1953), various classic World War II histories, and the I Ching (referred to in the novel). The novel features a "novel within the novel" comprising an alternate history within this alternate history wherein the Allies defeat the Axis (though in a manner distinct from the actual historical outcome).', 'science fiction', true);
INSERT INTO authors VALUES (DEFAULT, 'Dick, Philip', 'K.', '16 December 1928', 488);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'The Man in the High Castle') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Dick, Philip' AND last_name = 'K.') AS a1;
INSERT INTO books VALUES (DEFAULT, 9788499323091, 'Mockingjay', 'Against all odds, Katniss Everdeen has survived the Hunger Games twice. But now that shes made it out of the bloody arena alive, shes still not safe. The Capitol is angry. The Capitol wants revenge. Who do they think should pay for the unrest? Katniss. And whats worse, President Snow has made it clear that no one else is safe either. Not Katnisss family, not her friends, not the people of District 12. Powerful and haunting, this is the thrilling final installment of Suzanne Collinss groundbreaking Hunger Games trilogy. - Publisher.', 'science fiction', true);
INSERT INTO authors VALUES (DEFAULT, 'Suzanne', 'Collins', '1962', 61);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'Mockingjay') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Suzanne' AND last_name = 'Collins') AS a1;
INSERT INTO books VALUES (DEFAULT, 9781528771689, 'Wuthering Heights', 'Wuthering Heights is an 1847 novel by Emily Brontë, initially published under the pseudonym Ellis Bell. It concerns two families of the landed gentry living on the West Yorkshire moors, the Earnshaws and the Lintons, and their turbulent relationships with Earnshaws adopted son, Heathcliff. The novel was influenced by Romanticism and Gothic fiction.', 'women', true);
INSERT INTO authors VALUES (DEFAULT, 'Brontë,', 'Emily', '1818', 292);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'Wuthering Heights') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Brontë,' AND last_name = 'Emily') AS a1;
INSERT INTO books VALUES (DEFAULT, 9780141974217, 'The House of Mirth', 'Beautiful, intelligent, and hopelessly addicted to luxury, Lily Bart is the heroine of this Wharton masterpiece. But it is her very taste and moral sensibility that render her unfit for survival in this world.', 'women', true);
INSERT INTO authors VALUES (DEFAULT, 'Edith', 'Wharton', '24 January 1862', 1091);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'The House of Mirth') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Edith' AND last_name = 'Wharton') AS a1;
INSERT INTO books VALUES (DEFAULT, 9781686493928, 'Voyage Out', '“The Voyage Out” by Virginia Woolf.

This is a story about a young English woman, Rachel, on a sea voyage from London, to a South American   coastal city of Santa Marina. As I read the story,  the title of the story became  a metaphor for Rachels inner journey.
The inner journey within this story is perhaps best summarized in the authors words:
“The next few months passed away, as many years can pass away, without definite events, and yet, if suddenly disturbed, it would be seen that such months or years had a character unlike others.”
 Rachels mother has passed away many years ago. The sea voyage and the subsequent months in Santa Marina show that Rachel is also on an inner journey, to understand herself better.  She seeks advice from Helen, her aunt,  and Helen and Rachel become close friends.
“…................The vision of her own personality, of herself as a real everlasting thing, different from anything else, unmergeable, like the sea or the wind, flashed into Rachels mind, and she became profoundly excited at the thought of living...................”

Rachel falls in love with a young Englishman, Terence, in Santa Marina.  But tragically, she falls ill and dies.  Yet, in the brief time that Helen and Terence have known her, her journey has also made them reflect about their own lives.', 'women', true);
INSERT INTO authors VALUES (DEFAULT, 'Virginia', 'Woolf', '25 January 1882', 1094);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'Voyage Out') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Virginia' AND last_name = 'Woolf') AS a1;
INSERT INTO books VALUES (DEFAULT, 9781795245128, 'On Liberty', 'Book digitized by Google from the library of the New York Public Library and uploaded to the Internet Archive by user tpb.', 'women', false);
INSERT INTO authors VALUES (DEFAULT, 'John Stuart', 'Mill', '20 May 1806', 568);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'On Liberty') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'John Stuart' AND last_name = 'Mill') AS a1;
INSERT INTO books VALUES (DEFAULT, 9780713684070, 'Taming of the Shrew', 'This play within a play is a delightful farce about a fortune hunter who marries and tames" the town shrew. The comedy, often produced today because of its accessibility, is one of the plays Shakespeare intended for the general public rather than for the nobility.


CliffsComplete combines the full original text of The Taming of the Shrew with a helpful glossary and CliffsNotes-quality commentary into one volume. You will find:A unique pedagogical approach that combines the complete original text with expert commentary following each sceneA descriptive bibliography and historical background on the author, the times, and the work itselfAn improved character map that graphically illustrates the relationships among the charactersSidebar glossaries"', 'women', false);
INSERT INTO authors VALUES (DEFAULT, 'William', 'Shakespeare', '20 April 1564', 9649);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'Taming of the Shrew') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'William' AND last_name = 'Shakespeare') AS a1;
INSERT INTO books VALUES (DEFAULT, 9781411436718, 'The Rainbow', '(Brangwen Family #1)

Lush with imagery, this is the story of three generations of Brangwen women living during the decline of English rural life. Banned upon publication, it explores the most taboo subjects of its time: marriage, physical love, and one familys sexual mores.', 'women', true);
INSERT INTO authors VALUES (DEFAULT, 'Lawrence, D.', 'H.', '1885', 1);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'The Rainbow') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Lawrence, D.' AND last_name = 'H.') AS a1;
INSERT INTO books VALUES (DEFAULT, 9798469546283, 'Orlando', 'In her most exuberant, most fanciful novel, Woolf has created a character liberated from the restraints of time and sex. Born in the Elizabethan Age to wealth and position, Orlando is a young nobleman at the beginning of the story-and a modern woman three centuries later.', 'women', true);
INSERT INTO authors VALUES (DEFAULT, 'Virginia', 'Woolf', '25 January 1882', 1094);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'Orlando') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Virginia' AND last_name = 'Woolf') AS a1;
INSERT INTO books VALUES (DEFAULT, 9781080104598, 'The Awakening', 'The Awakening is a novel by Kate Chopin, first published in 1899. Set in New Orleans and on the Louisiana Gulf coast at the end of the 19th century, the plot centers on Edna Pontellier and her struggle between her increasingly unorthodox views on femininity and motherhood with the prevailing social attitudes of the turn-of-the-century American South. It is one of the earliest American novels that focuses on womens issues without condescension. It is also widely seen as a landmark work of early feminism, generating a mixed reaction from contemporary readers and critics.', 'women', true);
INSERT INTO authors VALUES (DEFAULT, 'Kate', 'Chopin', '1850', 390);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'The Awakening') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Kate' AND last_name = 'Chopin') AS a1;
INSERT INTO books VALUES (DEFAULT, 9783311220039, 'A Room of Ones Own', 'A Room of Ones Own is an extended essay by Virginia Woolf. First published on 24 October 1929, the essay was based on a series of lectures she delivered at Newnham College and Girton College, two womens colleges at Cambridge University in October 1928. While this extended essay in fact employs a fictional narrator and narrative to explore women both as writers of and characters in fiction, the manuscript for the delivery of the series of lectures, titled "Women and Fiction", and hence the essay, are considered non-fiction. The essay is generally seen as a feminist text, and is noted in its argument for both a literal and figural space for women writers within a literary tradition dominated by patriarchy.', 'women', false);
INSERT INTO authors VALUES (DEFAULT, 'Virginia', 'Woolf', '25 January 1882', 1094);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'A Room of Ones Own') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Virginia' AND last_name = 'Woolf') AS a1;
INSERT INTO books VALUES (DEFAULT, 9782846813785, 'Troilus and Cressida', 'With new editors who have incorporated the most up-to-date scholarship, this revised Pelican Shakespeare series will be the premiere choice for students, professors, and general readers well into the twenty-first century.Each volume features:* Authoritative, reliable texts* High quality introductions and notes* New, more readable trade trim size* An essay on the theatrical world of Shakespeare and essays on Shakespeares life and the selection of texts', 'women', true);
INSERT INTO authors VALUES (DEFAULT, 'William', 'Shakespeare', '20 April 1564', 9649);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'Troilus and Cressida') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'William' AND last_name = 'Shakespeare') AS a1;
INSERT INTO books VALUES (DEFAULT, 9781956221374, 'Rose in Bloom', 'In this sequel to Eight Cousins, Rose Campbell returns to the "Aunt Hill" after two years of traveling around the world. Suddenly, she is surrounded by male admirers, all expecting her to marry them. But before she marries anyone, Rose is determined to establish herself as an independent young woman. Besides, she suspects that some of her friends like her more for her money than for herself.', 'women', true);
INSERT INTO authors VALUES (DEFAULT, 'Louisa May', 'Alcott', '29 November 1832', 783);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'Rose in Bloom') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Louisa May' AND last_name = 'Alcott') AS a1;
INSERT INTO books VALUES (DEFAULT, 9781609772208, 'Vanity Fair', 'No one is better equipped in the struggle for wealth and worldly success than the alluring and ruthless Becky Sharp, who defies her impoverished background to clamber up the class ladder. Her sentimental companion Amelia, however, longs only for caddish soldier George. As the two heroines make their way through the tawdry glamour of Regency society, battles - military and domestic - are fought, fortunes made and lost. The one steadfast and honourable figure in this corrupt world is Dobbin with his devotion to Amelia, bringing pathos and depth to Thackerays gloriously satirical epic of love and social adventure.', 'women', true);
INSERT INTO authors VALUES (DEFAULT, 'Thackeray, William', 'Makepeace', '18 July 1811', 1);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'Vanity Fair') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Thackeray, William' AND last_name = 'Makepeace') AS a1;
INSERT INTO books VALUES (DEFAULT, 9798464079458, 'She', 'An enduring adventure yarn set in pre colonial Africa, culminating in the discovery of a lost civilization ruled by a beautiful eternally youthful queen. "She is generally considered to be one of the classics of imaginative literature and with 83 million copies sold by 1965, it is one of the best-selling books of all time." See more at: http://en.wikipedia.org/wiki/She_(novel)', 'women', true);
INSERT INTO authors VALUES (DEFAULT, 'H. Rider', 'Haggard', '1856', 3386);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'She') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'H. Rider' AND last_name = 'Haggard') AS a1;
INSERT INTO books VALUES (DEFAULT, 9781784878672, 'Beloved', 'Toni Morrison--author of Song of Solomon and Tar Baby--is a writer of remarkable powers: her novels, brilliantly acclaimed for their passion, their dazzling language and their lyric and emotional force, combine the unassailable truths of experience and emotion with the vision of legend and imagination. It is the story--set in post-Civil War Ohio--of Sethe, an escaped slave who has risked death in order to wrench herself from a living death; who has lost a husband and buried a child; who has borne the unthinkable and not gone mad: a woman of "iron eyes and backbone to match." Sethe lives in a small house on the edge of town with her daughter, Denver, her mother-in-law, Baby Suggs, and a disturbing, mesmerizing intruder who calls herself Beloved. Sethe works at "beating back the past," but it is alive in all of them. It keeps Denver fearful of straying from the house. It fuels the sadness that has settled into Baby Suggs "desolated center where the self that was no self made its home." And to Sethe, the past makes itself heard and felt incessantly: in memories that both haunt and soothe her...in the arrival of Paul D ("There was something blessed in his manner. Women saw him and wanted to weep"), one of her fellow slaves on the farm where she had once been kept...in the vivid and painfully cathartic stories she and Paul D tell each other of their years in captivity, of their glimpses of freedom...and, most powerfully, in the apparition of Beloved, whose eyes are expressionless at their deepest point, whose doomed childhood belongs to the hideous logic of slavery and who, as daughter, sister and seductress, has now come from the "place over there" to claim retribution for what she lost and for what was taken from her. Sethes struggle to keep Beloved from gaining full possession of her present--and to throw off the long, dark legacy of her past--is at the center of this profoundly affecting and startling novel. But its intensity and resonance of feeling, and the boldness of its narrative, lift it beyond its particulars so that it speaks to our experience as an entire nation with a past of both abominable and ennobling circumstance. In Beloved, Toni Morrison has given us a great American novel. Toni Morrison was awarded the 1988 Pulitzer Prize in Literature for Beloved.', 'women', true);
INSERT INTO authors VALUES (DEFAULT, 'Toni', 'Morrison', '18 February 1931', 122);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'Beloved') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Toni' AND last_name = 'Morrison') AS a1;
INSERT INTO books VALUES (DEFAULT, 9789027425133, 'The Mammoth Hunters', 'Once again Jean M. Auel opens the door of a time long past to reveal an age of wonder and danger at the dawn of the modern human race. With all the consummate storytelling artistry and vivid authenticity she brought to The Clan of the Cave Bear and its sequel, The Valley of Horses, Jean M. Auel continues the breathtaking epic journey of the woman called Ayla.

Riding Whinney with Jondalar, the man she loves, and followed by the mare’s colt, Ayla ventures into the land of the Mamutoi--the Mammoth Hunters. She has finally found the Others she has been seeking. Though Ayla must learn their different customs and language, she is adopted because of her remarkable hunting ability, singular healing skills, and uncanny fire-making technique. Bringing back the single pup of a lone wolf she has killed, Ayla shows the way she tames animals. She finds women friends and painful memories of the Clan she left behind, and meets Ranec, the dark-skinned, magnetic master carver of ivory, whom she cannot refuse--inciting Jondalar to a fierce jealousy that he tries to control by avoiding her. Unfamiliar with the ways of the Others, Ayla misunderstands, and thinking Jondalar no longer loves her, she turns more to Ranec. Throughout the icy winter the tension mounts, but warming weather will bring the great mammoth hunt and the mating rituals of the Summer Meeting, when Ayla must choose to remain with Ranec and the Mamutoi, or to follow Jondalar on a long journey into an unknown future.', 'women', true);
INSERT INTO authors VALUES (DEFAULT, 'Untinen Auel, Jean', 'Marie', '18 February 1936', 54);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'The Mammoth Hunters') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Untinen Auel, Jean' AND last_name = 'Marie') AS a1;
INSERT INTO books VALUES (DEFAULT, 9781628342383, 'Work', 'In this story of a womans search for a meaningful life, Alcott moves outside the family setting of her best knows works. Originally published in 1872, Work is both an exploration of Alcotts personal conflicts and a social critique, examining womens independence, the moral significance of labor, and the goals to which a woman can aspire. Influenced by Transcendentalism and by the womens rights movement, it affirms the possibility of a feminized utopian society.', 'women', true);
INSERT INTO authors VALUES (DEFAULT, 'Louisa May', 'Alcott', '29 November 1832', 783);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'Work') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Louisa May' AND last_name = 'Alcott') AS a1;
INSERT INTO books VALUES (DEFAULT, 9782818704097, 'Bridget Joness Diary', 'Bridget Joness Diary is a 1996 novel by Helen Fielding. Written in the form of a personal diary, the novel chronicles a year in the life of Bridget Jones, a thirty-something single working woman living in London. She writes about her career, self-image, vices, family, friends, and romantic relationships.


----------
Also contained in:
[Novels (Bridget Joness Diary / Bridget Jones - The Edge of Reason)](https://openlibrary.org/works/OL17546573W)', 'women', true);
INSERT INTO authors VALUES (DEFAULT, 'Helen', 'Fielding', '19 Feb 1958', 27);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'Bridget Joness Diary') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Helen' AND last_name = 'Fielding') AS a1;
INSERT INTO books VALUES (DEFAULT, 9798429685045, 'Whats wrong with the world', 'I originally called this book "What is Wrong," and it would have satisfied your sardonic temper to note the number of social misunderstandings that arose from the use of the title. Many a mild lady visitor opened her eyes when I remarked casually, I have been doing What is Wrong all this morning. And one minister of religion moved quite sharply in his chair when I told him (as he understood it) that I had to run upstairs and do what was wrong, but should be down again in a minute.', 'women', true);
INSERT INTO authors VALUES (DEFAULT, 'Chesterton, G.', 'K.', '29 May 1874', 2);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'Whats wrong with the world') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Chesterton, G.' AND last_name = 'K.') AS a1;
INSERT INTO books VALUES (DEFAULT, 9781492372158, 'La tía Tula', 'Esta novela narra la vida de Gertrudis, también llamada la Tía Tula, y los sacrificios que realiza durante su vida para satisfacer sus ansias de maternidad. Una de las novelas más conocidas de Unamuno, comparte con otras de sus obras el estilo y las preocupaciones habituales del autor, aunque incluye como factor diferencial un erotismo sutil. La trama de la novela se sustenta en la práctica antropológica del levirato y el sororato en un contexto de represión sexual. Tiene como tema principal el amor maternal.', 'women', true);
INSERT INTO authors VALUES (DEFAULT, 'Miguel de', 'Unamuno', '1864', 258);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'La tía Tula') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Miguel de' AND last_name = 'Unamuno') AS a1;
INSERT INTO books VALUES (DEFAULT, 9780606237796, 'A Streetcar Named Desire', 'A Streetcar Named Desire is one of the most remarkable plays of our time. It created an immortal woman in the character of Blanche DuBois, the haggard and fragile southern beauty whose pathetic last grasp at happiness is cruelly destroyed. It shot Marlon Brando to fame in the role of Stanley Kowalski, a sweat-shirted barbarian, the crudely sensual brother-in-law who precipitated Blances tragedy.

Produced across the world and translated into many languages, A Streetcar Named Desire has won one of the widest audiences in contemporary literature.

Also contained in:
 - [New Voices in the American Theatre](https://openlibrary.org/works/OL15163013W/New_Voices_in_the_American_Theatre)
 - [Plays 1937 - 1955](https://openlibrary.org/works/OL15077942W/Plays_1937_-_1955)', 'women', false);
INSERT INTO authors VALUES (DEFAULT, 'Williams,', 'Tennessee', '26 March 1911', 206);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'A Streetcar Named Desire') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Williams,' AND last_name = 'Tennessee') AS a1;
INSERT INTO books VALUES (DEFAULT, 9780063049659, 'Retrato en sepia', 'Una obra de extraordinaria dimension humana que eleva la narrativa de la autora a cotas de perfeccion literariaNarrada en la voz de una joven mujer, esta es una magnifica novela historica, situada a finales del siglo XIX en Chile, y una portentosa saga familiar en la que reencontramos algunos personajes de Hija de la fortun a y de La casa de los espiritus, novelas cumbre en la obra de Isabel Allende. El tema principal es la memoria y los secretos de familia. La protagonista, Aurora del Valle, sufre un trauma brutal que determina su caracter y borra de su mente los primeros cinco años de su vida. Criada por su ambiciosa abuela, Paulina del Valle, crece en un ambiente privilegiado, libre de muchas de las limitaciones que oprimen a las mujeres de su epoca, pero atormentada por horribles pesadillas. Cuando debe afrontar la traicion del hombre que ama y la soledad, decide explorar el misterio de su pasado. Una obra de extraordinaria dimension humana que eleva la narrativa de la autora a cotas de perfeccion literaria.', 'women', true);
INSERT INTO authors VALUES (DEFAULT, 'Isabel', 'Allende', '2 August 1942', 64);
INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = 'Retrato en sepia') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = 'Isabel' AND last_name = 'Allende') AS a1;

-----------------------------------------------------------------------------------------------

INSERT INTO reviews VALUES (1, 127, 5, 'The world felt so real, I could almost touch it.');
INSERT INTO reviews VALUES (2, 204, 4, 'A story that will linger in your thoughts. A reflective 4.');
INSERT INTO reviews VALUES (1, 199, 2, 'The pacing was off.');
INSERT INTO reviews VALUES (1, 51, 2, 'The story lacked depth.');
INSERT INTO reviews VALUES (0, 14, 2, 'The pacing was off.');
INSERT INTO reviews VALUES (2, 97, 4, 'The dialogue was sharp, but the ending was a bit abrupt. 4.');
INSERT INTO reviews VALUES (3, 206, 5, 'Couldn''t put it down.');
INSERT INTO reviews VALUES (3, 209, 2, 'The characters were one-dimensional. 2.');
INSERT INTO reviews VALUES (2, 82, 4, 'A unique blend of genres.');
INSERT INTO reviews VALUES (2, 88, 2, 'I found it hard to connect with the protagonist.');
INSERT INTO reviews VALUES (0, 10, 1, 'A letdown from beginning to end.');
INSERT INTO reviews VALUES (3, 12, 1, 'A struggle to get through.');
INSERT INTO reviews VALUES (0, 31, 4, 'A roller-coaster of emotions from start to finish!');
INSERT INTO reviews VALUES (2, 94, 2, 'Didn''t live up to my expectations.');
INSERT INTO reviews VALUES (0, 177, 4, 'A wild ride with unexpected twists.');
INSERT INTO reviews VALUES (1, 134, 4, 'A journey of self-discovery that touched my heart. A moving 4.');
INSERT INTO reviews VALUES (0, 156, 4, 'A roller-coaster of emotions from start to finish!');
INSERT INTO reviews VALUES (2, 119, 2, 'The characters were one-dimensional. 2.');
INSERT INTO reviews VALUES (2, 110, 4, 'The dialogue was sharp, but the ending was a bit abrupt. 4.');
INSERT INTO reviews VALUES (1, 106, 4, 'A wild ride from start to finish! A solid 4.');
INSERT INTO reviews VALUES (2, 51, 4, 'An intellectually stimulating read. A solid 4.');
INSERT INTO reviews VALUES (0, 141, 4, 'An engaging read with a surprising twist at the end.');
INSERT INTO reviews VALUES (1, 65, 2, 'The pacing was off.');
INSERT INTO reviews VALUES (1, 177, 2, 'A forgettable read.');
INSERT INTO reviews VALUES (3, 1, 4, 'A roller-coaster of emotions from start to finish!');
INSERT INTO reviews VALUES (1, 103, 3, 'I had trouble getting into the story, but it picked up later.');
INSERT INTO reviews VALUES (2, 12, 5, 'The world felt so real, I could almost touch it.');
INSERT INTO reviews VALUES (0, 126, 1, 'A struggle to stay engaged. 1 star.');
INSERT INTO reviews VALUES (1, 2, 4, 'An emotional rollercoaster that left me in tears. A poignant 4.');
INSERT INTO reviews VALUES (0, 61, 2, 'Not my cup of tea. 2.');
INSERT INTO reviews VALUES (0, 155, 4, 'The imagery was vivid, but some scenes felt rushed. 4.');
INSERT INTO reviews VALUES (0, 130, 4, 'A thought-provoking exploration of human nature.');
INSERT INTO reviews VALUES (3, 136, 3, 'The prose was exquisite, but the plot lacked depth.');
INSERT INTO reviews VALUES (2, 54, 3, 'A bit too predictable for my taste.');
INSERT INTO reviews VALUES (3, 131, 3, 'Too many loose ends.');
INSERT INTO reviews VALUES (1, 48, 2, 'A forgettable read.');
INSERT INTO reviews VALUES (0, 85, 5, 'An intricate plot with unexpected twists. A thrilling 5!');
INSERT INTO reviews VALUES (0, 171, 5, 'A story that will stay with me forever. A powerful 5!');
INSERT INTO reviews VALUES (2, 68, 2, 'Not my cup of tea. 2.');
INSERT INTO reviews VALUES (0, 15, 4, 'A roller-coaster of emotions.');
INSERT INTO reviews VALUES (2, 191, 1, 'A struggle to get through.');
INSERT INTO reviews VALUES (2, 8, 5, 'This book changed my perspective on life. A powerful 5!');
INSERT INTO reviews VALUES (2, 164, 2, 'Lacks depth and originality. 2.');
INSERT INTO reviews VALUES (3, 96, 3, 'The pacing was a bit slow for my taste, but the prose was elegant.');
INSERT INTO reviews VALUES (2, 15, 4, 'A wild ride with unexpected twists.');
INSERT INTO reviews VALUES (1, 62, 4, 'The characters were relatable, but the pacing dragged in parts.');
INSERT INTO reviews VALUES (0, 22, 2, 'Not my cup of tea. 2.');
INSERT INTO reviews VALUES (3, 27, 2, 'I found it hard to connect with the protagonist.');
INSERT INTO reviews VALUES (1, 20, 4, 'The characters were relatable, but the pacing dragged in parts.');
INSERT INTO reviews VALUES (0, 165, 2, 'The dialogue felt forced.');
INSERT INTO reviews VALUES (1, 93, 2, 'This book was not what I expected. Disappointing.');
INSERT INTO reviews VALUES (0, 79, 5, 'Unforgettable characters.');
INSERT INTO reviews VALUES (3, 92, 3, 'I had trouble getting into the story, but it picked up later.');
INSERT INTO reviews VALUES (1, 149, 2, 'I expected better. 2.');
INSERT INTO reviews VALUES (0, 127, 3, 'The world-building was on point, but the ending left me wanting more.');
INSERT INTO reviews VALUES (2, 144, 2, 'I found it hard to connect with the protagonist.');
INSERT INTO reviews VALUES (2, 114, 2, 'Boring and predictable.');
INSERT INTO reviews VALUES (3, 146, 4, 'The imagery was vivid, but some scenes felt rushed. 4.');
INSERT INTO reviews VALUES (2, 11, 3, 'The world-building was on point, but the ending left me wanting more.');
INSERT INTO reviews VALUES (2, 80, 2, 'This book was not what I expected. Disappointing.');
INSERT INTO reviews VALUES (2, 52, 2, 'Didn''t live up to my expectations.');
INSERT INTO reviews VALUES (0, 55, 4, 'An emotional rollercoaster that left me in tears. A poignant 4.');
INSERT INTO reviews VALUES (3, 142, 2, 'This book was not what I expected. Disappointing.');
INSERT INTO reviews VALUES (2, 50, 3, 'Beautiful prose, weak storyline.');
INSERT INTO reviews VALUES (1, 19, 2, 'Couldn''t connect with the protagonist.');
INSERT INTO reviews VALUES (1, 173, 4, 'The dialogue was sharp, but the ending was a bit abrupt. 4.');
INSERT INTO reviews VALUES (3, 139, 4, 'An emotional rollercoaster that left me in tears. A poignant 4.');
INSERT INTO reviews VALUES (2, 34, 2, 'I couldn''t connect with the story.');
INSERT INTO reviews VALUES (2, 129, 5, 'Couldn''t put it down.');
INSERT INTO reviews VALUES (0, 135, 1, 'A letdown. 1 star.');
INSERT INTO reviews VALUES (0, 201, 2, 'The writing didn''t engage me.');
INSERT INTO reviews VALUES (0, 119, 1, 'Lacked originality and creativity. 1 star.');
INSERT INTO reviews VALUES (1, 16, 2, 'Disappointing ending.');
INSERT INTO reviews VALUES (1, 74, 2, 'The plot was unconvincing. 2.');
INSERT INTO reviews VALUES (3, 108, 4, 'A poignant exploration of the human condition. A solid 4.');
INSERT INTO reviews VALUES (2, 24, 3, 'Engaging characters, but a weak plot.');
INSERT INTO reviews VALUES (3, 188, 3, 'The world-building was on point, but the ending left me wanting more.');
INSERT INTO reviews VALUES (1, 135, 3, 'The dialogue felt a bit forced, but the setting was vividly portrayed.');
INSERT INTO reviews VALUES (3, 101, 2, 'The plot was unconvincing. 2.');
INSERT INTO reviews VALUES (3, 147, 5, 'The world felt so real, I could almost touch it.');
INSERT INTO reviews VALUES (0, 136, 3, 'I couldn''t connect with the characters, but the world-building was exceptional.');
INSERT INTO reviews VALUES (1, 39, 2, 'This book was not what I expected. Disappointing.');
INSERT INTO reviews VALUES (3, 128, 3, 'The pacing was a bit slow for my taste, but the prose was elegant.');
INSERT INTO reviews VALUES (3, 52, 2, 'I found it hard to connect with the protagonist.');
INSERT INTO reviews VALUES (1, 140, 4, 'A complex and intricate world.');
INSERT INTO reviews VALUES (3, 114, 1, 'I couldn''t get into it.');
INSERT INTO reviews VALUES (3, 204, 3, 'Beautiful prose, weak storyline.');
INSERT INTO reviews VALUES (0, 182, 5, 'A story that will stay with me forever. A powerful 5!');
INSERT INTO reviews VALUES (0, 183, 3, 'The prose was exquisite, but the plot lacked depth.');
INSERT INTO reviews VALUES (0, 203, 2, 'Boring and predictable.');
INSERT INTO reviews VALUES (2, 167, 5, 'The author''s descriptive style painted vivid pictures in my mind.');
INSERT INTO reviews VALUES (2, 171, 3, 'I couldn''t connect with the characters, but the world-building was exceptional.');
INSERT INTO reviews VALUES (0, 142, 1, 'A struggle to get through.');
INSERT INTO reviews VALUES (2, 45, 2, 'The dialogue felt forced.');
INSERT INTO reviews VALUES (2, 198, 4, 'A roller-coaster of emotions.');
INSERT INTO reviews VALUES (3, 79, 3, 'The world-building was on point, but the ending left me wanting more.');
INSERT INTO reviews VALUES (2, 32, 2, 'Unmemorable and forgettable.');
INSERT INTO reviews VALUES (0, 129, 5, 'An absolute page-turner that left me wanting more.');
INSERT INTO reviews VALUES (3, 60, 2, 'I expected better. 2.');
INSERT INTO reviews VALUES (0, 6, 3, 'I had trouble getting into the story, but it picked up later.');


insert  into reviews (user_id, book_id, stars, content) values (1, 150, 4, 'Slow-paced and dull.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (11, 140, 4, 'Riveting and intense.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (1, 141, 3, 'Lacked depth.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (10, 67, 2, 'Beautifully descriptive.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (2, 40, 3, 'Couldn''t connect with the story.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (8, 5, 2, 'Unputdownable!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (0, 171, 3, 'Couldn''t get enough!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (12, 161, 4, 'Couldn''t connect with the story.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (3, 21, 4, 'Too many plot holes.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (10, 81, 5, 'Didn''t live up to expectations.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (14, 10, 4, 'Compelling and thought-provoking.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (8, 169, 2, 'A page-turner!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (7, 80, 3, 'Couldn''t get enough!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (1, 108, 4, 'Slow-paced and dull.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (5, 3, 2, 'Highly recommended!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (7, 58, 3, 'Compelling and thought-provoking.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (10, 143, 3, 'Couldn''t connect with the writing style.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (4, 14, 3, 'Expertly crafted.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (4, 20, 1, 'Too predictable.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (12, 111, 4, 'Engrossing and immersive.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (12, 206, 2, 'Couldn''t get into it.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (2, 96, 2, 'Didn''t resonate with me.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (12, 17, 5, 'Beautifully descriptive.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (3, 101, 4, 'Emotionally powerful.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (7, 109, 4, 'Compelling and thought-provoking.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (12, 48, 1, 'Disappointing ending.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (13, 73, 5, 'Didn''t resonate with me.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (9, 167, 2, 'Lacked depth.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (14, 193, 4, 'Great book!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (7, 157, 4, 'Expertly crafted.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (10, 28, 1, 'Disappointing ending.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (0, 22, 2, 'Addictive and suspenseful.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (11, 95, 4, 'Lacked depth.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (11, 14, 2, 'A literary masterpiece!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (5, 52, 1, 'Beautifully descriptive.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (0, 197, 5, 'Beautifully descriptive.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (7, 160, 3, 'Slow-paced and dull.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (2, 93, 3, 'Lacked originality.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (10, 12, 4, 'Didn''t meet my expectations.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (8, 197, 5, 'Too long and boring.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (4, 150, 4, 'Couldn''t put it down!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (2, 41, 5, 'Emotionally powerful.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (0, 201, 5, 'Unputdownable!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (13, 47, 1, 'Addictive and suspenseful.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (11, 19, 3, 'Thought-provoking.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (14, 4, 4, 'Highly recommended!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (12, 138, 3, 'A literary masterpiece!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (1, 103, 5, 'Couldn''t connect with the story.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (8, 171, 4, 'Couldn''t get into it.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (0, 33, 3, 'Unique and original.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (5, 63, 3, 'Engrossing and immersive.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (2, 53, 5, 'Highly recommended!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (5, 97, 3, 'A rollercoaster of emotions!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (12, 129, 2, 'A must-read!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (0, 77, 4, 'Couldn''t get enough!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (2, 120, 3, 'Underwhelming.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (2, 78, 4, 'Underwhelming.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (11, 50, 4, 'Highly recommended!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (13, 108, 3, 'Epic and unforgettable.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (4, 120, 4, 'A must-read!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (1, 44, 4, 'Compelling and thought-provoking.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (7, 55, 2, 'Epic and unforgettable.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (9, 193, 4, 'Gripping storyline.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (12, 2, 5, 'Well-written and engaging.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (9, 26, 1, 'Couldn''t connect with the story.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (12, 68, 2, 'Didn''t hold my interest.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (3, 190, 2, 'A letdown.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (14, 176, 4, 'Didn''t live up to expectations.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (11, 18, 3, 'Thought-provoking.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (1, 65, 5, 'Beautifully descriptive.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (1, 93, 2, 'Lacked originality.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (14, 174, 5, 'A page-turner!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (5, 65, 4, 'Well-written and engaging.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (12, 18, 1, 'Highly recommended!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (5, 14, 3, 'Riveting and intense.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (2, 30, 3, 'Thought-provoking.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (14, 182, 1, 'Engrossing and immersive.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (12, 170, 4, 'Heartwarming and touching.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (5, 24, 1, 'A letdown.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (7, 140, 3, 'Compelling and thought-provoking.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (6, 6, 3, 'Didn''t resonate with me.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (9, 106, 1, 'Addictive and suspenseful.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (5, 201, 2, 'Lacked depth.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (13, 61, 5, 'Well-developed characters.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (9, 67, 5, 'A rollercoaster of emotions!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (12, 61, 2, 'Unique and original.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (9, 33, 5, 'Gripping storyline.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (2, 108, 2, 'Too predictable.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (8, 61, 5, 'A literary masterpiece!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (2, 112, 4, 'Beautifully descriptive.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (7, 67, 4, 'Well-written and engaging.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (7, 70, 4, 'Too predictable.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (13, 31, 1, 'Too long and boring.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (12, 56, 5, 'Too long and boring.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (4, 69, 2, 'Not worth the hype.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (2, 202, 4, 'A letdown.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (10, 14, 2, 'Expertly crafted.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (4, 37, 1, 'Couldn''t connect with the writing style.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (7, 95, 1, 'Lacked depth.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (14, 130, 4, 'Couldn''t stop reading!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (8, 75, 3, 'Suspenseful and thrilling.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (7, 35, 4, 'Didn''t meet my expectations.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (11, 164, 1, 'Unforgettable characters.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (10, 174, 3, 'Beautifully descriptive.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (13, 127, 1, 'Not worth the hype.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (0, 12, 3, 'Didn''t meet my expectations.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (14, 22, 3, 'Heartwarming and touching.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (5, 183, 4, 'Captivating from start to finish.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (14, 11, 3, 'Expertly crafted.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (11, 164, 5, 'Addictive and suspenseful.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (6, 112, 4, 'Too many plot holes.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (8, 126, 4, 'Riveting and intense.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (13, 93, 4, 'Beautifully descriptive.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (5, 62, 2, 'Lacked depth.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (12, 210, 3, 'Couldn''t get into it.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (2, 103, 1, 'Well-written and engaging.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (8, 41, 3, 'Expertly crafted.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (0, 180, 5, 'Great book!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (10, 12, 2, 'Couldn''t stop reading!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (2, 85, 5, 'Captivating from start to finish.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (4, 94, 5, 'Well-written and engaging.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (11, 89, 4, 'Gripping storyline.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (13, 48, 1, 'A must-read!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (3, 135, 2, 'Too long and boring.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (8, 132, 2, 'Unforgettable characters.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (11, 113, 4, 'Couldn''t connect with the story.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (1, 205, 3, 'Incredible plot twist!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (2, 190, 2, 'Underwhelming.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (3, 33, 1, 'Expertly crafted.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (0, 186, 3, 'Loved the characters!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (6, 202, 1, 'Didn''t hold my interest.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (2, 145, 3, 'Lacked originality.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (8, 116, 3, 'Slow-paced and dull.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (13, 39, 2, 'Not worth the hype.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (0, 31, 5, 'Too many plot holes.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (14, 43, 2, 'A page-turner!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (9, 86, 5, 'Lacked originality.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (5, 69, 3, 'Couldn''t connect with the writing style.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (6, 154, 1, 'Didn''t live up to expectations.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (10, 106, 4, 'Riveting and intense.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (10, 9, 2, 'Well-developed characters.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (6, 26, 4, 'Emotionally powerful.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (0, 190, 4, 'Not worth the hype.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (1, 19, 5, 'Highly recommended!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (10, 74, 3, 'Disappointing ending.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (3, 82, 4, 'Didn''t hold my interest.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (13, 115, 4, 'Too many plot holes.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (11, 91, 3, 'Masterfully written.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (0, 66, 2, 'Incredible plot twist!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (10, 100, 1, 'Great book!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (12, 118, 3, 'Too many plot holes.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (6, 199, 1, 'Riveting and intense.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (9, 66, 5, 'Underwhelming.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (2, 130, 4, 'Unforgettable characters.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (4, 111, 2, 'Not worth the hype.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (4, 49, 5, 'Beautifully written.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (5, 79, 4, 'Couldn''t put it down!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (5, 194, 2, 'Lacked depth.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (14, 102, 3, 'A page-turner!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (5, 27, 1, 'Heartwarming and touching.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (9, 203, 1, 'Unique and original.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (13, 26, 2, 'Disappointing ending.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (14, 56, 2, 'Beautifully written.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (5, 54, 3, 'Beautifully written.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (12, 87, 1, 'Highly recommended!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (6, 141, 1, 'Emotionally powerful.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (8, 188, 5, 'Slow-paced and dull.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (7, 86, 3, 'Too predictable.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (14, 55, 2, 'Great book!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (8, 165, 2, 'Suspenseful and thrilling.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (9, 121, 4, 'Incredible plot twist!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (5, 5, 2, 'Loved the characters!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (0, 178, 5, 'Kept me guessing until the end.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (13, 146, 4, 'A letdown.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (7, 204, 3, 'Kept me guessing until the end.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (13, 3, 3, 'Addictive and suspenseful.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (5, 8, 1, 'Heartwarming and touching.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (11, 4, 5, 'Masterfully written.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (11, 136, 2, 'A letdown.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (13, 22, 5, 'Gripping storyline.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (2, 88, 2, 'Incredible plot twist!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (12, 41, 3, 'A letdown.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (11, 37, 5, 'Disappointing ending.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (7, 58, 1, 'Couldn''t stop reading!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (7, 38, 2, 'Riveting and intense.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (6, 76, 4, 'Gripping storyline.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (14, 98, 2, 'Unforgettable characters.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (11, 146, 4, 'Didn''t hold my interest.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (14, 105, 2, 'Couldn''t connect with the story.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (3, 83, 2, 'A must-read!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (2, 133, 2, 'Didn''t resonate with me.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (8, 66, 5, 'A letdown.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (5, 186, 2, 'Unputdownable!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (7, 162, 1, 'A rollercoaster of emotions!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (1, 120, 4, 'Expertly crafted.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (1, 179, 1, 'Masterfully written.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (11, 109, 2, 'A must-read!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (10, 20, 4, 'Highly recommended!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (8, 165, 2, 'Underwhelming.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (3, 91, 1, 'Disappointing ending.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (3, 192, 4, 'Expertly crafted.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (10, 184, 4, 'Unputdownable!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (12, 39, 2, 'Lacked originality.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (3, 33, 5, 'Emotionally powerful.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (10, 120, 4, 'Great book!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (0, 186, 3, 'Didn''t hold my interest.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (5, 136, 3, 'Unforgettable characters.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (12, 25, 2, 'Gripping storyline.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (7, 166, 2, 'Beautifully descriptive.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (10, 117, 3, 'Loved the characters!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (10, 157, 4, 'Couldn''t put it down!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (13, 84, 2, 'Great book!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (11, 187, 5, 'Unputdownable!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (7, 186, 3, 'Compelling and thought-provoking.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (9, 19, 2, 'A literary masterpiece!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (5, 85, 3, 'Great book!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (8, 180, 3, 'Engrossing and immersive.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (8, 106, 1, 'Well-developed characters.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (3, 164, 3, 'Riveting and intense.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (12, 53, 3, 'Didn''t resonate with me.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (3, 144, 5, 'Couldn''t connect with the story.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (10, 35, 1, 'Couldn''t get enough!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (9, 208, 3, 'Thought-provoking.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (1, 202, 5, 'Beautifully descriptive.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (7, 147, 1, 'Unputdownable!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (9, 203, 3, 'A must-read!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (3, 184, 3, 'Great book!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (13, 149, 3, 'Too many plot holes.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (6, 164, 5, 'Kept me guessing until the end.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (1, 168, 3, 'Expertly crafted.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (13, 61, 2, 'Incredible plot twist!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (10, 61, 5, 'Too long and boring.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (5, 61, 3, 'Compelling and thought-provoking.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (14, 146, 5, 'Not worth the hype.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (10, 19, 2, 'Couldn''t get enough!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (3, 83, 1, 'Beautifully written.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (2, 189, 2, 'Well-developed characters.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (9, 135, 4, 'Couldn''t get into it.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (8, 169, 2, 'Too predictable.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (5, 160, 2, 'Too many plot holes.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (9, 82, 2, 'Riveting and intense.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (11, 85, 4, 'Unforgettable characters.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (5, 36, 5, 'Lacked depth.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (0, 196, 3, 'A literary masterpiece!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (4, 154, 4, 'Unforgettable characters.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (0, 35, 4, 'Didn''t live up to expectations.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (9, 211, 3, 'Well-developed characters.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (12, 133, 5, 'Couldn''t get into it.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (10, 131, 1, 'Lacked depth.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (0, 101, 2, 'Unputdownable!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (4, 181, 2, 'Loved the characters!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (13, 101, 5, 'Couldn''t put it down!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (7, 122, 5, 'Engrossing and immersive.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (12, 140, 5, 'Slow-paced and dull.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (2, 123, 1, 'Kept me guessing until the end.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (14, 153, 2, 'Unforgettable characters.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (6, 106, 4, 'Couldn''t put it down!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (11, 199, 4, 'Expertly crafted.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (6, 2, 4, 'Heartwarming and touching.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (3, 207, 3, 'Masterfully written.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (3, 30, 5, 'Captivating from start to finish.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (9, 185, 3, 'Great book!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (10, 134, 1, 'A must-read!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (14, 93, 1, 'Captivating from start to finish.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (10, 47, 5, 'Great book!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (12, 154, 3, 'Riveting and intense.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (2, 3, 2, 'Thought-provoking.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (0, 185, 5, 'Expertly crafted.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (9, 14, 5, 'Well-written and engaging.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (0, 158, 2, 'Slow-paced and dull.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (12, 68, 3, 'Lacked depth.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (11, 46, 4, 'Addictive and suspenseful.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (12, 35, 2, 'Heartwarming and touching.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (13, 81, 1, 'A must-read!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (3, 92, 1, 'Lacked depth.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (5, 42, 2, 'Couldn''t put it down!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (14, 37, 5, 'Well-developed characters.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (11, 2, 2, 'Heartwarming and touching.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (3, 172, 5, 'Suspenseful and thrilling.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (12, 82, 4, 'Well-written and engaging.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (0, 57, 1, 'Couldn''t get into it.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (7, 125, 4, 'Highly recommended!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (0, 80, 5, 'Great book!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (2, 155, 4, 'Great book!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (12, 153, 2, 'Slow-paced and dull.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (1, 80, 5, 'Too predictable.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (11, 205, 2, 'Engrossing and immersive.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (14, 78, 2, 'Expertly crafted.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (7, 135, 2, 'Slow-paced and dull.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (12, 99, 1, 'Highly recommended!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (7, 11, 4, 'Didn''t hold my interest.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (0, 47, 3, 'Loved the characters!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (7, 82, 4, 'Compelling and thought-provoking.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (14, 208, 5, 'Couldn''t connect with the writing style.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (14, 131, 5, 'Beautifully descriptive.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (13, 148, 3, 'Too long and boring.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (0, 30, 4, 'Incredible plot twist!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (14, 91, 3, 'Thought-provoking.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (7, 79, 2, 'Masterfully written.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (10, 205, 5, 'Didn''t meet my expectations.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (6, 36, 2, 'Compelling and thought-provoking.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (2, 102, 1, 'Underwhelming.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (1, 202, 3, 'A page-turner!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (14, 137, 2, 'Captivating from start to finish.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (7, 129, 4, 'Gripping storyline.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (5, 175, 4, 'Underwhelming.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (6, 31, 2, 'Too many plot holes.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (7, 39, 5, 'Beautifully written.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (0, 182, 5, 'Couldn''t get enough!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (8, 77, 2, 'Couldn''t connect with the writing style.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (2, 161, 3, 'Beautifully written.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (11, 202, 1, 'Beautifully written.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (4, 39, 1, 'A literary masterpiece!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (0, 84, 4, 'Great book!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (2, 46, 5, 'A letdown.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (8, 36, 4, 'Didn''t meet my expectations.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (8, 83, 5, 'Loved the characters!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (3, 24, 5, 'Didn''t hold my interest.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (11, 159, 2, 'Masterfully written.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (0, 112, 1, 'Loved the characters!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (2, 198, 4, 'Lacked depth.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (8, 149, 1, 'Couldn''t connect with the story.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (1, 205, 1, 'Addictive and suspenseful.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (5, 180, 5, 'Addictive and suspenseful.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (9, 130, 1, 'Well-written and engaging.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (3, 121, 3, 'Emotionally powerful.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (7, 47, 2, 'Captivating from start to finish.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (6, 125, 5, 'Couldn''t connect with the writing style.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (14, 210, 5, 'Compelling and thought-provoking.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (13, 58, 5, 'A rollercoaster of emotions!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (0, 158, 3, 'Didn''t hold my interest.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (13, 71, 5, 'Too long and boring.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (14, 69, 2, 'Well-written and engaging.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (7, 109, 3, 'Beautifully descriptive.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (4, 75, 2, 'Didn''t resonate with me.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (14, 143, 1, 'Too long and boring.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (9, 36, 1, 'Couldn''t get enough!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (4, 87, 4, 'Great book!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (14, 149, 4, 'Couldn''t connect with the story.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (1, 58, 4, 'Kept me guessing until the end.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (7, 83, 2, 'Slow-paced and dull.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (12, 111, 4, 'Kept me guessing until the end.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (7, 63, 5, 'A must-read!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (8, 156, 5, 'Didn''t meet my expectations.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (14, 149, 2, 'Too long and boring.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (7, 119, 4, 'Didn''t hold my interest.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (2, 113, 2, 'Well-written and engaging.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (12, 141, 5, 'Unforgettable characters.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (13, 190, 5, 'Well-written and engaging.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (1, 207, 4, 'Captivating from start to finish.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (12, 59, 1, 'Expertly crafted.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (9, 159, 4, 'Didn''t meet my expectations.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (8, 51, 5, 'Beautifully written.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (5, 25, 2, 'Unique and original.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (8, 30, 5, 'Suspenseful and thrilling.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (10, 115, 1, 'Beautifully written.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (0, 58, 4, 'Engrossing and immersive.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (3, 56, 2, 'Epic and unforgettable.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (1, 180, 5, 'Captivating from start to finish.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (2, 150, 2, 'Didn''t live up to expectations.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (4, 211, 1, 'Suspenseful and thrilling.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (13, 197, 5, 'Expertly crafted.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (1, 50, 3, 'Riveting and intense.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (14, 37, 4, 'Engrossing and immersive.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (8, 40, 4, 'Couldn''t get enough!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (4, 51, 5, 'A rollercoaster of emotions!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (12, 36, 3, 'Epic and unforgettable.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (2, 21, 4, 'Beautifully written.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (12, 5, 4, 'Couldn''t connect with the story.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (4, 44, 3, 'Too long and boring.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (11, 184, 5, 'Couldn''t stop reading!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (3, 100, 2, 'A letdown.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (13, 181, 4, 'Masterfully written.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (14, 123, 5, 'Emotionally powerful.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (5, 198, 5, 'Expertly crafted.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (5, 16, 2, 'Too predictable.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (5, 198, 1, 'Unique and original.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (3, 4, 5, 'Thought-provoking.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (11, 19, 3, 'Unputdownable!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (10, 91, 2, 'A rollercoaster of emotions!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (1, 68, 1, 'Heartwarming and touching.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (10, 81, 1, 'Didn''t resonate with me.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (11, 186, 3, 'Underwhelming.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (0, 163, 2, 'Disappointing ending.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (5, 5, 5, 'Captivating from start to finish.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (1, 130, 2, 'A literary masterpiece!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (3, 77, 3, 'Slow-paced and dull.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (5, 26, 1, 'Couldn''t get into it.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (12, 34, 3, 'Disappointing ending.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (0, 31, 5, 'Unforgettable characters.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (1, 4, 1, 'Highly recommended!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (7, 195, 2, 'Incredible plot twist!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (8, 24, 4, 'Lacked originality.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (8, 175, 5, 'Emotionally powerful.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (14, 55, 5, 'A letdown.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (6, 190, 5, 'Suspenseful and thrilling.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (13, 99, 4, 'Underwhelming.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (13, 172, 3, 'Thought-provoking.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (2, 37, 3, 'Emotionally powerful.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (12, 146, 1, 'A letdown.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (6, 103, 3, 'Underwhelming.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (7, 1, 3, 'Compelling and thought-provoking.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (9, 83, 2, 'A literary masterpiece!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (1, 70, 4, 'Disappointing ending.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (0, 151, 4, 'Great book!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (5, 200, 2, 'Emotionally powerful.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (14, 192, 5, 'Addictive and suspenseful.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (11, 86, 2, 'Captivating from start to finish.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (6, 68, 2, 'Suspenseful and thrilling.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (2, 192, 2, 'Unputdownable!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (11, 204, 2, 'Riveting and intense.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (4, 22, 1, 'Captivating from start to finish.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (8, 12, 5, 'Beautifully descriptive.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (10, 169, 1, 'Too long and boring.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (14, 191, 5, 'Didn''t resonate with me.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (8, 41, 4, 'A rollercoaster of emotions!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (7, 2, 2, 'Couldn''t get into it.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (6, 93, 1, 'Great book!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (3, 150, 2, 'Too many plot holes.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (6, 73, 1, 'Compelling and thought-provoking.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (13, 106, 2, 'Kept me guessing until the end.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (12, 110, 4, 'Addictive and suspenseful.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (12, 204, 4, 'Kept me guessing until the end.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (5, 82, 5, 'Didn''t live up to expectations.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (12, 168, 1, 'Gripping storyline.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (8, 179, 1, 'Couldn''t connect with the story.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (7, 204, 1, 'Epic and unforgettable.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (0, 3, 4, 'Couldn''t stop reading!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (8, 41, 3, 'A letdown.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (1, 175, 3, 'A must-read!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (7, 169, 3, 'Captivating from start to finish.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (4, 1, 4, 'Engrossing and immersive.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (5, 209, 5, 'Couldn''t put it down!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (2, 171, 2, 'A literary masterpiece!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (9, 27, 3, 'Not worth the hype.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (6, 31, 3, 'Great book!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (14, 68, 1, 'Couldn''t connect with the writing style.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (1, 53, 5, 'Masterfully written.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (6, 38, 3, 'Addictive and suspenseful.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (5, 50, 2, 'Disappointing ending.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (10, 73, 3, 'Didn''t resonate with me.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (2, 181, 5, 'Beautifully written.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (5, 102, 5, 'Unique and original.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (14, 211, 3, 'Engrossing and immersive.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (7, 120, 1, 'Masterfully written.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (13, 107, 5, 'Thought-provoking.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (13, 51, 4, 'Thought-provoking.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (10, 185, 1, 'Lacked originality.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (4, 65, 4, 'Didn''t live up to expectations.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (13, 140, 3, 'Too long and boring.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (1, 156, 4, 'Emotionally powerful.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (14, 148, 3, 'Slow-paced and dull.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (12, 65, 3, 'Didn''t live up to expectations.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (8, 169, 2, 'Unforgettable characters.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (1, 62, 3, 'Disappointing ending.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (3, 205, 4, 'Couldn''t connect with the story.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (1, 161, 1, 'Heartwarming and touching.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (0, 210, 5, 'Great book!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (4, 147, 5, 'Unputdownable!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (2, 175, 2, 'Slow-paced and dull.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (3, 188, 4, 'Emotionally powerful.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (5, 103, 3, 'Unforgettable characters.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (6, 150, 2, 'Suspenseful and thrilling.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (11, 37, 3, 'Highly recommended!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (6, 85, 3, 'Epic and unforgettable.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (0, 205, 3, 'Didn''t meet my expectations.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (5, 30, 2, 'Compelling and thought-provoking.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (9, 71, 4, 'Lacked depth.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (2, 32, 3, 'Lacked depth.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (12, 84, 4, 'Couldn''t get enough!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (12, 32, 2, 'Beautifully written.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (1, 88, 5, 'Engrossing and immersive.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (7, 60, 5, 'Captivating from start to finish.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (8, 5, 5, 'Not worth the hype.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (7, 61, 2, 'Couldn''t get into it.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (9, 125, 5, 'Unique and original.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (1, 80, 2, 'Unputdownable!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (3, 199, 3, 'A letdown.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (6, 151, 5, 'Thought-provoking.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (10, 65, 4, 'Unforgettable characters.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (2, 139, 2, 'Didn''t live up to expectations.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (6, 210, 2, 'Loved the characters!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (9, 119, 4, 'Slow-paced and dull.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (11, 131, 3, 'Compelling and thought-provoking.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (1, 28, 1, 'Slow-paced and dull.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (1, 167, 4, 'Not worth the hype.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (4, 94, 4, 'Riveting and intense.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (3, 10, 1, 'Suspenseful and thrilling.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (2, 88, 5, 'Unique and original.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (6, 137, 5, 'Couldn''t put it down!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (10, 12, 2, 'Riveting and intense.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (14, 7, 4, 'Unique and original.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (9, 94, 2, 'Riveting and intense.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (14, 23, 4, 'Disappointing ending.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (13, 32, 4, 'Didn''t resonate with me.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (4, 28, 4, 'Engrossing and immersive.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (8, 183, 3, 'Kept me guessing until the end.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (6, 110, 5, 'Engrossing and immersive.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (10, 34, 1, 'Gripping storyline.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (10, 77, 3, 'Didn''t meet my expectations.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (7, 191, 3, 'Didn''t meet my expectations.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (13, 210, 1, 'A rollercoaster of emotions!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (5, 118, 3, 'Lacked depth.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (0, 160, 4, 'A letdown.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (2, 198, 3, 'Loved the characters!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (8, 211, 5, 'Heartwarming and touching.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (6, 169, 1, 'Didn''t resonate with me.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (9, 103, 3, 'Expertly crafted.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (14, 90, 2, 'Didn''t hold my interest.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (13, 41, 1, 'Couldn''t get into it.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (6, 168, 3, 'Epic and unforgettable.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (4, 163, 1, 'Beautifully descriptive.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (4, 49, 4, 'Beautifully written.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (1, 2, 4, 'Suspenseful and thrilling.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (1, 110, 4, 'Engrossing and immersive.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (3, 189, 4, 'Engrossing and immersive.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (11, 150, 3, 'Suspenseful and thrilling.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (9, 23, 4, 'Masterfully written.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (13, 111, 4, 'Addictive and suspenseful.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (10, 35, 4, 'A page-turner!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (2, 81, 4, 'Well-written and engaging.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (0, 196, 4, 'Well-developed characters.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (0, 36, 1, 'Couldn''t get into it.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (9, 100, 5, 'Disappointing ending.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (6, 79, 1, 'Couldn''t stop reading!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (9, 115, 5, 'Well-developed characters.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (4, 71, 1, 'Loved the characters!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (9, 154, 5, 'Too predictable.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (3, 132, 2, 'Didn''t hold my interest.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (5, 135, 5, 'Lacked originality.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (8, 118, 2, 'A letdown.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (4, 94, 2, 'Lacked originality.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (1, 6, 3, 'Incredible plot twist!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (9, 46, 5, 'Well-written and engaging.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (4, 61, 4, 'Heartwarming and touching.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (6, 206, 5, 'Heartwarming and touching.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (13, 168, 5, 'Unique and original.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (9, 210, 4, 'A literary masterpiece!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (11, 81, 1, 'Couldn''t connect with the story.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (9, 40, 1, 'Well-developed characters.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (13, 155, 5, 'Couldn''t connect with the story.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (6, 171, 5, 'A must-read!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (10, 19, 1, 'A must-read!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (4, 207, 4, 'Didn''t meet my expectations.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (11, 20, 3, 'Unputdownable!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (11, 128, 5, 'Well-written and engaging.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (13, 164, 4, 'Loved the characters!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (12, 182, 5, 'A page-turner!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (9, 108, 2, 'Didn''t resonate with me.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (7, 134, 2, 'Addictive and suspenseful.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (14, 207, 5, 'Beautifully descriptive.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (10, 92, 4, 'Couldn''t connect with the writing style.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (11, 186, 2, 'Didn''t resonate with me.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (8, 193, 5, 'Gripping storyline.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (12, 144, 1, 'Great book!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (1, 111, 4, 'Heartwarming and touching.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (6, 184, 3, 'Lacked originality.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (12, 197, 2, 'Didn''t live up to expectations.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (0, 169, 3, 'Incredible plot twist!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (2, 203, 2, 'Epic and unforgettable.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (1, 125, 4, 'Masterfully written.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (14, 27, 3, 'Engrossing and immersive.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (4, 18, 5, 'Heartwarming and touching.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (13, 24, 5, 'Too long and boring.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (4, 5, 4, 'Beautifully descriptive.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (8, 95, 3, 'Incredible plot twist!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (10, 77, 2, 'Beautifully written.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (7, 118, 5, 'Compelling and thought-provoking.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (2, 165, 2, 'Gripping storyline.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (2, 103, 5, 'Beautifully descriptive.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (0, 99, 2, 'Slow-paced and dull.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (11, 172, 4, 'Compelling and thought-provoking.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (10, 82, 2, 'Couldn''t get enough!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (4, 10, 3, 'Too long and boring.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (8, 68, 1, 'Couldn''t connect with the writing style.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (1, 158, 2, 'Beautifully descriptive.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (1, 15, 2, 'Epic and unforgettable.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (7, 38, 2, 'Couldn''t get into it.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (5, 127, 4, 'Great book!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (10, 111, 5, 'Couldn''t get enough!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (11, 50, 4, 'Underwhelming.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (13, 53, 4, 'Gripping storyline.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (14, 78, 5, 'Incredible plot twist!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (6, 53, 1, 'Masterfully written.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (0, 172, 2, 'Addictive and suspenseful.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (7, 185, 3, 'Gripping storyline.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (13, 68, 2, 'A literary masterpiece!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (0, 112, 5, 'Great book!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (13, 54, 2, 'Compelling and thought-provoking.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (7, 44, 2, 'Couldn''t connect with the story.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (1, 15, 3, 'Not worth the hype.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (5, 32, 5, 'Disappointing ending.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (3, 13, 5, 'Great book!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (5, 72, 5, 'A must-read!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (12, 130, 5, 'Didn''t live up to expectations.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (12, 149, 1, 'A letdown.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (0, 183, 3, 'Suspenseful and thrilling.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (5, 26, 1, 'Too predictable.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (8, 80, 4, 'Couldn''t stop reading!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (12, 96, 4, 'Engrossing and immersive.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (0, 72, 1, 'Couldn''t stop reading!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (11, 7, 5, 'Couldn''t stop reading!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (5, 117, 1, 'Heartwarming and touching.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (14, 103, 1, 'Beautifully written.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (9, 152, 4, 'Highly recommended!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (5, 117, 5, 'Couldn''t put it down!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (3, 211, 2, 'Compelling and thought-provoking.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (6, 187, 4, 'Well-developed characters.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (8, 154, 4, 'A literary masterpiece!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (7, 198, 2, 'Didn''t meet my expectations.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (8, 62, 2, 'Lacked depth.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (7, 144, 5, 'Too long and boring.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (2, 124, 3, 'Captivating from start to finish.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (1, 202, 1, 'Compelling and thought-provoking.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (5, 137, 3, 'Loved the characters!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (1, 160, 1, 'Not worth the hype.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (0, 49, 4, 'Couldn''t stop reading!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (12, 199, 3, 'Highly recommended!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (0, 104, 3, 'Kept me guessing until the end.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (10, 206, 4, 'Compelling and thought-provoking.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (14, 69, 3, 'Couldn''t stop reading!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (11, 46, 3, 'A page-turner!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (11, 104, 1, 'Not worth the hype.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (2, 45, 2, 'Great book!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (9, 9, 3, 'Epic and unforgettable.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (0, 83, 1, 'Riveting and intense.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (4, 49, 1, 'Masterfully written.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (7, 157, 5, 'Expertly crafted.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (0, 132, 3, 'Engrossing and immersive.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (10, 206, 1, 'Didn''t resonate with me.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (1, 134, 1, 'Unique and original.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (5, 61, 2, 'Expertly crafted.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (1, 166, 2, 'Didn''t resonate with me.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (9, 10, 3, 'Heartwarming and touching.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (5, 135, 2, 'Underwhelming.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (2, 167, 1, 'Didn''t live up to expectations.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (13, 189, 5, 'A literary masterpiece!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (2, 119, 1, 'Slow-paced and dull.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (0, 194, 5, 'Couldn''t get enough!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (14, 58, 3, 'Couldn''t stop reading!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (1, 139, 4, 'Gripping storyline.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (12, 196, 4, 'Incredible plot twist!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (3, 54, 2, 'Couldn''t connect with the story.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (8, 204, 4, 'Heartwarming and touching.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (13, 137, 5, 'Disappointing ending.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (1, 47, 4, 'Slow-paced and dull.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (9, 117, 3, 'Well-developed characters.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (8, 76, 4, 'Too many plot holes.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (5, 53, 1, 'Too long and boring.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (9, 160, 2, 'Couldn''t connect with the writing style.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (9, 10, 1, 'Expertly crafted.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (2, 143, 4, 'Couldn''t get into it.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (14, 63, 5, 'A letdown.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (1, 184, 3, 'Incredible plot twist!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (10, 5, 2, 'Heartwarming and touching.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (10, 146, 2, 'Thought-provoking.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (14, 9, 5, 'Lacked originality.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (9, 181, 4, 'Emotionally powerful.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (6, 88, 1, 'Unputdownable!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (8, 14, 3, 'Beautifully written.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (3, 142, 1, 'Unforgettable characters.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (4, 131, 2, 'A must-read!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (3, 78, 1, 'Kept me guessing until the end.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (8, 162, 2, 'Expertly crafted.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (6, 19, 2, 'Not worth the hype.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (11, 167, 2, 'Unputdownable!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (10, 133, 4, 'Beautifully descriptive.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (7, 43, 4, 'A page-turner!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (8, 41, 5, 'Couldn''t put it down!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (8, 52, 4, 'Heartwarming and touching.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (4, 128, 4, 'Couldn''t connect with the writing style.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (10, 97, 2, 'Gripping storyline.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (13, 151, 2, 'Unforgettable characters.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (5, 102, 1, 'Suspenseful and thrilling.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (7, 196, 3, 'Underwhelming.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (2, 178, 4, 'Not worth the hype.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (8, 139, 2, 'A page-turner!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (2, 179, 2, 'Too long and boring.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (9, 97, 1, 'Highly recommended!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (12, 82, 1, 'Unputdownable!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (11, 150, 4, 'Incredible plot twist!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (0, 116, 1, 'Masterfully written.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (11, 180, 3, 'Well-developed characters.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (5, 199, 3, 'Slow-paced and dull.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (8, 115, 5, 'Didn''t resonate with me.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (4, 119, 1, 'Masterfully written.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (9, 68, 5, 'Captivating from start to finish.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (5, 62, 2, 'Highly recommended!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (14, 162, 2, 'Didn''t live up to expectations.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (8, 201, 1, 'Couldn''t stop reading!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (5, 191, 1, 'A page-turner!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (2, 83, 1, 'Lacked originality.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (11, 83, 4, 'Couldn''t connect with the writing style.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (12, 118, 1, 'Lacked depth.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (9, 165, 4, 'Couldn''t stop reading!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (11, 64, 5, 'Great book!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (1, 91, 3, 'A rollercoaster of emotions!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (5, 36, 4, 'Didn''t resonate with me.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (13, 117, 5, 'Loved the characters!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (7, 36, 2, 'Riveting and intense.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (11, 180, 2, 'Didn''t live up to expectations.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (4, 16, 4, 'Didn''t hold my interest.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (2, 124, 3, 'Disappointing ending.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (5, 21, 3, 'Too long and boring.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (4, 152, 1, 'Thought-provoking.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (3, 152, 4, 'Thought-provoking.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (3, 185, 4, 'Didn''t resonate with me.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (12, 118, 3, 'Kept me guessing until the end.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (7, 204, 3, 'Compelling and thought-provoking.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (11, 66, 2, 'A page-turner!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (4, 158, 5, 'Highly recommended!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (2, 124, 1, 'Well-developed characters.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (10, 10, 1, 'Expertly crafted.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (0, 165, 2, 'Addictive and suspenseful.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (7, 169, 5, 'Underwhelming.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (9, 185, 2, 'Suspenseful and thrilling.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (4, 43, 4, 'Lacked originality.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (7, 61, 2, 'Slow-paced and dull.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (1, 98, 4, 'Unforgettable characters.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (7, 45, 1, 'Loved the characters!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (6, 139, 2, 'Engrossing and immersive.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (7, 149, 4, 'Highly recommended!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (13, 54, 2, 'Riveting and intense.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (13, 150, 4, 'Well-developed characters.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (0, 12, 2, 'Didn''t resonate with me.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (3, 106, 3, 'Thought-provoking.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (13, 69, 2, 'Expertly crafted.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (7, 110, 4, 'Well-written and engaging.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (5, 90, 4, 'Incredible plot twist!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (12, 207, 2, 'Heartwarming and touching.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (6, 38, 5, 'Couldn''t get enough!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (3, 113, 5, 'Couldn''t connect with the story.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (8, 130, 5, 'A must-read!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (0, 84, 5, 'Too long and boring.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (8, 13, 2, 'Didn''t live up to expectations.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (5, 107, 1, 'Beautifully written.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (4, 145, 5, 'A rollercoaster of emotions!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (2, 42, 2, 'Masterfully written.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (12, 77, 4, 'Loved the characters!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (10, 83, 1, 'Well-written and engaging.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (10, 202, 4, 'Couldn''t stop reading!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (5, 121, 2, 'Beautifully descriptive.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (5, 125, 3, 'Disappointing ending.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (12, 128, 5, 'Gripping storyline.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (6, 136, 4, 'Didn''t resonate with me.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (11, 37, 2, 'Thought-provoking.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (7, 80, 5, 'Unputdownable!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (8, 181, 2, 'Unforgettable characters.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (13, 86, 4, 'Unique and original.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (2, 41, 2, 'Underwhelming.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (14, 190, 5, 'Great book!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (4, 69, 5, 'Great book!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (4, 200, 5, 'Couldn''t get into it.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (8, 202, 1, 'Too many plot holes.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (7, 123, 5, 'Riveting and intense.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (12, 185, 4, 'Well-developed characters.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (6, 80, 3, 'Unique and original.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (12, 39, 4, 'Kept me guessing until the end.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (2, 211, 4, 'Slow-paced and dull.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (14, 1, 4, 'Underwhelming.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (7, 204, 5, 'Couldn''t get into it.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (0, 44, 1, 'Great book!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (1, 1, 4, 'Lacked originality.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (1, 143, 3, 'Underwhelming.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (12, 7, 1, 'Suspenseful and thrilling.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (5, 190, 5, 'Disappointing ending.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (14, 4, 2, 'Well-developed characters.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (6, 69, 2, 'Couldn''t put it down!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (11, 173, 1, 'Expertly crafted.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (1, 66, 1, 'Compelling and thought-provoking.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (7, 147, 2, 'Unputdownable!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (4, 115, 2, 'Great book!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (7, 162, 2, 'Engrossing and immersive.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (1, 107, 5, 'Couldn''t connect with the story.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (3, 155, 3, 'Captivating from start to finish.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (12, 76, 2, 'Couldn''t put it down!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (9, 165, 5, 'Great book!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (5, 198, 5, 'Didn''t hold my interest.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (14, 128, 2, 'A letdown.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (2, 189, 3, 'Couldn''t get enough!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (12, 156, 1, 'A rollercoaster of emotions!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (13, 8, 3, 'Loved the characters!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (8, 101, 3, 'Heartwarming and touching.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (0, 42, 5, 'Loved the characters!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (3, 142, 1, 'Slow-paced and dull.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (9, 16, 2, 'Couldn''t connect with the writing style.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (6, 123, 5, 'Couldn''t get into it.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (14, 45, 1, 'Too many plot holes.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (4, 13, 5, 'Gripping storyline.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (0, 52, 5, 'Unique and original.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (13, 182, 1, 'A must-read!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (9, 103, 4, 'A page-turner!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (12, 67, 4, 'Engrossing and immersive.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (3, 176, 5, 'A rollercoaster of emotions!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (3, 166, 1, 'Underwhelming.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (1, 23, 3, 'Loved the characters!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (10, 138, 3, 'Couldn''t stop reading!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (3, 68, 2, 'Loved the characters!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (5, 118, 3, 'Beautifully descriptive.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (14, 76, 5, 'Couldn''t get enough!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (3, 112, 4, 'Addictive and suspenseful.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (11, 115, 1, 'Highly recommended!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (11, 91, 2, 'Not worth the hype.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (13, 13, 1, 'Beautifully descriptive.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (12, 152, 4, 'Lacked originality.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (0, 41, 3, 'Loved the characters!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (1, 37, 1, 'Incredible plot twist!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (7, 2, 4, 'Didn''t live up to expectations.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (4, 122, 4, 'Disappointing ending.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (1, 135, 2, 'Unforgettable characters.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (4, 112, 1, 'Riveting and intense.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (4, 76, 2, 'Captivating from start to finish.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (4, 174, 2, 'Kept me guessing until the end.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (13, 104, 2, 'Emotionally powerful.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (1, 184, 4, 'Couldn''t get enough!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (2, 77, 4, 'Slow-paced and dull.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (2, 203, 1, 'Riveting and intense.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (5, 8, 5, 'A rollercoaster of emotions!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (1, 9, 2, 'Suspenseful and thrilling.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (12, 78, 2, 'Expertly crafted.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (4, 14, 2, 'Couldn''t get enough!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (2, 201, 2, 'Addictive and suspenseful.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (1, 155, 2, 'Slow-paced and dull.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (11, 38, 5, 'Too predictable.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (7, 181, 3, 'Too long and boring.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (7, 15, 4, 'Engrossing and immersive.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (3, 164, 4, 'Incredible plot twist!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (11, 165, 4, 'Too many plot holes.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (10, 134, 2, 'A literary masterpiece!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (7, 152, 4, 'Underwhelming.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (1, 88, 4, 'Emotionally powerful.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (4, 150, 5, 'Didn''t hold my interest.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (14, 143, 3, 'Great book!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (6, 78, 2, 'Suspenseful and thrilling.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (14, 70, 5, 'Captivating from start to finish.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (4, 115, 2, 'Beautifully descriptive.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (14, 183, 2, 'Great book!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (0, 133, 5, 'Suspenseful and thrilling.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (10, 145, 4, 'Epic and unforgettable.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (0, 72, 1, 'A literary masterpiece!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (1, 179, 4, 'Too many plot holes.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (8, 20, 2, 'Disappointing ending.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (11, 74, 3, 'Riveting and intense.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (0, 72, 3, 'A must-read!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (0, 70, 2, 'A page-turner!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (3, 90, 3, 'Beautifully written.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (2, 73, 1, 'Didn''t meet my expectations.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (9, 193, 5, 'Addictive and suspenseful.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (1, 194, 1, 'A page-turner!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (12, 41, 4, 'Underwhelming.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (11, 210, 3, 'Couldn''t put it down!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (3, 159, 5, 'Couldn''t connect with the story.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (0, 172, 1, 'Too predictable.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (11, 124, 4, 'Riveting and intense.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (5, 126, 4, 'Underwhelming.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (9, 116, 5, 'Epic and unforgettable.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (13, 95, 3, 'Beautifully descriptive.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (11, 192, 5, 'Compelling and thought-provoking.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (7, 52, 2, 'Lacked depth.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (4, 176, 3, 'Beautifully written.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (12, 27, 2, 'Heartwarming and touching.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (3, 90, 4, 'Epic and unforgettable.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (13, 96, 1, 'Epic and unforgettable.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (8, 163, 2, 'Suspenseful and thrilling.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (13, 143, 3, 'Suspenseful and thrilling.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (1, 88, 1, 'Didn''t meet my expectations.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (11, 180, 5, 'Incredible plot twist!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (8, 176, 5, 'Didn''t live up to expectations.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (0, 178, 1, 'Well-developed characters.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (9, 52, 5, 'Not worth the hype.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (14, 180, 3, 'Slow-paced and dull.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (10, 82, 4, 'Highly recommended!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (8, 37, 1, 'Expertly crafted.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (5, 174, 2, 'Well-written and engaging.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (5, 71, 4, 'Couldn''t connect with the story.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (14, 11, 3, 'Expertly crafted.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (3, 130, 4, 'Underwhelming.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (7, 168, 4, 'Compelling and thought-provoking.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (6, 69, 4, 'Beautifully descriptive.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (12, 113, 1, 'Beautifully written.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (11, 184, 1, 'Slow-paced and dull.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (13, 198, 3, 'Didn''t meet my expectations.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (10, 169, 3, 'A page-turner!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (8, 162, 1, 'Expertly crafted.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (10, 134, 1, 'A page-turner!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (11, 112, 2, 'Didn''t hold my interest.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (7, 82, 2, 'Great book!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (8, 120, 4, 'Too many plot holes.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (9, 137, 4, 'Couldn''t get into it.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (10, 53, 3, 'Didn''t meet my expectations.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (8, 7, 4, 'A rollercoaster of emotions!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (2, 96, 3, 'Couldn''t connect with the writing style.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (0, 29, 4, 'Well-developed characters.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (8, 155, 5, 'Too many plot holes.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (9, 109, 4, 'Suspenseful and thrilling.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (10, 50, 5, 'Highly recommended!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (0, 146, 4, 'Didn''t meet my expectations.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (1, 145, 2, 'A literary masterpiece!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (8, 102, 1, 'Slow-paced and dull.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (14, 98, 3, 'Well-written and engaging.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (7, 186, 1, 'Didn''t meet my expectations.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (2, 167, 3, 'Too many plot holes.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (10, 30, 2, 'Didn''t live up to expectations.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (2, 206, 5, 'Didn''t hold my interest.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (2, 10, 3, 'Great book!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (3, 113, 3, 'Captivating from start to finish.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (0, 119, 3, 'A letdown.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (3, 58, 2, 'Couldn''t put it down!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (13, 20, 5, 'Epic and unforgettable.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (8, 177, 2, 'Beautifully written.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (5, 202, 3, 'Incredible plot twist!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (5, 204, 1, 'Riveting and intense.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (11, 60, 2, 'Riveting and intense.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (1, 33, 5, 'Beautifully written.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (13, 67, 1, 'Compelling and thought-provoking.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (4, 180, 4, 'Lacked depth.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (9, 145, 1, 'Beautifully descriptive.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (3, 149, 1, 'Not worth the hype.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (13, 49, 4, 'Kept me guessing until the end.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (11, 96, 5, 'Expertly crafted.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (3, 178, 3, 'Gripping storyline.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (2, 85, 4, 'Unforgettable characters.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (4, 84, 5, 'Highly recommended!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (6, 70, 4, 'Engrossing and immersive.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (5, 126, 2, 'Couldn''t connect with the story.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (8, 207, 3, 'Couldn''t get into it.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (11, 122, 4, 'A literary masterpiece!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (2, 121, 3, 'Engrossing and immersive.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (14, 53, 4, 'Gripping storyline.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (7, 116, 3, 'Not worth the hype.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (2, 142, 3, 'Beautifully written.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (12, 74, 1, 'Not worth the hype.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (7, 183, 1, 'Addictive and suspenseful.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (9, 4, 1, 'Too many plot holes.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (10, 167, 4, 'Unputdownable!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (14, 37, 3, 'Suspenseful and thrilling.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (11, 193, 1, 'Loved the characters!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (8, 192, 1, 'Great book!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (5, 1, 3, 'Couldn''t connect with the writing style.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (12, 194, 5, 'A rollercoaster of emotions!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (14, 84, 4, 'Riveting and intense.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (6, 164, 3, 'Too predictable.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (12, 4, 2, 'Masterfully written.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (9, 144, 5, 'Unique and original.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (9, 11, 4, 'Lacked originality.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (3, 200, 1, 'Unforgettable characters.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (1, 118, 4, 'A must-read!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (9, 127, 2, 'Riveting and intense.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (3, 117, 5, 'Beautifully descriptive.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (9, 63, 2, 'A letdown.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (10, 175, 3, 'Well-developed characters.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (14, 70, 2, 'Unforgettable characters.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (0, 199, 4, 'Compelling and thought-provoking.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (8, 86, 3, 'Underwhelming.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (10, 129, 3, 'Too many plot holes.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (8, 178, 2, 'Highly recommended!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (13, 163, 3, 'Beautifully written.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (12, 49, 1, 'Didn''t resonate with me.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (9, 169, 5, 'A page-turner!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (7, 45, 5, 'Beautifully written.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (11, 143, 5, 'Underwhelming.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (14, 202, 3, 'A rollercoaster of emotions!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (13, 89, 3, 'Didn''t hold my interest.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (3, 130, 2, 'Beautifully written.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (9, 191, 2, 'Addictive and suspenseful.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (9, 34, 4, 'Didn''t hold my interest.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (11, 66, 1, 'Disappointing ending.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (7, 146, 1, 'Compelling and thought-provoking.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (1, 130, 2, 'Unputdownable!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (6, 8, 2, 'Couldn''t get into it.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (13, 140, 1, 'Disappointing ending.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (10, 154, 4, 'Disappointing ending.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (6, 30, 1, 'Expertly crafted.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (7, 51, 1, 'Didn''t hold my interest.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (14, 164, 5, 'Lacked depth.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (10, 90, 3, 'Kept me guessing until the end.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (7, 21, 3, 'Too predictable.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (3, 184, 4, 'Engrossing and immersive.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (0, 146, 2, 'Didn''t hold my interest.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (2, 125, 4, 'Emotionally powerful.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (11, 157, 4, 'Lacked depth.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (10, 64, 3, 'Captivating from start to finish.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (3, 80, 4, 'Couldn''t stop reading!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (2, 162, 2, 'A page-turner!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (0, 186, 3, 'Too predictable.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (7, 93, 2, 'A page-turner!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (7, 124, 5, 'Engrossing and immersive.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (1, 107, 3, 'Compelling and thought-provoking.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (5, 211, 1, 'Suspenseful and thrilling.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (14, 82, 3, 'Highly recommended!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (8, 208, 3, 'Emotionally powerful.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (1, 68, 2, 'Disappointing ending.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (10, 210, 1, 'A page-turner!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (3, 97, 4, 'Thought-provoking.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (5, 86, 2, 'Beautifully descriptive.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (7, 97, 1, 'Underwhelming.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (3, 2, 4, 'Incredible plot twist!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (9, 10, 5, 'Incredible plot twist!') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (8, 98, 3, 'Too predictable.') ON CONFLICT DO NOTHING;
insert  into reviews (user_id, book_id, stars, content) values (2, 68, 1, 'Disappointing ending.') ON CONFLICT DO NOTHING;


insert into reviews (user_id, book_id, stars, content) values (1, 110, 4, 'Captivating from start to finish.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (10, 78, 4, 'Engrossing and immersive.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (0, 162, 4, 'A tour de force.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (8, 53, 3, 'Exceptional storytelling.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (3, 182, 3, 'Deeply satisfying.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (4, 124, 4, 'A book that defies expectations.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (8, 207, 1, 'Deserves all the praise.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (0, 38, 4, 'Awe-inspiring.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (13, 162, 2, 'Perfect balance of humor and drama.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (3, 21, 1, 'Masterpiece!') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (1, 28, 3, 'Emotionally gripping.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (14, 173, 4, 'Awe-inspiring.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (0, 94, 3, 'A thought-provoking exploration.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (5, 124, 2, 'Well-written and engaging.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (6, 48, 5, 'Well-paced and suspenseful.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (7, 64, 4, 'Brilliantly executed.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (14, 35, 5, 'Highly recommended!') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (4, 119, 2, 'A gem of a book.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (10, 51, 4, 'Incredible story!') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (4, 182, 3, 'A gem of a book.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (1, 31, 5, 'Masterpiece!') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (8, 30, 4, 'Unique perspective.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (13, 55, 2, 'Incredible story!') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (12, 113, 2, 'Riveting storyline.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (3, 159, 1, 'Enthralling read.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (2, 81, 4, 'Impressive plot twists.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (7, 90, 4, 'A thought-provoking exploration.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (0, 200, 5, 'Well-paced and suspenseful.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (1, 172, 3, 'A gripping tale.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (14, 80, 5, 'Riveting storyline.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (8, 93, 1, 'A suspenseful and gripping read.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (4, 41, 2, 'A heartwarming story.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (11, 50, 2, 'A rollercoaster of emotions.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (0, 59, 1, 'Compelling narrative.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (3, 180, 5, 'A new favorite.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (3, 56, 4, 'A gem of a book.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (10, 132, 3, 'A book that defies expectations.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (5, 44, 1, 'Incredible story!') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (3, 205, 3, 'A true page-turner.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (6, 99, 1, 'Brilliantly executed.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (6, 195, 5, 'Impressive plot twists.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (9, 51, 1, 'A book that defies expectations.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (8, 8, 5, 'A book that challenges your perspective.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (6, 133, 5, 'Awe-inspiring.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (0, 45, 2, 'A heartwarming story.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (3, 157, 1, 'Great book!') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (5, 100, 3, 'Page-turner!') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (11, 36, 4, 'A book that challenges your perspective.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (11, 131, 4, 'A book that challenges conventions.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (2, 137, 5, 'A book that stays with you.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (13, 148, 3, 'Awe-inspiring.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (0, 144, 4, 'Beautifully crafted characters.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (0, 182, 3, 'Riveting storyline.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (13, 26, 5, 'A heartwarming story.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (3, 182, 4, 'A book that defies expectations.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (13, 172, 2, 'A thrilling adventure.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (14, 119, 1, 'Brilliantly executed.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (9, 162, 4, 'Couldn''t get enough.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (11, 18, 4, 'Unique perspective.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (8, 83, 2, 'A book that sparks conversation.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (11, 31, 3, 'Riveting storyline.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (0, 66, 4, 'A rollercoaster of emotions.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (12, 55, 3, 'A book that challenges your perspective.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (8, 133, 2, 'A delightful surprise.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (13, 180, 5, 'Highly recommended!') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (6, 181, 5, 'A thought-provoking exploration.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (9, 180, 3, 'Couldn''t put it down!') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (8, 105, 3, 'A book that defies expectations.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (0, 177, 2, 'Beautifully crafted characters.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (8, 79, 3, 'Couldn''t put it down!') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (7, 34, 3, 'A book that sheds light on important issues.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (9, 81, 3, 'A thought-provoking exploration.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (2, 107, 3, 'Exquisite prose.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (6, 73, 2, 'Riveting storyline.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (6, 99, 1, 'Compelling narrative.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (13, 58, 4, 'A tour de force.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (2, 15, 2, 'A heartwarming story.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (4, 7, 5, 'A rollercoaster of emotions.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (14, 102, 4, 'Perfect balance of humor and drama.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (5, 159, 5, 'A suspenseful and gripping read.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (0, 163, 4, 'Brilliantly executed.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (14, 116, 2, 'A book that leaves you wanting more.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (4, 73, 1, 'Unforgettable.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (14, 204, 3, 'A tour de force.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (10, 49, 2, 'Deeply satisfying.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (7, 74, 5, 'Loved it!') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (10, 156, 5, 'A captivating journey.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (9, 83, 5, 'Perfect balance of humor and drama.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (8, 210, 3, 'A suspenseful and gripping read.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (11, 96, 4, 'A thrilling adventure.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (10, 86, 1, 'Compelling narrative.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (6, 30, 1, 'A book that transports you.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (4, 21, 1, 'A rollercoaster of emotions.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (9, 56, 3, 'Well-paced and suspenseful.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (2, 24, 3, 'Unforgettable.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (0, 87, 5, 'A book that challenges your perspective.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (3, 5, 3, 'Couldn''t get enough.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (3, 52, 2, 'Loved it!') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (4, 130, 4, 'A book that sheds light on important issues.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (9, 48, 1, 'Beautifully crafted characters.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (12, 33, 4, 'A delightful surprise.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (12, 85, 3, 'Awe-inspiring.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (10, 22, 2, 'Couldn''t put it down!') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (14, 29, 5, 'Well-paced and suspenseful.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (10, 38, 2, 'Thought-provoking.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (13, 140, 4, 'Emotionally gripping.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (10, 88, 1, 'A book that tugs at the heartstrings.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (3, 192, 5, 'A tour de force.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (2, 204, 3, 'A book that sparks conversation.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (11, 105, 2, 'Engrossing and immersive.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (3, 165, 5, 'Unique perspective.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (5, 152, 4, 'Brilliantly executed.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (11, 59, 4, 'Unforgettable.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (10, 61, 5, 'A captivating journey.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (10, 35, 1, 'A book that stays with you.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (3, 174, 3, 'Powerful and moving.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (13, 88, 3, 'A book that tugs at the heartstrings.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (12, 50, 4, 'Emotionally gripping.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (9, 92, 3, 'Will definitely read again.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (8, 13, 4, 'Deserves all the praise.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (2, 168, 5, 'Captivating from start to finish.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (8, 172, 2, 'Compelling narrative.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (11, 66, 1, 'A tour de force.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (11, 5, 1, 'Great book!') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (5, 38, 1, 'Captivating from start to finish.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (0, 101, 2, 'Captivating from start to finish.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (1, 42, 1, 'A book that makes you think.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (2, 127, 2, 'A must-read!') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (14, 159, 5, 'A gripping tale.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (8, 8, 3, 'A tour de force.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (12, 157, 5, 'Compelling narrative.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (9, 166, 3, 'Deeply satisfying.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (2, 73, 1, 'A tour de force.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (12, 24, 1, 'Loved it!') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (2, 102, 1, 'A book that leaves you wanting more.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (7, 43, 2, 'A gem of a book.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (9, 79, 5, 'Emotionally gripping.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (4, 50, 1, 'A must-read!') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (14, 185, 4, 'A book that stays with you.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (13, 162, 3, 'Compelling narrative.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (0, 74, 4, 'Couldn''t get enough.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (9, 96, 4, 'Couldn''t put it down!') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (3, 12, 3, 'A beautifully written gem.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (14, 139, 5, 'A book that inspires.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (12, 162, 3, 'A book that leaves you wanting more.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (3, 41, 4, 'A new favorite.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (9, 10, 1, 'A book that inspires.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (6, 195, 1, 'A book that tugs at the heartstrings.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (12, 52, 5, 'A book that challenges your perspective.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (2, 154, 3, 'A beautifully written gem.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (13, 184, 3, 'Compelling narrative.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (0, 122, 4, 'Unforgettable.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (3, 36, 2, 'Masterpiece!') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (8, 59, 1, 'A gem of a book.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (10, 39, 1, 'Brilliantly executed.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (8, 102, 3, 'Unique perspective.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (2, 62, 4, 'Brilliantly executed.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (8, 42, 1, 'Great book!') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (9, 90, 3, 'Deeply satisfying.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (5, 127, 2, 'Well-paced and suspenseful.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (4, 150, 2, 'Will definitely read again.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (13, 181, 4, 'A gripping tale.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (0, 190, 3, 'A book that sparks conversation.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (6, 105, 3, 'A thought-provoking exploration.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (9, 206, 1, 'Well-paced and suspenseful.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (11, 65, 5, 'Exceptional storytelling.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (14, 157, 3, 'Unique perspective.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (2, 85, 5, 'Incredible story!') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (3, 154, 4, 'A rollercoaster of emotions.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (14, 140, 2, 'Exceptional storytelling.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (9, 163, 5, 'Great book!') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (8, 169, 3, 'Impressive plot twists.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (12, 164, 5, 'Riveting storyline.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (14, 42, 2, 'A book that makes you think.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (1, 194, 2, 'Impressive plot twists.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (9, 114, 4, 'Deeply satisfying.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (8, 39, 2, 'Incredible story!') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (3, 25, 2, 'A book that sparks conversation.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (5, 87, 2, 'A literary triumph.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (0, 108, 5, 'A tour de force.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (2, 9, 1, 'A book that sparks conversation.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (4, 23, 1, 'Thought-provoking.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (5, 196, 3, 'A rollercoaster of emotions.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (7, 17, 5, 'Masterpiece!') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (5, 85, 3, 'A tour de force.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (2, 108, 3, 'Deeply satisfying.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (1, 35, 3, 'Enthralling read.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (5, 16, 2, 'Highly original.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (8, 152, 2, 'Riveting storyline.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (0, 17, 2, 'A book that stays with you.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (0, 5, 1, 'A book that challenges conventions.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (10, 198, 1, 'A gripping tale.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (6, 2, 4, 'A book that defies expectations.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (11, 41, 2, 'Emotionally gripping.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (5, 179, 3, 'Highly recommended!') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (13, 45, 3, 'A rollercoaster of emotions.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (11, 70, 3, 'A book that sheds light on important issues.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (10, 44, 5, 'A book that challenges conventions.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (2, 38, 5, 'A must-read!') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (0, 199, 2, 'A captivating journey.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (6, 81, 1, 'Brilliantly executed.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (3, 202, 3, 'Well-paced and suspenseful.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (3, 30, 1, 'Emotionally gripping.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (2, 145, 2, 'Enthralling read.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (6, 181, 2, 'Unforgettable.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (7, 211, 1, 'Awe-inspiring.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (4, 80, 4, 'Emotionally gripping.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (11, 1, 5, 'Brilliantly executed.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (6, 183, 1, 'Masterpiece!') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (11, 59, 4, 'A delightful surprise.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (2, 77, 5, 'A book that challenges your perspective.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (12, 100, 2, 'Well-paced and suspenseful.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (11, 163, 4, 'Compelling narrative.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (8, 95, 5, 'Powerful and moving.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (2, 204, 3, 'Masterpiece!') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (12, 6, 3, 'A book that tugs at the heartstrings.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (0, 46, 3, 'A book that makes you think.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (9, 151, 5, 'Incredible story!') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (0, 173, 3, 'Loved it!') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (4, 107, 1, 'A book that tugs at the heartstrings.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (8, 161, 1, 'Engrossing and immersive.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (11, 171, 5, 'Great book!') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (12, 141, 5, 'A book that challenges your perspective.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (1, 189, 4, 'A thrilling adventure.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (4, 49, 1, 'A book that inspires.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (3, 44, 3, 'A gripping tale.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (7, 64, 1, 'A beautifully written gem.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (0, 122, 3, 'Beautifully crafted characters.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (13, 128, 2, 'Exquisite prose.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (8, 133, 4, 'Well-written and engaging.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (14, 153, 3, 'A thought-provoking exploration.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (8, 32, 1, 'A book that sparks conversation.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (1, 208, 1, 'A book that transports you.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (1, 132, 2, 'Compelling narrative.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (0, 28, 1, 'A book that challenges conventions.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (9, 40, 4, 'Loved it!') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (11, 6, 3, 'A thought-provoking exploration.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (1, 194, 2, 'Expertly researched.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (2, 180, 1, 'Unique perspective.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (8, 19, 4, 'A must-read!') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (11, 48, 5, 'Emotionally gripping.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (13, 134, 2, 'A book that inspires.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (11, 83, 1, 'Couldn''t put it down!') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (8, 140, 2, 'Will definitely read again.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (6, 114, 3, 'Exquisite prose.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (3, 2, 4, 'Couldn''t get enough.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (5, 90, 4, 'Captivating from start to finish.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (0, 174, 1, 'Captivating from start to finish.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (14, 119, 5, 'Impressive plot twists.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (1, 193, 3, 'Impressive plot twists.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (5, 144, 5, 'A book that transports you.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (1, 170, 4, 'Great book!') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (11, 54, 4, 'A book that transports you.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (4, 11, 4, 'Unforgettable.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (12, 55, 4, 'A book that makes you think.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (14, 23, 4, 'A book that tugs at the heartstrings.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (6, 192, 1, 'A beautifully written gem.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (8, 198, 5, 'A book that inspires.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (11, 148, 4, 'Perfect balance of humor and drama.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (7, 33, 4, 'A heartwarming story.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (9, 130, 1, 'Expertly researched.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (7, 31, 2, 'A gem of a book.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (11, 89, 2, 'A must-read!') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (14, 151, 2, 'Couldn''t get enough.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (9, 101, 2, 'Great book!') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (0, 123, 2, 'Incredible story!') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (8, 176, 2, 'Awe-inspiring.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (2, 32, 4, 'A captivating journey.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (12, 65, 2, 'A book that sparks conversation.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (5, 85, 1, 'Enthralling read.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (5, 53, 1, 'Loved it!') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (7, 160, 1, 'Well-paced and suspenseful.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (5, 125, 4, 'A thought-provoking exploration.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (13, 146, 2, 'A book that transports you.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (14, 167, 4, 'A suspenseful and gripping read.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (11, 84, 5, 'Enthralling read.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (1, 88, 1, 'Highly original.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (8, 54, 5, 'Compelling narrative.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (4, 209, 5, 'A book that transports you.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (14, 7, 1, 'Perfect balance of humor and drama.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (10, 140, 3, 'Couldn''t put it down!') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (8, 63, 3, 'Emotionally gripping.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (8, 173, 4, 'A heartwarming story.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (14, 35, 2, 'A must-read!') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (4, 79, 5, 'A book that inspires.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (1, 107, 3, 'Will definitely read again.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (0, 205, 5, 'Perfect balance of humor and drama.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (2, 192, 5, 'Captivating from start to finish.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (5, 41, 4, 'A tour de force.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (14, 74, 4, 'Highly original.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (1, 11, 4, 'A book that makes you think.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (9, 138, 3, 'A book that defies expectations.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (7, 10, 3, 'Incredible story!') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (13, 128, 3, 'Unique perspective.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (8, 31, 5, 'A book that sheds light on important issues.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (1, 65, 4, 'A captivating journey.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (12, 199, 2, 'A thrilling adventure.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (9, 174, 5, 'A book that challenges conventions.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (7, 208, 4, 'Perfect balance of humor and drama.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (13, 65, 1, 'A suspenseful and gripping read.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (8, 71, 2, 'Enthralling read.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (4, 132, 1, 'Unforgettable.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (10, 13, 3, 'A book that challenges your perspective.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (14, 75, 1, 'A book that sparks conversation.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (13, 129, 4, 'Well-paced and suspenseful.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (0, 82, 2, 'A thrilling adventure.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (13, 179, 5, 'A tour de force.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (14, 106, 1, 'Beautifully crafted characters.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (6, 1, 3, 'A book that sheds light on important issues.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (7, 110, 2, 'Emotionally gripping.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (8, 76, 2, 'Masterpiece!') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (6, 37, 2, 'A beautifully written gem.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (7, 29, 5, 'A beautifully written gem.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (6, 61, 1, 'A book that challenges your perspective.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (2, 90, 3, 'A thought-provoking exploration.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (2, 37, 3, 'Deserves all the praise.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (0, 63, 4, 'Captivating from start to finish.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (11, 101, 2, 'Compelling narrative.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (13, 47, 5, 'Well-paced and suspenseful.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (9, 136, 2, 'Brilliantly executed.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (11, 165, 4, 'Well-written and engaging.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (3, 73, 2, 'Deeply satisfying.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (6, 53, 3, 'Powerful and moving.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (3, 43, 3, 'Riveting storyline.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (9, 133, 1, 'Exquisite prose.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (3, 95, 5, 'Emotionally gripping.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (10, 136, 1, 'Couldn''t put it down!') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (4, 106, 1, 'A new favorite.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (7, 154, 1, 'Beautifully crafted characters.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (1, 108, 5, 'A book that tugs at the heartstrings.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (11, 210, 1, 'A must-read!') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (13, 90, 5, 'Emotionally gripping.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (9, 106, 2, 'A book that sparks conversation.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (12, 32, 4, 'A captivating journey.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (1, 131, 4, 'A rollercoaster of emotions.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (6, 12, 5, 'Highly recommended!') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (8, 2, 5, 'Unforgettable.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (8, 27, 3, 'A book that tugs at the heartstrings.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (4, 131, 2, 'Highly original.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (1, 125, 1, 'Compelling narrative.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (14, 57, 4, 'A gripping tale.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (5, 173, 5, 'A gripping tale.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (6, 38, 1, 'A heartwarming story.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (11, 84, 2, 'Unique perspective.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (4, 208, 1, 'Awe-inspiring.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (4, 146, 2, 'Powerful and moving.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (8, 64, 1, 'Engrossing and immersive.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (12, 180, 4, 'Exceptional storytelling.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (8, 172, 3, 'A book that stays with you.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (7, 185, 1, 'Perfect balance of humor and drama.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (5, 15, 2, 'A book that makes you think.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (0, 19, 2, 'A book that sheds light on important issues.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (1, 187, 5, 'A book that challenges conventions.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (9, 99, 3, 'Exceptional storytelling.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (6, 172, 4, 'Highly original.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (12, 105, 1, 'Couldn''t put it down!') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (4, 42, 5, 'A book that sheds light on important issues.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (1, 56, 1, 'Impressive plot twists.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (7, 171, 4, 'Loved it!') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (6, 78, 2, 'A book that leaves you wanting more.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (9, 23, 1, 'Unforgettable.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (2, 207, 5, 'Beautifully crafted characters.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (0, 153, 1, 'A book that inspires.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (1, 178, 4, 'Well-paced and suspenseful.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (12, 132, 4, 'A delightful surprise.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (7, 146, 5, 'Brilliantly executed.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (3, 72, 2, 'Brilliantly executed.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (5, 177, 2, 'Great book!') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (0, 143, 1, 'Loved it!') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (8, 13, 4, 'Well-written and engaging.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (7, 190, 2, 'A rollercoaster of emotions.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (0, 184, 4, 'Powerful and moving.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (1, 126, 1, 'A book that transports you.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (7, 51, 3, 'A true page-turner.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (9, 74, 3, 'Exceptional storytelling.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (2, 122, 4, 'A delightful surprise.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (4, 150, 1, 'A must-read!') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (1, 109, 3, 'Will definitely read again.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (7, 135, 2, 'Well-paced and suspenseful.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (14, 136, 5, 'Unforgettable.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (7, 67, 5, 'Unforgettable.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (11, 200, 3, 'Highly recommended!') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (2, 156, 5, 'A rollercoaster of emotions.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (6, 60, 5, 'Well-paced and suspenseful.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (5, 183, 2, 'Great book!') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (6, 191, 1, 'A book that tugs at the heartstrings.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (7, 121, 2, 'Will definitely read again.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (8, 82, 1, 'Emotionally gripping.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (8, 13, 1, 'A book that challenges your perspective.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (7, 152, 2, 'A book that inspires.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (12, 85, 5, 'A book that makes you think.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (9, 71, 4, 'Unique perspective.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (2, 60, 3, 'Thought-provoking.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (8, 31, 1, 'Unforgettable.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (13, 6, 4, 'A tour de force.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (5, 187, 5, 'A book that leaves you wanting more.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (7, 60, 1, 'Impressive plot twists.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (3, 158, 3, 'A book that tugs at the heartstrings.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (3, 60, 3, 'Masterpiece!') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (13, 98, 4, 'A gem of a book.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (1, 128, 5, 'Highly recommended!') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (5, 96, 2, 'Awe-inspiring.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (5, 136, 1, 'A book that tugs at the heartstrings.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (7, 147, 5, 'Page-turner!') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (4, 74, 4, 'Impressive plot twists.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (11, 145, 3, 'Awe-inspiring.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (4, 151, 3, 'Page-turner!') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (6, 132, 4, 'A delightful surprise.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (6, 70, 2, 'A literary triumph.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (14, 143, 3, 'A book that makes you think.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (14, 187, 2, 'A gripping tale.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (1, 45, 1, 'Will definitely read again.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (9, 133, 2, 'Deeply satisfying.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (5, 163, 1, 'Incredible story!') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (5, 15, 5, 'Highly original.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (4, 135, 5, 'Will definitely read again.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (13, 145, 2, 'A book that challenges your perspective.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (1, 77, 1, 'Unforgettable.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (10, 84, 2, 'A book that inspires.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (1, 33, 5, 'Masterpiece!') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (9, 3, 5, 'Emotionally gripping.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (12, 2, 3, 'Exquisite prose.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (14, 93, 5, 'Riveting storyline.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (7, 127, 2, 'A book that transports you.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (10, 48, 5, 'Unforgettable.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (8, 211, 1, 'A book that inspires.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (0, 36, 4, 'A beautifully written gem.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (6, 187, 1, 'Captivating from start to finish.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (3, 149, 3, 'Perfect balance of humor and drama.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (13, 161, 2, 'A new favorite.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (13, 25, 1, 'Impressive plot twists.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (6, 138, 2, 'A literary triumph.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (4, 65, 4, 'A new favorite.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (3, 105, 3, 'A book that transports you.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (11, 160, 5, 'A book that sheds light on important issues.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (13, 105, 2, 'A suspenseful and gripping read.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (0, 55, 3, 'A literary triumph.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (3, 49, 3, 'Captivating from start to finish.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (5, 174, 3, 'A book that stays with you.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (14, 175, 2, 'Couldn''t get enough.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (13, 56, 5, 'Impressive plot twists.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (3, 12, 5, 'A book that makes you think.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (7, 30, 2, 'A book that sheds light on important issues.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (11, 107, 2, 'Perfect balance of humor and drama.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (8, 116, 1, 'Deeply satisfying.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (3, 152, 2, 'A heartwarming story.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (10, 144, 3, 'Captivating from start to finish.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (9, 199, 2, 'Deserves all the praise.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (7, 32, 3, 'Great book!') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (7, 163, 1, 'Will definitely read again.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (4, 140, 1, 'A book that challenges conventions.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (0, 109, 5, 'Highly recommended!') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (5, 171, 1, 'Will definitely read again.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (6, 28, 1, 'A book that sheds light on important issues.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (1, 187, 1, 'A delightful surprise.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (12, 186, 3, 'Page-turner!') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (0, 82, 2, 'Enthralling read.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (6, 143, 1, 'A true page-turner.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (0, 101, 4, 'Awe-inspiring.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (4, 44, 1, 'A book that sparks conversation.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (13, 164, 1, 'Captivating from start to finish.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (3, 91, 5, 'A thrilling adventure.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (9, 47, 3, 'Beautifully crafted characters.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (11, 78, 2, 'Deserves all the praise.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (13, 47, 3, 'Powerful and moving.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (12, 3, 4, 'Brilliantly executed.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (0, 193, 4, 'Couldn''t put it down!') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (5, 189, 2, 'Couldn''t get enough.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (8, 41, 3, 'A true page-turner.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (13, 198, 5, 'Expertly researched.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (8, 90, 3, 'A tour de force.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (4, 163, 5, 'A rollercoaster of emotions.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (4, 120, 2, 'A book that inspires.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (3, 35, 5, 'Powerful and moving.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (8, 89, 4, 'Masterpiece!') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (0, 114, 3, 'Brilliantly executed.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (6, 28, 5, 'Highly original.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (11, 69, 5, 'Page-turner!') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (13, 66, 4, 'Exquisite prose.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (8, 47, 2, 'Expertly researched.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (3, 6, 3, 'Couldn''t get enough.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (10, 24, 4, 'Riveting storyline.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (14, 108, 2, 'Riveting storyline.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (1, 28, 3, 'Deserves all the praise.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (1, 133, 2, 'Unique perspective.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (8, 190, 2, 'A thought-provoking exploration.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (4, 112, 3, 'Enthralling read.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (7, 11, 3, 'A thrilling adventure.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (8, 198, 5, 'Well-paced and suspenseful.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (4, 12, 1, 'A suspenseful and gripping read.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (6, 74, 5, 'Perfect balance of humor and drama.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (8, 75, 3, 'Brilliantly executed.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (12, 200, 4, 'A book that sparks conversation.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (12, 87, 5, 'Unforgettable.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (11, 186, 5, 'A book that sparks conversation.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (14, 129, 5, 'Deserves all the praise.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (4, 14, 3, 'A beautifully written gem.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (10, 115, 3, 'A book that challenges your perspective.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (13, 104, 5, 'A book that leaves you wanting more.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (5, 76, 5, 'A book that sheds light on important issues.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (7, 33, 4, 'A book that makes you think.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (1, 90, 4, 'A thrilling adventure.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (8, 133, 1, 'Unforgettable.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (9, 98, 2, 'A book that tugs at the heartstrings.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (11, 65, 4, 'A beautifully written gem.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (0, 6, 3, 'Unforgettable.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (12, 159, 2, 'Page-turner!') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (6, 50, 1, 'Deeply satisfying.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (1, 203, 4, 'Impressive plot twists.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (4, 36, 2, 'Exquisite prose.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (4, 162, 2, 'A captivating journey.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (9, 211, 4, 'Loved it!') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (10, 202, 2, 'A delightful surprise.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (12, 180, 1, 'A heartwarming story.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (4, 183, 3, 'Exceptional storytelling.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (14, 84, 4, 'Exceptional storytelling.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (14, 67, 1, 'Unforgettable.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (4, 118, 1, 'A thought-provoking exploration.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (8, 93, 4, 'Page-turner!') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (1, 3, 2, 'Masterpiece!') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (9, 60, 3, 'A must-read!') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (1, 180, 2, 'Beautifully crafted characters.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (9, 85, 4, 'Well-paced and suspenseful.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (6, 86, 2, 'A true page-turner.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (3, 194, 1, 'Captivating from start to finish.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (12, 131, 3, 'Enthralling read.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (2, 147, 3, 'Engrossing and immersive.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (6, 15, 3, 'A book that challenges your perspective.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (3, 193, 1, 'Couldn''t get enough.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (6, 18, 2, 'Great book!') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (0, 65, 1, 'Emotionally gripping.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (14, 136, 1, 'Well-written and engaging.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (4, 205, 3, 'A book that defies expectations.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (0, 130, 2, 'Unique perspective.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (9, 29, 2, 'A book that defies expectations.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (9, 156, 5, 'Deeply satisfying.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (3, 192, 5, 'Unforgettable.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (12, 182, 5, 'A true page-turner.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (9, 159, 3, 'Brilliantly executed.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (4, 126, 3, 'Unique perspective.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (7, 38, 4, 'A book that makes you think.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (0, 87, 2, 'Unique perspective.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (6, 180, 4, 'Couldn''t get enough.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (1, 64, 1, 'A captivating journey.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (1, 165, 3, 'Engrossing and immersive.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (9, 22, 1, 'A captivating journey.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (6, 96, 1, 'Expertly researched.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (7, 68, 3, 'Thought-provoking.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (14, 133, 2, 'Expertly researched.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (7, 22, 3, 'Well-paced and suspenseful.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (10, 188, 2, 'Awe-inspiring.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (5, 100, 1, 'Highly recommended!') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (12, 125, 4, 'A gripping tale.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (10, 41, 2, 'Highly recommended!') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (5, 195, 2, 'A delightful surprise.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (1, 81, 5, 'A book that inspires.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (9, 53, 2, 'Well-paced and suspenseful.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (4, 148, 5, 'A book that stays with you.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (11, 211, 5, 'Exquisite prose.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (4, 105, 5, 'A thought-provoking exploration.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (2, 123, 3, 'A book that challenges your perspective.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (13, 44, 5, 'A gem of a book.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (14, 84, 1, 'A captivating journey.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (7, 75, 5, 'A book that challenges your perspective.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (14, 47, 3, 'A book that leaves you wanting more.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (1, 149, 2, 'Couldn''t put it down!') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (1, 130, 3, 'Emotionally gripping.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (9, 180, 5, 'A gripping tale.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (1, 142, 5, 'Exceptional storytelling.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (9, 79, 5, 'Beautifully crafted characters.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (4, 26, 3, 'Loved it!') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (7, 26, 1, 'A captivating journey.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (2, 72, 3, 'Exceptional storytelling.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (12, 167, 3, 'Will definitely read again.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (10, 32, 3, 'A book that transports you.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (6, 69, 3, 'Highly recommended!') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (3, 197, 4, 'Deeply satisfying.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (7, 38, 1, 'Perfect balance of humor and drama.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (12, 24, 4, 'A true page-turner.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (7, 150, 4, 'A book that stays with you.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (4, 46, 3, 'A gem of a book.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (11, 128, 2, 'A rollercoaster of emotions.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (2, 119, 1, 'A book that transports you.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (14, 181, 1, 'A book that tugs at the heartstrings.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (0, 30, 5, 'Riveting storyline.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (7, 77, 2, 'Brilliantly executed.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (3, 162, 2, 'A must-read!') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (0, 95, 1, 'Masterpiece!') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (6, 129, 3, 'Deeply satisfying.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (14, 181, 1, 'A beautifully written gem.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (6, 147, 5, 'Impressive plot twists.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (2, 144, 2, 'A heartwarming story.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (6, 86, 4, 'Unique perspective.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (7, 56, 1, 'Brilliantly executed.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (11, 42, 3, 'A must-read!') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (10, 27, 3, 'A book that challenges conventions.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (13, 106, 1, 'Riveting storyline.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (12, 58, 1, 'A book that sparks conversation.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (7, 20, 2, 'A beautifully written gem.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (10, 192, 3, 'Deeply satisfying.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (0, 126, 3, 'Exquisite prose.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (9, 116, 3, 'A book that makes you think.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (5, 209, 4, 'A new favorite.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (3, 59, 5, 'A gem of a book.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (3, 73, 2, 'A new favorite.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (2, 105, 3, 'Enthralling read.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (6, 25, 3, 'Engrossing and immersive.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (12, 106, 2, 'Loved it!') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (10, 133, 5, 'Well-written and engaging.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (7, 38, 1, 'Brilliantly executed.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (6, 125, 1, 'Incredible story!') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (6, 93, 1, 'A heartwarming story.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (10, 187, 5, 'Brilliantly executed.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (14, 171, 4, 'A book that defies expectations.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (5, 159, 3, 'A must-read!') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (3, 173, 3, 'A new favorite.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (3, 43, 5, 'Compelling narrative.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (11, 179, 2, 'Engrossing and immersive.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (8, 137, 1, 'Will definitely read again.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (14, 172, 4, 'Enthralling read.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (5, 24, 2, 'Captivating from start to finish.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (3, 131, 3, 'Emotionally gripping.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (8, 180, 2, 'Emotionally gripping.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (14, 208, 3, 'Great book!') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (8, 73, 4, 'Couldn''t put it down!') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (14, 61, 5, 'Exquisite prose.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (10, 106, 3, 'Page-turner!') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (5, 12, 1, 'A literary triumph.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (13, 155, 4, 'Couldn''t put it down!') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (8, 45, 1, 'A true page-turner.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (8, 22, 4, 'A book that inspires.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (8, 181, 2, 'A thrilling adventure.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (12, 90, 1, 'Emotionally gripping.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (13, 117, 5, 'A thought-provoking exploration.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (1, 80, 1, 'Well-paced and suspenseful.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (2, 52, 2, 'Deserves all the praise.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (2, 187, 5, 'A delightful surprise.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (10, 204, 3, 'Highly original.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (1, 59, 5, 'A book that tugs at the heartstrings.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (10, 128, 5, 'Awe-inspiring.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (12, 169, 2, 'A book that tugs at the heartstrings.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (4, 10, 3, 'Page-turner!') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (8, 109, 2, 'A gem of a book.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (13, 140, 2, 'A must-read!') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (8, 154, 5, 'Captivating from start to finish.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (0, 166, 2, 'Page-turner!') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (5, 174, 5, 'Couldn''t put it down!') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (3, 171, 5, 'Engrossing and immersive.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (9, 57, 3, 'A book that makes you think.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (4, 72, 1, 'Awe-inspiring.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (1, 156, 5, 'Riveting storyline.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (7, 32, 5, 'Exquisite prose.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (3, 7, 1, 'A book that defies expectations.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (14, 166, 1, 'Loved it!') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (0, 108, 4, 'Captivating from start to finish.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (14, 12, 4, 'A gripping tale.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (13, 52, 2, 'A book that sparks conversation.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (5, 83, 4, 'Thought-provoking.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (14, 81, 1, 'A book that makes you think.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (10, 32, 5, 'A true page-turner.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (3, 32, 4, 'Page-turner!') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (4, 166, 4, 'A true page-turner.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (5, 30, 2, 'Impressive plot twists.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (9, 72, 5, 'Perfect balance of humor and drama.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (13, 63, 2, 'A book that transports you.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (6, 75, 1, 'Emotionally gripping.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (12, 168, 2, 'A delightful surprise.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (0, 102, 4, 'A book that defies expectations.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (0, 95, 2, 'A book that defies expectations.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (9, 35, 5, 'A true page-turner.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (14, 211, 4, 'A book that sheds light on important issues.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (13, 141, 1, 'A book that sheds light on important issues.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (1, 72, 1, 'Thought-provoking.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (9, 85, 2, 'Loved it!') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (0, 165, 4, 'Riveting storyline.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (2, 70, 5, 'Exquisite prose.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (3, 94, 5, 'A book that challenges your perspective.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (2, 141, 5, 'Engrossing and immersive.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (10, 75, 1, 'Page-turner!') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (12, 43, 2, 'A rollercoaster of emotions.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (12, 24, 5, 'Thought-provoking.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (6, 203, 5, 'A book that challenges your perspective.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (8, 118, 4, 'Loved it!') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (3, 118, 1, 'Impressive plot twists.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (9, 194, 2, 'Well-paced and suspenseful.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (5, 157, 1, 'A thought-provoking exploration.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (5, 106, 2, 'A book that sparks conversation.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (1, 3, 1, 'A book that makes you think.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (3, 41, 5, 'Brilliantly executed.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (14, 56, 3, 'A book that challenges conventions.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (10, 110, 2, 'A book that sheds light on important issues.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (13, 187, 3, 'Captivating from start to finish.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (12, 183, 5, 'Expertly researched.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (6, 5, 3, 'Deeply satisfying.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (8, 68, 4, 'A beautifully written gem.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (6, 170, 4, 'Emotionally gripping.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (13, 121, 2, 'Impressive plot twists.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (1, 71, 2, 'Couldn''t put it down!') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (8, 64, 1, 'A book that challenges conventions.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (4, 43, 4, 'Will definitely read again.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (0, 58, 2, 'Impressive plot twists.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (1, 12, 2, 'A thrilling adventure.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (8, 71, 5, 'A book that challenges your perspective.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (12, 111, 5, 'Engrossing and immersive.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (12, 158, 2, 'Masterpiece!') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (12, 50, 1, 'Brilliantly executed.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (2, 151, 5, 'Captivating from start to finish.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (7, 166, 5, 'A must-read!') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (7, 124, 1, 'Great book!') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (14, 155, 5, 'Brilliantly executed.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (12, 152, 1, 'A rollercoaster of emotions.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (7, 48, 3, 'Highly original.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (4, 44, 3, 'A true page-turner.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (3, 13, 3, 'Well-paced and suspenseful.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (10, 65, 4, 'Perfect balance of humor and drama.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (7, 94, 3, 'A book that challenges your perspective.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (12, 197, 4, 'A gripping tale.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (3, 211, 5, 'Highly recommended!') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (9, 166, 2, 'Well-written and engaging.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (3, 67, 5, 'A must-read!') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (8, 62, 3, 'A must-read!') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (13, 116, 4, 'Couldn''t get enough.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (11, 144, 3, 'Enthralling read.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (10, 112, 5, 'Unforgettable.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (0, 33, 2, 'Incredible story!') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (6, 148, 3, 'A book that sparks conversation.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (5, 111, 5, 'A gripping tale.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (10, 160, 3, 'A tour de force.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (4, 51, 2, 'A suspenseful and gripping read.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (5, 8, 3, 'A book that transports you.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (9, 68, 1, 'Thought-provoking.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (14, 12, 4, 'Brilliantly executed.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (11, 87, 3, 'Highly original.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (12, 157, 5, 'Beautifully crafted characters.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (7, 137, 2, 'Exquisite prose.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (7, 90, 4, 'A must-read!') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (3, 163, 1, 'Emotionally gripping.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (7, 72, 2, 'A new favorite.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (13, 38, 2, 'A delightful surprise.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (11, 174, 5, 'Enthralling read.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (11, 144, 2, 'A literary triumph.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (8, 179, 1, 'A must-read!') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (13, 97, 4, 'A heartwarming story.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (8, 58, 2, 'Unforgettable.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (9, 99, 3, 'Highly original.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (1, 3, 2, 'A rollercoaster of emotions.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (3, 141, 2, 'Highly original.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (6, 153, 5, 'Engrossing and immersive.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (9, 207, 2, 'Emotionally gripping.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (9, 94, 3, 'Highly original.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (6, 39, 4, 'A book that inspires.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (6, 106, 1, 'A captivating journey.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (1, 5, 3, 'A must-read!') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (8, 123, 2, 'A true page-turner.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (14, 71, 3, 'Loved it!') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (1, 148, 4, 'Exceptional storytelling.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (13, 156, 4, 'A book that tugs at the heartstrings.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (1, 75, 4, 'Compelling narrative.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (3, 134, 4, 'A new favorite.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (3, 205, 4, 'A must-read!') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (6, 76, 4, 'Exceptional storytelling.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (1, 147, 4, 'Well-written and engaging.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (1, 116, 3, 'A book that sheds light on important issues.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (8, 45, 3, 'A book that stays with you.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (2, 109, 3, 'Enthralling read.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (7, 128, 3, 'A beautifully written gem.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (3, 179, 2, 'Beautifully crafted characters.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (8, 99, 2, 'A suspenseful and gripping read.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (0, 116, 3, 'A thrilling adventure.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (8, 125, 3, 'Couldn''t get enough.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (6, 211, 3, 'A must-read!') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (14, 36, 4, 'Unforgettable.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (0, 111, 5, 'A book that sparks conversation.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (1, 49, 5, 'A suspenseful and gripping read.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (10, 91, 4, 'Exquisite prose.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (7, 139, 5, 'A thrilling adventure.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (13, 125, 2, 'Deeply satisfying.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (6, 176, 2, 'Will definitely read again.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (7, 167, 1, 'Compelling narrative.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (11, 81, 1, 'Enthralling read.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (6, 194, 1, 'A suspenseful and gripping read.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (6, 21, 1, 'A thought-provoking exploration.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (12, 64, 4, 'A book that stays with you.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (4, 172, 4, 'A heartwarming story.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (10, 88, 2, 'Unique perspective.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (8, 1, 1, 'A true page-turner.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (12, 186, 4, 'Engrossing and immersive.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (2, 24, 3, 'Loved it!') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (1, 161, 5, 'A tour de force.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (9, 117, 1, 'Brilliantly executed.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (6, 106, 4, 'A book that sheds light on important issues.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (12, 150, 3, 'Brilliantly executed.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (5, 16, 2, 'A gem of a book.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (7, 130, 2, 'A literary triumph.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (13, 166, 2, 'Exceptional storytelling.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (7, 25, 5, 'Well-paced and suspenseful.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (2, 36, 3, 'A book that sparks conversation.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (4, 36, 2, 'Couldn''t get enough.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (7, 72, 4, 'A book that transports you.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (3, 202, 3, 'Enthralling read.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (5, 77, 3, 'A book that transports you.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (11, 172, 1, 'A gem of a book.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (6, 72, 5, 'A thought-provoking exploration.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (6, 143, 4, 'A book that sparks conversation.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (5, 88, 3, 'Beautifully crafted characters.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (7, 61, 5, 'Compelling narrative.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (14, 43, 1, 'A rollercoaster of emotions.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (2, 80, 2, 'A rollercoaster of emotions.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (8, 206, 1, 'A new favorite.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (13, 88, 2, 'Enthralling read.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (9, 59, 2, 'Highly original.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (6, 4, 4, 'A book that inspires.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (0, 131, 5, 'A book that defies expectations.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (14, 113, 5, 'Exquisite prose.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (3, 53, 4, 'A book that challenges your perspective.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (8, 24, 1, 'A book that transports you.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (11, 187, 1, 'Compelling narrative.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (7, 72, 3, 'Perfect balance of humor and drama.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (13, 164, 5, 'Compelling narrative.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (5, 141, 2, 'A book that sparks conversation.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (14, 91, 5, 'A book that tugs at the heartstrings.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (11, 71, 4, 'Deserves all the praise.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (2, 77, 4, 'A captivating journey.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (5, 128, 2, 'Emotionally gripping.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (4, 136, 5, 'A captivating journey.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (1, 127, 3, 'Couldn''t put it down!') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (0, 105, 3, 'A thrilling adventure.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (11, 13, 1, 'Unique perspective.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (3, 37, 4, 'A rollercoaster of emotions.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (14, 23, 2, 'A tour de force.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (3, 58, 5, 'A heartwarming story.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (10, 207, 3, 'Brilliantly executed.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (4, 211, 4, 'A suspenseful and gripping read.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (14, 127, 4, 'A literary triumph.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (1, 15, 4, 'A must-read!') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (2, 81, 1, 'Thought-provoking.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (1, 95, 5, 'A book that transports you.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (5, 206, 1, 'A gripping tale.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (9, 176, 2, 'Great book!') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (4, 38, 2, 'Compelling narrative.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (14, 167, 1, 'A gripping tale.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (8, 140, 4, 'Enthralling read.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (8, 76, 2, 'A captivating journey.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (0, 34, 5, 'Well-written and engaging.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (12, 48, 5, 'A book that sparks conversation.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (9, 152, 5, 'A delightful surprise.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (10, 120, 1, 'A book that leaves you wanting more.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (1, 160, 2, 'A book that stays with you.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (5, 4, 3, 'A book that challenges your perspective.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (3, 70, 1, 'Impressive plot twists.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (4, 114, 1, 'A book that sparks conversation.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (7, 191, 4, 'Exceptional storytelling.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (14, 39, 4, 'Masterpiece!') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (11, 152, 5, 'Brilliantly executed.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (0, 21, 2, 'A book that leaves you wanting more.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (13, 114, 5, 'Awe-inspiring.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (8, 142, 5, 'A book that challenges your perspective.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (10, 80, 1, 'Loved it!') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (11, 134, 5, 'Unforgettable.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (3, 150, 5, 'A book that inspires.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (8, 29, 4, 'Enthralling read.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (6, 46, 1, 'Couldn''t get enough.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (7, 29, 2, 'Engrossing and immersive.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (5, 208, 3, 'A gem of a book.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (9, 8, 3, 'A thrilling adventure.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (5, 134, 3, 'Unique perspective.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (8, 136, 1, 'A thrilling adventure.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (14, 175, 1, 'Deeply satisfying.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (7, 135, 2, 'A true page-turner.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (14, 196, 2, 'A book that challenges conventions.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (14, 82, 2, 'Engrossing and immersive.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (5, 41, 4, 'Beautifully crafted characters.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (8, 26, 2, 'Impressive plot twists.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (10, 37, 4, 'Masterpiece!') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (3, 207, 2, 'A beautifully written gem.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (13, 40, 5, 'Page-turner!') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (7, 201, 2, 'A book that sparks conversation.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (10, 36, 1, 'Unforgettable.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (8, 20, 2, 'A beautifully written gem.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (14, 120, 2, 'A suspenseful and gripping read.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (12, 40, 1, 'A true page-turner.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (5, 75, 5, 'Perfect balance of humor and drama.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (6, 130, 5, 'Engrossing and immersive.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (4, 62, 3, 'A book that sparks conversation.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (14, 14, 4, 'A gem of a book.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (0, 4, 3, 'Brilliantly executed.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (13, 150, 3, 'A book that challenges conventions.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (2, 10, 5, 'Great book!') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (11, 35, 3, 'Great book!') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (0, 16, 1, 'A delightful surprise.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (5, 7, 4, 'Highly recommended!') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (6, 24, 5, 'Couldn''t get enough.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (5, 59, 4, 'Enthralling read.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (0, 67, 4, 'Beautifully crafted characters.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (5, 130, 2, 'A thrilling adventure.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (0, 135, 5, 'A book that stays with you.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (4, 29, 3, 'Highly recommended!') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (0, 208, 3, 'A book that inspires.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (6, 84, 5, 'Well-paced and suspenseful.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (11, 63, 1, 'Unique perspective.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (0, 193, 5, 'A book that leaves you wanting more.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (4, 106, 5, 'Deeply satisfying.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (0, 174, 5, 'A book that sparks conversation.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (2, 195, 5, 'A rollercoaster of emotions.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (6, 199, 3, 'Perfect balance of humor and drama.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (14, 72, 3, 'Page-turner!') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (1, 130, 1, 'Page-turner!') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (6, 84, 4, 'A book that defies expectations.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (4, 120, 1, 'A book that challenges your perspective.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (8, 148, 4, 'A book that tugs at the heartstrings.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (2, 96, 4, 'A beautifully written gem.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (14, 122, 2, 'A book that challenges conventions.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (6, 62, 1, 'A book that defies expectations.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (11, 63, 5, 'Highly recommended!') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (6, 7, 4, 'Exquisite prose.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (14, 14, 4, 'A thrilling adventure.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (3, 39, 5, 'A literary triumph.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (10, 100, 4, 'Powerful and moving.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (14, 92, 3, 'Unforgettable.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (14, 204, 5, 'Highly recommended!') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (1, 209, 1, 'Awe-inspiring.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (1, 70, 2, 'A literary triumph.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (1, 100, 2, 'A book that challenges conventions.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (0, 27, 5, 'Compelling narrative.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (12, 152, 2, 'A book that inspires.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (13, 40, 3, 'Exquisite prose.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (12, 161, 4, 'Awe-inspiring.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (5, 6, 5, 'Deeply satisfying.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (6, 115, 1, 'Exceptional storytelling.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (8, 159, 3, 'Great book!') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (11, 174, 2, 'A tour de force.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (2, 6, 1, 'Well-paced and suspenseful.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (0, 208, 1, 'Great book!') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (8, 65, 4, 'Exceptional storytelling.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (14, 7, 2, 'Page-turner!') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (1, 201, 3, 'A book that stays with you.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (0, 170, 2, 'Deserves all the praise.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (4, 202, 2, 'Enthralling read.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (7, 180, 5, 'A book that makes you think.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (8, 142, 5, 'Emotionally gripping.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (8, 108, 2, 'Masterpiece!') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (7, 46, 5, 'Well-written and engaging.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (7, 18, 4, 'Impressive plot twists.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (12, 131, 1, 'A delightful surprise.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (14, 45, 2, 'A book that defies expectations.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (6, 50, 1, 'Loved it!') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (6, 87, 1, 'Impressive plot twists.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (8, 187, 2, 'Loved it!') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (14, 134, 4, 'Highly original.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (3, 50, 2, 'A gripping tale.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (14, 119, 1, 'A heartwarming story.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (2, 25, 3, 'A true page-turner.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (8, 173, 4, 'Exquisite prose.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (8, 70, 4, 'Deserves all the praise.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (9, 125, 3, 'A rollercoaster of emotions.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (12, 165, 3, 'A book that sparks conversation.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (12, 97, 5, 'Well-paced and suspenseful.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (6, 26, 3, 'A beautifully written gem.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (11, 178, 5, 'A book that sparks conversation.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (0, 150, 4, 'Thought-provoking.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (11, 54, 4, 'Exquisite prose.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (4, 132, 4, 'Captivating from start to finish.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (13, 193, 3, 'Impressive plot twists.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (3, 129, 5, 'Incredible story!') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (4, 163, 3, 'Well-paced and suspenseful.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (14, 136, 1, 'Emotionally gripping.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (8, 48, 3, 'Powerful and moving.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (11, 89, 1, 'A tour de force.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (0, 81, 1, 'Captivating from start to finish.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (8, 159, 5, 'A gem of a book.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (2, 40, 2, 'A tour de force.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (2, 77, 4, 'A delightful surprise.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (11, 208, 4, 'A book that leaves you wanting more.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (10, 57, 3, 'Brilliantly executed.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (12, 151, 5, 'Enthralling read.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (2, 116, 2, 'Beautifully crafted characters.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (12, 211, 2, 'Masterpiece!') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (5, 54, 1, 'Captivating from start to finish.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (7, 207, 3, 'Couldn''t get enough.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (11, 95, 3, 'A heartwarming story.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (7, 183, 3, 'A gripping tale.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (9, 94, 5, 'Captivating from start to finish.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (0, 129, 2, 'Will definitely read again.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (11, 198, 4, 'A heartwarming story.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (12, 134, 1, 'Couldn''t get enough.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (11, 193, 2, 'Unforgettable.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (10, 119, 5, 'A book that sparks conversation.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (0, 198, 4, 'Exceptional storytelling.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (4, 127, 1, 'A book that stays with you.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (7, 129, 5, 'A gripping tale.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (8, 151, 5, 'Deeply satisfying.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (0, 22, 2, 'A literary triumph.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (3, 174, 1, 'A book that inspires.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (14, 93, 1, 'A book that transports you.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (7, 111, 3, 'A book that tugs at the heartstrings.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (4, 18, 1, 'A thought-provoking exploration.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (13, 50, 4, 'Awe-inspiring.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (1, 52, 4, 'Thought-provoking.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (1, 136, 2, 'Emotionally gripping.') ON CONFLICT DO NOTHING;
insert into reviews (user_id, book_id, stars, content) values (8, 158, 5, 'A beautifully written gem.') ON CONFLICT DO NOTHING;

CREATE TABLE IF NOT EXISTS sessions
(
  user_id INT PRIMARY KEY,
  FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);
