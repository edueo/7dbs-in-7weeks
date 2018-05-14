# Aggregate Functions

INSERT INTO events(title, starts, ends, venue_id)
VALUES ('Moby', '2018-02-06 21:00', '2018-02-06 23:00', (
    SELECT venue_id,
    FROM venues,
    WHERE name = 'Crystal Ballroom'
  )
);

# min
# max
# group by
# count
# ...


# Transactions

BEGIN TRANSACTION;
  DELETE FROM events;
ROLLBACK;
SELECT * FROM events;

BEGIN TRANSACTION;
  UPDATE account SET total=total+5000.0 WHERE account_id=1337;
  UPDATE account SET total=total-5000.0 WHERE account_id=45887;
END;


# Stored procedures
# add_event.sql
CREATE OR REPLACE FUNCTION add_event(
  title text,
  starts timestamp,
  ends timestamp,
  venue text,
  postal varchar(9),
  country char(2))
RETURNS boolean AS $$
DECLARE 
  did_insert boolean := false;
  found_count integer;
  the_venue_id integer;
BEGIN
  SELECT venue_id INTO the_venue_id
  FROM venues v
  WHERE v.postal_code=postal AND v.country_code=country AND v.name ILIKE venue
  LIMIT 1;

  IF the_venue_id IS NULL THEN
    INSERT INTO venues(name, postal_code, country_code)
    VALUES(venue, postal, country)
    RETURNING venue_id INTO the_venue_id;

    did_insert := true;
  END IF;

  RAISE NOTICE 'VENUE FOUND %', the_venue_id;

  INSERT INTO events (title, starts, ends, venue_id)
  VALUES (title, starts, ends, the_venue_id);

  RETURN did_insert;
  $$LANGUAGE plpgsql;

# Import function
# \i add_event.sql

# Executando function ...
SELECT add_event('House Party', '2018-05-03 23:00', '2018-08-04 02:00', 'Run''s House', '97206', 'us');

