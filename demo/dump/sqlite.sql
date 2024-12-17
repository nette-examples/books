DROP TABLE IF EXISTS note;
DROP TABLE IF EXISTS book_tag_alt;
DROP TABLE IF EXISTS book_tag;
DROP TABLE IF EXISTS book;
DROP TABLE IF EXISTS tag;
DROP TABLE IF EXISTS author;

CREATE TABLE author (
	id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
	name TEXT NOT NULL,
	web TEXT NOT NULL,
	born DATE
);

CREATE TABLE tag (
	id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
	name TEXT NOT NULL
);

CREATE TABLE book (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	author_id INTEGER NOT NULL,
	translator_id INTEGER,
	title TEXT NOT NULL,
	sequel_id INTEGER,
	CONSTRAINT book_author FOREIGN KEY (author_id) REFERENCES author (id),
	CONSTRAINT book_translator FOREIGN KEY (translator_id) REFERENCES author (id),
	CONSTRAINT book_volume FOREIGN KEY (sequel_id) REFERENCES book (id)
);

CREATE INDEX book_title ON book (title);

CREATE TABLE book_tag (
	book_id INTEGER NOT NULL,
	tag_id INTEGER NOT NULL,
	CONSTRAINT book_tag_tag FOREIGN KEY (tag_id) REFERENCES tag (id),
	CONSTRAINT book_tag_book FOREIGN KEY (book_id) REFERENCES book (id) ON DELETE CASCADE,
	PRIMARY KEY (book_id, tag_id)
);

CREATE TABLE book_tag_alt (
	book_id INTEGER NOT NULL,
	tag_id INTEGER NOT NULL,
	state TEXT,
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
INSERT INTO author (name, web, born) VALUES
('John Smith', 'www.johnsmith.com', '1975-03-15'),       -- both writes and translates
('Emily Brown', 'www.emilybrown.net', '1982-07-22'),     -- writer only
('David Wilson', 'www.davidwilson.org', '1968-11-30'),   -- writer only
('Marie Novotná', 'www.marienovotna.cz', '1979-04-18'),  -- translator only
('Karel Černý', 'www.karelcerny.cz', '1971-09-05'),      -- both writes and translates
('Anna White', 'www.annawhite.com', '1985-12-10');       -- writer only

-- Insert tags
INSERT INTO tag (name) VALUES
('Fantasy'),     -- 1
('Sci-fi'),      -- 2
('Romance'),     -- 3
('Mystery'),     -- 4
('Historical'),  -- 5
('Adventure'),   -- 6
('Thriller'),    -- 7
('Drama');       -- 8

-- Insert books
-- Note: author_id corresponds to the order of insertion above (1-6)
INSERT INTO book (author_id, translator_id, title, sequel_id) VALUES
(1, NULL, 'The Magic Portal', NULL),                    -- id 1: fantasy series
(1, NULL, 'Beyond the Portal', 1),                      -- id 2: sequel
(1, NULL, 'The Final Gateway', 2),                      -- id 3: finale
(2, 4, 'Love in Paris', NULL),                          -- id 4: translated novel
(3, NULL, 'Mystery of the Ancient Temple', NULL),       -- id 5: standalone novel
(3, NULL, 'The Dark Secret', NULL),                     -- id 6: another by same author
(6, 5, 'Stars Above', NULL),                            -- id 7: translated sci-fi
(5, NULL, 'Temné noci', NULL),                          -- id 8: Czech thriller
(2, 4, 'Summer Dreams', NULL),                          -- id 9: translated novel
(6, NULL, 'The Last Ship', NULL);                       -- id 10: standalone novel

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
