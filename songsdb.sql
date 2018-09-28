--
-- PostgreSQL database dump
--

-- Dumped from database version 10.5 (Ubuntu 10.5-0ubuntu0.18.04)
-- Dumped by pg_dump version 10.5 (Ubuntu 10.5-0ubuntu0.18.04)

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
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: auth_group; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auth_group (
    id integer NOT NULL,
    name character varying(80) NOT NULL
);


ALTER TABLE public.auth_group OWNER TO postgres;

--
-- Name: auth_group_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.auth_group_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_group_id_seq OWNER TO postgres;

--
-- Name: auth_group_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.auth_group_id_seq OWNED BY public.auth_group.id;


--
-- Name: auth_group_permissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auth_group_permissions (
    id integer NOT NULL,
    group_id integer NOT NULL,
    permission_id integer NOT NULL
);


ALTER TABLE public.auth_group_permissions OWNER TO postgres;

--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.auth_group_permissions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_group_permissions_id_seq OWNER TO postgres;

--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.auth_group_permissions_id_seq OWNED BY public.auth_group_permissions.id;


--
-- Name: auth_permission; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auth_permission (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    content_type_id integer NOT NULL,
    codename character varying(100) NOT NULL
);


ALTER TABLE public.auth_permission OWNER TO postgres;

--
-- Name: auth_permission_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.auth_permission_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_permission_id_seq OWNER TO postgres;

--
-- Name: auth_permission_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.auth_permission_id_seq OWNED BY public.auth_permission.id;


--
-- Name: auth_user; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auth_user (
    id integer NOT NULL,
    password character varying(128) NOT NULL,
    last_login timestamp with time zone,
    is_superuser boolean NOT NULL,
    username character varying(150) NOT NULL,
    first_name character varying(30) NOT NULL,
    last_name character varying(150) NOT NULL,
    email character varying(254) NOT NULL,
    is_staff boolean NOT NULL,
    is_active boolean NOT NULL,
    date_joined timestamp with time zone NOT NULL
);


ALTER TABLE public.auth_user OWNER TO postgres;

--
-- Name: auth_user_groups; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auth_user_groups (
    id integer NOT NULL,
    user_id integer NOT NULL,
    group_id integer NOT NULL
);


ALTER TABLE public.auth_user_groups OWNER TO postgres;

--
-- Name: auth_user_groups_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.auth_user_groups_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_user_groups_id_seq OWNER TO postgres;

--
-- Name: auth_user_groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.auth_user_groups_id_seq OWNED BY public.auth_user_groups.id;


--
-- Name: auth_user_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.auth_user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_user_id_seq OWNER TO postgres;

--
-- Name: auth_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.auth_user_id_seq OWNED BY public.auth_user.id;


--
-- Name: auth_user_user_permissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auth_user_user_permissions (
    id integer NOT NULL,
    user_id integer NOT NULL,
    permission_id integer NOT NULL
);


ALTER TABLE public.auth_user_user_permissions OWNER TO postgres;

--
-- Name: auth_user_user_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.auth_user_user_permissions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_user_user_permissions_id_seq OWNER TO postgres;

--
-- Name: auth_user_user_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.auth_user_user_permissions_id_seq OWNED BY public.auth_user_user_permissions.id;


--
-- Name: django_admin_log; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.django_admin_log (
    id integer NOT NULL,
    action_time timestamp with time zone NOT NULL,
    object_id text,
    object_repr character varying(200) NOT NULL,
    action_flag smallint NOT NULL,
    change_message text NOT NULL,
    content_type_id integer,
    user_id integer NOT NULL,
    CONSTRAINT django_admin_log_action_flag_check CHECK ((action_flag >= 0))
);


ALTER TABLE public.django_admin_log OWNER TO postgres;

--
-- Name: django_admin_log_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.django_admin_log_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.django_admin_log_id_seq OWNER TO postgres;

--
-- Name: django_admin_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.django_admin_log_id_seq OWNED BY public.django_admin_log.id;


--
-- Name: django_content_type; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.django_content_type (
    id integer NOT NULL,
    app_label character varying(100) NOT NULL,
    model character varying(100) NOT NULL
);


ALTER TABLE public.django_content_type OWNER TO postgres;

--
-- Name: django_content_type_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.django_content_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.django_content_type_id_seq OWNER TO postgres;

--
-- Name: django_content_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.django_content_type_id_seq OWNED BY public.django_content_type.id;


--
-- Name: django_migrations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.django_migrations (
    id integer NOT NULL,
    app character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    applied timestamp with time zone NOT NULL
);


ALTER TABLE public.django_migrations OWNER TO postgres;

--
-- Name: django_migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.django_migrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.django_migrations_id_seq OWNER TO postgres;

--
-- Name: django_migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.django_migrations_id_seq OWNED BY public.django_migrations.id;


--
-- Name: django_session; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.django_session (
    session_key character varying(40) NOT NULL,
    session_data text NOT NULL,
    expire_date timestamp with time zone NOT NULL
);


ALTER TABLE public.django_session OWNER TO postgres;

--
-- Name: songs_album; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.songs_album (
    id integer NOT NULL,
    title character varying(64) NOT NULL,
    artist_id integer NOT NULL
);


ALTER TABLE public.songs_album OWNER TO postgres;

--
-- Name: songs_album_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.songs_album_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.songs_album_id_seq OWNER TO postgres;

--
-- Name: songs_album_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.songs_album_id_seq OWNED BY public.songs_album.id;


--
-- Name: songs_artist; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.songs_artist (
    id integer NOT NULL,
    name character varying(64) NOT NULL
);


ALTER TABLE public.songs_artist OWNER TO postgres;

--
-- Name: songs_artist_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.songs_artist_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.songs_artist_id_seq OWNER TO postgres;

--
-- Name: songs_artist_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.songs_artist_id_seq OWNED BY public.songs_artist.id;


--
-- Name: songs_genre; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.songs_genre (
    id integer NOT NULL,
    genre character varying(64) NOT NULL
);


ALTER TABLE public.songs_genre OWNER TO postgres;

--
-- Name: songs_genre_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.songs_genre_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.songs_genre_id_seq OWNER TO postgres;

--
-- Name: songs_genre_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.songs_genre_id_seq OWNED BY public.songs_genre.id;


