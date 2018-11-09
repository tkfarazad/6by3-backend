--
-- PostgreSQL database dump
--

-- Dumped from database version 10.3 (Debian 10.3-1.pgdg90+1)
-- Dumped by pg_dump version 10.5 (Debian 10.5-2.pgdg90+1)

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
-- Name: stripe_payment_sources_objects; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.stripe_payment_sources_objects AS ENUM (
    'source',
    'card'
);


--
-- Name: stripe_payment_sources_statuses; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.stripe_payment_sources_statuses AS ENUM (
    'canceled',
    'chargeable',
    'consumed',
    'failed',
    'pending'
);


--
-- Name: stripe_payment_sources_types; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.stripe_payment_sources_types AS ENUM (
    'ach_credit_transfer',
    'ach_debit',
    'alipay',
    'bancontact',
    'bitcoin',
    'card',
    'card_present',
    'eps',
    'giropay',
    'ideal',
    'multibanco',
    'p24',
    'sepa_credit_transfer',
    'sepa_debit',
    'sofort',
    'three_d_secure'
);


--
-- Name: stripe_subscriptions_statuses; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.stripe_subscriptions_statuses AS ENUM (
    'trialing',
    'active',
    'past_due',
    'canceled',
    'unpaid'
);


--
-- Name: users_plan_types; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.users_plan_types AS ENUM (
    'free',
    'trial',
    'paid'
);


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
    certifications text[],
    featured boolean DEFAULT false NOT NULL,
    social_links jsonb DEFAULT '{}'::jsonb NOT NULL
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
-- Name: favorite_user_coaches; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.favorite_user_coaches (
    id integer NOT NULL,
    user_id integer NOT NULL,
    coach_id integer NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: favorite_user_coaches_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.favorite_user_coaches ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.favorite_user_coaches_id_seq
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
-- Name: stripe_invoice_items; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.stripe_invoice_items (
    id integer NOT NULL,
    invoice_id integer NOT NULL,
    plan_id integer,
    stripe_id text NOT NULL,
    stripe_data jsonb NOT NULL,
    amount integer NOT NULL,
    currency text NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: stripe_invoice_items_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.stripe_invoice_items ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.stripe_invoice_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: stripe_invoices; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.stripe_invoices (
    id integer NOT NULL,
    user_id integer NOT NULL,
    subscription_id integer NOT NULL,
    stripe_id text NOT NULL,
    stripe_data jsonb NOT NULL,
    total integer NOT NULL,
    amount_due integer NOT NULL,
    amount_paid integer NOT NULL,
    currency text NOT NULL,
    date timestamp without time zone NOT NULL,
    due_date timestamp without time zone,
    forgiven boolean NOT NULL,
    closed boolean NOT NULL,
    attempted boolean NOT NULL,
    paid boolean NOT NULL,
    pdf_url text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: stripe_invoices_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.stripe_invoices ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.stripe_invoices_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: stripe_payment_sources; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.stripe_payment_sources (
    id integer NOT NULL,
    stripe_id text NOT NULL,
    object public.stripe_payment_sources_objects NOT NULL,
    type public.stripe_payment_sources_types,
    status public.stripe_payment_sources_statuses,
    stripe_data jsonb DEFAULT '{}'::jsonb NOT NULL,
    user_id integer NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: stripe_payment_sources_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.stripe_payment_sources ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.stripe_payment_sources_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: stripe_plans; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.stripe_plans (
    id integer NOT NULL,
    name text NOT NULL,
    stripe_id text NOT NULL,
    amount integer NOT NULL,
    currency text NOT NULL,
    product_id integer NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "interval" text NOT NULL,
    interval_count integer NOT NULL,
    trial_period_days integer,
    applicable boolean NOT NULL
);


--
-- Name: stripe_plans_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.stripe_plans ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.stripe_plans_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: stripe_products; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.stripe_products (
    id integer NOT NULL,
    name text NOT NULL,
    stripe_id text NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: stripe_products_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.stripe_products ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.stripe_products_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: stripe_subscribed_plans; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.stripe_subscribed_plans (
    id integer NOT NULL,
    subscription_id integer NOT NULL,
    plan_id integer NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: stripe_subscribed_plans_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.stripe_subscribed_plans ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.stripe_subscribed_plans_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: stripe_subscriptions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.stripe_subscriptions (
    id integer NOT NULL,
    user_id integer NOT NULL,
    status public.stripe_subscriptions_statuses NOT NULL,
    stripe_id text NOT NULL,
    current_period_start_at timestamp without time zone NOT NULL,
    current_period_end_at timestamp without time zone NOT NULL,
    trial_start_at timestamp without time zone,
    trial_end_at timestamp without time zone,
    stripe_data jsonb NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    cancel_at_period_end boolean NOT NULL,
    canceled_at timestamp without time zone
);


--
-- Name: stripe_subscriptions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.stripe_subscriptions ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.stripe_subscriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id integer NOT NULL,
    email public.citext NOT NULL,
    password_digest text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    avatar text,
    admin boolean DEFAULT false NOT NULL,
    deleted_at timestamp without time zone,
    email_confirmed_at timestamp without time zone,
    email_confirmation_token text,
    email_confirmation_requested_at timestamp without time zone,
    reset_password_token text,
    reset_password_requested_at timestamp without time zone,
    stripe_customer_id text,
    default_stripe_payment_source_id integer,
    privacy_policy_accepted boolean DEFAULT false NOT NULL,
    plan_type public.users_plan_types,
    first_name text,
    last_name text
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
-- Name: video_categories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.video_categories (
    id integer NOT NULL,
    name text NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: video_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.video_categories ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.video_categories_id_seq
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
    description text NOT NULL,
    duration integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    deleted_at timestamp without time zone,
    thumbnail text,
    views_count integer DEFAULT 0 NOT NULL,
    lesson_date timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    category_id integer,
    url text NOT NULL,
    content_type text NOT NULL,
    state text NOT NULL,
    featured boolean DEFAULT false NOT NULL
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
-- Name: favorite_user_coaches favorite_user_coaches_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.favorite_user_coaches
    ADD CONSTRAINT favorite_user_coaches_pkey PRIMARY KEY (id);


--
-- Name: favorite_user_coaches favorite_user_coaches_user_id_coach_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.favorite_user_coaches
    ADD CONSTRAINT favorite_user_coaches_user_id_coach_id_key UNIQUE (user_id, coach_id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (filename);


--
-- Name: stripe_invoice_items stripe_invoice_items_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stripe_invoice_items
    ADD CONSTRAINT stripe_invoice_items_pkey PRIMARY KEY (id);


--
-- Name: stripe_invoice_items stripe_invoice_items_stripe_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stripe_invoice_items
    ADD CONSTRAINT stripe_invoice_items_stripe_id_key UNIQUE (stripe_id);


--
-- Name: stripe_invoices stripe_invoices_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stripe_invoices
    ADD CONSTRAINT stripe_invoices_pkey PRIMARY KEY (id);


--
-- Name: stripe_invoices stripe_invoices_stripe_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stripe_invoices
    ADD CONSTRAINT stripe_invoices_stripe_id_key UNIQUE (stripe_id);


--
-- Name: stripe_payment_sources stripe_payment_sources_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stripe_payment_sources
    ADD CONSTRAINT stripe_payment_sources_pkey PRIMARY KEY (id);


--
-- Name: stripe_payment_sources stripe_payment_sources_stripe_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stripe_payment_sources
    ADD CONSTRAINT stripe_payment_sources_stripe_id_key UNIQUE (stripe_id);


--
-- Name: stripe_plans stripe_plans_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stripe_plans
    ADD CONSTRAINT stripe_plans_pkey PRIMARY KEY (id);


--
-- Name: stripe_plans stripe_plans_stripe_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stripe_plans
    ADD CONSTRAINT stripe_plans_stripe_id_key UNIQUE (stripe_id);


--
-- Name: stripe_products stripe_products_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stripe_products
    ADD CONSTRAINT stripe_products_name_key UNIQUE (name);


--
-- Name: stripe_products stripe_products_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stripe_products
    ADD CONSTRAINT stripe_products_pkey PRIMARY KEY (id);


--
-- Name: stripe_products stripe_products_stripe_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stripe_products
    ADD CONSTRAINT stripe_products_stripe_id_key UNIQUE (stripe_id);


--
-- Name: stripe_subscribed_plans stripe_subscribed_plans_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stripe_subscribed_plans
    ADD CONSTRAINT stripe_subscribed_plans_pkey PRIMARY KEY (id);


--
-- Name: stripe_subscribed_plans stripe_subscribed_plans_subscription_id_plan_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stripe_subscribed_plans
    ADD CONSTRAINT stripe_subscribed_plans_subscription_id_plan_id_key UNIQUE (subscription_id, plan_id);


--
-- Name: stripe_subscriptions stripe_subscriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stripe_subscriptions
    ADD CONSTRAINT stripe_subscriptions_pkey PRIMARY KEY (id);


--
-- Name: stripe_subscriptions stripe_subscriptions_stripe_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stripe_subscriptions
    ADD CONSTRAINT stripe_subscriptions_stripe_id_key UNIQUE (stripe_id);


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
-- Name: users users_stripe_customer_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_stripe_customer_id_key UNIQUE (stripe_customer_id);


--
-- Name: video_categories video_categories_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.video_categories
    ADD CONSTRAINT video_categories_name_key UNIQUE (name);


--
-- Name: video_categories video_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.video_categories
    ADD CONSTRAINT video_categories_pkey PRIMARY KEY (id);


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
-- Name: favorite_user_coaches_coach_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX favorite_user_coaches_coach_id_index ON public.favorite_user_coaches USING btree (coach_id);


--
-- Name: favorite_user_coaches_user_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX favorite_user_coaches_user_id_index ON public.favorite_user_coaches USING btree (user_id);


--
-- Name: stripe_invoice_items_invoice_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX stripe_invoice_items_invoice_id_index ON public.stripe_invoice_items USING btree (invoice_id);


--
-- Name: stripe_invoice_items_plan_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX stripe_invoice_items_plan_id_index ON public.stripe_invoice_items USING btree (plan_id);


--
-- Name: stripe_invoices_subscription_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX stripe_invoices_subscription_id_index ON public.stripe_invoices USING btree (subscription_id);


--
-- Name: stripe_invoices_user_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX stripe_invoices_user_id_index ON public.stripe_invoices USING btree (user_id);


--
-- Name: stripe_payment_sources_user_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX stripe_payment_sources_user_id_index ON public.stripe_payment_sources USING btree (user_id);


--
-- Name: stripe_plans_product_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX stripe_plans_product_id_index ON public.stripe_plans USING btree (product_id);


--
-- Name: stripe_subscribed_plans_plan_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX stripe_subscribed_plans_plan_id_index ON public.stripe_subscribed_plans USING btree (plan_id);


--
-- Name: stripe_subscribed_plans_subscription_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX stripe_subscribed_plans_subscription_id_index ON public.stripe_subscribed_plans USING btree (subscription_id);


--
-- Name: stripe_subscriptions_user_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX stripe_subscriptions_user_id_index ON public.stripe_subscriptions USING btree (user_id);


--
-- Name: users_plan_type_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX users_plan_type_index ON public.users USING btree (plan_type);


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
-- Name: favorite_user_coaches favorite_user_coaches_coach_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.favorite_user_coaches
    ADD CONSTRAINT favorite_user_coaches_coach_id_fkey FOREIGN KEY (coach_id) REFERENCES public.coaches(id);


--
-- Name: favorite_user_coaches favorite_user_coaches_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.favorite_user_coaches
    ADD CONSTRAINT favorite_user_coaches_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: stripe_invoice_items stripe_invoice_items_invoice_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stripe_invoice_items
    ADD CONSTRAINT stripe_invoice_items_invoice_id_fkey FOREIGN KEY (invoice_id) REFERENCES public.stripe_invoices(id);


--
-- Name: stripe_invoice_items stripe_invoice_items_plan_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stripe_invoice_items
    ADD CONSTRAINT stripe_invoice_items_plan_id_fkey FOREIGN KEY (plan_id) REFERENCES public.stripe_plans(id);


--
-- Name: stripe_invoices stripe_invoices_subscription_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stripe_invoices
    ADD CONSTRAINT stripe_invoices_subscription_id_fkey FOREIGN KEY (subscription_id) REFERENCES public.stripe_subscriptions(id);


--
-- Name: stripe_invoices stripe_invoices_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stripe_invoices
    ADD CONSTRAINT stripe_invoices_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: stripe_payment_sources stripe_payment_sources_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stripe_payment_sources
    ADD CONSTRAINT stripe_payment_sources_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: stripe_plans stripe_plans_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stripe_plans
    ADD CONSTRAINT stripe_plans_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.stripe_products(id);


--
-- Name: stripe_subscribed_plans stripe_subscribed_plans_plan_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stripe_subscribed_plans
    ADD CONSTRAINT stripe_subscribed_plans_plan_id_fkey FOREIGN KEY (plan_id) REFERENCES public.stripe_plans(id);


--
-- Name: stripe_subscribed_plans stripe_subscribed_plans_subscription_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stripe_subscribed_plans
    ADD CONSTRAINT stripe_subscribed_plans_subscription_id_fkey FOREIGN KEY (subscription_id) REFERENCES public.stripe_subscriptions(id);


--
-- Name: stripe_subscriptions stripe_subscriptions_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stripe_subscriptions
    ADD CONSTRAINT stripe_subscriptions_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: users users_default_stripe_payment_source_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_default_stripe_payment_source_id_fkey FOREIGN KEY (default_stripe_payment_source_id) REFERENCES public.stripe_payment_sources(id);


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
-- Name: videos videos_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.videos
    ADD CONSTRAINT videos_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.video_categories(id);


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
INSERT INTO "schema_migrations" ("filename") VALUES ('20180726115931_create_video_categories.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20180726135211_add_category_id_and_date_to_video.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20180726160108_change_video_duration_column_type.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20180801153513_add_stripe_customer_id_to_users.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20180808164101_change_video_structure.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20180809094716_add_featured_to_coaches.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20180810084706_create_stripe_payment_sources.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20180810113002_add_default_stripe_payment_source_to_users.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20180810134910_create_stripe_products.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20180810172253_create_stripe_plans.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20180811114449_create_stripe_subscriptions.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20180811114725_create_stripe_subscribed_plans.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20180812123956_add_video_state.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20180813152308_create_favorite_user_coaches.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20180814142242_add_featured_to_videos.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20180815101517_add_privacy_policy_to_users.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20180816062340_allow_null_to_password_digest_on_users.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20180816132226_add_social_links_to_coaches.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20180912082045_add_interval_interval_count_and_trial_days_to_plans.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20180912190441_add_plan_type_to_users.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20180926145052_split_fullname_from_users.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20181004140305_add_applicable_to_stripe_plans.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20181016062659_add_canceled_fields_to_subscriptions.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20181113065836_create_stripe_invoices.rb');
INSERT INTO "schema_migrations" ("filename") VALUES ('20181113071410_create_stripe_invoice_items.rb');