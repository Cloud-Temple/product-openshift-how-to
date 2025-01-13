```sql
-- public.alembic_version definition

-- Drop table

-- DROP TABLE public.alembic_version;

CREATE TABLE public.alembic_version (
	version_num varchar(32) NOT NULL,
	CONSTRAINT alembic_version_pkc PRIMARY KEY (version_num)
);

-- Permissions

ALTER TABLE public.alembic_version OWNER TO bonanza;
GRANT ALL ON TABLE public.alembic_version TO bonanza;

```