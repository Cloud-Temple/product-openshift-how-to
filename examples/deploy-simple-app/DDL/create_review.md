```sql
-- public.review definition

-- Drop table

-- DROP TABLE public.review;

CREATE TABLE public.review (
	id serial4 NOT NULL,
	restaurant int4 NULL,
	user_name varchar(30) NULL,
	rating int4 NULL,
	review_text varchar(500) NULL,
	review_date timestamp NULL,
	CONSTRAINT review_pkey PRIMARY KEY (id)
);

-- Permissions

ALTER TABLE public.review OWNER TO bonanza;
GRANT ALL ON TABLE public.review TO bonanza;


-- public.review foreign keys

ALTER TABLE public.review ADD CONSTRAINT review_restaurant_fkey FOREIGN KEY (restaurant) REFERENCES public.restaurant(id) ON DELETE CASCADE;

```