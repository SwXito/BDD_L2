--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.19
-- Dumped by pg_dump version 9.6.17

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

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: animal; Type: TABLE; Schema: public; Owner: damien.touati
--

CREATE TABLE public.animal (
    id_animal integer NOT NULL,
    espece character varying(30) NOT NULL,
    nom character varying(25) NOT NULL,
    age integer NOT NULL,
    sexe character(1) NOT NULL,
    signe_distinctif character varying(30),
    id_refuge integer,
    tel_particulier character varying(12),
    date_adoption date
);


--
-- Name: animal_id_animal_seq; Type: SEQUENCE; Schema: public; Owner: damien.touati
--

CREATE SEQUENCE public.animal_id_animal_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: animal_id_animal_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: damien.touati
--

ALTER SEQUENCE public.animal_id_animal_seq OWNED BY public.animal.id_animal;


--
-- Name: employe; Type: TABLE; Schema: public; Owner: damien.touati
--

CREATE TABLE public.employe (
    matricule character varying(10) NOT NULL,
    nom character varying(25) NOT NULL,
    prenom character varying(25) NOT NULL,
    adresse character varying(100) NOT NULL,
    tel character varying(12) NOT NULL,
    numsc character varying(15) NOT NULL,
    datearriver date NOT NULL,
    login_c character varying(16) NOT NULL,
    mdp character varying(100) NOT NULL
);



--
-- Name: historique; Type: TABLE; Schema: public; Owner: damien.touati
--

CREATE TABLE public.historique (
    id_refuge integer NOT NULL,
    id_animal integer NOT NULL,
    date_arrivee date NOT NULL,
    date_depart date
);



--
-- Name: particulier; Type: TABLE; Schema: public; Owner: damien.touati
--

CREATE TABLE public.particulier (
    telephone character varying(12) NOT NULL,
    nom character varying(25) NOT NULL,
    prenom character varying(25) NOT NULL,
    adresse character varying(100) NOT NULL
);


--
-- Name: refuge; Type: TABLE; Schema: public; Owner: damien.touati
--

CREATE TABLE public.refuge (
    id_refuge integer NOT NULL,
    nom character varying(25) NOT NULL,
    adresse character varying(100) NOT NULL,
    tel character varying(12) NOT NULL,
    capacite integer NOT NULL,
    matricule character varying(10)
);


--
-- Name: refuge_id_refuge_seq; Type: SEQUENCE; Schema: public; Owner: damien.touati
--

CREATE SEQUENCE public.refuge_id_refuge_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: refuge_id_refuge_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: damien.touati
--

ALTER SEQUENCE public.refuge_id_refuge_seq OWNED BY public.refuge.id_refuge;


--
-- Name: soigne; Type: TABLE; Schema: public; Owner: damien.touati
--

CREATE TABLE public.soigne (
    id_soin integer NOT NULL,
    id_animal integer NOT NULL
);



--
-- Name: soin; Type: TABLE; Schema: public; Owner: damien.touati
--

CREATE TABLE public.soin (
    id_soin integer NOT NULL,
    nom_soin character varying(20),
    type_s character varying(30) NOT NULL,
    date_s date,
    matricule character varying(10),
    delai_rappel date
);


--
-- Name: soin_id_soin_seq; Type: SEQUENCE; Schema: public; Owner: damien.touati
--

CREATE SEQUENCE public.soin_id_soin_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
-- Name: soin_id_soin_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: damien.touati
--

ALTER SEQUENCE public.soin_id_soin_seq OWNED BY public.soin.id_soin;


--
-- Name: travail; Type: TABLE; Schema: public; Owner: damien.touati
--

CREATE TABLE public.travail (
    matricule character varying(10) NOT NULL,
    id_refuge integer NOT NULL,
    fonction character varying(20)
);



--
-- Name: vaccination; Type: VIEW; Schema: public; Owner: damien.touati
--

CREATE VIEW public.vaccination AS
 SELECT soigne.id_animal,
    soin.nom_soin
   FROM (public.soin
     JOIN public.soigne USING (id_soin))
  WHERE (soin.delai_rappel < date(now()));



--
-- Name: verification; Type: VIEW; Schema: public; Owner: damien.touati
--

CREATE VIEW public.verification AS
 SELECT historique.id_refuge,
    count(historique.date_depart) AS count
   FROM public.historique
  WHERE (historique.date_depart > '2022-01-01'::date)
  GROUP BY historique.id_refuge
  ORDER BY (count(historique.date_depart)) DESC
 LIMIT 5;



