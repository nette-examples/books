IF OBJECT_ID('note', 'U') IS NOT NULL DROP TABLE note;
IF OBJECT_ID('book_tag_alt', 'U') IS NOT NULL DROP TABLE book_tag_alt;
IF OBJECT_ID('book_tag', 'U') IS NOT NULL DROP TABLE book_tag;
IF OBJECT_ID('book', 'U') IS NOT NULL DROP TABLE book;
IF OBJECT_ID('tag', 'U') IS NOT NULL DROP TABLE tag;
IF OBJECT_ID('author', 'U') IS NOT NULL DROP TABLE author;

CREATE TABLE author (
	id int NOT NULL IDENTITY(11,1),
	name varchar(30) NOT NULL,
	web varchar(100) NOT NULL,
	born date,
	PRIMARY KEY(id)
);

CREATE TABLE tag (
	id int NOT NULL IDENTITY(21, 1),
	name varchar(20) NOT NULL,
	PRIMARY KEY (id)
);

CREATE TABLE book (
	id int NOT NULL IDENTITY(1,1),
	author_id int NOT NULL,
	translator_id int,
	title varchar(50) NOT NULL,
	sequel_id int,
	PRIMARY KEY (id),
	CONSTRAINT book_author FOREIGN KEY (author_id) REFERENCES author (id),
	CONSTRAINT book_translator FOREIGN KEY (translator_id) REFERENCES author (id),
	CONSTRAINT book_volume FOREIGN KEY (sequel_id) REFERENCES book (id)
);

CREATE INDEX book_title ON book (title);

-- Add primary key manually, it is tested to name
CREATE TABLE book_tag (
	book_id int NOT NULL,
	tag_id int NOT NULL,
	CONSTRAINT book_tag_tag FOREIGN KEY (tag_id) REFERENCES tag (id),
	CONSTRAINT book_tag_book FOREIGN KEY (book_id) REFERENCES book (id) ON DELETE CASCADE
);
ALTER TABLE book_tag ADD CONSTRAINT PK_book_tag PRIMARY KEY CLUSTERED (book_id, tag_id);

CREATE TABLE book_tag_alt (
	book_id int NOT NULL,
	tag_id int NOT NULL,
	state varchar(30),
	PRIMARY KEY (book_id, tag_id),
	CONSTRAINT book_tag_alt_tag FOREIGN KEY (tag_id) REFERENCES tag (id),
	CONSTRAINT book_tag_alt_book FOREIGN KEY (book_id) REFERENCES book (id) ON DELETE CASCADE
);

CREATE TABLE note (
	book_id int NOT NULL,
	note varchar(100),
	CONSTRAINT note_book FOREIGN KEY (book_id) REFERENCES book (id)
);

-- Insert authors
SET IDENTITY_INSERT author ON;
INSERT INTO author (id, name, web, born) VALUES
(11, 'John Smith', 'www.johnsmith.com', '1975-03-15'),       -- both writes and translates
(12, 'Emily Brown', 'www.emilybrown.net', '1982-07-22'),     -- writer only
(13, 'David Wilson', 'www.davidwilson.org', '1968-11-30'),   -- writer only
(14, 'Marie Novotná', 'www.marienovotna.cz', '1979-04-18'),  -- translator only
(15, 'Karel Černý', 'www.karelcerny.cz', '1971-09-05'),      -- both writes and translates
(16, 'Anna White', 'www.annawhite.com', '1985-12-10');       -- writer only
SET IDENTITY_INSERT author OFF;

-- Insert tags
SET IDENTITY_INSERT tag ON;
INSERT INTO tag (id, name) VALUES
(21, 'Fantasy'),
(22, 'Sci-fi'),
(23, 'Romance'),
(24, 'Mystery'),
(25, 'Historical'),
(26, 'Adventure'),
(27, 'Thriller'),
(28, 'Drama');
SET IDENTITY_INSERT tag OFF;

-- Insert books
SET IDENTITY_INSERT book ON;
INSERT INTO book (id, author_id, translator_id, title, sequel_id) VALUES
(1, 11, NULL, 'The Magic Portal', NULL),                    -- fantasy series
(2, 11, NULL, 'Beyond the Portal', 1),                      -- sequel
(3, 11, NULL, 'The Final Gateway', 2),                      -- finale
(4, 12, 14, 'Love in Paris', NULL),                         -- translated novel
(5, 13, NULL, 'Mystery of the Ancient Temple', NULL),       -- standalone novel
(6, 13, NULL, 'The Dark Secret', NULL),                     -- another by same author
(7, 16, 15, 'Stars Above', NULL),                           -- translated sci-fi
(8, 15, NULL, 'Temné noci', NULL),                          -- Czech thriller
(9, 12, 14, 'Summer Dreams', NULL),                         -- translated novel
(10, 16, NULL, 'The Last Ship', NULL);                      -- standalone novel
SET IDENTITY_INSERT book OFF;

-- Assign tags to books
INSERT INTO book_tag (book_id, tag_id) VALUES
(1, 21), (1, 26),                   -- The Magic Portal: Fantasy, Adventure
(2, 21), (2, 26),                   -- Beyond the Portal: Fantasy, Adventure
(3, 21), (3, 26),                   -- The Final Gateway: Fantasy, Adventure
(4, 23), (4, 25),                   -- Love in Paris: Romance, Historical
(5, 24), (5, 26), (5, 25),         -- Mystery of the Ancient Temple: Mystery, Adventure, Historical
(6, 24), (6, 27),                   -- The Dark Secret: Mystery, Thriller
(7, 22), (7, 26),                   -- Stars Above: Sci-fi, Adventure
(8, 27), (8, 24),                   -- Temné noci: Thriller, Mystery
(9, 23), (9, 28),                   -- Summer Dreams: Romance, Drama
(10, 22), (10, 27), (10, 28);       -- The Last Ship: Sci-fi, Thriller, Drama

-- Insert alternative tags with additional information
INSERT INTO book_tag_alt (book_id, tag_id, state) VALUES
(1, 21, 'primary'), (1, 26, 'secondary'),
(4, 23, 'primary'), (4, 25, 'background'),
(7, 22, 'primary'), (7, 26, 'secondary'),
(10, 22, 'primary'), (10, 27, 'secondary'), (10, 28, 'background');

-- Insert notes
INSERT INTO note (book_id, note) VALUES
(1, 'First part of a successful fantasy series'),
(4, 'Romantic bestseller of 2023'),
(7, 'Awarded Best Sci-fi of 2024'),
(8, 'Inspired by true events');
