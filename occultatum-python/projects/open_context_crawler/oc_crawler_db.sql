CREATE SCHEMA api;;

CREATE TABLE api.oc_subjects (
    -- Common properties
    uuid uuid PRIMARY KEY NOT NULL,
    temporal_range numrange,
    label TEXT,
    category TEXT,
    type TEXT,
    issued DATE,
    modified DATE,
    creator_uuid UUID,
    license_url TEXT,
    project_uuid UUID,
    metadata jsonb NOT NULL
    -- Common properties end
);

CREATE TABLE api.oc_media (
    -- Common properties
    uuid uuid PRIMARY KEY NOT NULL,
    temporal_range numrange,
    label TEXT,
    category TEXT,
    type TEXT,
    issued DATE,
    modified DATE,
    creator_uuid UUID,
    license_url TEXT,
    project_uuid UUID,
    metadata jsonb NOT NULL,
    -- Common properties end
    reference_uri uuid REFERENCES api.oc_subjects(uuid)
);

CREATE TABLE api.oc_authors (
    uuid uuid PRIMARY KEY NOT NULL,
    name TEXT NOT NULL
);

CREATE TABLE api.oc_authors_items (
    author_id uuid NOT NULL REFERENCES api.oc_authors(uuid),
    item_id uuid NOT NULL,
    PRIMARY KEY (author_id, item_id)
);

-- Optionally, add indexes or constraints as needed

create role web_anon nologin;

grant usage on schema api to web_anon;
grant select on api.oc_subjects to web_anon;
grant select on api.oc_media to web_anon;
grant select on api.oc_authors to web_anon;
grant select on api.oc_authors_items to web_anon;

create role authenticator noinherit login password 'mysecretpassword';
grant web_anon to authenticator;

create role crawler_user nologin;
grant crawler_user to authenticator;

grant usage on schema api to crawler_user;
grant all on api.oc_subjects to crawler_user;
grant all on api.oc_media to crawler_user;
grant all on api.oc_authors to crawler_user;
grant all on api.oc_authors_items to crawler_user;


CREATE OR REPLACE FUNCTION api.oc_subjects_metadata_fill()
RETURNS trigger AS $$
DECLARE
  creator_uri TEXT;
  project_uri TEXT;
BEGIN
  NEW.uuid := (NEW.metadata->>'uuid')::uuid;
  NEW.temporal_range := numrange(
    NULLIF(NEW.metadata#>>'{features,0,when,start}', 'null')::numeric,
    NULLIF(NEW.metadata#>>'{features,0,when,stop}', 'null')::numeric
  );
  NEW.label := NEW.metadata->>'label';
  NEW.category := NEW.metadata->>'category';
  NEW.type := NEW.metadata->>'type';
  NEW.issued := (NEW.metadata->>'dc-terms:issued')::date;
  NEW.modified := (NEW.metadata->>'dc-terms:modified')::date;
  creator_uri := NEW.metadata#>>'{dc-terms:creator,0,id}';
  IF creator_uri IS NOT NULL THEN
    NEW.creator_uuid := regexp_replace(creator_uri, '^.*\/([0-9a-fA-F-]{36})$', '\1')::uuid;
  END IF;
  NEW.license_url := NEW.metadata#>>'{dc-terms:license,0,id}';
  project_uri := NEW.metadata#>>'{dc-terms:isPartOf,0,id}';
  IF project_uri IS NOT NULL THEN
    NEW.project_uuid := regexp_replace(project_uri, '^.*\/([0-9a-fA-F-]{36})$', '\1')::uuid;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS oc_subjects_metadata_fill_trigger ON api.oc_subjects;

CREATE TRIGGER oc_subjects_metadata_fill_trigger
BEFORE INSERT ON api.oc_subjects
FOR EACH ROW
EXECUTE FUNCTION api.oc_subjects_metadata_fill();


CREATE OR REPLACE FUNCTION api.oc_media_metadata_fill()
RETURNS trigger AS $$
DECLARE
  ref_uri_text TEXT;
  creator_uri TEXT;
  project_uri TEXT;
BEGIN
  NEW.uuid := (NEW.metadata->>'uuid')::uuid;
  NEW.temporal_range := numrange(
    NULLIF(NEW.metadata#>>'{features,0,when,start}', 'null')::numeric,
    NULLIF(NEW.metadata#>>'{features,0,when,stop}', 'null')::numeric
  );
  
  NEW.reference_uri := regexp_replace(
    NEW.metadata->'features'->0->'properties'->>'reference_uri',
    '^.*/([0-9a-fA-F-]{36})$',
    '\1'
  )::uuid;
  
  NEW.label := NEW.metadata->>'label';
  NEW.category := NEW.metadata->>'category';
  NEW.type := NEW.metadata->>'type';
  NEW.issued := (NEW.metadata->>'dc-terms:issued')::date;
  NEW.modified := (NEW.metadata->>'dc-terms:modified')::date;
  creator_uri := NEW.metadata#>>'{dc-terms:creator,0,id}';
  IF creator_uri IS NOT NULL THEN
    NEW.creator_uuid := regexp_replace(creator_uri, '^.*\/([0-9a-fA-F-]{36})$', '\1')::uuid;
  END IF;
  NEW.license_url := NEW.metadata#>>'{dc-terms:license,0,id}';
  project_uri := NEW.metadata#>>'{dc-terms:isPartOf,0,id}';
  IF project_uri IS NOT NULL THEN
    NEW.project_uuid := regexp_replace(project_uri, '^.*\/([0-9a-fA-F-]{36})$', '\1')::uuid;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS oc_media_metadata_fill_trigger ON api.oc_media;

CREATE TRIGGER oc_media_metadata_fill_trigger
BEFORE INSERT ON api.oc_media
FOR EACH ROW
EXECUTE FUNCTION api.oc_media_metadata_fill();

-- For fast lookup by category (subjects)
CREATE INDEX idx_oc_subjects_category ON api.oc_subjects(category);

-- For fast lookup by temporal_range (subjects)
CREATE INDEX idx_oc_subjects_temporal_range ON api.oc_subjects(temporal_range);

-- For fast lookup by category (media) if needed
CREATE INDEX idx_oc_media_category ON api.oc_media(category);

-- For fast lookup by temporal_range (media) if needed
CREATE INDEX idx_oc_media_temporal_range ON api.oc_media(temporal_range);

-- For fast lookup of all author_ids for a given item_id (author-item mapping)
CREATE INDEX idx_oc_authors_items_item_id ON api.oc_authors_items(item_id);

-- For fast lookup of all item_ids for a given author_id (reverse mapping)
CREATE INDEX idx_oc_authors_items_author_id ON api.oc_authors_items(author_id);