--
-- Name: animal id_animal; Type: DEFAULT; Schema: public; Owner: damien.touati
--

ALTER TABLE ONLY public.animal ALTER COLUMN id_animal SET DEFAULT nextval('public.animal_id_animal_seq'::regclass);


--
-- Name: refuge id_refuge; Type: DEFAULT; Schema: public; Owner: damien.touati
--

ALTER TABLE ONLY public.refuge ALTER COLUMN id_refuge SET DEFAULT nextval('public.refuge_id_refuge_seq'::regclass);


--
-- Name: soin id_soin; Type: DEFAULT; Schema: public; Owner: damien.touati
--

ALTER TABLE ONLY public.soin ALTER COLUMN id_soin SET DEFAULT nextval('public.soin_id_soin_seq'::regclass);


--
-- Data for Name: animal; Type: TABLE DATA; Schema: public; Owner: damien.touati
--

INSERT INTO public.animal VALUES (0, 'chien', 'Babouche', 6, 'M', 'marque sous le menton', 1, NULL, NULL);
INSERT INTO public.animal VALUES (1, 'chat', 'Minou', 4, 'M', 'oreille tordue', 0, NULL, NULL);
INSERT INTO public.animal VALUES (2, 'chat', 'Maxou', 8, 'M', NULL, 4, NULL, NULL);
INSERT INTO public.animal VALUES (3, 'lapin', 'Pidi', 8, 'F', NULL, 3, NULL, NULL);
INSERT INTO public.animal VALUES (4, 'chien', 'Lili', 3, 'F', NULL, 1, NULL, NULL);
INSERT INTO public.animal VALUES (5, 'chat', 'Miaous', 4, 'M', NULL, 0, NULL, NULL);
INSERT INTO public.animal VALUES (6, 'chien', 'Fares', 19, 'M', NULL, 0, NULL, NULL);


--
-- Name: animal_id_animal_seq; Type: SEQUENCE SET; Schema: public; Owner: damien.touati
--

SELECT pg_catalog.setval('public.animal_id_animal_seq', 1, false);


--
-- Data for Name: employe; Type: TABLE DATA; Schema: public; Owner: damien.touati
--

INSERT INTO public.employe VALUES ('03271FGH', 'Dindon', 'Didier', '70 Boulevard de la Place', '0673813900', '170042531111426', '2022-02-27', 'jesuisunlogin', '$2b$12$VoVRwbqlAME9P69gmNbbre6C.i7mNg.dOcsdq94JFtcYaio3587o2');
INSERT INTO public.employe VALUES ('1234567P', 'Tenko', 'Shimura', '16 rue de la Republique', '0673813900', '170042532222426', '2015-02-12', 'mob', '$2b$12$CbocoGI4/f.tewb/f6CV2uhRyU5RgNGJSIQXT5VaRCS.8OXYxB2w6');
INSERT INTO public.employe VALUES ('1233309A', 'Lionel', 'Messi', '1 rue de la coupe du monde', '0673813900', '160042531114426', '2010-11-11', 'a', '$2b$12$dymUKc0/JfBunz7ZklmhLuAfrBc10R7q332uWub.6cPgtJzCnXOeG');
INSERT INTO public.employe VALUES ('AX13FIZ', 'Loupio', 'Fares', '178 rue du Caloupix', '0655555500', '170042533333426', '2020-01-01', 'ok', '$2b$12$24fxHesmTMveYOH0j4/Gk.NwjJHArsE9PQinzCvH5X53HHeUxgH5u');


--
-- Data for Name: historique; Type: TABLE DATA; Schema: public; Owner: damien.touati
--

INSERT INTO public.historique VALUES (4, 2, '2022-06-23', NULL);
INSERT INTO public.historique VALUES (0, 5, '2022-02-10', NULL);
INSERT INTO public.historique VALUES (0, 4, '2021-10-21', NULL);
INSERT INTO public.historique VALUES (1, 3, '2022-08-09', NULL);
INSERT INTO public.historique VALUES (2, 2, '2022-11-01', NULL);
INSERT INTO public.historique VALUES (3, 0, '2022-03-06', NULL);
INSERT INTO public.historique VALUES (6, 1, '2022-04-10', NULL);
INSERT INTO public.historique VALUES (5, 2, '2022-04-10', '2022-02-10');
INSERT INTO public.historique VALUES (4, 5, '2022-06-02', '2022-06-24');
INSERT INTO public.historique VALUES (5, 4, '2021-10-01', '2021-10-21');
INSERT INTO public.historique VALUES (0, 3, '2022-07-11', '2022-08-09');
INSERT INTO public.historique VALUES (1, 2, '2022-10-01', '2022-11-01');
INSERT INTO public.historique VALUES (2, 0, '2022-02-06', '2022-03-06');
INSERT INTO public.historique VALUES (5, 1, '2022-01-10', '2022-04-10');


