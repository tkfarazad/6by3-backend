--
-- PostgreSQL database dump
--

-- Dumped from database version 10.3 (Debian 10.3-1.pgdg90+1)
-- Dumped by pg_dump version 10.4 (Debian 10.4-1.pgdg90+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: citext; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS citext WITH SCHEMA public;


--
-- Name: EXTENSION citext; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION citext IS 'data type for case-insensitive character strings';


--
-- Name: videos_set_views_count(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.videos_set_views_count() RETURNS trigger
    LANGUAGE plpgsql
    AS $$        BEGIN
          IF (TG_OP = 'UPDATE' AND (NEW."video_id" = OLD."video_id" OR (OLD."video_id" IS NULL AND NEW."video_id" IS NULL))) THEN
            RETURN NEW;
          ELSE
            IF ((TG_OP = 'INSERT' OR TG_OP = 'UPDATE') AND NEW."video_id" IS NOT NULL) THEN
              UPDATE "videos" SET "views_count" = "views_count" + 1 WHERE "id" = NEW."video_id";
            END IF;
            IF ((TG_OP = 'DELETE' OR TG_OP = 'UPDATE') AND OLD."video_id" IS NOT NULL) THEN
              UPDATE "videos" SET "views_count" = "views_count" - 1 WHERE "id" = OLD."video_id";
            END IF;
          END IF;

          IF (TG_OP = 'DELETE') THEN
            RETURN OLD;
          END IF;
          RETURN NEW;
        END;
$$;


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: auth_tokens; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.auth_tokens (
    id integer NOT NULL,
    token text NOT NULL,
    user_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL
);


--
-- Name: auth_tokens_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.auth_tokens ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.auth_tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: coaches; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.coaches (
    id integer NOT NULL,
    fullname text NOT NULL,
    avatar text,
    personal_info text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    deleted_at timestamp without time zone,
    certifications text[]
);


--
-- Name: coaches_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.coaches ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.coaches_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: coaches_videos; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.coaches_videos (
    id integer NOT NULL,
    coach_id integer NOT NULL,
    video_id integer NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: coaches_videos_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.coaches_videos ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.coaches_videos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    filename text NOT NULL
);


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id integer NOT NULL,
    email public.citext NOT NULL,
    password_digest text NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    fullname text,
    avatar text,
    admin boolean DEFAULT false NOT NULL,
    deleted_at timestamp without time zone,
    email_confirmed_at timestamp without time zone,
    email_confirmation_token text,
    email_confirmation_requested_at timestamp without time zone,
    reset_password_token text,
    reset_password_requested_at timestamp without time zone
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.users ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: video_views; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.video_views (
    id integer NOT NULL,
    user_id integer NOT NULL,
    video_id integer NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: video_views_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.video_views ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.video_views_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: videos; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.videos (
    id integer NOT NULL,
    name text NOT NULL,
    content text NOT NULL,
    description text NOT NULL,
    duration text NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    deleted_at timestamp without time zone,
    thumbnail text,
    views_count integer DEFAULT 0 NOT NULL
);


--
-- Name: videos_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.videos ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.videos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: auth_tokens auth_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_tokens
    ADD CONSTRAINT auth_tokens_pkey PRIMARY KEY (id);


--
-- Name: auth_tokens auth_tokens_token_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_tokens
    ADD CONSTRAINT auth_tokens_token_key UNIQUE (token);


--
-- Name: coaches coaches_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.coaches
    ADD CONSTRAINT coaches_pkey PRIMARY KEY (id);


--
-- Name: coaches_videos coaches_videos_coach_id_video_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.coaches_videos
    ADD CONSTRAINT coaches_videos_coach_id_video_id_key UNIQUE (coach_id, video_id);


--
-- Name: coaches_videos coaches_videos_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.coaches_videos
    ADD CONSTRAINT coaches_videos_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (filename);


--
-- Name: users users_email_confirmation_token_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_confirmation_token_key UNIQUE (email_confirmation_token);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: users users_reset_password_token_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_reset_password_token_key UNIQUE (reset_password_token);


--
-- Name: video_views video_views_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.video_views
    ADD CONSTRAINT video_views_pkey PRIMARY KEY (id);


--
-- Name: video_views video_views_user_id_video_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.video_views
    ADD CONSTRAINT video_views_user_id_video_id_key UNIQUE (user_id, video_id);


--
-- Name: videos videos_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.videos
    ADD CONSTRAINT videos_pkey PRIMARY KEY (id);


--
-- Name: auth_tokens_user_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX auth_tokens_user_id_index ON public.auth_tokens USING btree (user_id);


--
-- Name: coaches_videos_coach_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX coaches_videos_coach_id_index ON public.coaches_videos USING btree (coach_id);


--
-- Name: coaches_videos_video_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX coaches_videos_video_id_index ON public.coaches_videos USING btree (video_id);


--
-- Name: video_views_user_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX video_views_user_id_index ON public.video_views USING btree (user_id);


--
-- Name: video_views_video_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX video_views_video_id_index ON public.video_views USING btree (video_id);


--
-- Name: video_views set_views_count; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER set_views_count BEFORE INSERT OR DELETE OR UPDATE ON public.video_views FOR EACH ROW EXECUTE PROCEDURE public.videos_set_views_count();


--
-- Name: auth_tokens auth_tokens_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_tokens
    ADD CONSTRAINT auth_tokens_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: coaches_videos coaches_videos_coach_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.coaches_videos
    ADD CONSTRAINT coaches_videos_coach_id_fkey FOREIGN KEY (coach_id) REFERENCES public.coaches(id);


--
-- Name: coaches_videos coaches_videos_video_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.coaches_videos
    ADD CONSTRAINT coaches_videos_video_id_fkey FOREIGN KEY (video_id) REFERENCES public.videos(id);


--
-- Name: video_views video_views_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.video_views
    ADD CONSTRAINT video_views_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: video_views video_views_video_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.video_views
    ADD CONSTRAINT video_views_video_id_fkey FOREIGN KEY (video_id) REFERENCES public.videos(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;
INSERT INTO "schema_migrations" ("filename") VALUES ('20180515114415_create_users.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20180613132421_add_fullname_and_avatar_and_admin_and_deleted_at_to_user.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20180615140438_add_confirmation_fields_to_users.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20180615140524_create_auth_tokens.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20180615140558_add_reset_password_fields_to_users.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20180627184523_create_coaches.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20180702142257_create_videos.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20180703155514_create_coaches_videos.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20180718130339_add_certifications_to_coaches.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20180718175827_add_not_null_constraint_to_video_duration.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20180722193948_add_thumbnail_to_videos.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20180724144902_create_video_views.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20180725143820_add_video_views_count.rb');