--
-- Name: songs_playlist; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.songs_playlist (
    id integer NOT NULL,
    name character varying(64) NOT NULL,
    user_id integer NOT NULL
);


ALTER TABLE public.songs_playlist OWNER TO postgres;

--
-- Name: songs_playlist_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.songs_playlist_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.songs_playlist_id_seq OWNER TO postgres;

--
-- Name: songs_playlist_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.songs_playlist_id_seq OWNED BY public.songs_playlist.id;


--
-- Name: songs_playlist_song; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.songs_playlist_song (
    id integer NOT NULL,
    playlist_id integer NOT NULL,
    song_id integer NOT NULL
);


ALTER TABLE public.songs_playlist_song OWNER TO postgres;

--
-- Name: songs_playlist_song_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.songs_playlist_song_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.songs_playlist_song_id_seq OWNER TO postgres;

--
-- Name: songs_playlist_song_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.songs_playlist_song_id_seq OWNED BY public.songs_playlist_song.id;


--
-- Name: songs_song; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.songs_song (
    id integer NOT NULL,
    title character varying(64) NOT NULL,
    album_id integer NOT NULL,
    genre_id integer NOT NULL,
    path character varying(100) NOT NULL
);


ALTER TABLE public.songs_song OWNER TO postgres;

--
-- Name: songs_song_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.songs_song_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.songs_song_id_seq OWNER TO postgres;

--
-- Name: songs_song_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.songs_song_id_seq OWNED BY public.songs_song.id;


--
-- Name: auth_group id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group ALTER COLUMN id SET DEFAULT nextval('public.auth_group_id_seq'::regclass);


--
-- Name: auth_group_permissions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group_permissions ALTER COLUMN id SET DEFAULT nextval('public.auth_group_permissions_id_seq'::regclass);


--
-- Name: auth_permission id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_permission ALTER COLUMN id SET DEFAULT nextval('public.auth_permission_id_seq'::regclass);


--
-- Name: auth_user id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user ALTER COLUMN id SET DEFAULT nextval('public.auth_user_id_seq'::regclass);


--
-- Name: auth_user_groups id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user_groups ALTER COLUMN id SET DEFAULT nextval('public.auth_user_groups_id_seq'::regclass);


--
-- Name: auth_user_user_permissions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user_user_permissions ALTER COLUMN id SET DEFAULT nextval('public.auth_user_user_permissions_id_seq'::regclass);


--
-- Name: django_admin_log id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_admin_log ALTER COLUMN id SET DEFAULT nextval('public.django_admin_log_id_seq'::regclass);


--
-- Name: django_content_type id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_content_type ALTER COLUMN id SET DEFAULT nextval('public.django_content_type_id_seq'::regclass);


--
-- Name: django_migrations id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_migrations ALTER COLUMN id SET DEFAULT nextval('public.django_migrations_id_seq'::regclass);


--
-- Name: songs_album id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.songs_album ALTER COLUMN id SET DEFAULT nextval('public.songs_album_id_seq'::regclass);


--
-- Name: songs_artist id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.songs_artist ALTER COLUMN id SET DEFAULT nextval('public.songs_artist_id_seq'::regclass);


--
-- Name: songs_genre id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.songs_genre ALTER COLUMN id SET DEFAULT nextval('public.songs_genre_id_seq'::regclass);


--
-- Name: songs_playlist id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.songs_playlist ALTER COLUMN id SET DEFAULT nextval('public.songs_playlist_id_seq'::regclass);


--
-- Name: songs_playlist_song id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.songs_playlist_song ALTER COLUMN id SET DEFAULT nextval('public.songs_playlist_song_id_seq'::regclass);


--
-- Name: songs_song id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.songs_song ALTER COLUMN id SET DEFAULT nextval('public.songs_song_id_seq'::regclass);


--
-- Data for Name: auth_group; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.auth_group (id, name) FROM stdin;
\.


--
-- Data for Name: auth_group_permissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.auth_group_permissions (id, group_id, permission_id) FROM stdin;
\.


--
-- Data for Name: auth_permission; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.auth_permission (id, name, content_type_id, codename) FROM stdin;
1	Can add log entry	1	add_logentry
2	Can change log entry	1	change_logentry
3	Can delete log entry	1	delete_logentry
4	Can add permission	2	add_permission
5	Can change permission	2	change_permission
6	Can delete permission	2	delete_permission
7	Can add group	3	add_group
8	Can change group	3	change_group
9	Can delete group	3	delete_group
10	Can add user	4	add_user
11	Can change user	4	change_user
12	Can delete user	4	delete_user
13	Can add content type	5	add_contenttype
14	Can change content type	5	change_contenttype
15	Can delete content type	5	delete_contenttype
16	Can add session	6	add_session
17	Can change session	6	change_session
18	Can delete session	6	delete_session
19	Can add song	7	add_song
20	Can change song	7	change_song
21	Can delete song	7	delete_song
22	Can add artist	8	add_artist
23	Can change artist	8	change_artist
24	Can delete artist	8	delete_artist
25	Can add playlist	9	add_playlist
26	Can change playlist	9	change_playlist
27	Can delete playlist	9	delete_playlist
28	Can add genre	10	add_genre
29	Can change genre	10	change_genre
30	Can delete genre	10	delete_genre
31	Can add album	11	add_album
32	Can change album	11	change_album
33	Can delete album	11	delete_album
\.


--
-- Data for Name: auth_user; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.auth_user (id, password, last_login, is_superuser, username, first_name, last_name, email, is_staff, is_active, date_joined) FROM stdin;
1	pbkdf2_sha256$100000$FIAgYjulnNkV$K7wqjpPvkF69vgbRONtM7qr7tN+yExx/ZVlb1/GmGz0=	2018-09-27 14:59:56.273228+08	t	csd			marejean.perpinosa@asti.dost.gov.ph	t	t	2018-09-25 15:51:59.575999+08
6	pbkdf2_sha256$100000$yNeQVTQxRxCo$JpkH6PWPQNuOJw01RSs1lOlr264Rwa9s2UpGyq9eAUY=	2018-09-27 16:00:51.348526+08	f	marejean				f	t	2018-09-27 10:24:33.23674+08
\.


--
-- Data for Name: auth_user_groups; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.auth_user_groups (id, user_id, group_id) FROM stdin;
\.


