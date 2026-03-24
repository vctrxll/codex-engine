-- =====================================
-- CONFIG
-- =====================================
PRAGMA foreign_keys = ON;

-- =====================================
-- TABLE: museums
-- =====================================
CREATE TABLE museums (
                         id INTEGER PRIMARY KEY,
                         name TEXT NOT NULL,
                         city TEXT,
                         state TEXT,
                         country TEXT,
                         description TEXT,
                         website TEXT,
                         contact_email TEXT,
                         created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
                         deleted_at DATETIME
);

CREATE INDEX idx_museums_deleted_at ON museums(deleted_at);

-- =====================================
-- TABLE: cultures
-- =====================================
CREATE TABLE cultures (
                          id INTEGER PRIMARY KEY,
                          name TEXT NOT NULL,
                          description TEXT
);

-- =====================================
-- TABLE: periods
-- =====================================
CREATE TABLE periods (
                         id INTEGER PRIMARY KEY,
                         name TEXT NOT NULL,
                         description TEXT
);

-- =====================================
-- TABLE: artifacts
-- =====================================
CREATE TABLE artifacts (
                           id INTEGER PRIMARY KEY,
                           name TEXT NOT NULL,
                           museum_id INTEGER,
                           culture_id INTEGER,
                           period_id INTEGER,
                           description TEXT,
                           material TEXT,
                           created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
                           deleted_at DATETIME,

                           FOREIGN KEY (museum_id) REFERENCES museums(id),
                           FOREIGN KEY (culture_id) REFERENCES cultures(id),
                           FOREIGN KEY (period_id) REFERENCES periods(id)
);

CREATE INDEX idx_artifacts_museum_id ON artifacts(museum_id);
CREATE INDEX idx_artifacts_culture_id ON artifacts(culture_id);
CREATE INDEX idx_artifacts_period_id ON artifacts(period_id);
CREATE INDEX idx_artifacts_deleted_at ON artifacts(deleted_at);

-- =====================================
-- TABLE: artifact_metadata (1:1)
-- =====================================
CREATE TABLE artifact_metadata (
                                   id INTEGER PRIMARY KEY,
                                   artifact_id INTEGER NOT NULL UNIQUE,
                                   height_cm REAL,
                                   width_cm REAL,
                                   depth_cm REAL,
                                   inventory_code TEXT,
                                   collection TEXT,
                                   conservation_status TEXT,
                                   created_at DATETIME DEFAULT CURRENT_TIMESTAMP,

                                   FOREIGN KEY (artifact_id) REFERENCES artifacts(id)
);

-- =====================================
-- TABLE: models_3d (1:N)
-- =====================================
CREATE TABLE models_3d (
                           id INTEGER PRIMARY KEY,
                           artifact_id INTEGER NOT NULL,
                           file_low TEXT,
                           file_high TEXT,
                           format TEXT,
                           scan_method TEXT,
                           scan_resolution TEXT,
                           created_at DATETIME DEFAULT CURRENT_TIMESTAMP,

                           FOREIGN KEY (artifact_id) REFERENCES artifacts(id)
);

CREATE INDEX idx_models3d_artifact_id ON models_3d(artifact_id);

-- =====================================
-- TABLE: users
-- =====================================
CREATE TABLE users (
                       id INTEGER PRIMARY KEY,
                       name TEXT NOT NULL,
                       email TEXT NOT NULL,
                       password_hash TEXT NOT NULL,
                       role TEXT NOT NULL,
                       museum_id INTEGER,
                       created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
                       deleted_at DATETIME,

                       FOREIGN KEY (museum_id) REFERENCES museums(id)
);

-- UNIQUE solo para usuarios activos
CREATE UNIQUE INDEX idx_users_email_active
    ON users(email)
    WHERE deleted_at IS NULL;

CREATE INDEX idx_users_deleted_at ON users(deleted_at);

-- =====================================
-- VIEWS (MUY IMPORTANTE PARA API)
-- =====================================

-- Museos activos
CREATE VIEW active_museums AS
SELECT * FROM museums
WHERE deleted_at IS NULL;

-- Artifacts activos
CREATE VIEW active_artifacts AS
SELECT * FROM artifacts
WHERE deleted_at IS NULL;

-- Usuarios activos
CREATE VIEW active_users AS
SELECT * FROM users
WHERE deleted_at IS NULL;

-- Vista enriquecida (JOIN limpio)
CREATE VIEW artifact_full_view AS
SELECT
    a.id,
    a.name,
    a.description,
    a.material,
    a.created_at,

    m.name AS museum_name,
    c.name AS culture_name,
    p.name AS period_name

FROM artifacts a
         LEFT JOIN museums m
                   ON a.museum_id = m.id AND m.deleted_at IS NULL
         LEFT JOIN cultures c
                   ON a.culture_id = c.id
         LEFT JOIN periods p
                   ON a.period_id = p.id

WHERE a.deleted_at IS NULL;

-- =====================================
-- TRIGGERS (SOFT DELETE CASCADE LÓGICO)
-- =====================================

-- Cuando se elimina un museo → eliminar artifacts
CREATE TRIGGER soft_delete_artifacts_from_museum
    AFTER UPDATE OF deleted_at ON museums
    WHEN NEW.deleted_at IS NOT NULL
BEGIN
    UPDATE artifacts
    SET deleted_at = CURRENT_TIMESTAMP
    WHERE museum_id = NEW.id
      AND deleted_at IS NULL;
END;

-- Cuando se restaura un museo → NO restaurar artifacts automáticamente
-- (esto es intencional para evitar inconsistencias)

-- =====================================
-- HELPERS (CONSULTAS BASE)
-- =====================================

-- Obtener artifacts activos con modelos
-- (ejemplo base para endpoints)
-- SELECT * FROM artifact_full_view WHERE id = ?;
