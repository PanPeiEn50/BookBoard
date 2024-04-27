--
-- PostgreSQL database dump
--

-- Dumped from database version 15.4 (Debian 15.4-1.pgdg120+1)
-- Dumped by pg_dump version 15.4 (Debian 15.4-1.pgdg120+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: pg_trgm; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_trgm WITH SCHEMA public;


--
-- Name: EXTENSION pg_trgm; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_trgm IS 'text similarity measurement and index searching based on trigrams';


--
-- Name: update_updated_at(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_updated_at() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: authors; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.authors (
    author_id integer NOT NULL,
    first_name character varying(64),
    last_name character varying(128),
    date_of_birth character varying(64),
    number_of_books integer NOT NULL
);


ALTER TABLE public.authors OWNER TO postgres;

--
-- Name: authors_author_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.authors_author_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.authors_author_id_seq OWNER TO postgres;

--
-- Name: authors_author_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.authors_author_id_seq OWNED BY public.authors.author_id;


--
-- Name: book_author; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.book_author (
    book_id integer NOT NULL,
    author integer NOT NULL
);


ALTER TABLE public.book_author OWNER TO postgres;

--
-- Name: books; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.books (
    book_id integer NOT NULL,
    isbn bigint NOT NULL,
    title text NOT NULL,
    description text NOT NULL,
    genre character varying(64) NOT NULL,
    fiction boolean NOT NULL
);


ALTER TABLE public.books OWNER TO postgres;

--
-- Name: books_book_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.books_book_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.books_book_id_seq OWNER TO postgres;

--
-- Name: books_book_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.books_book_id_seq OWNED BY public.books.book_id;


--
-- Name: favorites; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.favorites (
    user_id integer NOT NULL,
    book_id integer NOT NULL,
    read boolean DEFAULT false
);


ALTER TABLE public.favorites OWNER TO postgres;

--
-- Name: reviews; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.reviews (
    user_id integer NOT NULL,
    book_id integer NOT NULL,
    stars smallint NOT NULL,
    content text NOT NULL,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now(),
    CONSTRAINT reviews_stars_check CHECK (((stars >= 1) AND (stars <= 5)))
);


ALTER TABLE public.reviews OWNER TO postgres;

--
-- Name: sessions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sessions (
    user_id integer NOT NULL
);


ALTER TABLE public.sessions OWNER TO postgres;

--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    user_id integer NOT NULL,
    username character varying(32) NOT NULL,
    password character varying(256) NOT NULL
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: users_user_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_user_id_seq OWNER TO postgres;

--
-- Name: users_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_user_id_seq OWNED BY public.users.user_id;


--
-- Name: authors author_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.authors ALTER COLUMN author_id SET DEFAULT nextval('public.authors_author_id_seq'::regclass);


--
-- Name: books book_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.books ALTER COLUMN book_id SET DEFAULT nextval('public.books_book_id_seq'::regclass);


--
-- Name: users user_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN user_id SET DEFAULT nextval('public.users_user_id_seq'::regclass);


--
-- Data for Name: authors; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.authors (author_id, first_name, last_name, date_of_birth, number_of_books) FROM stdin;
1	US	GOVERNMENT	July 4, 1776	23669
2	Simon	Unwin	1952	27
3	David	Morrell	1943	96
4	Summerson, John	Newenham	1904	48
5	Stephen	Biesty	1961-01-27	36
6	David	Macaulay	2 December 1946	99
7	David	Macaulay	2 December 1946	99
8	Gardner,	Helen	1878	19
9	Gardner,	Helen	1878	19
10	Thomas	Glavinic	2. April 1972	14
11	Junʾichirō	Tanizaki	1886	142
12	Paul	Wilton	1969	9
13	Elizabeth	Castro	1965	26
14	Michael	Grant	July 26, 1954	41
15	Robert Louis	Stevenson	13 November 1850	5142
16	Carroll,	Lewis	January 27, 1832	5
17	E.	Nesbit	15 August 1858	32
18	MacDonald,	George	1824	19
19	J. R. R.	Tolkien	3 January 1892	680
20	Baum, L.	Frank	15 May 1856	1
21	Baum, L.	Frank	15 May 1856	1
22	J. K.	Rowling	31 July 1965	471
23	Baum, L.	Frank	15 May 1856	1
24	E.	Nesbit	15 August 1858	32
25	Baum, L.	Frank	15 May 1856	1
26	Jules	Verne	8 February 1828	4789
27	Baum, L.	Frank	15 May 1856	1
28	E.	Nesbit	15 August 1858	32
29	Baum, L.	Frank	15 May 1856	1
30	Baum, L.	Frank	15 May 1856	1
31	Baum, L.	Frank	15 May 1856	1
32	Baum, L.	Frank	15 May 1856	1
33	Baum, L.	Frank	15 May 1856	1
34	E.	Nesbit	15 August 1858	32
35	Mikhail Afanasʹevich	Bulgakov	15 May 1891	270
36	Hugh	Lofting	14 January 1886	147
37	MacDonald,	George	1824	19
38	Jack	London	12 January 1876	2733
39	Voltaire	Voltaire	21 November 1694	2072
40	Brontë,	Charlotte	1816	746
41	William	Shakespeare	20 April 1564	9649
42	Frances Hodgson	Burnett	November 24, 1849	998
43	Mark	Twain	30 November 1835	23
44	William	Shakespeare	20 April 1564	9649
45	Montgomery, L. M. (Lucy Maud),	1874-1942	30 November 1874	993
46	Tolstoy,	Leo	9 September 1828	1
47	Collins,	Wilkie	8 Jan 1824	799
48	Douglass,	Frederick	1818	1
49	Orczy, Emmuska	Orczy	23 September 1865	1
50	Dante	Alighieri	1265	1598
51	E.	Nesbit	15 August 1858	32
52	Jerome, Jerome	K.	2 May 1859	0
53	E.	Nesbit	15 August 1858	32
54	Virgil.	Virgil.	15 October 70 BCE	20
55	Honoré de	Balzac	20 May 1799	5138
56	William	Shakespeare	20 April 1564	9649
57	Collins,	Wilkie	8 Jan 1824	799
58	Hardy,	Thomas	2 June 1840	8
59	William	Shakespeare	20 April 1564	9649
60	Joseph Sheridan Le	Fanu	28 Aug 1814	191
61	Stephen	King	September 21, 1947	663
62	William Peter	Blatty	1928	27
63	Stephen	King	September 21, 1947	663
64	Stephen	King	September 21, 1947	663
65	Ray	Bradbury	22 August 1920	639
66	V. C.	Andrews	6 June 1923	229
67	Stephen	King	September 21, 1947	663
68	Stephen	King	September 21, 1947	663
69	Stephen	King	September 21, 1947	663
70	Stephen	King	September 21, 1947	663
71	Stephen	King	September 21, 1947	663
72	Stephen	King	September 21, 1947	663
73	Stephen	King	September 21, 1947	663
74	Justin	Cronin	1962	15
75	Stephen	King	September 21, 1947	663
76	Anne	Rice	4 October 1941	300
77	Stephen	King	September 21, 1947	663
78	Stephen	King	September 21, 1947	663
79	V. C.	Andrews	6 June 1923	229
80	Dean R.	Koontz	9 July 1945	17
81	V. C.	Andrews	6 June 1923	229
82	Anne	Rice	4 October 1941	300
83	Sylvia	Plath	27 October 1932	33
84	Stephen	Chbosky	1970	7
85	Annie Payson	Call	1853	13
86	Alan	Watts	1915	108
87	Henning	Mankell	3 February 1948	108
88	Avi	Avi	23 Dec 1937	154
89	Richard Phillips	Feynman	1918	225
90	Anne	McCaffrey	1 April 1926	200
91	Qiaoanna	Keer	1944	190
92	Katherine	Applegate	9 October 1956	365
93	Oscar	Wilde	16 October 1854	3353
94	Gene	Zion	5 October 1913	39
95	Roddy	Doyle	1958	52
96	Doyle, Arthur	Conan	1859	1
97	Doyle, Arthur	Conan	1859	1
98	Doyle, Arthur	Conan	1859	1
99	H. G.	Wells	21 September 1866	4555
100	Doyle, Arthur	Conan	1859	1
101	Mark	Twain	30 November 1835	23
102	Chandler,	Raymond	1888	339
103	Agatha	Christie	15 September 1890	1428
104	Agatha	Christie	15 September 1890	1428
105	Agatha	Christie	15 September 1890	1428
106	Stephenie	Meyer	24 December 1973	168
107	J. S.	Fletcher	1863	187
108	A. A.	Milne	18 January 1882	1114
109	Christopher	Morley	1890	174
110	Gertrude Chandler	Warner	1890	358
111	Doyle, Arthur	Conan	1859	1
112	Poe, Edgar	Allan	19 January 1809	243
113	Ruth Stiles	Gannett	12 August 1923	16
114	Enid	Blyton	11 August 1897	4234
115	Susan	Cooper	1935	50
116	Mary Higgins	Clark	24 December 1927	841
117	John	Bellairs	1938	40
118	Gerónimo	Stilton	1958-01-01	0
119	Jeffrey	Archer	1940	169
120	Tom	Clancy	12 April 1947	767
121	Steven	Levy	1951	22
122	Robin	Nixon	1961	17
123	Charles	Dickens	7 February 1812	4320
124	Chesterton, G.	K.	29 May 1874	2
125	F. Scott	Fitzgerald	24 September 1896	593
126	Mark	Haddon	26 September 1962	96
127	Mitch	Albom	23 May 1958	46
128	Robert M.	Pirsig	6 Sep 1928	4
129	Gray,	John	28 Dec 1951	18
130	Ayn	Rand	February 2, 1905	209
131	Baldwin,	James	2 August 1924	1
132	Miller,	Arthur	1915	1
133	Robert	Greene	14 May 1959	59
134	Jodi	Picoult	19 May 1966	307
135	William	Styron	1925	121
136	Stephen	King	September 21, 1947	663
137	Yuval N.	Harari	24 February 1976	68
138	Steel,	Danielle.	August 14, 1947	1542
139	Brown,	Sandra	1948	160
140	Wilhelm	Reich	24 March 1897	118
141	Kazuo	Ishiguro	8 November 1954	39
142	Gabriel Garcia	Marquez	1927	407
143	Jung, C.	G.	1875.07.26	156
144	Fromm,	Erich	23 March 1900	4
145	Austen,	Jane	December 16, 1775	1242
146	Lawrence, D.	H.	1885	1
147	Conrad,	Joseph	3 December 1857	10
148	Edith	Wharton	24 January 1862	1091
149	Agatha	Christie	15 September 1890	1428
150	James,	Henry	15 April 1843	99
151	Agatha	Christie	15 September 1890	1428
152	Stephenie	Meyer	24 December 1973	168
153	Stephenie	Meyer	24 December 1973	168
154	Patricia	Highsmith	19 Jan 1921	132
155	V. C.	Andrews	6 June 1923	229
156	Bernhard	Schlink	6 July 1944	63
157	Edith	Wharton	24 January 1862	1091
158	Roy,	Arundhati.	24 November 1961	84
159	Ken	Follett	5 June 1949	105
160	Chimamanda Ngozi	Adichie	1977	44
161	Alessandro	Baricco	1958	75
162	Nicholas	Sparks	31 December 1965	384
163	Zane	Grey	31 January 1872	1787
164	Margaret Eleanor	Atwood	18 November 1939	411
165	Trollope,	Anthony	1815	0
166	Ken	Follett	5 June 1949	105
167	Mary Wollstonecraft	Shelley	30 August 1797	468
168	H. G.	Wells	21 September 1866	4555
169	Doyle, Arthur	Conan	1859	1
170	Jack	London	12 January 1876	2733
171	Edwin Abbott	Abbott	20 Dec 1838	110
172	Aldous	Huxley	26 July 1894	798
173	Conrad,	Joseph	3 December 1857	10
174	H. G.	Wells	21 September 1866	4555
175	Chesterton, G.	K.	29 May 1874	2
176	H. G.	Wells	21 September 1866	4555
177	H. G.	Wells	21 September 1866	4555
178	Burgess,	Anthony	25 February 1917	153
179	Arthur C.	Clarke	16 December 1917	743
180	H. G.	Wells	21 September 1866	4555
181	Suzanne	Collins	1962	61
182	H. G.	Wells	21 September 1866	4555
183	Carl	Sagan	9 November 1934	56
184	Vonnegut,	Kurt.	11 November 1922	2
185	Dick, Philip	K.	16 December 1928	488
186	George R. R.	Martin	September 20, 1948	439
187	Margaret Eleanor	Atwood	18 November 1939	411
188	H. G.	Wells	21 September 1866	4555
189	Dick, Philip	K.	16 December 1928	488
190	Suzanne	Collins	1962	61
191	Brontë,	Emily	1818	292
192	Edith	Wharton	24 January 1862	1091
193	Virginia	Woolf	25 January 1882	1094
194	John Stuart	Mill	20 May 1806	568
195	William	Shakespeare	20 April 1564	9649
196	Lawrence, D.	H.	1885	1
197	Virginia	Woolf	25 January 1882	1094
198	Kate	Chopin	1850	390
199	Virginia	Woolf	25 January 1882	1094
200	William	Shakespeare	20 April 1564	9649
201	Louisa May	Alcott	29 November 1832	783
202	Thackeray, William	Makepeace	18 July 1811	1
203	H. Rider	Haggard	1856	3386
204	Toni	Morrison	18 February 1931	122
205	Untinen Auel, Jean	Marie	18 February 1936	54
206	Louisa May	Alcott	29 November 1832	783
207	Helen	Fielding	19 Feb 1958	27
208	Chesterton, G.	K.	29 May 1874	2
209	Miguel de	Unamuno	1864	258
210	Williams,	Tennessee	26 March 1911	206
211	Isabel	Allende	2 August 1942	64
\.


--
-- Data for Name: book_author; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.book_author (book_id, author) FROM stdin;
1	1
2	2
3	3
4	4
5	5
6	6
7	6
7	7
8	8
9	8
9	9
10	10
11	11
12	12
13	13
14	14
15	15
16	16
17	17
18	18
19	19
20	20
21	20
21	21
22	22
23	20
23	21
23	23
24	17
24	24
25	20
25	21
25	23
25	25
26	26
27	20
27	21
27	23
27	25
27	27
28	17
28	24
28	28
29	20
29	21
29	23
29	25
29	27
29	29
30	20
30	21
30	23
30	25
30	27
30	29
30	30
31	20
31	21
31	23
31	25
31	27
31	29
31	30
31	31
32	20
32	21
32	23
32	25
32	27
32	29
32	30
32	31
32	32
33	20
33	21
33	23
33	25
33	27
33	29
33	30
33	31
33	32
33	33
34	17
34	24
34	28
34	34
35	35
36	36
37	18
37	37
38	38
39	39
40	40
41	41
42	42
43	43
44	41
44	44
45	45
46	46
47	47
48	48
49	49
50	50
51	17
51	24
51	28
51	34
51	51
52	52
53	17
53	24
53	28
53	34
53	51
53	53
54	54
55	55
56	41
56	44
56	56
57	47
57	57
58	58
59	41
59	44
59	56
59	59
60	60
61	61
62	62
63	61
63	63
64	61
64	63
64	64
65	65
66	66
67	61
67	63
67	64
67	67
68	61
68	63
68	64
68	67
68	68
69	61
69	63
69	64
69	67
69	68
69	69
70	61
70	63
70	64
70	67
70	68
70	69
70	70
71	61
71	63
71	64
71	67
71	68
71	69
71	70
71	71
72	61
72	63
72	64
72	67
72	68
72	69
72	70
72	71
72	72
73	61
73	63
73	64
73	67
73	68
73	69
73	70
73	71
73	72
73	73
74	74
75	61
75	63
75	64
75	67
75	68
75	69
75	70
75	71
75	72
75	73
75	75
76	76
77	61
77	63
77	64
77	67
77	68
77	69
77	70
77	71
77	72
77	73
77	75
77	77
78	61
78	63
78	64
78	67
78	68
78	69
78	70
78	71
78	72
78	73
78	75
78	77
78	78
79	66
79	79
80	80
81	66
81	79
81	81
82	76
82	82
83	83
84	84
85	85
86	86
87	87
88	88
89	89
90	90
91	91
92	92
93	93
94	94
95	95
96	96
97	96
97	97
98	96
98	97
98	98
99	99
100	96
100	97
100	98
100	100
101	43
101	101
102	102
103	103
104	103
104	104
105	103
105	104
105	105
106	106
107	107
108	108
109	109
110	110
111	96
111	97
111	98
111	100
111	111
112	112
113	113
114	114
115	115
116	116
117	117
118	118
119	119
120	120
121	121
122	122
123	123
124	124
125	125
126	126
127	127
128	128
129	129
130	130
131	131
132	132
133	133
134	134
135	135
136	61
136	63
136	64
136	67
136	68
136	69
136	70
136	71
136	72
136	73
136	75
136	77
136	78
136	136
137	137
138	138
139	139
140	140
141	141
142	142
143	143
144	144
145	145
146	146
147	147
148	148
149	103
149	104
149	105
149	149
150	150
151	103
151	104
151	105
151	149
151	151
152	106
152	152
153	106
153	152
153	153
154	154
155	66
155	79
155	81
155	155
156	156
157	148
157	157
158	158
159	159
160	160
161	161
162	162
163	163
164	164
165	165
166	159
166	166
167	167
168	99
168	168
169	96
169	97
169	98
169	100
169	111
169	169
170	38
170	170
171	171
172	172
173	147
173	173
174	99
174	168
174	174
175	124
175	175
176	99
176	168
176	174
176	176
177	99
177	168
177	174
177	176
177	177
178	178
179	179
180	99
180	168
180	174
180	176
180	177
180	180
181	181
182	99
182	168
182	174
182	176
182	177
182	180
182	182
183	183
184	184
185	185
186	186
187	164
187	187
188	99
188	168
188	174
188	176
188	177
188	180
188	182
188	188
189	185
189	189
190	181
190	190
191	191
192	148
192	157
192	192
193	193
194	194
195	41
195	44
195	56
195	59
195	195
196	146
196	196
197	193
197	197
198	198
199	193
199	197
199	199
200	41
200	44
200	56
200	59
200	195
200	200
201	201
202	202
203	203
204	204
205	205
206	201
206	206
207	207
208	124
208	175
208	208
209	209
210	210
211	211
\.


--
-- Data for Name: books; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.books (book_id, isbn, title, description, genre, fiction) FROM stdin;
1	9781598048889	Official Congressional Directory	Book digitized by Google from the library of the University of Michigan and uploaded to the Internet Archive by user tpb.	architecture	f
2	9781000334234	Analysing Architecture	Analysing Architecture offers a unique notebook of architectural strategies to present an engaging introduction to elements and concepts in architectural design. Beautifully illustrated throughout with the authors original drawings, examples are drawn from across the world, and from many periods architectural history (from prehistoric times to the very recent past), to illustrate analytical themes and to show how drawing can be used to study architecture.In this second edition the framework for analysis has been revised and enlarged, and further case studies added. Many new drawings have been included, illustrating further examples of the themes explored. The link between analysis and learning about the possibilities of design has been reinforced, and the bibliography of recommended supplementary reading has been expanded.Simon Unwin clearly identifies the key elements of architecture and conceptual themes apparent in buildings, and other works of architecture such as gardens and cities. He describes ideas for use in the active process of design. Breaking down the grammar of architecture into themes and moves, Unwin exposes its underlying patterns to reveal the organisational strategies that lie beneath the superficial appearances of buildings. Exploring buildings as results of the interaction of people with the world around them, Analysing Architecture offers a definition of architecture as identification of place and provides a greater understanding of architecture as a creative discipline. This book presents a powerful impetus for readers to develop their own capacities for architectural design.	architecture	f
3	9781441856920	Creepers	"Creepers" are urban explorers who illegally enter sealed buildings.	architecture	t
4	9780500201770	The Classical Language of Architecture	Sir John Summersons short (roughly 80 page) classic is an informal yet trenchant explanation of the classical grammar that has shaped Western architecture from antiquity through the current age. Various architectural elements and styles are explained in a delightful prose that engages and informs.	architecture	f
5	9780340844021	Castle (Stephen Biestys Cross-Sections)	Describes medieval castles and what life was like for the knights who lived in them.	architecture	f
6	9780808507666	Cathedral	The Gothic cathedral is one of mans most magnificent expressions as well as one of his grandest architectural achievements. Built to the glory of God, each cathedral was created by the ingenuity, skill, and hard work of generations of dedicated people. Text and detailed drawings follow the planning and construction of a magnificent Gothic cathedral in the imaginary French town of Chutreaux during the thirteenth century. - Publisher.	architecture	f
7	9781435201453	Castle	Text and detailed drawings follow the planning and construction of a "typical" castle and adjoining town in thirteenth-century Wales.	architecture	f
8	9780641611162	Art Through the Ages	Contains:\n\n - Volume I: [Ancient, Medieval, and Non-European Art](https://openlibrary.org/works/OL18151172W/Ancient_Medieval_and_Non-European_Art)\n - Volume II: [Renaissance and Modern Art](https://openlibrary.org/works/OL15125458W/Renaissance_and_Modern_Art)\n - Book B: [The Middle Ages](https://openlibrary.org/works/OL17551781W/The_Middle_Ages)\n - Book D: [Renaissance and Baroque](https://openlibrary.org/works/OL16584968W/Renaissance_and_Baroque)\n - Book E: [Modern Europe and America](https://openlibrary.org/works/OL17527112W/Modern_Europe_and_America)\n - Book F: [Non-Western Art to 1300](https://openlibrary.org/works/OL3002702W/Non-Western_Art_to_1300)\n\nSince publication of the first edition in 1926, Helen Gardner’s Art through the Ages has been a favorite with generations of students and general readers, who have found it an exciting and informative survey. Miss Gardner’s enthusiasm, knowledge, and humanity have made it possible for the beginner to learn how to see and thereby to penetrate the seeming mysteries of even the most complex artistic achievements. Every effort has been made in this volume to preserve her freshness and simplicity of style and, above all, her sympathetic approach to individual works of art and to the styles of which they are a part.	art history	f
9	9780155037595	Ancient, Medieval, and Non-European Art	Volume I of [Gardners Art Through the Ages](https://openlibrary.org/works/OL3002703W/Gardners_Art_Through_the_Ages)	art history	f
10	9789638626950	Wie man leben soll	Karl »Charlie« Kolostrum ist jung und stellt sich die entscheidende Frage, wie man eigentlich leben soll. Als Teil einer völlig überspannten Familie und Sohn einer Mutter, deren Neigung zu Alkohol und Promiskuität den Vater beizeiten verjagte, war er früh sich selbst überlassen und beschäftigte sich hauptsächlich mit der eigenen Person und ihrer Wirkung auf andere. Jetzt scheint es ihm an der Zeit, ein paar Lebensregeln aufzustellen ...	art history	f
11	9788582850596	陰翳礼讃 (Inei raisan)	"This is a powerfully anti-modernist book, yet contains the most beautiful evocation of the traditional Japanese aesthetic, which cast such a spell on Ludwig Mies van der Rohe and Frank Lloyd Wright.\n\n"The contradiction is easily explained: Tanizaki sees the empty Japanese wall as not empty at all, but a surface on which light continually traces its fugitive presence against encroaching shadow. He constructs a myth of the origin of the Japanese house: it began with a roof and overhanging eaves, which cast a shadow on the earth, calling forth a shelter."\n\nRead more: http://www.bdonline.co.uk/story.asp?storycode=3159684&origin=BDweeklydigest#ixzz0iOulXDEW	design	f
12	9781118057384	Beginning JavaScript	JavaScript is a scripting language that enables you to enhance static web applications by providing dynamic, personalized, and interactive content. This improves the experience of visitors to your site and makes it more likely that they will visit again. You must have seen the flashy drop-down menus, moving text, and changing content that are now widespread on web sites--they are enabled through JavaScript. Supported by all the major browsers, JavaScript is the language of choice on the Web. It can even be used outside web applications--to automate administrative tasks, for example.  This book aims to teach you all you need to know to start experimenting with JavaScript: what it is, how it works, and what you can do with it. Starting from the basic syntax, youll move on to learn how to create powerful web applications. Dont worry if youve never programmed before--this book will teach you all you need to know, step by step. Youll find that JavaScript can be a great introduction to the world of programming: with the knowledge and understanding that youll gain from this book, youll be able to move on to learn newer and more advanced technologies in the world of computing.  In order to get the most out of this book, youll need to have an understanding of HTML and how to create a static web page. You dont need to have any programming experience.  This book will also suit you if you have some programming experience already, and would like to turn your hand to web programming. You will know a fair amount about computing concepts, but maybe not as much about web technologies.  Alternatively, you may have a design background and know relatively little about the Web and computing concepts. For you, JavaScript will be a cheap and relatively easy introduction to the world of programming and web application development.  Whoever you are, we hope that this book lives up to your expectations.  Youll begin by looking at exactly what JavaScript is, and taking your first steps with the underlying language and syntax. Youll learn all the fundamental programming concepts, including data and data types, and structuring your code to make decisions in your programs or to loop over the same piece of code many times.  Once youre comfortable with the basics, youll move on to one of the key ideas in JavaScript--the object. Youll learn how to take advantage of the objects that are native to the JavaScript language, such as dates and strings, and find out how these objects enable you to manage complex data and simplify your programs. Next, youll see how you can use JavaScript to manipulate objects made available to you in the browser, such as forms, windows, and other controls. Using this knowledge, you can start to create truly professional-looking applications that enable you to interact with the user.  Long pieces of code are very hard to get right every time--even for the experienced programmer--and JavaScript code is no exception. You look at common syntax and logical errors, how you can spot them, and how to use the Microsoft Script Debugger to aid you with this task. Also, you need to examine how to handle the errors that slip through the net, and ensure that these do not detract from the experience of the end user of your application.  From here, youll move on to more advanced topics, such as using cookies and jazzing up your web pages with dynamic HTML and XML. Finally, youll be looking at a relatively new and exciting technology, remote scripting. This allows your JavaScript in a HTML page to communicate directly with a server, and useful for, say, looking up information on...	design	f
13	9780132809818	HTML for the World Wide Web with XHTML and CSS	Need to learn HTML fast? This best-selling references visual format and step-by-step, task-based instructions will have you up and running with HTML in no time. In this completely updated edition of our best-selling guide to HTML, Web expert and best-selling author Elizabeth Castro uses crystal-clear instructions and friendly prose to introduce you to all of todays HTML and XHTML essentials. Youll learn how to design, structure, and format your Web site. Youll create and use images, links, styles, lists, tables, frames, and forms, and youll add sound and movies to your site. Finally, you will test and debug your site, and publish it to the Web. Along the way, youll find extensive coverage of CSS techniques, current browsers (Opera, Safari, Firefox), creating pages for the mobile Web, and more. Visual QuickStart Guide--the quick and easy way to learn! Easy visual approach uses pictures to guide you through HTML and show you what to do. Concise steps and explanations get you up and running in no time. Page for page, the best content and value around. Companion Web site at www.cookwood.com/html offers examples, a lively question-and-answer area, updates, and more.	design	f
14	9781484412398	Eve & Adam	After being in a car accident, a patient recovering in her mothers research facility is given the task of creating the perfect boy using detailed simulation technologies.	design	t
44	9781515425175	Julius Caesar	Presents the original text of Shakespeares play side by side with a modern version, discusses the author and the theater of his time, and provides quizzes and other study activities.	history	t
15	9783737202268	Treasure Island	Traditionally considered a coming-of-age story, Treasure Island is an adventure tale known for its atmosphere, characters and action, and also as a wry commentary on the ambiguity of morality — as seen in Long John Silver — unusual for childrens literature then and now. It is one of the most frequently dramatized of all novels. The influence of Treasure Island on popular perceptions of pirates is enormous, including treasure maps marked with an "X", schooners, the Black Spot, tropical islands, and one-legged seamen carrying parrots on their shoulders	fantasy	t
16	9798408524822	Through the Looking-Glass	*Through the Looking-Glass, and What Alice Found There* (1871) is a work of childrens literature by Lewis Carroll (Charles Lutwidge Dodgson), generally categorized in the fairy tale genre. It is the sequel to *Alices Adventures in Wonderland* (1865). Although it makes no reference to the events in the earlier book, the themes and settings of *Through the Looking-Glass* make it a kind of mirror image of Wonderland: the first book begins outdoors, in the warm month of May, uses frequent changes in size as a plot device, and draws on the imagery of playing cards; the second opens indoors on a snowy, wintry night exactly six months later, on November 4 (the day before Guy Fawkes Night), uses frequent changes in time and spatial directions as a plot device, and draws on the imagery of chess. In it, there are many mirror themes, including opposites, time running backwards, and so on. ([Wikipedia][1])\n\n\n  [1]: http://en.wikipedia.org/wiki/Through_the_Looking-Glass	fantasy	t
17	9781719999854	Five Children and It	Havent you ever thought what you would wish for if you were granted three wishes? In Nesbits delightful classic, five siblings find a creature that grants their wishes, but as the old saying goes: be careful what you wish for, it might come true...	fantasy	t
18	9798736670154	Phantastes	One of George MacDonalds most important works, Phantastes is the story of a young man named Anotos and his long dreamlike journey in Fairy Land. It is the fairy tale of deep spiritual insight as Anotos makes his way through moments of uncertainty and peril and mistakes that can have irreversible consequences. This is also his spiritual quest that is destined to end with the supreme surrender of the self. When he finally experiences the hard-won surrender, a wave of joy overwhelms him. His intense personal introspection is honest as he is offered the full range of symbolic choices--great beauty, horrifying ugliness, irritating goblins, nurturing spirits. Each confrontation in Fairy Land allows Anotos to learn many necessary lessons. As he continues on the journey, many shadowy beings threaten his spiritual well-being and compel him to sing. The songs are irresistible to a beautiful White Lady who is freed from inside a statue by the music, and Anotos remains captivated by her for a long time. He sees the world more objectively; his trek invites a natural descent into feelings of pride and egotism. But his losses and sorrows coalesce themselves into things of grace, and these experiences help his spiritual growth.     Please Note:  This book has been reformatted to be easy to read in true text, not scanned images that can sometimes be difficult to decipher.  The Microsoft eBook has a contents page linked to the chapter headings for easy navigation. The Adobe eBook has bookmarks at chapter headings and is printable up to two full copies per year.  Both versions are text searchable.	fantasy	t
19	9788845271403	The Hobbit	The Hobbit is a tale of high adventure, undertaken by a company of dwarves in search of dragon-guarded gold. A reluctant partner in this perilous quest is Bilbo Baggins, a comfort-loving unambitious hobbit, who surprises even himself by his resourcefulness and skill as a burglar.\n\nEncounters with trolls, goblins, dwarves, elves, and giant spiders, conversations with the dragon, Smaug, and a rather unwilling presence at the Battle of Five Armies are just some of the adventures that befall Bilbo.\n\nBilbo Baggins has taken his place among the ranks of the immortals of children’s fiction. Written by Professor Tolkien for his children, The Hobbit met with instant critical acclaim when published.	fantasy	t
20	9781689585019	Ozma of Oz	When a storm blows Dorothy to the land of Ev where lunches grow on trees, she meets the Scarecrow, the Tin Woodman, the Cowardly Lion, and Princess Ozma, and together they set out to free the Queen of Ev and her ten children.	fantasy	f
21	9798405386553	The Emerald City of Oz	From the book:Perhaps I should admit on the title page that this book is "By L. Frank Baum and his correspondents," for I have used many suggestions conveyed to me in letters from children. Once on a time I really imagined myself "an author of fairy tales," but now I am merely an editor or private secretary for a host of youngsters whose ideas I am requestsed to weave into the thread of my stories. These ideas are often clever. They are also logical and interesting. So I have used them whenever I could find an opportunity, and it is but just that I acknowledge my indebtedness to my little friends.	fantasy	t
22	9781408883730	Harry Potter and the Philosophers Stone	Harry Potter #1\n\nWhen mysterious letters start arriving on his doorstep, Harry Potter has never heard of Hogwarts School of Witchcraft and Wizardry.\n\nThey are swiftly confiscated by his aunt and uncle.\n\nThen, on Harry’s eleventh birthday, a strange man bursts in with some important news: Harry Potter is a wizard and has been awarded a place to study at Hogwarts.\n\nAnd so the first of the Harry Potter adventures is set to begin.\n([source][1])\n\n\n  [1]: https://www.jkrowling.com/book/harry-potter-philosophers-stone/	fantasy	t
23	9798507755530	The Road to Oz	Dorothy and her friends follow the enchanted road to Oz and arrive in time for Ozmas birthday party.	fantasy	t
24	9789756446294	The Enchanted Castle	E. Nesbits classic story of how Gerald, Cathy and Jimmy find an enchanted garden and awake a princess from a hundred-year sleep, only to have her immediately made invisible by a magic ring. Her rescue is difficult, funny and sometimes frightening.	fantasy	t
25	9798569479252	The Lost Princess of Oz	When Princess Ozma and all the magic of the Land of Oz are mysteriously stolen away, Dorothy and the other residents of Oz are determined to find their missing ruler and the thief responsible for her disappearance.	fantasy	t
26	9782035846495	Le Tour du Monde en Quatre-Vingts Jours	Phileas Fogg, a very punctual man had broken into an argument while conversing about the recent bank robbery. To keep his word of proving that he would travel around the world in 80 days and win the bet, he sets on a long trip, where he is joined by a few other people on the way. A wonderful adventure is about to begin!	fantasy	t
27	9780844664958	The Patchwork Girl of Oz	"Wheres the butter, Unc Nunkie?" asked Ojo.	fantasy	f
28	9788324019403	The Phoenix and the Carpet	Five British children discover in their new carpet an egg, which hatches into a phoenix that takes them on a series of fantastic adventures around the world.	fantasy	t
43	9781017979435	The Prince and the Pauper	When young Edward VI of England and a poor boy who resembles him exchange places, each learns something about the others very different station in life. Includes a brief biography of the author.	history	t
29	9781977043863	The Sea Fairies	This is a tale of life beneath the sea, of mermaids and sea serpents and other strange inhabitants of the ocean depths. A little girl named Trot and Capn Bill, an old sailor, are invited by several mermaids to come and visit their under-water home. Baum wrote this story in the hope of interesting his readers in something other than Oz; in the preface he writes: "I hope my readers who have so long followed Dorothys adventures in the Land of Oz will be interested in Trots equally strange experiences." Of course, he did not succeed in distracting his fans from Oz, yet the book was eagerly read; the result of this attempt was that he was forced to introduce Trot and Capn Bill into the later Oz stories.	fantasy	t
30	9798770757804	The Tin Woodman of Oz	From the book:The Tin Woodman sat on his glittering tin throne in the handsome tin hall of his splendid tin castle in the Winkie Country of the Land of Oz. Beside him, in a chair of woven straw, sat his best friend, the Scarecrow of Oz. At times they spoke to one another of curious things they had seen and strange adventures they had known since first they two had met and become comrades. But at times they were silent, for these things had been talked over many times between them, and they found themselves contented in merely being together, speaking now and then a brief sentence to prove they were wide awake and attentive. But then, these two quaint persons never slept. Why should they sleep, when they never tired?	fantasy	t
31	9798408503575	Sky Island	Button-Brights adventures begin when he finds a magic umbrella that will carry him anywhere in the world.	fantasy	f
32	9781688845763	Rinkitink in Oz	When all the inhabitants of Pingaree are kidnapped by the mongrel hordes of twin island kingdoms, Prince Inga and his friend King Rinkitink decide to go to the rescue.	fantasy	t
33	9781016307345	Glinda of Oz	The Sorceress and Wizard of Oz attempt to save Princess Ozma and Dorothy from the dangers which threaten them when they try to bring peace to two warring tribes.	fantasy	t
34	9781089574781	The Magic City	An extremely unhappy ten-year-old magically escapes into a city he has built out of books, chessmen, candlesticks, and other household items.	fantasy	t
35	9788475888781	Мастер и Маргарита	The battle of competing translations, a new publishing phenomenon which began with One Day in the Life of Ivan Denisovich, now offers two rival American editions of Mikhail Bulgakovs The Master and Margarita. Mirra Ginsburgs (Grove Press) version is pointedly grotesque: she delights in the sharp, spinning, impressionistic phrase. Her Bulgakov reminds one of the virtuoso effects encountered in Zamyatin and Babel, as yell as the early Pasternaks bizarre tale of Heine in Italy. Translator Michael Glenny, on the other hand, almost suggests Tolstoy. His (Harper & Row) version is simpler, softer, and more humane. The Bulgakov fantasy is less striking here, but less strident, too. Glenny: ""There was an oddness about that terrible day...It was the hour of the day when people feel too exhausted to breathe, when Moscow glows in a dry haze..."" Ginsburg: ""Oh, yes, we must take note of the first strange thing...At that hour, when it no longer seemed possible to breathe, when the sun was tumbling in a dry haze..."" In any case, The Master and Margarita, a product of intense labor from 1928 till Bulgakovs death in 1940, is a distinctive and fascinating work, undoubtedly a stylistic landmark in Soviet literature, both for its aesthetic subversion of ""socialist realism"" (like Zamyatin, Bulgakov apparently believed that true literature is created by visionaries and skeptics and madmen), and for the purity of its imagination. Essentially the anti-scientific, vaguely anti-Stalinist tale presents a resurrected Christ figure, a demonic, tricksy foreign professor, and a Party poet, the bewildered Ivan Homeless, plus a bevy of odd or romantic types, all engaged in socio-political exposures, historical debates, and supernatural turnabouts. A humorous, astonishing parable on power, duplicity, freedom, and love.	fantasy	t
36	9798360896395	The Story of Doctor Dolittle	There are some of us now reaching middle age who discover themselves to be lamenting the past in one respect if in none other, that there are no books written now for children comparable with those of thirty years ago.  I say written FOR children because the new psychological business of writing ABOUT them as though they were small pills or hatched in some especially scientific method is extremely popular today.	fantasy	t
37	9781536923346	The Princess and the Goblin	There was once a little princess whose father was king over a great country full of mountains and valleys. His palace was built upon one of the mountains, and was very grand and beautiful. The princess, whose name was Irene, was born there, but she was sent soon after her birth, because her mother was not very strong, to be brought up by country people in a large house, half castle, half farmhouse, on the side of another mountain, about half-way between its base and its peak.	fantasy	t
38	9781662707681	The Call of the Wild	As Buck, a mixed breed dog, is taken away from his home, instead of facing a feast for breakfast and the comforts of home, he faces the hardships of being a sled dog. Soon he lands in the wrong hands, being forced to keep going when it is too rough for him and the other dogs in his pack. He also fights the urges to run free with his ancestors, the wolves who live around where he is pulling the sled.	history	t
39	9798756217643	Candide	Brought up in the household of a powerful Baron, Candide is an open-minded young man, whose tutor, Pangloss, has instilled in him the belief that all is for the best. But when his love for the Barons rosy-cheeked daughter is discovered, Candide is cast out to make his own way in the world.\n\nAnd so he and his various companions begin a breathless tour of Europe, South America and Asia, as an outrageous series of disasters befall them - earthquakes, syphilis, a brush with the Inquisition, murder - sorely testing the young heros optimism.	history	t
40	9798588005265	Jane Eyre	The novel is set somewhere in the north of England. Janes childhood at Gateshead Hall, where she is emotionally and physically abused by her aunt and cousins; her education at Lowood School, where she acquires friends and role models but also suffers privations and oppression; her time as the governess of Thornfield Hall, where she falls in love with her Byronic employer, Edward Rochester; her time with the Rivers family, during which her earnest but cold clergyman cousin, St John Rivers, proposes to her. Will she or will she not marry him?	history	t
41	9780606010672	The Merchant of Venice	In this lively comedy of love and money in sixteenth-century Venice, Bassanio wants to impress the wealthy heiress Portia but lacks the necessary funds. He turns to his merchant friend, Antonio, who is forced to borrow from Shylock, a Jewish moneylender. When Antonios business falters, repayment becomes impossible--and by the terms of the loan agreement, Shylock is able to demand a pound of Antonios flesh. Portia cleverly intervenes, and all ends well (except of course for Shylock).	history	t
42	9798460372973	The Secret Garden	A ten-year-old orphan comes to live in a lonely house on the Yorkshire moors where she discovers an invalid cousin and the mysteries of a locked garden.	history	t
45	9798487115096	Anne of Avonlea	"A tall, slim girl, "half-past sixteen," with serious gray eyes and hair which her friends called auburn, had sat down on the broad red sandstone doorstep of a Prince Edward Island farmhouse one ripe afternoon in August, firmly resolved to construe so many lines of Virgil. But an August afternoon, with blue hazes scarfing the harvest slopes, little winds whispering elfishly in the poplars, and a dancing slendor of red poppies outflaming against the dark coppice of young firs in a corner of the cherry orchard, was fitter for dreams than dead languages. The Virgil soon slipped unheeded to the ground, and Anne, her chin propped on her clasped hands, and her eyes on the splendid mass of fluffy clouds that were heaping up just over Mr. J. A. Harrisons house like a great  white mountain, was far away in a delicious world where a certain school-teacher was doing a wonderful work, shaping the destinies of future statesmen, and inspiring youthful minds and hearts with high and lofty ambitions."	history	t
46	9786055541590	War and Peace	War and Peace delineates in graphic detail events surrounding the French invasion of Russia, and the impact of the Napoleonic era on Tsarist society, as seen through the eyes of five Russian aristocratic families.\nThe novel begins in the year 1805 during the reign of Tsar Alexander I and leads up to the 1812 French invasion of Russia by Napoleon. The era of Catherine the Great (1762–1796), when the royal court in Paris was the centre of western European civilization,[16] is still fresh in the minds of older people. Catherine, fluent in French and wishing to reshape Russia into a great European nation, made French the language of her royal court. For the next one hundred years, it became a social requirement for members of the Russian nobility to speak French and understand French culture.[16] This historical and cultural context in the aristocracy is reflected in War and Peace. Catherines grandson, Alexander I, came to the throne in 1801 at the age of 24. In the novel, his mother, Marya Feodorovna, is the most powerful woman in the Russian court.\n\nWar and Peace tells the story of five aristocratic families — the Bezukhovs, the Bolkonskys, the Rostovs, the Kuragins and the Drubetskoys—and the entanglements of their personal lives with the history of 1805–1813, principally Napoleons invasion of Russia in 1812. The Bezukhovs, while very rich, are a fragmented family as the old Count, Kirill Vladimirovich, has fathered dozens of illegitimate sons. The Bolkonskys are an old established and wealthy family based at Bald Hills. Old Prince Bolkonsky, Nikolai Andreevich, served as a general under Catherine the Great, in earlier wars. The Moscow Rostovs have many estates, but never enough cash. They are a closely knit, loving family who live for the moment regardless of their financial situation. The Kuragin family has three children, who are all of questionable character. The Drubetskoy family is of impoverished nobility, and consists of an elderly mother and her only son, Boris, whom she wishes to push up the career ladder.	history	t
47	9798487094599	The Moonstone	One of the first English detective novels, this mystery involves the disappearance of a valuable diamond, originally stolen from a Hindu idol, given to a young woman on her eighteenth birthday, and then stolen again. A classic of 19th-century literature.	history	t
48	9798574841143	Narrative of the life of Frederick Douglass, an American slave	Published in 1845, this pre-eminent American slave narrative powerfully details the life of the internationally famous abolitionist Frederick Douglass from his birth into slavery in 1818 to his escape to the North in 1838—how he endured the daily physical and spiritual brutalities of his owners and drivers, how he learned to read and write, and how he grew into a man who could only live free or die.	history	t
49	9798415291786	The Scarlet Pimpernel	The Scarlet Pimpernel (1905) is a play and adventure novel by Baroness Emmuska Orczy set during the Reign of Terror following the start of the French Revolution.	history	t
50	9780847707294	Divina Commedia	Belonging in the immortal company of the great works of literature, Dante Alighieri’s poetic masterpiece, *The Divine Comedy* (Italian: *Divina Commedia),* is a moving human drama, an unforgettable visionary journey through the infinite torment of Hell, up the arduous slopes of Purgatory, and on to the glorious realm of Paradise—the sphere of universal harmony and eternal salvation.	history	f
51	9781790854950	The Railway Children	When Father mysteriously goes away, the children and their mother leave their happy life in London to go and live in a small cottage in the country. The Three Chimneys lies beside a railway track - a constant source of enjoyment to all three. They make friends with the Station Master and Perks the Porter, as well as the jovial Old Gentleman who waves to them everyday from the train. But the mystery remains: where is Father, and will he ever return?	history	t
52	9798473654479	Three men in a boat (to say nothing of the dog)	Three feckless young men take a rowing holiday on the Thames river in 1888.\n\nReferenced by [Robert A. Heinlein][1] in [Have Spacesuit Will Travel][2] as Kips fathers favorite book. Inspired [To Say Nothing of the Dog][3] by [Connie Willis][4].\n\n\n  [1]: https://openlibrary.org/authors/OL28641A/Robert_A._Heinlein\n  [2]: https://openlibrary.org/works/OL59727W/Have_Space_Suit_Will_Travel\n  [3]: https://openlibrary.org/works/OL14858398W/To_Say_Nothing_of_the_Dog_or_how_we_found_the_bishops_bird_stump_at_last#about/about\n  [4]: https://openlibrary.org/authors/OL20934A/Connie_Willis	history	t
53	9781730999871	The Story of the Treasure Seekers being the adventures of the Bastable children in search of a fortune	The six Bastable children try to restore their familys fortune using a variety of schemes taken from books, including finding buried treasure, rescuing someone from bandits, and starting a newspaper.	history	t
54	9788424907181	Aeneis	"A prose translation of Vergils Aeneid with new illustrations and informational appendices"--Provided by publisher.	history	f
55	9781096415466	La père Goriot	SCOTT (copy 1): The Hédi Bouraoui Collection in Maghrebian and Franco-Ontario Literatures is the gift of University Professor Emeritus Hédi Bouraoui.	history	t
56	9780333690987	King Henry IV. Part 1	Presents the original text of Shakespeares play side by side with a modern version, discusses the author and the theater of his time, and provides quizzes and other study activities.	history	t
57	9798585784859	The Woman in White	The Woman in White famously opens with Walter Hartrights eerie encounter on a moonlit London road. Engaged as a drawing master to the beautiful Laura Fairlie, Walter is drawn into the sinister intrigues of Sir Percival Glyde and his charming friend Count Fosco, who has a taste for white mice, vanilla bonbons and poison. Pursuing questions of identity and insanity along the paths and corridors of English country houses and the madhouse, The Woman in White is the first and most influential of the Victorian genre that combined Gothic horror with psychological realism.	history	t
86	9783426871812	The Wisdom of Insecurity	amazing insight. helps westerners step back and look at their actions and how they relate to the world around them. the mere desire to "be secure" is what actually makes you insecure.  all about time and pain.  most influential book ive ever read, and ive read a lot, high iq, etc.  from my point of view, a must read.	mental health	f
87	9789044511239	Leopardens öga	Arriving in newly independent Zambia in the hopes of fulfilling a friends missionary dream, Hans Olofson endeavors to make Africa his home while struggling with such past demons as his fathers alcoholism and a friends accident.	mental health	t
58	9781795416092	Jude the Obscure	Hardys last work of fiction, Jude the Obscure is also one of his most gloomily fatalistic, depicting the lives of individuals who are trapped by forces beyond their control. Jude Fawley, a poor villager, wants to enter the divinity school at Christminster. Sidetracked by Arabella Donn, an earthy country girl who pretends to be pregnant by him, Jude marries her and is then deserted. He earns a living as a stonemason at Christminster; there he falls in love with his independent-minded cousin, Sue Bridehead. Out of a sense of obligation, Sue marries the schoolmaster Phillotson, who has helped her. Unable to bear living with Phillotson, she returns to live with Jude and eventually bears his children out of wedlock. Their poverty and the weight of societys disapproval begin to take a toll on Sue and Jude; the climax occurs when Judes son by Arabella hangs Sue and Judes children and himself. In penance, Sue returns to Phillotson and the church. Jude returns to Arabella and eventually dies miserably. The novels sexual frankness shocked the public, as did Hardys criticisms of marriage, the university system, and the church. Hardy was so distressed by its reception that he wrote no more fiction, concentrating solely on his poetry.Please Note:  This book is easy to read in true text, not scanned images that can sometimes be difficult to decipher.  The Microsoft eBook has a contents page linked to the chapter headings for easy navigation. The Adobe eBook has bookmarks at chapter headings and is printable up to two full copies per year.  Both versions are text searchable.	history	t
59	9780582287273	Antony and Cleopatra	A magnificent drama of love and war, this riveting tragedy presents one of Shakespeares greatest female characters--the seductive, cunning Egyptian queen Cleopatra.  The Roman leader Mark Antony, a virtual prisoner of his passion for her, is a man torn between pleasure and virtue, between sensual indolence and duty . . . between an empire and love.  Bold, rich, and splendid in its setting and emotions, Antony And Cleopatra ranks among Shakespeares supreme achievements.From the Paperback edition.and the narrator vinay has explained what the intension in the relationship between antony and cleopatra	history	t
60	9781387764921	Carmilla	https://openlibrary.org/works/OL2895536W	horror	t
61	9783453003125	Skeleton Crew	From the Flap:\n\nThe Master at his scarifying best! From heart-pounding terror to the eeriest of whimsy--tales from the outer limits of one of the greatest imaginations of our time!\n\nEvil that breathes and walks and shrieks, brave new worlds and horror shows, human desperation bursting into deadly menace--such are the themes of these astounding works of fiction. In the tradition of Poe and Stevenson, of Lovecraft and The Twilight Zone, Stephen King has fused images of fear as old as time with the iconography of contemporary American life to create his own special brand of horror--one that has kept millions of readers turning the pages even as they gasp.\n\nIn the book-length story "The Mist," a supermarket becomes the last bastion of humanity as a peril beyond dimension invades the earth. . .\n\nTouch "The Man Who Would Not Shake Hands," and say your prayers . . .\n\nThere are some things in attics which are better left alone, things like "The Monkey" . . .\n\nThe most sublime woman driver on earth offers a man "Mrs. Todds Shortcut" to paradise . . .\n\nA boys sanity is pushed to the edge when hes left alone with the odious corpse of "Gramma" . . .\n\nIf you were stunned by Gremlins, the Fornits of "The Ballad of the Flexible Bullet" will knock your socks off . . .\n\nTrucks that punish and beautiful teen demons who seduce a young man to massacre; curses whose malevolence grows through the years; obscene presences and angels of grace--here, indeed, is a night-blooming bouquet of chills and thrills.\n([source][1])\n\n\n----------\nContains:\n\n - [The Mist](https://openlibrary.org/works/OL149144W/The_Mist)\n - Here There Be Tygers\n - [The Monkey](https://openlibrary.org/works/OL149146W/The_Monkey)\n - Cain Rose Up\n - [Mrs. Todds Shortcut](https://openlibrary.org/works/OL149148W/Mrs._Todds_Shortcut)\n - [The Jaunt](https://openlibrary.org/works/OL20663554W/The_Jaunt)\n - The Wedding Gig\n - Paranoid: a Chant\n - The Raft\n - [Word Processor of the Gods](https://openlibrary.org/works/OL20666372W/The_Word_Processor)\n - The Man Who Would Not Shake Hands\n - Beachworld\n - The Reapers Image\n - [Nona](https://openlibrary.org/works/OL20666488W/Nona)\n - For Owen\n - Survivor Type\n - Uncle Ottos Truck\n - Morning Deliveries (Milkman No. 1)\n - Big Wheels: a Tale of the Laundry Game (Milkman No. 2)\n - Gramma\n - The Ballad of the Flexible Bullet\n - The Reach\n\n  [1]: https://stephenking.com/library/story_collection/skeleton_crew_flap.html	horror	t
62	9788412198867	The Exorcist	The Exorcist is a 1971 horror novel by American writer William Peter Blatty. The book details the demonic possession of eleven-year-old Regan MacNeil, the daughter of a famous actress, and the two priests who attempt to exorcise the demon. Published by Harper & Row, the novel was the basis of a highly successful film adaptation released two years later, whose screenplay was also written and produced by Blatty, and part of The Exorcist franchise.\n\nThe novel was inspired by a 1949 case of demonic possession and exorcism that Blatty heard about while he was a student in the class of 1950 at Georgetown University. As a result, the novel takes place in Washington, D.C., near the campus of Georgetown University. In September 2011, the novel was reprinted by Harper Collins to celebrate its fortieth anniversary, with slight revisions made by Blatty as well as interior title artwork by Jeremy Caniglia.	horror	t
63	9780606019170	The Dead Zone	The Dead Zone is a science fiction thriller novel by Stephen King published in 1979. The story follows Johnny Smith, who awakens from a coma of nearly five years and, apparently as a result of brain damage, now experiences clairvoyant and precognitive visions triggered by touch. When some information is blocked from his perception, Johnny refers to that information as being trapped in the part of his brain that is permanently damaged, "the dead zone." The novel also follows a serial killer in Castle Rock, and the life of rising politician Greg Stillson, both of whom are evils Johnny must eventually face.\n\nThough earlier King books were successful, The Dead Zone was the first of his novels to rank among the ten best-selling novels of the year in the United States. The book was nominated for the Locus Award in 1980 and was dedicated to Kings son Owen. The Dead Zone is the first story by King to feature the fictional town of Castle Rock, which serves as the setting for several later stories and is referenced in others. The TV series Castle Rock takes place in this fictional town and makes references to the Strangler whom Johnny helped track down in The Dead Zone.\n\nThe Dead Zone is Kings seventh novel and the fifth under his own name. The book spawned a 1983 film adaptation as well as a television series.	horror	t
64	9781668009925	Firestarter	Firestarter is a science fiction-horror thriller novel by Stephen King, first published in September 1980. In July and August 1980, two excerpts from the novel were published in Omni. In 1981, Firestarter was nominated as Best Novel for the British Fantasy Award, Locus Poll Award, and Balrog Award.\n\n\n----------\nAlso contained in:\n[Ominbus](https://openlibrary.org/works/OL25080326W)	horror	t
65	9781583429938	Something Wicked This Way Comes	Few American novels written this century have endured in the heart and memory as has Ray Bradburys unparalleled literary classic SOMETHING WICKED THIS WAY COMES. For those who still dream and remember, for those yet to experience the hypnotic power of its dark poetry, step inside. The show is about to begin.\n\nThe carnival rolls in sometime after midnight, ushering in Halloween a week early. The shrill siren song of a calliope beckons to all with a seductive promise of dreams and youth regained. In this season of dying, Cooger & Darks Pandemonium Shadow Show has come to Green Town, Illinois, to destroy every life touched by its strange and sinister mystery. And two boys will discover the secret of its smoke, mazes, and mirrors; two friends who will soon know all too well the heavy cost of wishes. . .and the stuff of nightmare.	horror	t
66	9788484505785	If There Be Thorns	*If There Be Thorns* is a novel by Virginia Andrews which was published in 1981. It is the third book in the Dollanganger series. The story takes place in the year 1982.\n\nThe book is narrated by two half-brothers, Jory and Bart Sheffield. Jory is a handsome, talented young man who wants to follow his mother Cathy in her career in the ballet, while Bart, who is unattractive and clumsy, feels he is outshone by Jory. By now, Cathy and Chris live together as common-law husband and wife. To hide their history, they tell the boys and other people they know that Chris was Pauls younger brother. Unable to have more children, Cathy secretly adopts Cindy, the daughter of one her former dance students, who was killed in an accident, because she longs to have a child that is hers and Chriss. Initially against it, Chris comes to accept the child.\n\nLonely from all the attention Jory and Cindy are receiving, Bart befriends an elderly neighbor that moved in next door, who invites him over for cookies and ice cream and encourages him to call her "Grandmother." Jory also visits the old lady next door, and she reveals that she is actually his grandmother. Jory initially doesnt believe her, and avoids her at all costs. The old woman and Bart, on the other hand, soon develop an affectionate friendship, and the woman does her best to give Bart whatever he wants, provided that Bart promises to keep her gifts—-and their relationship-—a secret from his mother.\n\n\n----------\nAlso contained in:\n[If There Be Thorns / Seeds of Yesterday](https://openlibrary.org/works/OL16526063W)	horror	t
67	9781501177217	The Eyes of the Dragon	The Eyes of the Dragon is a fantasy novel by American writer Stephen King, first published as a limited edition slipcased hardcover by Philtrum Press in 1984, illustrated by Kenneth R. Linkhauser. The novel would later be published for the mass market by Viking in 1987, with illustrations by David Palladini. This trade edition was slightly revised for publication. The 1995 French edition did not reproduce the American illustrations; it included brand new illustrations by Christian Heinrich, and a 2016 new French version also included brand new illustrations, by Nicolas Duffaut.\n\nAt the time of publication, it was a deviation from the norm for King, who was best known for his horror fiction. The book is a work of epic fantasy in a quasi-medieval setting, with a clearly established battle between good and evil, and magic playing a lead role. The Eyes of the Dragon was originally titled The Napkins.\n\n\n----------\nAlso contained in:\n[Ominbus](https://openlibrary.org/works/OL25080326W)	horror	t
68	9780671042141	Hearts in Atlantis	Hearts in Atlantis (1999) is a collection of two novellas and three short stories by Stephen King, all connected to one another by recurring characters and taking place in roughly chronological order.\n\nThe stories are about the Baby Boomer Generation, specifically Kings view that this generation (to which he belongs) failed to live up to its promise and ideals. Significantly, the opening epigraph of the collection is the Peter Fonda line from the end of Easy Rider: "We blew it." All of the stories are about the 1960s and the war in Vietnam, and in all of them the members of that generation fail profoundly, or are paying the costs of some profound failure on their part.\n\nIn this collection:\n\n - Blind Willie\n - Hearts in Atlantis\n - Heavenly Shades of Night Are Falling\n - Low Men in Yellow Coats\n - Why Were in Vietnam	horror	t
69	9781668018071	Christine	A love triangle involving 17-year-old misfit Arnie Cunningham, his new girlfriend and a haunted 1958 Plymouth Fury. Dubbed Christine by her previous owner, Arnies first car is jealous, possessive and deadly.\n([source][1])\n\n\n  [1]: https://stephenking.com/library/novel/christine.html	horror	t
70	9780340633687	Rose Madder	Rosie Daniels flees from her husband, Norman after fourteen years in an abusive marriage. During one bout of violence, Norman caused Rosie to miscarry their only child. Escaping to a distant city, Rosie establishes a new life and forges new relationships. Norman Daniels, a police officer with a reputation for cruelty, uses his law-enforcement connections to track his wayward wife.\n([source][1])\n\n\n  [1]: https://stephenking.com/library/novel/rose_madder.html	horror	t
71	9780340952269	Thinner	Thinner is a horror novel by American author Stephen King, published in 1984 by NAL under Kings pseudonym Richard Bachman. The story centers on lawyer Billy Halleck, who kills a crossing Romani woman in a road accident and escapes legal punishment because of his connections. However, the womans father places a curse on Halleck, which causes him to lose weight uncontrollably.	horror	t
72	9788497595896	Desperation	Located off a desolate stretch of Interstate 50, Desperation, Nevada has few connections with the rest of the world. It is a place, though, where the seams between worlds are thin. Miners at the China Pit have accidentally broken into another dimension and released a horrific creature known as Tak, who takes human form by hijacking some of the towns residents. The forces of good orchestrate a confrontation between this ancient evil and a group of unsuspecting travelers who are lured to the dying town. This rag-tag band of unwilling champions is led by a young boy who speaks to God.\n\n([source][1])\n\n\n  [1]: https://www.stephenking.com/library/novel/desperation.html	horror	t
73	9788376481708	Danse Macabre	This is a non-fiction study of the horror genre including books, movies, television, etc.\n([source][1])\n\n\n----------\nAlso contained in:\n\n - [Works (Danse Macabre / Salems Lot / Shining](https://openlibrary.org/works/OL24233994W)\n\n  [1]: https://stephenking.com/library/nonfiction/danse_macabre.html	horror	f
74	9781587672316	The Passage	The Passage is a novel by Justin Cronin, published in 2010 by Ballantine Books, a division of Random House, Inc., New York. The Passage debuted at #3 on the New York Times hardcover fiction best seller list, and remained on the list for seven additional weeks. It is the first novel of a completed trilogy; the second book The Twelve was released in 2012, and the third book The City of Mirrors released in 2016.	horror	f
75	9785150003941	The Regulators	The Regulators is a novel by American author Stephen King, writing under the pseudonym Richard Bachman. It was published in 1996 at the same time as its "mirror" novel, Desperation. The two novels represent parallel universes relative to one another, and most of the characters present in one novels world also exist in the other novels reality, albeit in different circumstances. Additionally, the hardcover first editions of each novel, if set side by side, make a complete painting, and on the back of each cover is also a peek at the opposites cover.	horror	t
88	9780380724246	Sometimes I Think I Hear My Name	It wasnt that thirteen-year-old Conrad didnt like living with his aunt and uncle in St. Louis. Its just that his mother and father both lived in New York and he hadnt seen them lately. And he had a few questions he needed to have answered. Thats how Conrad happened to spend the strangest week of his life in New York City with a girl he hardly knew--and getting more answers than he had questions...about his parents, himself, and what real families are all about.	mental health	t
89	9780393339857	"Surely Youre Joking, Mr. Feynman"	The biography of the physicist and Nobel prize winner Richard P. Feynman - a collection of short stories, chapters told to and written down by Ralph Leighton.\nFeynman tells of his childhood and youth and goes into his adult life, both personally and professionally.	music	f
76	9782266118996	The Queen of the Damned	The third book in The Vampire Chronicles, Queen of the Damned, follows three parallel storylines.\n\nThe rock star Vampire Lestat prepares for a concert in San Francisco, unaware that hundreds of vampires will be among the fans that night and that they are committed to destroying him for risking exposing them all.\n\nThe sleep of a group of men and women, vampires and mortals, around the world is disturbed by a mysterious dream of red-haired twins who suffer an unspeakable tragedy. The dreamers, as if pulled, move toward each other, the nightmare becoming clearer the closer they get. Some die on the way, some live to face they terrifying fate their pilgrimage is building to.\n\nLestats journey to a cavern deep beneath a Greek Island on his quest for the origins of the vampire race awakened Akasha, Queen of the Damed and mother of all vampires, from her 6,000 year sleep. Awake and angry, Akasha plans to save mankind from itself by elevating herself and her chosen son/lover to the level of the gods.\n\nAs these three threads wind seamlessly together, the origins and culture of vampires are revealed, as is the length and breadth of their effect on the mortal world. The threads are brought together in the twentieth century when the fate of the living and the living dead is rewritten.\n([source][1])\n\n\n  [1]: http://annerice.com/Bookshelf-QueenDamned.html	horror	t
77	9788868362362	Dolores Claiborne	Suspected of killing Vera Donovan, her wealthy employer, Dolores Claiborne tells police the story of her life, harkening back to her disintegrating marriage and the suspicious death of her violent husband, Joe St. George, thirty years earlier. Dolores also tells of Veras physical and mental decline and of her loyalty to an employer who has become emotionally demanding in recent years.\n\n([source][1])\n\n\n  [1]: https://www.stephenking.com/library/novel/dolores_claiborne.html	horror	t
78	9785170853120	Mr. Mercedes	In the frigid pre-dawn hours, in a distressed Midwestern city, hundreds of desperate unemployed folks are lined up for a spot at a job fair. Without warning, a lone driver plows through the crowd in a stolen Mercedes, running over the innocent, backing up, and charging again. Eight people are killed; fifteen are wounded. The killer escapes.\n\nIn another part of town, months later, a retired cop named Bill Hodges is still haunted by the unsolved crime. When he gets a crazed letter from someone who self-identifies as the "perk" and threatens an even more diabolical attack, Hodges wakes up from his depressed and vacant retirement, hell-bent on preventing another tragedy.\n\nBrady Hartfield lives with his alcoholic mother in the house where he was born. He loved the feel of death under the wheels of the Mercedes, and he wants that rush again.\n\nOnly Bill Hodges, with a couple of highly unlikely allies, can apprehend the killer before he strikes again. And they have no time to lose, because Brady’s next mission, if it succeeds, will kill or maim thousands.\n\nMr. Mercedes is a war between good and evil, from the master of suspense whose insight into the mind of this obsessed, insane killer is chilling and unforgettable.	horror	t
79	9782277021438	Fallen Hearts	With Fallen Hearts, V.C. Andrews returns again to the number one best-selling saga of the Casteels, continuing the story that was begun in Heaven and Dark Angel.\n\nIn Fallen Hearts, Heaven returns to her Winnerow and begins to live out her childhood dreams--she becomes a respected schoolteacher at the local school and marries her sweetheart, Logan Stonewall. After their wedding trip back to Farthinggale Manor, Tony Tatterton persuades Heaven and Logan to stay in Boston, offering Logan a fabulous job and promising to share with Heaven all the Tatterton wealth and privilege. But old ghosts begin to rise up once more, writhing around Heavens fragile happiness, threatening her precious love with scandal and jealousy. Once again, V.C. Andrews tells an enthralling tale of sinister passions and dangerous dreams.	horror	t
80	9789501512274	The Voice of the Night	No one could understand why Colin and Roy were best friends. They were complete opposites. Colin was fascinated by Roy--and Roy was fascinated by death. Then one day Roy asked: "You ever killed anything?" And from that moment on, the two were bound together in a game to terrifying to imagine.	horror	t
81	9782724237443	My Sweet Audrina	My Sweet Audrina is a 1982 novel by V. C. Andrews. It was the only stand-alone novel published during Andrews lifetime and was a number-one best-selling novel in North America. The story takes place in the Mid-Atlantic United States during the 1960s and 1970s. The story features diverse subjects, such as brittle bone disease, rape, posttraumatic stress disorder and diabetes, in the haunting setting of a Victorian-era mansion near the fictitious River Lyle.	horror	t
82	9788466621793	Lasher	The Talamasca, documenters of paranormal activity, is on the hunt for the newly born Lasher. Mayfair women are dying from hemorrhages and a strange genetic anomaly has been found in Rowan and Michael. Lasher, born from Rowan, is another species altogether and now in the corporeal body, represents an incalcuable threat to the Mayfairs. Rowan and Lasher travel together to Houston and she becomes pregnant with another creature like him, a Taltos. Lasher seeks to reproduce his race in other women, but they cannot withstand it. Rowan escapes and becomes comatose as her fully-grown Taltos daughter is born. The Mayfairs declare all-out war on Lasher and try to nurse Rowan back to heatlth.\n\nMichael remains entwined in the Mayfair family and learns how he comes by his strange powers. Michaels ghostly visiting from a long-dead Mayfair reveals the importance of destroying Lasher. In the investigation, Lashers origins are revealed, the new Taltos Emaleth returns, and the climax of death and life engulfs the family.\n([source][1])\n\n\n  [1]: http://annerice.com/Bookshelf-Lasher.html	horror	t
83	9798354315864	The Bell Jar	The Bell Jar is the only novel written by American poet Sylvia Plath. It is an intensely realistic and emotional record of a successful and talented young womans descent into madness.	mental health	t
84	9781501133473	The Perks of Being a Wallflower	The Perks of Being a Wallflower is a young adult coming-of-age epistolary novel by American writer Stephen Chbosky, which was first published on February 1, 1999, by Pocket Books. Set in the early 1990s, the novel follows Charlie, an introverted observing teenager, through his freshman year of high school in a Pittsburgh suburb. The novel details Charlies unconventional style of thinking as he navigates between the worlds of adolescence and adulthood, and attempts to deal with poignant questions spurred by his interactions with both his friends and family.	mental health	t
85	9798719874166	Power Through Repose	No matter what our work in life, whether scientific, artistic, or domestic, it is the same body through which the power is transmitted; and the same freedom in the conductors for impression and expression is needed, to whatever end the power may be moved, from the most simple action to the highest scientific or artistic attainment. The quality of power differs greatly; the results are widely different, but the laws of transmission are the same. So wonderful is the unity of life and its laws!	mental health	f
102	9788374703727	The Big Sleep	Philip Marlowe, a private eye who operates in Los Angeless seamy underside during the 1930s, takes on his first case, which involves a paralyzed California millionaire, two psychotic daughters, blackmail, and murder	mystery and detective stories	t
90	9781481425803	Dragonsong	Menolly, a young fishers daughter, had dreamed all her life of learning the Harpers craft. Her musical talent is not valued in her fishing hold, especially by her parents the holders, as women in general tend to be less valued and have fewer choices than men in Pernese society. When her father denies her what she regards to be her destiny, she flees Half Circle Hold just as Pern is struck by the deadly danger of Threadfall, a deathly rain that falls from the sky. Menolly takes shelter in a cave by the sea and there, she makes a miraculous discovery that will change her life.	music	t
91	9780606090155	The Magic School Bus	To celebrate its 20th anniversary, Scholastic is re-releasing the ten original Magic School Bus titles in paperback. With updated scientific information, the bestselling science series ever is back!\n\nThe classroom is decorated as Dinosaur Land, but Ms. Frizzle-inspired by an archeological dig-craves a more authentic experience. The Magic School Bus turns into a time machine and transports the class back millions of years to an adventure where they learn about dinosaurs, their habitats and diets, and even a Maiasaura nesting ground	music	f
92	9780606090032	The Visitor	Rachel is still reeling from the news that the Earth is secretly under attack by parasitic aliens. And that she and her friends are the planets only defense.	music	t
93	9781522705635	Teleny or the Reverse of the Medal	Camille Des Grieux, a French man, attends a classical concert with his mother. When a Hungarian piano player named Rène Teleny starts to play, Des Greiux begins to have shared visions of lust with the piano player. This book is story of two men and their journey to and from each other, their hearts only made for one another.	music	t
94	9780760765043	HARRY and the Lady Next Door	An early reading book.\n\nThe lady next door sings too loud and too high, and Harry, usually quite a friendly dog, cannot bear it! But what can he do?	music	t
95	9789038898094	The Guts	"The man who invented the Commitments back in the 1980s is now 47, with a loving wife, 4 kids...and bowel cancer. He isnt dying, he thinks, but he might be. Jimmy still loves his music, and he still loves to hustle--his new thing is finding old bands and then finding the people who loved them enough to pay money online for their resurrected singles and albums. On his path through Dublin, between chemo and work he meets two of the Commitments--Outspan Foster, whose own illness is probably terminal, and Imelda Quirk, still as gorgeous as ever. He is reunited with his long-lost brother, Les, and learns to play the trumpet.... This warm, funny novel is about friendship and family, about facing death and opting for life"--	music	t
96	9798779305723	The Sign of Four	The Sign of the Four (1890), also called The Sign of Four, is the second novel featuring Sherlock Holmes written by Sir Arthur Conan Doyle.\n\n\n----------\nAlso contained in:\n[Adventures of Sherlock Holmes](https://openlibrary.org/works/OL20624138W)\n[Adventures of Sherlock Holmes](https://openlibrary.org/works/OL18191906W)\n[Annotated Sherlock Holmes. 1/2](https://openlibrary.org/works/OL1518438W)\n[Best of Sherlock Holmes](https://openlibrary.org/works/OL18195589W)\n[Boys Sherlock Holmes](https://openlibrary.org/works/OL8696809W)\n[Celebrated Cases of Sherlock Holmes](https://openlibrary.org/works/OL16076930W)\n[Complete Sherlock Holmes](https://openlibrary.org/works/OL18188824W)\n[Complete Sherlock Holmes](https://openlibrary.org/works/OL14929975W)\n[Illustrated Sherlock Holmes](https://openlibrary.org/works/OL1518342W)\n[Original Illustrated Strand Sherlock Holmes](https://openlibrary.org/works/OL262529W)\n[Sherlock Holmes: His Most Famous Mysteries](https://openlibrary.org/works/OL14930414W)\n[Sherlock Holmes: The Novels](https://openlibrary.org/works/OL16018654W)\n[The Sign of the Four, A Scandal in Bohemia and Other Stories](https://openlibrary.org/works/OL20630338W)\n[Sign of the Four and Other Stories](https://openlibrary.org/works/OL20628655W)\n[Tales of Sherlock Holmes](https://openlibrary.org/works/OL1518350W)\n[Tales of Sherlock Holmes](https://openlibrary.org/works/OL1518418W)\n[Works](https://openlibrary.org/works/OL16173818W)	mystery and detective stories	t
97	9788490019382	The Return of Sherlock Holmes	The Return of Sherlock Holmes is a 1905 collection of 13 Sherlock Holmes stories, originally published in 1903–1904, by Arthur Conan Doyle. The stories were published in the Strand Magazine in Britain and Colliers in the United States.\n\nContains:\n[Adventure of the Empty House](https://openlibrary.org/works/OL1518119W/The_Adventure_of_the_Empty_House)\n[Adventure of the Norwood Builder](https://openlibrary.org/works/OL262418W/Adventure_of_the_Norwood_Builder)\n[Adventure of the Dancing Men](https://openlibrary.org/works/OL262417W/The_Dancing_Men)\n[Adventure of the Solitary Cyclist](https://openlibrary.org/works/OL1518122W/Adventure_of_the_Solitary_Cyclist)\n[Adventure of the Priory School](https://openlibrary.org/works/OL1518319W/Adventure_of_the_Priory_School)\nBlack Peter\n[Adventure of Charles Augustus Milverton](https://openlibrary.org/works/OL20621973W/Adventure_of_Charles_Augustus_Milverton)\n[Six Napoleons](https://openlibrary.org/works/OL20628495W)\n[Adventure of the Three Students](https://openlibrary.org/works/OL1518368W/Adventure_of_the_Three_Students)\n[Adventure of the Golden Pince-Nez](https://openlibrary.org/works/OL18191848W/Adventure_of_the_Golden_Pince-Nez)\n[Adventure of the Missing Three-Quarter](https://openlibrary.org/works/OL18191816W/Adventure_of_the_Missing_Three_Quarter)\n[Adventure of the Abbey Grange](https://openlibrary.org/works/OL17084226W/Adventure_of_the_Abbey_Grange)\n[Second Stain](https://openlibrary.org/works/OL18191864W/Second_Stain)\n\n\n----------\nAlso contained in:\n[Celebrated Cases of Sherlock Holmes](https://openlibrary.org/works/OL16076930W)\n[Illustrated Sherlock Holmes](https://openlibrary.org/works/OL1518342W)\n[Original Illustrated Sherlock Holmes](https://openlibrary.org/works/OL1518150W)\n[Original Illustrated Strand Sherlock Holmes](https://openlibrary.org/works/OL262529W)\n[Short Stories](https://openlibrary.org/works/OL14929977W)\n[Works](https://openlibrary.org/works/OL16173818W)	mystery and detective stories	t
98	9781015520943	Memoirs of Sherlock Holmes [11 stories]	Contains:\n\n[Silver Blaze](https://openlibrary.org/works/OL1518358W/Silver_Blaze)\n[Adventure of the Yellow Face](https://openlibrary.org/works/OL20571966W/Adventure_of_the_Yellow_Face)\n[Stock-Brokers Clerk](https://openlibrary.org/works/OL20619319W/Adventure_of_the_Stockbrokers_Clerk)\n[Adventure of the Gloria Scott](https://openlibrary.org/works/OL20619337W/Adventure_of_the_Gloria_Scott)\n[Adventure of the Musgrave Ritual](https://openlibrary.org/works/OL20619374W/Adventure_of_the_Musgrave_Ritual)\nAdventure of the Reigate Squire\nCrooked Man\n[Adventure of the Resident Patient](https://openlibrary.org/works/OL16090759W)\nAdventure of the Greek interpreter\n[Naval Treaty](https://openlibrary.org/works/OL14930289W/The_Naval_Treaty)\nFinal Problem\n\n\n----------\nAlso contained in:\n\n - [Adventures and Memoirs of Sherlock Holmes](https://openlibrary.org/works/OL1518128W)\n - [Celebrated Cases of Sherlock Holmes](https://openlibrary.org/works/OL16076930W)\n - [Complete Sherlock Holmes: Volume I](https://openlibrary.org/works/OL18188824W)\n - [Complete Sherlock Holmes, Volume I](https://openlibrary.org/works/OL14929975W)\n - [Short Stories](https://openlibrary.org/works/OL14929977W)\n - [Works](https://openlibrary.org/works/OL16173818W)	mystery and detective stories	t
99	9781789503937	The Invisible Man	This book is the story of Griffin, a scientist who creates a serum to render himself invisible, and his descent into madness that follows.	mystery and detective stories	t
100	9788490019351	The Case-Book of Sherlock Holmes	The Illustrious Client\nThe Blanched Soldier\nThe Adventure Of The Mazarin Stone\nThe Adventure of the Three Gables\nThe Adventure of the Sussex Vampire\nThe Adventure of the Three Garridebs\nThe Problem of Thor Bridge\nThe Adventure of the Creeping Man\nThe Adventure of the Lions Mane\nThe Adventure of the Veiled Lodger\nThe Adventure of Shoscombe Old Place\nThe Adventure of the Retired Colourman	mystery and detective stories	t
101	9782070335244	Tom Sawyer, Detective	Tom Sawyer, Detective follows Twains popular novels The Adventures of Tom Sawyer,  Adventures of Huckleberry Finn, and Tom Sawyer Abroad. In this novel, Tom turns detective, trying to solve a murder. Twain plays with and celebrates the detective novel, wildly popular at the time. This novel, like the others, is told through the first-person narrative of Huck Finn.	mystery and detective stories	t
103	9780007716975	Nemesis	E-book exclusive extras:1) Christie biographer Charles Osbornes essay on Nemesis;2) "The Marples": the complete guide to all the cases of crime literatures foremost female detective.Even the unflappable Miss Marple is astounded as she reads the letter addressed to her on instructions from the recently deceased tycoon Mr Jason Rafiel, whom she had met on holiday in the West Indies (A Caribbean Mystery). Recognising in her a natural flair for justice and a genius for crime-solving, Mr Rafiel has bequeathed to Miss Marple a £20,000 legacy—and a legacy of an entirely different sort. For he has asked Miss Marple to investigate…his own murder. The only problem is, Mr Rafiel has failed to name a suspect or suspects. And, whoever they are, they will certainly be determined to thwart Miss Marple’s inquiries—no matter what it will take to stop her.Of note: Nemesis is the last Jane Marple mystery that Agatha Christie wrote—though not the last Marple published.	mystery and detective stories	t
104	9780396068198	Murder in Three Acts	Sir Charles Cartwright should have known better than to allow thirteen guests to sit down for dinner. For at the end of the evening one of them is dead—choked by a cocktail that contained no trace of poison.\n\nPredictable, says Hercule Poirot, the great detective. But entirely unpredictable is that he can find absolutely no motive for murder.…	mystery and detective stories	t
105	9788482565415	They Came to Baghdad	E-book exclusive extras: Agatha Christie in Baghdad, extensive selections from Agatha Christie: An Autobiography. Plus: Christie biographer Charles Osbornes essay on They Came to Baghdad.Agatha Christie first visited Baghdad as a tourist in 1927; many years later she would become a resident of the exotic and then open city, and it was here, and while on archaeological digs throughout Iraq with her husband, Sir Max Mallowan, that Agatha Christie wrote some of her most important works.They Came to Baghdad is one of Agatha Christies highly successful forays into the spy thriller genre. In this novel, Baghdad is the chosen location for a secret superpower summit. But the word is out, and an underground organisation is plotting to sabotage the talks.Into this explosive situation stumbles Victoria Jones, a young woman with a yearning for adventure who gets more than she bargains for when a wounded secret agent dies in her hotel room. Now, if only she could make sense of his final words: Lucifer... Basrah... Lefarge...	mystery and detective stories	t
106	9786169015307	Breaking Dawn	When you loved the one who was killing you, it left you no options. How could you run, how could you fight, when doing so would hurt that beloved one? If your life was all you had to give, how could you not give it? If it was someone you truly loved? To be irrevocably in love with a vampire is both fantasy and nightmare woven into a dangerously heightened reality for Bella Swan. Pulled in one direction by her intense passion for Edward Cullen, and in another by her profound connection to werewolf Jacob Black, a tumultuous year of temptation, loss, and strife have led her to the ultimate turning point. Her imminent choice to either join the dark but seductive world of immortals or to pursue a fully human life has become the thread from which the fates of two tribes hangs.Now that Bella has made her decision, a startling chain of unprecedented events is about to unfold with potentially devastating, and unfathomable, consequences. Just when the frayed strands of Bellas life-first discovered in Twilight, then scattered and torn in New Moon and Eclipse-seem ready to heal and knit together, could they be destroyed... forever?The astonishing, breathlessly anticipated conclusion to the Twilight Saga, Breaking Dawn illuminates the secrets and mysteries of this spellbinding romantic epic that has entranced millions.	mystery and detective stories	t
107	9783842472594	Scarhaven Keep	Scarhaven. A beautiful English town by the ocean, or a harbor for murder and mystery? When a famous actor goes missing, the search leads playwright Richard Copplestone to the seaside town of Scarhaven. Every clue seems to raise more questions, and Copplestone uncovers layer after layer of dark secrets, many of them involving the attractive Audrey Greyle and her family. But the intrigue goes far deeper than anyone in Scarhaven suspects. If Copplestone does not discover the truth soon, he risks endangering the lives of the friends he has made in Scarhaven -- including Audreys. - Back cover.	mystery and detective stories	t
108	9798712496037	The Red House Mystery	This is probably one of the top classics of "golden age" detective fiction. Anyone whos read any mystery novels at all will be familiar with the tropes -- an English country house in the first half of the twentieth century, a locked room, a dead body, an amateur sleuth, a helpful sidekick, and all the rest.\n\nIts a clever story, ingenious enough in its way, and an iconic example of Agatha Christie / Dorothy Sayers -type murder mysteries. If youve read more than a few of those kinds of books, you might find this one a little predictable, but its fun despite that.\n\nIts particularly of note, however, because Raymond Chandler wrote about it extensively in his essay "The Simple Art of Murder." After praising it as "an agreeable book, light, amusing in the Punch style, written with a deceptive smoothness that is not as easy as it looks," he proceeds to take it sharply to task for its essential lack of realism. This book -- which Chandler admired to an extent -- was what he saw as the iconic example of what was wrong with the detective fiction of his day, and to which novels like "The Big Sleep" or "The Long Goodbye", with their hard-boiled, hard-hitting gumshoes and gritty realism, were a direct response.\n\nSo this books worth reading not just because its "an agreeable book, light, [and] amusing in the Punch style", but also because reading it will give a deepened appreciation for the later, more realistic detective fiction of writers like Hammett and Chandler.	mystery and detective stories	t
109	9788483308301	The Haunted Bookshop	The Haunted Bookshop by Christopher Morley is the delightful tale of the bookseller Roger Mifflin, the advertising man Aubrey Gilbert, and the lovely Titania Chapman who comes to work at Mifflins Brooklyn bookshop.	mystery and detective stories	t
110	9798616932099	The Boxcar Children	Orphaned siblings Henry, Jessie, Benny, and Violet are determined not to be separated after the deaths of their parents. Fearing being sent away to live with their cruel, frightening grandfather, they run away and discover an abandoned boxcar in the woods. They convert the boxcar into a safe, comfortable home and learn to take care of themselves. But when Violet becomes deathly ill, the children are forced to seek out help at the risk of their newfound freedom.\n\nThis original 1924 edition contains a few small difference from the revised 1942 edition most readers are familiar with, but the basic story beloved by children remains essentially untouched.	mystery and detective stories	t
158	9789053335567	The God of Small Things	The God of Small Things is the debut novel of Indian writer Arundhati Roy. It is a story about the childhood experiences of fraternal twins whose lives are destroyed by the "Love Laws" that lay down "who should be loved, and how. And how much." The book explores how the small things affect peoples behavior and their lives. The book also reflects its irony against casteism, which is a major discrimination that prevails in India. It won the Booker Prize in 1997.	romance	t
111	9798593633057	The Adventure of the Speckled Band	The Adventure of the Speckled Band (SPEC) is a short story written by Arthur Conan Doyle first published in The Strand Magazine in february 1892. This is the 10th Sherlock Holmes story. Collected in The Adventures of Sherlock Holmes.\n\n\n----------\nAlso contained in:\n\n - [21 Great Stories](https://openlibrary.org/works/OL5272353W)\n - [65 Great Spine Chillers](https://openlibrary.org/works/OL4113986W)\n - [Adventures of Sherlock Holmes](https://openlibrary.org/works/OL262421W/The_Adventures_of_Sherlock_Holmes)\n - [Bedside Book of Famous British Stories](https://openlibrary.org/works/OL12844W)\n - [Best of Sherlock Holmes](https://openlibrary.org/works/OL262571W)\n - [Boys Sherlock Holmes](https://openlibrary.org/works/OL8696809W)\n - [Casebook of Sherlock Holmes](https://openlibrary.org/works/OL18193108W)\n - [Century of Detection](https://openlibrary.org/works/OL20461540W)\n - [Classic Adventures of Sherlock Holmes](https://openlibrary.org/works/OL14929956W)\n - [Extraordinary Cases of Sherlock Holmes](https://openlibrary.org/works/OL14930075W)\n - [Favorite Sherlock Holmes Detective Stories](https://openlibrary.org/works/OL1518175W)\n - [Fiction 100](https://openlibrary.org/works/OL18160158W)\n - [Fictions](https://openlibrary.org/works/OL17733654W)\n - [Fireside Reader](https://openlibrary.org/works/OL16057038W)\n - [Librivox Short Story Collection 007](https://openlibrary.org/works/OL24977897W)\n - [Literature](https://openlibrary.org/works/OL20538101W)\n - [Obras completas de Conan Doyle: II](https://openlibrary.org/works/OL20787319W)\n - [Oxford Book of Gothic Tales](https://openlibrary.org/works/OL2963651W)\n - [Pearson Literature: California: Reading and Language](https://openlibrary.org/works/OL24540813W)\n - [Prentice Hall: Literature Silver](https://openlibrary.org/works/OL7962755W)\n - [Prentice Hall Literature: Timeless Voices, Timeless Themes: Readers Companion: Silver](https://openlibrary.org/works/OL24569568W)\n - [Prentice Hall Literature: Timeless Voices, Timeless Themes: Readers Companion: Silver Level](https://openlibrary.org/works/OL24558357W)\n - [Prentice Hall Literature: Timeless Voices, Timeless Themes: Silver Level](https://openlibrary.org/works/OL16823929W)\n - [Quatre aventures de Sherlock Holmes](https://openlibrary.org/works/OL20942665W)\n - [Selected Adventures of Sherlock Holmes](https://openlibrary.org/works/OL1518403W)\n - [Sherlock Holmes: The Published Apocrypha](https://openlibrary.org/works/OL1518264W/Sherlock_Holmes)\n - [Sherlock Holmes Investigates](https://openlibrary.org/works/OL1518416W)\n - [Sherlock Holmes Mysteries](https://openlibrary.org/works/OL1518392W)\n - [Sherlock Holmes Reader](https://openlibrary.org/works/OL14930658W)\n - [Short Stories](https://openlibrary.org/works/OL7562666W)\n - [Six Great Sherlock Holmes Stories](https://openlibrary.org/works/OL1518361W)\n - [Some Adventures of Sherlock Holmes](https://openlibrary.org/works/OL24168603W)\n - [Tales of Sherlock Holmes](https://openlibrary.org/works/OL1518418W)\n - [Treasury of Sherlock Holmes](https://openlibrary.org/works/OL262548W)\n - [World of Mystery Fiction](https://openlibrary.org/works/OL6798057W)	mystery and detective stories	t
112	9781548024567	The Works of Edgar Allan Poe in Five Volumes	Contains:\n[Assignation](https://openlibrary.org/works/OL15645797W)\n[Berenice](https://openlibrary.org/works/OL15645808W)\n[Black Cat](https://openlibrary.org/works/OL41068W)\n[Cask of Amontillado](https://openlibrary.org/works/OL41016W)\n[Descent into the Maelstrom](https://openlibrary.org/works/OL273476W)\n[Domain of Arnheim](https://openlibrary.org/works/OL15645889W)\n[Eleonora](https://openlibrary.org/works/OL14937980W)\n[Facts in the Case of M. Valdemar](https://openlibrary.org/works/OL40987W)\n[Fall of the House of Usher](https://openlibrary.org/works/OL41078W)\n[Imp of the Perverse](https://openlibrary.org/works/OL15481077W)\n[Island of the Fay](https://openlibrary.org/works/OL15645993W)\n[Landors Cottage](https://openlibrary.org/works/OL15646005W)\n[Masque of the Red Death](https://openlibrary.org/works/OL41050W)\n[Mesmeric Revelation](https://openlibrary.org/works/OL15646037W)\n[Pit and the Pendulum](https://openlibrary.org/works/OL273550W)\n[Premature Burial](https://openlibrary.org/works/OL24583029W)\n[Purloined Letter](https://openlibrary.org/works/OL41065W)\n[Silence — A Fable](https://openlibrary.org/works/OL13370628W)\n[Tell-tale Heart](https://openlibrary.org/works/OL41059W)\n[Thousand-and-Second Tale of Scheherazade](https://openlibrary.org/works/OL15646039W)\n[Von Kempelen and His Discovery](https://openlibrary.org/works/OL25111544W)\n[William Wilson](https://openlibrary.org/works/OL16088822W)	mystery and detective stories	t
113	9780833508911	My fathers dragon	A young boy runs away from home to rescue an abused baby dragon held captive to serve as a free twenty-four hour, seven-days-a-week ferry for the lazy wild animals living on Wild Island.	mystery and detective stories	t
114	9782017072126	Five on a Treasure Island	Julian, Dick, Anne, George and Timmy the dog find excitement and adventure wherever they go in Enid Blytons most popular series. In their first adventure, the Famous Five find a shipwreck off Kirrin Island. But where is the treasure? The Famous Five are on the trail, looking for clues, but theyre not alone. Someone else has got the same idea! Time is running out for the Famous Five -- who will follow the clues and get to the treasure first?	mystery and detective stories	t
115	9788484410348	Over Sea, Under Stone (The Dark Is Rising #1)	On holiday in Cornwall, the three Drew children discover an ancient map in the attic of the house that they are staying in. They know immediately that it is special. It is even more than that -- the key to finding a grail, a source of power to fight the forces of evil known as the Dark. And in searching for it themselves, the Drews put their very lives in peril.\nThis is the first volume of Susan Coopers brilliant and absorbing fantasy sequence known as The Dark Is Rising.	mystery and detective stories	t
116	9782724222326	Where are the children?	Nancy Harmon had fled the evil of her first marriage, the macabre deaths of her two little children, the hideous charges against her. She changed her name and moved across the country. Now she was married again, had two more lovely children, and her life was filled with happiness....\n\nuntil the morning when she looked for her children and found only one tattered red mitten and knew that the nightmare was beginning again...	mystery and detective stories	t
117	9782070537969	The House with a Clock in Its Walls	When Lewis Barnavelt, an orphan, comes to stay with his uncle Jonathan, he expects to meet an ordinary person. But he is wrong. Uncle Jonathan and his next-door neighbor, Mrs. Zimmermann, are both magicians! Lewis is thrilled. At first, watching magic is enough. Then Lewis experiments with magic himself and unknowingly resurrects the former owner of the house: a woman named Selenna Izard. It seems that Selenna and her husband built a timepiece into the walls—a clock that could obliterate humankind. And only the Barnavelts can stop it!\n\n\n----------\nAlso contained in:\n[Best of John Bellairs](https://openlibrary.org/works/OL3338229W)	mystery and detective stories	t
118	9788491377665	Il sorriso di Monna Topisa	Geronimo investigates to see if the famous painting Mona Mousa holds a secret code.	painting	t
119	9788483463628	False Impression	Its September 10, 2001, and Lady Victoria Wentworth is sitting in spacious Wentworth Hall considering the sad state of family fortunes when a female intruder slips in, slashes her throat and cuts off her ear.  The next day in New York, art expert Anna Petrescu heads to her job as art wrangler for wealthy magnate Bryce Fenston of Fenston Finance.  The pairs offices are in the Twin towers, and when disaster strikes, each sees the tragedy as an opportunity to manipulate a transaction scheduled to transfer ownership of a legendary Van Gogh painting.	painting	t
120	9788408048947	Tom Clancys Net Force	Here comes a Clancy first: a new series of novels for young adults starring a team of troubleshooting teens--the Net Force Explorers--who know more about cutting edge technology than their teachers!	programming	t
121	9781449388393	Hackers	Today, technology is cool. Owning the most powerful computer, the latest high-tech gadget, and the whizziest website is a status symbol on a par with having a flashy car or a designer suit. And a media obsessed with the digital explosion has reappropriated the term "computer nerd" so that its practically synonymous with "entrepreneur." Yet, a mere fifteen years ago, wireheads hooked on tweaking endless lines of code were seen as marginal weirdos, outsiders whose world would never resonate with the mainstream. That was before one pioneering work documented the underground computer revolution that was about to change our world forever.\n\nWith groundbreaking profiles of Bill Gates, Steve Wozniak, MITs Tech Model Railroad Club, and more, Steven Levys Hackers brilliantly captures a seminal moment when the risk takers and explorers were poised to conquer twentieth-century Americas last great frontier. And in the Internet age, "the hacker ethic" -- first espoused here -- is alive and well. - Back cover.	programming	f
159	9785170357086	Night Over Water	On a bright September morning in 1939, two days after Britain declares war on Germany, a group of privileged but desperate people gather in Southhampton to board the largest, most luxurious airliner ever built, the Pan American Clipper bound for New York.	romance	t
122	9781449319267	Learning PHP, MySQL & JavaScript	Learning PHP, MySQL & JavaScript will teach you how to create responsive, data-driven websites with the three central technologies of PHP, MySQL and JavaScript - whether or not you know how to program. This simple, streamlined guide explains how the powerful combination of PHP and MySQL provides a painless way to build modern websites with dynamic data and user interaction. Youll also learn how to add JavaScript to create rich Internet websites and applications, and how to use Ajax to handle background communication with a web server. This book explains each technology separately, shows you how to combine them, and introduces valuable concepts in modern web programming, including objects, XHTML, cookies, regular expressions and session management.	programming	f
123	9798528777009	Hard Times	Dickens scathing portrait of Victorian industrial society and its misapplied utilitarian philosophy, Hard Times features schoolmaster Thomas Gradgrind, one of his most richly dimensional, memorable characters. Filled with the details and wonders of small-town life, it is also a daring novel of ideas and ultimately, a celebration of love, hope, and limitless possibilities of the imagination.	psychology	t
124	9798598007266	Saint Francis of Assisi	G.K. Chesterton lends his witty, astute and sardonic prose to the much loved figure of Saint Francis of Assis. Grounding the man behind the myth he states "however wild and romantic his gyrations might appear to many, [Francis] always hung on to reason by one invisible and indestructible hair....The great saint was sane....He was not a mere eccentric because he was always turning towards the center and heart of the maze; he took the queerest and most zigzag shortcuts through the wood, but he was always going home."Review: "his opinions shine from every page. The reader is rewarded with many fresh perspectives on Francis..." -- Franciscan, May 2002	psychology	f
125	9783423140577	Tender is the Night	A psychiatrist, Dick Diver, treats and eventually marries a wealthy patient, Nicole.  Eventually, this marriage destroys him.	psychology	t
126	9789754585728	The Curious Incident of the Dog in the Night-Time	This is Christophers murder mystery story. There are no lies in this story because Christopher cant tell lies. christopher does not like strangers or the colours yellow or brown or being touched. On the other hand, he knows all the countries in the world and their capital cities and every prime number up to 7507. When Christohper decides to find out who killed the neighbours dog, his mystery story becomes more complicated than he could ever have predicted.	psychology	t
127	9780751527377	Tuesdays with Morrie	Tuesdays with Morrie is a memoir by American author Mitch Albom about a series of visits Albom made to his former sociology professor Morrie Schwartz, as Schwartz gradually dies of ALS. The book topped the New York Times Non-Fiction Best-Sellers List for 23 combined weeks in 2000, and remained on the New York Times best-selling list for more than four years after. In 2006, Tuesdays with Morrie was the bestselling memoir of all time.	psychology	f
128	9780061908040	Zen and the Art of Motorcycle Maintenance	"The real cycle youre working on is a cycle called yourself."One of the most important and influential books of the past half-century, Robert M. Pirsigs Zen and the Art of Motorcycle Maintenance is a powerful, moving, and penetrating examination of how we live and a meditation on how to live better. The narrative of a father on a summer motorcycle trip across Americas Northwest with his young son, it becomes a profound personal and philosophical odyssey into lifes fundamental questions. A true modern classic, it remains at once touching and transcendent, resonant with the myriad confusions of existence and the small, essential triumphs that propel us forward.	psychology	f
129	9780583337144	Men are From Mars, Women are From Venus	Once upon a time Martians and Venusians met, fell in love, and had happy relationships together because they respected and accepted their differences. Then they came to Earth and amnesia set in: they forgot they were from different planets.Based on years of successful counseling of couples and individuals, Men Are from Mars, Women Are from Venus has helped millions of couples transform their relationships. Now viewed as a modern classic, this phenomenal book has helped men and women realize how different they really are and how to communicate their needs in such a way that conflict doesnt arise and intimacy is given every chance to grow.	psychology	f
130	9781483077031	The Fountainhead	The Fountainhead is a 1943 novel by Ayn Rand. It was Rands first major literary success and brought her fame and financial success. More than 6.5 million copies of the book have been sold worldwide.	psychology	t
131	9781721307852	Giovannis Room	Considered an audacious second novel, GIOVANNIS ROOM is set in the 1950s Paris of American expatriates, liaisons, and violence.  This now-classic story of a fated love triangle explores, with uncompromising clarity, the conflicts between desire, conventional morality and sexual identity.	psychology	t
132	9781444110241	A View from the Bridge	In A View from the Bridge Arthur Miller explores the intersection between one mans self-delusion and the brutal trajectory of fate. Eddie Carbone is a Brooklyn longshoreman, a hard-working man whose life has been soothingly predictable. He hasnt counted on the arrival of two of his wifes relatives, illegal immigrants from Italy; nor has he recognized his true feelings for his beautiful niece, Catherine. And in due course, what Eddie doesnt knowabout her, about life, about his own heartwill have devastating consequences.	psychology	t
133	9780733612275	The 48 Laws of Power	Amoral, cunning, ruthless, and instructive, this piercing work distills three thousand years of the history of power in to forty-eight well explicated laws. As attention--grabbing in its design as it is in its content, this bold volume outlines the laws of power in their unvarnished essence, synthesizing the philosophies of Machiavelli, Sun-tzu, Carl von Clausewitz, and other great thinkers. Some laws teach the need for prudence ("Law 1: Never Outshine the Master"), the virtue of stealth ("Law 3: Conceal Your Intentions"), and many demand the total absence of mercy ("Law 15: Crush Your Enemy Totally"), but like it or not, all have applications in real life. Illustrated through the tactics of Queen Elizabeth I, Henry Kissinger, P. T. Barnum, and other famous figures who have wielded--or been victimized by--power, these laws will fascinate any reader interested in gaining, observing, or defending against ultimate control.	psychology	f
145	9781731550897	Sense and Sensibility	When Mr. Dashwood dies, he must leave the bulk of his estate to the son by his first marriage, which leaves his second wife and three daughters (Elinor, Marianne, and Margaret) in straitened circumstances. They are taken in by a kindly cousin, but their lack of fortune affects the marriageability of both practical Elinor and romantic Marianne. When Elinor forms an attachment for the wealthy Edward Ferrars, his family disapproves and separates them. And though Mrs. Jennings tries to match the worthy (and rich) Colonel Brandon to her, Marianne finds the dashing and fiery Willoughby more to her taste. Both relationships are sorely tried. But this is a romance, and through the hardships and heartbreak, true love and a happy ending will find their way for both the sister who is all sense and the one who is all sensibility. - Publisher.	romance	t
134	9789570521191	My Sisters Keeper	With her penetrating insight into the hearts and minds of real people, Jodi Picoults My Sisters Keeper examines what it means to be a good parent, a good sister, a good person, and what happens when emotions meet with scientific advances. ***Now a major film.***\n\nAnna is not sick, but she might as well be. By age thirteen, she has undergone countless surgeries, transfusions and shots so that her older sister, Kate, can somehow fight the leukemia that has plagued her since childhood. **Anna was conceived as a bone marrow match for Kate a life and a role that she has never questioned until now.**\n\n**Like most teenagers, Anna is beginning to ask herself who she truly is.** But unlike most teenagers, she has always been defined in terms of her sister - and so Anna makes a decision that for most would be unthinkable a decision that will tear her family apart and have **perhaps fatal consequences for the sister she loves.**\n\n**Told from multiple points of view, My Sisters Keeper examines what it means to be a good parent, a good sister, a good person.** Is it morally correct to do whatever it takes to save a childs life . . . even if that means infringing upon the rights of another? Should you follow your own heart, or let others lead you?\n\n**Once again, in My Sisters Keeper, *Jodi Picoult tackles a controversial real-life subject with grace, wisdom, and sensitivity.***	psychology	t
135	9780385364140	Sophies Choice	The gripping, unforgettable story of Stingo, a 22-year-old writer; Sophie, a Polish-Catholic beauty who survived the Nazi concentration camp at Auschwitz; and Nathan, her mercurial lover. The three friends share magical, heart-warming times until doom overtakes them as Sophies and Nathans darkest secrets are revealed.	psychology	t
136	9782253123378	Liseys Story	Liseys Story is a novel by American writer Stephen King that combines elements of psychological horror and romance. The novel was released on October 24, 2006. It won the 2006 Bram Stoker Award for Best Novel, and was nominated for the World Fantasy Award in 2007. An early excerpt from the novel, a short story titled "Lisey and the Madman", was published in McSweeney’s Enchanted Chamber of Astonishing Stories (2004), and was nominated for the 2004 Bram Stoker Award for Best Long Fiction. King has stated that this is his favorite of the novels he has written.	psychology	t
137	9788525432186	Sapiens	New York Times Bestseller\n\nA Summer Reading Pick for President Barack Obama, Bill Gates, and Mark Zuckerberg\n\nFrom a renowned historian comes a groundbreaking narrative of humanity’s creation and evolution—a #1 international bestseller—that explores the ways in which biology and history have defined us and enhanced our understanding of what it means to be “human.”\n\nOne hundred thousand years ago, at least six different species of humans inhabited Earth. Yet today there is only one—homo sapiens. What happened to the others? And what may happen to us?\n\nMost books about the history of humanity pursue either a historical or a biological approach, but Dr. Yuval Noah Harari breaks the mold with this highly original book that begins about 70,000 years ago with the appearance of modern cognition. From examining the role evolving humans have played in the global ecosystem to charting the rise of empires, Sapiens integrates history and science to reconsider accepted narratives, connect past developments with contemporary concerns, and examine specific events within the context of larger ideas.\n\nDr. Harari also compels us to look ahead, because over the last few decades humans have begun to bend laws of natural selection that have governed life for the past four billion years. We are acquiring the ability to design not only the world around us, but also ourselves. Where is this leading us, and what do we want to become?\n\nFeaturing 27 photographs, 6 maps, and 25 illustrations/diagrams, this provocative and insightful work is sure to spark debate and is essential reading for aficionados of Jared Diamond, James Gleick, Matt Ridley, Robert Wright, and Sharon Moalem.	psychology	f
138	9780553479140	The long road home	Bestselling novelist Danielle Steel takes us on a harrowing journey into the heart of Americas hidden shame in a novel that explores the power of forgiveness, the dark side of childhood, and one womans unbreakable spirit.From her secret perch at the top of the stairs, Gabriella Harrison watches the guests arrive at her parents lavish Manhattan townhouse.  At seven, she knows she is an intruder in her parents party, in her parents life.  But she cant resist the magic.  Later, she waits for the click, click, click of her mothers high heels, the angry words, and the pain that will follow.  Gabriella already knows to hide her bruises, certain she is to blame for her mothers rage--and her fathers failure to protect her.  Her world is a confusing blend of terror, betrayal, and pain.  Her parents aristocratic world is no safeguard against the abuse that knows no boundaries, respects no person, no economic lines.  Gabriella knows that, try as she might, there is no safe place for her to hide.Even as a child, her only escape is through the stories she writes.  Only writing can dull the pain of her lonely world.  And when her parents marriage collapses, Gabriella is given her first reprieve, as her father disappears, and then her mother abandons her to a convent.  There, Gabriellas battered body and soul begin to mend.  Amid the quiet safety and hushed rituals of the nuns, Gabriella grows into womanhood in a safe, peaceful world.  Then a young priest comes into her life.  Father Joe Connors never questioned his vocation until Gabriella entered the confessional and shared her soul.  Confession leads to friendship.  And friendship grows dangerously into love.  Like Gabriella, Joe is haunted by the pain of his childhood, consumed by guilt over a family tragedy, for which he blames himself.  With Gabriella, Joe takes the first steps toward healing.  But their relationship leads to tragedy as Joe must choose between the priesthood and Gabriella, and life in the real world where he fears he does not belong, and cannot cope. Exiled and disgraced, and nearly destroyed, Gabriella struggles to survive on her own in New York.  There she seeks healing and escape through her writing again, this time as an adult, and her life as a writer begins.  But just when she thinks she is beyond hurt, Gabriella is once again betrayed by someone she trusts.  Brought to the edge of despair, physically attacked beyond recognition and belief, haunted by abuse in her present and her past, she nonetheless manages to find hope again, and the courage to face the past.  On a pilgrimage destined to bring her face-to-face with those who sought to destroy her in her early life, she finds forgiveness, freedom from guilt, and healing from abuse.  When Gabriella faces what was done to her, and why, she herself is free at last.  With profound insight, Danielle Steel has created a vivid portrait of an abused childs broken world, and the courage necessary to face it and free herself from the past.  A work of daring and compassion, a tale of healing that will shock and touch and move you to your very soul, it exposes the terror of child abuse, and opens the doors on a subject that affects us all.  The Long Road Home is more than riveting fiction.  It is an inspiration to us all.  A work of courage, hope, and love.From the Paperback edition.	psychology	t
139	9781455546435	The switch	From #1 New York Times bestselling author Sandra Brown comes another masterful creation, a riveting novel of suspense, revenge, and unpredictable twists and turns...Identical twins Melina and Gillian Lloyd havent considered switching places since childhood. So when Melina proposes that Gillian take her place as a media escort to NASA astronaut Col. "Chief" Hart, she refuses...at first. The following morning Melina receives terrible news: her sister has been brutally murdered-and Chief, though innocent, is the prime suspect. He and Melina are determined to find the killer, a megalomaniac whose horrific schemes require Gillians replacement, her identical twin-Melina.	psychology	t
140	9783436014223	Die Sexualität im Kulturkampf	**Die Sexualität im Kulturkampf** ("sexuality in the culture war"), 1936 (published later in English as **The Sexual Revolution**), is a work by Wilhelm Reich. The subtitle is "zur sozialistischen Umstrukturierung des Menschen" ("for the socialist restructuring of humans"), the double title reflecting the two-part structure of the work.\n\nThe first part "analyzes the crisis of the bourgeois sexual morality" and the failure of the attempts of "sexual reform" that preserved the frame of capitalist society (marriage and family). The second part reconstructs the history of the sexual revolution that took place with the establishment of the Soviet Union since 1922, and which was opposed by Joseph Stalin in the late 1920s.\n\n(Source: [Wikipedia](https://en.wikipedia.org/wiki/Die_Sexualit%C3%A4t_im_Kulturkampf))	psychology	f
141	9789750830426	When We Were Orphans	You seldom read a novel that so convinces you it is extending the possibilities of fiction. Sunday TimesEngland, 1930s. Christopher Banks has become the countrys most celebrated detective, his cases the talk of London society. Yet one unsolved crime has always haunted him: the mysterious disappearance of his parents, in old Shanghai, when he was a small boy. Moving between London and Shanghai of the inter-war years, When We Were Orphans is a remarkable story of memory, intrigue and the need to return.	psychology	t
142	9781400044603	Memoria de mis putas tristes	"Cuenta la vida de este anciano solitario, un apasionado de la música clásica, nada aficionado de las mascotas y lleno de manías. Por él sabremos cómo en todas sus aventuras sexuales (que no fueron pocas) siempre dio a cambio algo de dinero, pero nunca imaginó que de ese modo encontraría el verdadero amor."-- P. [4] of cover.	psychology	t
143	9780670410620	Critique of psychoanalysis	Extracted from Volumes 1, 8, and 18. Includes Jungs Foreword to Phenomènes Occultes (1939), "On the Psychology and Pathology of So-called Occult Phenomena," "The Psychological Foundations of Belief in Spirits," "The Soul and Death," "Psychology and Spiritualism," "On Spooks: Heresy or Truth?" and Foreword to Jaffé: Apparitions and Precognition.	psychology	f
144	9783499170522	The Anatomy of Human Destructiveness	A study of man’s destructive nature that utilizes evidence from psychoanalysis, neurophysiology, animal psychology, paleontology, and anthropology and is documented with clinical examples.	psychology	f
146	9781493724949	Women in Love	Dark, but filled with bright genius, Women in Love is a prophetic masterpiece steeped in eroticism, filled with perceptions about sexual power and obsession that have proven to be timeless and true.	romance	t
147	9788886229982	Heart of Darkness	Heart of Darkness (1899) is a novella by Polish-English novelist Joseph Conrad, about a voyage up the Congo River into the Congo Free State, in the heart of Africa, by the storys narrator Charles Marlow. Marlow tells his story to friends aboard a boat anchored on the River Thames. Joseph Conrad is one of the greatest English writers, and Heart of Darkness is considered his best.  His readers are brought to face our psychological selves to answer, ‘Who is the true savage?’. Originally published in 1902, Heart of Darkness remains one of this century’s most enduring works of fiction. Written several years after Joseph Conrad’s grueling sojourn in the Belgian Congo, the novel is a complex meditation on colonialism, evil, and the thin line between civilization and barbarity.	romance	t
148	9798481068572	The Age of Innocence	Edith Whartons most famous novel, written immediately after the end of the First World War, is a brilliantly realized anatomy of New York society in the 1870s, the world in which she grew up, and from which she spent her life escaping. Newland Archer, Whartons protagonist, charming, tactful, enlightened, is a thorough product of this society; he accepts its standards and abides by its rules but he also recognizes its limitations. His engagement to the impeccable May Welland assures him of a safe and conventional future, until the arrival of Mays cousin Ellen Olenska puts all his plans in jeopardy. Independent, free-thinking, scandalously separated from her husband, Ellen forces Archer to question the values and assumptions of his narrow world. As their love for each other grows, Archer has to decide where his ultimate loyalty lies. - Back cover.	romance	t
149	9780007250264	Poirot investigates	First there was the mystery of the film star and the diamond… then came the ‘suicide’ that was murder… the mystery of the absurdly chaep flat… a suspicious death in a locked gun-room… a million dollar bond robbery… the curse of a pharoah’s tomb… a jewel robbery by the sea… the abduction of a Prime Minister… the disappearance of a banker… a phone call from a dying man… and, finally, the mystery of the missing will.  What links these fascinating cases? Only the brilliant deductive powers of Hercule Poirot!	romance	t
150	9783423144544	The Portrait Of A Lady	Een rijke Amerikaanse jonge vrouw met een sterke drang naar onafhankelijkheid blijft, ondanks alles wat ze in de loop van haar huwelijk over hem te weten komt, haar onbekrompen maar oppervlakkige echtgenoot trouw.	romance	t
151	9780593685365	The Mystery of the Blue Train	Bound for the Riviera, detective Hercule Poirot has boarded Le Train Bleu, an elegant, leisurely means of travel, free of intrigue. Then he meets Ruth Kettering. The American heiress bailing out of a doomed marriage is en route to reconcile with her former lover. But by morning, her private affairs are made public when she is found murdered in her luxury compartment. The rumour of a strange man loitering in the victims shadow is all Poirot has to go on. Until Mrs. Ketterings secret life begins to unfold...	romance	t
152	9780316065221	New Moon	Love stories. Horror fiction. Now in a Special Trade Demy Paperback Edition. The dramatic sequel to TWILIGHT, following the tale of Bella, a teenage girl whose love for a vampire gets her into trouble. I stuck my finger under the edge of the paper and jerked it under the tape. Shoot,  I muttered when the paper sliced my finger. A single drop of blood oozed from the tiny cut. It all happened very quickly then. No! Edward roared ... Dazed and disorientated, I looked up from the bright red blood pulsing out of my arm - and into the fevered eyes of the six suddenly ravenous vampires. For Bella Swan, there is one thing more important than life itself: Edward Cullen. But being in love with a vampire is more dangerous than Bella ever could have imagined. Edward has already rescued Bella from the clutches of an evil vampire but now, as their daring relationship threatens all that is near and dear to them, they realise their troubles may just be beginning.	romance	t
153	9787544805711	Eclipse	A beautifully written book by Stephanie Meyer. This book will take you on an adventure like no other, the epic romance of a 110 year old vampire frozen in the body of a 17 year old, an 18 year old human named Isabella Swan. Join Edward Cullen and Bella Swan on this action packed romance.	romance	t
154	9780751558906	The Price of Salt	THE PRICE OF SALT is the famous lesbian love story by Patricia Highsmith, written under the pseudonym Claire Morgan. The author became notorious due to the storys latent lesbian content and happy ending, the latter having been unprecedented in homosexual fiction. Highsmith recalled that the novel was inspired by a mysterious woman she happened across in a shop and briefly stalked. Because of the happy ending (or at least an ending with the possibility of happiness) which defied the lesbian pulp formula and because of the unconventional characters that defied stereotypes about homosexuality, THE PRICE OF SALT was popular among lesbians in the 1950s. The book fell out of print but was re-issued and lives on today as a pioneering work of lesbian romance.	romance	t
155	9780007873746	Flowers in the Attic	Flowers in the Attic is a 1979 Gothic novel by V. C. Andrews. It is the first book in the Dollanganger Series. The novel is written in the first-person, from the point of view of Cathy Dollanganger. In 1993, Flowers in the Attic was awarded the Secondary BILBY Award. In 2003 the book was listed on the BBCs The Big Read poll of the UKs 200 "best-loved novels."\n\n\n----------\nAlso contained in:\n[Flowers in the Attic / Petals on the Wind](https://openlibrary.org/works/OL16524231W)	romance	t
156	9781407224299	Der Vorleser	Hailed for its coiled eroticism and the moral claims it makes upon the reader, this mesmerizing novel is a story of love and secrets, horror and compassion, unfolding against the haunted landscape of postwar Germany.When he falls ill on his way home from school, fifteen-year-old Michael Berg is rescued by Hanna, a woman twice his age. In time she becomes his lover--then she inexplicably disappears. When Michael next sees her, he is a young law student, and she is on trial for a hideous crime. As he watches her refuse to defend her innocence, Michael gradually realizes that Hanna may be guarding a secret she considers more shameful than murder.	romance	t
157	9781096931553	The Custom of the Country	Edith Whartons satiric anatomy of American society in the first decade of the twentieth century appeared in 1913; it both appalled and fascinated its first reviewers, and established her as a major novelist. It follows the career of Undine Spragg, recently arrived in New York from the Midwest and determined to conquer high society. Glamorous, selfish, mercenary, and manipulative, her principal assets are her striking beauty, her tenacity, and her fathers money. With her sights set on an advantageous marriage, Undine pursues her schemes in a world of shifting values, where triumph is swiftly followed by disillusion. Wharton was re-creating an environment she knew intimately, and Undines education for social success is chronicled in meticulous detail. The novel superbly captures the world of post-Civil War Ameria, as ruthless in its social ambitions as in its business and politics. - Back cover.	romance	t
194	9781795245128	On Liberty	Book digitized by Google from the library of the New York Public Library and uploaded to the Internet Archive by user tpb.	women	f
160	9788418327537	Americanah	Americanah is a 2013 novel by the Nigerian author Chimamanda Ngozi Adichie, for which Adichie won the 2013 U.S. National Book Critics Circle Award for fiction. Americanah tells the story of a young Nigerian woman, Ifemelu, who immigrates to the United States to attend university. The novel traces Ifemelus life in both countries, threaded by her love story with high school classmate Obinze.	romance	t
161	9788433915955	Seta	France, 1861. When an epidemic threatens to wipe out the silk trade in France, silkworm breeder Herve Joncour has to travel overland to distant Japan, out of bounds to foreigners, to smuggle out healthy silkworms. In the course of his secret negotiations with the local baron, Joncours attention is arrested by the mans concubine, a girl who does not have oriental eyes. Although they are unable to exchange so much as a word, love blossoms between them.	romance	t
162	9780751547498	The Notebook	A man with a faded, well-worn notebook open in his lap. A woman experiencing a morning ritual she doesnt understand. Until he begins to read to her. An achingly tender story about the enduring power of love.\n\nA man with a faded, well-worn notebook open in his lap. A woman experiencing a morning ritual she doesnt understand. Until he begins to read to her. The Notebook is an achingly tender story about the enduring power of love, a story of miracles that will stay with you forever.\n\nSet amid the austere beauty of coastal North Carolina in 1946, The Notebook begins with the story of Noah Calhoun, a rural Southerner returned home from World War II. Noah, thirty-one, is restoring a plantation home to its former glory, and he is haunted by images of the beautiful girl he met fourteen years earlier, a girl he loved like no other. Unable to find her, yet unwilling to forget the summer they spent together, Noah is content to live with only memories...until she unexpectedly returns to his town to see him once again.\n\nAllie Nelson, twenty-nine, is now engaged to another man, but realizes that the original passion she felt for Noah has not dimmed with the passage of time. Still, the obstacles that once ended their previous relationship remain, and the gulf between their worlds is too vast to ignore. With her impending marriage only weeks away, Allie is forced to confront her hopes and dreams for the future, a future that only she can shape.\n\nLike a puzzle within a puzzle, the story of Noah and Allie is just the beginning. As it unfolds, their tale miraculously becomes something different, with much higher stakes. The result is a deeply moving portrait of love itself, the tender moments and the fundamental changes that affect us all. Shining with a beauty that is rarely found in current literature, The Notebook establishes Nicholas Sparks as a classic storyteller with a unique insight into the only emotion that really matters.\n\n"I am nothing special, of this I am sure. I am a common man with common thoughts and Ive led a common life. There are no monuments dedicated to me and my name will soon be forgotten, but Ive loved another with all my heart and soul, and to me, this has always been enough."\n\nAnd so begins one of the most poignant and compelling love stories you will ever read...The Notebook	romance	t
163	9780786022625	Riders of the Purple Sage	Riders of the Purple Sage is a novel that tells the story of a woman by the name of Jane Withersteen and her battle to overcome persecution by members of  her polygamous Mormon fundamentalist church. A leader of the church, Elder Tull, wants to marry her, but she has evaded him for years. Things get complicated when Bern Venters and Lassiter, a famous gunman and killer of Mormons help her look after her cattle and horses. She is blinded by her faith to see that her church men are the ones harming her. But when her adopted child disappears... she abandons her beliefs and discovers her true love. The plot deepens and it involves a horse race and a decision to whether to roll a large stone that forever closes off the only way in or out of her hiding place. A second plot involves a innocent girl Bern Venters accidentally shot…or is she innocent?! The lives of all these people intertwine ….past…present and future! Preceded by Zane Greys book: The Heritage of the West and Followed by Zane Greys book: The Rainbow Trail	romance	t
164	9780965739221	Oryx and Crake	Oryx and Crake is at once an unforgettable love story and a compelling vision of the future. Snowman, known as Jimmy before mankind was overwhelmed by a plague, is struggling to survive in a world where he may be the last human, and mourning the loss of his best friend, Crake, and the beautiful and elusive Oryx whom they both loved. In search of answers, Snowman embarks on a journey–with the help of the green-eyed Children of Crake–through the lush wilderness that was so recently a great city, until powerful corporations took mankind on an uncontrolled genetic engineering ride. Margaret Atwood projects us into a near future that is both all too familiar and beyond our imagining.	romance	t
165	9781870587174	The Dukes Children	*The Palliser Novels*, book 6: *The Dukes Children*\n\nPlantagenet Palliser, the Duke of Omnium and former Prime Minister of England, is widowed and wracked by grief. Struggling to adapt to life without his beloved Lady Glencora, he works hard to guide and support his three adult children. Palliser soon discovers, however, that his own plans for them are very different from their desires. Sent down from university in disgrace, his two sons quickly begin to run up gambling debts. His only daughter, meanwhile, longs passionately to marry the poor son of a county squire against her fathers will. But while the Dukes dearest wishes for the three are thwarted one by one, he ultimately comes to understand that parents can learn from their own children. The final volume in the Palliser novels, *The Dukes Children* (1880) is a compelling exploration of wealth, pride and ultimately the strength of love.	romance	t
166	9789044924374	Lie Down With Lions	Ellis, the American. Jean-Pierre, the Frenchman. They were two men on opposite sides of the cold war, with a woman torn between them. Together, they formed a triangle of passion and deception, racing from terrorist bombs in Paris to the violence and intrigue of Afghanistan - to the moment of truth and deadly decision for all of them...\n\nThe intrigue surrounding Russian efforts to assassinate Masud, the leader of the Afghan guerrilla forces battling the Russians, sweeps a young Englishwoman, a French physician, and a roving American into its maelstrom	romance	t
167	9798493105944	Frankenstein; or, The Modern Prometheus	*Frankenstein; or, The Modern Prometheus* is an 1818 novel written by English author Mary Shelley. Frankenstein tells the story of Victor Frankenstein, a young scientist who creates a sapient creature in an unorthodox scientific experiment. Shelley started writing the story when she was 18, and the first edition was published anonymously in London on 1 January 1818, when she was 20. Her name first appeared in the second edition, which was published in Paris in 1821.	science fiction	t
168	9781543122183	The Time Machine	The Time Traveller, a dreamer obsessed with traveling through time, builds himself a time machine and, much to his surprise, travels over 800,000 years into the future. He lands in the year 802701: the world has been transformed by a society living in apparent harmony and bliss, but as the Traveler stays in the future he discovers a hidden barbaric and depraved subterranean class. Wellss transparent commentary on the capitalist society was an instant bestseller and launched the time-travel genre.	science fiction	t
169	9781522018575	The Lost World	Journalist Ed Malone is looking for an adventure, and thats exactly what he finds when he meets the eccentric Professor Challenger - an adventure that leads Malone and his three companions deep into the Amazon jungle, to a lost world where dinosaurs roam free.	science fiction	t
170	9798744519681	The Iron Heel	https://en.wikipedia.org/wiki/The_Iron_Heel	science fiction	t
171	9798515519834	Flatland	Flatland: A Romance of Many Dimensions, though written in 1884, is still considered useful in thinking about multiple dimensions. It is also seen as a satirical depiction of Victorian society and its hierarchies. A square, who is a resident of the two-dimensional Flatland, dreams of the one-dimensional Lineland. He attempts to convince the monarch of Lineland of the possibility of another dimension, but the monarch cannot see outside the line. The square is then visited himself by a Sphere from three-dimensional Spaceland, who must show the square Spaceland before he can conceive it. As more dimensions enter the scene, the storys discussion of fixed thought and the kind of inhuman action which accompanies it intensifies.	science fiction	t
172	9783596200269	Brave New World	Originally published in 1932, this outstanding work of literature is more crucial and relevant today than ever before. Cloning, feel-good drugs, antiaging programs, and total social control through politics, programming, and media -- has Aldous Huxley accurately predicted our future? With a storytellers genius, he weaves these ethical controversies in a compelling narrative that dawns in the year 632 AF (After Ford, the deity). When Lenina and Bernard visit a savage reservation, we experience how Utopia can destroy humanity. A powerful work of speculative fiction that has enthralled and terrified readers for generations, Brave New World is both a warning to be heeded and thought-provoking yet satisfying entertainment. - Container.	science fiction	t
173	9781548210823	The Secret Agent	**The Secret Agent: A Simple Tale** is a novel by Joseph Conrad, first published in 1907. The story is set in London in 1886 and deals with Mr. Adolf Verloc and his work as a spy for an unnamed country (presumably Russia). The Secret Agent is one of Conrads later political novels in which he moved away from his former tales of seafaring. The novel is dedicated to H. G. Wells and deals broadly with anarchism, espionage, and terrorism. It also deals with exploitation of the vulnerable in Verlocs relationship with his brother-in-law Stevie, who has an intellectual disability. Conrad’s gloomy portrait of London depicted in the novel was influenced by Charles Dickens’ *Bleak House*.\n\n(Source: [Wikipedia](https://en.wikipedia.org/wiki/The_Secret_Agent))	science fiction	t
174	9798459325263	The Island of Dr. Moreau	See work: https://openlibrary.org/works/OL15308975W	science fiction	t
175	9798819971550	The Napoleon of Notting Hill	A witty and surreal novel of the future.\n\nIn a rather dull stuck-in-a-rut future, a prankster chosen randomly to be King of England revives the old ways and inadvertently arouses romantic patriotism and civil war between the boroughs of London.	science fiction	t
176	9781521899359	When the Sleeper Awakes	A troubled insomniac in 1890s England falls suddenly into a sleep-like trance, from which he does not awake for over two hundred years. During his centuries of slumber, however, investments are made that make him the richest and most powerful man on Earth. But when he comes out of his trance he is horrified to discover that the money accumulated in his name is being used to maintain a hierarchal society in which most are poor, and more than a third of all people are enslaved. Oppressed and uneducated, the masses cling desperately to one dream – that the sleeper will awake, and lead them all to freedom.	science fiction	t
177	9786257650762	In the days of the comet	H. G. Wells, in his 1906 In the Days of the Comet uses the vapors of a comet to trigger a deep and lasting change in humanitys perspective on themselves and the world. In the build-up to a great war, poor student William Leadford struggles against the harsh conditions the lower-class live under. He also falls in love with a middle-class girl named Nettie. But when he discovers that Nettie has eloped with a man of upper-class standing, William struggles with the betrayal, and in the disorder of his own mind decides to buy a revolver and kill them both. All through this a large comet lights the night sky with a green glow, bright enough that the street lamps are left unlit.	science fiction	t
178	9788445013816	A Clockwork Orange	A Clockwork Orange is a dystopian satirical black comedy novel by English writer Anthony Burgess, published in 1962. It is set in a near-future society that has a youth subculture of extreme violence. The teenage protagonist, Alex, narrates his violent exploits and his experiences with state authorities intent on reforming him. The book is partially written in a Russian-influenced argot called "Nadsat", which takes its name from the Russian suffix that is equivalent to -teen in English. According to Burgess, it was a jeu desprit written in just three weeks.\n\nIn 2005, A Clockwork Orange was included on Time magazines list of the 100 best English-language novels written since 1923, and it was named by Modern Library and its readers as one of the 100 best English-language novels of the 20th century. The original manuscript of the book has been kept at McMaster Universitys William Ready Division of Archives and Research Collections in Hamilton, Ontario, Canada since the institution purchased the documents in 1971. It is considered one of the most influential dystopian books.\n\n----------\nAlso contained in:\n\n[A Clockwork Orange and Honey for the Bears](https://openlibrary.org/works/OL23787405W)\n[A Clockwork Orange / The Wanting Seed](https://openlibrary.org/works/OL17306508W)	science fiction	t
179	9780451155801	2001	A novel that proposes an idea about how the human race might have begun and where it might be headed...given a little help from out there. A colaboration of ideas with director Stanley Kubrick in the late 1960s it begins at "the dawn of man" and then leaps to the year 2001 where a mission to Saturn (Jupiter in the film) is mounted to try and answer questions raised by the discovery of an ancient artifact dug up on the moon. Though not particularly fast paced, the science is good, and there are a few hair raising events. There are also interesting speculations about the future, such as the space shuttle, and a device eerily similar to an iPad. Leaving plenty of room for contemplation and the appreciation for the inevitable trials of space travel, this is one of the truly landmark pieces of hard science fiction.	science fiction	t
180	9798575593997	The First Men in the Moon	When penniless businessman Mr Bedford retreats to the Kent coast to write a play, he meets by chance the brilliant Dr Cavor, an absent-minded scientist on the brink of developing a material that blocks gravity. Cavor soon succeeds in his experiments, only to tell a stunned Bedford the invention makes possible one of the oldest dreams of humanity: a journey to the moon. With Bedford motivated by money, and Cavor by the desire for knowledge, the two embark on the expedition. But neither are prepared for what they find - a world of freezing nights, boiling days and sinister alien life, on which they may be trapped forever.	science fiction	t
181	9783125781535	The Hunger Games	The Hunger Games is a 2008 dystopian novel by the American writer Suzanne Collins. It is written in the perspective of 16-year-old Katniss Everdeen, who lives in the future, post-apocalyptic nation of Panem in North America. The Capitol, a highly advanced metropolis, exercises political control over the rest of the nation. The Hunger Games is an annual event in which one boy and one girl aged 12–18 from each of the twelve districts surrounding the Capitol are selected by lottery to compete in a televised battle royale to the death.\n\nThe book received critical acclaim from major reviewers and authors. It was praised for its plot and character development. In writing The Hunger Games, Collins drew upon Greek mythology, Roman gladiatorial games, and contemporary reality television for thematic content. The novel won many awards, including the California Young Reader Medal, and was named one of Publishers Weeklys "Best Books of the Year" in 2008.\n\nThe Hunger Games was first published in hardcover on September 14, 2008, by Scholastic, featuring a cover designed by Tim OBrien.	science fiction	t
182	9798721858116	A Modern Utopia	Imagine a life without worries. You live in a perfect environment untouched by pollution. You have a job to do and play an important role in society. The politicians are watching out for your best interest. And, you get along with your neighbors. Wells’ utopia may not only be unattainable, it may be detrimental to humanity’s progress. Decide for yourself as you read this classic quest for social equality in the modern era.	science fiction	t
183	9780307291868	Contact	In December, 1999, a multinational team journeys out to the stars, to the most awesome encounter in human history. Who -- or what -- is out there?\nIn Cosmos, Carl Sagan explained the universe. In Contact, he predicts its future -- and our own.	science fiction	t
184	9789731249759	Slaughterhouse-Five	Slaughterhouse-Five is one of the worlds great anti-war books. Centering on the infamous fire-bombing of Dresden, Billy Pilgrims odyssey through time reflects the mythic journey of our own fractured lives as we search for meaning in what we are afraid to know.	science fiction	t
185	9789650722159	Do Androids Dream of Electric Sheep?	It was January 2021, and Rick Deckard had a license to kill.\nSomewhere among the hordes of humans out there, lurked several rogue androids. Deckards assignment--find them and then..."retire" them. Trouble was, the androids all looked exactly like humans, and they didnt want to be found!	science fiction	t
186	9788382025866	A Game of Thrones	A Game of Thrones is the first novel in A Song of Ice and Fire, a series of fantasy novels by the American author George R. R. Martin. It was first published on August 1, 1996. The novel won the 1997 Locus Award and was nominated for both the 1997 Nebula Award and the 1997 World Fantasy Award. The novella Blood of the Dragon, comprising the Daenerys Targaryen chapters from the novel, won the 1997 Hugo Award for Best Novella. In January 2011, the novel became a New York Times Bestseller and reached No. 1 on the list in July 2011.	science fiction	t
187	9788484374633	The Blind Assassin	More than fifty years on, Iris Chase is remembering Lauras mysterious death. And so begins an extraordinary and compelling story of two sisters and their secrets. Set against a panoramic backdrop of twentieth-century history, The Blind Assassin is an epic tale of memory, intrigue and betrayal...	science fiction	t
188	9798672902401	Tales of space and time	Tales of Space and Time collects together two novellas and three short stories by the great science fiction writer H. G. Wells. First published in 1899, this absorbing and stimulating read contains:The Crystal Egg (short story)The Star (short story)A Story of the Stone Age (novella)A Story of the Days To Come" (novella)The Man Who Could Work Miracles (short story)	science fiction	t
189	9783596905621	The Man in the High Castle	The Man in the High Castle is an alternate history novel by American writer Philip K. Dick. Published and set in 1962, the novel takes place fifteen years after an alternative ending to World War II, and concerns intrigues between the victorious Axis Powers—primarily, Imperial Japan and Nazi Germany—as they rule over the former United States, as well as daily life under the resulting totalitarian rule. The Man in the High Castle won the Hugo Award for Best Novel in 1963. Beginning in 2015, the book was adapted as a multi-season TV series, with Dicks daughter, Isa Dick Hackett, serving as one of the shows producers.\n\nReported inspirations include Ward Moores alternate Civil War history, Bring the Jubilee (1953), various classic World War II histories, and the I Ching (referred to in the novel). The novel features a "novel within the novel" comprising an alternate history within this alternate history wherein the Allies defeat the Axis (though in a manner distinct from the actual historical outcome).	science fiction	t
190	9788499323091	Mockingjay	Against all odds, Katniss Everdeen has survived the Hunger Games twice. But now that shes made it out of the bloody arena alive, shes still not safe. The Capitol is angry. The Capitol wants revenge. Who do they think should pay for the unrest? Katniss. And whats worse, President Snow has made it clear that no one else is safe either. Not Katnisss family, not her friends, not the people of District 12. Powerful and haunting, this is the thrilling final installment of Suzanne Collinss groundbreaking Hunger Games trilogy. - Publisher.	science fiction	t
191	9781528771689	Wuthering Heights	Wuthering Heights is an 1847 novel by Emily Brontë, initially published under the pseudonym Ellis Bell. It concerns two families of the landed gentry living on the West Yorkshire moors, the Earnshaws and the Lintons, and their turbulent relationships with Earnshaws adopted son, Heathcliff. The novel was influenced by Romanticism and Gothic fiction.	women	t
192	9780141974217	The House of Mirth	Beautiful, intelligent, and hopelessly addicted to luxury, Lily Bart is the heroine of this Wharton masterpiece. But it is her very taste and moral sensibility that render her unfit for survival in this world.	women	t
193	9781686493928	Voyage Out	“The Voyage Out” by Virginia Woolf.\n\nThis is a story about a young English woman, Rachel, on a sea voyage from London, to a South American   coastal city of Santa Marina. As I read the story,  the title of the story became  a metaphor for Rachels inner journey.\nThe inner journey within this story is perhaps best summarized in the authors words:\n“The next few months passed away, as many years can pass away, without definite events, and yet, if suddenly disturbed, it would be seen that such months or years had a character unlike others.”\n Rachels mother has passed away many years ago. The sea voyage and the subsequent months in Santa Marina show that Rachel is also on an inner journey, to understand herself better.  She seeks advice from Helen, her aunt,  and Helen and Rachel become close friends.\n“…................The vision of her own personality, of herself as a real everlasting thing, different from anything else, unmergeable, like the sea or the wind, flashed into Rachels mind, and she became profoundly excited at the thought of living...................”\n\nRachel falls in love with a young Englishman, Terence, in Santa Marina.  But tragically, she falls ill and dies.  Yet, in the brief time that Helen and Terence have known her, her journey has also made them reflect about their own lives.	women	t
195	9780713684070	Taming of the Shrew	This play within a play is a delightful farce about a fortune hunter who marries and tames" the town shrew. The comedy, often produced today because of its accessibility, is one of the plays Shakespeare intended for the general public rather than for the nobility.\n\n\nCliffsComplete combines the full original text of The Taming of the Shrew with a helpful glossary and CliffsNotes-quality commentary into one volume. You will find:A unique pedagogical approach that combines the complete original text with expert commentary following each sceneA descriptive bibliography and historical background on the author, the times, and the work itselfAn improved character map that graphically illustrates the relationships among the charactersSidebar glossaries"	women	f
196	9781411436718	The Rainbow	(Brangwen Family #1)\n\nLush with imagery, this is the story of three generations of Brangwen women living during the decline of English rural life. Banned upon publication, it explores the most taboo subjects of its time: marriage, physical love, and one familys sexual mores.	women	t
197	9798469546283	Orlando	In her most exuberant, most fanciful novel, Woolf has created a character liberated from the restraints of time and sex. Born in the Elizabethan Age to wealth and position, Orlando is a young nobleman at the beginning of the story-and a modern woman three centuries later.	women	t
198	9781080104598	The Awakening	The Awakening is a novel by Kate Chopin, first published in 1899. Set in New Orleans and on the Louisiana Gulf coast at the end of the 19th century, the plot centers on Edna Pontellier and her struggle between her increasingly unorthodox views on femininity and motherhood with the prevailing social attitudes of the turn-of-the-century American South. It is one of the earliest American novels that focuses on womens issues without condescension. It is also widely seen as a landmark work of early feminism, generating a mixed reaction from contemporary readers and critics.	women	t
199	9783311220039	A Room of Ones Own	A Room of Ones Own is an extended essay by Virginia Woolf. First published on 24 October 1929, the essay was based on a series of lectures she delivered at Newnham College and Girton College, two womens colleges at Cambridge University in October 1928. While this extended essay in fact employs a fictional narrator and narrative to explore women both as writers of and characters in fiction, the manuscript for the delivery of the series of lectures, titled "Women and Fiction", and hence the essay, are considered non-fiction. The essay is generally seen as a feminist text, and is noted in its argument for both a literal and figural space for women writers within a literary tradition dominated by patriarchy.	women	f
200	9782846813785	Troilus and Cressida	With new editors who have incorporated the most up-to-date scholarship, this revised Pelican Shakespeare series will be the premiere choice for students, professors, and general readers well into the twenty-first century.Each volume features:* Authoritative, reliable texts* High quality introductions and notes* New, more readable trade trim size* An essay on the theatrical world of Shakespeare and essays on Shakespeares life and the selection of texts	women	t
201	9781956221374	Rose in Bloom	In this sequel to Eight Cousins, Rose Campbell returns to the "Aunt Hill" after two years of traveling around the world. Suddenly, she is surrounded by male admirers, all expecting her to marry them. But before she marries anyone, Rose is determined to establish herself as an independent young woman. Besides, she suspects that some of her friends like her more for her money than for herself.	women	t
202	9781609772208	Vanity Fair	No one is better equipped in the struggle for wealth and worldly success than the alluring and ruthless Becky Sharp, who defies her impoverished background to clamber up the class ladder. Her sentimental companion Amelia, however, longs only for caddish soldier George. As the two heroines make their way through the tawdry glamour of Regency society, battles - military and domestic - are fought, fortunes made and lost. The one steadfast and honourable figure in this corrupt world is Dobbin with his devotion to Amelia, bringing pathos and depth to Thackerays gloriously satirical epic of love and social adventure.	women	t
203	9798464079458	She	An enduring adventure yarn set in pre colonial Africa, culminating in the discovery of a lost civilization ruled by a beautiful eternally youthful queen. "She is generally considered to be one of the classics of imaginative literature and with 83 million copies sold by 1965, it is one of the best-selling books of all time." See more at: http://en.wikipedia.org/wiki/She_(novel)	women	t
204	9781784878672	Beloved	Toni Morrison--author of Song of Solomon and Tar Baby--is a writer of remarkable powers: her novels, brilliantly acclaimed for their passion, their dazzling language and their lyric and emotional force, combine the unassailable truths of experience and emotion with the vision of legend and imagination. It is the story--set in post-Civil War Ohio--of Sethe, an escaped slave who has risked death in order to wrench herself from a living death; who has lost a husband and buried a child; who has borne the unthinkable and not gone mad: a woman of "iron eyes and backbone to match." Sethe lives in a small house on the edge of town with her daughter, Denver, her mother-in-law, Baby Suggs, and a disturbing, mesmerizing intruder who calls herself Beloved. Sethe works at "beating back the past," but it is alive in all of them. It keeps Denver fearful of straying from the house. It fuels the sadness that has settled into Baby Suggs "desolated center where the self that was no self made its home." And to Sethe, the past makes itself heard and felt incessantly: in memories that both haunt and soothe her...in the arrival of Paul D ("There was something blessed in his manner. Women saw him and wanted to weep"), one of her fellow slaves on the farm where she had once been kept...in the vivid and painfully cathartic stories she and Paul D tell each other of their years in captivity, of their glimpses of freedom...and, most powerfully, in the apparition of Beloved, whose eyes are expressionless at their deepest point, whose doomed childhood belongs to the hideous logic of slavery and who, as daughter, sister and seductress, has now come from the "place over there" to claim retribution for what she lost and for what was taken from her. Sethes struggle to keep Beloved from gaining full possession of her present--and to throw off the long, dark legacy of her past--is at the center of this profoundly affecting and startling novel. But its intensity and resonance of feeling, and the boldness of its narrative, lift it beyond its particulars so that it speaks to our experience as an entire nation with a past of both abominable and ennobling circumstance. In Beloved, Toni Morrison has given us a great American novel. Toni Morrison was awarded the 1988 Pulitzer Prize in Literature for Beloved.	women	t
205	9789027425133	The Mammoth Hunters	Once again Jean M. Auel opens the door of a time long past to reveal an age of wonder and danger at the dawn of the modern human race. With all the consummate storytelling artistry and vivid authenticity she brought to The Clan of the Cave Bear and its sequel, The Valley of Horses, Jean M. Auel continues the breathtaking epic journey of the woman called Ayla.\n\nRiding Whinney with Jondalar, the man she loves, and followed by the mare’s colt, Ayla ventures into the land of the Mamutoi--the Mammoth Hunters. She has finally found the Others she has been seeking. Though Ayla must learn their different customs and language, she is adopted because of her remarkable hunting ability, singular healing skills, and uncanny fire-making technique. Bringing back the single pup of a lone wolf she has killed, Ayla shows the way she tames animals. She finds women friends and painful memories of the Clan she left behind, and meets Ranec, the dark-skinned, magnetic master carver of ivory, whom she cannot refuse--inciting Jondalar to a fierce jealousy that he tries to control by avoiding her. Unfamiliar with the ways of the Others, Ayla misunderstands, and thinking Jondalar no longer loves her, she turns more to Ranec. Throughout the icy winter the tension mounts, but warming weather will bring the great mammoth hunt and the mating rituals of the Summer Meeting, when Ayla must choose to remain with Ranec and the Mamutoi, or to follow Jondalar on a long journey into an unknown future.	women	t
206	9781628342383	Work	In this story of a womans search for a meaningful life, Alcott moves outside the family setting of her best knows works. Originally published in 1872, Work is both an exploration of Alcotts personal conflicts and a social critique, examining womens independence, the moral significance of labor, and the goals to which a woman can aspire. Influenced by Transcendentalism and by the womens rights movement, it affirms the possibility of a feminized utopian society.	women	t
207	9782818704097	Bridget Joness Diary	Bridget Joness Diary is a 1996 novel by Helen Fielding. Written in the form of a personal diary, the novel chronicles a year in the life of Bridget Jones, a thirty-something single working woman living in London. She writes about her career, self-image, vices, family, friends, and romantic relationships.\n\n\n----------\nAlso contained in:\n[Novels (Bridget Joness Diary / Bridget Jones - The Edge of Reason)](https://openlibrary.org/works/OL17546573W)	women	t
208	9798429685045	Whats wrong with the world	I originally called this book "What is Wrong," and it would have satisfied your sardonic temper to note the number of social misunderstandings that arose from the use of the title. Many a mild lady visitor opened her eyes when I remarked casually, I have been doing What is Wrong all this morning. And one minister of religion moved quite sharply in his chair when I told him (as he understood it) that I had to run upstairs and do what was wrong, but should be down again in a minute.	women	t
209	9781492372158	La tía Tula	Esta novela narra la vida de Gertrudis, también llamada la Tía Tula, y los sacrificios que realiza durante su vida para satisfacer sus ansias de maternidad. Una de las novelas más conocidas de Unamuno, comparte con otras de sus obras el estilo y las preocupaciones habituales del autor, aunque incluye como factor diferencial un erotismo sutil. La trama de la novela se sustenta en la práctica antropológica del levirato y el sororato en un contexto de represión sexual. Tiene como tema principal el amor maternal.	women	t
210	9780606237796	A Streetcar Named Desire	A Streetcar Named Desire is one of the most remarkable plays of our time. It created an immortal woman in the character of Blanche DuBois, the haggard and fragile southern beauty whose pathetic last grasp at happiness is cruelly destroyed. It shot Marlon Brando to fame in the role of Stanley Kowalski, a sweat-shirted barbarian, the crudely sensual brother-in-law who precipitated Blances tragedy.\n\nProduced across the world and translated into many languages, A Streetcar Named Desire has won one of the widest audiences in contemporary literature.\n\nAlso contained in:\n - [New Voices in the American Theatre](https://openlibrary.org/works/OL15163013W/New_Voices_in_the_American_Theatre)\n - [Plays 1937 - 1955](https://openlibrary.org/works/OL15077942W/Plays_1937_-_1955)	women	f
211	9780063049659	Retrato en sepia	Una obra de extraordinaria dimension humana que eleva la narrativa de la autora a cotas de perfeccion literariaNarrada en la voz de una joven mujer, esta es una magnifica novela historica, situada a finales del siglo XIX en Chile, y una portentosa saga familiar en la que reencontramos algunos personajes de Hija de la fortun a y de La casa de los espiritus, novelas cumbre en la obra de Isabel Allende. El tema principal es la memoria y los secretos de familia. La protagonista, Aurora del Valle, sufre un trauma brutal que determina su caracter y borra de su mente los primeros cinco años de su vida. Criada por su ambiciosa abuela, Paulina del Valle, crece en un ambiente privilegiado, libre de muchas de las limitaciones que oprimen a las mujeres de su epoca, pero atormentada por horribles pesadillas. Cuando debe afrontar la traicion del hombre que ama y la soledad, decide explorar el misterio de su pasado. Una obra de extraordinaria dimension humana que eleva la narrativa de la autora a cotas de perfeccion literaria.	women	t
\.


--
-- Data for Name: favorites; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.favorites (user_id, book_id, read) FROM stdin;
\.


--
-- Data for Name: reviews; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.reviews (user_id, book_id, stars, content, created_at, updated_at) FROM stdin;
1	127	5	The world felt so real, I could almost touch it.	2023-12-03 21:02:38.149345	2023-12-03 21:02:38.149345
2	204	4	A story that will linger in your thoughts. A reflective 4.	2023-12-03 21:02:38.150964	2023-12-03 21:02:38.150964
1	199	2	The pacing was off.	2023-12-03 21:02:38.152265	2023-12-03 21:02:38.152265
1	51	2	The story lacked depth.	2023-12-03 21:02:38.153387	2023-12-03 21:02:38.153387
0	14	2	The pacing was off.	2023-12-03 21:02:38.154515	2023-12-03 21:02:38.154515
2	97	4	The dialogue was sharp, but the ending was a bit abrupt. 4.	2023-12-03 21:02:38.155367	2023-12-03 21:02:38.155367
3	206	5	Couldn't put it down.	2023-12-03 21:02:38.156163	2023-12-03 21:02:38.156163
3	209	2	The characters were one-dimensional. 2.	2023-12-03 21:02:38.156942	2023-12-03 21:02:38.156942
2	82	4	A unique blend of genres.	2023-12-03 21:02:38.157725	2023-12-03 21:02:38.157725
2	88	2	I found it hard to connect with the protagonist.	2023-12-03 21:02:38.158395	2023-12-03 21:02:38.158395
0	10	1	A letdown from beginning to end.	2023-12-03 21:02:38.159027	2023-12-03 21:02:38.159027
3	12	1	A struggle to get through.	2023-12-03 21:02:38.159592	2023-12-03 21:02:38.159592
0	31	4	A roller-coaster of emotions from start to finish!	2023-12-03 21:02:38.160165	2023-12-03 21:02:38.160165
2	94	2	Didn't live up to my expectations.	2023-12-03 21:02:38.160803	2023-12-03 21:02:38.160803
0	177	4	A wild ride with unexpected twists.	2023-12-03 21:02:38.161506	2023-12-03 21:02:38.161506
1	134	4	A journey of self-discovery that touched my heart. A moving 4.	2023-12-03 21:02:38.162179	2023-12-03 21:02:38.162179
0	156	4	A roller-coaster of emotions from start to finish!	2023-12-03 21:02:38.162837	2023-12-03 21:02:38.162837
2	119	2	The characters were one-dimensional. 2.	2023-12-03 21:02:38.163475	2023-12-03 21:02:38.163475
2	110	4	The dialogue was sharp, but the ending was a bit abrupt. 4.	2023-12-03 21:02:38.16414	2023-12-03 21:02:38.16414
1	106	4	A wild ride from start to finish! A solid 4.	2023-12-03 21:02:38.164934	2023-12-03 21:02:38.164934
2	51	4	An intellectually stimulating read. A solid 4.	2023-12-03 21:02:38.165945	2023-12-03 21:02:38.165945
0	141	4	An engaging read with a surprising twist at the end.	2023-12-03 21:02:38.166966	2023-12-03 21:02:38.166966
1	65	2	The pacing was off.	2023-12-03 21:02:38.16806	2023-12-03 21:02:38.16806
1	177	2	A forgettable read.	2023-12-03 21:02:38.168912	2023-12-03 21:02:38.168912
3	1	4	A roller-coaster of emotions from start to finish!	2023-12-03 21:02:38.169661	2023-12-03 21:02:38.169661
1	103	3	I had trouble getting into the story, but it picked up later.	2023-12-03 21:02:38.170568	2023-12-03 21:02:38.170568
2	12	5	The world felt so real, I could almost touch it.	2023-12-03 21:02:38.171653	2023-12-03 21:02:38.171653
0	126	1	A struggle to stay engaged. 1 star.	2023-12-03 21:02:38.172408	2023-12-03 21:02:38.172408
1	2	4	An emotional rollercoaster that left me in tears. A poignant 4.	2023-12-03 21:02:38.173154	2023-12-03 21:02:38.173154
0	61	2	Not my cup of tea. 2.	2023-12-03 21:02:38.174098	2023-12-03 21:02:38.174098
0	155	4	The imagery was vivid, but some scenes felt rushed. 4.	2023-12-03 21:02:38.17483	2023-12-03 21:02:38.17483
0	130	4	A thought-provoking exploration of human nature.	2023-12-03 21:02:38.175522	2023-12-03 21:02:38.175522
3	136	3	The prose was exquisite, but the plot lacked depth.	2023-12-03 21:02:38.176239	2023-12-03 21:02:38.176239
2	54	3	A bit too predictable for my taste.	2023-12-03 21:02:38.176917	2023-12-03 21:02:38.176917
3	131	3	Too many loose ends.	2023-12-03 21:02:38.177638	2023-12-03 21:02:38.177638
1	48	2	A forgettable read.	2023-12-03 21:02:38.178339	2023-12-03 21:02:38.178339
0	85	5	An intricate plot with unexpected twists. A thrilling 5!	2023-12-03 21:02:38.178951	2023-12-03 21:02:38.178951
0	171	5	A story that will stay with me forever. A powerful 5!	2023-12-03 21:02:38.179585	2023-12-03 21:02:38.179585
2	68	2	Not my cup of tea. 2.	2023-12-03 21:02:38.180263	2023-12-03 21:02:38.180263
0	15	4	A roller-coaster of emotions.	2023-12-03 21:02:38.18099	2023-12-03 21:02:38.18099
2	191	1	A struggle to get through.	2023-12-03 21:02:38.181719	2023-12-03 21:02:38.181719
2	8	5	This book changed my perspective on life. A powerful 5!	2023-12-03 21:02:38.18245	2023-12-03 21:02:38.18245
2	164	2	Lacks depth and originality. 2.	2023-12-03 21:02:38.183142	2023-12-03 21:02:38.183142
3	96	3	The pacing was a bit slow for my taste, but the prose was elegant.	2023-12-03 21:02:38.183911	2023-12-03 21:02:38.183911
2	15	4	A wild ride with unexpected twists.	2023-12-03 21:02:38.184744	2023-12-03 21:02:38.184744
1	62	4	The characters were relatable, but the pacing dragged in parts.	2023-12-03 21:02:38.185637	2023-12-03 21:02:38.185637
0	22	2	Not my cup of tea. 2.	2023-12-03 21:02:38.187047	2023-12-03 21:02:38.187047
3	27	2	I found it hard to connect with the protagonist.	2023-12-03 21:02:38.18792	2023-12-03 21:02:38.18792
1	20	4	The characters were relatable, but the pacing dragged in parts.	2023-12-03 21:02:38.18869	2023-12-03 21:02:38.18869
0	165	2	The dialogue felt forced.	2023-12-03 21:02:38.189715	2023-12-03 21:02:38.189715
1	93	2	This book was not what I expected. Disappointing.	2023-12-03 21:02:38.190978	2023-12-03 21:02:38.190978
0	79	5	Unforgettable characters.	2023-12-03 21:02:38.191728	2023-12-03 21:02:38.191728
3	92	3	I had trouble getting into the story, but it picked up later.	2023-12-03 21:02:38.192716	2023-12-03 21:02:38.192716
1	149	2	I expected better. 2.	2023-12-03 21:02:38.193644	2023-12-03 21:02:38.193644
0	127	3	The world-building was on point, but the ending left me wanting more.	2023-12-03 21:02:38.194465	2023-12-03 21:02:38.194465
2	144	2	I found it hard to connect with the protagonist.	2023-12-03 21:02:38.195096	2023-12-03 21:02:38.195096
2	114	2	Boring and predictable.	2023-12-03 21:02:38.195706	2023-12-03 21:02:38.195706
3	146	4	The imagery was vivid, but some scenes felt rushed. 4.	2023-12-03 21:02:38.196281	2023-12-03 21:02:38.196281
2	11	3	The world-building was on point, but the ending left me wanting more.	2023-12-03 21:02:38.196976	2023-12-03 21:02:38.196976
2	80	2	This book was not what I expected. Disappointing.	2023-12-03 21:02:38.197571	2023-12-03 21:02:38.197571
2	52	2	Didn't live up to my expectations.	2023-12-03 21:02:38.1982	2023-12-03 21:02:38.1982
0	55	4	An emotional rollercoaster that left me in tears. A poignant 4.	2023-12-03 21:02:38.198811	2023-12-03 21:02:38.198811
3	142	2	This book was not what I expected. Disappointing.	2023-12-03 21:02:38.1994	2023-12-03 21:02:38.1994
2	50	3	Beautiful prose, weak storyline.	2023-12-03 21:02:38.199967	2023-12-03 21:02:38.199967
1	19	2	Couldn't connect with the protagonist.	2023-12-03 21:02:38.200531	2023-12-03 21:02:38.200531
1	173	4	The dialogue was sharp, but the ending was a bit abrupt. 4.	2023-12-03 21:02:38.201093	2023-12-03 21:02:38.201093
3	139	4	An emotional rollercoaster that left me in tears. A poignant 4.	2023-12-03 21:02:38.201656	2023-12-03 21:02:38.201656
2	34	2	I couldn't connect with the story.	2023-12-03 21:02:38.202263	2023-12-03 21:02:38.202263
2	129	5	Couldn't put it down.	2023-12-03 21:02:38.202992	2023-12-03 21:02:38.202992
0	135	1	A letdown. 1 star.	2023-12-03 21:02:38.203855	2023-12-03 21:02:38.203855
0	201	2	The writing didn't engage me.	2023-12-03 21:02:38.204487	2023-12-03 21:02:38.204487
0	119	1	Lacked originality and creativity. 1 star.	2023-12-03 21:02:38.205026	2023-12-03 21:02:38.205026
1	16	2	Disappointing ending.	2023-12-03 21:02:38.20559	2023-12-03 21:02:38.20559
1	74	2	The plot was unconvincing. 2.	2023-12-03 21:02:38.206223	2023-12-03 21:02:38.206223
3	108	4	A poignant exploration of the human condition. A solid 4.	2023-12-03 21:02:38.206938	2023-12-03 21:02:38.206938
2	24	3	Engaging characters, but a weak plot.	2023-12-03 21:02:38.207593	2023-12-03 21:02:38.207593
3	188	3	The world-building was on point, but the ending left me wanting more.	2023-12-03 21:02:38.208256	2023-12-03 21:02:38.208256
1	135	3	The dialogue felt a bit forced, but the setting was vividly portrayed.	2023-12-03 21:02:38.208863	2023-12-03 21:02:38.208863
3	101	2	The plot was unconvincing. 2.	2023-12-03 21:02:38.209427	2023-12-03 21:02:38.209427
3	147	5	The world felt so real, I could almost touch it.	2023-12-03 21:02:38.210002	2023-12-03 21:02:38.210002
0	136	3	I couldn't connect with the characters, but the world-building was exceptional.	2023-12-03 21:02:38.210542	2023-12-03 21:02:38.210542
1	39	2	This book was not what I expected. Disappointing.	2023-12-03 21:02:38.211055	2023-12-03 21:02:38.211055
3	128	3	The pacing was a bit slow for my taste, but the prose was elegant.	2023-12-03 21:02:38.211758	2023-12-03 21:02:38.211758
3	52	2	I found it hard to connect with the protagonist.	2023-12-03 21:02:38.212327	2023-12-03 21:02:38.212327
1	140	4	A complex and intricate world.	2023-12-03 21:02:38.213021	2023-12-03 21:02:38.213021
3	114	1	I couldn't get into it.	2023-12-03 21:02:38.214095	2023-12-03 21:02:38.214095
3	204	3	Beautiful prose, weak storyline.	2023-12-03 21:02:38.214971	2023-12-03 21:02:38.214971
0	182	5	A story that will stay with me forever. A powerful 5!	2023-12-03 21:02:38.215757	2023-12-03 21:02:38.215757
0	183	3	The prose was exquisite, but the plot lacked depth.	2023-12-03 21:02:38.216604	2023-12-03 21:02:38.216604
0	203	2	Boring and predictable.	2023-12-03 21:02:38.217421	2023-12-03 21:02:38.217421
2	167	5	The author's descriptive style painted vivid pictures in my mind.	2023-12-03 21:02:38.218272	2023-12-03 21:02:38.218272
2	171	3	I couldn't connect with the characters, but the world-building was exceptional.	2023-12-03 21:02:38.219099	2023-12-03 21:02:38.219099
0	142	1	A struggle to get through.	2023-12-03 21:02:38.220053	2023-12-03 21:02:38.220053
2	45	2	The dialogue felt forced.	2023-12-03 21:02:38.220853	2023-12-03 21:02:38.220853
2	198	4	A roller-coaster of emotions.	2023-12-03 21:02:38.221467	2023-12-03 21:02:38.221467
3	79	3	The world-building was on point, but the ending left me wanting more.	2023-12-03 21:02:38.222202	2023-12-03 21:02:38.222202
2	32	2	Unmemorable and forgettable.	2023-12-03 21:02:38.223001	2023-12-03 21:02:38.223001
0	129	5	An absolute page-turner that left me wanting more.	2023-12-03 21:02:38.2238	2023-12-03 21:02:38.2238
3	60	2	I expected better. 2.	2023-12-03 21:02:38.224544	2023-12-03 21:02:38.224544
0	6	3	I had trouble getting into the story, but it picked up later.	2023-12-03 21:02:38.225252	2023-12-03 21:02:38.225252
\.


--
-- Data for Name: sessions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sessions (user_id) FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (user_id, username, password) FROM stdin;
0	feras	password
1	trevor	password
2	david	password
3	dave	password
\.


--
-- Name: authors_author_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.authors_author_id_seq', 211, true);


--
-- Name: books_book_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.books_book_id_seq', 211, true);


--
-- Name: users_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_user_id_seq', 3, true);


--
-- Name: authors authors_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.authors
    ADD CONSTRAINT authors_pkey PRIMARY KEY (author_id);


--
-- Name: book_author book_author_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.book_author
    ADD CONSTRAINT book_author_pkey PRIMARY KEY (book_id, author);


--
-- Name: books books_isbn_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.books
    ADD CONSTRAINT books_isbn_key UNIQUE (isbn);


--
-- Name: books books_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.books
    ADD CONSTRAINT books_pkey PRIMARY KEY (book_id);


--
-- Name: favorites favorites_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.favorites
    ADD CONSTRAINT favorites_pkey PRIMARY KEY (user_id, book_id);


--
-- Name: reviews reviews_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT reviews_pkey PRIMARY KEY (user_id, book_id);


--
-- Name: sessions sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (user_id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);


--
-- Name: users users_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key UNIQUE (username);


--
-- Name: reviews update_review; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_review BEFORE UPDATE ON public.reviews FOR EACH ROW EXECUTE FUNCTION public.update_updated_at();


--
-- Name: book_author book_author_author_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.book_author
    ADD CONSTRAINT book_author_author_fkey FOREIGN KEY (author) REFERENCES public.authors(author_id);


--
-- Name: book_author book_author_book_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.book_author
    ADD CONSTRAINT book_author_book_id_fkey FOREIGN KEY (book_id) REFERENCES public.books(book_id);


--
-- Name: favorites favorites_book_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.favorites
    ADD CONSTRAINT favorites_book_id_fkey FOREIGN KEY (book_id) REFERENCES public.books(book_id);


--
-- Name: favorites favorites_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.favorites
    ADD CONSTRAINT favorites_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- Name: reviews reviews_book_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT reviews_book_id_fkey FOREIGN KEY (book_id) REFERENCES public.books(book_id);


--
-- Name: reviews reviews_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT reviews_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- Name: sessions sessions_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT sessions_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