--
-- Data for Name: particulier; Type: TABLE DATA; Schema: public; Owner: damien.touati
--

INSERT INTO public.particulier VALUES ('0612345678', 'Maximilien', 'Maxime', '34 rue de la pétanque');


--
-- Data for Name: refuge; Type: TABLE DATA; Schema: public; Owner: damien.touati
--

INSERT INTO public.refuge VALUES (0, 'Aide animal', '23 rue de James Bond', '061372189', 30, NULL);
INSERT INTO public.refuge VALUES (1, 'Animal Crossing', '1 rue de Jupiter', '0644621367', 50, NULL);
INSERT INTO public.refuge VALUES (2, 'Exopose', '5 Rue d Apollon', '0637848281', 20, NULL);
INSERT INTO public.refuge VALUES (3, 'Pas indifférent', '10 Voie des Bijoux', '0613746784', 60, NULL);
INSERT INTO public.refuge VALUES (4, 'Tous Ensemble', '42 Voie de la Cloche', '0699382999', 10, NULL);
INSERT INTO public.refuge VALUES (5, 'Mille merci', '7 Rue de Mugissement', '0611111111', 100, NULL);
INSERT INTO public.refuge VALUES (6, 'Animal se sent mal', '2 Boulevard du Soleil', '0666666666', 70, NULL);
INSERT INTO public.refuge VALUES (7, 'Ne pas abandonner', '20 Chemin des Gemmes', '0688773344', 40, NULL);


--
-- Name: refuge_id_refuge_seq; Type: SEQUENCE SET; Schema: public; Owner: damien.touati
--

SELECT pg_catalog.setval('public.refuge_id_refuge_seq', 1, false);


--
-- Data for Name: soigne; Type: TABLE DATA; Schema: public; Owner: damien.touati
--

INSERT INTO public.soigne VALUES (0, 3);
INSERT INTO public.soigne VALUES (1, 2);
INSERT INTO public.soigne VALUES (2, 6);
INSERT INTO public.soigne VALUES (3, 6);
INSERT INTO public.soigne VALUES (4, 6);


--
-- Data for Name: soin; Type: TABLE DATA; Schema: public; Owner: damien.touati
--

INSERT INTO public.soin VALUES (0, 'CeciEstUnNom', 'vaccin', '2022-06-20', '03271FGH', '2023-10-23');
INSERT INTO public.soin VALUES (1, 'voila', 'vaccin', '2020-06-20', '03271FGH', '2021-10-23');
INSERT INTO public.soin VALUES (2, 'hydratation', 'important', '2022-11-19', 'AX13FIZ');
INSERT INTO public.soin VALUES (3, 'CANIGEN CHPPi/LR', 'vaccin', '2022-07-11', '03271FGH', '2023-07-11');
INSERT INTO public.soin VALUES (4, 'Imovax Rage', 'vaccin', '2020-11-11', 'AX13FIZ', '2022-07-11');



--
-- Name: soin_id_soin_seq; Type: SEQUENCE SET; Schema: public; Owner: damien.touati
--

SELECT pg_catalog.setval('public.soin_id_soin_seq', 1, false);


--
-- Data for Name: travail; Type: TABLE DATA; Schema: public; Owner: damien.touati
--

INSERT INTO public.travail VALUES ('03271FGH', 0, 'secrétaire');
INSERT INTO public.travail VALUES ('1233309A', 0, 'assistant');
INSERT INTO public.travail VALUES ('1234567P', 0, 'aide soignant');
INSERT INTO public.travail VALUES ('1233309A', 1, 'médecin');
INSERT INTO public.travail VALUES ('AX13FIZ', 0, 'médecin');


--
-- Name: animal animal_pkey; Type: CONSTRAINT; Schema: public; Owner: damien.touati
--

ALTER TABLE ONLY public.animal
    ADD CONSTRAINT animal_pkey PRIMARY KEY (id_animal);


--
-- Name: employe employe_login_c_key; Type: CONSTRAINT; Schema: public; Owner: damien.touati
--

ALTER TABLE ONLY public.employe
    ADD CONSTRAINT employe_login_c_key UNIQUE (login_c);


--
-- Name: employe employe_numsc_key; Type: CONSTRAINT; Schema: public; Owner: damien.touati
--

