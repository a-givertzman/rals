-- Таблица переводов

--
-- Enum of languages for translations
--
DROP TYPE IF EXISTS language CASCADE;
CREATE TYPE language AS ENUM ('ru', 'en');

--
-- Relation to store translation records
--
DROP TABLE IF EXISTS translation CASCADE;

CREATE TABLE IF NOT EXISTS translation (
  id INT GENERATED ALWAYS AS IDENTITY,
  default_text TEXT,
  CONSTRAINT translation_pk PRIMARY KEY (id)
);

--
-- Relation to store translation data for corresponding translation record with specified language
--
DROP TABLE IF EXISTS translation_data CASCADE;

CREATE TABLE IF NOT EXISTS translation_data (
  id INT GENERATED ALWAYS AS IDENTITY,
  translation_id INT NOT NULL,
  language language NOT NULL,
  title TEXT NOT NULL,
  abbreviation TEXT,
  description TEXT,
  CONSTRAINT translation_data_pk PRIMARY KEY (id),
  CONSTRAINT translation_data_translation_fk FOREIGN KEY (translation_id) REFERENCES translation (id),
  CONSTRAINT translation_data_check_language_unique UNIQUE (translation_id, language),
  CONSTRAINT translation_data_check_title CHECK(char_length(title) <= 100),
  CONSTRAINT translation_data_check_abbreviation CHECK(char_length(abbreviation) <= 50),
  CONSTRAINT translation_data_check_description CHECK(char_length(description) <= 1000)
);

--
-- Function to create new "translation" record with "translation_data" records automatically linked
--
DROP FUNCTION IF EXISTS new_translation CASCADE;

CREATE OR REPLACE FUNCTION new_translation(
  languages TEXT[], -- Array of languages for this translation
  titles TEXT[], -- Array of titles for this translation
  default_text TEXT DEFAULT NULL, -- Default text for this translation, NULL if not specified
  abbreviations TEXT[] DEFAULT ARRAY[]::TEXT[], -- Array of abbreviations for this translation, empty if not specified
  descriptions TEXT[] DEFAULT ARRAY[]::TEXT[] -- Array of descriptions for this translation, empty if not specified
)
RETURNS INT
LANGUAGE plpgsql AS $$
DECLARE
  translation_id INT;
BEGIN
  -- Insert new "translation" entry and save its id
  INSERT INTO translation (default_text)
  VALUES (default_text)
  RETURNING id INTO translation_id;
  -- Insert "translation_data" for corresponding "translation" entry
  INSERT INTO translation_data (translation_id, language, title, abbreviation, description)
  SELECT translation_id, td.language::language, td.title, td.abbreviation, td.description
  FROM unnest($1, $2, $4, $5) AS td(language, title, abbreviation, description);
  -- Return id of new "translation" entry
  RETURN translation_id;
END; $$;

--
-- View to get all translations with their data
--
DROP VIEW IF EXISTS translation_view CASCADE;

CREATE VIEW
    translation_view AS
SELECT 
    translation.id AS id,
    translation_data.language AS language,
    COALESCE(translation_data.title, translation.default_text) AS title,
    translation_data.abbreviation AS abbreviation,
    translation_data.description AS description
FROM 
    translation 
LEFT JOIN
    translation_data ON translation.id = translation_data.translation_id
ORDER BY
    translation_data.id;