--
-- Data for Name: auth_user_user_permissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.auth_user_user_permissions (id, user_id, permission_id) FROM stdin;
\.


--
-- Data for Name: django_admin_log; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.django_admin_log (id, action_time, object_id, object_repr, action_flag, change_message, content_type_id, user_id) FROM stdin;
1	2018-09-25 16:56:46.724891+08	1	RnB	1	[{"added": {}}]	10	1
2	2018-09-25 16:56:50.089245+08	1	RnB	2	[]	10	1
3	2018-09-25 16:56:55.343976+08	2	Rock	1	[{"added": {}}]	10	1
4	2018-09-25 16:56:59.688271+08	3	Country	1	[{"added": {}}]	10	1
5	2018-09-25 16:57:04.831428+08	4	Rap	1	[{"added": {}}]	10	1
6	2018-09-25 16:57:09.930505+08	5	Party Song	1	[{"added": {}}]	10	1
7	2018-09-25 16:57:19.056536+08	6	Pop	1	[{"added": {}}]	10	1
8	2018-09-25 16:57:42.832494+08	7	Asian	1	[{"added": {}}]	10	1
9	2018-09-25 16:57:46.874747+08	8	Pop	1	[{"added": {}}]	10	1
10	2018-09-25 17:27:40.188701+08	1	Lenka	1	[{"added": {}}]	8	1
11	2018-09-25 17:27:50.490109+08	9	Pop	1	[{"added": {}}]	10	1
12	2018-09-25 17:28:21.477784+08	9	Pop	3		10	1
13	2018-09-25 17:28:21.499088+08	8	Pop	3		10	1
14	2018-09-25 17:38:42.689645+08	1	Two	1	[{"added": {}}]	11	1
15	2018-09-25 17:39:24.339712+08	1	The Show	1	[{"added": {}}]	7	1
16	2018-09-26 12:22:19.90116+08	2	Make It Big	1	[{"added": {}}]	11	1
17	2018-09-26 12:22:46.832808+08	2	Make It Big	3		11	1
18	2018-09-26 12:23:09.595634+08	2	Wham!	1	[{"added": {}}]	8	1
19	2018-09-26 12:23:22.803049+08	3	Iggy Azalea	1	[{"added": {}}]	8	1
20	2018-09-26 12:23:29.736638+08	4	Carly Rae Jepsen	1	[{"added": {}}]	8	1
21	2018-09-26 12:23:35.622741+08	5	Bruno Mars	1	[{"added": {}}]	8	1
22	2018-09-26 12:23:41.610918+08	6	Lionel Richie	1	[{"added": {}}]	8	1
23	2018-09-26 12:23:48.719549+08	7	Blackpink	1	[{"added": {}}]	8	1
24	2018-09-26 12:23:55.692942+08	8	Big Bang	1	[{"added": {}}]	8	1
25	2018-09-26 12:24:01.811068+08	9	Exo	1	[{"added": {}}]	8	1
26	2018-09-26 12:24:09.193109+08	10	Twice	1	[{"added": {}}]	8	1
27	2018-09-26 12:24:15.696537+08	11	Infinite	1	[{"added": {}}]	8	1
28	2018-09-26 12:24:21.876942+08	12	Drake	1	[{"added": {}}]	8	1
29	2018-09-26 12:24:27.195878+08	13	Ariana Grande	1	[{"added": {}}]	8	1
30	2018-09-26 12:24:33.20481+08	14	Maroon 5	1	[{"added": {}}]	8	1
31	2018-09-26 12:24:42.533029+08	15	OneRepublic	1	[{"added": {}}]	8	1
32	2018-09-26 12:24:49.886923+08	16	Taylor Swift	1	[{"added": {}}]	8	1
33	2018-09-26 12:24:55.319106+08	17	Kelly Clarkson	1	[{"added": {}}]	8	1
34	2018-09-26 12:25:00.390068+08	18	Demi Lovato	1	[{"added": {}}]	8	1
35	2018-09-26 12:25:10.957249+08	19	James Blunt	1	[{"added": {}}]	8	1
36	2018-09-26 12:25:18.018871+08	20	Bon Jovi	1	[{"added": {}}]	8	1
37	2018-09-26 12:25:25.218994+08	21	Journey	1	[{"added": {}}]	8	1
38	2018-09-26 12:25:31.259919+08	22	Usher Ft. Alicia Keys	1	[{"added": {}}]	8	1
39	2018-09-26 12:25:37.972147+08	23	Neyo Ft. Kelly Clarkson	1	[{"added": {}}]	8	1
40	2018-09-26 12:25:44.203939+08	24	Shontelle	1	[{"added": {}}]	8	1
41	2018-09-26 12:25:49.76563+08	25	Kendrick Lamar	1	[{"added": {}}]	8	1
42	2018-09-26 12:25:59.541926+08	26	Maroon 5 Ft. Cardi B	1	[{"added": {}}]	8	1
43	2018-09-26 12:26:05.086641+08	27	The Wolves	1	[{"added": {}}]	8	1
44	2018-09-26 12:26:10.692936+08	28	Twenty One Pilots	1	[{"added": {}}]	8	1
45	2018-09-26 12:26:16.523362+08	29	Snow Patrol	1	[{"added": {}}]	8	1
46	2018-09-26 12:26:21.598049+08	30	Queen	1	[{"added": {}}]	8	1
47	2018-09-26 12:26:34.176911+08	31	Aerosmith	1	[{"added": {}}]	8	1
48	2018-09-26 12:26:41.588701+08	32	Sugarland Ft. Taylor Swift	1	[{"added": {}}]	8	1
49	2018-09-26 12:26:47.39778+08	33	Lady Antebellum	1	[{"added": {}}]	8	1
50	2018-09-26 12:26:53.148346+08	34	Lanco	1	[{"added": {}}]	8	1
51	2018-09-26 12:26:58.595066+08	35	Little Big Town	1	[{"added": {}}]	8	1
52	2018-09-26 12:27:03.820739+08	36	Thomas Relt	1	[{"added": {}}]	8	1
53	2018-09-26 12:27:14.912128+08	37	Cardi B	1	[{"added": {}}]	8	1
54	2018-09-26 12:27:25.642597+08	38	Lil Dicky ft Chris Brown, DJ Khaled, Kendall Jenner	1	[{"added": {}}]	8	1
55	2018-09-26 12:27:36.363519+08	39	Nicki Minaj	1	[{"added": {}}]	8	1
56	2018-09-26 12:27:42.522183+08	40	Lil Wayne	1	[{"added": {}}]	8	1
57	2018-09-26 12:27:48.508981+08	41	Big Sean	1	[{"added": {}}]	8	1
58	2018-09-26 12:28:14.43418+08	3	Make It Big	1	[{"added": {}}]	11	1
59	2018-09-26 12:28:24.669628+08	4	The New Classic	1	[{"added": {}}]	11	1
60	2018-09-26 12:28:32.908632+08	5	Kiss	1	[{"added": {}}]	11	1
61	2018-09-26 12:28:41.321476+08	6	Unorthodox Jukebox	1	[{"added": {}}]	11	1
62	2018-09-26 12:28:51.702393+08	7	Can't Slow Down	1	[{"added": {}}]	11	1
63	2018-09-26 12:29:00.70457+08	8	Square Up	1	[{"added": {}}]	11	1
64	2018-09-26 12:29:11.615032+08	9	Alive	1	[{"added": {}}]	11	1
65	2018-09-26 12:29:20.197231+08	10	XOXO	1	[{"added": {}}]	11	1
66	2018-09-26 12:29:28.863978+08	11	Summer Nights	1	[{"added": {}}]	11	1
67	2018-09-26 12:29:39.454703+08	12	Season 2	1	[{"added": {}}]	11	1
68	2018-09-26 12:29:48.753686+08	13	Scorpion	1	[{"added": {}}]	11	1
69	2018-09-26 12:29:58.971866+08	14	Sweetener	1	[{"added": {}}]	11	1
70	2018-09-26 12:30:08.486905+08	15	Overexposed	1	[{"added": {}}]	11	1
71	2018-09-26 12:30:23.199776+08	16	Native	1	[{"added": {}}]	11	1
72	2018-09-26 12:30:35.15332+08	17	1989	1	[{"added": {}}]	11	1
73	2018-09-26 12:30:46.491605+08	18	Stronger	1	[{"added": {}}]	11	1
74	2018-09-26 12:30:55.828437+08	19	Unbroken	1	[{"added": {}}]	11	1
75	2018-09-26 12:31:06.055365+08	20	Back to Bedlam	1	[{"added": {}}]	11	1
76	2018-09-26 12:31:14.749873+08	21	Crush	1	[{"added": {}}]	11	1
77	2018-09-26 12:31:24.725933+08	22	Escape	1	[{"added": {}}]	11	1
78	2018-09-26 12:31:34.071545+08	23	Confessions	1	[{"added": {}}]	11	1
79	2018-09-26 12:31:45.412716+08	24	Exclusive	1	[{"added": {}}]	11	1
80	2018-09-26 12:31:57.476897+08	25	Shontelligence	1	[{"added": {}}]	11	1
81	2018-09-26 12:32:10.364899+08	26	Black Panther: The Album	1	[{"added": {}}]	11	1
82	2018-09-26 12:32:23.99114+08	27	Red Pill Blues	1	[{"added": {}}]	11	1
83	2018-09-26 12:32:34.549511+08	28	Disobey	1	[{"added": {}}]	11	1
84	2018-09-26 12:32:44.016771+08	29	Trench	1	[{"added": {}}]	11	1
85	2018-09-26 12:32:53.967832+08	30	Wildness	1	[{"added": {}}]	11	1
86	2018-09-26 12:33:07.699186+08	31	A Night at the Opera	1	[{"added": {}}]	11	1
87	2018-09-26 12:33:16.587383+08	32	Toys in the Attic	1	[{"added": {}}]	11	1
88	2018-09-26 12:33:28.081543+08	33	Bigger	1	[{"added": {}}]	11	1
89	2018-09-26 12:33:39.864044+08	34	Need You Now	1	[{"added": {}}]	11	1
90	2018-09-26 12:33:49.122309+08	35	Hallelujah Nights	1	[{"added": {}}]	11	1
91	2018-09-26 12:34:05.69447+08	36	Pain Killer	1	[{"added": {}}]	11	1
92	2018-09-26 12:34:27.522027+08	37	Bodak Yellow	1	[{"added": {}}]	11	1
93	2018-09-26 12:34:42.687527+08	38	N/A	1	[{"added": {}}]	11	1
94	2018-09-26 12:34:51.631621+08	39	Pink Friday	1	[{"added": {}}]	11	1
95	2018-09-26 12:35:05.455139+08	40	The Carter II	1	[{"added": {}}]	11	1
96	2018-09-26 12:35:13.981782+08	41	Decided	1	[{"added": {}}]	11	1
97	2018-09-26 12:36:17.624844+08	10	Inspirational	1	[{"added": {}}]	10	1
98	2018-09-26 12:37:26.264467+08	2	Wake Me Up Before You Go Go	1	[{"added": {}}]	7	1
99	2018-09-26 12:38:00.550555+08	3	Fancy	1	[{"added": {}}]	7	1
100	2018-09-26 12:38:18.698214+08	4	Call Me Maybe	1	[{"added": {}}]	7	1
101	2018-09-26 12:38:37.768427+08	5	Treasure	1	[{"added": {}}]	7	1
102	2018-09-26 12:39:00.175712+08	6	All Night Long	1	[{"added": {}}]	7	1
103	2018-09-26 13:30:34.957155+08	7	my boo	1	[{"added": {}}]	7	1
104	2018-09-26 13:31:17.758286+08	8	superhuman	1	[{"added": {}}]	7	1
105	2018-09-26 13:31:52.458581+08	9	t - shirt	1	[{"added": {}}]	7	1
106	2018-09-26 13:32:04.965197+08	9	t - shirt	2	[]	7	1
107	2018-09-26 13:32:49.23606+08	10	girls lke you	1	[{"added": {}}]	7	1
108	2018-09-26 13:33:33.620711+08	11	all the stars	1	[{"added": {}}]	7	1
109	2018-09-26 13:38:07.308887+08	12	zombies	1	[{"added": {}}]	7	1
110	2018-09-26 13:38:57.536891+08	13	Jumpsuit	1	[{"added": {}}]	7	1
111	2018-09-26 13:47:50.141886+08	12	zombies	3		7	1
112	2018-09-26 13:47:50.15471+08	11	all the stars	3		7	1
113	2018-09-26 13:47:50.16306+08	10	girls lke you	3		7	1
114	2018-09-26 13:47:50.1714+08	9	t - shirt	3		7	1
115	2018-09-26 13:47:50.179744+08	8	superhuman	3		7	1
116	2018-09-26 13:47:50.188083+08	7	my boo	3		7	1
117	2018-09-26 13:48:41.632565+08	14	My Boo	1	[{"added": {}}]	7	1
118	2018-09-26 13:49:18.418123+08	15	Superhuman	1	[{"added": {}}]	7	1
119	2018-09-26 13:49:45.333154+08	16	T - Shirt	1	[{"added": {}}]	7	1
120	2018-09-26 13:50:40.952725+08	17	Girls Like You	1	[{"added": {}}]	7	1
121	2018-09-26 13:51:17.877989+08	18	All the Stars	1	[{"added": {}}]	7	1
122	2018-09-26 13:51:44.543657+08	19	Zombies	1	[{"added": {}}]	7	1
123	2018-09-26 13:52:07.352919+08	20	Don't Give In	1	[{"added": {}}]	7	1
124	2018-09-26 13:52:44.338301+08	21	Bohemian Rhapsody	1	[{"added": {}}]	7	1
125	2018-09-26 13:55:20.924518+08	22	Walk This Way	1	[{"added": {}}]	7	1
126	2018-09-26 13:55:58.549813+08	23	Babe	1	[{"added": {}}]	7	1
127	2018-09-26 13:56:27.305889+08	24	Need You Now	1	[{"added": {}}]	7	1
128	2018-09-26 13:57:19.637583+08	25	Greatest Love Story	1	[{"added": {}}]	7	1
129	2018-09-26 13:58:49.994418+08	26	Girl Crush	1	[{"added": {}}]	7	1
130	2018-09-26 14:02:17.094401+08	27	Marry Me	1	[{"added": {}}]	7	1
131	2018-09-26 14:03:07.106387+08	28	Bodak Yellow	1	[{"added": {}}]	7	1
132	2018-09-26 14:03:50.738052+08	29	Freaky Friday	1	[{"added": {}}]	7	1
133	2018-09-26 14:05:39.425908+08	30	Super Bass	1	[{"added": {}}]	7	1
134	2018-09-26 14:06:15.753476+08	31	Lollipop	1	[{"added": {}}]	7	1
135	2018-09-26 14:06:36.731141+08	32	Bounce Back	1	[{"added": {}}]	7	1
136	2018-09-27 15:16:16.003204+08	1	The Show	3		7	1
\.


