PRAGMA foreign_keys=OFF;
BEGIN TRANSACTION;
CREATE TABLE migrations (
 name VARCHAR(255)
,UNIQUE(name)
);
INSERT INTO migrations VALUES('create-table-users');
INSERT INTO migrations VALUES('create-table-repos');
INSERT INTO migrations VALUES('alter-table-repos-add-column-no-fork');
INSERT INTO migrations VALUES('alter-table-repos-add-column-no-pulls');
INSERT INTO migrations VALUES('alter-table-repos-add-column-cancel-pulls');
INSERT INTO migrations VALUES('alter-table-repos-add-column-cancel-push');
INSERT INTO migrations VALUES('create-table-perms');
INSERT INTO migrations VALUES('create-index-perms-user');
INSERT INTO migrations VALUES('create-index-perms-repo');
INSERT INTO migrations VALUES('create-table-builds');
INSERT INTO migrations VALUES('create-index-builds-repo');
INSERT INTO migrations VALUES('create-index-builds-author');
INSERT INTO migrations VALUES('create-index-builds-sender');
INSERT INTO migrations VALUES('create-index-builds-ref');
INSERT INTO migrations VALUES('create-index-build-incomplete');
INSERT INTO migrations VALUES('create-table-stages');
INSERT INTO migrations VALUES('create-index-stages-build');
INSERT INTO migrations VALUES('create-index-stages-status');
INSERT INTO migrations VALUES('create-table-steps');
INSERT INTO migrations VALUES('create-index-steps-stage');
INSERT INTO migrations VALUES('create-table-logs');
INSERT INTO migrations VALUES('create-table-cron');
INSERT INTO migrations VALUES('create-index-cron-repo');
INSERT INTO migrations VALUES('create-index-cron-next');
INSERT INTO migrations VALUES('create-table-secrets');
INSERT INTO migrations VALUES('create-index-secrets-repo');
INSERT INTO migrations VALUES('create-index-secrets-repo-name');
INSERT INTO migrations VALUES('create-table-nodes');
INSERT INTO migrations VALUES('alter-table-builds-add-column-cron');
INSERT INTO migrations VALUES('create-table-org-secrets');
INSERT INTO migrations VALUES('alter-table-builds-add-column-deploy-id');
CREATE TABLE users (
 user_id            INTEGER PRIMARY KEY AUTOINCREMENT
,user_login         TEXT COLLATE NOCASE
,user_email         TEXT
,user_admin         BOOLEAN
,user_machine       BOOLEAN
,user_active        BOOLEAN
,user_avatar        TEXT
,user_syncing       BOOLEAN
,user_synced        INTEGER
,user_created       INTEGER
,user_updated       INTEGER
,user_last_login    INTEGER
,user_oauth_token   TEXT
,user_oauth_refresh TEXT
,user_oauth_expiry  INTEGER
,user_hash          TEXT
,UNIQUE(user_login COLLATE NOCASE)
,UNIQUE(user_hash)
);
INSERT INTO users VALUES(1,'sandbox','sandbox@mailinator.com',0,0,1,'http://gitea:3000/user/avatar/sandbox/-1',0,1574287815,1574287802,1574287802,1574287802,'eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJnbnQiOjEsInR0IjowLCJleHAiOjE1NzQyOTE0MDIsImlhdCI6MTU3NDI4NzgwMn0.EsEzekQ5kCQ5dGojW5DTeQZgho031x-QNjh5yr3IdneQ9oKDa7yUN0fyvfz3K6eoc36hwqqEyX8i4HZeBdN6FA','eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJnbnQiOjEsInR0IjoxLCJleHAiOjE1NzY5MTU4MDIsImlhdCI6MTU3NDI4NzgwMn0.X-ugw5HR5yyh6Z7b7wcmWz2yyC_a12IMC0VyiKinCcbnCPqikt0gzz3rEttJn61UlzrI4U_BhM8mK8Svf8v63Q',1574291402,'U8hrBag2Up6KaJdH60CR3TV2lgaITIBw');
CREATE TABLE repos (
 repo_id                    INTEGER PRIMARY KEY AUTOINCREMENT
,repo_uid                   TEXT
,repo_user_id               INTEGER
,repo_namespace             TEXT
,repo_name                  TEXT
,repo_slug                  TEXT
,repo_scm                   TEXT
,repo_clone_url             TEXT
,repo_ssh_url               TEXT
,repo_html_url              TEXT
,repo_active                BOOLEAN
,repo_private               BOOLEAN
,repo_visibility            TEXT
,repo_branch                TEXT
,repo_counter               INTEGER
,repo_config                TEXT
,repo_timeout               INTEGER
,repo_trusted               BOOLEAN
,repo_protected             BOOLEAN
,repo_synced                INTEGER
,repo_created               INTEGER
,repo_updated               INTEGER
,repo_version               INTEGER
,repo_signer                TEXT
,repo_secret                TEXT
, repo_no_forks BOOLEAN NOT NULL DEFAULT 0, repo_no_pulls BOOLEAN NOT NULL DEFAULT 0, repo_cancel_pulls BOOLEAN NOT NULL DEFAULT 0, repo_cancel_push BOOLEAN NOT NULL DEFAULT 0,UNIQUE(repo_slug)
,UNIQUE(repo_uid)
);
CREATE TABLE perms (
 perm_user_id  INTEGER
,perm_repo_uid TEXT
,perm_read     BOOLEAN
,perm_write    BOOLEAN
,perm_admin    BOOLEAN
,perm_synced   INTEGER
,perm_created  INTEGER
,perm_updated  INTEGER
,PRIMARY KEY(perm_user_id, perm_repo_uid)
);
CREATE TABLE builds (
 build_id            INTEGER PRIMARY KEY AUTOINCREMENT
,build_repo_id       INTEGER
,build_trigger       TEXT
,build_number        INTEGER
,build_parent        INTEGER
,build_status        TEXT
,build_error         TEXT
,build_event         TEXT
,build_action        TEXT
,build_link          TEXT
,build_timestamp     INTEGER
,build_title         TEXT
,build_message       TEXT
,build_before        TEXT
,build_after         TEXT
,build_ref           TEXT
,build_source_repo   TEXT
,build_source        TEXT
,build_target        TEXT
,build_author        TEXT
,build_author_name   TEXT
,build_author_email  TEXT
,build_author_avatar TEXT
,build_sender        TEXT
,build_deploy        TEXT
,build_params        TEXT
,build_started       INTEGER
,build_finished      INTEGER
,build_created       INTEGER
,build_updated       INTEGER
,build_version       INTEGER
, build_cron TEXT NOT NULL DEFAULT '', build_deploy_id NUMBER NOT NULL DEFAULT 0,UNIQUE(build_repo_id, build_number)
);
CREATE TABLE stages (
 stage_id          INTEGER PRIMARY KEY AUTOINCREMENT
,stage_repo_id     INTEGER
,stage_build_id    INTEGER
,stage_number      INTEGER
,stage_kind        TEXT
,stage_type        TEXT
,stage_name        TEXT
,stage_status      TEXT
,stage_error       TEXT
,stage_errignore   BOOLEAN
,stage_exit_code   INTEGER
,stage_limit       INTEGER
,stage_os          TEXT
,stage_arch        TEXT
,stage_variant     TEXT
,stage_kernel      TEXT
,stage_machine     TEXT
,stage_started     INTEGER
,stage_stopped     INTEGER
,stage_created     INTEGER
,stage_updated     INTEGER
,stage_version     INTEGER
,stage_on_success  BOOLEAN
,stage_on_failure  BOOLEAN
,stage_depends_on  TEXT
,stage_labels      TEXT
,UNIQUE(stage_build_id, stage_number)
,FOREIGN KEY(stage_build_id) REFERENCES builds(build_id) ON DELETE CASCADE
);
CREATE TABLE steps (
 step_id          INTEGER PRIMARY KEY AUTOINCREMENT
,step_stage_id    INTEGER
,step_number      INTEGER
,step_name        TEXT
,step_status      TEXT
,step_error       TEXT
,step_errignore   BOOLEAN
,step_exit_code   INTEGER
,step_started     INTEGER
,step_stopped     INTEGER
,step_version     INTEGER
,UNIQUE(step_stage_id, step_number)
,FOREIGN KEY(step_stage_id) REFERENCES stages(stage_id) ON DELETE CASCADE
);
CREATE TABLE logs (
 log_id    INTEGER PRIMARY KEY
,log_data  BLOB
,FOREIGN KEY(log_id) REFERENCES steps(step_id) ON DELETE CASCADE
);
CREATE TABLE cron (
 cron_id          INTEGER PRIMARY KEY AUTOINCREMENT
,cron_repo_id     INTEGER
,cron_name        TEXT
,cron_expr        TEXT
,cron_next        INTEGER
,cron_prev        INTEGER
,cron_event       TEXT
,cron_branch      TEXT
,cron_target      TEXT
,cron_disabled    BOOLEAN
,cron_created     INTEGER
,cron_updated     INTEGER
,cron_version     INTEGER
,UNIQUE(cron_repo_id, cron_name)
,FOREIGN KEY(cron_repo_id) REFERENCES repos(repo_id) ON DELETE CASCADE
);
CREATE TABLE secrets (
 secret_id                INTEGER PRIMARY KEY AUTOINCREMENT
,secret_repo_id           INTEGER
,secret_name              TEXT
,secret_data              BLOB
,secret_pull_request      BOOLEAN
,secret_pull_request_push BOOLEAN
,UNIQUE(secret_repo_id, secret_name)
,FOREIGN KEY(secret_repo_id) REFERENCES repos(repo_id) ON DELETE CASCADE
);
CREATE TABLE nodes (
 node_id         INTEGER PRIMARY KEY AUTOINCREMENT
,node_uid        TEXT
,node_provider   TEXT
,node_state      TEXT
,node_name       TEXT
,node_image      TEXT
,node_region     TEXT
,node_size       TEXT
,node_os         TEXT
,node_arch       TEXT
,node_kernel     TEXT
,node_variant    TEXT
,node_address    TEXT
,node_capacity   INTEGER
,node_filter     TEXT
,node_labels     TEXT
,node_error      TEXT
,node_ca_key     TEXT
,node_ca_cert    TEXT
,node_tls_key    TEXT
,node_tls_cert   TEXT
,node_tls_name   TEXT
,node_paused     BOOLEAN
,node_protected  BOOLEAN
,node_created    INTEGER
,node_updated    INTEGER
,node_pulled     INTEGER

,UNIQUE(node_name)
);
CREATE TABLE orgsecrets (
 secret_id                INTEGER PRIMARY KEY AUTOINCREMENT
,secret_namespace         TEXT COLLATE NOCASE
,secret_name              TEXT COLLATE NOCASE
,secret_type              TEXT
,secret_data              BLOB
,secret_pull_request      BOOLEAN
,secret_pull_request_push BOOLEAN
,UNIQUE(secret_namespace, secret_name)
);
DELETE FROM sqlite_sequence;
INSERT INTO sqlite_sequence VALUES('users',1);
CREATE INDEX ix_perms_user ON perms (perm_user_id);
CREATE INDEX ix_perms_repo ON perms (perm_repo_uid);
CREATE INDEX ix_build_repo ON builds (build_repo_id);
CREATE INDEX ix_build_author ON builds (build_author);
CREATE INDEX ix_build_sender ON builds (build_sender);
CREATE INDEX ix_build_ref ON builds (build_repo_id, build_ref);
CREATE INDEX ix_build_incomplete ON builds (build_status)
WHERE build_status IN ('pending', 'running');
CREATE INDEX ix_stages_build ON stages (stage_build_id);
CREATE INDEX ix_stage_in_progress ON stages (stage_status)
WHERE stage_status IN ('pending', 'running');
CREATE INDEX ix_steps_stage ON steps (step_stage_id);
CREATE INDEX ix_cron_repo ON cron (cron_repo_id);
CREATE INDEX ix_cron_next ON cron (cron_next);
CREATE INDEX ix_secret_repo ON secrets (secret_repo_id);
CREATE INDEX ix_secret_repo_name ON secrets (secret_repo_id, secret_name);
COMMIT;
