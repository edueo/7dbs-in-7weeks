# CREATE TABLE countries


CREATE TABLE countries (
  country_code char(2) PRIMARY KEY,
  country_name text UNIQUE
);

# Insert many countries

INSERT INTO countries(country_code, country_name)
VALUES ('us', 'United States'), ('mx', 'Mexico'), ('au', 'Australia'),
('gb', 'United Kingdom'), ('de', 'Germany'), ('ll', 'Loompaland');

# Reading countries

SELECT *
FROM countries;


# CREATE TABLE cities

CREATE TABLE cities (
  name text NOT NULL,
  postal_code varchar(9) CHECK (postal_code <> ''),
  country_code char(2) REFERENCES countries,
  PRIMARY KEY (country_code, postal_code)
);

INSERT INTO cities 
VALUES ('Toronto', 'MC415B', 'ca'); # FAIL violates FK constraint

INSERT INTO cities
VALUES ('Portland', '82700', 'us');

#
SELECT cities.*, country_name
FROM cities INNER JOIN countries
ON cities.country_code = countries.country_code;

CREATE TABLE venues (
  venue_id SERIAL PRIMARY KEY,
  name varchar(255),
  street_address text, 
  type char(7) CHECK (type in ('public', 'private')) DEFAULT 'public',
  postal_code varchar(9),
  country_code char(2),
  FOREIGN KEY (country_code, postal_code) REFERENCES cities (country_code, postal_code) MATCH FULL
);

INSERT INTO venues (name, postal_code, country_code)
VALUES ('Vodoo Doughut', '82700', 'us') RETURNING venue_id;