--
-- Data for Name: django_content_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.django_content_type (id, app_label, model) FROM stdin;
1	admin	logentry
2	auth	permission
3	auth	group
4	auth	user
5	contenttypes	contenttype
6	sessions	session
7	songs	song
8	songs	artist
9	songs	playlist
10	songs	genre
11	songs	album
\.


--
-- Data for Name: django_migrations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.django_migrations (id, app, name, applied) FROM stdin;
1	contenttypes	0001_initial	2018-09-25 15:51:18.503641+08
2	auth	0001_initial	2018-09-25 15:51:19.246796+08
3	admin	0001_initial	2018-09-25 15:51:19.421724+08
4	admin	0002_logentry_remove_auto_add	2018-09-25 15:51:19.442705+08
5	contenttypes	0002_remove_content_type_name	2018-09-25 15:51:19.479599+08
6	auth	0002_alter_permission_name_max_length	2018-09-25 15:51:19.496212+08
7	auth	0003_alter_user_email_max_length	2018-09-25 15:51:19.521315+08
8	auth	0004_alter_user_username_opts	2018-09-25 15:51:19.53735+08
9	auth	0005_alter_user_last_login_null	2018-09-25 15:51:19.563285+08
10	auth	0006_require_contenttypes_0002	2018-09-25 15:51:19.571431+08
11	auth	0007_alter_validators_add_error_messages	2018-09-25 15:51:19.592408+08
12	auth	0008_alter_user_username_max_length	2018-09-25 15:51:19.66327+08
13	auth	0009_alter_user_last_name_max_length	2018-09-25 15:51:19.687947+08
14	sessions	0001_initial	2018-09-25 15:51:19.86364+08
15	songs	0001_initial	2018-09-25 15:56:43.805661+08
16	songs	0002_song_path	2018-09-25 17:26:36.130312+08
17	songs	0003_auto_20180925_0937	2018-09-25 17:37:46.13778+08
\.