ALTER TABLE ONLY public.employe
    ADD CONSTRAINT employe_numsc_key UNIQUE (numsc);


--
-- Name: employe employe_pkey; Type: CONSTRAINT; Schema: public; Owner: damien.touati
--

ALTER TABLE ONLY public.employe
    ADD CONSTRAINT employe_pkey PRIMARY KEY (matricule);


--
-- Name: employe employe_tel_key; Type: CONSTRAINT; Schema: public; Owner: damien.touati
--

ALTER TABLE ONLY public.employe
    ADD CONSTRAINT employe_tel_key UNIQUE (tel);


--
-- Name: travail employe_travail; Type: CONSTRAINT; Schema: public; Owner: damien.touati
--

ALTER TABLE ONLY public.travail
    ADD CONSTRAINT employe_travail PRIMARY KEY (matricule, id_refuge);


--
-- Name: historique histo; Type: CONSTRAINT; Schema: public; Owner: damien.touati
--

ALTER TABLE ONLY public.historique
    ADD CONSTRAINT histo PRIMARY KEY (id_refuge, id_animal, date_arrivee);


--
-- Name: particulier particulier_pkey; Type: CONSTRAINT; Schema: public; Owner: damien.touati
--

ALTER TABLE ONLY public.particulier
    ADD CONSTRAINT particulier_pkey PRIMARY KEY (telephone);


--
-- Name: refuge refuge_nom_key; Type: CONSTRAINT; Schema: public; Owner: damien.touati
--

ALTER TABLE ONLY public.refuge
    ADD CONSTRAINT refuge_nom_key UNIQUE (nom);


--
-- Name: refuge refuge_pkey; Type: CONSTRAINT; Schema: public; Owner: damien.touati
--

ALTER TABLE ONLY public.refuge
    ADD CONSTRAINT refuge_pkey PRIMARY KEY (id_refuge);


--
-- Name: refuge refuge_tel_key; Type: CONSTRAINT; Schema: public; Owner: damien.touati
--

ALTER TABLE ONLY public.refuge
    ADD CONSTRAINT refuge_tel_key UNIQUE (tel);


--
-- Name: soigne soigneanimal; Type: CONSTRAINT; Schema: public; Owner: damien.touati
--

ALTER TABLE ONLY public.soigne
    ADD CONSTRAINT soigneanimal PRIMARY KEY (id_soin, id_animal);


--
-- Name: soin soin_pkey; Type: CONSTRAINT; Schema: public; Owner: damien.touati
--

ALTER TABLE ONLY public.soin
    ADD CONSTRAINT soin_pkey PRIMARY KEY (id_soin);


--
-- Name: employe uniquenomprenom; Type: CONSTRAINT; Schema: public; Owner: damien.touati
--

ALTER TABLE ONLY public.employe
    ADD CONSTRAINT uniquenomprenom UNIQUE (nom, prenom);


--
-- Name: animal animal_id_refuge_fkey; Type: FK CONSTRAINT; Schema: public; Owner: damien.touati
--

ALTER TABLE ONLY public.animal
    ADD CONSTRAINT animal_id_refuge_fkey FOREIGN KEY (id_refuge) REFERENCES public.refuge(id_refuge) ON UPDATE CASCADE;


--
-- Name: refuge refuge_matricule_fkey; Type: FK CONSTRAINT; Schema: public; Owner: damien.touati
--

ALTER TABLE ONLY public.refuge
    ADD CONSTRAINT refuge_matricule_fkey FOREIGN KEY (matricule) REFERENCES public.employe(matricule) ON UPDATE CASCADE;


--
-- Name: soin soin_matricule_fkey; Type: FK CONSTRAINT; Schema: public; Owner: damien.touati
--

ALTER TABLE ONLY public.soin
    ADD CONSTRAINT soin_matricule_fkey FOREIGN KEY (matricule) REFERENCES public.employe(matricule) ON UPDATE CASCADE;


--
-- Name: travail travail_id_refuge_fkey; Type: FK CONSTRAINT; Schema: public; Owner: damien.touati
--

ALTER TABLE ONLY public.travail
    ADD CONSTRAINT travail_id_refuge_fkey FOREIGN KEY (id_refuge) REFERENCES public.refuge(id_refuge) ON UPDATE CASCADE;


--
-- Name: travail travail_matricule_fkey; Type: FK CONSTRAINT; Schema: public; Owner: damien.touati
--

ALTER TABLE ONLY public.travail
    ADD CONSTRAINT travail_matricule_fkey FOREIGN KEY (matricule) REFERENCES public.employe(matricule) ON UPDATE CASCADE;


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

