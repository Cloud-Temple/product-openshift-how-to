```sql
-- public.restaurant definition

-- Drop table

-- DROP TABLE public.restaurant;

CREATE TABLE public.restaurant (
	id serial4 NOT NULL,
	"name" varchar(50) NULL,
	street_address varchar(50) NULL,
	description varchar(250) NULL,
	CONSTRAINT restaurant_pkey PRIMARY KEY (id)
);

-- Permissions

ALTER TABLE public.restaurant OWNER TO bonanza;
GRANT ALL ON TABLE public.restaurant TO bonanza;

```