--
-- Data for Name: django_session; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.django_session (session_key, session_data, expire_date) FROM stdin;
gloi7ja4c1geduuv28vimjqnuau337zb	Y2UwYWI2OTI5NTFhMjA4YTk2ZDRlM2JmM2UxOTM4ZmFjMmVjZDA2Yzp7Il9hdXRoX3VzZXJfaWQiOiIxIiwiX2F1dGhfdXNlcl9iYWNrZW5kIjoiZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmQiLCJfYXV0aF91c2VyX2hhc2giOiJiMDljYjY1YjE2N2ZlNGNkMzBiMTUwZDViZjFiZWE4MmJiMjk4OTUxIn0=	2018-10-09 15:52:19.320762+08
ikke6fgjyfer06ujfe1fh70vbq54vme2	Y2UwYWI2OTI5NTFhMjA4YTk2ZDRlM2JmM2UxOTM4ZmFjMmVjZDA2Yzp7Il9hdXRoX3VzZXJfaWQiOiIxIiwiX2F1dGhfdXNlcl9iYWNrZW5kIjoiZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmQiLCJfYXV0aF91c2VyX2hhc2giOiJiMDljYjY1YjE2N2ZlNGNkMzBiMTUwZDViZjFiZWE4MmJiMjk4OTUxIn0=	2018-10-10 09:27:37.924934+08
ui75lfd69twu2d58gy3b9z5tlu4hwvab	Y2UwYWI2OTI5NTFhMjA4YTk2ZDRlM2JmM2UxOTM4ZmFjMmVjZDA2Yzp7Il9hdXRoX3VzZXJfaWQiOiIxIiwiX2F1dGhfdXNlcl9iYWNrZW5kIjoiZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmQiLCJfYXV0aF91c2VyX2hhc2giOiJiMDljYjY1YjE2N2ZlNGNkMzBiMTUwZDViZjFiZWE4MmJiMjk4OTUxIn0=	2018-10-10 13:11:44.936971+08
sja76cba13800ju8vcdkuuvwqqnu7xvr	Y2UwYWI2OTI5NTFhMjA4YTk2ZDRlM2JmM2UxOTM4ZmFjMmVjZDA2Yzp7Il9hdXRoX3VzZXJfaWQiOiIxIiwiX2F1dGhfdXNlcl9iYWNrZW5kIjoiZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmQiLCJfYXV0aF91c2VyX2hhc2giOiJiMDljYjY1YjE2N2ZlNGNkMzBiMTUwZDViZjFiZWE4MmJiMjk4OTUxIn0=	2018-10-10 13:20:15.107022+08
g1ot9nuvyk6udmcu8m363jludmswh89y	Y2UwYWI2OTI5NTFhMjA4YTk2ZDRlM2JmM2UxOTM4ZmFjMmVjZDA2Yzp7Il9hdXRoX3VzZXJfaWQiOiIxIiwiX2F1dGhfdXNlcl9iYWNrZW5kIjoiZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmQiLCJfYXV0aF91c2VyX2hhc2giOiJiMDljYjY1YjE2N2ZlNGNkMzBiMTUwZDViZjFiZWE4MmJiMjk4OTUxIn0=	2018-10-10 15:40:52.599738+08
yqw1djx8v50nwdd4ibk3j32izm14oyv1	ZDA0NWU2ZTkzZjJlNDE5OTFjZWRiNTY3ZTkxYmQwOTNlMzAwNGRiMzp7Il9hdXRoX3VzZXJfaWQiOiI2IiwiX2F1dGhfdXNlcl9iYWNrZW5kIjoiZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmQiLCJfYXV0aF91c2VyX2hhc2giOiIzOWUzNzY0Yjk4Njc3NDA4NWIyYTA5NWMwZjM2MDQyM2ZmZTBjZGZiIn0=	2018-10-11 16:00:51.357194+08
\.


