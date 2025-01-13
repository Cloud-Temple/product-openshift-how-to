CREATE TABLE public.alembic_version (
	version_num varchar(32) NOT NULL,
	CONSTRAINT alembic_version_pkc PRIMARY KEY (version_num)
);

ALTER TABLE public.alembic_version OWNER TO bonanza;
GRANT ALL ON TABLE public.alembic_version TO bonanza;


CREATE TABLE public.restaurant (
	id serial4 NOT NULL,
	"name" varchar(50) NULL,
	street_address varchar(50) NULL,
	description varchar(250) NULL,
	CONSTRAINT restaurant_pkey PRIMARY KEY (id)
);

ALTER TABLE public.restaurant OWNER TO bonanza;
GRANT ALL ON TABLE public.restaurant TO bonanza;

CREATE TABLE public.review (
	id serial4 NOT NULL,
	restaurant int4 NULL,
	user_name varchar(30) NULL,
	rating int4 NULL,
	review_text varchar(500) NULL,
	review_date timestamp NULL,
	CONSTRAINT review_pkey PRIMARY KEY (id)
);


ALTER TABLE public.review OWNER TO bonanza;
GRANT ALL ON TABLE public.review TO bonanza;

ALTER TABLE public.review ADD CONSTRAINT review_restaurant_fkey FOREIGN KEY (restaurant) REFERENCES public.restaurant(id) ON DELETE CASCADE;
