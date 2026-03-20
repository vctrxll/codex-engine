-- Activar claves foráneas
PRAGMA foreign_keys = ON;

-- =========================
-- TABLE: museums
-- =========================
CREATE TABLE museums (
                         id INTEGER PRIMARY KEY,
                         name TEXT NOT NULL,
                         city TEXT,
                         state TEXT,
                         country TEXT,
                         description TEXT,
                         website TEXT,
                         contact_email TEXT,
                         created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- =========================
-- TABLE: cultures
-- =========================
CREATE TABLE cultures (
                          id INTEGER PRIMARY KEY,
                          name TEXT NOT NULL,
                          description TEXT
);

-- =========================
-- TABLE: periods
-- =========================
CREATE TABLE periods (
                         id INTEGER PRIMARY KEY,
                         name TEXT NOT NULL,
                         start_year INTEGER,
                         end_year INTEGER,
                         description TEXT
);

-- =========================
-- TABLE: artifacts
-- =========================
CREATE TABLE artifacts (
                           id INTEGER PRIMARY KEY,
                           name TEXT NOT NULL,
                           museum_id INTEGER,
                           culture_id INTEGER,
                           period_id INTEGER,
                           description TEXT,
                           material TEXT,
                           discovery_year INTEGER,
                           image_url TEXT,
                           created_at DATETIME DEFAULT CURRENT_TIMESTAMP,

                           FOREIGN KEY (museum_id) REFERENCES museums(id),
                           FOREIGN KEY (culture_id) REFERENCES cultures(id),
                           FOREIGN KEY (period_id) REFERENCES periods(id)
);

CREATE INDEX artifacts_museum_id_index ON artifacts(museum_id);
CREATE INDEX artifacts_culture_id_index ON artifacts(culture_id);
CREATE INDEX artifacts_period_id_index ON artifacts(period_id);

-- =========================
-- TABLE: artifact_metadata
-- =========================
CREATE TABLE artifact_metadata (
                                   id INTEGER PRIMARY KEY,
                                   artifact_id INTEGER NOT NULL UNIQUE,
                                   height_cm REAL,
                                   width_cm REAL,
                                   depth_cm REAL,
                                   inventory_code TEXT,
                                   collection TEXT,
                                   discovery_site TEXT,
                                   excavation_year INTEGER,
                                   archaeologist TEXT,
                                   conservation_status TEXT,
                                   legal_status TEXT,
                                   storage_location TEXT,
                                   created_at DATETIME DEFAULT CURRENT_TIMESTAMP,

                                   FOREIGN KEY (artifact_id) REFERENCES artifacts(id)
);

-- =========================
-- TABLE: models_3d
-- =========================
CREATE TABLE models_3d (
                           id INTEGER PRIMARY KEY,
                           artifact_id INTEGER NOT NULL,
                           preview_url TEXT,
                           file_low TEXT,
                           file_high TEXT,
                           format TEXT,
                           scan_method TEXT,
                           scan_resolution TEXT,
                           created_at DATETIME DEFAULT CURRENT_TIMESTAMP,

                           FOREIGN KEY (artifact_id) REFERENCES artifacts(id)
);

CREATE INDEX models_3d_artifact_id_index ON models_3d(artifact_id);

-- =========================
-- TABLE: users
-- =========================
CREATE TABLE users (
                       id INTEGER PRIMARY KEY,
                       name TEXT NOT NULL,
                       email TEXT NOT NULL UNIQUE,
                       password_hash TEXT NOT NULL,
                       role TEXT NOT NULL,
                       museum_id INTEGER,
                       created_at DATETIME DEFAULT CURRENT_TIMESTAMP,

                       FOREIGN KEY (museum_id) REFERENCES museums(id)
);

-- =========================
-- TABLE: api_keys
-- =========================
CREATE TABLE api_keys (
                          id INTEGER PRIMARY KEY,
                          user_id INTEGER NOT NULL,
                          api_key TEXT NOT NULL UNIQUE,
                          plan TEXT,
                          request_limit INTEGER,
                          created_at DATETIME DEFAULT CURRENT_TIMESTAMP,

                          FOREIGN KEY (user_id) REFERENCES users(id)
);

-- =========================
-- TABLE: api_usage
-- =========================
CREATE TABLE api_usage (
                           id INTEGER PRIMARY KEY,
                           api_key_id INTEGER,
                           endpoint TEXT,
                           request_time DATETIME DEFAULT CURRENT_TIMESTAMP,

                           FOREIGN KEY (api_key_id) REFERENCES api_keys(id)
);