--
-- Data for Name: songs_album; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.songs_album (id, title, artist_id) FROM stdin;
1	Two	1
3	Make It Big	2
4	The New Classic	3
5	Kiss	4
6	Unorthodox Jukebox	5
7	Can't Slow Down	6
8	Square Up	7
9	Alive	8
10	XOXO	9
11	Summer Nights	10
12	Season 2	11
13	Scorpion	12
14	Sweetener	13
15	Overexposed	14
16	Native	15
17	1989	16
18	Stronger	17
19	Unbroken	18
20	Back to Bedlam	19
21	Crush	20
22	Escape	21
23	Confessions	22
24	Exclusive	23
25	Shontelligence	24
26	Black Panther: The Album	25
27	Red Pill Blues	26
28	Disobey	27
29	Trench	28
30	Wildness	29
31	A Night at the Opera	30
32	Toys in the Attic	31
33	Bigger	32
34	Need You Now	33
35	Hallelujah Nights	34
36	Pain Killer	35
37	Bodak Yellow	37
38	N/A	38
39	Pink Friday	39
40	The Carter II	40
41	Decided	41
\.


--
-- Data for Name: songs_artist; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.songs_artist (id, name) FROM stdin;
1	Lenka
2	Wham!
3	Iggy Azalea
4	Carly Rae Jepsen
5	Bruno Mars
6	Lionel Richie
7	Blackpink
8	Big Bang
9	Exo
10	Twice
11	Infinite
12	Drake
13	Ariana Grande
14	Maroon 5
15	OneRepublic
16	Taylor Swift
17	Kelly Clarkson
18	Demi Lovato
19	James Blunt
20	Bon Jovi
21	Journey
22	Usher Ft. Alicia Keys
23	Neyo Ft. Kelly Clarkson
24	Shontelle
25	Kendrick Lamar
26	Maroon 5 Ft. Cardi B
27	The Wolves
28	Twenty One Pilots
29	Snow Patrol
30	Queen
31	Aerosmith
32	Sugarland Ft. Taylor Swift
33	Lady Antebellum
34	Lanco
35	Little Big Town
36	Thomas Relt
37	Cardi B
38	Lil Dicky ft Chris Brown, DJ Khaled, Kendall Jenner
39	Nicki Minaj
40	Lil Wayne
41	Big Sean
\.


--
-- Data for Name: songs_genre; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.songs_genre (id, genre) FROM stdin;
1	RnB
2	Rock
3	Country
4	Rap
5	Party Song
6	Pop
7	Asian
10	Inspirational
\.


--
-- Data for Name: songs_playlist; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.songs_playlist (id, name, user_id) FROM stdin;
\.


--
-- Data for Name: songs_playlist_song; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.songs_playlist_song (id, playlist_id, song_id) FROM stdin;
\.


--
-- Data for Name: songs_song; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.songs_song (id, title, album_id, genre_id, path) FROM stdin;
2	Wake Me Up Before You Go Go	3	5	mp3_files/Wake_Me_Up_Before_You_Go_Go.mp3
3	Fancy	4	5	mp3_files/Fancy.mp3
4	Call Me Maybe	5	5	mp3_files/Call_Me_Maybe.mp3
5	Treasure	6	5	mp3_files/Treasure.mp3
6	All Night Long	7	5	mp3_files/All_Night_Long.mp3
13	Jumpsuit	29	2	mp3_files/Jumpsuit.mp3
14	My Boo	23	1	mp3_files/My_Boo_mZnZhcY.mp3
15	Superhuman	24	1	mp3_files/Superhuman_8IjZoAH.mp3
16	T - Shirt	25	1	mp3_files/T-_Shirt_vrbO83O.mp3
17	Girls Like You	27	1	mp3_files/Girls_Like_You_Om8haIh.mp3
18	All the Stars	26	1	mp3_files/All_the_Stars_JkDq0RX.mp3
19	Zombies	28	2	mp3_files/Zombies_29DzLsa.mp3
20	Don't Give In	30	2	mp3_files/Dont_Give_In.mp3
21	Bohemian Rhapsody	31	2	mp3_files/Bohemian_Rhapsody.mp3
22	Walk This Way	32	2	mp3_files/Walk_This_Way.mp3
23	Babe	33	3	mp3_files/Babe.mp3
24	Need You Now	34	3	mp3_files/Need_You_Now.mp3
25	Greatest Love Story	35	3	mp3_files/Greatest_Love_Story.mp3
26	Girl Crush	36	3	mp3_files/Girl_Crush.mp3
27	Marry Me	38	3	mp3_files/Marry_Me.mp3
28	Bodak Yellow	37	4	mp3_files/Bodak_Yellow.mp3
29	Freaky Friday	38	4	mp3_files/Freaky_Friday.mp3
30	Super Bass	39	4	mp3_files/Super_Bass.mp3
31	Lollipop	40	4	mp3_files/Lollipop.mp3
32	Bounce Back	41	4	mp3_files/Bounce_Back.mp3
\.


