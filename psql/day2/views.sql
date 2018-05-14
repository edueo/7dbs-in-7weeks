CREATE VIEW holiday AS 
  SELECT event_id AS holiday_id, title AS name, starts AS date
  FROM events
  WHERE title LIKE '%Day%' AND venue_id IS NULL;

#
SELECT name, to_char(date, 'Month DD, YYYY') AS date
FROM holidays 
WHERE date <= '2018-04-01';

#
ALTER TABLE events
ADD colors text ARRAY;


CREATE VIEW holiday AS 
  SELECT event_id AS holiday_id, title AS name, starts AS date, colors
  FROM events
  WHERE title LIKE '%Day%' AND venue_id IS NULL;


# Allow updates against our holidays view
CREATE RULE update_holidays AS ON UPDATE TO holidays DO INSTEAD
  UPDATE events
  SET title = NEW.name
  starts = NEW.date,
  colors = NEW.colors
  WHERE title = OLD.name;

UPDATE holidays SET colors = '{"green", "red"}' where name='Christimas Day';

# PESQUISAR: crosstab

