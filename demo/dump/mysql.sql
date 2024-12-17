SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS `author`, `book`, `book_tag`, `book_tag_alt`, `note`, `tag`;

CREATE TABLE author (
	id int NOT NULL AUTO_INCREMENT,
	name varchar(30) NOT NULL,
	web varchar(100) NOT NULL,
	born date DEFAULT NULL,
	PRIMARY KEY(id)
) ENGINE=InnoDB AUTO_INCREMENT=13;

CREATE TABLE tag (
	id int NOT NULL AUTO_INCREMENT,
	name varchar(20) NOT NULL,
	PRIMARY KEY (id)
) ENGINE=InnoDB AUTO_INCREMENT=25;

CREATE TABLE book (
	id int NOT NULL AUTO_INCREMENT,
	author_id int NOT NULL,
	translator_id int,
	title varchar(50) NOT NULL,
	sequel_id int,
	PRIMARY KEY (id),
	CONSTRAINT book_author FOREIGN KEY (author_id) REFERENCES author (id),
	CONSTRAINT book_translator FOREIGN KEY (translator_id) REFERENCES author (id),
	CONSTRAINT book_volume FOREIGN KEY (sequel_id) REFERENCES book (id)
) ENGINE=InnoDB AUTO_INCREMENT=5;

CREATE INDEX book_title ON book (title);

CREATE TABLE book_tag (
	book_id int NOT NULL,
	tag_id int NOT NULL,
	PRIMARY KEY (book_id, tag_id),
	CONSTRAINT book_tag_tag FOREIGN KEY (tag_id) REFERENCES tag (id),
	CONSTRAINT book_tag_book FOREIGN KEY (book_id) REFERENCES book (id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE book_tag_alt (
	book_id int NOT NULL,
	tag_id int NOT NULL,
	state varchar(30),
	PRIMARY KEY (book_id, tag_id),
	CONSTRAINT book_tag_alt_tag FOREIGN KEY (tag_id) REFERENCES tag (id),
	CONSTRAINT book_tag_alt_book FOREIGN KEY (book_id) REFERENCES book (id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE note (
	book_id int NOT NULL,
	note varchar(100),
	CONSTRAINT note_book FOREIGN KEY (book_id) REFERENCES book (id)
) ENGINE=InnoDB;

SET FOREIGN_KEY_CHECKS = 1;

-- Insert authors
INSERT INTO author (id, name, web, born) VALUES
(1, 'John Smith', 'www.johnsmith.com', '1975-03-15'),       -- both writes and translates
(2, 'Emily Brown', 'www.emilybrown.net', '1982-07-22'),     -- writer only
(3, 'David Wilson', 'www.davidwilson.org', '1968-11-30'),   -- writer only
(4, 'Marie Novotná', 'www.marienovotna.cz', '1979-04-18'),  -- translator only
(5, 'Karel Černý', 'www.karelcerny.cz', '1971-09-05'),      -- both writes and translates
(6, 'Anna White', 'www.annawhite.com', '1985-12-10');       -- writer only

-- Insert tags
INSERT INTO tag (id, name) VALUES
(1, 'Fantasy'),
(2, 'Sci-fi'),
(3, 'Romance'),
(4, 'Mystery'),
(5, 'Historical'),
(6, 'Adventure'),
(7, 'Thriller'),
(8, 'Drama');

-- Insert books
INSERT INTO book (id, author_id, translator_id, title, sequel_id) VALUES
(1, 1, NULL, 'The Magic Portal', NULL),                    -- fantasy series
(2, 1, NULL, 'Beyond the Portal', 1),                      -- sequel
(3, 1, NULL, 'The Final Gateway', 2),                      -- finale
(4, 2, 4, 'Love in Paris', NULL),                          -- translated novel
(5, 3, NULL, 'Mystery of the Ancient Temple', NULL),       -- standalone novel
(6, 3, NULL, 'The Dark Secret', NULL),                     -- another by same author
(7, 6, 5, 'Stars Above', NULL),                            -- translated sci-fi
(8, 5, NULL, 'Temné noci', NULL),                          -- Czech thriller
(9, 2, 4, 'Summer Dreams', NULL),                          -- translated novel
(10, 6, NULL, 'The Last Ship', NULL);                      -- standalone novel

-- Assign tags to books
INSERT INTO book_tag (book_id, tag_id) VALUES
(1, 1), (1, 6),                    -- The Magic Portal: Fantasy, Adventure
(2, 1), (2, 6),                    -- Beyond the Portal: Fantasy, Adventure
(3, 1), (3, 6),                    -- The Final Gateway: Fantasy, Adventure
(4, 3), (4, 5),                    -- Love in Paris: Romance, Historical
(5, 4), (5, 6), (5, 5),           -- Mystery of the Ancient Temple: Mystery, Adventure, Historical
(6, 4), (6, 7),                    -- The Dark Secret: Mystery, Thriller
(7, 2), (7, 6),                    -- Stars Above: Sci-fi, Adventure
(8, 7), (8, 4),                    -- Temné noci: Thriller, Mystery
(9, 3), (9, 8),                    -- Summer Dreams: Romance, Drama
(10, 2), (10, 7), (10, 8);        -- The Last Ship: Sci-fi, Thriller, Drama

-- Insert alternative tags with additional information
INSERT INTO book_tag_alt (book_id, tag_id, state) VALUES
(1, 1, 'primary'), (1, 6, 'secondary'),
(4, 3, 'primary'), (4, 5, 'background'),
(7, 2, 'primary'), (7, 6, 'secondary'),
(10, 2, 'primary'), (10, 7, 'secondary'), (10, 8, 'background');

-- Insert notes
INSERT INTO note (book_id, note) VALUES
(1, 'First part of a successful fantasy series'),
(4, 'Romantic bestseller of 2023'),
(7, 'Awarded Best Sci-fi of 2024'),
(8, 'Inspired by true events');