--
-- Name: auth_group_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.auth_group_id_seq', 1, false);


--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.auth_group_permissions_id_seq', 1, false);


--
-- Name: auth_permission_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.auth_permission_id_seq', 33, true);


--
-- Name: auth_user_groups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.auth_user_groups_id_seq', 1, false);


--
-- Name: auth_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.auth_user_id_seq', 6, true);


--
-- Name: auth_user_user_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.auth_user_user_permissions_id_seq', 1, false);


--
-- Name: django_admin_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.django_admin_log_id_seq', 136, true);


--
-- Name: django_content_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.django_content_type_id_seq', 11, true);


--
-- Name: django_migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.django_migrations_id_seq', 17, true);


--
-- Name: songs_album_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.songs_album_id_seq', 41, true);


--
-- Name: songs_artist_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.songs_artist_id_seq', 41, true);


--
-- Name: songs_genre_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.songs_genre_id_seq', 10, true);


--
-- Name: songs_playlist_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.songs_playlist_id_seq', 1, false);


--
-- Name: songs_playlist_song_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.songs_playlist_song_id_seq', 1, false);


--
-- Name: songs_song_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.songs_song_id_seq', 32, true);


--
-- Name: auth_group auth_group_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group
    ADD CONSTRAINT auth_group_name_key UNIQUE (name);


--
-- Name: auth_group_permissions auth_group_permissions_group_id_permission_id_0cd325b0_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_group_id_permission_id_0cd325b0_uniq UNIQUE (group_id, permission_id);


--
-- Name: auth_group_permissions auth_group_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_pkey PRIMARY KEY (id);


--
-- Name: auth_group auth_group_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group
    ADD CONSTRAINT auth_group_pkey PRIMARY KEY (id);


--
-- Name: auth_permission auth_permission_content_type_id_codename_01ab375a_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_content_type_id_codename_01ab375a_uniq UNIQUE (content_type_id, codename);


--
-- Name: auth_permission auth_permission_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_pkey PRIMARY KEY (id);


--
-- Name: auth_user_groups auth_user_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_pkey PRIMARY KEY (id);


--
-- Name: auth_user_groups auth_user_groups_user_id_group_id_94350c0c_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_user_id_group_id_94350c0c_uniq UNIQUE (user_id, group_id);


--
-- Name: auth_user auth_user_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user
    ADD CONSTRAINT auth_user_pkey PRIMARY KEY (id);


--
-- Name: auth_user_user_permissions auth_user_user_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_pkey PRIMARY KEY (id);


--
-- Name: auth_user_user_permissions auth_user_user_permissions_user_id_permission_id_14a6b632_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_user_id_permission_id_14a6b632_uniq UNIQUE (user_id, permission_id);


--
-- Name: auth_user auth_user_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user
    ADD CONSTRAINT auth_user_username_key UNIQUE (username);


--
-- Name: django_admin_log django_admin_log_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_pkey PRIMARY KEY (id);


--
-- Name: django_content_type django_content_type_app_label_model_76bd3d3b_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_content_type
    ADD CONSTRAINT django_content_type_app_label_model_76bd3d3b_uniq UNIQUE (app_label, model);


--
-- Name: django_content_type django_content_type_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_content_type
    ADD CONSTRAINT django_content_type_pkey PRIMARY KEY (id);


--
-- Name: django_migrations django_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_migrations
    ADD CONSTRAINT django_migrations_pkey PRIMARY KEY (id);


--
-- Name: django_session django_session_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_session
    ADD CONSTRAINT django_session_pkey PRIMARY KEY (session_key);


--
-- Name: songs_album songs_album_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.songs_album
    ADD CONSTRAINT songs_album_pkey PRIMARY KEY (id);


--
-- Name: songs_artist songs_artist_name_38bde1d2_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.songs_artist
    ADD CONSTRAINT songs_artist_name_38bde1d2_uniq UNIQUE (name);


--
-- Name: songs_artist songs_artist_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.songs_artist
    ADD CONSTRAINT songs_artist_pkey PRIMARY KEY (id);


--
-- Name: songs_genre songs_genre_genre_169e8f55_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.songs_genre
    ADD CONSTRAINT songs_genre_genre_169e8f55_uniq UNIQUE (genre);


--
-- Name: songs_genre songs_genre_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.songs_genre
    ADD CONSTRAINT songs_genre_pkey PRIMARY KEY (id);


--
-- Name: songs_playlist songs_playlist_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.songs_playlist
    ADD CONSTRAINT songs_playlist_pkey PRIMARY KEY (id);


--
-- Name: songs_playlist_song songs_playlist_song_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.songs_playlist_song
    ADD CONSTRAINT songs_playlist_song_pkey PRIMARY KEY (id);


--
-- Name: songs_playlist_song songs_playlist_song_playlist_id_song_id_8a294ea6_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.songs_playlist_song
    ADD CONSTRAINT songs_playlist_song_playlist_id_song_id_8a294ea6_uniq UNIQUE (playlist_id, song_id);


--
-- Name: songs_song songs_song_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.songs_song
    ADD CONSTRAINT songs_song_pkey PRIMARY KEY (id);


--
-- Name: auth_group_name_a6ea08ec_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_group_name_a6ea08ec_like ON public.auth_group USING btree (name varchar_pattern_ops);


--
-- Name: auth_group_permissions_group_id_b120cbf9; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_group_permissions_group_id_b120cbf9 ON public.auth_group_permissions USING btree (group_id);


--
-- Name: auth_group_permissions_permission_id_84c5c92e; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_group_permissions_permission_id_84c5c92e ON public.auth_group_permissions USING btree (permission_id);


--
-- Name: auth_permission_content_type_id_2f476e4b; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_permission_content_type_id_2f476e4b ON public.auth_permission USING btree (content_type_id);


--
-- Name: auth_user_groups_group_id_97559544; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_user_groups_group_id_97559544 ON public.auth_user_groups USING btree (group_id);


--
-- Name: auth_user_groups_user_id_6a12ed8b; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_user_groups_user_id_6a12ed8b ON public.auth_user_groups USING btree (user_id);


--
-- Name: auth_user_user_permissions_permission_id_1fbb5f2c; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_user_user_permissions_permission_id_1fbb5f2c ON public.auth_user_user_permissions USING btree (permission_id);


--
-- Name: auth_user_user_permissions_user_id_a95ead1b; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_user_user_permissions_user_id_a95ead1b ON public.auth_user_user_permissions USING btree (user_id);


--
-- Name: auth_user_username_6821ab7c_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_user_username_6821ab7c_like ON public.auth_user USING btree (username varchar_pattern_ops);


--
-- Name: django_admin_log_content_type_id_c4bce8eb; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX django_admin_log_content_type_id_c4bce8eb ON public.django_admin_log USING btree (content_type_id);


--
-- Name: django_admin_log_user_id_c564eba6; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX django_admin_log_user_id_c564eba6 ON public.django_admin_log USING btree (user_id);


--
-- Name: django_session_expire_date_a5c62663; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX django_session_expire_date_a5c62663 ON public.django_session USING btree (expire_date);


--
-- Name: django_session_session_key_c0390e0f_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX django_session_session_key_c0390e0f_like ON public.django_session USING btree (session_key varchar_pattern_ops);


--
-- Name: songs_album_artist_id_1a27259f; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX songs_album_artist_id_1a27259f ON public.songs_album USING btree (artist_id);


--
-- Name: songs_artist_name_38bde1d2_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX songs_artist_name_38bde1d2_like ON public.songs_artist USING btree (name varchar_pattern_ops);


--
-- Name: songs_genre_genre_169e8f55_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX songs_genre_genre_169e8f55_like ON public.songs_genre USING btree (genre varchar_pattern_ops);


--
-- Name: songs_playlist_song_playlist_id_7d19bd7a; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX songs_playlist_song_playlist_id_7d19bd7a ON public.songs_playlist_song USING btree (playlist_id);


--
-- Name: songs_playlist_song_song_id_062a2a8c; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX songs_playlist_song_song_id_062a2a8c ON public.songs_playlist_song USING btree (song_id);


--
-- Name: songs_playlist_user_id_28ae0584; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX songs_playlist_user_id_28ae0584 ON public.songs_playlist USING btree (user_id);


--
-- Name: songs_song_album_id_dcf4800d; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX songs_song_album_id_dcf4800d ON public.songs_song USING btree (album_id);


--
-- Name: songs_song_genre_id_15af3b02; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX songs_song_genre_id_15af3b02 ON public.songs_song USING btree (genre_id);


--
-- Name: auth_group_permissions auth_group_permissio_permission_id_84c5c92e_fk_auth_perm; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissio_permission_id_84c5c92e_fk_auth_perm FOREIGN KEY (permission_id) REFERENCES public.auth_permission(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_group_permissions auth_group_permissions_group_id_b120cbf9_fk_auth_group_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_group_id_b120cbf9_fk_auth_group_id FOREIGN KEY (group_id) REFERENCES public.auth_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_permission auth_permission_content_type_id_2f476e4b_fk_django_co; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_content_type_id_2f476e4b_fk_django_co FOREIGN KEY (content_type_id) REFERENCES public.django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_user_groups auth_user_groups_group_id_97559544_fk_auth_group_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_group_id_97559544_fk_auth_group_id FOREIGN KEY (group_id) REFERENCES public.auth_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_user_groups auth_user_groups_user_id_6a12ed8b_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_user_id_6a12ed8b_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_user_user_permissions auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm FOREIGN KEY (permission_id) REFERENCES public.auth_permission(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_user_user_permissions auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: django_admin_log django_admin_log_content_type_id_c4bce8eb_fk_django_co; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_content_type_id_c4bce8eb_fk_django_co FOREIGN KEY (content_type_id) REFERENCES public.django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: django_admin_log django_admin_log_user_id_c564eba6_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_user_id_c564eba6_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: songs_album songs_album_artist_id_1a27259f_fk_songs_artist_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.songs_album
    ADD CONSTRAINT songs_album_artist_id_1a27259f_fk_songs_artist_id FOREIGN KEY (artist_id) REFERENCES public.songs_artist(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: songs_playlist_song songs_playlist_song_playlist_id_7d19bd7a_fk_songs_playlist_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.songs_playlist_song
    ADD CONSTRAINT songs_playlist_song_playlist_id_7d19bd7a_fk_songs_playlist_id FOREIGN KEY (playlist_id) REFERENCES public.songs_playlist(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: songs_playlist_song songs_playlist_song_song_id_062a2a8c_fk_songs_song_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.songs_playlist_song
    ADD CONSTRAINT songs_playlist_song_song_id_062a2a8c_fk_songs_song_id FOREIGN KEY (song_id) REFERENCES public.songs_song(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: songs_playlist songs_playlist_user_id_28ae0584_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.songs_playlist
    ADD CONSTRAINT songs_playlist_user_id_28ae0584_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: songs_song songs_song_album_id_dcf4800d_fk_songs_album_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.songs_song
    ADD CONSTRAINT songs_song_album_id_dcf4800d_fk_songs_album_id FOREIGN KEY (album_id) REFERENCES public.songs_album(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: songs_song songs_song_genre_id_15af3b02_fk_songs_genre_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.songs_song
    ADD CONSTRAINT songs_song_genre_id_15af3b02_fk_songs_genre_id FOREIGN KEY (genre_id) REFERENCES public.songs_genre(id) DEFERRABLE INITIALLY DEFERRED;


--
-- PostgreSQL database dump complete
--

