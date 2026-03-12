-- Base de données S314 Clubmed
DROP TABLE IF EXISTS activite CASCADE;
DROP TABLE IF EXISTS activiteadulte CASCADE;
DROP TABLE IF EXISTS activiteenfant CASCADE;
DROP TABLE IF EXISTS adresse CASCADE;
DROP TABLE IF EXISTS type_chambre_sdb CASCADE;
DROP TABLE IF EXISTS autrevoyageur CASCADE;
DROP TABLE IF EXISTS avis CASCADE;
DROP TABLE IF EXISTS calendrier CASCADE;
DROP TABLE IF EXISTS categorie CASCADE;
DROP TABLE IF EXISTS chambre CASCADE;
DROP TABLE IF EXISTS client CASCADE;
DROP TABLE IF EXISTS club CASCADE;
DROP TABLE IF EXISTS clubstation CASCADE;
DROP TABLE IF EXISTS club_categorie CASCADE;
DROP TABLE IF EXISTS club_regroupement CASCADE;
DROP TABLE IF EXISTS date_calendrier CASCADE;
DROP TABLE IF EXISTS disponibilite CASCADE;
DROP TABLE IF EXISTS equipement CASCADE;
DROP TABLE IF EXISTS equipementsalledebain CASCADE;
DROP TABLE IF EXISTS failed_jobs CASCADE;
DROP TABLE IF EXISTS club_restauration CASCADE;
DROP TABLE IF EXISTS categorie_localisation CASCADE;
DROP TABLE IF EXISTS icon CASCADE;
DROP TABLE IF EXISTS club_activite CASCADE;
DROP TABLE IF EXISTS lieurestauration CASCADE;
DROP TABLE IF EXISTS localisation CASCADE;
DROP TABLE IF EXISTS migrations CASCADE;
DROP TABLE IF EXISTS partenaires CASCADE;
DROP TABLE IF EXISTS password_reset_tokens CASCADE;
DROP TABLE IF EXISTS periode CASCADE;
DROP TABLE IF EXISTS personal_access_tokens CASCADE;
DROP TABLE IF EXISTS photo CASCADE;
DROP TABLE IF EXISTS photo_club CASCADE;
DROP TABLE IF EXISTS photoavis CASCADE;
DROP TABLE IF EXISTS pointfort CASCADE;
DROP TABLE IF EXISTS prix_periode CASCADE;
DROP TABLE IF EXISTS regroupement CASCADE;
DROP TABLE IF EXISTS reservation CASCADE;
DROP TABLE IF EXISTS pays_region CASCADE;
DROP TABLE IF EXISTS categorie_type_club CASCADE;
DROP TABLE IF EXISTS type_chambre_service CASCADE;
DROP TABLE IF EXISTS club_chambre CASCADE;
DROP TABLE IF EXISTS reservation_activite CASCADE;
DROP TABLE IF EXISTS type_chambre_equipement CASCADE;
DROP TABLE IF EXISTS service CASCADE;
DROP TABLE IF EXISTS souslocalisation CASCADE;
DROP TABLE IF EXISTS station CASCADE;
DROP TABLE IF EXISTS subscription_items CASCADE;
DROP TABLE IF EXISTS subscriptions CASCADE;
DROP TABLE IF EXISTS type_chambre_pointfort CASCADE;
DROP TABLE IF EXISTS trancheage CASCADE;
DROP TABLE IF EXISTS transaction CASCADE;
DROP TABLE IF EXISTS transport CASCADE;
DROP TABLE IF EXISTS typeactivite CASCADE;
DROP TABLE IF EXISTS typechambre CASCADE;
DROP TABLE IF EXISTS typeclub CASCADE;
DROP TABLE IF EXISTS utilisateur CASCADE;

DROP SEQUENCE IF EXISTS reservation_numreservation_seq CASCADE;
DROP SEQUENCE IF EXISTS client_numclient_seq CASCADE;
DROP SEQUENCE IF EXISTS failed_jobs_id_seq CASCADE;
DROP SEQUENCE IF EXISTS migrations_id_seq CASCADE;
DROP SEQUENCE IF EXISTS partenaires_idpartenaire_seq CASCADE;
DROP SEQUENCE IF EXISTS personal_access_tokens_id_seq CASCADE;
DROP SEQUENCE IF EXISTS subscription_items_id_seq CASCADE;
DROP SEQUENCE IF EXISTS subscriptions_id_seq CASCADE;
DROP SEQUENCE IF EXISTS transaction_idtransaction_seq CASCADE;
DROP SEQUENCE IF EXISTS utilisateur_idutilisateur_seq CASCADE;

DROP VIEW IF EXISTS v_bi_analyse_ventes_resort;
DROP VIEW IF EXISTS v_suivi_ventes_global;
DROP VIEW IF EXISTS v_clubs_en_creation;

DROP TRIGGER IF EXISTS trg_update_club_rating ON avis;
DROP TRIGGER IF EXISTS trg_validate_reservation_dates ON reservation;

DROP FUNCTION IF EXISTS update_notemoyenne_club;
DROP FUNCTION IF EXISTS check_dates_coherence;

DROP PROCEDURE IF EXISTS creer_reservation;
DROP PROCEDURE IF EXISTS annuler_reservation;
DROP PROCEDURE IF EXISTS creer_club;

DROP INDEX IF EXISTS idx_reservation_client;
DROP INDEX IF EXISTS idx_reservation_dates;
DROP INDEX IF EXISTS idx_avis_club;
DROP INDEX IF EXISTS idx_club_titre;

--  Création des tables

-- Table: activite
create table activite (
   idactivite int4 not null,
   titre varchar(1024) null,
   description varchar(1024) not null,
   prixmin decimal not null,
   idpartenaire integer,
   constraint pk_activite primary key (idactivite)
);

-- Table: activiteadulte
CREATE TABLE activiteadulte (
    idactivite integer NOT NULL,
    numtypeactivite integer NOT NULL,
    titre character varying(1024),
    description character varying(1024) NOT NULL,
    prixmin numeric NOT NULL,
    duree numeric NOT NULL,
    ageminimum integer NOT NULL,
    frequence character varying(1024) NOT NULL
);

-- Table: activiteenfant
CREATE TABLE activiteenfant (
    idactivite integer NOT NULL,
    numtranche integer NOT NULL,
    titre character varying(1024) NOT NULL,
    description character varying(1024) NOT NULL,
    prixmin numeric NOT NULL,
    detail character varying(1024) NOT NULL
);

-- Table: adresse
CREATE TABLE adresse (
    numadresse integer NOT NULL,
    numrue integer NOT NULL,
    nomrue character varying(1024) NOT NULL,
    codepostal character varying(5) NOT NULL,
    ville character varying(1024) NOT NULL,
    pays character varying(1024) NOT NULL
);

-- Table: type_chambre_sdb
CREATE TABLE type_chambre_sdb (
    numequipementsallebain integer NOT NULL,
    idtypechambre integer NOT NULL
);

-- Table: autrevoyageur 
CREATE TABLE autrevoyageur (
    numvoyageur integer NOT NULL,
    numreservation integer NOT NULL,
    genre character varying(1024),
    prenom character varying(1024),
    nom character varying(1024),
    datenaissance date
);

-- Table: avis 
CREATE TABLE avis (
    numavis integer NOT NULL,
    idclub integer NOT NULL,
    numclient integer NOT NULL,
    titre character varying(1024),
    commentaire character varying(1024) NOT NULL,
    note integer NOT NULL,
    numreservation integer NOT NULL,
    reponse character varying(1024)
);

-- Table: calendrier
CREATE TABLE calendrier (
    date date NOT NULL
);

-- Table: categorie
CREATE TABLE categorie (
    numcategory integer NOT NULL,
    nomcategory character varying(1024)
);

-- Table: chambre
CREATE TABLE chambre (
    numchambre integer NOT NULL,
    idtypechambre integer NOT NULL
);

-- Table: client
CREATE TABLE client (
    numclient integer NOT NULL,
    numadresse integer,
    genre character varying(1024),
    prenom character varying(1024) NOT NULL,
    nom character varying(1024) NOT NULL,
    datenaissance date,
    email character varying(1024) NOT NULL,
    telephone character varying(1024),
    motdepasse_crypter character varying(1024) NOT NULL,
    role character varying(20) DEFAULT 'client'::character varying,
    a2f_active boolean DEFAULT false,
    stripe_id character varying(255),
    pm_type character varying(255),
    pm_last_four character varying(4),
    trial_ends_at timestamp(0) without time zone,
    CONSTRAINT ck_email CHECK (((email)::text ~~ '%_@_%._%'::text))
);

-- Table: club
CREATE TABLE club (
    idclub integer NOT NULL,
    numphoto integer NOT NULL,
    titre character varying(1024),
    description character varying(1024),
    notemoyenne numeric,
    lienpdf character varying(1024),
    numpays integer,
    email character varying(255),
    statut_mise_en_ligne character varying(50) DEFAULT 'EN_CREATION'::character varying
);

-- Table: clubstation
CREATE TABLE clubstation (
    idclub integer NOT NULL,
    numstation integer NOT NULL,
    numphoto integer,
    titre character varying(1024),
    description character varying(1024) NOT NULL,
    notemoyenne numeric,
    lienpdf character varying(1024),
    altitudeclub character(10) NOT NULL
);

-- Table: club_categorie
CREATE TABLE club_categorie (
    idclub integer NOT NULL,
    numcategory integer NOT NULL
);

-- Table: club_regroupement
CREATE TABLE club_regroupement (
    idclub integer NOT NULL,
    numregroupement integer NOT NULL
);

-- Table: date_calendrier
CREATE TABLE date_calendrier (
    jour date NOT NULL
);

-- Table: disponibilite
CREATE TABLE disponibilite (
    date date NOT NULL,
    numchambre integer NOT NULL,
    idclub integer NOT NULL,
    estdisponibilite boolean
);

-- Table: equipement
CREATE TABLE equipement (
    numequipement integer NOT NULL,
    numicon integer NOT NULL,
    nom character varying(1024)
);

-- Table: equipementsalledebain
CREATE TABLE equipementsalledebain (
    numequipementsallebain integer NOT NULL,
    nom character varying(1024)
);

-- Table: failed_jobs
CREATE TABLE failed_jobs (
    id bigint NOT NULL,
    uuid character varying(255) NOT NULL,
    connection text NOT NULL,
    queue text NOT NULL,
    payload text NOT NULL,
    exception text NOT NULL,
    failed_at timestamp(0) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);

-- Table: club_restauration
CREATE TABLE club_restauration (
    idclub integer NOT NULL,
    numrestauration integer NOT NULL
);

-- Table: categorie_localisation
CREATE TABLE categorie_localisation (
    numcategory integer NOT NULL,
    numlocalisation integer NOT NULL
);

-- Table: icon
CREATE TABLE icon (
    numicon integer NOT NULL,
    numpointfort integer NOT NULL,
    numservice integer NOT NULL,
    numequipementsallebain integer NOT NULL,
    lienicon character varying(1024)
);

-- Table: club_activite
CREATE TABLE club_activite (
    idclub integer NOT NULL,
    idactivite integer NOT NULL
);

-- Table: lieurestauration
CREATE TABLE lieurestauration (
    numrestauration integer NOT NULL,
    numphoto integer NOT NULL,
    presentation character varying(1024),
    nom character varying(1024) NOT NULL,
    description character varying(1024) NOT NULL,
    estbar boolean
);

-- Table: localisation
CREATE TABLE localisation (
    numlocalisation integer NOT NULL,
    nomlocalisation character varying(1024)
);

-- Table: migrations
CREATE TABLE migrations (
    id integer NOT NULL,
    migration character varying(255) NOT NULL,
    batch integer NOT NULL
);

-- Table: partenaires
CREATE TABLE partenaires (
    idpartenaire integer NOT NULL,
    nom character varying(255) NOT NULL,
    email character varying(255),
    telephone character varying(50)
);

-- Table: password_reset_tokens
CREATE TABLE password_reset_tokens (
    email character varying(255) NOT NULL,
    token character varying(255) NOT NULL,
    created_at timestamp(0) without time zone
);

-- Table: periode
CREATE TABLE periode (
    numperiode character(10) NOT NULL,
    datedeb date,
    datefin date
);

-- Table: personal_access_tokens
CREATE TABLE personal_access_tokens (
    id bigint NOT NULL,
    tokenable_type character varying(255) NOT NULL,
    tokenable_id bigint NOT NULL,
    name character varying(255) NOT NULL,
    token character varying(64) NOT NULL,
    abilities text,
    last_used_at timestamp(0) without time zone,
    expires_at timestamp(0) without time zone,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);

-- Table: photo
CREATE TABLE photo (
    numphoto integer NOT NULL,
    url character varying(1024)
);

-- Table: photo_club
CREATE TABLE photo_club (
    idclub integer NOT NULL,
    numphoto integer NOT NULL,
    ordre integer
);

--  Table: photoavis
CREATE TABLE photoavis (
    numavis integer NOT NULL,
    numphoto integer NOT NULL
);

-- Table: pointfort
CREATE TABLE pointfort (
    numpointfort integer NOT NULL,
    nom character varying(1024)
);

--  Table: prix_periode                   
CREATE TABLE prix_periode (
    numperiode character(10) NOT NULL,
    idtypechambre integer NOT NULL,
    prixperiode numeric
);

-- Table: regroupement                   
CREATE TABLE regroupement (
    numregroupement integer NOT NULL,
    libelleregroupement character varying(1024)
);

--  Table: reservation                    
CREATE TABLE reservation (
    numreservation integer NOT NULL,
    idclub integer NOT NULL,
    idtransport integer NOT NULL,
    numclient integer NOT NULL,
    datedebut date,
    datefin date,
    nbpersonnes integer,
    lieudepart character varying(1024),
    prix numeric,
    statut character varying(50) DEFAULT 'EN_ATTENTE'::character varying,
    etat_calcule character varying(20),
    mail boolean DEFAULT false,
    disponibilite_confirmee boolean DEFAULT false,
    token_partenaire character varying(64),
    mail_confirmation_envoye boolean,
    veut_annuler boolean DEFAULT false
);

-- Table: pays_region           
CREATE TABLE pays_region (
    numlocalisation integer NOT NULL,
    numpays integer NOT NULL
);

-- Table: categorie_type_club               
CREATE TABLE categorie_type_club (
    numcategory integer NOT NULL,
    numtype integer NOT NULL
);

-- Table: type_chambre_service                
CREATE TABLE type_chambre_service (
    numservice integer NOT NULL,
    idtypechambre integer NOT NULL
);

-- Table: club_chambre                       
CREATE TABLE club_chambre (
    idclub integer NOT NULL,
    numchambre integer NOT NULL
);

-- Table: reservation_activite                      
CREATE TABLE reservation_activite (
    numreservation integer NOT NULL,
    idactivite integer NOT NULL,
    nbpersonnes integer NOT NULL,
    disponibilite_confirmee boolean DEFAULT false,
    token character varying(255),
    date_envoi date
);

-- Table: type_chambre_equipement        
CREATE TABLE type_chambre_equipement (
    numequipement integer NOT NULL,
    idtypechambre integer NOT NULL
);

-- Table: service                        
CREATE TABLE service (
    numservice integer NOT NULL,
    nom character varying(1024)
);

-- Table: souslocalisation               
CREATE TABLE souslocalisation (
    numpays integer NOT NULL,
    numphoto integer NOT NULL,
    nompays character varying(1024)
);

-- Table: station                      
CREATE TABLE station (
    numstation integer NOT NULL,
    numphoto integer NOT NULL,
    nomstation character varying(1024) NOT NULL,
    altitudestation numeric NOT NULL,
    longueurpistes numeric NOT NULL,
    nbpistes integer NOT NULL,
    infoski character varying(1024) NOT NULL
);

-- Table: subscription_items             
CREATE TABLE subscription_items (
    id bigint NOT NULL,
    subscription_id bigint NOT NULL,
    stripe_id character varying(255) NOT NULL,
    stripe_product character varying(255) NOT NULL,
    stripe_price character varying(255) NOT NULL,
    quantity integer,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);

-- Table: subscriptions                  
CREATE TABLE subscriptions (
    id bigint NOT NULL,
    name character varying(255) NOT NULL,
    stripe_id character varying(255) NOT NULL,
    stripe_status character varying(255) NOT NULL,
    stripe_price character varying(255),
    quantity integer,
    trial_ends_at timestamp(0) without time zone,
    ends_at timestamp(0) without time zone,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);

-- Table: type_chambre_pointfort                    
CREATE TABLE type_chambre_pointfort (
    numpointfort integer NOT NULL,
    idtypechambre integer NOT NULL
);

-- Table: trancheage                     
CREATE TABLE trancheage (
    numtranche integer NOT NULL,
    agemin integer,
    agemax integer
);

-- Table: transaction                   
CREATE TABLE transaction (
    idtransaction integer NOT NULL,
    numreservation integer NOT NULL,
    montant numeric,
    date_transaction timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    moyen_paiement character varying(50),
    statut_paiement character varying(50)
);

-- Table: transport
CREATE TABLE transport (
    idtransport integer NOT NULL,
    lieudepart character varying(1024),
    prix numeric(10,2)
);

--  Table: typeactivite                   
CREATE TABLE typeactivite (
    numtypeactivite integer NOT NULL,
    numphoto integer NOT NULL,
    description character varying(1024) NOT NULL,
    nbactivitecarte integer NOT NULL,
    nbactiviteincluse integer NOT NULL,
    titre character varying(1024)
);

-- Table: typechambre
CREATE TABLE typechambre (
    idtypechambre integer NOT NULL,
    numphoto integer NOT NULL,
    nomtype character varying(1024),
    metrescarres numeric,
    textepresentation character varying(1024),
    capacitemax integer,
    idclub integer,
    indisponible boolean DEFAULT false
);

-- Table: typeclub
CREATE TABLE typeclub (
    numtype integer NOT NULL,
    nomtype character varying(1024)
);

-- Table: utilisateur
CREATE TABLE utilisateur (
    idutilisateur integer NOT NULL,
    numadresse integer,
    nom character varying(1024),
    prenom character varying(1024),
    email character varying(1024) NOT NULL,
    motdepasse_crypter character varying(1024),
    telephone character varying(1024),
    role character varying(50) DEFAULT 'CLIENT'::character varying
);


-- Séquences
CREATE SEQUENCE client_numclient_seq
    AS integer
    START WITH 154 
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

CREATE SEQUENCE failed_jobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE failed_jobs_id_seq OWNED BY failed_jobs.id;

CREATE SEQUENCE migrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE migrations_id_seq OWNED BY migrations.id;

CREATE SEQUENCE partenaires_idpartenaire_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE partenaires_idpartenaire_seq OWNED BY partenaires.idpartenaire;

CREATE SEQUENCE personal_access_tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE personal_access_tokens_id_seq OWNED BY personal_access_tokens.id;

CREATE SEQUENCE reservation_numreservation_seq
    AS integer
    START WITH 601
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE reservation_numreservation_seq OWNED BY reservation.numreservation;

CREATE SEQUENCE subscription_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE subscription_items_id_seq OWNED BY subscription_items.id;

CREATE SEQUENCE subscriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE subscriptions_id_seq OWNED BY subscriptions.id;

CREATE SEQUENCE transaction_idtransaction_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE transaction_idtransaction_seq OWNED BY transaction.idtransaction;

CREATE SEQUENCE utilisateur_idutilisateur_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE utilisateur_idutilisateur_seq OWNED BY utilisateur.idutilisateur;


ALTER TABLE   client ALTER COLUMN numclient SET DEFAULT nextval('client_numclient_seq'::regclass);
ALTER TABLE   failed_jobs ALTER COLUMN id SET DEFAULT nextval('failed_jobs_id_seq'::regclass);
ALTER TABLE   migrations ALTER COLUMN id SET DEFAULT nextval('migrations_id_seq'::regclass);
ALTER TABLE   partenaires ALTER COLUMN idpartenaire SET DEFAULT nextval('partenaires_idpartenaire_seq'::regclass);
ALTER TABLE   personal_access_tokens ALTER COLUMN id SET DEFAULT nextval('personal_access_tokens_id_seq'::regclass);
ALTER TABLE   reservation ALTER COLUMN numreservation SET DEFAULT nextval('reservation_numreservation_seq'::regclass);
ALTER TABLE   subscription_items ALTER COLUMN id SET DEFAULT nextval('subscription_items_id_seq'::regclass);
ALTER TABLE   subscriptions ALTER COLUMN id SET DEFAULT nextval('subscriptions_id_seq'::regclass);
ALTER TABLE   transaction ALTER COLUMN idtransaction SET DEFAULT nextval('transaction_idtransaction_seq'::regclass);
ALTER TABLE   utilisateur ALTER COLUMN idutilisateur SET DEFAULT nextval('utilisateur_idutilisateur_seq'::regclass);

SELECT pg_catalog.setval('failed_jobs_id_seq', 1, false);
SELECT pg_catalog.setval('migrations_id_seq', 12, true);
SELECT pg_catalog.setval('partenaires_idpartenaire_seq', 1, false);
SELECT pg_catalog.setval('personal_access_tokens_id_seq', 770, true);
SELECT pg_catalog.setval('reservation_numreservation_seq', 600, true);
SELECT pg_catalog.setval('subscription_items_id_seq', 1, false);
SELECT pg_catalog.setval('subscriptions_id_seq', 1, false);
SELECT pg_catalog.setval('transaction_idtransaction_seq', 32, true);
SELECT pg_catalog.setval('utilisateur_idutilisateur_seq', 1, false);

-- Photos
INSERT INTO photo VALUES (1, 'assets/images/pays/france.jpg');
INSERT INTO photo VALUES (2, 'assets/images/pays/maroc.jpg');
INSERT INTO photo VALUES (3, 'assets/images/pays/italie.jpg');
INSERT INTO photo VALUES (4, 'assets/images/pays/indonesie.jpg');
INSERT INTO photo VALUES (5, 'assets/images/pays/mexique.jpg');
INSERT INTO photo VALUES (6, 'assets/images/pays/turquie.jpg');
INSERT INTO photo VALUES (7, 'assets/images/pays/turks_caicos.jpg');
INSERT INTO photo VALUES (8, 'assets/images/pays/bresil.jpg');
INSERT INTO photo VALUES (9, 'assets/images/pays/grece.jpg');
INSERT INTO photo VALUES (10, 'assets/images/pays/portugal.jpg');
INSERT INTO photo VALUES (11, 'assets/images/pays/espagne.jpg');
INSERT INTO photo VALUES (12, 'assets/images/pays/suisse.jpg');
INSERT INTO photo VALUES (13, 'assets/images/pays/rep_dominicaine.jpg');
INSERT INTO photo VALUES (14, 'assets/images/pays/bahamas.jpg');
INSERT INTO photo VALUES (15, 'assets/images/pays/maurice.jpg');
INSERT INTO photo VALUES (16, 'assets/images/pays/seychelles.jpg');
INSERT INTO photo VALUES (17, 'assets/images/pays/senegal.jpg');
INSERT INTO photo VALUES (18, 'assets/images/pays/tunisie.jpg');
INSERT INTO photo VALUES (19, 'assets/images/pays/japon.jpg');
INSERT INTO photo VALUES (20, 'assets/images/pays/chine.jpg');
INSERT INTO photo VALUES (21, 'assets/images/pays/thailande.jpg');
INSERT INTO photo VALUES (22, 'assets/images/pays/malaisie.jpg');
INSERT INTO photo VALUES (23, 'assets/images/pays/maldives.jpg');
INSERT INTO photo VALUES (24, 'assets/images/pays/canada.jpg');
INSERT INTO photo VALUES (25, 'assets/images/pays/egypte.jpg');
INSERT INTO photo VALUES (26, 'assets/images/pays/usa.jpg');

INSERT INTO photo VALUES (100, 'assets/images/stations/flaine.jpg');
INSERT INTO photo VALUES (101, 'assets/images/stations/meribel.jpg');
INSERT INTO photo VALUES (102, 'assets/images/stations/les_arcs.jpg');
INSERT INTO photo VALUES (103, 'assets/images/stations/chamonix.jpg');
INSERT INTO photo VALUES (104, 'assets/images/stations/serre_chevalier.jpg');
INSERT INTO photo VALUES (105, 'assets/images/stations/val_isere.jpg');
INSERT INTO photo VALUES (106, 'assets/images/stations/les_menuires_valmorel.jpg');
INSERT INTO photo VALUES (107, 'assets/images/stations/val_thorens.jpg');
INSERT INTO photo VALUES (108, 'assets/images/stations/avoriaz.jpg');
INSERT INTO photo VALUES (109, 'assets/images/stations/courchevel.jpg');
INSERT INTO photo VALUES (110, 'assets/images/stations/la_plagne.jpg');
INSERT INTO photo VALUES (111, 'assets/images/stations/les_deux_alpes.jpg');
INSERT INTO photo VALUES (112, 'assets/images/stations/tignes.jpg');
INSERT INTO photo VALUES (113, 'assets/images/stations/alpe_huez.jpg');
INSERT INTO photo VALUES (114, 'assets/images/stations/les_menuires.jpg');

INSERT INTO photo VALUES (200, 'assets/images/clubs/alpe_huez.jpg');
INSERT INTO photo VALUES (201, 'assets/images/clubs/bali.jpg');
INSERT INTO photo VALUES (202, 'assets/images/clubs/bodrum.jpg');
INSERT INTO photo VALUES (203, 'assets/images/clubs/cancun.jpg');
INSERT INTO photo VALUES (204, 'assets/images/clubs/cap_skirring.jpg');
INSERT INTO photo VALUES (205, 'assets/images/clubs/cefalu.jpg');
INSERT INTO photo VALUES (206, 'assets/images/clubs/cherating.jpg');
INSERT INTO photo VALUES (207, 'assets/images/clubs/columbus.jpg');
INSERT INTO photo VALUES (208, 'assets/images/clubs/da_balaia.jpg');
INSERT INTO photo VALUES (209, 'assets/images/clubs/grand_massif.jpg');
INSERT INTO photo VALUES (210, 'assets/images/clubs/gregolimano.jpg');
INSERT INTO photo VALUES (211, 'assets/images/clubs/guilin.jpg');
INSERT INTO photo VALUES (212, 'assets/images/clubs/ixtapa.jpg');
INSERT INTO photo VALUES (213, 'assets/images/clubs/kabira.jpg');
INSERT INTO photo VALUES (214, 'assets/images/clubs/kani.jpg');
INSERT INTO photo VALUES (215, 'assets/images/clubs/kiroro.jpg');
INSERT INTO photo VALUES (216, 'assets/images/clubs/caravelle.jpg');
INSERT INTO photo VALUES (217, 'assets/images/clubs/la_palmyre.jpg');
INSERT INTO photo VALUES (218, 'assets/images/clubs/albion.jpg');
INSERT INTO photo VALUES (219, 'assets/images/clubs/la_rosiere.jpg');
INSERT INTO photo VALUES (220, 'assets/images/clubs/les_arcs.jpg');
INSERT INTO photo VALUES (221, 'assets/images/clubs/villas_albion.jpg');
INSERT INTO photo VALUES (222, 'assets/images/clubs/finolhu.jpg');
INSERT INTO photo VALUES (223, 'assets/images/clubs/lijiang.jpg');
INSERT INTO photo VALUES (224, 'assets/images/clubs/marbella.jpg');
INSERT INTO photo VALUES (225, 'assets/images/clubs/marrakech.jpg');
INSERT INTO photo VALUES (226, 'assets/images/clubs/miches.jpg');
INSERT INTO photo VALUES (227, 'assets/images/clubs/opio.jpg');
INSERT INTO photo VALUES (228, 'assets/images/clubs/palmiye.jpg');
INSERT INTO photo VALUES (229, 'assets/images/clubs/peisey.jpg');
INSERT INTO photo VALUES (230, 'assets/images/clubs/phuket.jpg');
INSERT INTO photo VALUES (231, 'assets/images/clubs/pragelato.jpg');
INSERT INTO photo VALUES (232, 'assets/images/clubs/punta_cana.jpg');
INSERT INTO photo VALUES (233, 'assets/images/clubs/quebec.jpg');
INSERT INTO photo VALUES (234, 'assets/images/clubs/rio.jpg');
INSERT INTO photo VALUES (235, 'assets/images/clubs/sahoro.jpg');
INSERT INTO photo VALUES (236, 'assets/images/clubs/st_moritz.jpg');
INSERT INTO photo VALUES (237, 'assets/images/clubs/serre_chevalier.jpg');
INSERT INTO photo VALUES (238, 'assets/images/clubs/seychelles.jpg');
INSERT INTO photo VALUES (239, 'assets/images/clubs/tignes.jpg');
INSERT INTO photo VALUES (240, 'assets/images/clubs/tomamu.jpg');
INSERT INTO photo VALUES (241, 'assets/images/clubs/trancoso.jpg');
INSERT INTO photo VALUES (242, 'assets/images/clubs/turkoise.jpg');
INSERT INTO photo VALUES (243, 'assets/images/clubs/val_isere.jpg');
INSERT INTO photo VALUES (244, 'assets/images/clubs/valmorel.jpg');
INSERT INTO photo VALUES (245, 'assets/images/clubs/val_thorens.jpg');
INSERT INTO photo VALUES (246, 'assets/images/clubs/vittel.jpg');
INSERT INTO photo VALUES (247, 'assets/images/clubs/yabuli.jpg');
INSERT INTO photo VALUES (248, 'assets/images/clubs/la_plagne.jpg');

INSERT INTO photo VALUES (300, 'assets/images/resto/healthy_food.jpg');
INSERT INTO photo VALUES (301, 'assets/images/resto/lagon_bleu.jpg');
INSERT INTO photo VALUES (302, 'assets/images/resto/tapas_bodega.jpg');
INSERT INTO photo VALUES (303, 'assets/images/resto/italien_pizza.jpg');
INSERT INTO photo VALUES (304, 'assets/images/resto/glacier_chocolat.jpg');
INSERT INTO photo VALUES (305, 'assets/images/resto/gourmet_alpin.jpg');
INSERT INTO photo VALUES (306, 'assets/images/resto/sushi_master.jpg');
INSERT INTO photo VALUES (307, 'assets/images/resto/gastronomie.jpg');
INSERT INTO photo VALUES (308, 'assets/images/resto/lounge_bar_vin.jpg');
INSERT INTO photo VALUES (309, 'assets/images/resto/grand_buffet.jpg');
INSERT INTO photo VALUES (310, 'assets/images/resto/romantique_diamant.jpg');
INSERT INTO photo VALUES (311, 'assets/images/resto/trattoria_famille.jpg');
INSERT INTO photo VALUES (312, 'assets/images/resto/pub_nightclub.jpg');
INSERT INTO photo VALUES (313, 'assets/images/resto/snack_burger.jpg');

INSERT INTO photo VALUES (400, 'assets/images/activites/sports_nautiques.jpg');
INSERT INTO photo VALUES (401, 'assets/images/activites/sports_terrestres.jpg');
INSERT INTO photo VALUES (402, 'assets/images/activites/bien_etre_spa.jpg');
INSERT INTO photo VALUES (403, 'assets/images/activites/excursions.jpg');
INSERT INTO photo VALUES (404, 'assets/images/activites/spectacles.jpg');

INSERT INTO photo VALUES (1000, 'assets/images/activites/tennis_padel.jpg');
INSERT INTO photo VALUES (1001, 'assets/images/activites/fitness_cardio.jpg');
INSERT INTO photo VALUES (1002, 'assets/images/activites/relaxation_yoga.jpg');
INSERT INTO photo VALUES (1003, 'assets/images/activites/arts_creatifs.jpg');
INSERT INTO photo VALUES (1004, 'assets/images/activites/danse.jpg');
INSERT INTO photo VALUES (1005, 'assets/images/activites/rafting.jpg');
INSERT INTO photo VALUES (1006, 'assets/images/activites/sports_collectifs.jpg');
INSERT INTO photo VALUES (1007, 'assets/images/activites/cuisine.jpg');
INSERT INTO photo VALUES (1008, 'assets/images/activites/soirees_theme.jpg');
INSERT INTO photo VALUES (1009, 'assets/images/activites/esthetique.jpg');
INSERT INTO photo VALUES (1010, 'assets/images/activites/randonnee.jpg');
INSERT INTO photo VALUES (1011, 'assets/images/activites/tech_robotique.jpg');
INSERT INTO photo VALUES (1012, 'assets/images/activites/peche.jpg');
INSERT INTO photo VALUES (1013, 'assets/images/activites/alpinisme.jpg');
INSERT INTO photo VALUES (1014, 'assets/images/activites/meditation.jpg');
INSERT INTO photo VALUES (1015, 'assets/images/activites/musique_chant.jpg');
INSERT INTO photo VALUES (1016, 'assets/images/activites/arts_martiaux.jpg');
INSERT INTO photo VALUES (1017, 'assets/images/activites/photographie.jpg');
INSERT INTO photo VALUES (1018, 'assets/images/activites/plongee.jpg');
INSERT INTO photo VALUES (1019, 'assets/images/activites/vtt.jpg');
INSERT INTO photo VALUES (1020, 'assets/images/activites/cirque.jpg');
INSERT INTO photo VALUES (1021, 'assets/images/activites/thermalisme.jpg');
INSERT INTO photo VALUES (1022, 'assets/images/activites/crossfit.jpg');
INSERT INTO photo VALUES (1023, 'assets/images/activites/jardinage.jpg');
INSERT INTO photo VALUES (1024, 'assets/images/activites/voile.jpg');
INSERT INTO photo VALUES (1025, 'assets/images/activites/glace_hockey.jpg');
INSERT INTO photo VALUES (1026, 'assets/images/activites/jeux_societe.jpg');
INSERT INTO photo VALUES (1027, 'assets/images/activites/dev_perso.jpg');
INSERT INTO photo VALUES (1028, 'assets/images/activites/langues.jpg');
INSERT INTO photo VALUES (1029, 'assets/images/activites/tir_arc.jpg');
INSERT INTO photo VALUES (1030, 'assets/images/activites/surf.jpg');
INSERT INTO photo VALUES (1031, 'assets/images/activites/ski_rando.jpg');
INSERT INTO photo VALUES (1032, 'assets/images/activites/theatre.jpg');
INSERT INTO photo VALUES (1033, 'assets/images/activites/yoga_aerien.jpg');
INSERT INTO photo VALUES (1034, 'assets/images/activites/poterie.jpg');
INSERT INTO photo VALUES (1035, 'assets/images/activites/gym_suedoise.jpg');
INSERT INTO photo VALUES (1036, 'assets/images/activites/kayak.jpg');
INSERT INTO photo VALUES (1037, 'assets/images/activites/biathlon.jpg');
INSERT INTO photo VALUES (1038, 'assets/images/activites/magie.jpg');
INSERT INTO photo VALUES (1039, 'assets/images/activites/massage.jpg');
INSERT INTO photo VALUES (1040, 'assets/images/activites/astronomie.jpg');
INSERT INTO photo VALUES (1041, 'assets/images/activites/running.jpg');
INSERT INTO photo VALUES (1042, 'assets/images/activites/paddle.jpg');
INSERT INTO photo VALUES (1043, 'assets/images/activites/escalade.jpg');
INSERT INTO photo VALUES (1044, 'assets/images/activites/cinema.jpg');
INSERT INTO photo VALUES (1045, 'assets/images/activites/sauna.jpg');
INSERT INTO photo VALUES (1046, 'assets/images/activites/oenologie.jpg');
INSERT INTO photo VALUES (1047, 'assets/images/activites/golf.jpg');
INSERT INTO photo VALUES (1048, 'assets/images/activites/kitesurf.jpg');

-- Adresses
INSERT INTO adresse VALUES (1, 45, 'Boulevard de la Corderie', '13007', 'Marseille', 'France');
INSERT INTO adresse VALUES (2, 8, 'Rue Esquermoise', '59000', 'Lille', 'France');
INSERT INTO adresse VALUES (3, 3, 'Place du Capitole', '31000', 'Toulouse', 'France');
INSERT INTO adresse VALUES (4, 2, 'Cours Julien', '13006', 'Marseille', 'France');
INSERT INTO adresse VALUES (5, 7, 'Quai Sainte-Catherine', '33000', 'Bordeaux', 'France');
INSERT INTO adresse VALUES (6, 23, 'Rue de la Monnaie', '59800', 'Lille', 'France');
INSERT INTO adresse VALUES (7, 1, 'Quai des États-Unis', '06300', 'Nice', 'France');
INSERT INTO adresse VALUES (8, 5, 'Place des Jacobins', '69002', 'Lyon', 'France');
INSERT INTO adresse VALUES (9, 4, 'Rue des Remparts', '33000', 'Bordeaux', 'France');
INSERT INTO adresse VALUES (10, 33, 'Rue Masséna', '06000', 'Nice', 'France');
INSERT INTO adresse VALUES (11, 6, 'Rue Grignan', '13006', 'Marseille', 'France');
INSERT INTO adresse VALUES (12, 1, 'Rue du Lac', '74000', 'Annecy', 'France');
INSERT INTO adresse VALUES (13, 8, 'Place Wilson', '31000', 'Toulouse', 'France');
INSERT INTO adresse VALUES (14, 16, 'Avenue Jean Médecin', '06000', 'Nice', 'France');
INSERT INTO adresse VALUES (15, 5, 'Quai du Port', '13002', 'Marseille', 'France');
INSERT INTO adresse VALUES (16, 29, 'Rue Mercière', '69002', 'Lyon', 'France');
INSERT INTO adresse VALUES (17, 3, 'Rue de Béthune', '59000', 'Lille', 'France');
INSERT INTO adresse VALUES (18, 7, 'Faubourg des Annonciades', '74000', 'Annecy', 'France');
INSERT INTO adresse VALUES (19, 20, 'Rue de France', '06000', 'Nice', 'France');
INSERT INTO adresse VALUES (20, 8, 'Place Bellecour', '69002', 'Lyon', 'France');
INSERT INTO adresse VALUES (21, 36, 'Cours de l''Intendance', '33000', 'Bordeaux', 'France');
INSERT INTO adresse VALUES (22, 2, 'Avenue de Verdun', '06000', 'Nice', 'France');
INSERT INTO adresse VALUES (23, 28, 'Place du Parlement', '33000', 'Bordeaux', 'France');
INSERT INTO adresse VALUES (24, 5, 'Rue du Molinel', '59000', 'Lille', 'France');
INSERT INTO adresse VALUES (25, 6, 'Place Saint-Georges', '31000', 'Toulouse', 'France');
INSERT INTO adresse VALUES (26, 4, 'Place des Vosges', '75004', 'Paris', 'France');
INSERT INTO adresse VALUES (27, 24, 'Rue de la Grande Chaussée', '59800', 'Lille', 'France');
INSERT INTO adresse VALUES (28, 3, 'Avenue d''Albigny', '74000', 'Annecy', 'France');
INSERT INTO adresse VALUES (29, 33, 'Rue du Faubourg Saint-Honoré', '75008', 'Paris', 'France');
INSERT INTO adresse VALUES (30, 2, 'Rue Ozenne', '31000', 'Toulouse', 'France');
INSERT INTO adresse VALUES (31, 7, 'Rue de la Buffa', '06000', 'Nice', 'France');
INSERT INTO adresse VALUES (32, 3, 'Rue de Lodi', '13006', 'Marseille', 'France');
INSERT INTO adresse VALUES (33, 16, 'Rue de Brest', '69002', 'Lyon', 'France');
INSERT INTO adresse VALUES (34, 6, 'Rue des Tanneurs', '59800', 'Lille', 'France');
INSERT INTO adresse VALUES (35, 29, 'Allées Forain-François Verdier', '31000', 'Toulouse', 'France');
INSERT INTO adresse VALUES (36, 5, 'Rue du Congrès', '06000', 'Nice', 'France');
INSERT INTO adresse VALUES (37, 1, 'Rue d''Endoume', '13007', 'Marseille', 'France');
INSERT INTO adresse VALUES (38, 27, 'Rue des Arts', '59000', 'Lille', 'France');
INSERT INTO adresse VALUES (39, 4, 'Grande Rue Saint-Michel', '31400', 'Toulouse', 'France');
INSERT INTO adresse VALUES (40, 23, 'Rue Pastorelli', '06000', 'Nice', 'France');
INSERT INTO adresse VALUES (41, 8, 'Rue du Panier', '13002', 'Marseille', 'France');
INSERT INTO adresse VALUES (42, 7, 'Quai de Bondy', '69005', 'Lyon', 'France');
INSERT INTO adresse VALUES (43, 45, 'Rue Fondaudège', '33000', 'Bordeaux', 'France');
INSERT INTO adresse VALUES (44, 1, 'Passage des Clercs', '74000', 'Annecy', 'France');
INSERT INTO adresse VALUES (45, 20, 'Cours Gambetta', '69003', 'Lyon', 'France');
INSERT INTO adresse VALUES (46, 3, 'Place Pey Berland', '33000', 'Bordeaux', 'France');
INSERT INTO adresse VALUES (47, 6, 'Rue club', '76000', 'Mabos', 'Afrique du Sud');
INSERT INTO adresse VALUES (48, 4, 'rue des furtifs', '89000', 'Auxerre', 'France');
INSERT INTO adresse VALUES (49, 51, 'rue de la paix', '74000', 'Annecy', 'France');
INSERT INTO adresse VALUES (50, 3, 'avenue Elu', '86160', 'La Ferrière-Airoux', 'Bahamas');
INSERT INTO adresse VALUES (51, 8, 'Rue Jean-Jacques Rousseau', '69780', 'Mions', 'France');
INSERT INTO adresse VALUES (52, 45, 'Avenue Crampel', '31400', 'Toulouse', 'France');
INSERT INTO adresse VALUES (53, 3, 'Allée de la Grangette', '74940', 'Annecy', 'France');


-- Localisations
INSERT INTO localisation VALUES (1, 'Europe');
INSERT INTO localisation VALUES (2, 'Alpes');
INSERT INTO localisation VALUES (3, 'Afrique');
INSERT INTO localisation VALUES (4, 'Ocean Indien');
INSERT INTO localisation VALUES (5, 'Caraibes');
INSERT INTO localisation VALUES (6, 'Amérique Sud');
INSERT INTO localisation VALUES (7, 'Amérique Nord');
INSERT INTO localisation VALUES (8, 'Asie');

-- Categories
INSERT INTO categorie VALUES (1, 'Montagne');
INSERT INTO categorie VALUES (2, 'Mer');
INSERT INTO categorie VALUES (3, 'Famille');
INSERT INTO categorie VALUES (4, 'Couple');
INSERT INTO categorie VALUES (5, 'Premium');
INSERT INTO categorie VALUES (6, 'Bien-être et Spa');
INSERT INTO categorie VALUES (7, 'Sportif');
INSERT INTO categorie VALUES (8, 'Tout Inclus');
INSERT INTO categorie VALUES (9, 'Séjour Hiver');
INSERT INTO categorie VALUES (10, 'Séjour Été');
INSERT INTO categorie VALUES (11, 'Campagne');
INSERT INTO categorie VALUES (12, 'Insolite');

-- Regroupements
INSERT INTO regroupement VALUES (1, 'Nos coups de coeur');
INSERT INTO regroupement VALUES (2, 'Dernières chambres');
INSERT INTO regroupement VALUES (4, 'Jusqu’à -10%');
INSERT INTO regroupement VALUES (3, 'Dernières minutes');

-- Services
INSERT INTO service VALUES (1, 'Non applicable'); 
INSERT INTO service VALUES (2, 'Wifi Premium Haut Débit');
INSERT INTO service VALUES (3, 'Room Service 24h/24');
INSERT INTO service VALUES (4, 'Conciergerie de Luxe');
INSERT INTO service VALUES (5, 'Navette Privée');

-- Point forts
INSERT INTO pointfort VALUES (1, 'Non applicable');
INSERT INTO pointfort VALUES (2, 'Vue Panoramique Mer/Montagne');
INSERT INTO pointfort VALUES (3, 'Accès Direct (Ski-in/Ski-out ou Plage)');
INSERT INTO pointfort VALUES (4, 'Architecture Design & Atypique');
INSERT INTO pointfort VALUES (5, 'Calme Absolu');

-- Equipements salle de bain
INSERT INTO equipementsalledebain VALUES (1, 'Non applicable');
INSERT INTO equipementsalledebain VALUES (2, 'Douche à l''Italienne Pluie');
INSERT INTO equipementsalledebain VALUES (3, 'Baignoire Balnéo Jacuzzi');
INSERT INTO equipementsalledebain VALUES (4, 'Double Vasque Marbre');
INSERT INTO equipementsalledebain VALUES (5, 'Produits d''accueil de Luxe');

-- Partenaires  
INSERT INTO partenaires VALUES (1, 'Blue Lagoon Plongée', 'truffart.gabin@gmail.com', '0601010101');
INSERT INTO partenaires VALUES (2, 'Wind & Sail Academy', 'truffart.gabin@gmail.com', '0601010102');
INSERT INTO partenaires VALUES (3, 'Jet Ski Xtrem', 'truffart.gabin@gmail.com', '0601010103');
INSERT INTO partenaires VALUES (4, 'Ocean Kayak Tours', 'truffart.gabin@gmail.com', '0601010104');
INSERT INTO partenaires VALUES (5, 'Deep Sea Fishing', 'truffart.gabin@gmail.com', '0601010105');
INSERT INTO partenaires VALUES (6, 'Kitesurf Paradise', 'truffart.gabin@gmail.com', '0601010106');
INSERT INTO partenaires VALUES (7, 'Paddle & Yoga Mer', 'truffart.gabin@gmail.com', '0601010107');
INSERT INTO partenaires VALUES (8, 'Wakeboard City', 'truffart.gabin@gmail.com', '0601010108');
INSERT INTO partenaires VALUES (9, 'Catamaran Cruises', 'truffart.gabin@gmail.com', '0601010109');
INSERT INTO partenaires VALUES (10, 'Snorkeling Discovery', 'truffart.gabin@gmail.com', '0601010110');
INSERT INTO partenaires VALUES (11, 'Alpinisme Pro Guide', 'truffart.gabin@gmail.com', '0602020201');
INSERT INTO partenaires VALUES (12, 'VTT Descente Club', 'truffart.gabin@gmail.com', '0602020202');
INSERT INTO partenaires VALUES (13, 'Rando Nature Evasion', 'truffart.gabin@gmail.com', '0602020203');
INSERT INTO partenaires VALUES (14, 'Equitation Passion', 'truffart.gabin@gmail.com', '0602020204');
INSERT INTO partenaires VALUES (15, 'Quad & Buggy Safari', 'truffart.gabin@gmail.com', '0602020205');
INSERT INTO partenaires VALUES (16, 'Canyoning Aventure', 'truffart.gabin@gmail.com', '0602020206');
INSERT INTO partenaires VALUES (17, 'Escalade Verticale', 'truffart.gabin@gmail.com', '0602020207');
INSERT INTO partenaires VALUES (18, 'Tir à l''Arc Tradition', 'truffart.gabin@gmail.com', '0602020208');
INSERT INTO partenaires VALUES (19, 'Tennis Elite Academy', 'truffart.gabin@gmail.com', '0602020209');
INSERT INTO partenaires VALUES (20, 'Green Valley Golf', 'truffart.gabin@gmail.com', '0602020210');
INSERT INTO partenaires VALUES (21, 'Lotus Royal Spa', 'truffart.gabin@gmail.com', '0603030301');
INSERT INTO partenaires VALUES (22, 'Hammam des Sables', 'truffart.gabin@gmail.com', '0603030302');
INSERT INTO partenaires VALUES (23, 'Yoga Spirit Center', 'truffart.gabin@gmail.com', '0603030303');
INSERT INTO partenaires VALUES (24, 'Beauty Bar & Nails', 'truffart.gabin@gmail.com', '0603030304');
INSERT INTO partenaires VALUES (25, 'Massage du Monde', 'truffart.gabin@gmail.com', '0603030305');
INSERT INTO partenaires VALUES (26, 'Meditation Zen Garden', 'truffart.gabin@gmail.com', '0603030306');
INSERT INTO partenaires VALUES (27, 'Les P''tits Loups Garderie', 'truffart.gabin@gmail.com', '0604040401');
INSERT INTO partenaires VALUES (28, 'Magic Kids Events', 'truffart.gabin@gmail.com', '0604040402');
INSERT INTO partenaires VALUES (29, 'Junior Aventure Club', 'truffart.gabin@gmail.com', '0604040403');
INSERT INTO partenaires VALUES (30, 'Baby Douceur', 'truffart.gabin@gmail.com', '0604040404');
INSERT INTO partenaires VALUES (31, 'Teen Spirit Animation', 'truffart.gabin@gmail.com', '0604040405');
INSERT INTO partenaires VALUES (32, 'Atelier Créatif Kids', 'truffart.gabin@gmail.com', '0604040406');
INSERT INTO partenaires VALUES (33, 'Cirque du Soleil Levant', 'truffart.gabin@gmail.com', '0604040407');
INSERT INTO partenaires VALUES (34, 'Cuisine des Chefs', 'truffart.gabin@gmail.com', '0605050501');
INSERT INTO partenaires VALUES (35, 'Vins & Terroirs', 'truffart.gabin@gmail.com', '0605050502');
INSERT INTO partenaires VALUES (36, 'Photo Pro Studio', 'truffart.gabin@gmail.com', '0605050503');
INSERT INTO partenaires VALUES (37, 'Artisanat Local', 'truffart.gabin@gmail.com', '0605050504');
INSERT INTO partenaires VALUES (38, 'Langues & Culture', 'truffart.gabin@gmail.com', '0605050505');
INSERT INTO partenaires VALUES (39, 'Casino Royal Events', 'truffart.gabin@gmail.com', '0605050506');
INSERT INTO partenaires VALUES (40, 'Night Fever DJ', 'truffart.gabin@gmail.com', '0606060601');
INSERT INTO partenaires VALUES (41, 'Jazz Club Live', 'truffart.gabin@gmail.com', '0606060602');
INSERT INTO partenaires VALUES (42, 'Magic Show Prestidige', 'truffart.gabin@gmail.com', '0606060604');
INSERT INTO partenaires VALUES (43, 'Night Fever DJ Bis', 'truffart.gabin@gmail.com', '0606060601');
INSERT INTO partenaires VALUES (44, 'Théâtre du Rire', 'truffart.gabin@gmail.com', '0606060603');
INSERT INTO partenaires VALUES (45, 'Cinema Paradiso', 'truffart.gabin@gmail.com', '0606060605');
INSERT INTO partenaires VALUES (46, 'Football 5 League', 'truffart.gabin@gmail.com', '0607070701');
INSERT INTO partenaires VALUES (47, 'Beach Volley Pro', 'truffart.gabin@gmail.com', '0607070702');
INSERT INTO partenaires VALUES (48, 'Basket Street Zone', 'truffart.gabin@gmail.com', '0607070703');
INSERT INTO partenaires VALUES (49, 'Waterpolo Club', 'truffart.gabin@gmail.com', '0607070704');
INSERT INTO partenaires VALUES (50, 'Fitness Bootcamp', 'truffart.gabin@gmail.com', '0607070705');

-- Transports
INSERT INTO transport VALUES (1, 'Paris - CDG', 350.00);
INSERT INTO transport VALUES (2, 'Lyon St-Ex', 200.00);
INSERT INTO transport VALUES (3, 'Marseille', 150.00);
INSERT INTO transport VALUES (4, 'Bordeaux', 180.00);
INSERT INTO transport VALUES (5, 'Genève', 250.00);
INSERT INTO transport VALUES (6, 'Paris Montparnasse', 45.00);
INSERT INTO transport VALUES (7, 'Lyon Part-Dieu', 30.00);
INSERT INTO transport VALUES (8, 'Autocar Paris', 12.00);
INSERT INTO transport VALUES (9, 'Aucun - (Voiture Personnelle)', 0.00);

-- Tranches d'age
INSERT INTO trancheage VALUES (1, 0, 3);
INSERT INTO trancheage VALUES (2, 4, 10);
INSERT INTO trancheage VALUES (3, 11, 17);

-- Types de club
INSERT INTO typeclub VALUES (1, 'En famille');
INSERT INTO typeclub VALUES (2, 'Ski');
INSERT INTO typeclub VALUES (3, 'Soleil');
INSERT INTO typeclub VALUES (4, 'En couple');
INSERT INTO typeclub VALUES (5, 'En France');
INSERT INTO typeclub VALUES (6, 'En croisière');
INSERT INTO typeclub VALUES (7, 'En circuit');

-- Calendrier
INSERT INTO calendrier VALUES ('2024-02-10');
INSERT INTO calendrier VALUES ('2024-02-11');
INSERT INTO calendrier VALUES ('2024-02-12');
INSERT INTO calendrier VALUES ('2024-02-13');
INSERT INTO calendrier VALUES ('2024-02-14');
INSERT INTO calendrier VALUES ('2024-03-15');
INSERT INTO calendrier VALUES ('2024-03-16');
INSERT INTO calendrier VALUES ('2024-03-17');
INSERT INTO calendrier VALUES ('2024-12-22');
INSERT INTO calendrier VALUES ('2024-12-23');
INSERT INTO calendrier VALUES ('2024-12-24');
INSERT INTO calendrier VALUES ('2024-12-25');

-- Periodes
INSERT INTO periode VALUES ('HIVER_25', '2025-12-01', '2026-03-31');
INSERT INTO periode VALUES ('PRINT_26', '2026-04-01', '2026-05-31');
INSERT INTO periode VALUES ('ETE_26', '2026-06-01', '2026-09-30');
INSERT INTO periode VALUES ('AUT_26', '2026-10-01', '2026-11-30');

-- Lieux de restauration
INSERT INTO lieurestauration VALUES (1, 305, 'Signature', 'Le Gourmet Alpin', 'Une rÃ©interprÃ©tation moderne et raffinÃ©e des grands classiques de la gastronomie alpine.', false);
INSERT INTO lieurestauration VALUES (2, 303, 'Italien', 'La Pergola', 'Retrouvez toutes les saveurs ensoleillÃ©es de l''Italie avec nos pizzas et pastas maison.', false);
INSERT INTO lieurestauration VALUES (3, 308, NULL, 'Le Lounge Bar', 'Un espace dÃ©tente chic et feutrÃ© pour savourer des cocktails signature en musique.', true);
INSERT INTO lieurestauration VALUES (4, 309, 'Buffet', 'Le Petit DÃ©jeuner', 'Un buffet matinal gargantuesque sucrÃ©-salÃ© pour faire le plein d''Ã©nergie avant l''aventure.', false);
INSERT INTO lieurestauration VALUES (5, 313, 'Snack', 'Snack de la Piste', 'Une halte rapide et roborative directement sur les pistes pour ne pas perdre une minute de ski.', true);
INSERT INTO lieurestauration VALUES (6, 304, 'GoÃ»ter', 'Le Glacier', 'La pause gourmande incontournable avec pÃ¢tisseries fines et glaces artisanales pour le goÃ»ter.', false);
INSERT INTO lieurestauration VALUES (7, 302, 'Festif', 'La Bodega', 'Plongez dans l''ambiance festive des soirÃ©es espagnoles avec tapas Ã  partager et sangria.', true);
INSERT INTO lieurestauration VALUES (8, 307, 'Gastro', 'Table du Chef', 'Une expÃ©rience culinaire exclusive et intimiste orchestrÃ©e chaque soir par notre chef Ã©toilÃ©.', false);
INSERT INTO lieurestauration VALUES (9, 300, NULL, 'Coin Healthy', 'Des options lÃ©gÃ¨res, bio et vitaminÃ©es pour prendre soin de votre corps avec plaisir.', false);
INSERT INTO lieurestauration VALUES (10, 312, 'Pub', 'Pub Anglais', 'L''atmosphÃ¨re chaleureuse d''un vÃ©ritable pub britannique proposant biÃ¨res pression et billard.', true);
INSERT INTO lieurestauration VALUES (20, 305, 'Authentique', 'Le Refuge Savoyard', 'DÃ©gustez d''authentiques fondues et raclettes au lait cru dans un cadre rustique au coin du feu.', false);
INSERT INTO lieurestauration VALUES (21, 307, 'Chaleureux', 'La Table des Cimes', 'Une cuisine gastronomique d''altitude mettant Ã  l''honneur les produits locaux de saison.', false);
INSERT INTO lieurestauration VALUES (22, 313, 'Rapide', 'Le Summit Burger', 'Des burgers gourmets prÃ©parÃ©s Ã  la minute avec du bÅ“uf local et des fromages de montagne.', false);
INSERT INTO lieurestauration VALUES (23, 308, 'Après-Ski', 'Le Yeti Bar', 'L''endroit idÃ©al pour l''aprÃ¨s-ski avec vin chaud, planches de charcuterie et musique festive.', true);
INSERT INTO lieurestauration VALUES (24, 304, 'Douceur', 'Chocolat & Co', 'Un salon de thÃ© cosy proposant des chocolats chauds onctueux et des pÃ¢tisseries maison.', false);
INSERT INTO lieurestauration VALUES (25, 312, 'Festif', 'L''Avalanche', 'Un pub vibrant avec musique live et une large sÃ©lection de biÃ¨res pour prolonger la soirÃ©e.', true);
INSERT INTO lieurestauration VALUES (26, 301, 'Frais', 'Le Lagon Bleu', 'Savourez la pÃªche du jour grillÃ©e Ã  la plancha les pieds dans le sable face Ã  l''ocÃ©an turquoise.', false);
INSERT INTO lieurestauration VALUES (27, 302, 'Latino', 'La Cantina Mexicana', 'Une explosion de saveurs Ã©picÃ©es avec nos tacos, fajitas et guacamoles dans une ambiance colorÃ©e.', false);
INSERT INTO lieurestauration VALUES (28, 303, 'Grill', 'Sunset BBQ', 'Profitez de nos grillades de viandes et poissons au feu de bois devant un coucher de soleil inoubliable.', false);
INSERT INTO lieurestauration VALUES (29, 308, 'Cocktails', 'Coco Loco Bar', 'Le bar de plage exotique par excellence servant des cocktails signatures Ã  base de fruits frais.', true);
INSERT INTO lieurestauration VALUES (30, 300, 'VitaminÃ©', 'Smoothie Bar', 'Faites le plein d''Ã©nergie et de vitamines avec nos jus dÃ©tox et smoothies prÃ©parÃ©s sous vos yeux.', true);
INSERT INTO lieurestauration VALUES (31, 303, 'Italien', 'La Dolce Vita', 'Des pizzas croustillantes cuites au feu de bois et des antipasti comme si vous Ã©tiez en Italie.', false);
INSERT INTO lieurestauration VALUES (32, 305, 'Zen', 'Le Lotus', 'Une cuisine fusion asiatique raffinÃ©e mariant techniques traditionnelles et saveurs modernes.', false);
INSERT INTO lieurestauration VALUES (33, 306, 'Japonais', 'Sushi Master', 'Nos maÃ®tres sushis prÃ©parent devant vous sashimis et makis d''une fraÃ®cheur exceptionnelle.', false);
INSERT INTO lieurestauration VALUES (34, 307, 'Ã‰picÃ©', 'Le Taj Mahal', 'Voyagez en Inde avec nos currys parfumÃ©s, tandooris et naans cuits au four traditionnel.', false);
INSERT INTO lieurestauration VALUES (35, 312, 'Lounge', 'Buddha Bar', 'Un lounge sophistiquÃ© aux lumiÃ¨res tamisÃ©es pour dÃ©guster des cocktails crÃ©atifs en toute intimitÃ©.', true);
INSERT INTO lieurestauration VALUES (36, 300, 'Wok', 'Wok Street', 'Choisissez vos ingrÃ©dients frais et regardez nos chefs les faire sauter au wok avec dextÃ©ritÃ©.', false);
INSERT INTO lieurestauration VALUES (37, 309, 'International', 'Le Grand MarchÃ©', 'Un buffet international aux multiples saveurs du monde pour satisfaire toutes les envies gourmandes.', false);
INSERT INTO lieurestauration VALUES (38, 310, 'Gastro', 'Le Diamant Noir', 'Une expÃ©rience gastronomique intime et Ã©lÃ©gante, idÃ©ale pour les dÃ®ners romantiques en tÃªte-Ã -tÃªte.', false);
INSERT INTO lieurestauration VALUES (39, 311, 'Familial', 'La Trattoria', 'Retrouvez la convivialitÃ© des grandes tablÃ©es italiennes autour de plats de pÃ¢tes fraÃ®ches maison.', false);
INSERT INTO lieurestauration VALUES (40, 308, 'Vins', 'Le Cellier', 'Une cave exclusive pour dÃ©guster des grands crus accompagnÃ©s d''une sÃ©lection de mets raffinÃ©s.', true);
INSERT INTO lieurestauration VALUES (41, 302, 'Tapas', 'Bodega EspaÃ±ola', 'Partagez des tapas authentiques et de la sangria maison dans une ambiance andalouse survoltÃ©e.', false);
INSERT INTO lieurestauration VALUES (42, 305, 'Viande', 'Steakhouse The Bull', 'Le paradis des carnivores proposant des viandes maturÃ©es d''exception grillÃ©es Ã  la perfection.', false);
INSERT INTO lieurestauration VALUES (43, 300, 'Vegan', 'The Green Spot', 'Une cuisine crÃ©ative et savoureuse 100% vÃ©gÃ©tale qui ravira vÃ©gÃ©tariens et curieux.', false);
INSERT INTO lieurestauration VALUES (44, 304, 'Glacier', 'Ice Cream Dream', 'Une farandole de glaces artisanales et sorbets aux fruits pour une pause fraÃ®cheur bien mÃ©ritÃ©e.', false);
INSERT INTO lieurestauration VALUES (45, 313, 'Snack', 'Pool Side Snack', 'Une restauration rapide et savoureuse Ã  dÃ©guster sans avoir Ã  quitter votre transat au bord de la piscine.', false);
INSERT INTO lieurestauration VALUES (46, 312, 'Nuit', 'Night Club The Box', 'Le rendez-vous nocturne incontournable avec DJ sets pour danser jusqu''au bout de la nuit.', true);
INSERT INTO lieurestauration VALUES (47, 307, 'Local', 'L''Auberge du PÃªcheur', 'Une cuisine maritime simple et authentique basÃ©e exclusivement sur l''arrivage du port ce matin.', false);
INSERT INTO lieurestauration VALUES (48, 308, 'Vue', 'Sky Bar', 'Sirotez votre verre au sommet de la station avec une vue panoramique Ã©poustouflante sur le domaine.', true);
INSERT INTO lieurestauration VALUES (49, 309, 'Brunch', 'Sunday Brunch', 'Un brunch dominical copieux mÃªlant sucrÃ© et salÃ© pour un rÃ©veil en douceur et en gourmandise.', false);
INSERT INTO lieurestauration VALUES (50, 301, 'SantÃ©', 'Detox Bar', 'Des Ã©lixirs santÃ© Ã  base de lÃ©gumes, gingembre et super-aliments pour se revitaliser aprÃ¨s le sport.', true);

-- Stations
INSERT INTO station VALUES (1, 107, 'Val Thorens', 2300, 600, 320, 'Domaine Les 3 Vallées.');
INSERT INTO station VALUES (2, 109, 'Courchevel', 1850, 600, 330, 'Prestige.');
INSERT INTO station VALUES (3, 110, 'La Plagne', 2000, 425, 225, 'Paradiski.');
INSERT INTO station VALUES (4, 102, 'Les Arcs', 1950, 425, 230, 'Paradiski.');
INSERT INTO station VALUES (5, 112, 'Tignes', 2100, 300, 150, 'Espace Killy.');
INSERT INTO station VALUES (6, 105, 'Val d''Isère', 1850, 300, 155, 'Espace Killy.');
INSERT INTO station VALUES (7, 108, 'Avoriaz', 1800, 650, 280, 'Portes du Soleil.');
INSERT INTO station VALUES (8, 113, 'Alpe d''Huez', 1860, 250, 135, 'Grand Domaine.');
INSERT INTO station VALUES (9, 103, 'Chamonix', 1035, 170, 110, 'Mont Blanc.');
INSERT INTO station VALUES (10, 104, 'Serre Chevalier', 1400, 250, 81, 'Vallée Guisane.');
INSERT INTO station VALUES (11, 100, 'Flaine', 1600, 265, 140, 'Grand Massif.');
INSERT INTO station VALUES (12, 114, 'Les Menuires', 1850, 600, 310, '3 Vallées.');
INSERT INTO station VALUES (13, 101, 'Méribel', 1450, 600, 325, '3 Vallées.');
INSERT INTO station VALUES (14, 111, 'Les Deux Alpes', 1650, 220, 96, 'Glacier.');
INSERT INTO station VALUES (15, 106, 'Valmorel', 1400, 165, 95, 'Grand Domaine.');

-- Types activite
INSERT INTO typeactivite VALUES (1, 1000, 'Tennis, padel ou badminton : affinez votre revers et votre stratégie.', 2, 5, 'Sports de Raquette');
INSERT INTO typeactivite VALUES (2, 1001, 'Gardez la forme avec des équipements modernes et des coachs motivants.', 0, 10, 'Fitness & Cardio');
INSERT INTO typeactivite VALUES (3, 1002, 'Retrouvez votre équilibre intérieur grâce à des techniques douces.', 1, 5, 'Relaxation & Mindset');
INSERT INTO typeactivite VALUES (4, 1003, 'Libérez votre imagination à travers la peinture, le dessin et le bricolage.', 2, 2, 'Arts Créatifs');
INSERT INTO typeactivite VALUES (5, 1004, 'Laissez-vous emporter par la musique, de la salsa au hip-hop.', 0, 4, 'Danse & Rythme');
INSERT INTO typeactivite VALUES (6, 245, 'Sensations fortes garanties pour les amateurs d''adrénaline pure.', 5, 0, 'Glisse Extrême');
INSERT INTO typeactivite VALUES (7, 1005, 'Affrontez les rapides en rafting ou canyoning pour un max de frissons.', 3, 2, 'Sports d''Eau Vive');
INSERT INTO typeactivite VALUES (8, 1006, 'L''esprit d''équipe avant tout : football, volley, basket et plus encore.', 0, 8, 'Sports Collectifs');
INSERT INTO typeactivite VALUES (9, 1007, 'Éveillez vos papilles avec des ateliers de cuisine et dégustations locales.', 5, 0, 'Découverte Culinaire');
INSERT INTO typeactivite VALUES (10, 1008, 'Costumes, décors et ambiance survoltée pour des nuits mémorables.', 0, 7, 'Soirées à Thème');
INSERT INTO typeactivite VALUES (11, 1009, 'Mise en beauté, manucure et soins du visage pour rayonner.', 10, 0, 'Soins Esthétiques');
INSERT INTO typeactivite VALUES (12, 1010, 'Marchez au cœur de paysages époustouflants, guidés par nos experts.', 2, 3, 'Randonnée & Trek');
INSERT INTO typeactivite VALUES (13, 1011, 'Découvrez les dernières innovations, du codage à la robotique.', 1, 1, 'Atelier Technologie');
INSERT INTO typeactivite VALUES (14, 1012, 'Patience et technique pour traquer les plus beaux poissons en mer ou rivière.', 3, 0, 'Pêche Sportive');
INSERT INTO typeactivite VALUES (15, 1013, 'Prenez de la hauteur et défiez les sommets enneigés en toute sécurité.', 4, 0, 'Alpinisme');
INSERT INTO typeactivite VALUES (16, 1014, 'Apprenez à lâcher prise et à vous recentrer sur l''instant présent.', 0, 5, 'Méditation Guidée');
INSERT INTO typeactivite VALUES (17, 1015, 'Révélez votre voix ou apprenez un instrument dans une ambiance conviviale.', 1, 2, 'Musique & Chant');
INSERT INTO typeactivite VALUES (18, 1016, 'Discipline et maîtrise de soi avec le judo, karaté ou taekwondo.', 0, 4, 'Arts Martiaux');
INSERT INTO typeactivite VALUES (19, 1017, 'Capturez la beauté de vos vacances avec les conseils de nos pros.', 2, 1, 'Photographie');
INSERT INTO typeactivite VALUES (20, 1018, 'Explorez les fonds marins et nagez au milieu des poissons multicolores.', 4, 1, 'Plongée & Snorkeling');
INSERT INTO typeactivite VALUES (21, 400, 'Domptez les vagues et le vent avec notre sélection complète d''activités sur l''eau.', 3, 4, 'Sports Nautiques');
INSERT INTO typeactivite VALUES (22, 401, 'Dépensez-vous sur la terre ferme avec des sports classiques et intenses.', 3, 4, 'Sports Terrestres');
INSERT INTO typeactivite VALUES (23, 402, 'Une parenthèse de douceur pour ressourcer votre corps et votre esprit.', 1, 1, 'Bien-être & Spa');
INSERT INTO typeactivite VALUES (24, 403, 'Partez à l''aventure et explorez les trésors culturels de la région.', 1, 0, 'Excursions & Découverte');
INSERT INTO typeactivite VALUES (25, 404, 'Vivez des moments inoubliables avec nos spectacles et soirées festives.', 1, 1, 'Animations & Événements');
INSERT INTO typeactivite VALUES (26, 1019, 'Dévalez les pentes ou baladez-vous sur les sentiers à votre rythme.', 2, 3, 'VTT & Cyclisme');
INSERT INTO typeactivite VALUES (27, 1020, 'Trapèze, jonglage et équilibre : devenez l''étoile de la piste.', 1, 3, 'Cirque & Acrobatie');
INSERT INTO typeactivite VALUES (28, 1021, 'Profitez des bienfaits des eaux thermales pour une santé de fer.', 5, 0, 'Thermalisme');
INSERT INTO typeactivite VALUES (29, 1022, 'Un entraînement complet et intense pour repousser vos limites.', 0, 5, 'Crossfit');
INSERT INTO typeactivite VALUES (30, 1023, 'Reconnectez-vous à la terre en apprenant à cultiver et observer la nature.', 0, 3, 'Jardinage & Nature');
INSERT INTO typeactivite VALUES (31, 1024, 'Hissez les voiles et naviguez en toute liberté sur l''océan.', 3, 2, 'Voile & Catamaran');
INSERT INTO typeactivite VALUES (32, 1025, 'Patinage, hockey ou curling pour s''amuser au frais.', 2, 2, 'Sports de Glace');
INSERT INTO typeactivite VALUES (33, 1026, 'Moments de partage et de rire autour de jeux de plateau modernes.', 0, 10, 'Jeux de Société');
INSERT INTO typeactivite VALUES (34, 1027, 'Des ateliers pour mieux se connaître et booster sa confiance.', 2, 0, 'Développement Perso');
INSERT INTO typeactivite VALUES (35, 1028, 'Apprenez les bases d''une nouvelle langue de manière ludique.', 2, 1, 'Langues Étrangères');
INSERT INTO typeactivite VALUES (36, 1029, 'Concentration maximale pour atteindre la cible au tir à l''arc ou carabine.', 1, 2, 'Tir de Précision');
INSERT INTO typeactivite VALUES (37, 1030, 'Guettez le tube parfait et glissez sur les meilleures vagues.', 3, 1, 'Surf & Bodyboard');
INSERT INTO typeactivite VALUES (38, 1031, 'Loin des foules, gravissez la montagne pour une descente vierge.', 4, 0, 'Ski de Randonnée');
INSERT INTO typeactivite VALUES (39, 1032, 'Montez sur scène et révélez vos talents d''acteur.', 0, 3, 'Théâtre & Impro');
INSERT INTO typeactivite VALUES (40, 1033, 'Défiez la gravité et étirez-vous en douceur suspendu dans les airs.', 1, 2, 'Yoga Aérien');
INSERT INTO typeactivite VALUES (41, 1034, 'Façonnez l''argile et créez vos propres objets d''art.', 2, 0, 'Poterie & Céramique');
INSERT INTO typeactivite VALUES (42, 1035, 'Un mix dynamique de musique et de gym pour se tonifier avec le sourire.', 0, 5, 'Gym Suédoise');
INSERT INTO typeactivite VALUES (43, 1036, 'Balade tranquille ou sportive au fil de l''eau.', 1, 3, 'Canoë-Kayak');
INSERT INTO typeactivite VALUES (44, 1037, 'Combinez l''effort du ski de fond et la précision du tir.', 3, 0, 'Biathlon');
INSERT INTO typeactivite VALUES (45, 1038, 'Apprenez des tours bluffants pour impressionner vos amis.', 1, 1, 'Magie & Illusion');
INSERT INTO typeactivite VALUES (46, 1039, 'Voyagez à travers les techniques ancestrales de relaxation.', 10, 0, 'Massages du Monde');
INSERT INTO typeactivite VALUES (47, 1040, 'Observez les étoiles et découvrez les mystères de l''univers.', 1, 1, 'Astronomie');
INSERT INTO typeactivite VALUES (48, 1041, 'Des footings collectifs pour découvrir les environs en courant.', 0, 5, 'Running Club');
INSERT INTO typeactivite VALUES (49, 1042, 'Glissez debout sur l''eau pour un travail d''équilibre et de gainage.', 1, 4, 'Paddle');
INSERT INTO typeactivite VALUES (50, 1043, 'Grimpez vers les sommets sur mur artificiel ou falaise naturelle.', 2, 2, 'Escalade');
INSERT INTO typeactivite VALUES (51, 1044, 'Vos films préférés sous les étoiles, confortablement installés.', 0, 1, 'Cinéma Plein Air');
INSERT INTO typeactivite VALUES (52, 1045, 'Chaleur sèche ou humide pour éliminer les toxines et se détendre.', 0, 2, 'Sauna & Hammam');
INSERT INTO typeactivite VALUES (53, 1046, 'Initiez-vous à l''art de la dégustation des vins et spiritueux.', 5, 0, 'Oenologie');
INSERT INTO typeactivite VALUES (54, 1047, 'Perfectionnez votre swing sur nos parcours 18 trous d''exception.', 5, 0, 'Golf');
INSERT INTO typeactivite VALUES (55, 1048, 'Envolez-vous au-dessus de l''eau tracté par votre voile.', 5, 0, 'Kitesurf');

-- Sous-localisation
INSERT INTO souslocalisation VALUES (1, 1, 'France');
INSERT INTO souslocalisation VALUES (2, 2, 'Maroc');
INSERT INTO souslocalisation VALUES (3, 3, 'Italie');
INSERT INTO souslocalisation VALUES (4, 4, 'Indonésie');
INSERT INTO souslocalisation VALUES (5, 5, 'Mexique');
INSERT INTO souslocalisation VALUES (6, 6, 'Turquie');
INSERT INTO souslocalisation VALUES (7, 7, 'Turks-et-Caïcos');
INSERT INTO souslocalisation VALUES (8, 8, 'Brésil');
INSERT INTO souslocalisation VALUES (9, 9, 'Grèce');
INSERT INTO souslocalisation VALUES (10, 10, 'Portugal');
INSERT INTO souslocalisation VALUES (11, 11, 'Espagne');
INSERT INTO souslocalisation VALUES (12, 12, 'Suisse');
INSERT INTO souslocalisation VALUES (13, 13, 'République Dominicaine');
INSERT INTO souslocalisation VALUES (14, 14, 'Bahamas');
INSERT INTO souslocalisation VALUES (15, 15, 'Maurice');
INSERT INTO souslocalisation VALUES (16, 16, 'Seychelles');
INSERT INTO souslocalisation VALUES (17, 17, 'Sénégal');
INSERT INTO souslocalisation VALUES (18, 18, 'Tunisie');
INSERT INTO souslocalisation VALUES (19, 19, 'Japon');
INSERT INTO souslocalisation VALUES (20, 20, 'Chine');
INSERT INTO souslocalisation VALUES (21, 21, 'Thaïlande');
INSERT INTO souslocalisation VALUES (22, 22, 'Malaisie');
INSERT INTO souslocalisation VALUES (23, 23, 'Maldives');
INSERT INTO souslocalisation VALUES (24, 24, 'Canada');
INSERT INTO souslocalisation VALUES (25, 25, 'Égypte');
INSERT INTO souslocalisation VALUES (26, 26, 'États-Unis');

-- Liaison : pays_region
INSERT INTO pays_region VALUES (1, 1);  
INSERT INTO pays_region VALUES (1, 3);  
INSERT INTO pays_region VALUES (1, 6);  
INSERT INTO pays_region VALUES (1, 9);  
INSERT INTO pays_region VALUES (1, 10); 
INSERT INTO pays_region VALUES (1, 11);     
INSERT INTO pays_region VALUES (1, 12); 
INSERT INTO pays_region VALUES (2, 1);  
INSERT INTO pays_region VALUES (2, 3);  
INSERT INTO pays_region VALUES (2, 12); 
INSERT INTO pays_region VALUES (3, 2);  
INSERT INTO pays_region VALUES (3, 17); 
INSERT INTO pays_region VALUES (3, 18); 
INSERT INTO pays_region VALUES (3, 25); 
INSERT INTO pays_region VALUES (4, 15); 
INSERT INTO pays_region VALUES (4, 16); 
INSERT INTO pays_region VALUES (4, 23); 
INSERT INTO pays_region VALUES (5, 7);  
INSERT INTO pays_region VALUES (5, 13); 
INSERT INTO pays_region VALUES (5, 14); 
INSERT INTO pays_region VALUES (6, 8);  
INSERT INTO pays_region VALUES (7, 5);  
INSERT INTO pays_region VALUES (7, 24); 
INSERT INTO pays_region VALUES (7, 26); 
INSERT INTO pays_region VALUES (8, 4);  
INSERT INTO pays_region VALUES (8, 19); 
INSERT INTO pays_region VALUES (8, 20); 
INSERT INTO pays_region VALUES (8, 21); 
INSERT INTO pays_region VALUES (8, 22); 

-- Icons
INSERT INTO icon VALUES (1, 1, 2, 1, 'assets/icons/service_wifi.png');
INSERT INTO icon VALUES (2, 2, 1, 1, 'assets/icons/pf_view.png');
INSERT INTO icon VALUES (3, 1, 1, 2, 'assets/icons/sdb_shower.png');
INSERT INTO icon VALUES (4, 3, 1, 1, 'assets/icons/pf_access.png');
INSERT INTO icon VALUES (5, 1, 3, 1, 'assets/icons/service_food.png');
INSERT INTO icon VALUES (6, 1, 1, 3, 'assets/icons/sdb_bath.png');
INSERT INTO icon VALUES (7, 4, 1, 1, 'assets/icons/pf_arch.png');
INSERT INTO icon VALUES (8, 1, 5, 1, 'assets/icons/service_shuttle.png');
INSERT INTO icon VALUES (10, 1, 1, 1, 'assets/icons/eq_ski.png');
INSERT INTO icon VALUES (11, 1, 1, 1, 'assets/icons/eq_tech.png');
INSERT INTO icon VALUES (12, 1, 1, 1, 'assets/icons/eq_baby.png');
INSERT INTO icon VALUES (13, 1, 1, 1, 'assets/icons/eq_wellness.png');
INSERT INTO icon VALUES (14, 1, 1, 1, 'assets/icons/eq_room.png');
INSERT INTO icon VALUES (15, 1, 1, 1, 'assets/icons/eq_pool.png');
INSERT INTO icon VALUES (16, 1, 1, 1, 'assets/icons/eq_general.png');

-- Equipements
INSERT INTO equipement VALUES (1, 10, 'Casier Ski');
INSERT INTO equipement VALUES (2, 11, 'Wifi');
INSERT INTO equipement VALUES (4, 13, 'Hammam');
INSERT INTO equipement VALUES (3, 12, 'Kit Bébé');
INSERT INTO equipement VALUES (5, 14, 'Climatisation');
INSERT INTO equipement VALUES (6, 14, 'Coffre-fort');
INSERT INTO equipement VALUES (7, 11, 'Télévision');
INSERT INTO equipement VALUES (8, 14, 'Sèche-cheveux');
INSERT INTO equipement VALUES (9, 14, 'Minibar');
INSERT INTO equipement VALUES (10, 14, 'Machine à café');
INSERT INTO equipement VALUES (11, 14, 'Fer à repasser');
INSERT INTO equipement VALUES (12, 10, 'Sèche-chaussures');
INSERT INTO equipement VALUES (13, 10, 'Boutique Location Skis');
INSERT INTO equipement VALUES (14, 13, 'Sauna');
INSERT INTO equipement VALUES (15, 13, 'Jacuzzi');
INSERT INTO equipement VALUES (16, 13, 'Salle de Yoga');
INSERT INTO equipement VALUES (17, 13, 'Salle de Fitness');
INSERT INTO equipement VALUES (18, 12, 'Poussette');
INSERT INTO equipement VALUES (19, 12, 'Chauffe-biberon');
INSERT INTO equipement VALUES (20, 12, 'Lit parapluie');
INSERT INTO equipement VALUES (21, 12, 'Baby Phone');
INSERT INTO equipement VALUES (22, 15, 'Piscine Extérieure');
INSERT INTO equipement VALUES (23, 15, 'Piscine Intérieure');
INSERT INTO equipement VALUES (24, 15, 'Piscine Zen (Adulte)');
INSERT INTO equipement VALUES (25, 15, 'Serviette de plage');
INSERT INTO equipement VALUES (26, 15, 'Transat');
INSERT INTO equipement VALUES (27, 15, 'Parasol');
INSERT INTO equipement VALUES (28, 16, 'Parking');
INSERT INTO equipement VALUES (29, 16, 'Bornes de recharge élec.');
INSERT INTO equipement VALUES (30, 16, 'Bagagerie');
INSERT INTO equipement VALUES (31, 16, 'Navette Aéroport');
INSERT INTO equipement VALUES (32, 16, 'Infirmerie');
INSERT INTO equipement VALUES (33, 16, 'Blanchisserie');

-- Clubs
INSERT INTO club VALUES (1, 237, 'Serre Chevalier', 'Alpes du Sud', 0, 'pdf', 1, '', 'EN_LIGNE');
INSERT INTO club VALUES (2, 246, 'Vittel Ermitage', 'Vosges', 4.1, 'pdf', 1, '', 'EN_LIGNE');
INSERT INTO club VALUES (3, 228, 'Palmiye Turquie', 'Turquie', 1.1, 'pdf', 6, '', 'EN_LIGNE');
INSERT INTO club VALUES (4, 232, 'Punta Cana', 'Caraibes', 3.3, 'pdf', 13, '', 'EN_LIGNE');
INSERT INTO club VALUES (5, 203, 'Cancun', 'Mexique', 3.8, 'pdf', 5, '', 'EN_LIGNE');
INSERT INTO club VALUES (6, 230, 'Phuket', 'Thailande', 1.1, 'pdf', 21, '', 'EN_LIGNE');
INSERT INTO club VALUES (7, 204, 'Cap Skirring', 'Senegal', 1.8, 'pdf', 17, '', 'EN_LIGNE');
INSERT INTO club VALUES (8, 225, 'Marrakech', 'Maroc', 0.7, 'pdf', 2, '', 'EN_LIGNE');
INSERT INTO club VALUES (9, 227, 'Opio', 'Provence', 4.9, 'pdf', 1, '', 'EN_LIGNE');
INSERT INTO club VALUES (10, 217, 'La Palmyre', 'Atlantique', 2.8, 'pdf', 1, '', 'EN_LIGNE');
INSERT INTO club VALUES (11, 219, 'La Rosière', 'Alpes', 0.7, 'pdf', 1, '', 'EN_LIGNE');
INSERT INTO club VALUES (12, 231, 'Pragelato', 'Italie', 2.1, 'pdf', 3, '', 'EN_LIGNE');
INSERT INTO club VALUES (13, 236, 'St-Moritz', 'Suisse', 3.9, 'pdf', 12, '', 'EN_LIGNE');
INSERT INTO club VALUES (14, 226, 'Michès', 'Rep Dom', 4.7, 'pdf', 13, '', 'EN_LIGNE');
INSERT INTO club VALUES (15, 218, 'Plantation Albion', 'Maurice', 4.1, 'pdf', 15, '', 'EN_LIGNE');
INSERT INTO club VALUES (16, 221, 'Villas Albion', 'Maurice', 4.4, 'pdf', 15, '', 'EN_LIGNE');
INSERT INTO club VALUES (17, 214, 'Kani', 'Maldives', 1.1, 'pdf', 23, '', 'EN_LIGNE');
INSERT INTO club VALUES (18, 222, 'Finolhu', 'Maldives', 0.9, 'pdf', 23, '', 'EN_LIGNE');
INSERT INTO club VALUES (19, 201, 'Bali', 'Indonésie', 1.7, 'pdf', 4, '', 'EN_LIGNE');
INSERT INTO club VALUES (20, 206, 'Cherating', 'Malaisie', 0.7, 'pdf', 22, '', 'EN_LIGNE');
INSERT INTO club VALUES (21, 211, 'Guilin', 'Chine', 1.1, 'pdf', 20, '', 'EN_LIGNE');
INSERT INTO club VALUES (22, 240, 'Tomamu', 'Japon', 2.7, 'pdf', 19, '', 'EN_LIGNE');
INSERT INTO club VALUES (23, 213, 'Kabira', 'Japon', 2, 'pdf', 19, '', 'EN_LIGNE');
INSERT INTO club VALUES (24, 239, 'Tignes', 'Alpes', 2.8, 'pdf', 1, '', 'EN_LIGNE');
INSERT INTO club VALUES (25, 243, 'Val d''Isère', 'Alpes', 3.9, 'pdf', 1, '', 'EN_LIGNE');
INSERT INTO club VALUES (26, 245, 'Val Thorens', 'Alpes', 3.9, 'pdf', 1, '', 'EN_LIGNE');
INSERT INTO club VALUES (27, 200, 'Alpe d''Huez', 'Alpes', 0.2, 'pdf', 1, '', 'EN_LIGNE');
INSERT INTO club VALUES (28, 220, 'Les Arcs', 'Alpes', 2.2, 'pdf', 1, '', 'EN_LIGNE');
INSERT INTO club VALUES (29, 209, 'Grand Massif', 'Alpes', 2.3, 'pdf', 1, '', 'EN_LIGNE');
INSERT INTO club VALUES (30, 244, 'Valmorel', 'Alpes', 2.1, 'pdf', 1, '', 'EN_LIGNE');
INSERT INTO club VALUES (31, 229, 'Peisey', 'Alpes', 3.7, 'pdf', 1, '', 'EN_LIGNE');
INSERT INTO club VALUES (32, 248, 'La Plagne', 'Alpes', 0.3, 'pdf', 1, '', 'EN_LIGNE');
INSERT INTO club VALUES (33, 231, 'Cervinia', 'Italie', 1, 'pdf', 3, '', 'EN_LIGNE');
INSERT INTO club VALUES (34, 215, 'Kiroro', 'Japon', 3.8, 'pdf', 19, '', 'EN_LIGNE');
INSERT INTO club VALUES (35, 235, 'Sahoro', 'Japon', 2, 'pdf', 19, '', 'EN_LIGNE');
INSERT INTO club VALUES (36, 233, 'Quebec', 'Canada', 2.8, 'pdf', 24, '', 'EN_LIGNE');
INSERT INTO club VALUES (37, 238, 'Seychelles', 'Seychelles', 2.1, 'pdf', 16, '', 'EN_LIGNE');
INSERT INTO club VALUES (38, 202, 'Bodrum', 'Turquie', 1.5, 'pdf', 6, '', 'EN_LIGNE');
INSERT INTO club VALUES (39, 205, 'Cefalu', 'Sicile', 0.6, 'pdf', 3, '', 'EN_LIGNE');
INSERT INTO club VALUES (40, 224, 'Marbella', 'Espagne', 4.4, 'pdf', 11, '', 'EN_LIGNE');
INSERT INTO club VALUES (41, 208, 'Da Balaia', 'Portugal', 2.6, 'pdf', 10, '', 'EN_LIGNE');
INSERT INTO club VALUES (42, 210, 'Gregolimano', 'Grèce', 1.4, 'pdf', 9, '', 'EN_LIGNE');
INSERT INTO club VALUES (43, 207, 'Columbus', 'Bahamas', 3.2, 'pdf', 14, '', 'EN_LIGNE');
INSERT INTO club VALUES (44, 242, 'Turkoise', 'Turks', 2.2, 'pdf', 7, '', 'EN_LIGNE');
INSERT INTO club VALUES (45, 212, 'Ixtapa', 'Mexique', 0.1, 'pdf', 5, '', 'EN_LIGNE');
INSERT INTO club VALUES (46, 234, 'Rio das Pedras', 'Bresil', 2, 'pdf', 8, '', 'EN_LIGNE');
INSERT INTO club VALUES (47, 241, 'Trancoso', 'Bresil', 2.2, 'pdf', 8, '', 'EN_LIGNE');
INSERT INTO club VALUES (48, 247, 'Yabuli', 'Chine', 2.5, 'pdf', 20, '', 'EN_LIGNE');
INSERT INTO club VALUES (49, 216, 'Caravelle', 'Guadeloupe', 3.1, 'pdf', 1, '', 'EN_LIGNE');
INSERT INTO club VALUES (50, 223, 'Lijiang', 'Chine', 0.9, 'pdf', 20, '', 'EN_LIGNE');

-- Clients
INSERT INTO client VALUES (1, 12, 'M', 'Tom', 'Maniglier', '2006-02-15', 'ouaf@gmail.com', '0680808080', '$2y$12$t2YBx73CdC5Y3FaaX3ZiK.5t8yVr2S3.1IVzFuCDK3Wo.hZyAa956', 'CLIENT', false, NULL, NULL, NULL, NULL);
INSERT INTO client VALUES (2, 45, 'F', 'Victoria', 'Renault', '1989-02-12', 'victoria.renault@gmail.com', '0691345678', '$2y$06$UhbOS6S.3DC7wcjh5Ani.uBNtpX.bflPRqxHTjWVVkrqSsd3tp7kC', 'CLIENT', false, NULL, NULL, NULL, NULL);
INSERT INTO client VALUES (3, 3, 'M', 'Issa', 'Pons', '1981-08-20', 'issa.pons@gmail.com', '0778345678', '$2y$06$MITGRwqrJbXR3jjgWDMKH.1NG2vv1bkt.1NueCBFJ7amhxmi12Yqy', 'CLIENT', false, NULL, NULL, NULL, NULL);
INSERT INTO client VALUES (4, 18, 'F', 'Constance', 'Lacroix', '1994-12-07', 'constance.lacroix@gmail.com', '0656345678', '$2y$06$bUzR02L4yKYJL258RwEvTurNF59Yslt1VWAcDTq5/sghY/waLw6Fu', 'CLIENT', false, NULL, NULL, NULL, NULL);
INSERT INTO client VALUES (5, 22, 'F', 'Maeva', 'Barre', '1999-04-26', 'maeva.barre@gmail.com', '0650345678', '$2y$06$Xk6uZa8NW4jUcA.yu3EjlOQElRjbTy5FF73427ykyShcV.aYf5JAi', 'CLIENT', false, NULL, NULL, NULL, NULL);
INSERT INTO client VALUES (6, 50, 'M', 'Kevin', 'Lopes', '1978-05-11', 'kevin.lopes@gmail.com', '0778456789', '$2y$06$HtUgsHHqJrX3QHrbSOyX7eLd.SL8cmD/76cRbPVUefjouHov1hYpu', 'CLIENT', false, NULL, NULL, NULL, NULL);
INSERT INTO client VALUES (7, 7, 'F', 'Jeanne', 'Louis', '1987-11-30', 'jeanne.louis@gmail.com', '0656456789', '$2y$06$Z8o4/zoVWUM6gVNL4JebiO.q/jPstAx6czE6CcvJgvDvjygj030ou', 'CLIENT', false, NULL, NULL, NULL, NULL);
INSERT INTO client VALUES (8, 33, 'M', 'Abdesallamaaaaaaaaaaaa', 'Abdul', '2000-12-18', 'iqsid105@gmail.com', '051025', '$2y$12$/dnFaORcgfv4QHuXUKoQcenBnam0c4F2LCkJteQ7YuhSL7OBI7eBq', 'CLIENT', false, NULL, NULL, NULL, NULL);
INSERT INTO client VALUES (9, 14, 'M', 'Jorge', 'ALVES DA SILVA', '2005-10-24', 'iqsid201@gmail.com', '0761429095', '$2y$12$LuSDUD.VpjQM94Rh6QO0f.FqIr01x5l8DYQGWE/GiCxJ.qetVgBCe', 'CLIENT', false, NULL, NULL, NULL, NULL);
INSERT INTO client VALUES (10, 29, 'F', 'Natis', 'Saillet', '2006-10-28', 'natis.saillet@etu.univ-smb.fr', '0617983451', '$2y$12$1EdagTH0v/myAtKi0q5rtetXO/n8LQnwgllkLW8VBIwRTn35d2qcG', 'CLIENT', false, NULL, NULL, NULL, NULL);
INSERT INTO client VALUES (11, 2, 'F', 'Marie', 'Martin', '1992-11-20', 'marie.martin@gmail.com', '0798765432', '$2y$06$8FUMlj/v096EMlBpCeT7iueuobsR5g4QCPBAz9HrVsnOxu.ttZruW', 'VENTE', false, 'cus_TmdZfqtctvdSOd', NULL, NULL, NULL);
INSERT INTO client VALUES (12, 11, 'M', 'Julien', 'Moreau', '1985-02-10', 'julien.moreau@gmail.com', '0691223344', '$2y$06$QeqKmn8UDqd3WcrQmTuCW.xuQrYeplQc.kNFgzyDZCZh4WwE.3XAS', 'CLIENT', false, NULL, NULL, NULL, NULL);
INSERT INTO client VALUES (13, 32, 'F', 'Ambre', 'Meyer', '1992-06-19', 'ambre.meyer@gmail.com', '0693567890', '$2y$06$/FQaJerXpUBulgSvGaIBNehwTW0MqtVNRQAyOj2Hrzk9N82TwHr1e', 'CLIENT', false, NULL, NULL, NULL, NULL);
INSERT INTO client VALUES (14, 34, 'F', 'Jade', 'Perrin', '1987-10-10', 'jade.perrin@gmail.com', '0691678901', '$2y$06$GVx0i6VO/wjkAirkXPnuRuWNUBrMuooIyVbhvkqBi1htjfFUictGC', 'CLIENT', false, NULL, NULL, NULL, NULL);
INSERT INTO client VALUES (15, 35, 'M', 'Paul', 'Rousseau', '1993-03-06', 'paul.rousseau@gmail.com', '0778678901', '$2y$06$V8iDPpzpAX4kg.Sc4vJ/bO6LQEQ2ud4Vd2GOmTAX/RmRMxckmwWZi', 'CLIENT', false, NULL, NULL, NULL, NULL);
INSERT INTO client VALUES (16, 37, 'M', 'Valentin', 'Colin', '1983-12-23', 'valentin.colin@gmail.com', '0720678901', '$2y$06$Nt5oHq7qVxleUtYkZfBf9.Nvgtai14WbJy3NHK2dK..NGh/TPJGZW', 'CLIENT', false, NULL, NULL, NULL, NULL);
INSERT INTO client VALUES (17, 38, 'F', 'Charlotte', 'Caron', '1997-02-17', 'charlotte.caron@gmail.com', '0650678901', '$2y$06$VG/GGzzCq0HT5sr/EUrkq.VGpP4A6vCWlDSg3pE/6MzHx2YORJMUa', 'CLIENT', false, NULL, NULL, NULL, NULL);
INSERT INTO client VALUES (18, 40, 'F', 'Nina', 'Muller', '1991-08-08', 'nina.muller@gmail.com', '0693678901', '$2y$06$MV7VIyMZlgXr7zeMMrqB.uQlbolXZmcmbVTjFOvJQTbpRdXF5qKHi', 'CLIENT', false, NULL, NULL, NULL, NULL);
INSERT INTO client VALUES (19, 43, 'M', 'Adam', 'Brunet', '1981-07-28', 'adam.brunet@gmail.com', '0778789012', '$2y$06$7x05.LRCAOxWeb.TQB1RMuQFUt55NOSvFAG07xCARzNdvQtiu5jI2', 'CLIENT', false, NULL, NULL, NULL, NULL);
INSERT INTO client VALUES (20, 44, 'F', 'Rose', 'Lambert', '1996-03-03', 'rose.lambert@gmail.com', '0656789012', '$2y$06$A1Ub.NvQPTcdw1G.w2mj/ubCGAgHgZV0hfs9qRKEVi2rKuKfs/XZC', 'CLIENT', false, NULL, NULL, NULL, NULL);
INSERT INTO client VALUES (21, 48, 'F', 'Margot', 'Dufour', '1990-05-04', 'margot.dufour@gmail.com', '0693789012', '$2y$06$Syu6L5zixrT2OyUCtrLE3.jhpaoGmInS.iN2IZfFzpyiG8cfQpMUS', 'CLIENT', false, NULL, NULL, NULL, NULL);
INSERT INTO client VALUES (22, 52, 'F', 'Diane', 'Mary', '1986-12-01', 'diane.mary@gmail.com', '0656890123', '$2y$06$eSJ/Dl0R3VTkTdPpj2VLvuM4HSzJgqvthccYUmqrtz7TnKHm4wgZK', 'CLIENT', false, NULL, NULL, NULL, NULL);
INSERT INTO client VALUES (23, 53, 'M', 'Léo', 'Royer', '1995-07-18', 'leo.royer@gmail.com', '0720890123', '$2y$06$9.sOfN0URbEdyI2pfDFEMuFvAjUds5vgEwBhc5Thpbx.LfkYAFrMW', 'CLIENT', false, NULL, NULL, NULL, NULL);
INSERT INTO client VALUES (24, 1, 'M', 'Maël', 'Barbier', '1984-03-31', 'mael.barbier@gmail.com', '0761890123', '$2y$06$vamE6KGPZLT.f7F9a/h9u.sosm.wVKuwWxFjoj/pSlcvDLZ/Zv9Gu', 'CLIENT', false, NULL, NULL, NULL, NULL);
INSERT INTO client VALUES (25, 5, 'M', 'Nolan', 'Giraud', '1980-08-03', 'nolan.giraud@gmail.com', '0749012345', '$2y$06$7jN.gwRM531UjP7mWGuMNua1eF/KvznRmMo/OGa.lxhd2ma2DIOzW', 'CLIENT', false, NULL, NULL, NULL, NULL);
INSERT INTO client VALUES (26, 8, 'M', 'Noé', 'Charles', '1997-01-20', 'noe.charles@gmail.com', '0720901234', '$2y$06$gKU4OOStganz8J/XjkGFeOHnftsqIvKBdKt1XOW22mTAJKGbc09HW', 'CLIENT', false, NULL, NULL, NULL, NULL);
INSERT INTO client VALUES (27, 9, 'F', 'Sofia', 'Renard', '2001-05-30', 'sofia.renard@gmail.com', '0650901234', '$2y$06$NBP0zztGGF9oSrc4kyV4wuvmPc2z0m8rx0.eZiC4OR8EaCQpStN1K', 'CLIENT', false, NULL, NULL, NULL, NULL);
INSERT INTO client VALUES (28, 12, 'M', 'Ethan', 'Henry', '1976-04-09', 'ethan.henry@gmail.com', '0740123456', '$2y$06$PPZMVP1eFwjmAgak2zBhQ.KZYV/76mxlkAizX25ekjbstBeqQjfZq', 'CLIENT', false, NULL, NULL, NULL, NULL);
INSERT INTO client VALUES (29, 15, 'M', 'Gattouzo', 'Xbassem', '2001-03-19', 'iqsid106@gmail.com', '3', '$2y$12$EXmTfHBLyEQ0pkeCWj5DVeoc69bis/wYMBBM8vRSl9n0IP0n5Fv5e', 'CLIENT', false, NULL, NULL, NULL, NULL);
INSERT INTO client VALUES (30, 12, 'F', 'Emma', 'Simon', '1993-10-03', 'emma.simon@gmail.com', '0756112233', '$2y$06$t2u/y5SKthTTZPljH9E23.8tAatiUdNYy5h3OOFb9KlmXzMD9Iu32', 'CLIENT', false, NULL, NULL, NULL, NULL);
INSERT INTO client VALUES (31, 13, 'M', 'Nicolas', 'Laurent', '1976-11-28', 'nicolas.laurent@gmail.com', '0620998877', '$2y$06$7tVrNWmlemPZg/LK.MRl7u00wUISkVRkZc0/rpLiQuPuvp93wa1OW', 'CLIENT', false, NULL, NULL, NULL, NULL);
INSERT INTO client VALUES (32, 24, 'F', 'Louise', 'Vincent', '1996-10-16', 'louise.vincent@gmail.com', '0693456789', '$2y$06$FU.mte.WDlU9AgDrKT9fsuqKpR3nXITC7A.yRHFhTck0mJym7Cbme', 'CLIENT', false, NULL, NULL, NULL, NULL);
INSERT INTO client VALUES (33, 26, 'F', 'Sarah', 'Mercier', '1977-12-04', 'sarah.mercier@gmail.com', '0691567890', '$2y$06$MA73dngc5nHs7sxV2QBaZeIhGXBD1Ud6QnDRRk5KKHIJEtEK1SCyG', 'CLIENT', false, NULL, NULL, NULL, NULL);
INSERT INTO client VALUES (34, 30, 'F', 'Eva', 'Francois', '1998-11-27', 'eva.francois@gmail.com', '0650567890', '$2y$06$YEmHdKtVFLyvZeInPfUo/O0e0.ApE2QtNs8AD03aD6I1f/Z6iSQke', 'CLIENT', false, NULL, NULL, NULL, NULL);
INSERT INTO client VALUES (35, 31, 'M', 'Enzo', 'Legrand', '1980-01-05', 'enzo.legrand@gmail.com', '0761567890', '$2y$06$PqT.ZnZUI9vLEGIOJPqtNOxbdfyhPvU2UJr6tGECaP.aAAzw0DxBq', 'CLIENT', false, NULL, NULL, NULL, NULL);
INSERT INTO client VALUES (36, 5, 'M', 'Lucas', 'Thomas', '1995-03-25', 'lucas.thomas@gmail.com', '0621456789', '$2y$06$EVCRQJ.M4EioUWLQdoX.yelG2.j9dQJn7Hvz8lDFVX7w4Z2TAnnNy', 'CLIENT', false, NULL, NULL, NULL, NULL);
INSERT INTO client VALUES (37, 16, 'F', 'Clara', 'Roux', '1999-01-01', 'clara.roux@gmail.com', '0793123456', '$2y$06$CoovuP21tGlWKcY.f527EO8C9b58DsOGrDVpTb.fvkDRB6uLYWR7m', 'CLIENT', false, NULL, NULL, NULL, NULL);
INSERT INTO client VALUES (38, 19, 'M', 'Maxime', 'Bertrand', '1978-03-17', 'maxime.bertrand@gmail.com', '0778234567', '$2y$06$X2zykDDxXMY9WE9V2Djub.rwYfNP8Lz1m4iXsYXeoegjgWS/oU25S', 'CLIENT', false, NULL, NULL, NULL, NULL);
INSERT INTO client VALUES (39, 20, 'F', 'Pauline', 'Morel', '1987-05-29', 'pauline.morel@gmail.com', '0656234567', '$2y$06$4X12YvyTISAvx6.bik0hKeam95LLb4d5OXJDgx7cj4y389feFkN1W', 'CLIENT', false, NULL, NULL, NULL, NULL);
INSERT INTO client VALUES (40, 18, 'M', 'Mohamed', 'Roussel', '1979-11-03', 'mohamed.roussel@gmail.com', '0761012345', '$2y$06$akfaSjQ4UHwm.wk8huGUqOj8bGYBmLBH3ZNmbesTz02KYE2stoZAe', 'CLIENT', false, NULL, NULL, NULL, NULL);
INSERT INTO client VALUES (41, 19, 'M', 'Lou', 'Maniglier', '2025-11-05', 'iqsid103@gmail.com', '0769666666', '$2y$12$qXFm9wwLaiN.ad67N64X0eDYEUlTO7j55/jHQaI/tIgBabv/3S7Be', 'CLIENT', false, NULL, NULL, NULL, NULL);
INSERT INTO client VALUES (42, 20, 'M', 'To', 'Man', '2025-11-30', 'iqsid104@gmail.com', '0456789012', '$2y$12$PC0o8RgVLXUkVS7ECieX7OgVoZOe6mI9d5joHvNN93yJ4HfG8kluC', 'CLIENT', false, NULL, NULL, NULL, NULL);
INSERT INTO client VALUES (43, 7, 'M', 'Alexandre', 'Richard', '1982-12-18', 'alex.richard@gmail.com', '0661234567', '$2y$06$atqUDBK47dQ9Avw1iZjw9emfTKRqA4XAPuz/t.0Yi2oAIb7BV.Aaa', 'CLIENT', false, NULL, NULL, NULL, NULL);
INSERT INTO client VALUES (44, 23, 'F', 'Olivia', 'Fernandez', '1990-07-24', 'olivia.fernandez@gmail.com', '0693012345', '$2y$06$ImVcacosDDcLBveqSaR4KuW03S2xrY7q/wAEpNLzZ2q1/QHzwrPyC', 'CLIENT', false, NULL, NULL, NULL, NULL);
INSERT INTO client VALUES (45, 25, 'F', 'Clémence', 'Moreno', '1993-10-22', 'clemence.moreno@gmail.com', '0691123456', '$2y$06$Mq78GLceN.znxIP.aa/NHeVnEOEohcJFvRmxD1ycZ1m0JTAJsiPBG', 'CLIENT', false, NULL, NULL, NULL, NULL);
INSERT INTO client VALUES (46, 26, 'M', 'Augustin', 'Girard', '1977-01-31', 'augustin.girard@gmail.com', '0778123456', '$2y$06$JJCh9Ge8KoG2Xr841lz79edSKDUtHiRwZX/oDsc0q9WpG3Q8USfIS', 'CLIENT', false, NULL, NULL, NULL, NULL);
INSERT INTO client VALUES (47, 27, 'M', 'Simon', 'Payet', '1995-12-11', 'simon.payet@gmail.com', '0720123456', '$2y$06$isp/Wx5niuDArPpY5BOs4Oay/Z40cEuor0vG/TCbfx8bTOz.UqCJy', 'CLIENT', false, NULL, NULL, NULL, NULL);
INSERT INTO client VALUES (48, 28, 'M', 'Oscar', 'Clement', '1980-09-28', 'oscar.clement@gmail.com', '0761123456', '$2y$06$3mBBIbQ11.MvaJTEMf7W8uVwolrVPM1Mu9k/IDBrU4kVkTO75y4VW', 'CLIENT', false, NULL, NULL, NULL, NULL);
INSERT INTO client VALUES (49, 29, 'F', 'Alix', 'Da silva', '1991-06-02', 'alix.da.silva@gmail.com', '0693123456', '$2y$06$Cs5NSbGFCWJxdjrK1NhrU.KCEJPg5dTDhW3JORTCPdj/L3kGOSau6', 'CLIENT', false, NULL, NULL, NULL, NULL);
INSERT INTO client VALUES (50, 30, 'F', 'Romane', 'Perrot', '1996-07-14', 'romane.perrot@gmail.com', '0691234567', '$2y$06$ctVLBJ4wCyzsQ0v014FQP.AQLrUYyKSUTpwwhHHMAuqJHT8roQbxi', 'CLIENT', false, NULL, NULL, NULL, NULL);
INSERT INTO client VALUES (51, 31, 'M', 'Gaspard', 'Perez', '1997-09-16', 'gaspard.perez@gmail.com', '0720234567', '$2y$06$l3YKLdwFBvVveT6V.JwAueqgeAg8f25093gF1baRUj17cDRQYr7p6', 'CLIENT', false, NULL, NULL, NULL, NULL);
INSERT INTO client VALUES (52, 32, 'M', 'Aaron', 'Guérin', '1984-05-20', 'aaron.guerin@gmail.com', '0761234567', '$2y$06$utk2onAst7CgVaaC8EmvqeBDm.Sj8PNYh7gt68tjm5Z3uNmSxAL3q', 'CLIENT', false, NULL, NULL, NULL, NULL);
INSERT INTO client VALUES (53, 33, 'F', 'Elisa', 'Carpentier', '1992-11-25', 'elisa.carpentier@gmail.com', '0693234567', '$2y$06$abopwvMtxuGLz9xagTtO2uhfZS565f2HcKzQyHLIiJwcMA6pMVfqi', 'CLIENT', false, NULL, NULL, NULL, NULL);
INSERT INTO client VALUES (54, 34, 'M', 'Lea', 'Michel', '1990-01-01', 'lea.michel10000@example.com', '0600000000', '$2y$10$dummyhash', 'CLIENT', false, NULL, NULL, NULL, NULL);
INSERT INTO client VALUES (55, 35, 'M', 'Sophie', 'Durand', '1990-01-01', 'sophie.durand10001@example.com', '0600000000', '$2y$10$dummyhash', 'CLIENT', false, NULL, NULL, NULL, NULL);
INSERT INTO client VALUES (56, 36, 'M', 'Lea', 'Richard', '1990-01-01', 'lea.richard10002@example.com', '0600000000', '$2y$10$dummyhash', 'CLIENT', false, NULL, NULL, NULL, NULL);
INSERT INTO client VALUES (57, 37, 'M', 'Marie', 'Petit', '1990-01-01', 'marie.petit10003@example.com', '0600000000', '$2y$10$dummyhash', 'CLIENT', false, NULL, NULL, NULL, NULL);
INSERT INTO client VALUES (58, 38, 'M', 'Sophie', 'David', '1990-01-01', 'sophie.david10004@example.com', '0600000000', '$2y$10$dummyhash', 'CLIENT', false, NULL, NULL, NULL, NULL);
INSERT INTO client VALUES (59, 39, 'M', 'Sophie', 'David', '1990-01-01', 'sophie.david10005@example.com', '0600000000', '$2y$10$dummyhash', 'CLIENT', false, NULL, NULL, NULL, NULL);
INSERT INTO client VALUES (60, 40, 'M', 'Pierre', 'Laurent', '1990-01-01', 'pierre.laurent10006@example.com', '0600000000', '$2y$10$dummyhash', 'CLIENT', false, NULL, NULL, NULL, NULL);
INSERT INTO client VALUES (61, 41, 'M', 'Marie', 'Dupont', '1990-01-01', 'marie.dupont10007@example.com', '0600000000', '$2y$10$dummyhash', 'CLIENT', false, NULL, NULL, NULL, NULL);
INSERT INTO client VALUES (62, 42, 'M', 'Chloé', 'Durand', '1990-01-01', 'chloé.durand10008@example.com', '0600000000', '$2y$10$dummyhash', 'CLIENT', false, NULL, NULL, NULL, NULL);
INSERT INTO client VALUES (63, 43, 'M', 'Paul', 'Durand', '1990-01-01', 'paul.durand10009@example.com', '0600000000', '$2y$10$dummyhash', 'CLIENT', false, NULL, NULL, NULL, NULL);
INSERT INTO client VALUES (64, 44, 'M', 'Lea', 'Simon', '1990-01-01', 'lea.simon10010@example.com', '0600000000', '$2y$10$dummyhash', 'CLIENT', false, NULL, NULL, NULL, NULL);
INSERT INTO client VALUES (65, 45, 'M', 'Chloé', 'Michel', '1990-01-01', 'chloé.michel10011@example.com', '0600000000', '$2y$10$dummyhash', 'CLIENT', false, NULL, NULL, NULL, NULL);
INSERT INTO client VALUES (66, 46, 'M', 'Paul', 'Richard', '1990-01-01', 'paul.richard10012@example.com', '0600000000', '$2y$10$dummyhash', 'CLIENT', false, NULL, NULL, NULL, NULL);
INSERT INTO client VALUES (67, 47, 'M', 'Marie', 'Bertrand', '1990-01-01', 'marie.bertrand10013@example.com', '0600000000', '$2y$10$dummyhash', 'CLIENT', false, NULL, NULL, NULL, NULL);
INSERT INTO client VALUES (68, 48, 'M', 'Manon', 'Bernard', '1990-01-01', 'manon.bernard10014@example.com', '0600000000', '$2y$10$dummyhash', 'CLIENT', false, NULL, NULL, NULL, NULL);
INSERT INTO client VALUES (69, 49, 'M', 'Chloé', 'David', '1990-01-01', 'chloé.david10015@example.com', '0600000000', '$2y$10$dummyhash', 'CLIENT', false, NULL, NULL, NULL, NULL);
INSERT INTO client VALUES (70, 50, 'M', 'Thomas', 'Martin', '1990-01-01', 'thomas.martin10016@example.com', '0600000000', '$2y$10$dummyhash', 'CLIENT', false, NULL, NULL, NULL, NULL);
INSERT INTO client VALUES (71, 51, 'M', 'Chloé', 'Richard', '1990-01-01', 'chloé.richard10017@example.com', '0600000000', '$2y$10$dummyhash', 'CLIENT', false, NULL, NULL, NULL, NULL);
INSERT INTO client VALUES (72, 52, 'M', 'Claire', 'Robert', '1990-01-01', 'claire.robert10018@example.com', '0600000000', '$2y$10$dummyhash', 'CLIENT', false, NULL, NULL, NULL, NULL);
INSERT INTO client VALUES (73, 53, 'M', 'Lea', 'Durand', '1990-01-01', 'lea.durand10019@example.com', '0600000000', '$2y$10$dummyhash', 'CLIENT', false, NULL, NULL, NULL, NULL);
INSERT INTO client VALUES (74, 1, 'M', 'Jacques', 'Petit', '1990-01-01', 'jacques.petit10020@example.com', '0600000000', '$2y$10$dummyhash', 'CLIENT', false, NULL, NULL, NULL, NULL);
INSERT INTO client VALUES (75, 2, 'M', 'Jacques', 'Robert', '1990-01-01', 'jacques.robert10021@example.com', '0600000000', '$2y$10$dummyhash', 'CLIENT', false, NULL, NULL, NULL, NULL);
INSERT INTO client VALUES (76, 3, 'M', 'Lucas', 'Laurent', '1990-01-01', 'lucas.laurent10022@example.com', '0600000000', '$2y$10$dummyhash', 'CLIENT', false, NULL, NULL, NULL, NULL);
INSERT INTO client VALUES (77, 4, 'M', 'Sophie', 'Martin', '1990-01-01', 'sophie.martin10023@example.com', '0600000000', '$2y$10$dummyhash', 'CLIENT', false, NULL, NULL, NULL, NULL);
INSERT INTO client VALUES (78, 5, 'M', 'Emma', 'Bertrand', '1990-01-01', 'emma.bertrand10024@example.com', '0600000000', '$2y$10$dummyhash', 'CLIENT', false, NULL, NULL, NULL, NULL);
INSERT INTO client VALUES (79, 6, 'M', 'Sophie', 'Durand', '1990-01-01', 'sophie.durand10025@example.com', '0600000000', '$2y$10$dummyhash', 'CLIENT', false, NULL, NULL, NULL, NULL);
INSERT INTO client VALUES (80, 7, 'M', 'Emma', 'Garcia', '1990-01-01', 'emma.garcia10026@example.com', '0600000000', '$2y$10$dummyhash', 'CLIENT', false, NULL, NULL, NULL, NULL);
INSERT INTO client VALUES (81, 8, 'M', 'Manon', 'Bernard', '1990-01-01', 'manon.bernard10027@example.com', '0600000000', '$2y$10$dummyhash', 'CLIENT', false, NULL, NULL, NULL, NULL);
INSERT INTO client VALUES (82, 9, 'M', 'Nicolas', 'Petit', '1990-01-01', 'nicolas.petit10028@example.com', '0600000000', '$2y$10$dummyhash', 'CLIENT', false, NULL, NULL, NULL, NULL);
INSERT INTO client VALUES (83, 10, 'M', 'Julie', 'Garcia', '1990-01-01', 'julie.garcia10029@example.com', '0600000000', '$2y$10$dummyhash', 'CLIENT', false, NULL, NULL, NULL, NULL);
INSERT INTO client VALUES (84, 11, 'M', 'Chloé', 'Martin', '1990-01-01', 'chloé.martin10030@example.com', '0600000000', '$2y$10$dummyhash', 'CLIENT', false, NULL, NULL, NULL, NULL);
INSERT INTO client VALUES (85, 12, 'M', 'Thomas', 'David', '1990-01-01', 'thomas.david10031@example.com', '0600000000', '$2y$10$dummyhash', 'CLIENT', false, NULL, NULL, NULL, NULL);
INSERT INTO client VALUES (86, 13, 'M', 'Claire', 'Petit', '1990-01-01', 'claire.petit10032@example.com', '0600000000', '$2y$10$dummyhash', 'CLIENT', false, NULL, NULL, NULL, NULL);
INSERT INTO client VALUES (87, 14, 'M', 'Nicolas', 'Bertrand', '1990-01-01', 'nicolas.bertrand10033@example.com', '0600000000', '$2y$10$dummyhash', 'CLIENT', false, NULL, NULL, NULL, NULL);
INSERT INTO client VALUES (88, 15, 'M', 'Pierre', 'Bertrand', '1990-01-01', 'pierre.bertrand10034@example.com', '0600000000', '$2y$10$dummyhash', 'CLIENT', false, NULL, NULL, NULL, NULL);
INSERT INTO client VALUES (89, 16, 'M', 'Julie', 'Simon', '1990-01-01', 'julie.simon10035@example.com', '0600000000', '$2y$10$dummyhash', 'CLIENT', false, NULL, NULL, NULL, NULL);
INSERT INTO client VALUES (90, 17, 'M', 'Jean', 'Simon', '1990-01-01', 'jean.simon10036@example.com', '0600000000', '$2y$10$dummyhash', 'CLIENT', false, NULL, NULL, NULL, NULL);
INSERT INTO client VALUES (91, 18, 'M', 'Chloé', 'Robert', '1990-01-01', 'chloé.robert10037@example.com', '0600000000', '$2y$10$dummyhash', 'CLIENT', false, NULL, NULL, NULL, NULL);
INSERT INTO client VALUES (92, 19, 'M', 'Jacques', 'Garcia', '1990-01-01', 'jacques.garcia10038@example.com', '0600000000', '$2y$10$dummyhash', 'CLIENT', false, NULL, NULL, NULL, NULL);
INSERT INTO client VALUES (93, 20, 'M', 'Chloé', 'Robert', '1990-01-01', 'chloé.robert10039@example.com', '0600000000', '$2y$10$dummyhash', 'CLIENT', false, NULL, NULL, NULL, NULL);
INSERT INTO client VALUES (94, 21, 'M', 'Lea', 'Durand', '1990-01-01', 'lea.durand10040@example.com', '0600000000', '$2y$10$dummyhash', 'CLIENT', false, NULL, NULL, NULL, NULL);
INSERT INTO client VALUES (95, 22, 'M', 'Manon', 'Laurent', '1990-01-01', 'manon.laurent10041@example.com', '0600000000', '$2y$10$dummyhash', 'CLIENT', false, NULL, NULL, NULL, NULL);
INSERT INTO client VALUES (96, 23, 'M', 'Pierre', 'Richard', '1990-01-01', 'pierre.richard10042@example.com', '0600000000', '$2y$10$dummyhash', 'CLIENT', false, NULL, NULL, NULL, NULL);
INSERT INTO client VALUES (97, 24, 'M', 'Thomas', 'David', '1990-01-01', 'thomas.david10043@example.com', '0600000000', '$2y$10$dummyhash', 'CLIENT', false, NULL, NULL, NULL, NULL);
INSERT INTO client VALUES (98, 25, 'M', 'Thomas', 'Laurent', '1990-01-01', 'thomas.laurent10044@example.com', '0600000000', '$2y$10$dummyhash', 'CLIENT', false, NULL, NULL, NULL, NULL);
INSERT INTO client VALUES (99, 26, 'M', 'Jean', 'Laurent', '1990-01-01', 'jean.laurent10045@example.com', '0600000000', '$2y$10$dummyhash', 'CLIENT', false, NULL, NULL, NULL, NULL);
INSERT INTO client VALUES (100, 27, 'M', 'Emma', 'Michel', '1990-01-01', 'emma.michel10046@example.com', '0600000000', '$2y$10$dummyhash', 'CLIENT', false, NULL, NULL, NULL, NULL);
INSERT INTO client VALUES (101, 28, 'M', 'Claire', 'Durand', '1990-01-01', 'claire.durand10047@example.com', '0600000000', '$2y$10$dummyhash', 'CLIENT', false, NULL, NULL, NULL, NULL);
INSERT INTO client VALUES (102, 29, 'M', 'Sophie', 'Richard', '1990-01-01', 'sophie.richard10048@example.com', '0600000000', '$2y$10$dummyhash', 'CLIENT', false, NULL, NULL, NULL, NULL);
INSERT INTO client VALUES (103, 30, 'M', 'Lucas', 'Laurent', '1990-01-01', 'lucas.laurent10049@example.com', '0600000000', '$2y$10$dummyhash', 'CLIENT', false, NULL, NULL, NULL, NULL);
INSERT INTO client VALUES (104, 31, 'M', 'Sophie', 'Simon', '1990-01-01', 'sophie.simon10050@example.com', '0600000000', '$2y$10$dummyhash', 'CLIENT', false, NULL, NULL, NULL, NULL);
INSERT INTO client VALUES (105, 32, 'M', 'Julie', 'Petit', '1990-01-01', 'julie.petit10051@example.com', '0600000000', '$2y$10$dummyhash', 'CLIENT', false, NULL, NULL, NULL, NULL);
INSERT INTO client VALUES (106, 33, 'M', 'Sophie', 'Dupont', '1990-01-01', 'sophie.dupont10052@example.com', '0600000000', '$2y$10$dummyhash', 'CLIENT', false, NULL, NULL, NULL, NULL);
INSERT INTO client VALUES (107, 34, 'M', 'Nicolas', 'Bertrand', '1990-01-01', 'nicolas.bertrand10053@example.com', '0600000000', '$2y$10$dummyhash', 'CLIENT', false, NULL, NULL, NULL, NULL);
INSERT INTO client VALUES (108, 35, 'M', 'Nicolas', 'Robert', '1990-01-01', 'nicolas.robert10054@example.com', '0600000000', '$2y$10$dummyhash', 'CLIENT', false, NULL, NULL, NULL, NULL);
INSERT INTO client VALUES (109, 36, 'M', 'Julie', 'Petit', '1990-01-01', 'julie.petit10055@example.com', '0600000000', '$2y$10$dummyhash', 'CLIENT', false, NULL, NULL, NULL, NULL);
INSERT INTO client VALUES (110, 37, 'M', 'Sophie', 'Michel', '1990-01-01', 'sophie.michel10056@example.com', '0600000000', '$2y$10$dummyhash', 'CLIENT', false, NULL, NULL, NULL, NULL);
INSERT INTO client VALUES (111, 38, 'M', 'Julie', 'Bertrand', '1990-01-01', 'julie.bertrand10057@example.com', '0600000000', '$2y$10$dummyhash', 'CLIENT', false, NULL, NULL, NULL, NULL);
INSERT INTO client VALUES (112, 39, 'M', 'Julie', 'Richard', '1990-01-01', 'julie.richard10058@example.com', '0600000000', '$2y$10$dummyhash', 'CLIENT', false, NULL, NULL, NULL, NULL);
INSERT INTO client VALUES (113, 40, 'M', 'Chloé', 'Martin', '1990-01-01', 'chloé.martin10059@example.com', '0600000000', '$2y$10$dummyhash', 'CLIENT', false, NULL, NULL, NULL, NULL);
INSERT INTO client VALUES (114, 41, 'M', 'Claire', 'Martin', '1990-01-01', 'claire.martin10060@example.com', '0600000000', '$2y$10$dummyhash', 'CLIENT', false, NULL, NULL, NULL, NULL);
INSERT INTO client VALUES (115, 42, 'M', 'Manon', 'Martin', '1990-01-01', 'manon.martin10061@example.com', '0600000000', '$2y$10$dummyhash', 'CLIENT', false, NULL, NULL, NULL, NULL);
INSERT INTO client VALUES (116, 43, 'M', 'Emma', 'Michel', '1990-01-01', 'emma.michel10062@example.com', '0600000000', '$2y$10$dummyhash', 'CLIENT', false, NULL, NULL, NULL, NULL);
INSERT INTO client VALUES (117, 44, 'M', 'Lea', 'David', '1990-01-01', 'lea.david10063@example.com', '0600000000', '$2y$10$dummyhash', 'CLIENT', false, NULL, NULL, NULL, NULL);
INSERT INTO client VALUES (118, 45, 'M', 'Thomas', 'Bernard', '1990-01-01', 'thomas.bernard10064@example.com', '0600000000', '$2y$10$dummyhash', 'CLIENT', false, NULL, NULL, NULL, NULL);
INSERT INTO client VALUES (119, 46, 'M', 'Julie', 'David', '1990-01-01', 'julie.david10065@example.com', '0600000000', '$2y$10$dummyhash', 'CLIENT', false, NULL, NULL, NULL, NULL);
INSERT INTO client VALUES (120, 47, 'M', 'Julie', 'Dupont', '1990-01-01', 'julie.dupont10066@example.com', '0600000000', '$2y$10$dummyhash', 'CLIENT', false, NULL, NULL, NULL, NULL);
INSERT INTO client VALUES (121, 48, 'M', 'Pierre', 'Robert', '1990-01-01', 'pierre.robert10067@example.com', '0600000000', '$2y$10$dummyhash', 'CLIENT', false, NULL, NULL, NULL, NULL);
INSERT INTO client VALUES (122, 49, 'M', 'Manon', 'Simon', '1990-01-01', 'manon.simon10068@example.com', '0600000000', '$2y$10$dummyhash', 'CLIENT', false, NULL, NULL, NULL, NULL);
INSERT INTO client VALUES (123, 50, 'M', 'Manon', 'David', '1990-01-01', 'manon.david10069@example.com', '0600000000', '$2y$10$dummyhash', 'CLIENT', false, NULL, NULL, NULL, NULL);
INSERT INTO client VALUES (124, 51, 'M', 'Jacques', 'Laurent', '1990-01-01', 'jacques.laurent10070@example.com', '0600000000', '$2y$10$dummyhash', 'CLIENT', false, NULL, NULL, NULL, NULL);
INSERT INTO client VALUES (125, 52, 'M', 'Thomas', 'Durand', '1990-01-01', 'thomas.durand10071@example.com', '0600000000', '$2y$10$dummyhash', 'CLIENT', false, NULL, NULL, NULL, NULL);
INSERT INTO client VALUES (126, 53, 'M', 'Nicolas', 'Durand', '1990-01-01', 'nicolas.durand10072@example.com', '0600000000', '$2y$10$dummyhash', 'CLIENT', false, NULL, NULL, NULL, NULL);
INSERT INTO client VALUES (127, 1, 'M', 'Manon', 'Martin', '1990-01-01', 'manon.martin10073@example.com', '0600000000', '$2y$10$dummyhash', 'CLIENT', false, NULL, NULL, NULL, NULL);
INSERT INTO client VALUES (128, 2, 'M', 'Marie', 'Bernard', '1990-01-01', 'marie.bernard10074@example.com', '0600000000', '$2y$10$dummyhash', 'CLIENT', false, NULL, NULL, NULL, NULL);
INSERT INTO client VALUES (129, 3, 'M', 'Manon', 'Petit', '1990-01-01', 'manon.petit10075@example.com', '0600000000', '$2y$10$dummyhash', 'CLIENT', false, NULL, NULL, NULL, NULL);
INSERT INTO client VALUES (130, 4, 'M', 'Julie', 'Simon', '1990-01-01', 'julie.simon10076@example.com', '0600000000', '$2y$10$dummyhash', 'CLIENT', false, NULL, NULL, NULL, NULL);
INSERT INTO client VALUES (131, 5, 'M', 'Pierre', 'Richard', '1990-01-01', 'pierre.richard10077@example.com', '0600000000', '$2y$10$dummyhash', 'CLIENT', false, NULL, NULL, NULL, NULL);
INSERT INTO client VALUES (132, 6, 'M', 'Jacques', 'Robert', '1990-01-01', 'jacques.robert10078@example.com', '0600000000', '$2y$10$dummyhash', 'CLIENT', false, NULL, NULL, NULL, NULL);
INSERT INTO client VALUES (133, 7, 'M', 'Pierre', 'Laurent', '1990-01-01', 'pierre.laurent10079@example.com', '0600000000', '$2y$10$dummyhash', 'CLIENT', false, NULL, NULL, NULL, NULL);
INSERT INTO client VALUES (134, 8, 'M', 'Lea', 'Martin', '1990-01-01', 'lea.martin10080@example.com', '0600000000', '$2y$10$dummyhash', 'CLIENT', false, NULL, NULL, NULL, NULL);
INSERT INTO client VALUES (135, 9, 'M', 'Chloé', 'Richard', '1990-01-01', 'chloé.richard10081@example.com', '0600000000', '$2y$10$dummyhash', 'CLIENT', false, NULL, NULL, NULL, NULL);
INSERT INTO client VALUES (136, 10, 'M', 'Claire', 'Durand', '1990-01-01', 'claire.durand10082@example.com', '0600000000', '$2y$10$dummyhash', 'CLIENT', false, NULL, NULL, NULL, NULL);
INSERT INTO client VALUES (137, 11, 'M', 'Emma', 'Garcia', '1990-01-01', 'emma.garcia10083@example.com', '0600000000', '$2y$10$dummyhash', 'CLIENT', false, NULL, NULL, NULL, NULL);
INSERT INTO client VALUES (138, 12, 'M', 'Paul', 'Bernard', '1990-01-01', 'paul.bernard10084@example.com', '0600000000', '$2y$10$dummyhash', 'CLIENT', false, NULL, NULL, NULL, NULL);
INSERT INTO client VALUES (139, 13, 'M', 'Julie', 'Petit', '1990-01-01', 'julie.petit10085@example.com', '0600000000', '$2y$10$dummyhash', 'CLIENT', false, NULL, NULL, NULL, NULL);
INSERT INTO client VALUES (140, 14, 'M', 'Paul', 'Robert', '1990-01-01', 'paul.robert10086@example.com', '0600000000', '$2y$10$dummyhash', 'CLIENT', false, NULL, NULL, NULL, NULL);
INSERT INTO client VALUES (141, 15, 'M', 'Sophie', 'Richard', '1990-01-01', 'sophie.richard10087@example.com', '0600000000', '$2y$10$dummyhash', 'CLIENT', false, NULL, NULL, NULL, NULL);
INSERT INTO client VALUES (142, 16, 'M', 'Thomas', 'Garcia', '1990-01-01', 'thomas.garcia10088@example.com', '0600000000', '$2y$10$dummyhash', 'CLIENT', false, NULL, NULL, NULL, NULL);
INSERT INTO client VALUES (143, 17, 'M', 'Paul', 'Bertrand', '1990-01-01', 'paul.bertrand10089@example.com', '0600000000', '$2y$10$dummyhash', 'CLIENT', false, NULL, NULL, NULL, NULL);
INSERT INTO client VALUES (144, 18, 'M', 'Lea', 'Laurent', '1990-01-01', 'lea.laurent10090@example.com', '0600000000', '$2y$10$dummyhash', 'CLIENT', false, NULL, NULL, NULL, NULL);
INSERT INTO client VALUES (145, 19, 'M', 'Manon', 'David', '1990-01-01', 'manon.david10091@example.com', '0600000000', '$2y$10$dummyhash', 'CLIENT', false, NULL, NULL, NULL, NULL);
INSERT INTO client VALUES (146, 20, 'M', 'Nicolas', 'Bertrand', '1990-01-01', 'nicolas.bertrand10092@example.com', '0600000000', '$2y$10$dummyhash', 'CLIENT', false, NULL, NULL, NULL, NULL);
INSERT INTO client VALUES (147, 21, 'M', 'Chloé', 'Laurent', '1990-01-01', 'chloé.laurent10093@example.com', '0600000000', '$2y$10$dummyhash', 'CLIENT', false, NULL, NULL, NULL, NULL);
INSERT INTO client VALUES (148, 22, 'M', 'Sophie', 'Laurent', '1990-01-01', 'sophie.laurent10094@example.com', '0600000000', '$2y$10$dummyhash', 'CLIENT', false, NULL, NULL, NULL, NULL);
INSERT INTO client VALUES (149, 23, 'M', 'Marie', 'Dupont', '1990-01-01', 'marie.dupont10095@example.com', '0600000000', '$2y$10$dummyhash', 'CLIENT', false, NULL, NULL, NULL, NULL);
INSERT INTO client VALUES (150, 24, 'M', 'Paul', 'Petit', '1990-01-01', 'paul.petit10096@example.com', '0600000000', '$2y$10$dummyhash', 'CLIENT', false, NULL, NULL, NULL, NULL);
INSERT INTO client VALUES (151, 25, 'M', 'Julie', 'Michel', '1990-01-01', 'julie.michel10097@example.com', '0600000000', '$2y$10$dummyhash', 'CLIENT', false, NULL, NULL, NULL, NULL);
INSERT INTO client VALUES (152, 26, 'M', 'Lucas', 'Michel', '1990-01-01', 'lucas.michel10098@example.com', '0600000000', '$2y$10$dummyhash', 'CLIENT', false, NULL, NULL, NULL, NULL);
INSERT INTO client VALUES (153, 27, 'M', 'Lea', 'Bertrand', '1990-01-01', 'lea.bertrand10099@example.com', '0600000000', '$2y$10$dummyhash', 'CLIENT', false, NULL, NULL, NULL, NULL);

-- Utilisateurs
INSERT INTO utilisateur VALUES (1, 1, 'Dupont', 'Jean', 'jean.dupont@gmail.com', 'ww0EBwMC0f64lgysclhi0jgB+WCiGd+P/v4NZJTYA6WY2n8cu+JkksgneMex5lommdoex7ffec6EbdqT5/8owV0f1ckRi+R20w==', '0612345678', 'CLIENT');
INSERT INTO utilisateur VALUES (2, 2, 'Martin', 'Marie', 'marie.martin@gmail.com', 'ww0EBwMCTi9b7ug9zKFp0jgBGSn4DOH858H/RRIS0/Bhe+BRJe+CaYRl4mgkxbh7M3HUsn1+2rWoJ5qpwGytVHOBWjeDquhXtg==', '0798765432', 'CLIENT');
INSERT INTO utilisateur VALUES (3, 3, 'Bernard', 'Pierre', 'p.bernard@gmail.com', 'ww0EBwMCtsmidZSExhJo0jgBC77d1NylOGyAEAKc0xALlsOGJu8llJycwooIHS1MG9o7FZUzAVawdBwYtHqYSf3wzRnG+jZwvA==', '0611223344', 'CLIENT');
INSERT INTO utilisateur VALUES (4, 4, 'Dubois', 'Camille', 'camille.dubois@gmail.com', 'ww0EBwMC8Qmx2GQme69o0jgB/Gx9eDV8ULaG5s0rrynEbyR/L+mhK48Y1/YzOWTACilWzG25VbK8tRx3dPrQz1WjEPi5Vn1aYw==', '0755667788', 'CLIENT');
INSERT INTO utilisateur VALUES (5, 5, 'Thomas', 'Lucas', 'lucas.thomas@gmail.com', 'ww0EBwMCSWazHLdFrTpu0jgBy3yE/sdDr0VrW6+WltNlvsJ19RFY4eeDxWqN6LLqst9jwiCuymwtB106sEFxLlRC1ppj9WcFnQ==', '0621456789', 'CLIENT');
INSERT INTO utilisateur VALUES (6, 6, 'Robert', 'ChloÃ©', 'chloe.robert@gmail.com', 'ww0EBwMCSxCCL3fKoJBn0jgBxNCleZDfSVUi258TWljyjDLzOOw3QHVl7pWik5KK7YyI0DhXlIuCM+x6zTGKxxNUoNmBf1kAtQ==', '0750123456', 'CLIENT');
INSERT INTO utilisateur VALUES (7, 7, 'Richard', 'Alexandre', 'alex.richard@gmail.com', 'ww0EBwMC51eZcN5kAzN20jgB842Jx1aCVpcjOFuWgHemynkKaLavEg9IT9d6TZgQ8JbZ+vF3CqfcdyjojZX3IL0kKMVNjYm8CA==', '0661234567', 'CLIENT');
INSERT INTO utilisateur VALUES (8, 8, 'Petit', 'LÃ©a', 'lea.petit@gmail.com', 'ww0EBwMCCoNR1tlAzHx20jgBsLX6jlSLXIBaSAICBt0MAiwWf57X5L2hLyMdRjz3zVn/nSytT1aKnxZMNo5hPwG+zrmM4qbgVw==', '0793887766', 'CLIENT');
INSERT INTO utilisateur VALUES (9, 9, 'Durand', 'Antoine', 'antoine.durand@gmail.com', 'ww0EBwMCU5cGx/79JUJx0jgBitZ4+9B76W2dLOn01GEG6VEng4IwFWlS7MFD2Wiko+qqpltE0kpvyu/aFp8tvZYPl6CA9nJ3nA==', '0678112233', 'CLIENT');
INSERT INTO utilisateur VALUES (10, 10, 'Leroy', 'Manon', 'manon.leroy@gmail.com', 'ww0EBwMCZOvK3MrhABRs0jgB+980LPYfI44H3K+2aRAdN/phnDxYgsJdTQegh5mhXK9ha633lTLUYa7dgwZ7eTXvTGqYQsW5Pg==', '0745678901', 'CLIENT');
INSERT INTO utilisateur VALUES (11, 11, 'Moreau', 'Julien', 'julien.moreau@gmail.com', 'ww0EBwMCC/OtpFAgvIpw0jgBbXQcpr3ryaGAjdkEPITNFOicWc1kHY7CixIOq52LT18Xv7Jo+kfWAqET2k8W31VNwt2qQliI9g==', '0691223344', 'CLIENT');
INSERT INTO utilisateur VALUES (12, 12, 'Simon', 'Emma', 'emma.simon@gmail.com', 'ww0EBwMCtUCWPSYK27x30jgBMu+iG1OH/xyvu5NuXt/Ry1RJJM6apSJnV7BAzmRNigaWsYAWSDO8fZ7Im7AVwAQ1pVpL7iNbYg==', '0756112233', 'CLIENT');
INSERT INTO utilisateur VALUES (13, 13, 'Laurent', 'Nicolas', 'nicolas.laurent@gmail.com', 'ww0EBwMCYBrZcK9gPhZg0jgBUqbmIw2lCoPpC9CPZyDkijLIurZBUnGPwIPJZQKykxZ9awLfEJT2f8ilTQ5b7v8yiT83232csw==', '0620998877', 'CLIENT');
INSERT INTO utilisateur VALUES (14, 14, 'Michel', 'Alice', 'alice.michel@gmail.com', 'ww0EBwMCCd9MvV13x5pr0jgBDgYgSc3BBAnq5uPj6YDag00RKVr1cbeKZLGBeaNizVCTfrcNumFso3dsESSOyBOMTLB/abqWfA==', '0750987654', 'CLIENT');
INSERT INTO utilisateur VALUES (15, 15, 'Garcia', 'Hugo', 'hugo.garcia@gmail.com', 'ww0EBwMC95bMvTOYXiNl0jgBcQPvzsLj572McxTTF0aBi7xHgYID2Hg478TeS5LcLFNstNJJf8aX1ZXoFcy/PhuYWt5jXafvjg==', '0661987654', 'CLIENT');
INSERT INTO utilisateur VALUES (16, 16, 'Roux', 'Clara', 'clara.roux@gmail.com', 'ww0EBwMCT9+NJsdp03990jgBei4q1TASy/4v5D1A9Ii1XwmYWCQp/SYMx5ZGQ75swEBNRl1SU/JDrBI1SBUhaEEO5+S+/gEMHQ==', '0793123456', 'CLIENT');
INSERT INTO utilisateur VALUES (17, 17, 'Blanc', 'Thomas', 'thomas.blanc@gmail.com', 'ww0EBwMCG24y6MQ0/ZN10jgBEkE+aExZRGEMgv491CEh1XBYGOAKQzEMoxHw5trJOrRaL989Uftexc1/lxEl/4M///ZIz+7nbw==', '0742334455', 'CLIENT');
INSERT INTO utilisateur VALUES (18, 18, 'David', 'InÃ¨s', 'ines.david@gmail.com', 'ww0EBwMCwufxvGJx5XRi0jgBRqpbDZaWb5Xr3JiyCEyUpuSDglpMmJ2V3bPcppnHiLoQ6vj9JGjGXvFcCqxmgFS8ujzWAi7pJw==', '0691876543', 'CLIENT');
INSERT INTO utilisateur VALUES (19, 19, 'Bertrand', 'Maxime', 'maxime.bertrand@gmail.com', 'ww0EBwMC73ex9Uc5oxFk0jgB0seP9Kw2Gdm5ev3yxDqiEe02VuTRhkM3qe2nygypWBTdjZACgr0qkQstIqxR5QQqFH7Oyihs/w==', '0778234567', 'CLIENT');
INSERT INTO utilisateur VALUES (20, 20, 'Morel', 'Pauline', 'pauline.morel@gmail.com', 'ww0EBwMCF78PL/vQDyht0jgBnPVQqcalosr79kSTcbAD2Pt3f5I14MV4hWppU+9lRtJeNPf+2so29Y8MjWdm9CJKiEKpzvQJGg==', '0656234567', 'CLIENT');
INSERT INTO utilisateur VALUES (21, 21, 'ESF', 'Directeur', 'contact@esf.net', 'ww0EBwMCsdw6bmSR5a5u0jgB5b/xccyWrAaiZ9pxHHijvgX34H0JzKhciFRwToHjOSerbCfngJ0DH8NH+Fm1HYY611pUQDa98g==', '0479000000', 'PARTENAIRE');
INSERT INTO utilisateur VALUES (22, 22, 'Taxis', 'G7', 'pro@taxis.fr', 'ww0EBwMCpvn96c3m1eVh0jgB4eNdI8ip/Vn0SQ8IUb8N764YSfZsyZv42z2uP+MidSuib1YuL5Q6WxBN/QZWmHy7JWorZYw0IA==', '0472000000', 'PARTENAIRE');

-- Activites
INSERT INTO activite VALUES (1, 'Trapèze Volant', 'Cirque inclus', 0, 33);
INSERT INTO activite VALUES (2, 'Tir à l''arc', 'Inclus', 15, 18);
INSERT INTO activite VALUES (3, 'Tennis', 'Cours inclus', 25, 19);
INSERT INTO activite VALUES (4, 'Voile', 'Cours inclus', 0, 2);
INSERT INTO activite VALUES (5, 'Ski Nautique', 'Inclus', 0, 8);
INSERT INTO activite VALUES (7, 'Yoga', 'Inclus', 0, 23);
INSERT INTO activite VALUES (8, 'Kayak', 'Inclus', 15, 4);
INSERT INTO activite VALUES (9, 'Mini Club', 'Enfants', 50, 27);
INSERT INTO activite VALUES (10, 'Spectacles', 'Soirée', 0, 45);
INSERT INTO activite VALUES (11, 'Spa', 'Soin payant', 60, 21);
INSERT INTO activite VALUES (12, 'Excursion', 'Payant', 75, 13);
INSERT INTO activite VALUES (13, 'Plongée', 'Payant', 80, 1);
INSERT INTO activite VALUES (14, 'Golf', 'Payant', 0, 20);
INSERT INTO activite VALUES (15, 'Jet Ski', 'Payant', 120, 3);
INSERT INTO activite VALUES (16, 'Cheval', 'Payant', 0, 14);
INSERT INTO activite VALUES (17, 'Kitesurf', 'Payant', 100, 6);
INSERT INTO activite VALUES (18, 'Ski Privé', 'Payant', 150, 11);
INSERT INTO activite VALUES (21, 'Baby Club', 'Bébés', 0, 30);
INSERT INTO activite VALUES (22, 'Petit Chef', 'Cuisine', 30, 34);
INSERT INTO activite VALUES (23, 'Junior Club', 'Ados', 50, 31);
INSERT INTO activite VALUES (29, 'Soirées à Thème', 'Costumes et décors', 0, 1);

INSERT INTO activite VALUES (200, 'Zumba Beach', 'Danse latine sur la plage', 15, 50);
INSERT INTO activite VALUES (201, 'CrossFit Morning', 'Entraînement intensif matinal', 40, 50);
INSERT INTO activite VALUES (202, 'Atelier Cocktail', 'Création de cocktails signature', 0, 34);
INSERT INTO activite VALUES (203, 'Yoga Vinyasa', 'Yoga dynamique', 20, 23);
INSERT INTO activite VALUES (204, 'Soirée Blanche', 'Dress code blanc exigé', 30, 40);
INSERT INTO activite VALUES (205, 'Cours de Salsa', 'Initiation danse cubaine', 0, 40);
INSERT INTO activite VALUES (206, 'Dégustation Vins', 'Tour de France des vignobles', 0, 35);
INSERT INTO activite VALUES (207, 'Paddle Yoga', 'Yoga sur une planche de paddle', 20, 7);
INSERT INTO activite VALUES (208, 'Massage Balinais', 'Soin relaxant 1h', 0, 25);
INSERT INTO activite VALUES (209, 'Rando Glaciaire', 'Marche avec crampons', 0, 11);
INSERT INTO activite VALUES (210, 'Tournoi Poker', 'Soirée casino fictif', 20, 39);
INSERT INTO activite VALUES (211, 'Aquabike', 'Vélo dans la piscine', 20, 50);
INSERT INTO activite VALUES (212, 'Initiation Golf', 'Sur le practice', 0, 20);
INSERT INTO activite VALUES (213, 'Parcours 18 trous', 'Green fee inclus', 0, 20);
INSERT INTO activite VALUES (214, 'Plongée Épave', 'Niveau 2 requis', 0, 1);
INSERT INTO activite VALUES (215, 'Atelier Sushi', 'Apprenez à rouler vos makis', 0, 34);
INSERT INTO activite VALUES (216, 'Pilates Mat', 'Renforcement profond', 20, 50);
INSERT INTO activite VALUES (217, 'Boxe Thaï', 'Cardio boxing', 40, 50);
INSERT INTO activite VALUES (218, 'Sortie Catamaran', 'Navigation côtière', 35, 9);
INSERT INTO activite VALUES (219, 'Jet Ski Tour', 'Randonnée 1h', 0, 3);
INSERT INTO activite VALUES (220, 'Parasailing', 'Parachute ascensionnel', 0, 8);
INSERT INTO activite VALUES (221, 'Tennis Tournoi', 'Compétition amicale', 0, 19);
INSERT INTO activite VALUES (222, 'Tir à l''arc Pro', 'Distance olympique', 0, 18);
INSERT INTO activite VALUES (223, 'Escalade Falaise', 'Sortie naturelle', 0, 17);
INSERT INTO activite VALUES (224, 'Via Ferrata', 'Parcours vertigineux', 0, 17);
INSERT INTO activite VALUES (225, 'VTT Descente', 'Pistes noires', 0, 12);
INSERT INTO activite VALUES (226, 'Canyoning', 'Sauts et toboggans', 0, 16);
INSERT INTO activite VALUES (227, 'Cours Photo', 'Maîtriser son reflex', 0, 36);
INSERT INTO activite VALUES (228, 'Peinture sur Soie', 'Artisanat local', 0, 37);
INSERT INTO activite VALUES (229, 'Céramique', 'Tour de potier', 0, 37);
INSERT INTO activite VALUES (230, 'Café Théâtre', 'Spectacle humoristique', 0, 44);
INSERT INTO activite VALUES (231, 'Concert Jazz', 'Live music au bar', 0, 41);
INSERT INTO activite VALUES (232, 'Méditation Zen', 'Au jardin japonais', 0, 26);
INSERT INTO activite VALUES (233, 'Tai Chi', 'Gymnastique douce', 0, 26);
INSERT INTO activite VALUES (234, 'Stretching', 'Étirements guidés', 0, 26);
INSERT INTO activite VALUES (235, 'Volley Beach', 'Tournoi 4x4', 0, 47);
INSERT INTO activite VALUES (236, 'Foot 5x5', 'Sur terrain synthétique', 0, 46);
INSERT INTO activite VALUES (237, 'Basket 3x3', 'Tournoi urbain', 0, 48);
INSERT INTO activite VALUES (238, 'Water Polo', 'Match en piscine', 0, 49);
INSERT INTO activite VALUES (239, 'Cours Italien', 'Bases de la langue', 0, 38);
INSERT INTO activite VALUES (240, 'Conférence Histoire', 'Culture locale', 0, 38);
INSERT INTO activite VALUES (241, 'Excursion Volcan', 'Journée complète', 0, 11);
INSERT INTO activite VALUES (242, 'Quad Safari', 'Découverte des dunes', 0, 15);
INSERT INTO activite VALUES (243, 'Pêche au Gros', 'Sortie en mer', 0, 5);
INSERT INTO activite VALUES (244, 'Soin Visage', 'Produits marins', 0, 21);
INSERT INTO activite VALUES (245, 'Gommage Corps', 'Au sable noir', 0, 21);
INSERT INTO activite VALUES (246, 'Sauna Infrarouge', 'Séance 30min', 0, 22);
INSERT INTO activite VALUES (247, 'Hammam Tradition', 'Rituel complet', 0, 22);
INSERT INTO activite VALUES (248, 'Cours de Chant', 'Technique vocale', 0, 45);
INSERT INTO activite VALUES (249, 'Danse Orientale', 'Initiation', 0, 40);

INSERT INTO activite VALUES (300, 'Peinture Doigts', 'Art pour les petits', 0, 27);
INSERT INTO activite VALUES (301, 'Sieste Contée', 'Histoires calmes', 0, 27);
INSERT INTO activite VALUES (302, 'Promenade Poussette', 'Balade au parc', 0, 30);
INSERT INTO activite VALUES (303, 'Eveil Musical', 'Découverte instruments', 0, 27);
INSERT INTO activite VALUES (304, 'Parcours Motricité', 'Gym pour bébés', 0, 30);
INSERT INTO activite VALUES (305, 'Pâte à Sel', 'Création de formes', 0, 27);
INSERT INTO activite VALUES (306, 'Chansons Comptines', 'Rondes enfantines', 0, 27);
INSERT INTO activite VALUES (307, 'Bain de Boules', 'Jeu en sécurité', 0, 27);
INSERT INTO activite VALUES (308, 'Mini Marionnettes', 'Spectacle doudou', 0, 28);
INSERT INTO activite VALUES (309, 'Découverte Sensorielle', 'Toucher et écouter', 0, 28);
INSERT INTO activite VALUES (310, 'Mini Foot', 'Initiation ballon', 0, 28);
INSERT INTO activite VALUES (311, 'Chasse au Trésor', 'Carte et indices', 0, 28);
INSERT INTO activite VALUES (312, 'Atelier Chocolat', 'Cuisine gourmande', 0, 34);
INSERT INTO activite VALUES (313, 'Tir à l''arc Junior', 'Flèches ventouses', 0, 18);
INSERT INTO activite VALUES (314, 'Cirque Junior', 'Jonglage et équilibre', 0, 33);
INSERT INTO activite VALUES (315, 'Spectacle Enfants', 'Préparation du show', 0, 28);
INSERT INTO activite VALUES (316, 'Mini Disco', 'Danse avec la mascotte', 0, 28);
INSERT INTO activite VALUES (317, 'Piscine Jeux', 'Bataille d''eau', 0, 28);
INSERT INTO activite VALUES (318, 'Fabrication Masque', 'Atelier créatif', 0, 32);
INSERT INTO activite VALUES (319, 'Jardinage Bio', 'Planter des fraises', 0, 27);
INSERT INTO activite VALUES (320, 'Olympiades', 'Épreuves sportives', 0, 29);
INSERT INTO activite VALUES (321, 'Tennis Découverte', 'Balles mousses', 0, 19);
INSERT INTO activite VALUES (322, 'Roller Kids', 'Parcours en patins', 0, 29);
INSERT INTO activite VALUES (323, 'Dessin Manga', 'Apprendre à dessiner', 0, 32);
INSERT INTO activite VALUES (324, 'Château de Sable', 'Concours sur plage', 0, 29);
INSERT INTO activite VALUES (325, 'Tournoi FIFA', 'E-sport sur PS5', 0, 31);
INSERT INTO activite VALUES (326, 'Escape Game Ado', 'Énigmes à résoudre', 0, 31);
INSERT INTO activite VALUES (327, 'Stage DJ', 'Mixer sur platines', 0, 43);
INSERT INTO activite VALUES (328, 'Danse Hip-Hop', 'Chorégraphie urbaine', 0, 31);
INSERT INTO activite VALUES (329, 'Instagram Tour', 'Spot photo resort', 0, 36);
INSERT INTO activite VALUES (330, 'Wakeboard Ado', 'Tracté par bateau', 0, 8);
INSERT INTO activite VALUES (331, 'Catamaran Ado', 'Sortie en équipage', 0, 9);
INSERT INTO activite VALUES (332, 'Beach Party', 'Soirée sans parents', 0, 43);
INSERT INTO activite VALUES (333, 'Cinéma Ado', 'Blockbuster et Popcorn', 15, 45);
INSERT INTO activite VALUES (334, 'Graffiti Art', 'Fresque murale légale', 0, 32);
INSERT INTO activite VALUES (335, 'Montage Vidéo', 'Créer son vlog', 0, 31);
INSERT INTO activite VALUES (336, 'Volley Ado', 'Matchs classés', 0, 47);
INSERT INTO activite VALUES (337, 'Waterpolo Ado', 'Sport physique', 0, 49);
INSERT INTO activite VALUES (338, 'Kayak Aventure', 'Randonnée groupée', 0, 4);
INSERT INTO activite VALUES (339, 'Snorkeling Ado', 'Découverte récif', 0, 10);
INSERT INTO activite VALUES (340, 'Maquillage Scène', 'Pour le spectacle', 0, 24);
INSERT INTO activite VALUES (341, 'Costumerie', 'Essayage déguisements', 0, 37);
INSERT INTO activite VALUES (342, 'Magie Close-up', 'Apprendre des tours', 0, 42);
INSERT INTO activite VALUES (343, 'Science Amusante', 'Expériences chimiques', 0, 31);
INSERT INTO activite VALUES (344, 'Robotique Lego', 'Programmation simple', 0, 31);
INSERT INTO activite VALUES (345, 'Drone Pilotage', 'Parcours obstacles', 0, 31);
INSERT INTO activite VALUES (346, 'Karting Ado', 'Course sur circuit', 0, 15);
INSERT INTO activite VALUES (347, 'Paintball', 'Billes de peinture', 0, 29);
INSERT INTO activite VALUES (348, 'Laser Game', 'Dans la forêt', 0, 29);
INSERT INTO activite VALUES (349, 'Feu de Camp', 'Chamallows grillés', 0, 29);

-- Activites adultes
INSERT INTO activiteadulte VALUES (1, 27, 'Trapèze Volant', 'Cirque inclus', 20, 2.0, 18, 'Quotidien');
INSERT INTO activiteadulte VALUES (2, 36, 'Tir à l''arc', 'Inclus', 20, 2.0, 18, 'Quotidien');
INSERT INTO activiteadulte VALUES (3, 1, 'Tennis', 'Cours inclus', 20, 2.0, 18, 'Quotidien');
INSERT INTO activiteadulte VALUES (4, 31, 'Voile', 'Cours inclus', 20, 2.0, 18, 'Quotidien');
INSERT INTO activiteadulte VALUES (5, 21, 'Ski Nautique', 'Inclus', 20, 2.0, 18, 'Quotidien');
INSERT INTO activiteadulte VALUES (7, 3, 'Yoga', 'Inclus', 20, 2.0, 18, 'Quotidien');
INSERT INTO activiteadulte VALUES (8, 43, 'Kayak', 'Inclus', 20, 2.0, 18, 'Quotidien');
INSERT INTO activiteadulte VALUES (10, 25, 'Spectacles', 'Soirée', 20, 2.0, 18, 'Quotidien');
INSERT INTO activiteadulte VALUES (11, 23, 'Spa', 'Soin payant', 20, 2.0, 18, 'Quotidien');
INSERT INTO activiteadulte VALUES (12, 24, 'Excursion', 'Payant', 20, 2.0, 18, 'Quotidien');
INSERT INTO activiteadulte VALUES (13, 20, 'Plongée', 'Payant', 20, 2.0, 18, 'Quotidien');
INSERT INTO activiteadulte VALUES (14, 54, 'Golf', 'Payant', 20, 2.0, 18, 'Quotidien');
INSERT INTO activiteadulte VALUES (15, 21, 'Jet Ski', 'Payant', 20, 2.0, 18, 'Quotidien');
INSERT INTO activiteadulte VALUES (16, 22, 'Cheval', 'Payant', 20, 2.0, 18, 'Quotidien');
INSERT INTO activiteadulte VALUES (17, 55, 'Kitesurf', 'Payant', 20, 2.0, 18, 'Quotidien');
INSERT INTO activiteadulte VALUES (18, 38, 'Ski Privé', 'Payant', 20, 2.0, 18, 'Quotidien');
INSERT INTO activiteadulte VALUES (200, 5, 'Zumba Beach', 'Danse latine sur la plage', 20, 2.0, 18, 'Quotidien');
INSERT INTO activiteadulte VALUES (201, 29, 'CrossFit Morning', 'Entraînement intensif matinal', 20, 2.0, 18, 'Quotidien');
INSERT INTO activiteadulte VALUES (202, 9, 'Atelier Cocktail', 'Création de cocktails signature', 20, 2.0, 18, 'Hebdomadaire');
INSERT INTO activiteadulte VALUES (203, 3, 'Yoga Vinyasa', 'Yoga dynamique', 20, 2.0, 18, 'Quotidien');
INSERT INTO activiteadulte VALUES (204, 10, 'Soirée Blanche', 'Dress code blanc exigé', 20, 2.0, 18, 'Hebdomadaire');
INSERT INTO activiteadulte VALUES (205, 5, 'Cours de Salsa', 'Initiation danse cubaine', 20, 2.0, 18, 'Quotidien');
INSERT INTO activiteadulte VALUES (206, 53, 'Dégustation Vins', 'Tour de France des vignobles', 20, 2.0, 18, 'Hebdomadaire');
INSERT INTO activiteadulte VALUES (207, 49, 'Paddle Yoga', 'Yoga sur une planche de paddle', 20, 2.0, 18, 'Quotidien');
INSERT INTO activiteadulte VALUES (208, 46, 'Massage Balinais', 'Soin relaxant 1h', 60, 1.0, 18, 'Sur demande');
INSERT INTO activiteadulte VALUES (209, 15, 'Rando Glaciaire', 'Marche avec crampons', 50, 4.0, 18, 'Hebdomadaire');
INSERT INTO activiteadulte VALUES (210, 33, 'Tournoi Poker', 'Soirée casino fictif', 20, 3.0, 18, 'Hebdomadaire');
INSERT INTO activiteadulte VALUES (211, 2, 'Aquabike', 'Vélo dans la piscine', 20, 1.0, 18, 'Quotidien');
INSERT INTO activiteadulte VALUES (212, 54, 'Initiation Golf', 'Sur le practice', 0, 1.5, 18, 'Quotidien');
INSERT INTO activiteadulte VALUES (213, 54, 'Parcours 18 trous', 'Green fee inclus', 80, 4.0, 18, 'Sur demande');
INSERT INTO activiteadulte VALUES (214, 20, 'Plongée Épave', 'Niveau 2 requis', 80, 2.5, 18, 'Sur demande');
INSERT INTO activiteadulte VALUES (215, 9, 'Atelier Sushi', 'Apprenez à rouler vos makis', 30, 1.5, 18, 'Hebdomadaire');
INSERT INTO activiteadulte VALUES (216, 2, 'Pilates Mat', 'Renforcement profond', 20, 1.0, 18, 'Quotidien');
INSERT INTO activiteadulte VALUES (217, 18, 'Boxe Thaï', 'Cardio boxing', 20, 1.5, 18, 'Quotidien');
INSERT INTO activiteadulte VALUES (218, 31, 'Sortie Catamaran', 'Navigation côtière', 50, 3.0, 18, 'Quotidien');
INSERT INTO activiteadulte VALUES (219, 21, 'Jet Ski Tour', 'Randonnée 1h', 120, 1.0, 18, 'Sur demande');
INSERT INTO activiteadulte VALUES (220, 6, 'Parasailing', 'Parachute ascensionnel', 90, 0.5, 18, 'Sur demande');
INSERT INTO activiteadulte VALUES (221, 1, 'Tennis Tournoi', 'Compétition amicale', 0, 2.0, 18, 'Hebdomadaire');
INSERT INTO activiteadulte VALUES (222, 36, 'Tir à l''arc Pro', 'Distance olympique', 0, 1.5, 18, 'Quotidien');
INSERT INTO activiteadulte VALUES (223, 50, 'Escalade Falaise', 'Sortie naturelle', 40, 3.0, 18, 'Hebdomadaire');
INSERT INTO activiteadulte VALUES (224, 50, 'Via Ferrata', 'Parcours vertigineux', 50, 3.0, 18, 'Hebdomadaire');
INSERT INTO activiteadulte VALUES (225, 26, 'VTT Descente', 'Pistes noires', 40, 3.0, 18, 'Quotidien');
INSERT INTO activiteadulte VALUES (226, 7, 'Canyoning', 'Sauts et toboggans', 60, 3.0, 18, 'Hebdomadaire');
INSERT INTO activiteadulte VALUES (227, 19, 'Cours Photo', 'Maîtriser son reflex', 30, 2.0, 18, 'Hebdomadaire');
INSERT INTO activiteadulte VALUES (228, 4, 'Peinture sur Soie', 'Artisanat local', 25, 2.0, 18, 'Hebdomadaire');
INSERT INTO activiteadulte VALUES (229, 41, 'Céramique', 'Tour de potier', 30, 2.0, 18, 'Hebdomadaire');
INSERT INTO activiteadulte VALUES (230, 39, 'Café Théâtre', 'Spectacle humoristique', 0, 1.5, 18, 'Hebdomadaire');
INSERT INTO activiteadulte VALUES (231, 17, 'Concert Jazz', 'Live music au bar', 0, 2.0, 18, 'Hebdomadaire');
INSERT INTO activiteadulte VALUES (232, 16, 'Méditation Zen', 'Au jardin japonais', 0, 1.0, 18, 'Quotidien');
INSERT INTO activiteadulte VALUES (233, 16, 'Tai Chi', 'Gymnastique douce', 0, 1.0, 18, 'Quotidien');
INSERT INTO activiteadulte VALUES (234, 2, 'Stretching', 'Étirements guidés', 0, 1.0, 18, 'Quotidien');
INSERT INTO activiteadulte VALUES (235, 8, 'Volley Beach', 'Tournoi 4x4', 0, 2.0, 18, 'Quotidien');
INSERT INTO activiteadulte VALUES (236, 8, 'Foot 5x5', 'Sur terrain synthétique', 0, 1.0, 18, 'Quotidien');
INSERT INTO activiteadulte VALUES (237, 8, 'Basket 3x3', 'Tournoi urbain', 0, 1.0, 18, 'Quotidien');
INSERT INTO activiteadulte VALUES (238, 8, 'Water Polo', 'Match en piscine', 0, 1.0, 18, 'Quotidien');
INSERT INTO activiteadulte VALUES (239, 35, 'Cours Italien', 'Bases de la langue', 0, 1.0, 18, 'Quotidien');
INSERT INTO activiteadulte VALUES (240, 24, 'Conférence Histoire', 'Culture locale', 0, 1.5, 18, 'Hebdomadaire');
INSERT INTO activiteadulte VALUES (241, 24, 'Excursion Volcan', 'Journée complète', 100, 8.0, 18, 'Hebdomadaire');
INSERT INTO activiteadulte VALUES (242, 24, 'Quad Safari', 'Découverte des dunes', 80, 3.0, 18, 'Hebdomadaire');
INSERT INTO activiteadulte VALUES (243, 14, 'Pêche au Gros', 'Sortie en mer', 150, 4.0, 18, 'Sur demande');
INSERT INTO activiteadulte VALUES (244, 11, 'Soin Visage', 'Produits marins', 60, 1.0, 18, 'Sur demande');
INSERT INTO activiteadulte VALUES (245, 11, 'Gommage Corps', 'Au sable noir', 50, 0.5, 18, 'Sur demande');
INSERT INTO activiteadulte VALUES (246, 52, 'Sauna Infrarouge', 'Séance 30min', 0, 0.5, 18, 'Quotidien');
INSERT INTO activiteadulte VALUES (247, 52, 'Hammam Tradition', 'Rituel complet', 40, 1.0, 18, 'Quotidien');
INSERT INTO activiteadulte VALUES (248, 17, 'Cours de Chant', 'Technique vocale', 0, 1.0, 18, 'Hebdomadaire');
INSERT INTO activiteadulte VALUES (249, 5, 'Danse Orientale', 'Initiation', 0, 1.0, 18, 'Hebdomadaire');



-- Activites enfants
INSERT INTO activiteenfant VALUES (21, 1, 'Baby Club', 'Bébés', 50, 'Accueil 4 mois - 3 ans');
INSERT INTO activiteenfant VALUES (301, 1, 'Sieste Contée', 'Histoires calmes', 0, 'Repos encadré');
INSERT INTO activiteenfant VALUES (302, 1, 'Promenade Poussette', 'Balade au parc', 0, 'Sortie nature');
INSERT INTO activiteenfant VALUES (304, 1, 'Parcours Motricité', 'Gym pour bébés', 0, 'Eveil corporel');

INSERT INTO activiteenfant VALUES (9, 2, 'Mini Club', 'Enfants', 0, 'Jeux collectifs');
INSERT INTO activiteenfant VALUES (22, 2, 'Petit Chef', 'Cuisine', 0, 'Atelier culinaire');
INSERT INTO activiteenfant VALUES (300, 2, 'Peinture Doigts', 'Art pour les petits', 0, 'Créativité manuelle');
INSERT INTO activiteenfant VALUES (303, 2, 'Eveil Musical', 'Découverte instruments', 0, 'Musique et rythme');
INSERT INTO activiteenfant VALUES (305, 2, 'Pâte à Sel', 'Création de formes', 0, 'Sculpture facile');
INSERT INTO activiteenfant VALUES (306, 2, 'Chansons Comptines', 'Rondes enfantines', 0, 'Chant choral');
INSERT INTO activiteenfant VALUES (307, 2, 'Bain de Boules', 'Jeu en sécurité', 0, 'Espace ludique');
INSERT INTO activiteenfant VALUES (308, 2, 'Mini Marionnettes', 'Spectacle doudou', 0, 'Théâtre');
INSERT INTO activiteenfant VALUES (309, 2, 'Découverte Sensorielle', 'Toucher et écouter', 0, 'Eveil 5 sens');
INSERT INTO activiteenfant VALUES (310, 2, 'Mini Foot', 'Initiation ballon', 0, 'Sport équipe');
INSERT INTO activiteenfant VALUES (311, 2, 'Chasse au Trésor', 'Carte et indices', 0, 'Aventure parc');
INSERT INTO activiteenfant VALUES (312, 2, 'Atelier Chocolat', 'Cuisine gourmande', 15, 'Dégustation');
INSERT INTO activiteenfant VALUES (313, 2, 'Tir à l''arc Junior', 'Flèches ventouses', 0, 'Précision');
INSERT INTO activiteenfant VALUES (314, 2, 'Cirque Junior', 'Jonglage et équilibre', 0, 'Arts du cirque');
INSERT INTO activiteenfant VALUES (315, 2, 'Spectacle Enfants', 'Préparation du show', 0, 'Scène');
INSERT INTO activiteenfant VALUES (316, 2, 'Mini Disco', 'Danse avec la mascotte', 0, 'Soirée dansante');
INSERT INTO activiteenfant VALUES (317, 2, 'Piscine Jeux', 'Bataille d''eau', 0, 'Jeu aquatique');
INSERT INTO activiteenfant VALUES (318, 2, 'Fabrication Masque', 'Atelier créatif', 0, 'Déguisement');
INSERT INTO activiteenfant VALUES (319, 2, 'Jardinage Bio', 'Planter des fraises', 0, 'Nature');

INSERT INTO activiteenfant VALUES (23, 3, 'Junior Club', 'Ados', 0, 'QG des ados');
INSERT INTO activiteenfant VALUES (320, 3, 'Olympiades', 'Épreuves sportives', 0, 'Compétition');
INSERT INTO activiteenfant VALUES (321, 3, 'Tennis Découverte', 'Balles mousses', 0, 'Initiation');
INSERT INTO activiteenfant VALUES (322, 3, 'Roller Kids', 'Parcours en patins', 0, 'Glisse urbaine');
INSERT INTO activiteenfant VALUES (323, 3, 'Dessin Manga', 'Apprendre à dessiner', 0, 'Art japonais');
INSERT INTO activiteenfant VALUES (324, 3, 'Château de Sable', 'Concours sur plage', 0, 'Construction');
INSERT INTO activiteenfant VALUES (325, 3, 'Tournoi FIFA', 'E-sport sur PS5', 0, 'Gaming');
INSERT INTO activiteenfant VALUES (326, 3, 'Escape Game Ado', 'Énigmes à résoudre', 10, 'Réflexion');
INSERT INTO activiteenfant VALUES (327, 3, 'Stage DJ', 'Mixer sur platines', 20, 'Musique');
INSERT INTO activiteenfant VALUES (328, 3, 'Danse Hip-Hop', 'Chorégraphie urbaine', 0, 'Danse');
INSERT INTO activiteenfant VALUES (329, 3, 'Instagram Tour', 'Spot photo resort', 0, 'Réseaux sociaux');
INSERT INTO activiteenfant VALUES (330, 3, 'Wakeboard Ado', 'Tracté par bateau', 30, 'Glisse eau');
INSERT INTO activiteenfant VALUES (331, 3, 'Catamaran Ado', 'Sortie en équipage', 0, 'Voile');
INSERT INTO activiteenfant VALUES (332, 3, 'Beach Party', 'Soirée sans parents', 0, 'Fête');
INSERT INTO activiteenfant VALUES (333, 3, 'Cinéma Ado', 'Blockbuster et Popcorn', 0, 'Film');
INSERT INTO activiteenfant VALUES (334, 3, 'Graffiti Art', 'Fresque murale légale', 0, 'Street Art');
INSERT INTO activiteenfant VALUES (335, 3, 'Montage Vidéo', 'Créer son vlog', 0, 'Vidéo');
INSERT INTO activiteenfant VALUES (336, 3, 'Volley Ado', 'Matchs classés', 0, 'Sport plage');
INSERT INTO activiteenfant VALUES (337, 3, 'Waterpolo Ado', 'Sport physique', 0, 'Sport piscine');
INSERT INTO activiteenfant VALUES (338, 3, 'Kayak Aventure', 'Randonnée groupée', 0, 'Exploration');
INSERT INTO activiteenfant VALUES (339, 3, 'Snorkeling Ado', 'Découverte récif', 0, 'Mer');
INSERT INTO activiteenfant VALUES (340, 3, 'Maquillage Scène', 'Pour le spectacle', 0, 'Artiste');
INSERT INTO activiteenfant VALUES (341, 3, 'Costumerie', 'Essayage déguisements', 0, 'Mode');
INSERT INTO activiteenfant VALUES (342, 3, 'Magie Close-up', 'Apprendre des tours', 0, 'Illusion');
INSERT INTO activiteenfant VALUES (343, 3, 'Science Amusante', 'Expériences chimiques', 0, 'Découverte');
INSERT INTO activiteenfant VALUES (344, 3, 'Robotique Lego', 'Programmation simple', 0, 'Tech');
INSERT INTO activiteenfant VALUES (345, 3, 'Drone Pilotage', 'Parcours obstacles', 25, 'Pilotage');
INSERT INTO activiteenfant VALUES (346, 3, 'Karting Ado', 'Course sur circuit', 40, 'Vitesse');
INSERT INTO activiteenfant VALUES (347, 3, 'Paintball', 'Billes de peinture', 35, 'Action');
INSERT INTO activiteenfant VALUES (348, 3, 'Laser Game', 'Dans la forêt', 20, 'Stratégie');
INSERT INTO activiteenfant VALUES (349, 3, 'Feu de Camp', 'Chamallows grillés', 0, 'Convivialité');


-- Types chambres
INSERT INTO typechambre VALUES (1, 14, 'Supérieure', 28, 'Chambre confortable avec balcon et vue jardin.', 2, NULL, false);
INSERT INTO typechambre VALUES (2, 5, 'Deluxe', 35, 'Espace généreux avec coin salon et vue mer latérale.', 3, NULL, false);
INSERT INTO typechambre VALUES (3, 10, 'Suite', 55, 'Luxe et volupté avec chambre séparée et dressing.', 4, NULL, false);
INSERT INTO typechambre VALUES (4, 6, 'Familiale', 26, 'Deux espaces nuit distincts pour la tranquillité des parents.', 4, NULL, false);
INSERT INTO typechambre VALUES (5, 214, 'Bungalow Pilotis', 60.0, 'Accès direct au lagon turquoise depuis votre terrasse privée.', 2, 17, false);
INSERT INTO typechambre VALUES (6, 5, 'Chambre Standard', 25, 'Chambre confortable idéale pour le repos après la plage.', 2, 5, false);
INSERT INTO typechambre VALUES (7, 5, 'Chambre Deluxe', 35, 'Espace supérieur avec vue mer des Caraïbes.', 3, 5, false);
INSERT INTO typechambre VALUES (8, 5, 'Suite Exclusive', 55, 'Le summum du luxe avec jacuzzi sur la terrasse.', 4, 5, false);
INSERT INTO typechambre VALUES (9, 4, 'Chambre Standard', 25, 'Décoration balinaise traditionnelle et vue jardin zen.', 2, 19, false);
INSERT INTO typechambre VALUES (10, 201, 'Chambre Deluxe', 35, 'Espace supérieur avec terrasse en teck.', 3, 19, false);
INSERT INTO typechambre VALUES (11, 201, 'Suite Exclusive', 55, 'Suite privée avec accès piscine calme.', 4, 19, false);
INSERT INTO typechambre VALUES (12, 6, 'Chambre Standard', 25, 'Chambre lumineuse au cœur de la pinède.', 2, 38, false);
INSERT INTO typechambre VALUES (13, 202, 'Chambre Deluxe', 35, 'Vue imprenable sur la mer Egée.', 3, 38, false);
INSERT INTO typechambre VALUES (14, 202, 'Suite Exclusive', 55, 'Grand luxe avec services de conciergerie dédiés.', 4, 38, false);
INSERT INTO typechambre VALUES (15, 3, 'Chambre Standard', 25, 'Design italien moderne et confort absolu.', 2, 39, false);
INSERT INTO typechambre VALUES (16, 205, 'Chambre Deluxe', 35, 'Villetta privée nichée dans le rocher.', 3, 39, false);
INSERT INTO typechambre VALUES (17, 205, 'Suite Exclusive', 55, 'Vue panoramique sur la baie de Cefalu.', 4, 39, false);
INSERT INTO typechambre VALUES (18, 10, 'Chambre Standard', 25.0, 'Confort simple et efficace au cœur de l''Algarve.', 2, 41, false);
INSERT INTO typechambre VALUES (19, 208, 'Chambre Deluxe', 40.0, 'Vue golf et coin salon spacieux.', 3, 41, false);
INSERT INTO typechambre VALUES (20, 208, 'Suite Familiale', 65.0, 'Deux chambres séparées pour toute la famille.', 5, 41, false);
INSERT INTO typechambre VALUES (21, 10, 'Chambre Standard (Eco)', 25, 'Chambre confortable idéale pour le repos.', 2, 41, true);
INSERT INTO typechambre VALUES (22, 10, 'Chambre Deluxe (Vue)', 35, 'Espace supérieur avec services inclus.', 3, 41, false);
INSERT INTO typechambre VALUES (23, 10, 'Suite Exclusive (Top)', 55, 'Le summum du luxe et de l''espace.', 4, 41, false);
INSERT INTO typechambre VALUES (24, 9, 'Suite Royale', 50.0, 'Vue imprenable sur la mer Egée.', 4, 42, false);
INSERT INTO typechambre VALUES (25, 9, 'Chambre Standard', 25, 'Bungalow sous les oliviers.', 2, 42, true);
INSERT INTO typechambre VALUES (26, 210, 'Chambre Deluxe', 35, 'Accès direct à la plage de sable doré.', 3, 42, false);
INSERT INTO typechambre VALUES (27, 210, 'Suite Exclusive', 55, 'Terrasse privative et service en chambre.', 4, 42, false);

-- ============================================================
-- 1. TYPES DE CHAMBRES (Spécifiques par Club)
-- ============================================================


INSERT INTO typechambre VALUES (30, 237, 'Chambre Standard', 25, 'Confort et élégance.', 2, 1, false);
INSERT INTO typechambre VALUES (31, 237, 'Chambre Deluxe', 35, 'Vue imprenable et espace.', 3, 1, false);
INSERT INTO typechambre VALUES (32, 237, 'Suite Familiale', 50, 'Idéal pour les tribus.', 4, 1, false);
INSERT INTO typechambre VALUES (33, 246, 'Chambre Standard', 25, 'Confort et élégance.', 2, 2, false);
INSERT INTO typechambre VALUES (34, 246, 'Chambre Deluxe', 35, 'Vue imprenable et espace.', 3, 2, false);
INSERT INTO typechambre VALUES (35, 246, 'Suite Familiale', 50, 'Idéal pour les tribus.', 4, 2, false);
INSERT INTO typechambre VALUES (36, 228, 'Chambre Standard', 25, 'Confort et élégance.', 2, 3, false);
INSERT INTO typechambre VALUES (37, 228, 'Chambre Deluxe', 35, 'Vue imprenable et espace.', 3, 3, false);
INSERT INTO typechambre VALUES (38, 228, 'Suite Familiale', 50, 'Idéal pour les tribus.', 4, 3, false);
INSERT INTO typechambre VALUES (39, 232, 'Chambre Standard', 25, 'Confort et élégance.', 2, 4, false);
INSERT INTO typechambre VALUES (40, 232, 'Chambre Deluxe', 35, 'Vue imprenable et espace.', 3, 4, false);
INSERT INTO typechambre VALUES (41, 232, 'Suite Familiale', 50, 'Idéal pour les tribus.', 4, 4, false);
INSERT INTO typechambre VALUES (42, 230, 'Chambre Standard', 25, 'Confort et élégance.', 2, 6, false);
INSERT INTO typechambre VALUES (43, 230, 'Chambre Deluxe', 35, 'Vue imprenable et espace.', 3, 6, false);
INSERT INTO typechambre VALUES (44, 230, 'Suite Familiale', 50, 'Idéal pour les tribus.', 4, 6, false);
INSERT INTO typechambre VALUES (45, 204, 'Chambre Standard', 25, 'Confort et élégance.', 2, 7, false);
INSERT INTO typechambre VALUES (46, 204, 'Chambre Deluxe', 35, 'Vue imprenable et espace.', 3, 7, false);
INSERT INTO typechambre VALUES (47, 204, 'Suite Familiale', 50, 'Idéal pour les tribus.', 4, 7, false);
INSERT INTO typechambre VALUES (48, 225, 'Chambre Standard', 25, 'Confort et élégance.', 2, 8, false);
INSERT INTO typechambre VALUES (49, 225, 'Chambre Deluxe', 35, 'Vue imprenable et espace.', 3, 8, false);
INSERT INTO typechambre VALUES (50, 225, 'Suite Familiale', 50, 'Idéal pour les tribus.', 4, 8, false);
INSERT INTO typechambre VALUES (51, 227, 'Chambre Standard', 25, 'Confort et élégance.', 2, 9, false);
INSERT INTO typechambre VALUES (52, 227, 'Chambre Deluxe', 35, 'Vue imprenable et espace.', 3, 9, false);
INSERT INTO typechambre VALUES (53, 227, 'Suite Familiale', 50, 'Idéal pour les tribus.', 4, 9, false);
INSERT INTO typechambre VALUES (54, 217, 'Chambre Standard', 25, 'Confort et élégance.', 2, 10, false);
INSERT INTO typechambre VALUES (55, 217, 'Chambre Deluxe', 35, 'Vue imprenable et espace.', 3, 10, false);
INSERT INTO typechambre VALUES (56, 217, 'Suite Familiale', 50, 'Idéal pour les tribus.', 4, 10, false);
INSERT INTO typechambre VALUES (57, 219, 'Chambre Standard', 25, 'Confort et élégance.', 2, 11, false);
INSERT INTO typechambre VALUES (58, 219, 'Chambre Deluxe', 35, 'Vue imprenable et espace.', 3, 11, false);
INSERT INTO typechambre VALUES (59, 219, 'Suite Familiale', 50, 'Idéal pour les tribus.', 4, 11, false);
INSERT INTO typechambre VALUES (60, 231, 'Chambre Standard', 25, 'Confort et élégance.', 2, 12, false);
INSERT INTO typechambre VALUES (61, 231, 'Chambre Deluxe', 35, 'Vue imprenable et espace.', 3, 12, false);
INSERT INTO typechambre VALUES (62, 231, 'Suite Familiale', 50, 'Idéal pour les tribus.', 4, 12, false);
INSERT INTO typechambre VALUES (63, 236, 'Chambre Standard', 25, 'Confort et élégance.', 2, 13, false);
INSERT INTO typechambre VALUES (64, 236, 'Chambre Deluxe', 35, 'Vue imprenable et espace.', 3, 13, false);
INSERT INTO typechambre VALUES (65, 236, 'Suite Familiale', 50, 'Idéal pour les tribus.', 4, 13, false);
INSERT INTO typechambre VALUES (66, 226, 'Chambre Standard', 25, 'Confort et élégance.', 2, 14, false);
INSERT INTO typechambre VALUES (67, 226, 'Chambre Deluxe', 35, 'Vue imprenable et espace.', 3, 14, false);
INSERT INTO typechambre VALUES (68, 226, 'Suite Familiale', 50, 'Idéal pour les tribus.', 4, 14, false);
INSERT INTO typechambre VALUES (69, 218, 'Chambre Standard', 25, 'Confort et élégance.', 2, 15, false);
INSERT INTO typechambre VALUES (70, 218, 'Chambre Deluxe', 35, 'Vue imprenable et espace.', 3, 15, false);
INSERT INTO typechambre VALUES (71, 218, 'Suite Familiale', 50, 'Idéal pour les tribus.', 4, 15, false);
INSERT INTO typechambre VALUES (72, 221, 'Chambre Standard', 25, 'Confort et élégance.', 2, 16, false);
INSERT INTO typechambre VALUES (73, 221, 'Chambre Deluxe', 35, 'Vue imprenable et espace.', 3, 16, false);
INSERT INTO typechambre VALUES (74, 221, 'Suite Familiale', 50, 'Idéal pour les tribus.', 4, 16, false);
INSERT INTO typechambre VALUES (75, 222, 'Chambre Standard', 25, 'Confort et élégance.', 2, 18, false);
INSERT INTO typechambre VALUES (76, 222, 'Chambre Deluxe', 35, 'Vue imprenable et espace.', 3, 18, false);
INSERT INTO typechambre VALUES (77, 222, 'Suite Familiale', 50, 'Idéal pour les tribus.', 4, 18, false);
INSERT INTO typechambre VALUES (78, 206, 'Chambre Standard', 25, 'Confort et élégance.', 2, 20, false);
INSERT INTO typechambre VALUES (79, 206, 'Chambre Deluxe', 35, 'Vue imprenable et espace.', 3, 20, false);
INSERT INTO typechambre VALUES (80, 206, 'Suite Familiale', 50, 'Idéal pour les tribus.', 4, 20, false);
INSERT INTO typechambre VALUES (81, 211, 'Chambre Standard', 25, 'Confort et élégance.', 2, 21, false);
INSERT INTO typechambre VALUES (82, 211, 'Chambre Deluxe', 35, 'Vue imprenable et espace.', 3, 21, false);
INSERT INTO typechambre VALUES (83, 211, 'Suite Familiale', 50, 'Idéal pour les tribus.', 4, 21, false);
INSERT INTO typechambre VALUES (84, 240, 'Chambre Standard', 25, 'Confort et élégance.', 2, 22, false);
INSERT INTO typechambre VALUES (85, 240, 'Chambre Deluxe', 35, 'Vue imprenable et espace.', 3, 22, false);
INSERT INTO typechambre VALUES (86, 240, 'Suite Familiale', 50, 'Idéal pour les tribus.', 4, 22, false);
INSERT INTO typechambre VALUES (87, 213, 'Chambre Standard', 25, 'Confort et élégance.', 2, 23, false);
INSERT INTO typechambre VALUES (88, 213, 'Chambre Deluxe', 35, 'Vue imprenable et espace.', 3, 23, false);
INSERT INTO typechambre VALUES (89, 213, 'Suite Familiale', 50, 'Idéal pour les tribus.', 4, 23, false);
INSERT INTO typechambre VALUES (90, 239, 'Chambre Standard', 25, 'Confort et élégance.', 2, 24, false);
INSERT INTO typechambre VALUES (91, 239, 'Chambre Deluxe', 35, 'Vue imprenable et espace.', 3, 24, false);
INSERT INTO typechambre VALUES (92, 239, 'Suite Familiale', 50, 'Idéal pour les tribus.', 4, 24, false);
INSERT INTO typechambre VALUES (93, 243, 'Chambre Standard', 25, 'Confort et élégance.', 2, 25, false);
INSERT INTO typechambre VALUES (94, 243, 'Chambre Deluxe', 35, 'Vue imprenable et espace.', 3, 25, false);
INSERT INTO typechambre VALUES (95, 243, 'Suite Familiale', 50, 'Idéal pour les tribus.', 4, 25, false);
INSERT INTO typechambre VALUES (96, 245, 'Chambre Standard', 25, 'Confort et élégance.', 2, 26, false);
INSERT INTO typechambre VALUES (97, 245, 'Chambre Deluxe', 35, 'Vue imprenable et espace.', 3, 26, false);
INSERT INTO typechambre VALUES (98, 245, 'Suite Familiale', 50, 'Idéal pour les tribus.', 4, 26, false);
INSERT INTO typechambre VALUES (99, 200, 'Chambre Standard', 25, 'Confort et élégance.', 2, 27, false);
INSERT INTO typechambre VALUES (100, 200, 'Chambre Deluxe', 35, 'Vue imprenable et espace.', 3, 27, false);
INSERT INTO typechambre VALUES (101, 200, 'Suite Familiale', 50, 'Idéal pour les tribus.', 4, 27, false);
INSERT INTO typechambre VALUES (102, 220, 'Chambre Standard', 25, 'Confort et élégance.', 2, 28, false);
INSERT INTO typechambre VALUES (103, 220, 'Chambre Deluxe', 35, 'Vue imprenable et espace.', 3, 28, false);
INSERT INTO typechambre VALUES (104, 220, 'Suite Familiale', 50, 'Idéal pour les tribus.', 4, 28, false);
INSERT INTO typechambre VALUES (105, 209, 'Chambre Standard', 25, 'Confort et élégance.', 2, 29, false);
INSERT INTO typechambre VALUES (106, 209, 'Chambre Deluxe', 35, 'Vue imprenable et espace.', 3, 29, false);
INSERT INTO typechambre VALUES (107, 209, 'Suite Familiale', 50, 'Idéal pour les tribus.', 4, 29, false);
INSERT INTO typechambre VALUES (108, 244, 'Chambre Standard', 25, 'Confort et élégance.', 2, 30, false);
INSERT INTO typechambre VALUES (109, 244, 'Chambre Deluxe', 35, 'Vue imprenable et espace.', 3, 30, false);
INSERT INTO typechambre VALUES (110, 244, 'Suite Familiale', 50, 'Idéal pour les tribus.', 4, 30, false);
INSERT INTO typechambre VALUES (111, 229, 'Chambre Standard', 25, 'Confort et élégance.', 2, 31, false);
INSERT INTO typechambre VALUES (112, 229, 'Chambre Deluxe', 35, 'Vue imprenable et espace.', 3, 31, false);
INSERT INTO typechambre VALUES (113, 229, 'Suite Familiale', 50, 'Idéal pour les tribus.', 4, 31, false);
INSERT INTO typechambre VALUES (114, 248, 'Chambre Standard', 25, 'Confort et élégance.', 2, 32, false);
INSERT INTO typechambre VALUES (115, 248, 'Chambre Deluxe', 35, 'Vue imprenable et espace.', 3, 32, false);
INSERT INTO typechambre VALUES (116, 248, 'Suite Familiale', 50, 'Idéal pour les tribus.', 4, 32, false);
INSERT INTO typechambre VALUES (117, 231, 'Chambre Standard', 25, 'Confort et élégance.', 2, 33, false);
INSERT INTO typechambre VALUES (118, 231, 'Chambre Deluxe', 35, 'Vue imprenable et espace.', 3, 33, false);
INSERT INTO typechambre VALUES (119, 231, 'Suite Familiale', 50, 'Idéal pour les tribus.', 4, 33, false);
INSERT INTO typechambre VALUES (120, 215, 'Chambre Standard', 25, 'Confort et élégance.', 2, 34, false);
INSERT INTO typechambre VALUES (121, 215, 'Chambre Deluxe', 35, 'Vue imprenable et espace.', 3, 34, false);
INSERT INTO typechambre VALUES (122, 215, 'Suite Familiale', 50, 'Idéal pour les tribus.', 4, 34, false);
INSERT INTO typechambre VALUES (123, 235, 'Chambre Standard', 25, 'Confort et élégance.', 2, 35, false);
INSERT INTO typechambre VALUES (124, 235, 'Chambre Deluxe', 35, 'Vue imprenable et espace.', 3, 35, false);
INSERT INTO typechambre VALUES (125, 235, 'Suite Familiale', 50, 'Idéal pour les tribus.', 4, 35, false);
INSERT INTO typechambre VALUES (126, 233, 'Chambre Standard', 25, 'Confort et élégance.', 2, 36, false);
INSERT INTO typechambre VALUES (127, 233, 'Chambre Deluxe', 35, 'Vue imprenable et espace.', 3, 36, false);
INSERT INTO typechambre VALUES (128, 233, 'Suite Familiale', 50, 'Idéal pour les tribus.', 4, 36, false);
INSERT INTO typechambre VALUES (129, 238, 'Chambre Standard', 25, 'Confort et élégance.', 2, 37, false);
INSERT INTO typechambre VALUES (130, 238, 'Chambre Deluxe', 35, 'Vue imprenable et espace.', 3, 37, false);
INSERT INTO typechambre VALUES (131, 238, 'Suite Familiale', 50, 'Idéal pour les tribus.', 4, 37, false);
INSERT INTO typechambre VALUES (132, 224, 'Chambre Standard', 25, 'Confort et élégance.', 2, 40, false);
INSERT INTO typechambre VALUES (133, 224, 'Chambre Deluxe', 35, 'Vue imprenable et espace.', 3, 40, false);
INSERT INTO typechambre VALUES (134, 224, 'Suite Familiale', 50, 'Idéal pour les tribus.', 4, 40, false);
INSERT INTO typechambre VALUES (135, 207, 'Chambre Standard', 25, 'Confort et élégance.', 2, 43, false);
INSERT INTO typechambre VALUES (136, 207, 'Chambre Deluxe', 35, 'Vue imprenable et espace.', 3, 43, false);
INSERT INTO typechambre VALUES (137, 207, 'Suite Familiale', 50, 'Idéal pour les tribus.', 4, 43, false);
INSERT INTO typechambre VALUES (138, 242, 'Chambre Standard', 25, 'Confort et élégance.', 2, 44, false);
INSERT INTO typechambre VALUES (139, 242, 'Chambre Deluxe', 35, 'Vue imprenable et espace.', 3, 44, false);
INSERT INTO typechambre VALUES (140, 242, 'Suite Familiale', 50, 'Idéal pour les tribus.', 4, 44, false);
INSERT INTO typechambre VALUES (141, 212, 'Chambre Standard', 25, 'Confort et élégance.', 2, 45, false);
INSERT INTO typechambre VALUES (142, 212, 'Chambre Deluxe', 35, 'Vue imprenable et espace.', 3, 45, false);
INSERT INTO typechambre VALUES (143, 212, 'Suite Familiale', 50, 'Idéal pour les tribus.', 4, 45, false);
INSERT INTO typechambre VALUES (144, 234, 'Chambre Standard', 25, 'Confort et élégance.', 2, 46, false);
INSERT INTO typechambre VALUES (145, 234, 'Chambre Deluxe', 35, 'Vue imprenable et espace.', 3, 46, false);
INSERT INTO typechambre VALUES (146, 234, 'Suite Familiale', 50, 'Idéal pour les tribus.', 4, 46, false);
INSERT INTO typechambre VALUES (147, 241, 'Chambre Standard', 25, 'Confort et élégance.', 2, 47, false);
INSERT INTO typechambre VALUES (148, 241, 'Chambre Deluxe', 35, 'Vue imprenable et espace.', 3, 47, false);
INSERT INTO typechambre VALUES (149, 241, 'Suite Familiale', 50, 'Idéal pour les tribus.', 4, 47, false);
INSERT INTO typechambre VALUES (150, 247, 'Chambre Standard', 25, 'Confort et élégance.', 2, 48, false);
INSERT INTO typechambre VALUES (151, 247, 'Chambre Deluxe', 35, 'Vue imprenable et espace.', 3, 48, false);
INSERT INTO typechambre VALUES (152, 247, 'Suite Familiale', 50, 'Idéal pour les tribus.', 4, 48, false);
INSERT INTO typechambre VALUES (153, 216, 'Chambre Standard', 25, 'Confort et élégance.', 2, 49, false);
INSERT INTO typechambre VALUES (154, 216, 'Chambre Deluxe', 35, 'Vue imprenable et espace.', 3, 49, false);
INSERT INTO typechambre VALUES (155, 216, 'Suite Familiale', 50, 'Idéal pour les tribus.', 4, 49, false);
INSERT INTO typechambre VALUES (156, 223, 'Chambre Standard', 25, 'Confort et élégance.', 2, 50, false);
INSERT INTO typechambre VALUES (157, 223, 'Chambre Deluxe', 35, 'Vue imprenable et espace.', 3, 50, false);
INSERT INTO typechambre VALUES (158, 223, 'Suite Familiale', 50, 'Idéal pour les tribus.', 4, 50, false);

-- Chambres & LIAISON club_chambre
INSERT INTO chambre VALUES (1, 30); INSERT INTO club_chambre VALUES (1, 1);
INSERT INTO chambre VALUES (2, 31); INSERT INTO club_chambre VALUES (1, 2);
INSERT INTO chambre VALUES (3, 32); INSERT INTO club_chambre VALUES (1, 3);
INSERT INTO chambre VALUES (4, 30); INSERT INTO club_chambre VALUES (1, 4);
INSERT INTO chambre VALUES (5, 31); INSERT INTO club_chambre VALUES (1, 5);
INSERT INTO chambre VALUES (6, 32); INSERT INTO club_chambre VALUES (1, 6);
INSERT INTO chambre VALUES (7, 30); INSERT INTO club_chambre VALUES (1, 7);
INSERT INTO chambre VALUES (8, 31); INSERT INTO club_chambre VALUES (1, 8);
INSERT INTO chambre VALUES (9, 32); INSERT INTO club_chambre VALUES (1, 9);
INSERT INTO chambre VALUES (10, 30); INSERT INTO club_chambre VALUES (1, 10);

INSERT INTO chambre VALUES (11, 33); INSERT INTO club_chambre VALUES (2, 11);
INSERT INTO chambre VALUES (12, 34); INSERT INTO club_chambre VALUES (2, 12);
INSERT INTO chambre VALUES (13, 35); INSERT INTO club_chambre VALUES (2, 13);
INSERT INTO chambre VALUES (14, 33); INSERT INTO club_chambre VALUES (2, 14);
INSERT INTO chambre VALUES (15, 34); INSERT INTO club_chambre VALUES (2, 15);
INSERT INTO chambre VALUES (16, 35); INSERT INTO club_chambre VALUES (2, 16);
INSERT INTO chambre VALUES (17, 33); INSERT INTO club_chambre VALUES (2, 17);
INSERT INTO chambre VALUES (18, 34); INSERT INTO club_chambre VALUES (2, 18);
INSERT INTO chambre VALUES (19, 35); INSERT INTO club_chambre VALUES (2, 19);
INSERT INTO chambre VALUES (20, 33); INSERT INTO club_chambre VALUES (2, 20);

INSERT INTO chambre VALUES (21, 36); INSERT INTO club_chambre VALUES (3, 21);
INSERT INTO chambre VALUES (22, 37); INSERT INTO club_chambre VALUES (3, 22);
INSERT INTO chambre VALUES (23, 38); INSERT INTO club_chambre VALUES (3, 23);
INSERT INTO chambre VALUES (24, 36); INSERT INTO club_chambre VALUES (3, 24);
INSERT INTO chambre VALUES (25, 37); INSERT INTO club_chambre VALUES (3, 25);
INSERT INTO chambre VALUES (26, 38); INSERT INTO club_chambre VALUES (3, 26);
INSERT INTO chambre VALUES (27, 36); INSERT INTO club_chambre VALUES (3, 27);
INSERT INTO chambre VALUES (28, 37); INSERT INTO club_chambre VALUES (3, 28);
INSERT INTO chambre VALUES (29, 38); INSERT INTO club_chambre VALUES (3, 29);
INSERT INTO chambre VALUES (30, 36); INSERT INTO club_chambre VALUES (3, 30);

INSERT INTO chambre VALUES (31, 39); INSERT INTO club_chambre VALUES (4, 31);
INSERT INTO chambre VALUES (32, 40); INSERT INTO club_chambre VALUES (4, 32);
INSERT INTO chambre VALUES (33, 41); INSERT INTO club_chambre VALUES (4, 33);
INSERT INTO chambre VALUES (34, 39); INSERT INTO club_chambre VALUES (4, 34);
INSERT INTO chambre VALUES (35, 40); INSERT INTO club_chambre VALUES (4, 35);
INSERT INTO chambre VALUES (36, 41); INSERT INTO club_chambre VALUES (4, 36);
INSERT INTO chambre VALUES (37, 39); INSERT INTO club_chambre VALUES (4, 37);
INSERT INTO chambre VALUES (38, 40); INSERT INTO club_chambre VALUES (4, 38);
INSERT INTO chambre VALUES (39, 41); INSERT INTO club_chambre VALUES (4, 39);
INSERT INTO chambre VALUES (40, 39); INSERT INTO club_chambre VALUES (4, 40);

INSERT INTO chambre VALUES (41, 6); INSERT INTO club_chambre VALUES (5, 41);
INSERT INTO chambre VALUES (42, 7); INSERT INTO club_chambre VALUES (5, 42);
INSERT INTO chambre VALUES (43, 8); INSERT INTO club_chambre VALUES (5, 43);
INSERT INTO chambre VALUES (44, 6); INSERT INTO club_chambre VALUES (5, 44);
INSERT INTO chambre VALUES (45, 7); INSERT INTO club_chambre VALUES (5, 45);
INSERT INTO chambre VALUES (46, 8); INSERT INTO club_chambre VALUES (5, 46);
INSERT INTO chambre VALUES (47, 6); INSERT INTO club_chambre VALUES (5, 47);
INSERT INTO chambre VALUES (48, 7); INSERT INTO club_chambre VALUES (5, 48);
INSERT INTO chambre VALUES (49, 8); INSERT INTO club_chambre VALUES (5, 49);
INSERT INTO chambre VALUES (50, 6); INSERT INTO club_chambre VALUES (5, 50);

INSERT INTO chambre VALUES (51, 42); INSERT INTO club_chambre VALUES (6, 51);
INSERT INTO chambre VALUES (52, 43); INSERT INTO club_chambre VALUES (6, 52);
INSERT INTO chambre VALUES (53, 44); INSERT INTO club_chambre VALUES (6, 53);
INSERT INTO chambre VALUES (54, 42); INSERT INTO club_chambre VALUES (6, 54);
INSERT INTO chambre VALUES (55, 43); INSERT INTO club_chambre VALUES (6, 55);
INSERT INTO chambre VALUES (56, 44); INSERT INTO club_chambre VALUES (6, 56);
INSERT INTO chambre VALUES (57, 42); INSERT INTO club_chambre VALUES (6, 57);
INSERT INTO chambre VALUES (58, 43); INSERT INTO club_chambre VALUES (6, 58);
INSERT INTO chambre VALUES (59, 44); INSERT INTO club_chambre VALUES (6, 59);
INSERT INTO chambre VALUES (60, 42); INSERT INTO club_chambre VALUES (6, 60);

INSERT INTO chambre VALUES (61, 45); INSERT INTO club_chambre VALUES (7, 61);
INSERT INTO chambre VALUES (62, 46); INSERT INTO club_chambre VALUES (7, 62);
INSERT INTO chambre VALUES (63, 47); INSERT INTO club_chambre VALUES (7, 63);
INSERT INTO chambre VALUES (64, 45); INSERT INTO club_chambre VALUES (7, 64);
INSERT INTO chambre VALUES (65, 46); INSERT INTO club_chambre VALUES (7, 65);
INSERT INTO chambre VALUES (66, 47); INSERT INTO club_chambre VALUES (7, 66);
INSERT INTO chambre VALUES (67, 45); INSERT INTO club_chambre VALUES (7, 67);
INSERT INTO chambre VALUES (68, 46); INSERT INTO club_chambre VALUES (7, 68);
INSERT INTO chambre VALUES (69, 47); INSERT INTO club_chambre VALUES (7, 69);
INSERT INTO chambre VALUES (70, 45); INSERT INTO club_chambre VALUES (7, 70);

INSERT INTO chambre VALUES (71, 48); INSERT INTO club_chambre VALUES (8, 71);
INSERT INTO chambre VALUES (72, 49); INSERT INTO club_chambre VALUES (8, 72);
INSERT INTO chambre VALUES (73, 50); INSERT INTO club_chambre VALUES (8, 73);
INSERT INTO chambre VALUES (74, 48); INSERT INTO club_chambre VALUES (8, 74);
INSERT INTO chambre VALUES (75, 49); INSERT INTO club_chambre VALUES (8, 75);
INSERT INTO chambre VALUES (76, 50); INSERT INTO club_chambre VALUES (8, 76);
INSERT INTO chambre VALUES (77, 48); INSERT INTO club_chambre VALUES (8, 77);
INSERT INTO chambre VALUES (78, 49); INSERT INTO club_chambre VALUES (8, 78);
INSERT INTO chambre VALUES (79, 50); INSERT INTO club_chambre VALUES (8, 79);
INSERT INTO chambre VALUES (80, 48); INSERT INTO club_chambre VALUES (8, 80);

INSERT INTO chambre VALUES (81, 51); INSERT INTO club_chambre VALUES (9, 81);
INSERT INTO chambre VALUES (82, 52); INSERT INTO club_chambre VALUES (9, 82);
INSERT INTO chambre VALUES (83, 53); INSERT INTO club_chambre VALUES (9, 83);
INSERT INTO chambre VALUES (84, 51); INSERT INTO club_chambre VALUES (9, 84);
INSERT INTO chambre VALUES (85, 52); INSERT INTO club_chambre VALUES (9, 85);
INSERT INTO chambre VALUES (86, 53); INSERT INTO club_chambre VALUES (9, 86);
INSERT INTO chambre VALUES (87, 51); INSERT INTO club_chambre VALUES (9, 87);
INSERT INTO chambre VALUES (88, 52); INSERT INTO club_chambre VALUES (9, 88);
INSERT INTO chambre VALUES (89, 53); INSERT INTO club_chambre VALUES (9, 89);
INSERT INTO chambre VALUES (90, 51); INSERT INTO club_chambre VALUES (9, 90);

INSERT INTO chambre VALUES (91, 54); INSERT INTO club_chambre VALUES (10, 91);
INSERT INTO chambre VALUES (92, 55); INSERT INTO club_chambre VALUES (10, 92);
INSERT INTO chambre VALUES (93, 56); INSERT INTO club_chambre VALUES (10, 93);
INSERT INTO chambre VALUES (94, 54); INSERT INTO club_chambre VALUES (10, 94);
INSERT INTO chambre VALUES (95, 55); INSERT INTO club_chambre VALUES (10, 95);
INSERT INTO chambre VALUES (96, 56); INSERT INTO club_chambre VALUES (10, 96);
INSERT INTO chambre VALUES (97, 54); INSERT INTO club_chambre VALUES (10, 97);
INSERT INTO chambre VALUES (98, 55); INSERT INTO club_chambre VALUES (10, 98);
INSERT INTO chambre VALUES (99, 56); INSERT INTO club_chambre VALUES (10, 99);
INSERT INTO chambre VALUES (100, 54); INSERT INTO club_chambre VALUES (10, 100);

INSERT INTO chambre VALUES (101, 57); INSERT INTO club_chambre VALUES (11, 101);
INSERT INTO chambre VALUES (102, 58); INSERT INTO club_chambre VALUES (11, 102);
INSERT INTO chambre VALUES (103, 59); INSERT INTO club_chambre VALUES (11, 103);
INSERT INTO chambre VALUES (104, 57); INSERT INTO club_chambre VALUES (11, 104);
INSERT INTO chambre VALUES (105, 58); INSERT INTO club_chambre VALUES (11, 105);
INSERT INTO chambre VALUES (106, 59); INSERT INTO club_chambre VALUES (11, 106);
INSERT INTO chambre VALUES (107, 57); INSERT INTO club_chambre VALUES (11, 107);
INSERT INTO chambre VALUES (108, 58); INSERT INTO club_chambre VALUES (11, 108);
INSERT INTO chambre VALUES (109, 59); INSERT INTO club_chambre VALUES (11, 109);
INSERT INTO chambre VALUES (110, 57); INSERT INTO club_chambre VALUES (11, 110);

INSERT INTO chambre VALUES (111, 60); INSERT INTO club_chambre VALUES (12, 111);
INSERT INTO chambre VALUES (112, 61); INSERT INTO club_chambre VALUES (12, 112);
INSERT INTO chambre VALUES (113, 62); INSERT INTO club_chambre VALUES (12, 113);
INSERT INTO chambre VALUES (114, 60); INSERT INTO club_chambre VALUES (12, 114);
INSERT INTO chambre VALUES (115, 61); INSERT INTO club_chambre VALUES (12, 115);
INSERT INTO chambre VALUES (116, 62); INSERT INTO club_chambre VALUES (12, 116);
INSERT INTO chambre VALUES (117, 60); INSERT INTO club_chambre VALUES (12, 117);
INSERT INTO chambre VALUES (118, 61); INSERT INTO club_chambre VALUES (12, 118);
INSERT INTO chambre VALUES (119, 62); INSERT INTO club_chambre VALUES (12, 119);
INSERT INTO chambre VALUES (120, 60); INSERT INTO club_chambre VALUES (12, 120);

INSERT INTO chambre VALUES (121, 63); INSERT INTO club_chambre VALUES (13, 121);
INSERT INTO chambre VALUES (122, 64); INSERT INTO club_chambre VALUES (13, 122);
INSERT INTO chambre VALUES (123, 65); INSERT INTO club_chambre VALUES (13, 123);
INSERT INTO chambre VALUES (124, 63); INSERT INTO club_chambre VALUES (13, 124);
INSERT INTO chambre VALUES (125, 64); INSERT INTO club_chambre VALUES (13, 125);
INSERT INTO chambre VALUES (126, 65); INSERT INTO club_chambre VALUES (13, 126);
INSERT INTO chambre VALUES (127, 63); INSERT INTO club_chambre VALUES (13, 127);
INSERT INTO chambre VALUES (128, 64); INSERT INTO club_chambre VALUES (13, 128);
INSERT INTO chambre VALUES (129, 65); INSERT INTO club_chambre VALUES (13, 129);
INSERT INTO chambre VALUES (130, 63); INSERT INTO club_chambre VALUES (13, 130);

INSERT INTO chambre VALUES (131, 66); INSERT INTO club_chambre VALUES (14, 131);
INSERT INTO chambre VALUES (132, 67); INSERT INTO club_chambre VALUES (14, 132);
INSERT INTO chambre VALUES (133, 68); INSERT INTO club_chambre VALUES (14, 133);
INSERT INTO chambre VALUES (134, 66); INSERT INTO club_chambre VALUES (14, 134);
INSERT INTO chambre VALUES (135, 67); INSERT INTO club_chambre VALUES (14, 135);
INSERT INTO chambre VALUES (136, 68); INSERT INTO club_chambre VALUES (14, 136);
INSERT INTO chambre VALUES (137, 66); INSERT INTO club_chambre VALUES (14, 137);
INSERT INTO chambre VALUES (138, 67); INSERT INTO club_chambre VALUES (14, 138);
INSERT INTO chambre VALUES (139, 68); INSERT INTO club_chambre VALUES (14, 139);
INSERT INTO chambre VALUES (140, 66); INSERT INTO club_chambre VALUES (14, 140);

INSERT INTO chambre VALUES (141, 69); INSERT INTO club_chambre VALUES (15, 141);
INSERT INTO chambre VALUES (142, 70); INSERT INTO club_chambre VALUES (15, 142);
INSERT INTO chambre VALUES (143, 71); INSERT INTO club_chambre VALUES (15, 143);
INSERT INTO chambre VALUES (144, 69); INSERT INTO club_chambre VALUES (15, 144);
INSERT INTO chambre VALUES (145, 70); INSERT INTO club_chambre VALUES (15, 145);
INSERT INTO chambre VALUES (146, 71); INSERT INTO club_chambre VALUES (15, 146);
INSERT INTO chambre VALUES (147, 69); INSERT INTO club_chambre VALUES (15, 147);
INSERT INTO chambre VALUES (148, 70); INSERT INTO club_chambre VALUES (15, 148);
INSERT INTO chambre VALUES (149, 71); INSERT INTO club_chambre VALUES (15, 149);
INSERT INTO chambre VALUES (150, 69); INSERT INTO club_chambre VALUES (15, 150);

INSERT INTO chambre VALUES (151, 72); INSERT INTO club_chambre VALUES (16, 151);
INSERT INTO chambre VALUES (152, 73); INSERT INTO club_chambre VALUES (16, 152);
INSERT INTO chambre VALUES (153, 74); INSERT INTO club_chambre VALUES (16, 153);
INSERT INTO chambre VALUES (154, 72); INSERT INTO club_chambre VALUES (16, 154);
INSERT INTO chambre VALUES (155, 73); INSERT INTO club_chambre VALUES (16, 155);
INSERT INTO chambre VALUES (156, 74); INSERT INTO club_chambre VALUES (16, 156);
INSERT INTO chambre VALUES (157, 72); INSERT INTO club_chambre VALUES (16, 157);
INSERT INTO chambre VALUES (158, 73); INSERT INTO club_chambre VALUES (16, 158);
INSERT INTO chambre VALUES (159, 74); INSERT INTO club_chambre VALUES (16, 159);
INSERT INTO chambre VALUES (160, 72); INSERT INTO club_chambre VALUES (16, 160);

INSERT INTO chambre VALUES (161, 5); INSERT INTO club_chambre VALUES (17, 161);
INSERT INTO chambre VALUES (162, 5); INSERT INTO club_chambre VALUES (17, 162);
INSERT INTO chambre VALUES (163, 5); INSERT INTO club_chambre VALUES (17, 163);
INSERT INTO chambre VALUES (164, 5); INSERT INTO club_chambre VALUES (17, 164);
INSERT INTO chambre VALUES (165, 5); INSERT INTO club_chambre VALUES (17, 165);
INSERT INTO chambre VALUES (166, 5); INSERT INTO club_chambre VALUES (17, 166);
INSERT INTO chambre VALUES (167, 5); INSERT INTO club_chambre VALUES (17, 167);
INSERT INTO chambre VALUES (168, 5); INSERT INTO club_chambre VALUES (17, 168);
INSERT INTO chambre VALUES (169, 5); INSERT INTO club_chambre VALUES (17, 169);
INSERT INTO chambre VALUES (170, 5); INSERT INTO club_chambre VALUES (17, 170);

INSERT INTO chambre VALUES (171, 75); INSERT INTO club_chambre VALUES (18, 171);
INSERT INTO chambre VALUES (172, 76); INSERT INTO club_chambre VALUES (18, 172);
INSERT INTO chambre VALUES (173, 77); INSERT INTO club_chambre VALUES (18, 173);
INSERT INTO chambre VALUES (174, 75); INSERT INTO club_chambre VALUES (18, 174);
INSERT INTO chambre VALUES (175, 76); INSERT INTO club_chambre VALUES (18, 175);
INSERT INTO chambre VALUES (176, 77); INSERT INTO club_chambre VALUES (18, 176);
INSERT INTO chambre VALUES (177, 75); INSERT INTO club_chambre VALUES (18, 177);
INSERT INTO chambre VALUES (178, 76); INSERT INTO club_chambre VALUES (18, 178);
INSERT INTO chambre VALUES (179, 77); INSERT INTO club_chambre VALUES (18, 179);
INSERT INTO chambre VALUES (180, 75); INSERT INTO club_chambre VALUES (18, 180);

INSERT INTO chambre VALUES (181, 9); INSERT INTO club_chambre VALUES (19, 181);
INSERT INTO chambre VALUES (182, 10); INSERT INTO club_chambre VALUES (19, 182);
INSERT INTO chambre VALUES (183, 11); INSERT INTO club_chambre VALUES (19, 183);
INSERT INTO chambre VALUES (184, 9); INSERT INTO club_chambre VALUES (19, 184);
INSERT INTO chambre VALUES (185, 10); INSERT INTO club_chambre VALUES (19, 185);
INSERT INTO chambre VALUES (186, 11); INSERT INTO club_chambre VALUES (19, 186);
INSERT INTO chambre VALUES (187, 9); INSERT INTO club_chambre VALUES (19, 187);
INSERT INTO chambre VALUES (188, 10); INSERT INTO club_chambre VALUES (19, 188);
INSERT INTO chambre VALUES (189, 11); INSERT INTO club_chambre VALUES (19, 189);
INSERT INTO chambre VALUES (190, 9); INSERT INTO club_chambre VALUES (19, 190);

INSERT INTO chambre VALUES (191, 78); INSERT INTO club_chambre VALUES (20, 191);
INSERT INTO chambre VALUES (192, 79); INSERT INTO club_chambre VALUES (20, 192);
INSERT INTO chambre VALUES (193, 80); INSERT INTO club_chambre VALUES (20, 193);
INSERT INTO chambre VALUES (194, 78); INSERT INTO club_chambre VALUES (20, 194);
INSERT INTO chambre VALUES (195, 79); INSERT INTO club_chambre VALUES (20, 195);
INSERT INTO chambre VALUES (196, 80); INSERT INTO club_chambre VALUES (20, 196);
INSERT INTO chambre VALUES (197, 78); INSERT INTO club_chambre VALUES (20, 197);
INSERT INTO chambre VALUES (198, 79); INSERT INTO club_chambre VALUES (20, 198);
INSERT INTO chambre VALUES (199, 80); INSERT INTO club_chambre VALUES (20, 199);
INSERT INTO chambre VALUES (200, 78); INSERT INTO club_chambre VALUES (20, 200);

INSERT INTO chambre VALUES (201, 81); INSERT INTO club_chambre VALUES (21, 201);
INSERT INTO chambre VALUES (202, 82); INSERT INTO club_chambre VALUES (21, 202);
INSERT INTO chambre VALUES (203, 83); INSERT INTO club_chambre VALUES (21, 203);
INSERT INTO chambre VALUES (204, 81); INSERT INTO club_chambre VALUES (21, 204);
INSERT INTO chambre VALUES (205, 82); INSERT INTO club_chambre VALUES (21, 205);
INSERT INTO chambre VALUES (206, 83); INSERT INTO club_chambre VALUES (21, 206);
INSERT INTO chambre VALUES (207, 81); INSERT INTO club_chambre VALUES (21, 207);
INSERT INTO chambre VALUES (208, 82); INSERT INTO club_chambre VALUES (21, 208);
INSERT INTO chambre VALUES (209, 83); INSERT INTO club_chambre VALUES (21, 209);
INSERT INTO chambre VALUES (210, 81); INSERT INTO club_chambre VALUES (21, 210);

INSERT INTO chambre VALUES (211, 84); INSERT INTO club_chambre VALUES (22, 211);
INSERT INTO chambre VALUES (212, 85); INSERT INTO club_chambre VALUES (22, 212);
INSERT INTO chambre VALUES (213, 86); INSERT INTO club_chambre VALUES (22, 213);
INSERT INTO chambre VALUES (214, 84); INSERT INTO club_chambre VALUES (22, 214);
INSERT INTO chambre VALUES (215, 85); INSERT INTO club_chambre VALUES (22, 215);
INSERT INTO chambre VALUES (216, 86); INSERT INTO club_chambre VALUES (22, 216);
INSERT INTO chambre VALUES (217, 84); INSERT INTO club_chambre VALUES (22, 217);
INSERT INTO chambre VALUES (218, 85); INSERT INTO club_chambre VALUES (22, 218);
INSERT INTO chambre VALUES (219, 86); INSERT INTO club_chambre VALUES (22, 219);
INSERT INTO chambre VALUES (220, 84); INSERT INTO club_chambre VALUES (22, 220);

INSERT INTO chambre VALUES (221, 87); INSERT INTO club_chambre VALUES (23, 221);
INSERT INTO chambre VALUES (222, 88); INSERT INTO club_chambre VALUES (23, 222);
INSERT INTO chambre VALUES (223, 89); INSERT INTO club_chambre VALUES (23, 223);
INSERT INTO chambre VALUES (224, 87); INSERT INTO club_chambre VALUES (23, 224);
INSERT INTO chambre VALUES (225, 88); INSERT INTO club_chambre VALUES (23, 225);
INSERT INTO chambre VALUES (226, 89); INSERT INTO club_chambre VALUES (23, 226);
INSERT INTO chambre VALUES (227, 87); INSERT INTO club_chambre VALUES (23, 227);
INSERT INTO chambre VALUES (228, 88); INSERT INTO club_chambre VALUES (23, 228);
INSERT INTO chambre VALUES (229, 89); INSERT INTO club_chambre VALUES (23, 229);
INSERT INTO chambre VALUES (230, 87); INSERT INTO club_chambre VALUES (23, 230);

INSERT INTO chambre VALUES (231, 90); INSERT INTO club_chambre VALUES (24, 231);
INSERT INTO chambre VALUES (232, 91); INSERT INTO club_chambre VALUES (24, 232);
INSERT INTO chambre VALUES (233, 92); INSERT INTO club_chambre VALUES (24, 233);
INSERT INTO chambre VALUES (234, 90); INSERT INTO club_chambre VALUES (24, 234);
INSERT INTO chambre VALUES (235, 91); INSERT INTO club_chambre VALUES (24, 235);
INSERT INTO chambre VALUES (236, 92); INSERT INTO club_chambre VALUES (24, 236);
INSERT INTO chambre VALUES (237, 90); INSERT INTO club_chambre VALUES (24, 237);
INSERT INTO chambre VALUES (238, 91); INSERT INTO club_chambre VALUES (24, 238);
INSERT INTO chambre VALUES (239, 92); INSERT INTO club_chambre VALUES (24, 239);
INSERT INTO chambre VALUES (240, 90); INSERT INTO club_chambre VALUES (24, 240);

INSERT INTO chambre VALUES (241, 93); INSERT INTO club_chambre VALUES (25, 241);
INSERT INTO chambre VALUES (242, 94); INSERT INTO club_chambre VALUES (25, 242);
INSERT INTO chambre VALUES (243, 95); INSERT INTO club_chambre VALUES (25, 243);
INSERT INTO chambre VALUES (244, 93); INSERT INTO club_chambre VALUES (25, 244);
INSERT INTO chambre VALUES (245, 94); INSERT INTO club_chambre VALUES (25, 245);
INSERT INTO chambre VALUES (246, 95); INSERT INTO club_chambre VALUES (25, 246);
INSERT INTO chambre VALUES (247, 93); INSERT INTO club_chambre VALUES (25, 247);
INSERT INTO chambre VALUES (248, 94); INSERT INTO club_chambre VALUES (25, 248);
INSERT INTO chambre VALUES (249, 95); INSERT INTO club_chambre VALUES (25, 249);
INSERT INTO chambre VALUES (250, 93); INSERT INTO club_chambre VALUES (25, 250);

INSERT INTO chambre VALUES (251, 96); INSERT INTO club_chambre VALUES (26, 251);
INSERT INTO chambre VALUES (252, 97); INSERT INTO club_chambre VALUES (26, 252);
INSERT INTO chambre VALUES (253, 98); INSERT INTO club_chambre VALUES (26, 253);
INSERT INTO chambre VALUES (254, 96); INSERT INTO club_chambre VALUES (26, 254);
INSERT INTO chambre VALUES (255, 97); INSERT INTO club_chambre VALUES (26, 255);
INSERT INTO chambre VALUES (256, 98); INSERT INTO club_chambre VALUES (26, 256);
INSERT INTO chambre VALUES (257, 96); INSERT INTO club_chambre VALUES (26, 257);
INSERT INTO chambre VALUES (258, 97); INSERT INTO club_chambre VALUES (26, 258);
INSERT INTO chambre VALUES (259, 98); INSERT INTO club_chambre VALUES (26, 259);
INSERT INTO chambre VALUES (260, 96); INSERT INTO club_chambre VALUES (26, 260);

INSERT INTO chambre VALUES (261, 99); INSERT INTO club_chambre VALUES (27, 261);
INSERT INTO chambre VALUES (262, 100); INSERT INTO club_chambre VALUES (27, 262);
INSERT INTO chambre VALUES (263, 101); INSERT INTO club_chambre VALUES (27, 263);
INSERT INTO chambre VALUES (264, 99); INSERT INTO club_chambre VALUES (27, 264);
INSERT INTO chambre VALUES (265, 100); INSERT INTO club_chambre VALUES (27, 265);
INSERT INTO chambre VALUES (266, 101); INSERT INTO club_chambre VALUES (27, 266);
INSERT INTO chambre VALUES (267, 99); INSERT INTO club_chambre VALUES (27, 267);
INSERT INTO chambre VALUES (268, 100); INSERT INTO club_chambre VALUES (27, 268);
INSERT INTO chambre VALUES (269, 101); INSERT INTO club_chambre VALUES (27, 269);
INSERT INTO chambre VALUES (270, 99); INSERT INTO club_chambre VALUES (27, 270);

INSERT INTO chambre VALUES (271, 102); INSERT INTO club_chambre VALUES (28, 271);
INSERT INTO chambre VALUES (272, 103); INSERT INTO club_chambre VALUES (28, 272);
INSERT INTO chambre VALUES (273, 104); INSERT INTO club_chambre VALUES (28, 273);
INSERT INTO chambre VALUES (274, 102); INSERT INTO club_chambre VALUES (28, 274);
INSERT INTO chambre VALUES (275, 103); INSERT INTO club_chambre VALUES (28, 275);
INSERT INTO chambre VALUES (276, 104); INSERT INTO club_chambre VALUES (28, 276);
INSERT INTO chambre VALUES (277, 102); INSERT INTO club_chambre VALUES (28, 277);
INSERT INTO chambre VALUES (278, 103); INSERT INTO club_chambre VALUES (28, 278);
INSERT INTO chambre VALUES (279, 104); INSERT INTO club_chambre VALUES (28, 279);
INSERT INTO chambre VALUES (280, 102); INSERT INTO club_chambre VALUES (28, 280);

INSERT INTO chambre VALUES (281, 105); INSERT INTO club_chambre VALUES (29, 281);
INSERT INTO chambre VALUES (282, 106); INSERT INTO club_chambre VALUES (29, 282);
INSERT INTO chambre VALUES (283, 107); INSERT INTO club_chambre VALUES (29, 283);
INSERT INTO chambre VALUES (284, 105); INSERT INTO club_chambre VALUES (29, 284);
INSERT INTO chambre VALUES (285, 106); INSERT INTO club_chambre VALUES (29, 285);
INSERT INTO chambre VALUES (286, 107); INSERT INTO club_chambre VALUES (29, 286);
INSERT INTO chambre VALUES (287, 105); INSERT INTO club_chambre VALUES (29, 287);
INSERT INTO chambre VALUES (288, 106); INSERT INTO club_chambre VALUES (29, 288);
INSERT INTO chambre VALUES (289, 107); INSERT INTO club_chambre VALUES (29, 289);
INSERT INTO chambre VALUES (290, 105); INSERT INTO club_chambre VALUES (29, 290);

INSERT INTO chambre VALUES (291, 108); INSERT INTO club_chambre VALUES (30, 291);
INSERT INTO chambre VALUES (292, 109); INSERT INTO club_chambre VALUES (30, 292);
INSERT INTO chambre VALUES (293, 110); INSERT INTO club_chambre VALUES (30, 293);
INSERT INTO chambre VALUES (294, 108); INSERT INTO club_chambre VALUES (30, 294);
INSERT INTO chambre VALUES (295, 109); INSERT INTO club_chambre VALUES (30, 295);
INSERT INTO chambre VALUES (296, 110); INSERT INTO club_chambre VALUES (30, 296);
INSERT INTO chambre VALUES (297, 108); INSERT INTO club_chambre VALUES (30, 297);
INSERT INTO chambre VALUES (298, 109); INSERT INTO club_chambre VALUES (30, 298);
INSERT INTO chambre VALUES (299, 110); INSERT INTO club_chambre VALUES (30, 299);
INSERT INTO chambre VALUES (300, 108); INSERT INTO club_chambre VALUES (30, 300);

INSERT INTO chambre VALUES (301, 111); INSERT INTO club_chambre VALUES (31, 301);
INSERT INTO chambre VALUES (302, 112); INSERT INTO club_chambre VALUES (31, 302);
INSERT INTO chambre VALUES (303, 113); INSERT INTO club_chambre VALUES (31, 303);
INSERT INTO chambre VALUES (304, 111); INSERT INTO club_chambre VALUES (31, 304);
INSERT INTO chambre VALUES (305, 112); INSERT INTO club_chambre VALUES (31, 305);
INSERT INTO chambre VALUES (306, 113); INSERT INTO club_chambre VALUES (31, 306);
INSERT INTO chambre VALUES (307, 111); INSERT INTO club_chambre VALUES (31, 307);
INSERT INTO chambre VALUES (308, 112); INSERT INTO club_chambre VALUES (31, 308);
INSERT INTO chambre VALUES (309, 113); INSERT INTO club_chambre VALUES (31, 309);
INSERT INTO chambre VALUES (310, 111); INSERT INTO club_chambre VALUES (31, 310);

INSERT INTO chambre VALUES (311, 114); INSERT INTO club_chambre VALUES (32, 311);
INSERT INTO chambre VALUES (312, 115); INSERT INTO club_chambre VALUES (32, 312);
INSERT INTO chambre VALUES (313, 116); INSERT INTO club_chambre VALUES (32, 313);
INSERT INTO chambre VALUES (314, 114); INSERT INTO club_chambre VALUES (32, 314);
INSERT INTO chambre VALUES (315, 115); INSERT INTO club_chambre VALUES (32, 315);
INSERT INTO chambre VALUES (316, 116); INSERT INTO club_chambre VALUES (32, 316);
INSERT INTO chambre VALUES (317, 114); INSERT INTO club_chambre VALUES (32, 317);
INSERT INTO chambre VALUES (318, 115); INSERT INTO club_chambre VALUES (32, 318);
INSERT INTO chambre VALUES (319, 116); INSERT INTO club_chambre VALUES (32, 319);
INSERT INTO chambre VALUES (320, 114); INSERT INTO club_chambre VALUES (32, 320);

INSERT INTO chambre VALUES (321, 117); INSERT INTO club_chambre VALUES (33, 321);
INSERT INTO chambre VALUES (322, 118); INSERT INTO club_chambre VALUES (33, 322);
INSERT INTO chambre VALUES (323, 119); INSERT INTO club_chambre VALUES (33, 323);
INSERT INTO chambre VALUES (324, 117); INSERT INTO club_chambre VALUES (33, 324);
INSERT INTO chambre VALUES (325, 118); INSERT INTO club_chambre VALUES (33, 325);
INSERT INTO chambre VALUES (326, 119); INSERT INTO club_chambre VALUES (33, 326);
INSERT INTO chambre VALUES (327, 117); INSERT INTO club_chambre VALUES (33, 327);
INSERT INTO chambre VALUES (328, 118); INSERT INTO club_chambre VALUES (33, 328);
INSERT INTO chambre VALUES (329, 119); INSERT INTO club_chambre VALUES (33, 329);
INSERT INTO chambre VALUES (330, 117); INSERT INTO club_chambre VALUES (33, 330);

INSERT INTO chambre VALUES (331, 120); INSERT INTO club_chambre VALUES (34, 331);
INSERT INTO chambre VALUES (332, 121); INSERT INTO club_chambre VALUES (34, 332);
INSERT INTO chambre VALUES (333, 122); INSERT INTO club_chambre VALUES (34, 333);
INSERT INTO chambre VALUES (334, 120); INSERT INTO club_chambre VALUES (34, 334);
INSERT INTO chambre VALUES (335, 121); INSERT INTO club_chambre VALUES (34, 335);
INSERT INTO chambre VALUES (336, 122); INSERT INTO club_chambre VALUES (34, 336);
INSERT INTO chambre VALUES (337, 120); INSERT INTO club_chambre VALUES (34, 337);
INSERT INTO chambre VALUES (338, 121); INSERT INTO club_chambre VALUES (34, 338);
INSERT INTO chambre VALUES (339, 122); INSERT INTO club_chambre VALUES (34, 339);
INSERT INTO chambre VALUES (340, 120); INSERT INTO club_chambre VALUES (34, 340);

INSERT INTO chambre VALUES (341, 123); INSERT INTO club_chambre VALUES (35, 341);
INSERT INTO chambre VALUES (342, 124); INSERT INTO club_chambre VALUES (35, 342);
INSERT INTO chambre VALUES (343, 125); INSERT INTO club_chambre VALUES (35, 343);
INSERT INTO chambre VALUES (344, 123); INSERT INTO club_chambre VALUES (35, 344);
INSERT INTO chambre VALUES (345, 124); INSERT INTO club_chambre VALUES (35, 345);
INSERT INTO chambre VALUES (346, 125); INSERT INTO club_chambre VALUES (35, 346);
INSERT INTO chambre VALUES (347, 123); INSERT INTO club_chambre VALUES (35, 347);
INSERT INTO chambre VALUES (348, 124); INSERT INTO club_chambre VALUES (35, 348);
INSERT INTO chambre VALUES (349, 125); INSERT INTO club_chambre VALUES (35, 349);
INSERT INTO chambre VALUES (350, 123); INSERT INTO club_chambre VALUES (35, 350);

INSERT INTO chambre VALUES (351, 126); INSERT INTO club_chambre VALUES (36, 351);
INSERT INTO chambre VALUES (352, 127); INSERT INTO club_chambre VALUES (36, 352);
INSERT INTO chambre VALUES (353, 128); INSERT INTO club_chambre VALUES (36, 353);
INSERT INTO chambre VALUES (354, 126); INSERT INTO club_chambre VALUES (36, 354);
INSERT INTO chambre VALUES (355, 127); INSERT INTO club_chambre VALUES (36, 355);
INSERT INTO chambre VALUES (356, 128); INSERT INTO club_chambre VALUES (36, 356);
INSERT INTO chambre VALUES (357, 126); INSERT INTO club_chambre VALUES (36, 357);
INSERT INTO chambre VALUES (358, 127); INSERT INTO club_chambre VALUES (36, 358);
INSERT INTO chambre VALUES (359, 128); INSERT INTO club_chambre VALUES (36, 359);
INSERT INTO chambre VALUES (360, 126); INSERT INTO club_chambre VALUES (36, 360);

INSERT INTO chambre VALUES (361, 129); INSERT INTO club_chambre VALUES (37, 361);
INSERT INTO chambre VALUES (362, 130); INSERT INTO club_chambre VALUES (37, 362);
INSERT INTO chambre VALUES (363, 131); INSERT INTO club_chambre VALUES (37, 363);
INSERT INTO chambre VALUES (364, 129); INSERT INTO club_chambre VALUES (37, 364);
INSERT INTO chambre VALUES (365, 130); INSERT INTO club_chambre VALUES (37, 365);
INSERT INTO chambre VALUES (366, 131); INSERT INTO club_chambre VALUES (37, 366);
INSERT INTO chambre VALUES (367, 129); INSERT INTO club_chambre VALUES (37, 367);
INSERT INTO chambre VALUES (368, 130); INSERT INTO club_chambre VALUES (37, 368);
INSERT INTO chambre VALUES (369, 131); INSERT INTO club_chambre VALUES (37, 369);
INSERT INTO chambre VALUES (370, 129); INSERT INTO club_chambre VALUES (37, 370);

INSERT INTO chambre VALUES (371, 12); INSERT INTO club_chambre VALUES (38, 371);
INSERT INTO chambre VALUES (372, 13); INSERT INTO club_chambre VALUES (38, 372);
INSERT INTO chambre VALUES (373, 14); INSERT INTO club_chambre VALUES (38, 373);
INSERT INTO chambre VALUES (374, 12); INSERT INTO club_chambre VALUES (38, 374);
INSERT INTO chambre VALUES (375, 13); INSERT INTO club_chambre VALUES (38, 375);
INSERT INTO chambre VALUES (376, 14); INSERT INTO club_chambre VALUES (38, 376);
INSERT INTO chambre VALUES (377, 12); INSERT INTO club_chambre VALUES (38, 377);
INSERT INTO chambre VALUES (378, 13); INSERT INTO club_chambre VALUES (38, 378);
INSERT INTO chambre VALUES (379, 14); INSERT INTO club_chambre VALUES (38, 379);
INSERT INTO chambre VALUES (380, 12); INSERT INTO club_chambre VALUES (38, 380);

INSERT INTO chambre VALUES (381, 15); INSERT INTO club_chambre VALUES (39, 381);
INSERT INTO chambre VALUES (382, 16); INSERT INTO club_chambre VALUES (39, 382);
INSERT INTO chambre VALUES (383, 17); INSERT INTO club_chambre VALUES (39, 383);
INSERT INTO chambre VALUES (384, 15); INSERT INTO club_chambre VALUES (39, 384);
INSERT INTO chambre VALUES (385, 16); INSERT INTO club_chambre VALUES (39, 385);
INSERT INTO chambre VALUES (386, 17); INSERT INTO club_chambre VALUES (39, 386);
INSERT INTO chambre VALUES (387, 15); INSERT INTO club_chambre VALUES (39, 387);
INSERT INTO chambre VALUES (388, 16); INSERT INTO club_chambre VALUES (39, 388);
INSERT INTO chambre VALUES (389, 17); INSERT INTO club_chambre VALUES (39, 389);
INSERT INTO chambre VALUES (390, 15); INSERT INTO club_chambre VALUES (39, 390);

INSERT INTO chambre VALUES (391, 132); INSERT INTO club_chambre VALUES (40, 391);
INSERT INTO chambre VALUES (392, 133); INSERT INTO club_chambre VALUES (40, 392);
INSERT INTO chambre VALUES (393, 134); INSERT INTO club_chambre VALUES (40, 393);
INSERT INTO chambre VALUES (394, 132); INSERT INTO club_chambre VALUES (40, 394);
INSERT INTO chambre VALUES (395, 133); INSERT INTO club_chambre VALUES (40, 395);
INSERT INTO chambre VALUES (396, 134); INSERT INTO club_chambre VALUES (40, 396);
INSERT INTO chambre VALUES (397, 132); INSERT INTO club_chambre VALUES (40, 397);
INSERT INTO chambre VALUES (398, 133); INSERT INTO club_chambre VALUES (40, 398);
INSERT INTO chambre VALUES (399, 134); INSERT INTO club_chambre VALUES (40, 399);
INSERT INTO chambre VALUES (400, 132); INSERT INTO club_chambre VALUES (40, 400);

INSERT INTO chambre VALUES (401, 18); INSERT INTO club_chambre VALUES (41, 401);
INSERT INTO chambre VALUES (402, 19); INSERT INTO club_chambre VALUES (41, 402);
INSERT INTO chambre VALUES (403, 20); INSERT INTO club_chambre VALUES (41, 403);
INSERT INTO chambre VALUES (404, 21); INSERT INTO club_chambre VALUES (41, 404);
INSERT INTO chambre VALUES (405, 22); INSERT INTO club_chambre VALUES (41, 405);
INSERT INTO chambre VALUES (406, 23); INSERT INTO club_chambre VALUES (41, 406);
INSERT INTO chambre VALUES (407, 18); INSERT INTO club_chambre VALUES (41, 407);
INSERT INTO chambre VALUES (408, 19); INSERT INTO club_chambre VALUES (41, 408);
INSERT INTO chambre VALUES (409, 20); INSERT INTO club_chambre VALUES (41, 409);
INSERT INTO chambre VALUES (410, 21); INSERT INTO club_chambre VALUES (41, 410);

INSERT INTO chambre VALUES (411, 24); INSERT INTO club_chambre VALUES (42, 411);
INSERT INTO chambre VALUES (412, 25); INSERT INTO club_chambre VALUES (42, 412);
INSERT INTO chambre VALUES (413, 26); INSERT INTO club_chambre VALUES (42, 413);
INSERT INTO chambre VALUES (414, 27); INSERT INTO club_chambre VALUES (42, 414);
INSERT INTO chambre VALUES (415, 24); INSERT INTO club_chambre VALUES (42, 415);
INSERT INTO chambre VALUES (416, 25); INSERT INTO club_chambre VALUES (42, 416);
INSERT INTO chambre VALUES (417, 26); INSERT INTO club_chambre VALUES (42, 417);
INSERT INTO chambre VALUES (418, 27); INSERT INTO club_chambre VALUES (42, 418);
INSERT INTO chambre VALUES (419, 24); INSERT INTO club_chambre VALUES (42, 419);
INSERT INTO chambre VALUES (420, 25); INSERT INTO club_chambre VALUES (42, 420);

INSERT INTO chambre VALUES (421, 135); INSERT INTO club_chambre VALUES (43, 421);
INSERT INTO chambre VALUES (422, 136); INSERT INTO club_chambre VALUES (43, 422);
INSERT INTO chambre VALUES (423, 137); INSERT INTO club_chambre VALUES (43, 423);
INSERT INTO chambre VALUES (424, 135); INSERT INTO club_chambre VALUES (43, 424);
INSERT INTO chambre VALUES (425, 136); INSERT INTO club_chambre VALUES (43, 425);
INSERT INTO chambre VALUES (426, 137); INSERT INTO club_chambre VALUES (43, 426);
INSERT INTO chambre VALUES (427, 135); INSERT INTO club_chambre VALUES (43, 427);
INSERT INTO chambre VALUES (428, 136); INSERT INTO club_chambre VALUES (43, 428);
INSERT INTO chambre VALUES (429, 137); INSERT INTO club_chambre VALUES (43, 429);
INSERT INTO chambre VALUES (430, 135); INSERT INTO club_chambre VALUES (43, 430);

INSERT INTO chambre VALUES (431, 138); INSERT INTO club_chambre VALUES (44, 431);
INSERT INTO chambre VALUES (432, 139); INSERT INTO club_chambre VALUES (44, 432);
INSERT INTO chambre VALUES (433, 140); INSERT INTO club_chambre VALUES (44, 433);
INSERT INTO chambre VALUES (434, 138); INSERT INTO club_chambre VALUES (44, 434);
INSERT INTO chambre VALUES (435, 139); INSERT INTO club_chambre VALUES (44, 435);
INSERT INTO chambre VALUES (436, 140); INSERT INTO club_chambre VALUES (44, 436);
INSERT INTO chambre VALUES (437, 138); INSERT INTO club_chambre VALUES (44, 437);
INSERT INTO chambre VALUES (438, 139); INSERT INTO club_chambre VALUES (44, 438);
INSERT INTO chambre VALUES (439, 140); INSERT INTO club_chambre VALUES (44, 439);
INSERT INTO chambre VALUES (440, 138); INSERT INTO club_chambre VALUES (44, 440);

INSERT INTO chambre VALUES (441, 141); INSERT INTO club_chambre VALUES (45, 441);
INSERT INTO chambre VALUES (442, 142); INSERT INTO club_chambre VALUES (45, 442);
INSERT INTO chambre VALUES (443, 143); INSERT INTO club_chambre VALUES (45, 443);
INSERT INTO chambre VALUES (444, 141); INSERT INTO club_chambre VALUES (45, 444);
INSERT INTO chambre VALUES (445, 142); INSERT INTO club_chambre VALUES (45, 445);
INSERT INTO chambre VALUES (446, 143); INSERT INTO club_chambre VALUES (45, 446);
INSERT INTO chambre VALUES (447, 141); INSERT INTO club_chambre VALUES (45, 447);
INSERT INTO chambre VALUES (448, 142); INSERT INTO club_chambre VALUES (45, 448);
INSERT INTO chambre VALUES (449, 143); INSERT INTO club_chambre VALUES (45, 449);
INSERT INTO chambre VALUES (450, 141); INSERT INTO club_chambre VALUES (45, 450);

INSERT INTO chambre VALUES (451, 144); INSERT INTO club_chambre VALUES (46, 451);
INSERT INTO chambre VALUES (452, 145); INSERT INTO club_chambre VALUES (46, 452);
INSERT INTO chambre VALUES (453, 146); INSERT INTO club_chambre VALUES (46, 453);
INSERT INTO chambre VALUES (454, 144); INSERT INTO club_chambre VALUES (46, 454);
INSERT INTO chambre VALUES (455, 145); INSERT INTO club_chambre VALUES (46, 455);
INSERT INTO chambre VALUES (456, 146); INSERT INTO club_chambre VALUES (46, 456);
INSERT INTO chambre VALUES (457, 144); INSERT INTO club_chambre VALUES (46, 457);
INSERT INTO chambre VALUES (458, 145); INSERT INTO club_chambre VALUES (46, 458);
INSERT INTO chambre VALUES (459, 146); INSERT INTO club_chambre VALUES (46, 459);
INSERT INTO chambre VALUES (460, 144); INSERT INTO club_chambre VALUES (46, 460);

INSERT INTO chambre VALUES (461, 147); INSERT INTO club_chambre VALUES (47, 461);
INSERT INTO chambre VALUES (462, 148); INSERT INTO club_chambre VALUES (47, 462);
INSERT INTO chambre VALUES (463, 149); INSERT INTO club_chambre VALUES (47, 463);
INSERT INTO chambre VALUES (464, 147); INSERT INTO club_chambre VALUES (47, 464);
INSERT INTO chambre VALUES (465, 148); INSERT INTO club_chambre VALUES (47, 465);
INSERT INTO chambre VALUES (466, 149); INSERT INTO club_chambre VALUES (47, 466);
INSERT INTO chambre VALUES (467, 147); INSERT INTO club_chambre VALUES (47, 467);
INSERT INTO chambre VALUES (468, 148); INSERT INTO club_chambre VALUES (47, 468);
INSERT INTO chambre VALUES (469, 149); INSERT INTO club_chambre VALUES (47, 469);
INSERT INTO chambre VALUES (470, 147); INSERT INTO club_chambre VALUES (47, 470);

INSERT INTO chambre VALUES (471, 150); INSERT INTO club_chambre VALUES (48, 471);
INSERT INTO chambre VALUES (472, 151); INSERT INTO club_chambre VALUES (48, 472);
INSERT INTO chambre VALUES (473, 152); INSERT INTO club_chambre VALUES (48, 473);
INSERT INTO chambre VALUES (474, 150); INSERT INTO club_chambre VALUES (48, 474);
INSERT INTO chambre VALUES (475, 151); INSERT INTO club_chambre VALUES (48, 475);
INSERT INTO chambre VALUES (476, 152); INSERT INTO club_chambre VALUES (48, 476);
INSERT INTO chambre VALUES (477, 150); INSERT INTO club_chambre VALUES (48, 477);
INSERT INTO chambre VALUES (478, 151); INSERT INTO club_chambre VALUES (48, 478);
INSERT INTO chambre VALUES (479, 152); INSERT INTO club_chambre VALUES (48, 479);
INSERT INTO chambre VALUES (480, 150); INSERT INTO club_chambre VALUES (48, 480);

INSERT INTO chambre VALUES (481, 153); INSERT INTO club_chambre VALUES (49, 481);
INSERT INTO chambre VALUES (482, 154); INSERT INTO club_chambre VALUES (49, 482);
INSERT INTO chambre VALUES (483, 155); INSERT INTO club_chambre VALUES (49, 483);
INSERT INTO chambre VALUES (484, 153); INSERT INTO club_chambre VALUES (49, 484);
INSERT INTO chambre VALUES (485, 154); INSERT INTO club_chambre VALUES (49, 485);
INSERT INTO chambre VALUES (486, 155); INSERT INTO club_chambre VALUES (49, 486);
INSERT INTO chambre VALUES (487, 153); INSERT INTO club_chambre VALUES (49, 487);
INSERT INTO chambre VALUES (488, 154); INSERT INTO club_chambre VALUES (49, 488);
INSERT INTO chambre VALUES (489, 155); INSERT INTO club_chambre VALUES (49, 489);
INSERT INTO chambre VALUES (490, 153); INSERT INTO club_chambre VALUES (49, 490);

INSERT INTO chambre VALUES (491, 156); INSERT INTO club_chambre VALUES (50, 491);
INSERT INTO chambre VALUES (492, 157); INSERT INTO club_chambre VALUES (50, 492);
INSERT INTO chambre VALUES (493, 158); INSERT INTO club_chambre VALUES (50, 493);
INSERT INTO chambre VALUES (494, 156); INSERT INTO club_chambre VALUES (50, 494);
INSERT INTO chambre VALUES (495, 157); INSERT INTO club_chambre VALUES (50, 495);
INSERT INTO chambre VALUES (496, 158); INSERT INTO club_chambre VALUES (50, 496);
INSERT INTO chambre VALUES (497, 156); INSERT INTO club_chambre VALUES (50, 497);
INSERT INTO chambre VALUES (498, 157); INSERT INTO club_chambre VALUES (50, 498);
INSERT INTO chambre VALUES (499, 158); INSERT INTO club_chambre VALUES (50, 499);
INSERT INTO chambre VALUES (500, 156); INSERT INTO club_chambre VALUES (50, 500);

-- Clubs station
INSERT INTO clubstation VALUES (1, 10, 237, 'Serre Chevalier', 'Un hameau de chalets en pierre et bois au cœur des mélèzes, idéal pour les familles.', 4.5, 'serre_chevalier_infos.pdf', '1400m');
INSERT INTO clubstation VALUES (24, 5, 239, 'Tignes', 'Le nouveau resort au pied des pistes, vibrant et sportif, face au glacier de la Grande Motte.', 4.7, 'tignes_infos.pdf', '2100m');
INSERT INTO clubstation VALUES (25, 6, 243, 'Val d''Isère', 'Le seul Club Med Exclusive Collection à la montagne, alliant luxe, intimité et ski d''exception.', 4.8, 'val_isere_infos.pdf', '1850m');
INSERT INTO clubstation VALUES (26, 1, 245, 'Val Thorens Sensations', 'Un design audacieux et contemporain pour ce resort situé dans la plus haute station d''Europe.', 4.6, 'val_thorens_infos.pdf', '2300m');
INSERT INTO clubstation VALUES (27, 8, 200, 'Alpe d''Huez', 'Une terrasse plein sud pour profiter de l''ensoleillement légendaire de l''île au soleil.', 4.4, 'alpe_huez_infos.pdf', '1860m');
INSERT INTO clubstation VALUES (28, 4, 220, 'Les Arcs Panorama', 'Une vue à couper le souffle sur la vallée de la Tarentaise et le Mont Blanc.', 4.5, 'les_arcs_infos.pdf', '1750m');
INSERT INTO clubstation VALUES (29, 11, 209, 'Grand Massif Samoëns', 'Un resort moderne perché sur le plateau des Saix, offrant une vue panoramique à 360°.', 4.3, 'grand_massif_infos.pdf', '1600m');
INSERT INTO clubstation VALUES (30, 15, 244, 'Valmorel', 'Le charme authentique d''une architecture traditionnelle au pied des pistes du Grand Domaine.', 4.2, 'valmorel_infos.pdf', '1460m');
INSERT INTO clubstation VALUES (31, 4, 229, 'Peisey-Vallandry', 'Au cœur de la forêt, ce club offre une ambiance chaleureuse et un accès direct au Vanoise Express.', 4.4, 'peisey_infos.pdf', '1600m');
INSERT INTO clubstation VALUES (32, 3, 248, 'La Plagne 2100', 'Une architecture audacieuse au pied des pistes pour les amateurs de glisse intense.', 4.1, 'la_plagne_infos.pdf', '2100m');

-- Reservations
INSERT INTO reservation VALUES (1, 43, 4, 60, '2026-06-06', '2026-06-20', 3, 'Bordeaux', 1446, 'CONFIRMEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (2, 46, 5, 148, '2025-09-25', '2025-10-09', 4, 'Genève', 1182, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (3, 26, 4, 19, '2025-03-22', '2025-03-26', 3, 'Bordeaux', 4576, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (4, 46, 1, 79, '2026-10-29', '2026-11-06', 4, 'Paris', 4054, 'CONFIRMEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (5, 30, 2, 5, '2025-03-11', '2025-03-24', 2, 'Lyon', 4642, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (6, 12, 8, 112, '2026-02-15', '2026-02-23', 2, 'Paris', 3821, 'PAYEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (7, 39, 3, 45, '2024-05-18', '2024-05-25', 5, 'Marseille', 2150, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (8, 5, 9, 88, '2025-07-10', '2025-07-20', 1, 'Domicile', 890, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (9, 22, 6, 23, '2024-12-01', '2024-12-08', 3, 'Paris', 3200, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (10, 48, 1, 150, '2026-08-14', '2026-08-28', 4, 'Paris', 4100, 'EN_ATTENTE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (11, 15, 2, 9, '2025-01-05', '2025-01-12', 2, 'Lyon', 1560, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (12, 33, 7, 77, '2024-09-09', '2024-09-16', 1, 'Lyon', 950, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (13, 29, 5, 101, '2026-04-22', '2026-05-02', 5, 'Genève', 4890, 'PAYEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (14, 41, 4, 33, '2025-11-11', '2025-11-18', 2, 'Bordeaux', 2340, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (15, 8, 9, 142, '2024-03-30', '2024-04-06', 3, 'Domicile', 2780, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (16, 19, 1, 65, '2026-01-20', '2026-01-30', 4, 'Paris', 3650, 'CONFIRMEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (17, 25, 3, 12, '2025-06-15', '2025-06-22', 2, 'Marseille', 1980, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (18, 50, 8, 99, '2024-10-05', '2024-10-12', 1, 'Paris', 1100, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (19, 3, 2, 41, '2026-12-01', '2026-12-10', 5, 'Lyon', 4950, 'EN_ATTENTE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (20, 11, 6, 8, '2025-02-14', '2025-02-21', 2, 'Paris', 2200, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (21, 37, 5, 130, '2024-08-20', '2024-08-30', 3, 'Genève', 3450, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (22, 14, 4, 55, '2026-03-10', '2026-03-17', 4, 'Bordeaux', 3120, 'CONFIRMEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (23, 44, 1, 19, '2025-05-05', '2025-05-12', 2, 'Paris', 2670, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (24, 28, 9, 83, '2024-11-25', '2024-12-05', 1, 'Domicile', 1340, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (25, 6, 7, 115, '2026-07-08', '2026-07-18', 5, 'Lyon', 4760, 'PAYEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (26, 31, 3, 29, '2025-09-01', '2025-09-08', 3, 'Marseille', 2890, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (27, 17, 2, 66, '2024-04-15', '2024-04-22', 2, 'Lyon', 1850, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (28, 49, 8, 107, '2026-11-20', '2026-11-27', 4, 'Paris', 3980, 'CONFIRMEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (29, 2, 5, 4, '2025-03-05', '2025-03-15', 1, 'Genève', 1250, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (30, 35, 6, 92, '2024-07-28', '2024-08-04', 3, 'Paris', 3340, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (31, 10, 1, 144, '2026-05-12', '2026-05-19', 2, 'Paris', 2100, 'PAYEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (32, 23, 4, 38, '2025-12-25', '2026-01-02', 5, 'Bordeaux', 4800, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (33, 42, 9, 71, '2024-02-10', '2024-02-17', 4, 'Domicile', 3560, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (34, 18, 3, 15, '2026-09-18', '2026-09-28', 1, 'Marseille', 1450, 'EN_ATTENTE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (35, 30, 2, 122, '2025-04-04', '2025-04-11', 3, 'Lyon', 2980, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (36, 7, 7, 50, '2024-10-30', '2024-11-06', 2, 'Lyon', 2230, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (37, 45, 5, 85, '2026-02-28', '2026-03-10', 4, 'Genève', 4120, 'CONFIRMEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (38, 13, 8, 136, '2025-08-15', '2025-08-22', 5, 'Paris', 4670, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (39, 27, 1, 22, '2024-06-05', '2024-06-12', 3, 'Paris', 3050, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (40, 38, 4, 109, '2026-10-10', '2026-10-17', 1, 'Bordeaux', 980, 'PAYEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (41, 1, 6, 61, '2025-01-22', '2025-02-01', 2, 'Paris', 2450, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (42, 40, 9, 14, '2024-09-15', '2024-09-25', 4, 'Domicile', 3780, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (43, 21, 2, 95, '2026-04-05', '2026-04-12', 3, 'Lyon', 2890, 'CONFIRMEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (44, 34, 3, 30, '2025-11-01', '2025-11-08', 5, 'Marseille', 4320, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (45, 16, 5, 118, '2024-03-12', '2024-03-19', 2, 'Genève', 1760, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (46, 47, 1, 75, '2026-07-25', '2026-08-04', 1, 'Paris', 1540, 'PAYEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (47, 9, 7, 151, '2025-05-20', '2025-05-30', 4, 'Lyon', 3900, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (48, 26, 4, 42, '2024-12-12', '2024-12-19', 3, 'Bordeaux', 2650, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (49, 36, 8, 103, '2026-01-08', '2026-01-15', 2, 'Paris', 2310, 'CONFIRMEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (50, 4, 2, 10, '2025-08-02', '2025-08-12', 5, 'Lyon', 4990, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (51, 32, 9, 87, '2024-05-08', '2024-05-15', 3, 'Domicile', 2760, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (52, 20, 6, 133, '2026-09-05', '2026-09-15', 1, 'Paris', 1230, 'EN_ATTENTE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (53, 43, 3, 58, '2025-02-28', '2025-03-07', 4, 'Marseille', 3450, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (54, 12, 1, 26, '2024-10-18', '2024-10-25', 2, 'Paris', 1980, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (55, 39, 5, 111, '2026-06-22', '2026-06-29', 5, 'Genève', 4540, 'PAYEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (56, 5, 4, 73, '2025-10-30', '2025-11-06', 3, 'Bordeaux', 2870, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (57, 24, 8, 3, '2024-01-15', '2024-01-22', 1, 'Paris', 850, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (58, 46, 2, 97, '2026-03-25', '2026-04-04', 4, 'Lyon', 4210, 'CONFIRMEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (59, 15, 7, 140, '2025-06-08', '2025-06-15', 2, 'Lyon', 2150, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (60, 29, 9, 49, '2024-08-12', '2024-08-22', 5, 'Domicile', 4780, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (61, 41, 1, 126, '2026-11-05', '2026-11-12', 3, 'Paris', 3020, 'EN_ATTENTE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (62, 8, 3, 20, '2025-01-18', '2025-01-25', 4, 'Marseille', 3590, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (63, 22, 5, 82, '2024-04-02', '2024-04-09', 2, 'Genève', 1890, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (64, 48, 6, 152, '2026-08-30', '2026-09-09', 1, 'Paris', 1340, 'PAYEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (65, 11, 4, 35, '2025-04-20', '2025-04-30', 5, 'Bordeaux', 4650, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (66, 33, 2, 105, '2024-12-05', '2024-12-12', 3, 'Lyon', 2760, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (67, 19, 8, 62, '2026-02-08', '2026-02-15', 2, 'Paris', 2430, 'CONFIRMEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (68, 50, 9, 135, '2025-09-22', '2025-10-02', 4, 'Domicile', 3890, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (69, 3, 1, 7, '2024-07-15', '2024-07-22', 1, 'Paris', 920, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (70, 37, 7, 90, '2026-05-02', '2026-05-12', 3, 'Lyon', 3120, 'EN_ATTENTE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (71, 14, 5, 40, '2025-11-28', '2025-12-05', 2, 'Genève', 2050, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (72, 44, 3, 119, '2024-03-25', '2024-04-01', 5, 'Marseille', 4450, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (73, 25, 4, 25, '2026-10-22', '2026-10-29', 4, 'Bordeaux', 3670, 'PAYEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (74, 6, 2, 80, '2025-02-05', '2025-02-15', 3, 'Lyon', 3230, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (75, 31, 6, 146, '2024-09-08', '2024-09-15', 2, 'Paris', 1780, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (76, 17, 1, 53, '2026-01-12', '2026-01-19', 1, 'Paris', 1150, 'CONFIRMEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (77, 45, 8, 98, '2025-06-25', '2025-07-05', 5, 'Paris', 4890, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (78, 2, 9, 13, '2024-11-10', '2024-11-17', 4, 'Domicile', 3990, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (79, 28, 5, 70, '2026-04-18', '2026-04-25', 2, 'Genève', 2340, 'EN_ATTENTE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (80, 40, 7, 125, '2025-08-30', '2025-09-06', 3, 'Lyon', 2900, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (81, 10, 3, 36, '2024-05-02', '2024-05-12', 1, 'Marseille', 1450, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (82, 35, 2, 93, '2026-12-15', '2026-12-22', 4, 'Lyon', 3780, 'PAYEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (83, 21, 4, 153, '2025-03-20', '2025-03-27', 2, 'Bordeaux', 2560, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (84, 47, 1, 6, '2024-08-05', '2024-08-15', 5, 'Paris', 4670, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (85, 12, 6, 84, '2026-03-02', '2026-03-09', 3, 'Paris', 3120, 'CONFIRMEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (86, 34, 5, 113, '2025-10-15', '2025-10-22', 1, 'Genève', 1020, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (87, 49, 9, 32, '2024-01-28', '2024-02-04', 4, 'Domicile', 3450, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (88, 26, 8, 141, '2026-07-12', '2026-07-22', 2, 'Paris', 2670, 'EN_ATTENTE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (89, 7, 2, 59, '2025-05-08', '2025-05-15', 5, 'Lyon', 4230, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (90, 32, 1, 100, '2024-12-20', '2024-12-27', 3, 'Paris', 3560, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (91, 42, 3, 17, '2026-09-30', '2026-10-07', 4, 'Marseille', 3890, 'PAYEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (92, 16, 7, 76, '2025-02-18', '2025-02-28', 2, 'Lyon', 2100, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (93, 27, 4, 128, '2024-06-25', '2024-07-02', 1, 'Bordeaux', 890, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (94, 38, 5, 47, '2026-02-12', '2026-02-19', 3, 'Genève', 2980, 'CONFIRMEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (95, 1, 9, 110, '2025-11-25', '2025-12-05', 5, 'Domicile', 4780, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (96, 46, 2, 2, '2024-04-10', '2024-04-17', 2, 'Lyon', 1670, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (97, 20, 6, 96, '2026-05-22', '2026-06-01', 4, 'Paris', 4120, 'EN_ATTENTE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (98, 5, 1, 137, '2025-09-12', '2025-09-19', 3, 'Paris', 2560, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (99, 36, 8, 54, '2024-10-02', '2024-10-09', 1, 'Paris', 1200, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (100, 29, 3, 89, '2026-08-18', '2026-08-25', 2, 'Marseille', 2340, 'PAYEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (101, 43, 7, 24, '2025-04-15', '2025-04-25', 5, 'Lyon', 4900, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (102, 13, 2, 114, '2024-01-30', '2024-02-06', 4, 'Lyon', 3670, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (103, 30, 5, 68, '2026-11-10', '2026-11-17', 3, 'Genève', 3210, 'CONFIRMEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (104, 9, 4, 149, '2025-06-02', '2025-06-12', 1, 'Bordeaux', 1450, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (105, 41, 1, 37, '2024-07-20', '2024-07-27', 2, 'Paris', 2780, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (106, 22, 9, 102, '2026-01-25', '2026-02-01', 4, 'Domicile', 3560, 'EN_ATTENTE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (107, 47, 6, 18, '2025-10-08', '2025-10-15', 5, 'Paris', 4320, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (108, 18, 3, 131, '2024-03-05', '2024-03-15', 3, 'Marseille', 2980, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (109, 39, 8, 63, '2026-06-12', '2026-06-19', 2, 'Paris', 2120, 'PAYEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (110, 4, 2, 91, '2025-01-10', '2025-01-17', 1, 'Lyon', 950, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (111, 25, 1, 120, '2024-09-25', '2024-10-05', 4, 'Paris', 3890, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (112, 44, 5, 8, '2026-03-18', '2026-03-25', 3, 'Genève', 2670, 'CONFIRMEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (113, 11, 4, 143, '2025-07-02', '2025-07-09', 2, 'Bordeaux', 1890, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (114, 32, 7, 52, '2024-05-18', '2024-05-28', 5, 'Lyon', 4560, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (115, 48, 9, 27, '2026-10-25', '2026-11-01', 1, 'Domicile', 1100, 'EN_ATTENTE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (116, 17, 3, 78, '2025-02-22', '2025-03-01', 4, 'Marseille', 3450, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (117, 35, 1, 112, '2024-11-15', '2024-11-22', 2, 'Paris', 2340, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (118, 50, 6, 150, '2026-08-05', '2026-08-15', 3, 'Paris', 3230, 'PAYEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (119, 8, 2, 34, '2025-05-12', '2025-05-19', 5, 'Lyon', 4780, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (120, 23, 8, 106, '2024-01-08', '2024-01-15', 1, 'Paris', 890, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (121, 40, 5, 69, '2026-04-28', '2026-05-08', 4, 'Genève', 4120, 'CONFIRMEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (122, 14, 1, 145, '2025-09-18', '2025-09-25', 2, 'Paris', 2560, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (123, 31, 4, 21, '2024-06-10', '2024-06-17', 3, 'Bordeaux', 2780, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (124, 45, 9, 86, '2026-12-05', '2026-12-15', 5, 'Domicile', 4900, 'EN_ATTENTE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (125, 2, 7, 127, '2025-03-30', '2025-04-06', 1, 'Lyon', 1340, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (126, 19, 2, 44, '2024-08-25', '2024-09-01', 4, 'Lyon', 3670, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (127, 37, 6, 100, '2026-01-15', '2026-01-22', 2, 'Paris', 2100, 'PAYEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (128, 42, 3, 57, '2025-11-22', '2025-12-02', 3, 'Marseille', 3450, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (129, 6, 8, 139, '2024-04-05', '2024-04-12', 5, 'Paris', 4560, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (130, 27, 1, 16, '2026-07-02', '2026-07-09', 2, 'Paris', 2340, 'CONFIRMEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (131, 49, 5, 94, '2025-01-28', '2025-02-04', 1, 'Genève', 980, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (132, 12, 4, 117, '2024-10-12', '2024-10-22', 4, 'Bordeaux', 3890, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (133, 33, 9, 39, '2026-02-25', '2026-03-04', 3, 'Domicile', 2670, 'EN_ATTENTE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (134, 15, 2, 74, '2025-06-18', '2025-06-25', 2, 'Lyon', 1890, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (135, 46, 1, 148, '2024-03-02', '2024-03-12', 5, 'Paris', 4780, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (136, 21, 6, 51, '2026-11-15', '2026-11-22', 1, 'Paris', 1230, 'PAYEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (137, 36, 7, 108, '2025-08-08', '2025-08-15', 4, 'Lyon', 3560, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (138, 5, 3, 1, '2024-12-08', '2024-12-18', 2, 'Marseille', 2450, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (139, 28, 8, 81, '2026-05-30', '2026-06-06', 3, 'Paris', 2900, 'CONFIRMEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (140, 44, 2, 132, '2025-04-12', '2025-04-19', 5, 'Lyon', 4670, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (141, 9, 5, 28, '2024-09-02', '2024-09-09', 1, 'Genève', 1100, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (142, 30, 4, 116, '2026-09-20', '2026-09-30', 4, 'Bordeaux', 4120, 'EN_ATTENTE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (143, 18, 1, 60, '2025-02-10', '2025-02-17', 2, 'Paris', 2230, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (144, 41, 9, 142, '2024-05-25', '2024-06-04', 3, 'Domicile', 3450, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (145, 24, 6, 31, '2026-01-05', '2026-01-12', 5, 'Paris', 4990, 'PAYEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (146, 3, 2, 99, '2025-10-25', '2025-11-01', 2, 'Lyon', 1780, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (147, 47, 8, 123, '2024-01-18', '2024-01-25', 4, 'Paris', 3670, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (148, 13, 1, 11, '2026-04-10', '2026-04-20', 1, 'Paris', 1450, 'CONFIRMEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (149, 32, 7, 72, '2025-07-18', '2025-07-25', 3, 'Lyon', 2780, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (150, 48, 3, 138, '2024-11-05', '2024-11-12', 2, 'Marseille', 2100, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (151, 10, 5, 46, '2026-08-22', '2026-09-01', 5, 'Genève', 4540, 'EN_ATTENTE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (152, 26, 4, 104, '2025-03-15', '2025-03-22', 4, 'Bordeaux', 3890, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (153, 39, 2, 19, '2024-06-20', '2024-06-27', 1, 'Lyon', 950, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (154, 1, 9, 88, '2026-12-08', '2026-12-18', 3, 'Domicile', 3120, 'PAYEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (155, 45, 1, 152, '2025-01-05', '2025-01-12', 2, 'Paris', 2340, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (156, 16, 6, 33, '2024-08-10', '2024-08-17', 5, 'Paris', 4890, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (157, 29, 8, 115, '2026-03-30', '2026-04-06', 4, 'Paris', 3780, 'CONFIRMEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (158, 42, 2, 5, '2025-11-10', '2025-11-20', 1, 'Lyon', 1340, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (159, 7, 5, 79, '2024-02-15', '2024-02-22', 3, 'Genève', 2670, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (160, 35, 3, 147, '2026-06-05', '2026-06-12', 2, 'Marseille', 1980, 'EN_ATTENTE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (161, 20, 1, 25, '2025-05-25', '2025-06-04', 5, 'Paris', 4650, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (162, 49, 7, 95, '2024-10-18', '2024-10-25', 4, 'Lyon', 3560, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (163, 11, 4, 129, '2026-02-02', '2026-02-09', 2, 'Bordeaux', 2450, 'PAYEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (164, 34, 9, 67, '2025-09-08', '2025-09-18', 3, 'Domicile', 3020, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (165, 4, 2, 134, '2024-03-22', '2024-03-29', 1, 'Lyon', 890, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (166, 25, 6, 10, '2026-10-15', '2026-10-22', 5, 'Paris', 4780, 'CONFIRMEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (167, 43, 8, 112, '2025-04-02', '2025-04-12', 4, 'Paris', 4210, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (168, 14, 1, 56, '2024-12-25', '2025-01-01', 2, 'Paris', 2560, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (169, 31, 5, 124, '2026-07-28', '2026-08-04', 3, 'Genève', 2890, 'EN_ATTENTE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (170, 46, 3, 43, '2025-02-12', '2025-02-19', 1, 'Marseille', 1200, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (171, 2, 2, 101, '2024-07-05', '2024-07-15', 5, 'Lyon', 4450, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (172, 37, 4, 151, '2026-11-22', '2026-11-29', 2, 'Bordeaux', 2100, 'PAYEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (173, 19, 7, 7, '2025-06-15', '2025-06-22', 4, 'Lyon', 3670, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (174, 50, 9, 83, '2024-04-28', '2024-05-08', 3, 'Domicile', 3340, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (175, 8, 1, 140, '2026-01-30', '2026-02-06', 2, 'Paris', 2230, 'CONFIRMEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (176, 30, 6, 22, '2025-10-10', '2025-10-17', 1, 'Paris', 1100, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (177, 40, 8, 64, '2024-09-20', '2024-09-30', 5, 'Paris', 4990, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (178, 12, 2, 118, '2026-05-05', '2026-05-12', 4, 'Lyon', 3780, 'EN_ATTENTE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (179, 27, 5, 36, '2025-03-08', '2025-03-15', 3, 'Genève', 2670, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (180, 47, 1, 93, '2024-01-20', '2024-01-30', 2, 'Paris', 2450, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (181, 6, 3, 146, '2026-09-12', '2026-09-19', 1, 'Marseille', 1250, 'PAYEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (182, 33, 4, 52, '2025-07-22', '2025-08-01', 5, 'Bordeaux', 4560, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (183, 15, 9, 13, '2024-11-28', '2024-12-05', 4, 'Domicile', 3900, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (184, 41, 2, 77, '2026-04-12', '2026-04-19', 2, 'Lyon', 2340, 'CONFIRMEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (185, 23, 7, 121, '2025-01-05', '2025-01-15', 3, 'Lyon', 3120, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (186, 38, 1, 30, '2024-06-08', '2024-06-15', 5, 'Paris', 4670, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (187, 5, 6, 105, '2026-10-30', '2026-11-06', 1, 'Paris', 1340, 'EN_ATTENTE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (188, 22, 8, 48, '2025-05-18', '2025-05-25', 4, 'Paris', 3560, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (189, 45, 5, 136, '2024-02-25', '2024-03-07', 2, 'Genève', 2890, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (190, 18, 2, 9, '2026-07-15', '2026-07-22', 3, 'Lyon', 2780, 'PAYEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (191, 32, 1, 85, '2025-11-08', '2025-11-15', 2, 'Paris', 2150, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (192, 48, 4, 152, '2024-08-30', '2024-09-09', 5, 'Bordeaux', 4890, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (193, 9, 9, 66, '2026-02-18', '2026-02-25', 1, 'Domicile', 980, 'CONFIRMEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (194, 28, 3, 23, '2025-09-25', '2025-10-02', 4, 'Marseille', 3670, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (195, 36, 1, 113, '2024-04-12', '2024-04-22', 3, 'Paris', 3230, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (196, 42, 6, 141, '2026-12-20', '2026-12-27', 2, 'Paris', 2560, 'EN_ATTENTE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (197, 13, 2, 41, '2025-06-05', '2025-06-12', 5, 'Lyon', 4450, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (198, 26, 7, 72, '2024-10-22', '2024-10-29', 1, 'Lyon', 1450, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (199, 44, 8, 98, '2026-05-15', '2026-05-25', 4, 'Paris', 4120, 'PAYEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (200, 3, 5, 12, '2025-02-08', '2025-02-15', 2, 'Genève', 2050, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (201, 31, 1, 107, '2024-07-28', '2024-08-04', 3, 'Paris', 3020, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (202, 49, 9, 34, '2026-09-02', '2026-09-09', 5, 'Domicile', 4900, 'CONFIRMEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (203, 10, 2, 130, '2025-04-25', '2025-05-02', 1, 'Lyon', 850, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (204, 39, 4, 59, '2024-12-15', '2024-12-22', 4, 'Bordeaux', 3780, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (205, 17, 3, 86, '2026-01-30', '2026-02-06', 2, 'Marseille', 2340, 'EN_ATTENTE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (206, 24, 6, 148, '2025-08-20', '2025-08-30', 3, 'Paris', 3450, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (207, 46, 1, 19, '2024-03-10', '2024-03-17', 5, 'Paris', 4560, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (208, 1, 8, 116, '2026-11-05', '2026-11-15', 2, 'Paris', 2670, 'PAYEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (209, 37, 2, 70, '2025-01-12', '2025-01-19', 4, 'Lyon', 3890, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (210, 20, 5, 2, '2024-09-05', '2024-09-12', 1, 'Genève', 1100, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (211, 43, 7, 92, '2026-06-25', '2026-07-02', 3, 'Lyon', 3120, 'CONFIRMEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (212, 11, 9, 144, '2025-05-05', '2025-05-15', 5, 'Domicile', 4780, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (213, 29, 1, 38, '2024-01-25', '2024-02-01', 2, 'Paris', 2230, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (214, 40, 2, 120, '2026-08-10', '2026-08-17', 4, 'Lyon', 4210, 'EN_ATTENTE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (215, 7, 4, 53, '2025-12-05', '2025-12-12', 1, 'Bordeaux', 1450, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (216, 34, 6, 81, '2024-05-20', '2024-05-30', 3, 'Paris', 3230, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (217, 16, 3, 102, '2026-03-15', '2026-03-22', 2, 'Marseille', 1980, 'PAYEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (218, 48, 8, 134, '2025-07-08', '2025-07-18', 5, 'Paris', 4990, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (219, 25, 1, 26, '2024-11-22', '2024-11-29', 4, 'Paris', 3670, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (220, 35, 5, 61, '2026-10-02', '2026-10-09', 1, 'Genève', 1200, 'CONFIRMEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (221, 12, 2, 150, '2025-02-25', '2025-03-04', 3, 'Lyon', 2780, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (222, 45, 9, 87, '2024-06-15', '2024-06-25', 2, 'Domicile', 2450, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (223, 2, 1, 114, '2026-04-20', '2026-04-27', 5, 'Paris', 4450, 'EN_ATTENTE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (224, 30, 4, 31, '2025-09-15', '2025-09-22', 4, 'Bordeaux', 3900, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (225, 18, 7, 73, '2024-02-08', '2024-02-15', 1, 'Lyon', 890, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (226, 42, 3, 129, '2026-12-25', '2027-01-01', 3, 'Marseille', 3450, 'PAYEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (227, 8, 6, 45, '2025-06-30', '2025-07-10', 2, 'Paris', 2560, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (228, 33, 2, 90, '2024-10-10', '2024-10-17', 5, 'Lyon', 4670, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (229, 21, 5, 145, '2026-07-05', '2026-07-12', 4, 'Genève', 3780, 'CONFIRMEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (230, 47, 8, 15, '2025-01-02', '2025-01-09', 1, 'Paris', 1340, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (231, 5, 1, 58, '2024-08-18', '2024-08-28', 3, 'Paris', 3120, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (232, 28, 9, 106, '2026-05-10', '2026-05-17', 2, 'Domicile', 2100, 'EN_ATTENTE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (233, 38, 2, 24, '2025-11-20', '2025-11-27', 5, 'Lyon', 4890, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (234, 13, 4, 76, '2024-03-05', '2024-03-12', 4, 'Bordeaux', 3670, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (235, 41, 6, 118, '2026-09-25', '2026-10-02', 1, 'Paris', 1450, 'PAYEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (236, 19, 3, 35, '2025-04-05', '2025-04-15', 3, 'Marseille', 3020, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (237, 36, 1, 88, '2024-12-18', '2024-12-25', 2, 'Paris', 2340, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (238, 49, 5, 132, '2026-02-15', '2026-02-22', 5, 'Genève', 4780, 'CONFIRMEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (239, 9, 2, 55, '2025-08-25', '2025-09-01', 4, 'Lyon', 3560, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (240, 26, 8, 10, '2024-05-30', '2024-06-06', 1, 'Paris', 980, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (241, 44, 7, 149, '2026-11-25', '2026-12-05', 3, 'Lyon', 3230, 'EN_ATTENTE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (242, 15, 1, 68, '2025-03-12', '2025-03-19', 2, 'Paris', 1890, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (243, 32, 4, 111, '2024-09-08', '2024-09-15', 5, 'Bordeaux', 4560, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (244, 50, 9, 22, '2026-06-18', '2026-06-28', 4, 'Domicile', 3900, 'PAYEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (245, 6, 2, 82, '2025-01-25', '2025-02-01', 1, 'Lyon', 1100, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (246, 23, 6, 126, '2024-07-10', '2024-07-17', 3, 'Paris', 2780, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (247, 40, 5, 41, '2026-03-22', '2026-03-29', 2, 'Genève', 2100, 'CONFIRMEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (248, 12, 1, 93, '2025-10-05', '2025-10-15', 5, 'Paris', 4990, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (249, 31, 3, 137, '2024-01-12', '2024-01-19', 4, 'Marseille', 3670, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (250, 45, 8, 5, '2026-08-10', '2026-08-17', 1, 'Paris', 1250, 'EN_ATTENTE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (251, 18, 2, 72, '2025-06-02', '2025-06-09', 3, 'Lyon', 2900, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (252, 35, 7, 117, '2024-11-18', '2024-11-25', 2, 'Lyon', 1670, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (253, 2, 4, 37, '2026-04-25', '2026-05-05', 5, 'Bordeaux', 4780, 'PAYEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (254, 48, 1, 90, '2025-02-20', '2025-02-27', 4, 'Paris', 3890, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (255, 27, 9, 143, '2024-04-30', '2024-05-07', 1, 'Domicile', 950, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (256, 10, 2, 28, '2026-12-12', '2026-12-19', 3, 'Lyon', 2670, 'CONFIRMEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (257, 37, 5, 60, '2025-09-01', '2025-09-08', 2, 'Genève', 1890, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (258, 20, 6, 109, '2024-06-15', '2024-06-25', 5, 'Paris', 4670, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (259, 43, 1, 15, '2026-02-05', '2026-02-12', 4, 'Paris', 3560, 'EN_ATTENTE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (260, 4, 8, 84, '2025-11-25', '2025-12-02', 1, 'Paris', 1340, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (261, 29, 2, 128, '2024-08-25', '2024-09-01', 3, 'Lyon', 3120, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (262, 47, 3, 44, '2026-05-20', '2026-05-30', 2, 'Marseille', 2340, 'PAYEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (263, 14, 4, 99, '2025-03-10', '2025-03-17', 5, 'Bordeaux', 4560, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (264, 34, 1, 19, '2024-10-05', '2024-10-12', 4, 'Paris', 3780, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (265, 8, 9, 63, '2026-09-15', '2026-09-22', 1, 'Domicile', 890, 'CONFIRMEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (266, 41, 5, 110, '2025-07-28', '2025-08-04', 3, 'Genève', 2890, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (267, 24, 2, 50, '2024-03-18', '2024-03-25', 2, 'Lyon', 1560, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (268, 38, 7, 133, '2026-01-08', '2026-01-18', 5, 'Lyon', 4890, 'EN_ATTENTE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (269, 17, 6, 75, '2025-12-15', '2025-12-22', 4, 'Paris', 3900, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (270, 46, 1, 23, '2024-02-28', '2024-03-07', 1, 'Paris', 1230, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (271, 3, 8, 96, '2026-07-10', '2026-07-17', 3, 'Paris', 2780, 'PAYEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (272, 22, 4, 141, '2025-04-22', '2025-04-29', 2, 'Bordeaux', 2100, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (273, 49, 2, 62, '2024-09-12', '2024-09-19', 5, 'Lyon', 4670, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (274, 11, 1, 106, '2026-03-28', '2026-04-04', 4, 'Paris', 3670, 'CONFIRMEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (275, 30, 3, 33, '2025-01-15', '2025-01-25', 1, 'Marseille', 1100, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (276, 42, 5, 88, '2024-05-30', '2024-06-06', 3, 'Genève', 3020, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (277, 16, 9, 121, '2026-10-20', '2026-10-27', 2, 'Domicile', 1780, 'EN_ATTENTE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (278, 33, 6, 48, '2025-08-05', '2025-08-12', 5, 'Paris', 4990, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (279, 7, 2, 115, '2024-11-12', '2024-11-19', 4, 'Lyon', 3560, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (280, 25, 1, 57, '2026-06-02', '2026-06-12', 1, 'Paris', 1450, 'PAYEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (281, 45, 8, 138, '2025-03-20', '2025-03-27', 3, 'Paris', 2560, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (282, 13, 4, 71, '2024-01-05', '2024-01-12', 2, 'Bordeaux', 2340, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (283, 36, 2, 9, '2026-08-25', '2026-09-01', 5, 'Lyon', 4450, 'CONFIRMEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (284, 5, 7, 104, '2025-05-28', '2025-06-04', 4, 'Lyon', 3780, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (285, 28, 1, 152, '2024-07-22', '2024-07-29', 1, 'Paris', 920, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (286, 40, 5, 30, '2026-04-10', '2026-04-20', 3, 'Genève', 3230, 'EN_ATTENTE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (287, 19, 9, 83, '2025-11-05', '2025-11-12', 2, 'Domicile', 1890, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (288, 31, 3, 126, '2024-04-18', '2024-04-25', 5, 'Marseille', 4780, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (289, 44, 2, 65, '2026-12-01', '2026-12-08', 4, 'Lyon', 4120, 'PAYEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (290, 1, 6, 142, '2025-02-12', '2025-02-19', 1, 'Paris', 1100, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (291, 21, 1, 46, '2024-09-30', '2024-10-07', 3, 'Paris', 2900, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (292, 37, 8, 97, '2026-02-22', '2026-03-04', 2, 'Paris', 2150, 'CONFIRMEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (293, 12, 4, 114, '2025-09-10', '2025-09-17', 5, 'Bordeaux', 4560, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (294, 48, 2, 17, '2024-03-15', '2024-03-22', 4, 'Lyon', 3670, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (295, 23, 1, 80, '2026-05-18', '2026-05-25', 1, 'Paris', 1020, 'EN_ATTENTE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (296, 39, 5, 131, '2025-07-05', '2025-07-15', 3, 'Genève', 3450, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (297, 9, 9, 39, '2024-12-28', '2025-01-04', 2, 'Domicile', 2230, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (298, 27, 2, 77, '2026-09-22', '2026-09-29', 5, 'Lyon', 4890, 'PAYEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (299, 43, 6, 122, '2025-04-08', '2025-04-15', 4, 'Paris', 3780, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (300, 15, 3, 22, '2024-06-25', '2024-07-02', 1, 'Marseille', 1250, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (301, 34, 1, 108, '2026-01-10', '2026-01-17', 3, 'Paris', 2670, 'CONFIRMEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (302, 47, 8, 54, '2025-10-20', '2025-10-30', 2, 'Paris', 2340, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (303, 2, 4, 149, '2024-02-05', '2024-02-12', 5, 'Bordeaux', 4990, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (304, 26, 2, 40, '2026-07-30', '2026-08-06', 4, 'Lyon', 3890, 'EN_ATTENTE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (305, 42, 7, 91, '2025-05-15', '2025-05-22', 1, 'Lyon', 1340, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (306, 17, 1, 128, '2024-08-12', '2024-08-19', 3, 'Paris', 2780, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (307, 32, 5, 11, '2026-03-05', '2026-03-12', 2, 'Genève', 1890, 'PAYEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (308, 49, 9, 69, '2025-11-28', '2025-12-08', 5, 'Domicile', 4670, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (309, 6, 2, 140, '2024-05-22', '2024-05-29', 4, 'Lyon', 3560, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (310, 22, 6, 28, '2026-10-25', '2026-11-01', 1, 'Paris', 980, 'CONFIRMEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (311, 38, 1, 103, '2025-01-20', '2025-01-27', 3, 'Paris', 3120, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (312, 10, 3, 51, '2024-10-10', '2024-10-17', 2, 'Marseille', 2100, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (313, 45, 8, 119, '2026-06-18', '2026-06-25', 5, 'Paris', 4780, 'EN_ATTENTE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (314, 20, 2, 14, '2025-03-25', '2025-04-04', 4, 'Lyon', 3670, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (315, 35, 4, 82, '2024-01-30', '2024-02-06', 1, 'Bordeaux', 1200, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (316, 4, 1, 133, '2026-08-28', '2026-09-04', 3, 'Paris', 2900, 'PAYEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (317, 30, 5, 25, '2025-06-10', '2025-06-17', 2, 'Genève', 2230, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (318, 14, 2, 76, '2024-09-05', '2024-09-12', 5, 'Lyon', 4450, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (319, 41, 6, 127, '2026-04-15', '2026-04-22', 4, 'Paris', 3900, 'CONFIRMEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (320, 18, 1, 48, '2025-11-05', '2025-11-15', 1, 'Paris', 1150, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (321, 33, 9, 93, '2024-04-25', '2024-05-02', 3, 'Domicile', 2780, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (322, 50, 2, 151, '2026-12-22', '2026-12-29', 2, 'Lyon', 2340, 'EN_ATTENTE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (323, 7, 8, 36, '2025-02-18', '2025-02-25', 5, 'Paris', 4890, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (324, 24, 1, 105, '2024-11-15', '2024-11-22', 4, 'Paris', 3780, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (325, 46, 3, 62, '2026-02-05', '2026-02-12', 1, 'Marseille', 890, 'PAYEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (326, 11, 2, 124, '2025-08-30', '2025-09-09', 3, 'Lyon', 3020, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (327, 29, 7, 19, '2024-03-12', '2024-03-19', 2, 'Lyon', 1890, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (328, 43, 4, 89, '2026-10-25', '2026-11-01', 5, 'Bordeaux', 4560, 'CONFIRMEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (329, 5, 1, 144, '2025-05-22', '2025-05-29', 4, 'Paris', 3670, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (330, 25, 5, 43, '2024-07-28', '2024-08-04', 1, 'Genève', 1250, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (331, 39, 2, 98, '2026-07-12', '2026-07-19', 3, 'Lyon', 2670, 'EN_ATTENTE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (332, 13, 9, 7, '2025-01-08', '2025-01-18', 2, 'Domicile', 2150, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (333, 48, 1, 112, '2024-12-05', '2024-12-12', 5, 'Paris', 4780, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (334, 22, 6, 65, '2026-05-05', '2026-05-12', 4, 'Paris', 3890, 'PAYEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (335, 37, 2, 132, '2025-09-15', '2025-09-22', 1, 'Lyon', 1340, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (336, 1, 8, 29, '2024-06-22', '2024-06-29', 3, 'Paris', 2780, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (337, 42, 1, 86, '2026-01-30', '2026-02-06', 2, 'Paris', 2450, 'CONFIRMEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (338, 28, 2, 122, '2025-07-20', '2025-07-30', 5, 'Lyon', 4230, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (339, 8, 5, 50, '2024-02-15', '2024-02-22', 4, 'Genève', 3560, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (340, 31, 1, 100, '2026-09-08', '2026-09-15', 1, 'Paris', 920, 'EN_ATTENTE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (341, 45, 3, 15, '2025-04-10', '2025-04-17', 3, 'Marseille', 2890, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (342, 16, 4, 73, '2024-10-25', '2024-11-01', 2, 'Bordeaux', 2100, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (343, 34, 2, 127, '2026-06-28', '2026-07-08', 5, 'Lyon', 4990, 'PAYEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (344, 49, 9, 3, '2025-02-28', '2025-03-07', 4, 'Domicile', 3670, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (345, 12, 1, 91, '2024-09-02', '2024-09-09', 1, 'Paris', 1100, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (346, 27, 6, 56, '2026-03-20', '2026-03-27', 3, 'Paris', 2560, 'CONFIRMEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (347, 40, 2, 139, '2025-11-12', '2025-11-19', 2, 'Lyon', 1890, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (348, 3, 8, 26, '2024-05-05', '2024-05-15', 5, 'Paris', 4670, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (349, 23, 1, 84, '2026-12-05', '2026-12-12', 4, 'Paris', 3780, 'EN_ATTENTE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (350, 47, 2, 117, '2025-06-22', '2025-06-29', 1, 'Lyon', 1230, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (351, 9, 7, 42, '2024-01-25', '2024-02-01', 3, 'Lyon', 3020, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (352, 33, 1, 95, '2026-08-15', '2026-08-22', 2, 'Paris', 2450, 'PAYEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (353, 19, 5, 135, '2025-03-30', '2025-04-09', 5, 'Genève', 4780, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (354, 44, 2, 60, '2024-11-20', '2024-11-27', 4, 'Lyon', 3890, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (355, 2, 3, 148, '2026-04-12', '2026-04-19', 1, 'Marseille', 1450, 'CONFIRMEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (356, 26, 1, 8, '2025-10-05', '2025-10-12', 3, 'Paris', 2670, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (357, 39, 4, 79, '2024-07-15', '2024-07-22', 2, 'Bordeaux', 2340, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (358, 15, 2, 123, '2026-02-28', '2026-03-07', 5, 'Lyon', 4450, 'EN_ATTENTE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (359, 48, 9, 37, '2025-08-08', '2025-08-18', 4, 'Domicile', 3560, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (360, 6, 1, 94, '2024-03-18', '2024-03-25', 1, 'Paris', 980, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (361, 30, 2, 151, '2026-11-28', '2026-12-05', 3, 'Lyon', 3120, 'PAYEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (362, 43, 6, 12, '2025-05-15', '2025-05-22', 2, 'Paris', 2150, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (363, 17, 1, 64, '2024-12-10', '2024-12-17', 5, 'Paris', 4560, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (364, 41, 2, 107, '2026-07-20', '2026-07-30', 4, 'Lyon', 3900, 'CONFIRMEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (365, 21, 5, 29, '2025-01-25', '2025-02-01', 1, 'Genève', 1200, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (366, 36, 1, 83, '2024-09-08', '2024-09-15', 3, 'Paris', 2780, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (367, 10, 8, 138, '2026-05-02', '2026-05-09', 2, 'Paris', 2100, 'EN_ATTENTE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (368, 45, 2, 51, '2025-11-18', '2025-11-25', 5, 'Lyon', 4890, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (369, 29, 3, 115, '2024-05-12', '2024-05-19', 4, 'Marseille', 3670, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (370, 4, 1, 74, '2026-01-05', '2026-01-15', 1, 'Paris', 1340, 'PAYEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (371, 38, 2, 19, '2025-09-22', '2025-09-29', 3, 'Lyon', 2900, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (372, 14, 9, 96, '2024-02-28', '2024-03-07', 2, 'Domicile', 2230, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (373, 49, 1, 142, '2026-10-10', '2026-10-17', 5, 'Paris', 4670, 'CONFIRMEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (374, 24, 2, 33, '2025-04-05', '2025-04-12', 4, 'Lyon', 3780, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (375, 7, 4, 109, '2024-11-25', '2024-12-02', 1, 'Bordeaux', 890, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (376, 32, 1, 57, '2026-06-25', '2026-07-02', 3, 'Paris', 3230, 'EN_ATTENTE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (377, 42, 2, 123, '2025-02-15', '2025-02-22', 2, 'Lyon', 2340, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (378, 20, 7, 70, '2024-08-20', '2024-08-30', 5, 'Lyon', 4990, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (379, 47, 1, 11, '2026-03-12', '2026-03-19', 4, 'Paris', 3890, 'PAYEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (380, 12, 2, 85, '2025-12-08', '2025-12-15', 1, 'Lyon', 1250, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (381, 35, 6, 136, '2024-06-02', '2024-06-09', 3, 'Paris', 2780, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (382, 5, 1, 40, '2026-09-18', '2026-09-25', 2, 'Paris', 2100, 'CONFIRMEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (383, 27, 2, 92, '2025-03-30', '2025-04-09', 5, 'Lyon', 4560, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (384, 46, 5, 153, '2024-01-12', '2024-01-19', 4, 'Genève', 3670, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (385, 18, 1, 21, '2026-11-20', '2026-11-27', 1, 'Paris', 1100, 'EN_ATTENTE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (386, 33, 2, 78, '2025-07-10', '2025-07-17', 3, 'Lyon', 2560, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (387, 8, 8, 132, '2024-10-30', '2024-11-06', 2, 'Paris', 2450, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (388, 40, 1, 59, '2026-02-28', '2026-03-07', 5, 'Paris', 4780, 'PAYEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (389, 22, 2, 102, '2025-09-05', '2025-09-12', 4, 'Lyon', 3900, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (390, 48, 3, 27, '2024-04-18', '2024-04-25', 1, 'Marseille', 980, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (391, 13, 1, 147, '2026-05-25', '2026-06-04', 3, 'Paris', 3230, 'CONFIRMEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (392, 31, 9, 68, '2025-01-05', '2025-01-12', 2, 'Domicile', 2150, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (393, 44, 2, 111, '2024-07-25', '2024-08-01', 5, 'Lyon', 4450, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (394, 25, 1, 16, '2026-10-08', '2026-10-15', 4, 'Paris', 4120, 'EN_ATTENTE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (395, 3, 2, 87, '2025-06-18', '2025-06-25', 1, 'Lyon', 1340, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (396, 37, 4, 125, '2024-12-22', '2024-12-29', 3, 'Bordeaux', 2780, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (397, 45, 1, 49, '2026-01-15', '2026-01-22', 2, 'Paris', 2100, 'PAYEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (398, 16, 2, 103, '2025-08-25', '2025-09-04', 5, 'Lyon', 4890, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (399, 29, 6, 20, '2024-02-10', '2024-02-17', 4, 'Paris', 3560, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (400, 42, 1, 141, '2026-07-02', '2026-07-09', 1, 'Paris', 1230, 'CONFIRMEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (401, 11, 2, 61, '2025-04-12', '2025-04-19', 3, 'Lyon', 3020, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (402, 34, 5, 98, '2024-09-22', '2024-09-29', 2, 'Genève', 2340, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (403, 49, 1, 124, '2026-11-30', '2026-12-07', 5, 'Paris', 4560, 'EN_ATTENTE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (404, 21, 2, 32, '2025-02-20', '2025-02-27', 4, 'Lyon', 3670, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (405, 36, 7, 85, '2024-05-15', '2024-05-25', 1, 'Lyon', 950, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (406, 6, 1, 152, '2026-04-05', '2026-04-12', 3, 'Paris', 2900, 'PAYEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (407, 43, 2, 53, '2025-10-30', '2025-11-06', 2, 'Lyon', 1890, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (408, 15, 8, 110, '2024-01-02', '2024-01-09', 5, 'Paris', 4780, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (409, 30, 1, 14, '2026-08-12', '2026-08-19', 4, 'Paris', 4120, 'CONFIRMEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (410, 47, 2, 104, '2025-05-22', '2025-05-29', 1, 'Lyon', 1450, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (411, 24, 3, 43, '2024-11-10', '2024-11-17', 3, 'Marseille', 2670, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (412, 9, 1, 136, '2026-01-28', '2026-02-04', 2, 'Paris', 2450, 'EN_ATTENTE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (413, 38, 9, 75, '2025-07-15', '2025-07-25', 5, 'Domicile', 4990, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (414, 50, 1, 24, '2024-04-28', '2024-05-05', 4, 'Paris', 3780, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (415, 18, 2, 118, '2026-09-02', '2026-09-09', 1, 'Lyon', 1100, 'PAYEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (416, 32, 4, 69, '2025-01-12', '2025-01-19', 3, 'Bordeaux', 3120, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (417, 46, 1, 143, '2024-08-05', '2024-08-12', 2, 'Paris', 2230, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (418, 2, 2, 38, '2026-03-25', '2026-04-04', 5, 'Lyon', 4450, 'CONFIRMEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (419, 26, 5, 93, '2025-12-10', '2025-12-17', 4, 'Genève', 3900, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (420, 41, 1, 5, '2024-06-20', '2024-06-27', 1, 'Paris', 1250, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (421, 12, 2, 108, '2026-10-30', '2026-11-06', 3, 'Lyon', 3450, 'EN_ATTENTE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (422, 35, 6, 52, '2025-03-08', '2025-03-15', 2, 'Paris', 2150, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (423, 7, 1, 121, '2024-12-01', '2024-12-08', 5, 'Paris', 4560, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (424, 22, 2, 19, '2026-06-15', '2026-06-22', 4, 'Lyon', 3560, 'PAYEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (425, 48, 8, 82, '2025-09-30', '2025-10-07', 1, 'Paris', 950, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (426, 14, 1, 139, '2024-02-25', '2024-03-04', 3, 'Paris', 2780, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (427, 28, 2, 47, '2026-04-18', '2026-04-25', 2, 'Lyon', 1890, 'CONFIRMEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (428, 40, 1, 99, '2025-11-22', '2025-11-29', 5, 'Paris', 4890, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (429, 5, 2, 26, '2024-07-12', '2024-07-19', 4, 'Lyon', 3670, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (430, 19, 1, 114, '2026-01-08', '2026-01-15', 1, 'Paris', 1340, 'EN_ATTENTE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (431, 33, 9, 62, '2025-06-25', '2025-07-05', 3, 'Domicile', 3230, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (432, 44, 1, 153, '2024-09-18', '2024-09-25', 2, 'Paris', 2450, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (433, 25, 2, 10, '2026-11-12', '2026-11-19', 5, 'Lyon', 4210, 'PAYEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (434, 10, 4, 88, '2025-02-05', '2025-02-12', 4, 'Bordeaux', 3780, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (435, 37, 1, 126, '2024-05-22', '2024-05-29', 1, 'Paris', 1100, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (436, 49, 2, 34, '2026-07-28', '2026-08-04', 3, 'Lyon', 2670, 'CONFIRMEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (437, 1, 5, 135, '2025-12-10', '2025-12-17', 2, 'Genève', 2340, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (438, 20, 1, 59, '2024-03-30', '2024-04-06', 5, 'Paris', 4670, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (439, 42, 2, 102, '2026-02-18', '2026-02-25', 4, 'Lyon', 3450, 'EN_ATTENTE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (440, 13, 7, 16, '2025-08-12', '2025-08-22', 1, 'Lyon', 1230, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (441, 31, 1, 71, '2024-10-08', '2024-10-15', 3, 'Paris', 3020, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (442, 47, 2, 147, '2026-05-30', '2026-06-06', 2, 'Lyon', 1780, 'PAYEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (443, 8, 3, 28, '2025-01-20', '2025-01-27', 5, 'Marseille', 4120, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (444, 27, 1, 91, '2024-06-12', '2024-06-19', 4, 'Paris', 3560, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (445, 39, 2, 116, '2026-09-02', '2026-09-09', 1, 'Lyon', 890, 'CONFIRMEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (446, 17, 1, 41, '2025-04-18', '2025-04-25', 3, 'Paris', 2900, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (447, 46, 6, 108, '2024-11-25', '2024-12-02', 2, 'Paris', 2100, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (448, 3, 2, 137, '2026-03-10', '2026-03-17', 5, 'Lyon', 4780, 'EN_ATTENTE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (449, 29, 9, 63, '2025-06-25', '2025-07-05', 4, 'Domicile', 3230, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (450, 43, 1, 86, '2024-01-15', '2024-01-22', 1, 'Paris', 1450, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (451, 16, 2, 12, '2026-11-12', '2026-11-19', 3, 'Lyon', 3120, 'PAYEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (452, 36, 1, 52, '2025-03-05', '2025-03-12', 2, 'Paris', 1890, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (453, 6, 4, 128, '2024-08-30', '2024-09-06', 5, 'Bordeaux', 4890, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (454, 24, 1, 104, '2026-01-25', '2026-02-01', 4, 'Paris', 3450, 'CONFIRMEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (455, 41, 2, 33, '2025-09-15', '2025-09-22', 1, 'Lyon', 980, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (456, 11, 1, 79, '2024-04-05', '2024-04-12', 3, 'Paris', 2560, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (457, 32, 5, 148, '2026-06-20', '2026-06-27', 2, 'Genève', 2340, 'EN_ATTENTE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (458, 48, 2, 15, '2025-02-12', '2025-02-19', 5, 'Lyon', 4450, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (459, 21, 1, 90, '2024-10-10', '2024-10-17', 4, 'Paris', 3670, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (460, 35, 2, 119, '2026-08-08', '2026-08-15', 1, 'Lyon', 1100, 'PAYEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (461, 4, 8, 46, '2025-05-22', '2025-05-29', 3, 'Paris', 2780, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (462, 18, 1, 72, '2024-12-25', '2025-01-01', 2, 'Paris', 2100, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (463, 45, 2, 133, '2026-04-02', '2026-04-09', 5, 'Lyon', 4900, 'CONFIRMEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (464, 23, 1, 24, '2025-11-20', '2025-11-27', 4, 'Paris', 3340, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (465, 38, 3, 101, '2024-07-12', '2024-07-19', 1, 'Marseille', 1250, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (466, 15, 2, 60, '2026-10-25', '2026-11-01', 3, 'Lyon', 3020, 'EN_ATTENTE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (467, 30, 9, 144, '2025-01-30', '2025-02-09', 2, 'Domicile', 1780, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (468, 44, 1, 87, '2024-09-02', '2024-09-09', 5, 'Paris', 4670, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (469, 2, 2, 32, '2026-02-28', '2026-03-07', 4, 'Lyon', 3560, 'PAYEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (470, 34, 1, 112, '2025-06-15', '2025-06-22', 1, 'Paris', 1340, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (471, 9, 6, 70, '2024-03-05', '2024-03-12', 3, 'Paris', 2900, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (472, 40, 2, 138, '2026-09-18', '2026-09-25', 2, 'Lyon', 1890, 'CONFIRMEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (473, 26, 1, 20, '2025-04-10', '2025-04-17', 5, 'Paris', 4120, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (474, 12, 4, 93, '2024-11-15', '2024-11-22', 4, 'Bordeaux', 3230, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (475, 47, 2, 53, '2026-05-12', '2026-05-19', 1, 'Lyon', 890, 'EN_ATTENTE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (476, 22, 1, 129, '2025-08-30', '2025-09-06', 3, 'Paris', 2670, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (477, 37, 2, 8, '2024-02-25', '2024-03-04', 2, 'Lyon', 2230, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (478, 5, 5, 66, '2026-11-05', '2026-11-12', 5, 'Genève', 4320, 'PAYEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (479, 28, 1, 106, '2025-03-18', '2025-03-25', 4, 'Paris', 3780, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (480, 42, 2, 150, '2024-06-08', '2024-06-15', 1, 'Lyon', 1150, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (481, 13, 1, 38, '2026-07-25', '2026-08-01', 3, 'Paris', 2780, 'CONFIRMEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (482, 31, 2, 116, '2025-12-15', '2025-12-22', 2, 'Lyon', 1560, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (483, 46, 7, 73, '2024-05-22', '2024-06-01', 5, 'Lyon', 4780, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (484, 19, 1, 142, '2026-03-05', '2026-03-12', 4, 'Paris', 3450, 'EN_ATTENTE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (485, 33, 9, 27, '2025-07-02', '2025-07-12', 1, 'Domicile', 1250, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (486, 7, 2, 97, '2024-10-30', '2024-11-06', 3, 'Lyon', 2450, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (487, 25, 1, 58, '2026-08-20', '2026-08-27', 2, 'Paris', 2100, 'PAYEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (488, 43, 3, 125, '2025-02-08', '2025-02-15', 5, 'Marseille', 4890, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (489, 14, 2, 45, '2024-01-10', '2024-01-17', 4, 'Lyon', 3560, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (490, 35, 1, 102, '2026-10-22', '2026-10-29', 1, 'Paris', 920, 'CONFIRMEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (491, 49, 2, 81, '2025-09-12', '2025-09-19', 3, 'Lyon', 3120, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (492, 20, 4, 137, '2024-04-15', '2024-04-22', 2, 'Bordeaux', 1890, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (493, 38, 1, 18, '2026-06-12', '2026-06-19', 5, 'Paris', 4990, 'EN_ATTENTE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (494, 2, 2, 113, '2025-01-28', '2025-02-04', 4, 'Lyon', 3780, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (495, 27, 8, 62, '2024-09-25', '2024-10-02', 1, 'Paris', 1340, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (496, 42, 2, 146, '2026-02-25', '2026-03-04', 3, 'Lyon', 2560, 'PAYEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (497, 10, 1, 31, '2025-06-25', '2025-07-02', 2, 'Paris', 2230, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (498, 32, 5, 88, '2024-12-05', '2024-12-12', 5, 'Genève', 4120, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (499, 48, 2, 130, '2026-09-08', '2026-09-15', 4, 'Lyon', 3670, 'CONFIRMEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (500, 16, 1, 54, '2025-04-05', '2025-04-12', 1, 'Paris', 980, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (501, 29, 2, 99, '2024-08-12', '2024-08-19', 3, 'Lyon', 2890, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (502, 44, 9, 22, '2026-11-15', '2026-11-25', 2, 'Domicile', 2340, 'EN_ATTENTE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (503, 5, 1, 108, '2025-03-18', '2025-03-25', 5, 'Paris', 4670, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (504, 23, 2, 69, '2024-05-30', '2024-06-06', 4, 'Lyon', 3450, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (505, 37, 6, 143, '2026-04-20', '2026-04-27', 1, 'Paris', 1150, 'PAYEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (506, 1, 2, 39, '2025-10-12', '2025-10-19', 3, 'Lyon', 3230, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (507, 41, 1, 117, '2024-03-02', '2024-03-09', 2, 'Paris', 1890, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (508, 18, 7, 74, '2026-07-28', '2026-08-07', 5, 'Lyon', 4230, 'CONFIRMEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (509, 34, 2, 12, '2025-02-08', '2025-02-15', 4, 'Lyon', 3020, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (510, 45, 1, 100, '2024-11-22', '2024-11-29', 1, 'Paris', 1450, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (511, 11, 2, 57, '2026-10-02', '2026-10-09', 3, 'Lyon', 2670, 'EN_ATTENTE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (512, 30, 4, 131, '2025-05-25', '2025-06-01', 2, 'Bordeaux', 2150, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (513, 47, 1, 16, '2024-01-20', '2024-01-27', 5, 'Paris', 4780, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (514, 21, 2, 94, '2026-05-10', '2026-05-17', 4, 'Lyon', 3990, 'PAYEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (515, 36, 1, 49, '2025-09-30', '2025-10-07', 1, 'Paris', 850, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (516, 6, 2, 112, '2024-07-08', '2024-07-15', 3, 'Lyon', 3340, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (517, 26, 8, 79, '2026-01-15', '2026-01-22', 2, 'Paris', 2450, 'CONFIRMEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (518, 42, 2, 135, '2025-04-05', '2025-04-12', 5, 'Lyon', 4890, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (519, 13, 1, 25, '2024-09-15', '2024-09-22', 4, 'Paris', 3560, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (520, 33, 2, 107, '2026-08-20', '2026-08-27', 1, 'Lyon', 1230, 'EN_ATTENTE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (521, 49, 3, 67, '2025-01-28', '2025-02-04', 3, 'Marseille', 2900, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (522, 22, 1, 149, '2024-06-10', '2024-06-17', 2, 'Paris', 1780, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (523, 40, 2, 32, '2026-03-25', '2026-04-01', 5, 'Lyon', 4120, 'PAYEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (524, 7, 5, 84, '2025-08-15', '2025-08-22', 4, 'Genève', 3780, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (525, 25, 2, 126, '2024-02-25', '2024-03-04', 1, 'Lyon', 1100, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (526, 44, 1, 52, '2026-11-28', '2026-12-05', 3, 'Paris', 2560, 'CONFIRMEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (527, 15, 2, 104, '2025-06-20', '2025-06-27', 2, 'Lyon', 2230, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (528, 32, 9, 145, '2024-12-12', '2024-12-22', 5, 'Domicile', 4670, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (529, 48, 1, 19, '2026-04-22', '2026-04-29', 4, 'Paris', 3450, 'EN_ATTENTE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (530, 20, 2, 72, '2025-11-10', '2025-11-17', 1, 'Lyon', 1340, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (531, 38, 1, 117, '2024-05-02', '2024-05-09', 3, 'Paris', 3120, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (532, 4, 6, 40, '2026-09-08', '2026-09-15', 2, 'Paris', 2100, 'PAYEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (533, 27, 2, 92, '2025-02-18', '2025-02-25', 5, 'Lyon', 4450, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (534, 46, 1, 134, '2024-10-25', '2024-11-01', 4, 'Paris', 3230, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (535, 12, 2, 63, '2026-02-05', '2026-02-12', 1, 'Lyon', 980, 'CONFIRMEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (536, 31, 1, 105, '2025-07-25', '2025-08-01', 3, 'Paris', 2890, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (537, 43, 7, 26, '2024-04-12', '2024-04-22', 2, 'Lyon', 1560, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (538, 9, 1, 88, '2026-10-30', '2026-11-06', 5, 'Paris', 4990, 'EN_ATTENTE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (539, 28, 2, 141, '2025-03-12', '2025-03-19', 4, 'Lyon', 3670, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (540, 45, 1, 55, '2024-08-02', '2024-08-09', 1, 'Paris', 1250, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (541, 16, 2, 112, '2026-06-15', '2026-06-22', 3, 'Lyon', 2670, 'PAYEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (542, 35, 4, 30, '2025-12-05', '2025-12-12', 2, 'Bordeaux', 2340, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (543, 2, 1, 99, '2024-01-25', '2024-02-01', 5, 'Paris', 4780, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (544, 42, 2, 123, '2026-03-20', '2026-03-27', 4, 'Lyon', 3560, 'CONFIRMEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (545, 19, 1, 75, '2025-09-08', '2025-09-15', 1, 'Paris', 890, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (546, 37, 2, 10, '2024-06-05', '2024-06-12', 3, 'Lyon', 3020, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (547, 49, 1, 150, '2026-11-18', '2026-11-25', 2, 'Paris', 1890, 'EN_ATTENTE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (548, 14, 5, 48, '2025-04-20', '2025-04-27', 5, 'Genève', 4120, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (549, 32, 2, 120, '2024-11-10', '2024-11-17', 4, 'Lyon', 3900, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (550, 47, 1, 65, '2026-07-28', '2026-08-04', 1, 'Paris', 1150, 'PAYEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (551, 23, 2, 96, '2025-01-15', '2025-01-22', 3, 'Lyon', 2780, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (552, 40, 8, 22, '2024-09-25', '2024-10-02', 2, 'Paris', 2100, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (553, 5, 2, 141, '2026-04-05', '2026-04-12', 5, 'Lyon', 4560, 'CONFIRMEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (554, 26, 1, 79, '2025-10-18', '2025-10-25', 4, 'Paris', 3450, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (555, 44, 2, 108, '2024-03-30', '2024-04-06', 1, 'Lyon', 1340, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (556, 11, 9, 52, '2026-12-25', '2027-01-04', 3, 'Domicile', 2900, 'EN_ATTENTE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (557, 34, 2, 129, '2025-05-28', '2025-06-04', 2, 'Lyon', 1780, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (558, 50, 1, 15, '2024-02-12', '2024-02-19', 5, 'Paris', 4890, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (559, 18, 2, 87, '2026-09-08', '2026-09-15', 4, 'Lyon', 3230, 'PAYEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (560, 39, 3, 31, '2025-12-05', '2025-12-12', 1, 'Marseille', 950, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (561, 3, 2, 114, '2024-07-20', '2024-07-27', 3, 'Lyon', 3120, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (562, 27, 1, 61, '2026-01-30', '2026-02-06', 2, 'Paris', 2340, 'CONFIRMEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (563, 45, 2, 136, '2025-08-15', '2025-08-22', 5, 'Lyon', 4210, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (564, 13, 1, 29, '2024-05-05', '2024-05-12', 4, 'Paris', 3780, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (565, 36, 4, 102, '2026-10-10', '2026-10-17', 1, 'Bordeaux', 1250, 'EN_ATTENTE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (566, 48, 2, 55, '2025-03-25', '2025-04-01', 3, 'Lyon', 2560, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (567, 21, 1, 146, '2024-11-12', '2024-11-19', 2, 'Paris', 2150, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (568, 42, 2, 83, '2026-06-25', '2026-07-02', 5, 'Lyon', 4990, 'PAYEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (569, 7, 7, 13, '2025-01-18', '2025-01-28', 4, 'Lyon', 3560, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (570, 30, 2, 122, '2024-08-08', '2024-08-15', 1, 'Lyon', 1100, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (571, 46, 1, 68, '2026-03-12', '2026-03-19', 3, 'Paris', 3020, 'CONFIRMEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (572, 17, 2, 151, '2025-10-25', '2025-11-01', 2, 'Lyon', 1890, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (573, 38, 5, 42, '2024-04-18', '2024-04-25', 5, 'Genève', 4670, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (574, 1, 2, 106, '2026-11-20', '2026-11-27', 4, 'Lyon', 3450, 'EN_ATTENTE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (575, 25, 1, 19, '2025-06-08', '2025-06-15', 1, 'Paris', 980, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (576, 41, 2, 125, '2024-12-28', '2025-01-04', 3, 'Lyon', 2780, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (577, 10, 6, 74, '2026-08-12', '2026-08-19', 2, 'Paris', 2450, 'PAYEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (578, 33, 2, 36, '2025-02-28', '2025-03-07', 5, 'Lyon', 4780, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (579, 49, 1, 113, '2024-09-22', '2024-09-29', 4, 'Paris', 3230, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (580, 20, 2, 59, '2026-04-15', '2026-04-22', 1, 'Lyon', 1340, 'CONFIRMEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (581, 43, 8, 147, '2025-11-10', '2025-11-17', 3, 'Paris', 2670, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (582, 12, 2, 89, '2024-06-05', '2024-06-12', 2, 'Lyon', 1780, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (583, 31, 1, 9, '2026-12-15', '2026-12-22', 5, 'Paris', 4120, 'EN_ATTENTE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (584, 47, 2, 131, '2025-07-20', '2025-07-27', 4, 'Lyon', 3900, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (585, 24, 3, 50, '2024-03-10', '2024-03-17', 1, 'Marseille', 890, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (586, 40, 2, 118, '2026-09-25', '2026-10-02', 3, 'Lyon', 3120, 'PAYEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (587, 8, 1, 28, '2025-04-25', '2025-05-02', 2, 'Paris', 2150, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (588, 29, 2, 100, '2024-11-18', '2024-11-25', 5, 'Lyon', 4560, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (589, 45, 9, 63, '2026-02-05', '2026-02-15', 4, 'Domicile', 3560, 'CONFIRMEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (590, 16, 2, 143, '2025-09-02', '2025-09-09', 1, 'Lyon', 1230, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (591, 37, 4, 33, '2024-05-20', '2024-05-27', 3, 'Bordeaux', 2890, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (592, 2, 1, 95, '2026-05-28', '2026-06-04', 2, 'Paris', 2340, 'EN_ATTENTE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (593, 22, 2, 121, '2025-01-12', '2025-01-19', 5, 'Lyon', 4890, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (594, 48, 5, 54, '2024-08-25', '2024-09-01', 4, 'Genève', 3780, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (595, 14, 2, 109, '2026-10-12', '2026-10-19', 1, 'Lyon', 1100, 'PAYEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (596, 35, 1, 16, '2025-05-08', '2025-05-15', 3, 'Paris', 3020, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (597, 50, 2, 79, '2024-12-15', '2024-12-22', 2, 'Lyon', 2230, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (598, 26, 7, 137, '2026-07-20', '2026-07-30', 5, 'Lyon', 4990, 'CONFIRMEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (599, 44, 2, 42, '2025-02-22', '2025-03-01', 4, 'Lyon', 3450, 'TERMINEE', NULL, false, true, NULL, true, false);
INSERT INTO reservation VALUES (600, 19, 1, 91, '2024-10-02', '2024-10-09', 1, 'Paris', 1450, 'TERMINEE', NULL, false, true, NULL, true, false);

-- Autres voyageurs
INSERT INTO autrevoyageur VALUES (1, 1, 'M', 'Martin', 'Sophie', '1985-04-12');
INSERT INTO autrevoyageur VALUES (2, 1, 'M', 'Martin', 'Lucas', '2015-06-20');
INSERT INTO autrevoyageur VALUES (3, 4, 'M', 'Bernard', 'Julie', '1990-02-15');
INSERT INTO autrevoyageur VALUES (4, 10, 'M', 'Dubois', 'Thomas', '1988-11-30');
INSERT INTO autrevoyageur VALUES (5, 10, 'M', 'Petit', 'Emma', '1989-08-22');
INSERT INTO autrevoyageur VALUES (6, 15, 'M', 'Robert', 'Camille', '1982-05-10');
INSERT INTO autrevoyageur VALUES (7, 15, 'M', 'Robert', 'Hugo', '2012-09-14');
INSERT INTO autrevoyageur VALUES (8, 15, 'M', 'Robert', 'Chloé', '2016-01-30');
INSERT INTO autrevoyageur VALUES (9, 20, 'M', 'Richard', 'Nicolas', '1975-03-25');
INSERT INTO autrevoyageur VALUES (10, 22, 'M', 'Durand', 'Céline', '1995-07-18');
INSERT INTO autrevoyageur VALUES (11, 25, 'M', 'Moreau', 'Alexandre', '2018-12-05');
INSERT INTO autrevoyageur VALUES (12, 28, 'M', 'Simon', 'Léa', '1992-10-08');
INSERT INTO autrevoyageur VALUES (13, 30, 'M', 'Laurent', 'Maxime', '1980-06-12');
INSERT INTO autrevoyageur VALUES (14, 30, 'M', 'Laurent', 'Juliette', '2014-04-03');
INSERT INTO autrevoyageur VALUES (15, 35, 'M', 'Michel', 'Antoine', '1998-01-20');
INSERT INTO autrevoyageur VALUES (16, 40, 'M', 'Lefebvre', 'Sarah', '2010-11-15');
INSERT INTO autrevoyageur VALUES (17, 42, 'M', 'Leroy', 'Paul', '1978-09-28');
INSERT INTO autrevoyageur VALUES (18, 45, 'M', 'Roux', 'Mathilde', '2019-02-10');
INSERT INTO autrevoyageur VALUES (19, 48, 'M', 'David', 'Enzo', '2005-05-05');
INSERT INTO autrevoyageur VALUES (20, 50, 'M', 'Bertrand', 'Manon', '1993-08-14');
INSERT INTO autrevoyageur VALUES (21, 55, 'M', 'Morel', 'Louis', '1987-12-22');
INSERT INTO autrevoyageur VALUES (22, 55, 'M', 'Morel', 'Jade', '2017-03-18');
INSERT INTO autrevoyageur VALUES (23, 60, 'M', 'Fournier', 'Gabriel', '2011-06-09');
INSERT INTO autrevoyageur VALUES (24, 62, 'M', 'Girard', 'Louise', '1990-04-25');
INSERT INTO autrevoyageur VALUES (25, 65, 'M', 'Bonnet', 'Adam', '2015-10-12');
INSERT INTO autrevoyageur VALUES (26, 68, 'M', 'Dupont', 'Eva', '1986-07-07');
INSERT INTO autrevoyageur VALUES (27, 70, 'M', 'Lambert', 'Arthur', '2020-01-30');
INSERT INTO autrevoyageur VALUES (28, 72, 'M', 'Fontaine', 'Inès', '1996-09-19');
INSERT INTO autrevoyageur VALUES (29, 75, 'M', 'Rousseau', 'Mael', '2013-05-24');
INSERT INTO autrevoyageur VALUES (30, 75, 'M', 'Rousseau', 'Lola', '2015-08-11');
INSERT INTO autrevoyageur VALUES (31, 80, 'M', 'Vincent', 'Raphaël', '1984-02-03');
INSERT INTO autrevoyageur VALUES (32, 85, 'M', 'Muller', 'Agathe', '1999-11-28');
INSERT INTO autrevoyageur VALUES (33, 88, 'M', 'Lefevre', 'Tom', '2016-06-15');
INSERT INTO autrevoyageur VALUES (34, 90, 'M', 'Faure', 'Alice', '1991-12-10');
INSERT INTO autrevoyageur VALUES (35, 95, 'M', 'Andre', 'Nathan', '2014-04-22');
INSERT INTO autrevoyageur VALUES (36, 100, 'M', 'Mercier', 'Anna', '1989-03-08');
INSERT INTO autrevoyageur VALUES (37, 102, 'M', 'Blanc', 'Théo', '2012-09-25');
INSERT INTO autrevoyageur VALUES (38, 105, 'M', 'Guerin', 'Julia', '1994-07-14');
INSERT INTO autrevoyageur VALUES (39, 108, 'M', 'Boyer', 'Sacha', '2018-01-05');
INSERT INTO autrevoyageur VALUES (40, 110, 'M', 'Garnier', 'Romane', '1983-10-30');
INSERT INTO autrevoyageur VALUES (41, 112, 'M', 'Chevalier', 'Gaspard', '2015-05-18');
INSERT INTO autrevoyageur VALUES (42, 115, 'M', 'Francois', 'Ambre', '1997-02-12');
INSERT INTO autrevoyageur VALUES (43, 118, 'M', 'Legrand', 'Noé', '2011-08-20');
INSERT INTO autrevoyageur VALUES (44, 120, 'M', 'Gauthier', 'Mia', '1992-06-02');
INSERT INTO autrevoyageur VALUES (45, 122, 'M', 'Garcia', 'Léo', '2019-12-15');
INSERT INTO autrevoyageur VALUES (46, 125, 'M', 'Perrin', 'Léna', '1988-04-09');
INSERT INTO autrevoyageur VALUES (47, 125, 'M', 'Perrin', 'Jules', '2016-11-23');
INSERT INTO autrevoyageur VALUES (48, 130, 'M', 'Robin', 'Zoé', '1995-09-05');
INSERT INTO autrevoyageur VALUES (49, 135, 'M', 'Clement', 'Malo', '2013-01-18');
INSERT INTO autrevoyageur VALUES (50, 140, 'M', 'Morin', 'Rose', '1986-07-27');
INSERT INTO autrevoyageur VALUES (51, 142, 'M', 'Nicolas', 'Timéo', '2017-03-10');
INSERT INTO autrevoyageur VALUES (52, 145, 'M', 'Henry', 'Mila', '1993-10-15');
INSERT INTO autrevoyageur VALUES (53, 148, 'M', 'Roussel', 'Ethan', '2014-05-28');
INSERT INTO autrevoyageur VALUES (54, 150, 'M', 'Mathieu', 'Lou', '1990-12-05');
INSERT INTO autrevoyageur VALUES (55, 152, 'M', 'Gautier', 'Axel', '2012-08-19');
INSERT INTO autrevoyageur VALUES (56, 155, 'M', 'Masson', 'Lina', '1985-02-24');
INSERT INTO autrevoyageur VALUES (57, 158, 'M', 'Marchand', 'Robin', '2018-06-30');
INSERT INTO autrevoyageur VALUES (58, 160, 'M', 'Duval', 'Iris', '1996-04-12');
INSERT INTO autrevoyageur VALUES (59, 162, 'M', 'Denis', 'Valentin', '2011-11-08');
INSERT INTO autrevoyageur VALUES (60, 165, 'M', 'Dumont', 'Charlotte', '1991-09-20');
INSERT INTO autrevoyageur VALUES (61, 168, 'M', 'Marie', 'Marius', '2016-01-15');
INSERT INTO autrevoyageur VALUES (62, 170, 'M', 'Lemaire', 'Victoire', '1989-07-03');
INSERT INTO autrevoyageur VALUES (63, 172, 'M', 'Noel', 'Liam', '2015-03-25');
INSERT INTO autrevoyageur VALUES (64, 175, 'M', 'Meyer', 'Eléna', '1994-12-12');
INSERT INTO autrevoyageur VALUES (65, 178, 'M', 'Dufour', 'Paul', '2013-08-05');
INSERT INTO autrevoyageur VALUES (66, 180, 'M', 'Valentin', 'Margaux', '1987-05-18');
INSERT INTO autrevoyageur VALUES (67, 180, 'M', 'Valentin', 'Clément', '2017-10-30');
INSERT INTO autrevoyageur VALUES (68, 185, 'M', 'Brun', 'Apolline', '1998-02-22');
INSERT INTO autrevoyageur VALUES (69, 188, 'M', 'Blanchard', 'Augustin', '2012-06-14');
INSERT INTO autrevoyageur VALUES (70, 190, 'M', 'Giraud', 'Jeanne', '1992-11-05');
INSERT INTO autrevoyageur VALUES (71, 192, 'M', 'Joly', 'Baptiste', '2015-09-28');
INSERT INTO autrevoyageur VALUES (72, 195, 'M', 'Riviere', 'Adèle', '1986-04-10');
INSERT INTO autrevoyageur VALUES (73, 198, 'M', 'Lucas', 'Simon', '2011-01-20');
INSERT INTO autrevoyageur VALUES (74, 200, 'M', 'Brunet', 'Élise', '1995-07-15');
INSERT INTO autrevoyageur VALUES (75, 202, 'M', 'Gaillard', 'Nolan', '2018-03-08');
INSERT INTO autrevoyageur VALUES (76, 205, 'M', 'Barbier', 'Célia', '1990-12-25');
INSERT INTO autrevoyageur VALUES (77, 208, 'M', 'Arnaud', 'Antonin', '2014-06-12');
INSERT INTO autrevoyageur VALUES (78, 210, 'M', 'Marty', 'Romy', '1988-10-02');
INSERT INTO autrevoyageur VALUES (79, 212, 'M', 'Huet', 'Gabin', '2016-05-18');
INSERT INTO autrevoyageur VALUES (80, 215, 'M', 'Leroux', 'Léonie', '1993-01-30');
INSERT INTO autrevoyageur VALUES (81, 218, 'M', 'Colin', 'Éliott', '2013-09-22');
INSERT INTO autrevoyageur VALUES (82, 220, 'M', 'Vidal', 'Capucine', '1985-04-05');
INSERT INTO autrevoyageur VALUES (83, 222, 'M', 'Caron', 'Marceau', '2017-11-15');
INSERT INTO autrevoyageur VALUES (84, 225, 'M', 'Picard', 'Constance', '1997-08-28');
INSERT INTO autrevoyageur VALUES (85, 228, 'M', 'Roger', 'Oscar', '2012-02-10');
INSERT INTO autrevoyageur VALUES (86, 230, 'M', 'Fabre', 'Lise', '1991-06-25');
INSERT INTO autrevoyageur VALUES (87, 230, 'M', 'Fabre', 'Thibault', '2015-12-08');
INSERT INTO autrevoyageur VALUES (88, 235, 'M', 'Aubert', 'Ninon', '1989-03-18');
INSERT INTO autrevoyageur VALUES (89, 238, 'M', 'Lemoine', 'Côme', '2014-10-30');
INSERT INTO autrevoyageur VALUES (90, 240, 'M', 'Renaud', 'Zélie', '1996-05-12');
INSERT INTO autrevoyageur VALUES (91, 242, 'M', 'Dumas', 'Léon', '2018-09-05');
INSERT INTO autrevoyageur VALUES (92, 245, 'M', 'Lacroix', 'Alix', '1984-01-22');
INSERT INTO autrevoyageur VALUES (93, 248, 'M', 'Olivier', 'Victor', '2011-07-15');
INSERT INTO autrevoyageur VALUES (94, 250, 'M', 'Philippe', 'Valentine', '1992-12-28');
INSERT INTO autrevoyageur VALUES (95, 252, 'M', 'Bourgeois', 'Basile', '2016-04-10');
INSERT INTO autrevoyageur VALUES (96, 255, 'M', 'Pierre', 'Diane', '1999-11-20');
INSERT INTO autrevoyageur VALUES (97, 258, 'M', 'Benoit', 'Ismaël', '2013-02-05');
INSERT INTO autrevoyageur VALUES (98, 260, 'M', 'Rey', 'Charlie', '1987-08-18');
INSERT INTO autrevoyageur VALUES (99, 262, 'M', 'Leclerc', 'Olivia', '2015-06-30');
INSERT INTO autrevoyageur VALUES (100, 265, 'M', 'Payet', 'Félix', '1994-03-12');
INSERT INTO autrevoyageur VALUES (101, 268, 'M', 'Rolland', 'Solène', '2012-10-25');
INSERT INTO autrevoyageur VALUES (102, 270, 'M', 'Lecomte', 'Henri', '1986-05-08');
INSERT INTO autrevoyageur VALUES (103, 272, 'M', 'Lopez', 'Mathilde', '2017-12-15');
INSERT INTO autrevoyageur VALUES (104, 275, 'M', 'Jean', 'Achille', '1993-09-22');
INSERT INTO autrevoyageur VALUES (105, 278, 'M', 'Dupuy', 'Elsa', '2014-01-05');
INSERT INTO autrevoyageur VALUES (106, 280, 'M', 'Guillot', 'Naël', '1990-07-28');
INSERT INTO autrevoyageur VALUES (107, 282, 'M', 'Hubert', 'Suzie', '2016-04-15');
INSERT INTO autrevoyageur VALUES (108, 285, 'M', 'Berger', 'Ruben', '1988-11-10');
INSERT INTO autrevoyageur VALUES (109, 288, 'M', 'Carpentier', 'Louison', '2013-05-25');
INSERT INTO autrevoyageur VALUES (110, 290, 'M', 'Sanchez', 'Abel', '1995-12-30');
INSERT INTO autrevoyageur VALUES (111, 292, 'M', 'Deschamps', 'Clémence', '2018-08-12');
INSERT INTO autrevoyageur VALUES (112, 295, 'M', 'Moulin', 'Marin', '1983-02-28');
INSERT INTO autrevoyageur VALUES (113, 298, 'M', 'Louis', 'Céleste', '2011-06-18');
INSERT INTO autrevoyageur VALUES (114, 300, 'M', 'Maillard', 'Milo', '1997-09-08');
INSERT INTO autrevoyageur VALUES (115, 300, 'M', 'Maillard', 'Garance', '2015-03-22');
INSERT INTO autrevoyageur VALUES (116, 305, 'M', 'Marchal', 'Gaspard', '1991-10-15');
INSERT INTO autrevoyageur VALUES (117, 308, 'M', 'Hamon', 'Livia', '2014-07-05');
INSERT INTO autrevoyageur VALUES (118, 310, 'M', 'Vasseur', 'Solal', '1985-04-20');
INSERT INTO autrevoyageur VALUES (119, 312, 'M', 'Boucher', 'Héloïse', '2017-11-28');
INSERT INTO autrevoyageur VALUES (120, 315, 'M', 'Perez', 'Ulysse', '1999-01-10');
INSERT INTO autrevoyageur VALUES (121, 318, 'M', 'Roy', 'Alma', '2012-08-25');
INSERT INTO autrevoyageur VALUES (122, 320, 'M', 'Charpentier', 'Loup', '1992-05-15');
INSERT INTO autrevoyageur VALUES (123, 322, 'M', 'Gros', 'Thelma', '2016-12-05');
INSERT INTO autrevoyageur VALUES (124, 325, 'M', 'Lucas', 'Vadim', '1987-03-30');
INSERT INTO autrevoyageur VALUES (125, 328, 'M', 'Dumont', 'Roxane', '2013-10-12');
INSERT INTO autrevoyageur VALUES (126, 330, 'F', 'Dupuis', 'Noam', '1994-06-22');
INSERT INTO autrevoyageur VALUES (127, 332, 'F', 'Crusoe', 'Yasmine', '2015-09-08');
INSERT INTO autrevoyageur VALUES (128, 335, 'F', 'Paris', 'Léonard', '1989-02-18');
INSERT INTO autrevoyageur VALUES (129, 338, 'F', 'Guyot', 'Suzanne', '2018-04-30');
INSERT INTO autrevoyageur VALUES (130, 340, 'F', 'Guillaume', 'Marcus', '1984-11-25');
INSERT INTO autrevoyageur VALUES (131, 342, 'F', 'Adam', 'Billie', '2011-07-10');
INSERT INTO autrevoyageur VALUES (132, 345, 'F', 'Lecomte', 'Césaire', '1996-03-05');
INSERT INTO autrevoyageur VALUES (133, 348, 'F', 'Gregoire', 'June', '2014-12-15');
INSERT INTO autrevoyageur VALUES (134, 350, 'F', 'Millet', 'Gustave', '1990-08-28');
INSERT INTO autrevoyageur VALUES (135, 352, 'F', 'Delmas', 'Ariane', '2016-05-20');
INSERT INTO autrevoyageur VALUES (136, 355, 'F', 'Lamy', 'Octave', '1983-09-12');
INSERT INTO autrevoyageur VALUES (137, 358, 'F', 'Prevost', 'Castille', '2012-01-30');
INSERT INTO autrevoyageur VALUES (138, 360, 'F', 'Renault', 'Anatole', '1998-04-15');
INSERT INTO autrevoyageur VALUES (139, 362, 'F', 'Breton', 'Olympe', '2015-11-05');
INSERT INTO autrevoyageur VALUES (140, 365, 'F', 'Leroy', 'Ferdinand', '1993-06-25');
INSERT INTO autrevoyageur VALUES (141, 365, 'F', 'Leroy', 'Colette', '2017-02-10');
INSERT INTO autrevoyageur VALUES (142, 370, 'F', 'Rousset', 'Lucien', '1986-10-22');
INSERT INTO autrevoyageur VALUES (143, 372, 'F', 'Bessis', 'Mahaut', '2013-03-08');
INSERT INTO autrevoyageur VALUES (144, 375, 'F', 'Voisin', 'Siméon', '1991-09-18');
INSERT INTO autrevoyageur VALUES (145, 378, 'F', 'Chauvin', 'Zélie', '2016-07-02');
INSERT INTO autrevoyageur VALUES (146, 380, 'F', 'Bouchet', 'Barnabé', '1988-12-12');
INSERT INTO autrevoyageur VALUES (147, 382, 'F', 'Menard', 'Emy', '2011-05-28');
INSERT INTO autrevoyageur VALUES (148, 385, 'F', 'Perrot', 'Arsène', '1995-08-15');
INSERT INTO autrevoyageur VALUES (149, 388, 'F', 'Daniel', 'Lila', '2014-04-30');
INSERT INTO autrevoyageur VALUES (150, 390, 'F', 'Vallee', 'Gaston', '1982-11-25');
INSERT INTO autrevoyageur VALUES (151, 392, 'F', 'Maury', 'Ava', '2018-06-10');
INSERT INTO autrevoyageur VALUES (152, 395, 'F', 'Coulon', 'Louison', '1997-01-20');
INSERT INTO autrevoyageur VALUES (153, 398, 'F', 'Poulain', 'Tess', '2012-09-05');
INSERT INTO autrevoyageur VALUES (154, 400, 'F', 'Texier', 'Nils', '1990-03-15');
INSERT INTO autrevoyageur VALUES (155, 402, 'F', 'Carre', 'Yara', '2015-10-28');
INSERT INTO autrevoyageur VALUES (156, 405, 'F', 'Royer', 'Lubin', '1985-07-22');
INSERT INTO autrevoyageur VALUES (157, 408, 'F', 'Lucas', 'Pia', '2013-02-12');
INSERT INTO autrevoyageur VALUES (158, 410, 'F', 'Bousquet', 'Vianney', '1994-08-30');
INSERT INTO autrevoyageur VALUES (159, 412, 'F', 'Hebert', 'Alba', '2016-12-18');
INSERT INTO autrevoyageur VALUES (160, 415, 'F', 'Tessier', 'Marceau', '1989-05-08');
INSERT INTO autrevoyageur VALUES (161, 418, 'F', 'Blin', 'Nine', '2011-11-25');
INSERT INTO autrevoyageur VALUES (162, 420, 'F', 'Guilbert', 'Élie', '1996-06-15');
INSERT INTO autrevoyageur VALUES (163, 422, 'F', 'Leger', 'Joséphine', '2014-09-02');
INSERT INTO autrevoyageur VALUES (164, 425, 'F', 'Bailly', 'Félix', '1984-04-20');
INSERT INTO autrevoyageur VALUES (165, 428, 'F', 'Pineau', 'Anita', '2017-03-12');
INSERT INTO autrevoyageur VALUES (166, 430, 'F', 'Albert', 'Soren', '1992-10-25');
INSERT INTO autrevoyageur VALUES (167, 430, 'F', 'Albert', 'Maïa', '2015-01-08');
INSERT INTO autrevoyageur VALUES (168, 435, 'F', 'Jacques', 'Ambroise', '1987-08-22');
INSERT INTO autrevoyageur VALUES (169, 438, 'F', 'Pichon', 'Lise', '2012-05-15');
INSERT INTO autrevoyageur VALUES (170, 440, 'F', 'Verdier', 'Hélios', '1998-12-30');
INSERT INTO autrevoyageur VALUES (171, 442, 'F', 'Gaudin', 'Anouk', '2013-07-18');
INSERT INTO autrevoyageur VALUES (172, 445, 'F', 'Brunel', 'Lancelot', '1991-03-10');
INSERT INTO autrevoyageur VALUES (173, 448, 'F', 'Guillet', 'Mona', '2016-09-28');
INSERT INTO autrevoyageur VALUES (174, 450, 'F', 'Devaux', 'Virgile', '1986-01-25');
INSERT INTO autrevoyageur VALUES (175, 452, 'F', 'Dupre', 'Sienna', '2011-08-12');
INSERT INTO autrevoyageur VALUES (176, 455, 'F', 'Marin', 'Zadig', '1995-04-05');
INSERT INTO autrevoyageur VALUES (177, 458, 'F', 'Pruvost', 'Thaïs', '2014-11-20');
INSERT INTO autrevoyageur VALUES (178, 460, 'F', 'Mahe', 'Emile', '1989-06-30');
INSERT INTO autrevoyageur VALUES (179, 462, 'F', 'Peltier', 'Liv', '2017-02-22');
INSERT INTO autrevoyageur VALUES (180, 465, 'F', 'Thibault', 'Cyprien', '1993-09-15');
INSERT INTO autrevoyageur VALUES (181, 468, 'F', 'Laine', 'Aimée', '2012-03-08');
INSERT INTO autrevoyageur VALUES (182, 470, 'F', 'Barre', 'Aloïs', '1985-12-10');
INSERT INTO autrevoyageur VALUES (183, 472, 'F', 'Barthelemy', 'Brune', '2015-06-25');
INSERT INTO autrevoyageur VALUES (184, 475, 'F', 'Gillet', 'Célestin', '1997-10-18');
INSERT INTO autrevoyageur VALUES (185, 478, 'F', 'Godard', 'Esmée', '2013-01-30');
INSERT INTO autrevoyageur VALUES (186, 480, 'F', 'Langlois', 'Marin', '1990-08-22');
INSERT INTO autrevoyageur VALUES (187, 482, 'F', 'Couturier', 'Fleur', '2016-04-12');
INSERT INTO autrevoyageur VALUES (188, 485, 'F', 'Raynaud', 'Aurèle', '1988-11-28');
INSERT INTO autrevoyageur VALUES (189, 488, 'F', 'Prevot', 'Yana', '2011-05-15');
INSERT INTO autrevoyageur VALUES (190, 490, 'F', 'Etienne', 'Melvil', '1994-12-05');
INSERT INTO autrevoyageur VALUES (191, 492, 'F', 'Lebrun', 'Ella', '2018-07-20');
INSERT INTO autrevoyageur VALUES (192, 495, 'F', 'Guillon', 'Léandre', '1982-03-25');
INSERT INTO autrevoyageur VALUES (193, 495, 'F', 'Guillon', 'Paola', '2014-09-10');
INSERT INTO autrevoyageur VALUES (194, 500, 'F', 'Rossi', 'Gabin', '1996-01-18');
INSERT INTO autrevoyageur VALUES (195, 505, 'F', 'Jacquet', 'Alix', '2012-08-30');
INSERT INTO autrevoyageur VALUES (196, 510, 'F', 'Collet', 'Marceau', '1991-04-15');
INSERT INTO autrevoyageur VALUES (197, 520, 'F', 'Prevost', 'Romy', '2015-11-22');
INSERT INTO autrevoyageur VALUES (198, 550, 'F', 'Maurin', 'Léon', '1987-06-05');
INSERT INTO autrevoyageur VALUES (199, 580, 'F', 'Perrier', 'Charlie', '2013-12-12');
INSERT INTO autrevoyageur VALUES (200, 600, 'F', 'Ferreira', 'Lou', '1999-09-08');

-- Avis
INSERT INTO avis VALUES (1, 43, 60, 'Très bon moment', 'Le cadre est magnifique mais le service est lent.', 3, 1, NULL);
INSERT INTO avis VALUES (2, 46, 148, 'A refaire (mais pas ici)', 'Un peu déçu par la prestation.', 2, 2, NULL);
INSERT INTO avis VALUES (3, 26, 19, 'Incroyable séjour', 'Le personnel est très accueillant.', 5, 3, NULL);
INSERT INTO avis VALUES (4, 46, 79, 'Incroyable séjour', 'Excellent séjour en famille, les enfants ont adoré.', 5, 4, NULL);
INSERT INTO avis VALUES (5, 30, 5, 'Vacances de rêve', 'Le personnel est très accueillant.', 4, 5, NULL);
INSERT INTO avis VALUES (6, 12, 112, 'Vacances de rêve', 'Excellent séjour en famille, les enfants ont adoré.', 5, 6, NULL);
INSERT INTO avis VALUES (7, 39, 45, 'Mitigé', 'La chambre n''était pas très propre.', 1, 7, NULL);
INSERT INTO avis VALUES (8, 5, 88, 'Très bon moment', 'Un peu cher pour la prestation.', 3, 8, NULL);
INSERT INTO avis VALUES (9, 22, 23, 'Déçu', 'La chambre n''était pas très propre.', 1, 9, NULL);
INSERT INTO avis VALUES (10, 48, 150, 'Déçu', 'Trop de monde à la piscine.', 1, 10, NULL);
INSERT INTO avis VALUES (11, 15, 9, 'Déçu', 'Un peu déçu par la prestation.', 2, 11, NULL);
INSERT INTO avis VALUES (12, 33, 77, 'Déçu', 'La chambre n''était pas très propre.', 1, 12, NULL);
INSERT INTO avis VALUES (13, 29, 101, 'Mitigé', 'La chambre n''était pas très propre.', 1, 13, NULL);
INSERT INTO avis VALUES (14, 41, 33, 'Incroyable séjour', 'Excellent séjour en famille, les enfants ont adoré.', 5, 14, NULL);
INSERT INTO avis VALUES (15, 8, 142, 'Vacances de rêve', 'Tout était parfait du début à la fin.', 5, 15, NULL);
INSERT INTO avis VALUES (16, 19, 65, 'Très bon moment', 'La nourriture était délicieuse.', 3, 16, NULL);
INSERT INTO avis VALUES (17, 25, 12, 'Bon rapport qualité prix', 'Le cadre est magnifique mais le service est lent.', 3, 17, NULL);
INSERT INTO avis VALUES (18, 50, 99, 'Super vacances', 'Je recommande vivement ce club.', 5, 18, NULL);
INSERT INTO avis VALUES (19, 3, 41, 'Correct', 'La nourriture était délicieuse.', 3, 19, NULL);
INSERT INTO avis VALUES (20, 11, 8, 'A refaire (mais pas ici)', 'La chambre n''était pas très propre.', 1, 20, NULL);
INSERT INTO avis VALUES (21, 37, 130, 'Mitigé', 'Un peu déçu par la prestation.', 2, 21, NULL);
INSERT INTO avis VALUES (22, 14, 55, 'Très bon moment', 'La nourriture était délicieuse.', 3, 22, NULL);
INSERT INTO avis VALUES (23, 44, 19, 'Très bon moment', 'Le cadre est magnifique mais le service est lent.', 3, 23, NULL);
INSERT INTO avis VALUES (24, 28, 83, 'Correct', 'Un peu cher pour la prestation.', 3, 24, NULL);
INSERT INTO avis VALUES (25, 6, 115, 'Déçu', 'Un peu déçu par la prestation.', 2, 25, NULL);
INSERT INTO avis VALUES (26, 31, 29, 'Déçu', 'Trop de monde à la piscine.', 2, 26, NULL);
INSERT INTO avis VALUES (27, 17, 66, 'A refaire (mais pas ici)', 'Un peu déçu par la prestation.', 1, 27, NULL);
INSERT INTO avis VALUES (28, 49, 107, 'Très bon moment', 'Le cadre est magnifique mais le service est lent.', 3, 28, NULL);
INSERT INTO avis VALUES (29, 2, 4, 'Très bon moment', 'Un peu cher pour la prestation.', 3, 29, NULL);
INSERT INTO avis VALUES (30, 35, 92, 'Déçu', 'La chambre n''était pas très propre.', 1, 30, NULL);
INSERT INTO avis VALUES (31, 10, 144, 'Vacances de rêve', 'Excellent séjour en famille, les enfants ont adoré.', 5, 31, NULL);
INSERT INTO avis VALUES (32, 23, 38, 'Parfait', 'Le personnel est très accueillant.', 5, 32, NULL);
INSERT INTO avis VALUES (33, 42, 71, 'Bon rapport qualité prix', 'Le cadre est magnifique mais le service est lent.', 3, 33, NULL);
INSERT INTO avis VALUES (34, 18, 15, 'Très bon moment', 'Le cadre est magnifique mais le service est lent.', 3, 34, NULL);
INSERT INTO avis VALUES (35, 30, 122, 'Déçu', 'Un peu déçu par la prestation.', 2, 35, NULL);
INSERT INTO avis VALUES (36, 7, 50, 'A refaire (mais pas ici)', 'Trop de monde à la piscine.', 2, 36, NULL);
INSERT INTO avis VALUES (37, 45, 85, 'Très bon moment', 'Un peu cher pour la prestation.', 3, 37, NULL);
INSERT INTO avis VALUES (38, 13, 136, 'Déçu', 'Un peu déçu par la prestation.', 1, 38, NULL);
INSERT INTO avis VALUES (39, 27, 22, 'Vacances de rêve', 'Je recommande vivement ce club.', 5, 39, NULL);
INSERT INTO avis VALUES (40, 38, 109, 'Très bon moment', 'Un peu cher pour la prestation.', 3, 40, NULL);
INSERT INTO avis VALUES (41, 1, 61, 'Mitigé', 'La chambre n''était pas très propre.', 2, 41, NULL);
INSERT INTO avis VALUES (42, 40, 14, 'Incroyable séjour', 'Je recommande vivement ce club.', 5, 42, NULL);
INSERT INTO avis VALUES (43, 21, 95, 'Correct', 'Le cadre est magnifique mais le service est lent.', 3, 43, NULL);
INSERT INTO avis VALUES (44, 34, 30, 'Mitigé', 'Un peu déçu par la prestation.', 1, 44, NULL);
INSERT INTO avis VALUES (45, 16, 118, 'A refaire (mais pas ici)', 'Un peu déçu par la prestation.', 1, 45, NULL);
INSERT INTO avis VALUES (46, 47, 75, 'Parfait', 'Le personnel est très accueillant.', 5, 46, NULL);
INSERT INTO avis VALUES (47, 9, 151, 'Mitigé', 'La chambre n''était pas très propre.', 1, 47, NULL);
INSERT INTO avis VALUES (48, 26, 42, 'Déçu', 'Trop de monde à la piscine.', 1, 48, NULL);
INSERT INTO avis VALUES (49, 36, 103, 'Correct', 'Le cadre est magnifique mais le service est lent.', 3, 49, NULL);
INSERT INTO avis VALUES (50, 4, 10, 'Parfait', 'Excellent séjour en famille, les enfants ont adoré.', 5, 50, NULL);
INSERT INTO avis VALUES (51, 32, 87, 'Déçu', 'La chambre n''était pas très propre.', 2, 51, NULL);
INSERT INTO avis VALUES (52, 20, 133, 'Déçu', 'La chambre n''était pas très propre.', 1, 52, NULL);
INSERT INTO avis VALUES (53, 43, 58, 'A refaire (mais pas ici)', 'Un peu déçu par la prestation.', 2, 53, NULL);
INSERT INTO avis VALUES (54, 12, 26, 'Déçu', 'La chambre n''était pas très propre.', 1, 54, NULL);
INSERT INTO avis VALUES (55, 39, 111, 'Mitigé', 'Trop de monde à la piscine.', 2, 55, NULL);
INSERT INTO avis VALUES (56, 5, 73, 'Déçu', 'Trop de monde à la piscine.', 2, 56, NULL);
INSERT INTO avis VALUES (57, 24, 3, 'Très bon moment', 'Le cadre est magnifique mais le service est lent.', 3, 57, NULL);
INSERT INTO avis VALUES (58, 46, 97, 'A refaire (mais pas ici)', 'Trop de monde à la piscine.', 1, 58, NULL);
INSERT INTO avis VALUES (59, 15, 140, 'Mitigé', 'Trop de monde à la piscine.', 2, 59, NULL);
INSERT INTO avis VALUES (60, 29, 49, 'Très bon moment', 'Le cadre est magnifique mais le service est lent.', 3, 60, NULL);
INSERT INTO avis VALUES (61, 41, 126, 'Déçu', 'Un peu déçu par la prestation.', 2, 61, NULL);
INSERT INTO avis VALUES (62, 8, 20, 'A refaire (mais pas ici)', 'Un peu déçu par la prestation.', 2, 62, NULL);
INSERT INTO avis VALUES (63, 22, 82, 'Très bon moment', 'Un peu cher pour la prestation.', 3, 63, NULL);
INSERT INTO avis VALUES (64, 48, 152, 'Vacances de rêve', 'Excellent séjour en famille, les enfants ont adoré.', 5, 64, NULL);
INSERT INTO avis VALUES (65, 11, 35, 'Mitigé', 'La chambre n''était pas très propre.', 1, 65, NULL);
INSERT INTO avis VALUES (66, 33, 105, 'Parfait', 'Excellent séjour en famille, les enfants ont adoré.', 5, 66, NULL);
INSERT INTO avis VALUES (67, 19, 62, 'A refaire (mais pas ici)', 'La chambre n''était pas très propre.', 2, 67, NULL);
INSERT INTO avis VALUES (68, 50, 135, 'Mitigé', 'La chambre n''était pas très propre.', 1, 68, NULL);
INSERT INTO avis VALUES (69, 3, 7, 'Mitigé', 'Un peu déçu par la prestation.', 2, 69, NULL);
INSERT INTO avis VALUES (70, 37, 90, 'Vacances de rêve', 'Tout était parfait du début à la fin.', 4, 70, NULL);
INSERT INTO avis VALUES (71, 14, 40, 'Bon rapport qualité prix', 'Le cadre est magnifique mais le service est lent.', 3, 71, NULL);
INSERT INTO avis VALUES (72, 44, 119, 'Très bon moment', 'Un peu cher pour la prestation.', 3, 72, NULL);
INSERT INTO avis VALUES (73, 25, 25, 'Super vacances', 'Excellent séjour en famille, les enfants ont adoré.', 5, 73, NULL);
INSERT INTO avis VALUES (74, 6, 80, 'Mitigé', 'Un peu déçu par la prestation.', 2, 74, NULL);
INSERT INTO avis VALUES (75, 31, 146, 'Très bon moment', 'Un peu cher pour la prestation.', 3, 75, NULL);
INSERT INTO avis VALUES (76, 17, 53, 'Super vacances', 'Tout était parfait du début à la fin.', 5, 76, NULL);
INSERT INTO avis VALUES (77, 45, 98, 'Incroyable séjour', 'Je recommande vivement ce club.', 5, 77, NULL);
INSERT INTO avis VALUES (78, 2, 13, 'Déçu', 'La chambre n''était pas très propre.', 2, 78, NULL);
INSERT INTO avis VALUES (79, 28, 70, 'A refaire (mais pas ici)', 'La chambre n''était pas très propre.', 2, 79, NULL);
INSERT INTO avis VALUES (80, 40, 125, 'Bon rapport qualité prix', 'La nourriture était délicieuse.', 3, 80, NULL);
INSERT INTO avis VALUES (81, 10, 36, 'A refaire (mais pas ici)', 'Un peu déçu par la prestation.', 1, 81, NULL);
INSERT INTO avis VALUES (82, 35, 93, 'A refaire (mais pas ici)', 'Un peu déçu par la prestation.', 2, 82, NULL);
INSERT INTO avis VALUES (83, 21, 153, 'A refaire (mais pas ici)', 'Un peu déçu par la prestation.', 2, 83, NULL);
INSERT INTO avis VALUES (84, 47, 6, 'A refaire (mais pas ici)', 'Un peu déçu par la prestation.', 2, 84, NULL);
INSERT INTO avis VALUES (85, 12, 84, 'A refaire (mais pas ici)', 'La chambre n''était pas très propre.', 1, 85, NULL);
INSERT INTO avis VALUES (86, 34, 113, 'Déçu', 'Trop de monde à la piscine.', 2, 86, NULL);
INSERT INTO avis VALUES (87, 49, 32, 'Déçu', 'Un peu déçu par la prestation.', 2, 87, NULL);
INSERT INTO avis VALUES (88, 26, 141, 'Mitigé', 'Trop de monde à la piscine.', 1, 88, NULL);
INSERT INTO avis VALUES (89, 7, 59, 'Mitigé', 'Un peu déçu par la prestation.', 1, 89, NULL);
INSERT INTO avis VALUES (90, 32, 100, 'Bon rapport qualité prix', 'Un peu cher pour la prestation.', 3, 90, NULL);
INSERT INTO avis VALUES (91, 42, 17, 'Correct', 'La nourriture était délicieuse.', 3, 91, NULL);
INSERT INTO avis VALUES (92, 16, 76, 'Vacances de rêve', 'Excellent séjour en famille, les enfants ont adoré.', 5, 92, NULL);
INSERT INTO avis VALUES (93, 27, 128, 'Super vacances', 'Je recommande vivement ce club.', 5, 93, NULL);
INSERT INTO avis VALUES (94, 38, 47, 'Bon rapport qualité prix', 'Un peu cher pour la prestation.', 3, 94, NULL);
INSERT INTO avis VALUES (95, 1, 110, 'Bon rapport qualité prix', 'La nourriture était délicieuse.', 3, 95, NULL);
INSERT INTO avis VALUES (96, 46, 2, 'Incroyable séjour', 'Tout était parfait du début à la fin.', 5, 96, NULL);
INSERT INTO avis VALUES (97, 20, 96, 'Déçu', 'La chambre n''était pas très propre.', 2, 97, NULL);
INSERT INTO avis VALUES (98, 5, 137, 'Déçu', 'Un peu déçu par la prestation.', 2, 98, NULL);
INSERT INTO avis VALUES (99, 36, 54, 'Super vacances', 'Le personnel est très accueillant.', 5, 99, NULL);
INSERT INTO avis VALUES (100, 29, 89, 'Vacances de rêve', 'Excellent séjour en famille, les enfants ont adoré.', 5, 100, NULL);

-- Transactions
INSERT INTO transaction (idtransaction, numreservation, montant, date_transaction, moyen_paiement, statut_paiement)
SELECT 
    numreservation AS idtransaction,
    numreservation,
    prix, 
    datedebut - (floor(random() * 30 + 5)::int || ' days')::interval AS date_transaction,
    CASE floor(random() * 3)
        WHEN 0 THEN 'Carte Bancaire'
        WHEN 1 THEN 'PayPal'
        ELSE 'Virement'
    END AS moyen_paiement,
    CASE statut 
        WHEN 'TERMINEE' THEN 'VALIDE'
        WHEN 'PAYEE' THEN 'VALIDE'
        WHEN 'CONFIRMEE' THEN 'EN_ATTENTE'
        WHEN 'ANNULEE' THEN 'REMBOURSE'
        ELSE 'EN_ATTENTE'
    END AS statut_paiement
FROM reservation;

-- LIAISONS
-- club-activite
INSERT INTO club_activite VALUES (1, 311); 
INSERT INTO club_activite VALUES (1, 230); 
INSERT INTO club_activite VALUES (1, 15);  
INSERT INTO club_activite VALUES (1, 18);  
INSERT INTO club_activite VALUES (1, 305); 
INSERT INTO club_activite VALUES (1, 335); 
INSERT INTO club_activite VALUES (1, 222); 
INSERT INTO club_activite VALUES (1, 303); 
INSERT INTO club_activite VALUES (1, 333); 
INSERT INTO club_activite VALUES (1, 345); 
INSERT INTO club_activite VALUES (1, 239); 
INSERT INTO club_activite VALUES (1, 203);
INSERT INTO club_activite VALUES (1, 12); 
INSERT INTO club_activite VALUES (1, 219); 
INSERT INTO club_activite VALUES (1, 209); 
INSERT INTO club_activite VALUES (1, 319); 
INSERT INTO club_activite VALUES (1, 321); 
INSERT INTO club_activite VALUES (1, 9);  
INSERT INTO club_activite VALUES (1, 225); 
INSERT INTO club_activite VALUES (2, 342);
INSERT INTO club_activite VALUES (2, 229);
INSERT INTO club_activite VALUES (2, 243);
INSERT INTO club_activite VALUES (2, 1);
INSERT INTO club_activite VALUES (2, 302);
INSERT INTO club_activite VALUES (2, 236);
INSERT INTO club_activite VALUES (2, 338);
INSERT INTO club_activite VALUES (2, 315);
INSERT INTO club_activite VALUES (2, 13);
INSERT INTO club_activite VALUES (2, 326);
INSERT INTO club_activite VALUES (2, 212);
INSERT INTO club_activite VALUES (2, 202);
INSERT INTO club_activite VALUES (2, 16);
INSERT INTO club_activite VALUES (2, 332);
INSERT INTO club_activite VALUES (2, 223);
INSERT INTO club_activite VALUES (2, 226);
INSERT INTO club_activite VALUES (2, 322);
INSERT INTO club_activite VALUES (2, 309);
INSERT INTO club_activite VALUES (2, 216);
INSERT INTO club_activite VALUES (2, 329);
INSERT INTO club_activite VALUES (3, 336);
INSERT INTO club_activite VALUES (3, 208);
INSERT INTO club_activite VALUES (3, 218);
INSERT INTO club_activite VALUES (3, 217);
INSERT INTO club_activite VALUES (3, 14);
INSERT INTO club_activite VALUES (3, 240);
INSERT INTO club_activite VALUES (3, 237);
INSERT INTO club_activite VALUES (3, 349);
INSERT INTO club_activite VALUES (3, 11);
INSERT INTO club_activite VALUES (3, 220);
INSERT INTO club_activite VALUES (3, 235);
INSERT INTO club_activite VALUES (3, 307);
INSERT INTO club_activite VALUES (3, 228);
INSERT INTO club_activite VALUES (3, 313);
INSERT INTO club_activite VALUES (3, 320);
INSERT INTO club_activite VALUES (3, 304);
INSERT INTO club_activite VALUES (3, 346);
INSERT INTO club_activite VALUES (3, 22);
INSERT INTO club_activite VALUES (3, 316);
INSERT INTO club_activite VALUES (3, 206);
INSERT INTO club_activite VALUES (4, 318);
INSERT INTO club_activite VALUES (4, 232);
INSERT INTO club_activite VALUES (4, 334);
INSERT INTO club_activite VALUES (4, 245);
INSERT INTO club_activite VALUES (4, 300);
INSERT INTO club_activite VALUES (4, 210);
INSERT INTO club_activite VALUES (4, 205);
INSERT INTO club_activite VALUES (4, 328);
INSERT INTO club_activite VALUES (4, 227);
INSERT INTO club_activite VALUES (4, 238);
INSERT INTO club_activite VALUES (4, 327);
INSERT INTO club_activite VALUES (4, 224);
INSERT INTO club_activite VALUES (4, 310);
INSERT INTO club_activite VALUES (4, 248);
INSERT INTO club_activite VALUES (4, 231);
INSERT INTO club_activite VALUES (4, 215);
INSERT INTO club_activite VALUES (4, 17);
INSERT INTO club_activite VALUES (4, 10);
INSERT INTO club_activite VALUES (4, 325);
INSERT INTO club_activite VALUES (4, 348);
INSERT INTO club_activite VALUES (5, 200);
INSERT INTO club_activite VALUES (5, 339);
INSERT INTO club_activite VALUES (5, 341);
INSERT INTO club_activite VALUES (5, 306);
INSERT INTO club_activite VALUES (5, 330);
INSERT INTO club_activite VALUES (5, 337);
INSERT INTO club_activite VALUES (5, 23);
INSERT INTO club_activite VALUES (5, 204);
INSERT INTO club_activite VALUES (5, 314);
INSERT INTO club_activite VALUES (5, 301);
INSERT INTO club_activite VALUES (5, 29);
INSERT INTO club_activite VALUES (5, 340);
INSERT INTO club_activite VALUES (5, 234);
INSERT INTO club_activite VALUES (5, 233);
INSERT INTO club_activite VALUES (5, 3);
INSERT INTO club_activite VALUES (5, 8);
INSERT INTO club_activite VALUES (5, 343);
INSERT INTO club_activite VALUES (5, 241);
INSERT INTO club_activite VALUES (5, 246);
INSERT INTO club_activite VALUES (5, 247);
INSERT INTO club_activite VALUES (6, 211);
INSERT INTO club_activite VALUES (6, 323);
INSERT INTO club_activite VALUES (6, 249);
INSERT INTO club_activite VALUES (6, 4);
INSERT INTO club_activite VALUES (6, 331);
INSERT INTO club_activite VALUES (6, 221);
INSERT INTO club_activite VALUES (6, 7);
INSERT INTO club_activite VALUES (6, 244);
INSERT INTO club_activite VALUES (6, 317);
INSERT INTO club_activite VALUES (6, 21);
INSERT INTO club_activite VALUES (6, 207);
INSERT INTO club_activite VALUES (6, 324);
INSERT INTO club_activite VALUES (6, 347);
INSERT INTO club_activite VALUES (6, 5);
INSERT INTO club_activite VALUES (6, 242);
INSERT INTO club_activite VALUES (6, 213);
INSERT INTO club_activite VALUES (6, 308);
INSERT INTO club_activite VALUES (6, 201);
INSERT INTO club_activite VALUES (6, 344);
INSERT INTO club_activite VALUES (6, 312);
INSERT INTO club_activite VALUES (7, 214);
INSERT INTO club_activite VALUES (7, 335);
INSERT INTO club_activite VALUES (7, 329);
INSERT INTO club_activite VALUES (7, 239);
INSERT INTO club_activite VALUES (7, 209);
INSERT INTO club_activite VALUES (7, 1);
INSERT INTO club_activite VALUES (7, 305);
INSERT INTO club_activite VALUES (7, 13);
INSERT INTO club_activite VALUES (7, 202);
INSERT INTO club_activite VALUES (7, 311);
INSERT INTO club_activite VALUES (7, 333);
INSERT INTO club_activite VALUES (7, 243);
INSERT INTO club_activite VALUES (7, 319);
INSERT INTO club_activite VALUES (7, 11);
INSERT INTO club_activite VALUES (7, 230);
INSERT INTO club_activite VALUES (7, 212);
INSERT INTO club_activite VALUES (7, 222);
INSERT INTO club_activite VALUES (7, 303);
INSERT INTO club_activite VALUES (7, 345);
INSERT INTO club_activite VALUES (7, 18);
INSERT INTO club_activite VALUES (8, 219);
INSERT INTO club_activite VALUES (8, 12);
INSERT INTO club_activite VALUES (8, 302);
INSERT INTO club_activite VALUES (8, 229);
INSERT INTO club_activite VALUES (8, 322);
INSERT INTO club_activite VALUES (8, 15);
INSERT INTO club_activite VALUES (8, 326);
INSERT INTO club_activite VALUES (8, 203);
INSERT INTO club_activite VALUES (8, 216);
INSERT INTO club_activite VALUES (8, 240);
INSERT INTO club_activite VALUES (8, 332);
INSERT INTO club_activite VALUES (8, 309);
INSERT INTO club_activite VALUES (8, 338);
INSERT INTO club_activite VALUES (8, 321);
INSERT INTO club_activite VALUES (8, 236);
INSERT INTO club_activite VALUES (8, 225);
INSERT INTO club_activite VALUES (8, 9);
INSERT INTO club_activite VALUES (8, 218);
INSERT INTO club_activite VALUES (8, 342);
INSERT INTO club_activite VALUES (8, 226);
INSERT INTO club_activite VALUES (9, 235);
INSERT INTO club_activite VALUES (9, 315);
INSERT INTO club_activite VALUES (9, 16);
INSERT INTO club_activite VALUES (9, 237);
INSERT INTO club_activite VALUES (9, 220);
INSERT INTO club_activite VALUES (9, 336);
INSERT INTO club_activite VALUES (9, 223);
INSERT INTO club_activite VALUES (9, 14);
INSERT INTO club_activite VALUES (9, 307);
INSERT INTO club_activite VALUES (9, 313);
INSERT INTO club_activite VALUES (9, 208);
INSERT INTO club_activite VALUES (9, 320);
INSERT INTO club_activite VALUES (9, 217);
INSERT INTO club_activite VALUES (9, 349);
INSERT INTO club_activite VALUES (9, 228);
INSERT INTO club_activite VALUES (9, 346);
INSERT INTO club_activite VALUES (9, 206);
INSERT INTO club_activite VALUES (9, 304);
INSERT INTO club_activite VALUES (9, 22);
INSERT INTO club_activite VALUES (10, 316);
INSERT INTO club_activite VALUES (10, 205);
INSERT INTO club_activite VALUES (10, 238);
INSERT INTO club_activite VALUES (10, 328);
INSERT INTO club_activite VALUES (10, 210);
INSERT INTO club_activite VALUES (10, 327);
INSERT INTO club_activite VALUES (10, 325);
INSERT INTO club_activite VALUES (10, 248);
INSERT INTO club_activite VALUES (10, 224);
INSERT INTO club_activite VALUES (10, 310);
INSERT INTO club_activite VALUES (10, 245);
INSERT INTO club_activite VALUES (10, 348);
INSERT INTO club_activite VALUES (10, 300);
INSERT INTO club_activite VALUES (10, 318);
INSERT INTO club_activite VALUES (10, 227);
INSERT INTO club_activite VALUES (10, 231);
INSERT INTO club_activite VALUES (10, 334);
INSERT INTO club_activite VALUES (10, 330);
INSERT INTO club_activite VALUES (10, 215);
INSERT INTO club_activite VALUES (10, 232);
INSERT INTO club_activite VALUES (11, 200);
INSERT INTO club_activite VALUES (11, 337);
INSERT INTO club_activite VALUES (11, 306);
INSERT INTO club_activite VALUES (11, 339);
INSERT INTO club_activite VALUES (11, 10);
INSERT INTO club_activite VALUES (11, 341);
INSERT INTO club_activite VALUES (11, 246);
INSERT INTO club_activite VALUES (11, 340);
INSERT INTO club_activite VALUES (11, 241);
INSERT INTO club_activite VALUES (11, 301);
INSERT INTO club_activite VALUES (11, 233);
INSERT INTO club_activite VALUES (11, 8);
INSERT INTO club_activite VALUES (11, 343);
INSERT INTO club_activite VALUES (11, 29);
INSERT INTO club_activite VALUES (11, 234);
INSERT INTO club_activite VALUES (11, 23);
INSERT INTO club_activite VALUES (11, 17);
INSERT INTO club_activite VALUES (11, 314);
INSERT INTO club_activite VALUES (11, 247);
INSERT INTO club_activite VALUES (11, 204);
INSERT INTO club_activite VALUES (12, 3);
INSERT INTO club_activite VALUES (12, 207);
INSERT INTO club_activite VALUES (12, 211);
INSERT INTO club_activite VALUES (12, 331);
INSERT INTO club_activite VALUES (12, 347);
INSERT INTO club_activite VALUES (12, 323);
INSERT INTO club_activite VALUES (12, 244);
INSERT INTO club_activite VALUES (12, 249);
INSERT INTO club_activite VALUES (12, 4);
INSERT INTO club_activite VALUES (12, 344);
INSERT INTO club_activite VALUES (12, 221);
INSERT INTO club_activite VALUES (12, 242);
INSERT INTO club_activite VALUES (12, 5);
INSERT INTO club_activite VALUES (12, 7);
INSERT INTO club_activite VALUES (12, 317);
INSERT INTO club_activite VALUES (12, 324);
INSERT INTO club_activite VALUES (12, 21);
INSERT INTO club_activite VALUES (12, 308);
INSERT INTO club_activite VALUES (12, 312);
INSERT INTO club_activite VALUES (12, 201);
INSERT INTO club_activite VALUES (13, 213);
INSERT INTO club_activite VALUES (13, 209);
INSERT INTO club_activite VALUES (13, 305);
INSERT INTO club_activite VALUES (13, 222);
INSERT INTO club_activite VALUES (13, 11);
INSERT INTO club_activite VALUES (13, 239);
INSERT INTO club_activite VALUES (13, 319);
INSERT INTO club_activite VALUES (13, 18);
INSERT INTO club_activite VALUES (13, 212);
INSERT INTO club_activite VALUES (13, 230);
INSERT INTO club_activite VALUES (13, 345);
INSERT INTO club_activite VALUES (13, 13);
INSERT INTO club_activite VALUES (13, 214);
INSERT INTO club_activite VALUES (13, 335);
INSERT INTO club_activite VALUES (13, 303);
INSERT INTO club_activite VALUES (13, 329);
INSERT INTO club_activite VALUES (13, 202);
INSERT INTO club_activite VALUES (13, 311);
INSERT INTO club_activite VALUES (13, 243);
INSERT INTO club_activite VALUES (13, 333);
INSERT INTO club_activite VALUES (14, 218);
INSERT INTO club_activite VALUES (14, 342);
INSERT INTO club_activite VALUES (14, 302);
INSERT INTO club_activite VALUES (14, 322);
INSERT INTO club_activite VALUES (14, 240);
INSERT INTO club_activite VALUES (14, 216);
INSERT INTO club_activite VALUES (14, 236);
INSERT INTO club_activite VALUES (14, 332);
INSERT INTO club_activite VALUES (14, 203);
INSERT INTO club_activite VALUES (14, 12);
INSERT INTO club_activite VALUES (14, 321);
INSERT INTO club_activite VALUES (14, 1);
INSERT INTO club_activite VALUES (14, 15);
INSERT INTO club_activite VALUES (14, 326);
INSERT INTO club_activite VALUES (14, 9);
INSERT INTO club_activite VALUES (14, 226);
INSERT INTO club_activite VALUES (14, 225);
INSERT INTO club_activite VALUES (14, 229);
INSERT INTO club_activite VALUES (14, 309);
INSERT INTO club_activite VALUES (14, 338);
INSERT INTO club_activite VALUES (15, 235);
INSERT INTO club_activite VALUES (15, 219);
INSERT INTO club_activite VALUES (15, 349);
INSERT INTO club_activite VALUES (15, 14);
INSERT INTO club_activite VALUES (15, 346);
INSERT INTO club_activite VALUES (15, 206);
INSERT INTO club_activite VALUES (15, 220);
INSERT INTO club_activite VALUES (15, 336);
INSERT INTO club_activite VALUES (15, 237);
INSERT INTO club_activite VALUES (15, 320);
INSERT INTO club_activite VALUES (15, 228);
INSERT INTO club_activite VALUES (15, 217);
INSERT INTO club_activite VALUES (15, 22);
INSERT INTO club_activite VALUES (15, 304);
INSERT INTO club_activite VALUES (15, 208);
INSERT INTO club_activite VALUES (15, 313);
INSERT INTO club_activite VALUES (15, 307);
INSERT INTO club_activite VALUES (15, 16);
INSERT INTO club_activite VALUES (15, 315);
INSERT INTO club_activite VALUES (16, 223);
INSERT INTO club_activite VALUES (16, 328);
INSERT INTO club_activite VALUES (16, 227);
INSERT INTO club_activite VALUES (16, 310);
INSERT INTO club_activite VALUES (16, 245);
INSERT INTO club_activite VALUES (16, 238);
INSERT INTO club_activite VALUES (16, 327);
INSERT INTO club_activite VALUES (16, 330);
INSERT INTO club_activite VALUES (16, 316);
INSERT INTO club_activite VALUES (16, 348);
INSERT INTO club_activite VALUES (16, 210);
INSERT INTO club_activite VALUES (16, 248);
INSERT INTO club_activite VALUES (16, 300);
INSERT INTO club_activite VALUES (16, 224);
INSERT INTO club_activite VALUES (16, 205);
INSERT INTO club_activite VALUES (16, 231);
INSERT INTO club_activite VALUES (16, 325);
INSERT INTO club_activite VALUES (16, 318);
INSERT INTO club_activite VALUES (16, 334);
INSERT INTO club_activite VALUES (16, 215);
INSERT INTO club_activite VALUES (17, 232);
INSERT INTO club_activite VALUES (17, 339);
INSERT INTO club_activite VALUES (17, 241);
INSERT INTO club_activite VALUES (17, 247);
INSERT INTO club_activite VALUES (17, 234);
INSERT INTO club_activite VALUES (17, 341);
INSERT INTO club_activite VALUES (17, 29);
INSERT INTO club_activite VALUES (17, 8);
INSERT INTO club_activite VALUES (17, 340);
INSERT INTO club_activite VALUES (17, 233);
INSERT INTO club_activite VALUES (17, 301);
INSERT INTO club_activite VALUES (17, 3);
INSERT INTO club_activite VALUES (17, 200);
INSERT INTO club_activite VALUES (17, 306);
INSERT INTO club_activite VALUES (17, 246);
INSERT INTO club_activite VALUES (17, 337);
INSERT INTO club_activite VALUES (17, 204);
INSERT INTO club_activite VALUES (17, 23);
INSERT INTO club_activite VALUES (17, 10);
INSERT INTO club_activite VALUES (17, 330);
INSERT INTO club_activite VALUES (18, 314);
INSERT INTO club_activite VALUES (18, 343);
INSERT INTO club_activite VALUES (18, 221);
INSERT INTO club_activite VALUES (18, 331);
INSERT INTO club_activite VALUES (18, 242);
INSERT INTO club_activite VALUES (18, 323);
INSERT INTO club_activite VALUES (18, 312);
INSERT INTO club_activite VALUES (18, 211);
INSERT INTO club_activite VALUES (18, 308);
INSERT INTO club_activite VALUES (18, 213);
INSERT INTO club_activite VALUES (18, 324);
INSERT INTO club_activite VALUES (18, 207);
INSERT INTO club_activite VALUES (18, 317);
INSERT INTO club_activite VALUES (18, 7);
INSERT INTO club_activite VALUES (18, 347);
INSERT INTO club_activite VALUES (18, 244);
INSERT INTO club_activite VALUES (18, 5);
INSERT INTO club_activite VALUES (18, 201);
INSERT INTO club_activite VALUES (18, 4);
INSERT INTO club_activite VALUES (18, 344);
INSERT INTO club_activite VALUES (19, 214);
INSERT INTO club_activite VALUES (19, 222);
INSERT INTO club_activite VALUES (19, 1);
INSERT INTO club_activite VALUES (19, 13);
INSERT INTO club_activite VALUES (19, 202);
INSERT INTO club_activite VALUES (19, 311);
INSERT INTO club_activite VALUES (19, 243);
INSERT INTO club_activite VALUES (19, 11);
INSERT INTO club_activite VALUES (19, 329);
INSERT INTO club_activite VALUES (19, 335);
INSERT INTO club_activite VALUES (19, 18);
INSERT INTO club_activite VALUES (19, 305);
INSERT INTO club_activite VALUES (19, 333);
INSERT INTO club_activite VALUES (19, 209);
INSERT INTO club_activite VALUES (19, 230);
INSERT INTO club_activite VALUES (19, 239);
INSERT INTO club_activite VALUES (19, 212);
INSERT INTO club_activite VALUES (19, 303);
INSERT INTO club_activite VALUES (19, 345);
INSERT INTO club_activite VALUES (19, 319);
INSERT INTO club_activite VALUES (20, 219);
INSERT INTO club_activite VALUES (20, 322);
INSERT INTO club_activite VALUES (20, 321);
INSERT INTO club_activite VALUES (20, 326);
INSERT INTO club_activite VALUES (20, 338);
INSERT INTO club_activite VALUES (20, 302);
INSERT INTO club_activite VALUES (20, 15);
INSERT INTO club_activite VALUES (20, 309);
INSERT INTO club_activite VALUES (20, 240);
INSERT INTO club_activite VALUES (20, 226);
INSERT INTO club_activite VALUES (20, 342);
INSERT INTO club_activite VALUES (20, 9);
INSERT INTO club_activite VALUES (20, 332);
INSERT INTO club_activite VALUES (20, 229);
INSERT INTO club_activite VALUES (20, 225);
INSERT INTO club_activite VALUES (20, 12);
INSERT INTO club_activite VALUES (20, 216);
INSERT INTO club_activite VALUES (20, 203);
INSERT INTO club_activite VALUES (20, 218);
INSERT INTO club_activite VALUES (20, 236);
INSERT INTO club_activite VALUES (21, 235);
INSERT INTO club_activite VALUES (21, 349);
INSERT INTO club_activite VALUES (21, 223);
INSERT INTO club_activite VALUES (21, 228);
INSERT INTO club_activite VALUES (21, 320);
INSERT INTO club_activite VALUES (21, 307);
INSERT INTO club_activite VALUES (21, 313);
INSERT INTO club_activite VALUES (21, 237);
INSERT INTO club_activite VALUES (21, 14);
INSERT INTO club_activite VALUES (21, 206);
INSERT INTO club_activite VALUES (21, 220);
INSERT INTO club_activite VALUES (21, 304);
INSERT INTO club_activite VALUES (21, 217);
INSERT INTO club_activite VALUES (21, 208);
INSERT INTO club_activite VALUES (21, 22);
INSERT INTO club_activite VALUES (21, 346);
INSERT INTO club_activite VALUES (21, 336);
INSERT INTO club_activite VALUES (21, 315);
INSERT INTO club_activite VALUES (21, 16);
INSERT INTO club_activite VALUES (22, 238);
INSERT INTO club_activite VALUES (22, 318);
INSERT INTO club_activite VALUES (22, 232);
INSERT INTO club_activite VALUES (22, 334);
INSERT INTO club_activite VALUES (22, 325);
INSERT INTO club_activite VALUES (22, 245);
INSERT INTO club_activite VALUES (22, 316);
INSERT INTO club_activite VALUES (22, 210);
INSERT INTO club_activite VALUES (22, 205);
INSERT INTO club_activite VALUES (22, 231);
INSERT INTO club_activite VALUES (22, 327);
INSERT INTO club_activite VALUES (22, 348);
INSERT INTO club_activite VALUES (22, 215);
INSERT INTO club_activite VALUES (22, 330);
INSERT INTO club_activite VALUES (22, 248);
INSERT INTO club_activite VALUES (22, 224);
INSERT INTO club_activite VALUES (22, 300);
INSERT INTO club_activite VALUES (22, 310);
INSERT INTO club_activite VALUES (22, 227);
INSERT INTO club_activite VALUES (22, 328);
INSERT INTO club_activite VALUES (23, 200);
INSERT INTO club_activite VALUES (23, 246);
INSERT INTO club_activite VALUES (23, 234);
INSERT INTO club_activite VALUES (23, 306);
INSERT INTO club_activite VALUES (23, 204);
INSERT INTO club_activite VALUES (23, 17);
INSERT INTO club_activite VALUES (23, 10);
INSERT INTO club_activite VALUES (23, 301);
INSERT INTO club_activite VALUES (23, 233);
INSERT INTO club_activite VALUES (23, 339);
INSERT INTO club_activite VALUES (23, 247);
INSERT INTO club_activite VALUES (23, 337);
INSERT INTO club_activite VALUES (23, 343);
INSERT INTO club_activite VALUES (23, 23);
INSERT INTO club_activite VALUES (23, 341);
INSERT INTO club_activite VALUES (23, 29);
INSERT INTO club_activite VALUES (23, 8);
INSERT INTO club_activite VALUES (23, 241);
INSERT INTO club_activite VALUES (23, 3);
INSERT INTO club_activite VALUES (23, 314);
INSERT INTO club_activite VALUES (24, 21);
INSERT INTO club_activite VALUES (24, 324);
INSERT INTO club_activite VALUES (24, 221);
INSERT INTO club_activite VALUES (24, 244);
INSERT INTO club_activite VALUES (24, 344);
INSERT INTO club_activite VALUES (24, 323);
INSERT INTO club_activite VALUES (24, 331);
INSERT INTO club_activite VALUES (24, 201);
INSERT INTO club_activite VALUES (24, 249);
INSERT INTO club_activite VALUES (24, 347);
INSERT INTO club_activite VALUES (24, 213);
INSERT INTO club_activite VALUES (24, 312);
INSERT INTO club_activite VALUES (24, 207);
INSERT INTO club_activite VALUES (24, 242);
INSERT INTO club_activite VALUES (24, 4);
INSERT INTO club_activite VALUES (24, 308);
INSERT INTO club_activite VALUES (24, 317);
INSERT INTO club_activite VALUES (24, 5);
INSERT INTO club_activite VALUES (24, 7);
INSERT INTO club_activite VALUES (24, 211);
INSERT INTO club_activite VALUES (25, 239);
INSERT INTO club_activite VALUES (25, 230);
INSERT INTO club_activite VALUES (25, 335);
INSERT INTO club_activite VALUES (25, 12);
INSERT INTO club_activite VALUES (25, 345);
INSERT INTO club_activite VALUES (25, 202);
INSERT INTO club_activite VALUES (25, 321);
INSERT INTO club_activite VALUES (25, 303);
INSERT INTO club_activite VALUES (25, 11);
INSERT INTO club_activite VALUES (25, 1);
INSERT INTO club_activite VALUES (25, 333);
INSERT INTO club_activite VALUES (25, 13);
INSERT INTO club_activite VALUES (25, 212);
INSERT INTO club_activite VALUES (25, 209);
INSERT INTO club_activite VALUES (25, 243);
INSERT INTO club_activite VALUES (25, 319);
INSERT INTO club_activite VALUES (25, 311);
INSERT INTO club_activite VALUES (25, 222);
INSERT INTO club_activite VALUES (25, 214);
INSERT INTO club_activite VALUES (25, 305);
INSERT INTO club_activite VALUES (26, 322);
INSERT INTO club_activite VALUES (26, 218);
INSERT INTO club_activite VALUES (26, 240);
INSERT INTO club_activite VALUES (26, 309);
INSERT INTO club_activite VALUES (26, 9);
INSERT INTO club_activite VALUES (26, 219);
INSERT INTO club_activite VALUES (26, 15);
INSERT INTO club_activite VALUES (26, 332);
INSERT INTO club_activite VALUES (26, 302);
INSERT INTO club_activite VALUES (26, 342);
INSERT INTO club_activite VALUES (26, 326);
INSERT INTO club_activite VALUES (26, 338);
INSERT INTO club_activite VALUES (26, 229);
INSERT INTO club_activite VALUES (26, 203);
INSERT INTO club_activite VALUES (26, 225);
INSERT INTO club_activite VALUES (26, 226);
INSERT INTO club_activite VALUES (26, 18);
INSERT INTO club_activite VALUES (26, 236);
INSERT INTO club_activite VALUES (26, 216);
INSERT INTO club_activite VALUES (27, 235);
INSERT INTO club_activite VALUES (27, 349);
INSERT INTO club_activite VALUES (27, 206);
INSERT INTO club_activite VALUES (27, 307);
INSERT INTO club_activite VALUES (27, 228);
INSERT INTO club_activite VALUES (27, 320);
INSERT INTO club_activite VALUES (27, 315);
INSERT INTO club_activite VALUES (27, 217);
INSERT INTO club_activite VALUES (27, 304);
INSERT INTO club_activite VALUES (27, 346);
INSERT INTO club_activite VALUES (27, 16);
INSERT INTO club_activite VALUES (27, 220);
INSERT INTO club_activite VALUES (27, 237);
INSERT INTO club_activite VALUES (27, 336);
INSERT INTO club_activite VALUES (27, 313);
INSERT INTO club_activite VALUES (27, 223);
INSERT INTO club_activite VALUES (27, 208);
INSERT INTO club_activite VALUES (27, 14);
INSERT INTO club_activite VALUES (27, 22);
INSERT INTO club_activite VALUES (28, 325);
INSERT INTO club_activite VALUES (28, 238);
INSERT INTO club_activite VALUES (28, 327);
INSERT INTO club_activite VALUES (28, 205);
INSERT INTO club_activite VALUES (28, 310);
INSERT INTO club_activite VALUES (28, 227);
INSERT INTO club_activite VALUES (28, 328);
INSERT INTO club_activite VALUES (28, 334);
INSERT INTO club_activite VALUES (28, 224);
INSERT INTO club_activite VALUES (28, 348);
INSERT INTO club_activite VALUES (28, 316);
INSERT INTO club_activite VALUES (28, 300);
INSERT INTO club_activite VALUES (28, 215);
INSERT INTO club_activite VALUES (28, 210);
INSERT INTO club_activite VALUES (28, 248);
INSERT INTO club_activite VALUES (28, 318);
INSERT INTO club_activite VALUES (28, 245);
INSERT INTO club_activite VALUES (28, 330);
INSERT INTO club_activite VALUES (28, 232);
INSERT INTO club_activite VALUES (28, 231);
INSERT INTO club_activite VALUES (29, 3);
INSERT INTO club_activite VALUES (29, 343);
INSERT INTO club_activite VALUES (29, 247);
INSERT INTO club_activite VALUES (29, 200);
INSERT INTO club_activite VALUES (29, 233);
INSERT INTO club_activite VALUES (29, 10);
INSERT INTO club_activite VALUES (29, 8);
INSERT INTO club_activite VALUES (29, 246);
INSERT INTO club_activite VALUES (29, 29);
INSERT INTO club_activite VALUES (29, 337);
INSERT INTO club_activite VALUES (29, 17);
INSERT INTO club_activite VALUES (29, 306);
INSERT INTO club_activite VALUES (29, 339);
INSERT INTO club_activite VALUES (29, 341);
INSERT INTO club_activite VALUES (29, 204);
INSERT INTO club_activite VALUES (29, 241);
INSERT INTO club_activite VALUES (29, 301);
INSERT INTO club_activite VALUES (29, 340);
INSERT INTO club_activite VALUES (29, 314);
INSERT INTO club_activite VALUES (29, 234);
INSERT INTO club_activite VALUES (30, 207);
INSERT INTO club_activite VALUES (30, 242);
INSERT INTO club_activite VALUES (30, 211);
INSERT INTO club_activite VALUES (30, 5);
INSERT INTO club_activite VALUES (30, 317);
INSERT INTO club_activite VALUES (30, 221);
INSERT INTO club_activite VALUES (30, 344);
INSERT INTO club_activite VALUES (30, 7);
INSERT INTO club_activite VALUES (30, 324);
INSERT INTO club_activite VALUES (30, 244);
INSERT INTO club_activite VALUES (30, 331);
INSERT INTO club_activite VALUES (30, 323);
INSERT INTO club_activite VALUES (30, 347);
INSERT INTO club_activite VALUES (30, 4);
INSERT INTO club_activite VALUES (30, 249);
INSERT INTO club_activite VALUES (30, 308);
INSERT INTO club_activite VALUES (30, 312);
INSERT INTO club_activite VALUES (30, 213);
INSERT INTO club_activite VALUES (30, 21);
INSERT INTO club_activite VALUES (30, 201);
INSERT INTO club_activite VALUES (31, 333);
INSERT INTO club_activite VALUES (31, 239);
INSERT INTO club_activite VALUES (31, 305);
INSERT INTO club_activite VALUES (31, 13);
INSERT INTO club_activite VALUES (31, 243);
INSERT INTO club_activite VALUES (31, 329);
INSERT INTO club_activite VALUES (31, 212);
INSERT INTO club_activite VALUES (31, 335);
INSERT INTO club_activite VALUES (31, 345);
INSERT INTO club_activite VALUES (31, 12);
INSERT INTO club_activite VALUES (31, 230);
INSERT INTO club_activite VALUES (31, 311);
INSERT INTO club_activite VALUES (31, 222);
INSERT INTO club_activite VALUES (31, 202);
INSERT INTO club_activite VALUES (31, 213);
INSERT INTO club_activite VALUES (31, 18);
INSERT INTO club_activite VALUES (31, 209);
INSERT INTO club_activite VALUES (31, 214);
INSERT INTO club_activite VALUES (31, 303);
INSERT INTO club_activite VALUES (31, 1);
INSERT INTO club_activite VALUES (32, 236);
INSERT INTO club_activite VALUES (32, 240);
INSERT INTO club_activite VALUES (32, 332);
INSERT INTO club_activite VALUES (32, 338);
INSERT INTO club_activite VALUES (32, 216);
INSERT INTO club_activite VALUES (32, 321);
INSERT INTO club_activite VALUES (32, 15);
INSERT INTO club_activite VALUES (32, 203);
INSERT INTO club_activite VALUES (32, 326);
INSERT INTO club_activite VALUES (32, 225);
INSERT INTO club_activite VALUES (32, 302);
INSERT INTO club_activite VALUES (32, 229);
INSERT INTO club_activite VALUES (32, 309);
INSERT INTO club_activite VALUES (32, 226);
INSERT INTO club_activite VALUES (32, 322);
INSERT INTO club_activite VALUES (32, 9);
INSERT INTO club_activite VALUES (32, 219);
INSERT INTO club_activite VALUES (32, 342);
INSERT INTO club_activite VALUES (32, 218);
INSERT INTO club_activite VALUES (32, 12);
INSERT INTO club_activite VALUES (33, 307);
INSERT INTO club_activite VALUES (33, 220);
INSERT INTO club_activite VALUES (33, 223);
INSERT INTO club_activite VALUES (33, 14);
INSERT INTO club_activite VALUES (33, 315);
INSERT INTO club_activite VALUES (33, 235);
INSERT INTO club_activite VALUES (33, 206);
INSERT INTO club_activite VALUES (33, 208);
INSERT INTO club_activite VALUES (33, 228);
INSERT INTO club_activite VALUES (33, 349);
INSERT INTO club_activite VALUES (33, 336);
INSERT INTO club_activite VALUES (33, 16);
INSERT INTO club_activite VALUES (33, 346);
INSERT INTO club_activite VALUES (33, 320);
INSERT INTO club_activite VALUES (33, 304);
INSERT INTO club_activite VALUES (33, 22);
INSERT INTO club_activite VALUES (33, 237);
INSERT INTO club_activite VALUES (33, 217);
INSERT INTO club_activite VALUES (33, 313);
INSERT INTO club_activite VALUES (34, 318);
INSERT INTO club_activite VALUES (34, 328);
INSERT INTO club_activite VALUES (34, 330);
INSERT INTO club_activite VALUES (34, 215);
INSERT INTO club_activite VALUES (34, 224);
INSERT INTO club_activite VALUES (34, 238);
INSERT INTO club_activite VALUES (34, 316);
INSERT INTO club_activite VALUES (34, 245);
INSERT INTO club_activite VALUES (34, 300);
INSERT INTO club_activite VALUES (34, 348);
INSERT INTO club_activite VALUES (34, 334);
INSERT INTO club_activite VALUES (34, 248);
INSERT INTO club_activite VALUES (34, 325);
INSERT INTO club_activite VALUES (34, 227);
INSERT INTO club_activite VALUES (34, 231);
INSERT INTO club_activite VALUES (34, 310);
INSERT INTO club_activite VALUES (34, 232);
INSERT INTO club_activite VALUES (34, 205);
INSERT INTO club_activite VALUES (34, 210);
INSERT INTO club_activite VALUES (34, 327);
INSERT INTO club_activite VALUES (35, 233);
INSERT INTO club_activite VALUES (35, 343);
INSERT INTO club_activite VALUES (35, 10);
INSERT INTO club_activite VALUES (35, 340);
INSERT INTO club_activite VALUES (35, 234);
INSERT INTO club_activite VALUES (35, 29);
INSERT INTO club_activite VALUES (35, 8);
INSERT INTO club_activite VALUES (35, 337);
INSERT INTO club_activite VALUES (35, 241);
INSERT INTO club_activite VALUES (35, 246);
INSERT INTO club_activite VALUES (35, 306);
INSERT INTO club_activite VALUES (35, 247);
INSERT INTO club_activite VALUES (35, 17);
INSERT INTO club_activite VALUES (35, 341);
INSERT INTO club_activite VALUES (35, 339);
INSERT INTO club_activite VALUES (35, 23);
INSERT INTO club_activite VALUES (35, 301);
INSERT INTO club_activite VALUES (35, 314);
INSERT INTO club_activite VALUES (35, 200);
INSERT INTO club_activite VALUES (35, 3);
INSERT INTO club_activite VALUES (36, 317);
INSERT INTO club_activite VALUES (36, 323);
INSERT INTO club_activite VALUES (36, 21);
INSERT INTO club_activite VALUES (36, 308);
INSERT INTO club_activite VALUES (36, 249);
INSERT INTO club_activite VALUES (36, 201);
INSERT INTO club_activite VALUES (36, 347);
INSERT INTO club_activite VALUES (36, 221);
INSERT INTO club_activite VALUES (36, 211);
INSERT INTO club_activite VALUES (36, 331);
INSERT INTO club_activite VALUES (36, 324);
INSERT INTO club_activite VALUES (36, 207);
INSERT INTO club_activite VALUES (36, 344);
INSERT INTO club_activite VALUES (36, 312);
INSERT INTO club_activite VALUES (36, 7);
INSERT INTO club_activite VALUES (36, 244);
INSERT INTO club_activite VALUES (36, 242);
INSERT INTO club_activite VALUES (36, 4);
INSERT INTO club_activite VALUES (36, 5);
INSERT INTO club_activite VALUES (36, 213);
INSERT INTO club_activite VALUES (37, 230);
INSERT INTO club_activite VALUES (37, 303);
INSERT INTO club_activite VALUES (37, 212);
INSERT INTO club_activite VALUES (37, 209);
INSERT INTO club_activite VALUES (37, 1);
INSERT INTO club_activite VALUES (37, 333);
INSERT INTO club_activite VALUES (37, 13);
INSERT INTO club_activite VALUES (37, 239);
INSERT INTO club_activite VALUES (37, 345);
INSERT INTO club_activite VALUES (37, 311);
INSERT INTO club_activite VALUES (37, 222);
INSERT INTO club_activite VALUES (37, 335);
INSERT INTO club_activite VALUES (37, 214);
INSERT INTO club_activite VALUES (37, 12);
INSERT INTO club_activite VALUES (37, 18);
INSERT INTO club_activite VALUES (37, 202);
INSERT INTO club_activite VALUES (37, 243);
INSERT INTO club_activite VALUES (37, 321);
INSERT INTO club_activite VALUES (37, 329);
INSERT INTO club_activite VALUES (37, 305);
INSERT INTO club_activite VALUES (38, 240);
INSERT INTO club_activite VALUES (38, 309);
INSERT INTO club_activite VALUES (38, 322);
INSERT INTO club_activite VALUES (38, 226);
INSERT INTO club_activite VALUES (38, 342);
INSERT INTO club_activite VALUES (38, 225);
INSERT INTO club_activite VALUES (38, 229);
INSERT INTO club_activite VALUES (38, 219);
INSERT INTO club_activite VALUES (38, 15);
INSERT INTO club_activite VALUES (38, 332);
INSERT INTO club_activite VALUES (38, 302);
INSERT INTO club_activite VALUES (38, 9);
INSERT INTO club_activite VALUES (38, 216);
INSERT INTO club_activite VALUES (38, 326);
INSERT INTO club_activite VALUES (38, 203);
INSERT INTO club_activite VALUES (38, 338);
INSERT INTO club_activite VALUES (38, 236);
INSERT INTO club_activite VALUES (38, 12);
INSERT INTO club_activite VALUES (38, 218);
INSERT INTO club_activite VALUES (38, 349);
INSERT INTO club_activite VALUES (39, 220);
INSERT INTO club_activite VALUES (39, 304);
INSERT INTO club_activite VALUES (39, 320);
INSERT INTO club_activite VALUES (39, 223);
INSERT INTO club_activite VALUES (39, 206);
INSERT INTO club_activite VALUES (39, 217);
INSERT INTO club_activite VALUES (39, 235);
INSERT INTO club_activite VALUES (39, 313);
INSERT INTO club_activite VALUES (39, 14);
INSERT INTO club_activite VALUES (39, 346);
INSERT INTO club_activite VALUES (39, 228);
INSERT INTO club_activite VALUES (39, 22);
INSERT INTO club_activite VALUES (39, 237);
INSERT INTO club_activite VALUES (39, 307);
INSERT INTO club_activite VALUES (39, 16);
INSERT INTO club_activite VALUES (39, 336);
INSERT INTO club_activite VALUES (39, 315);
INSERT INTO club_activite VALUES (39, 208);
INSERT INTO club_activite VALUES (39, 349);
INSERT INTO club_activite VALUES (40, 245);
INSERT INTO club_activite VALUES (40, 232);
INSERT INTO club_activite VALUES (40, 310);
INSERT INTO club_activite VALUES (40, 215);
INSERT INTO club_activite VALUES (40, 248);
INSERT INTO club_activite VALUES (40, 227);
INSERT INTO club_activite VALUES (40, 328);
INSERT INTO club_activite VALUES (40, 327);
INSERT INTO club_activite VALUES (40, 224);
INSERT INTO club_activite VALUES (40, 334);
INSERT INTO club_activite VALUES (40, 205);
INSERT INTO club_activite VALUES (40, 238);
INSERT INTO club_activite VALUES (40, 348);
INSERT INTO club_activite VALUES (40, 325);
INSERT INTO club_activite VALUES (40, 316);
INSERT INTO club_activite VALUES (40, 231);
INSERT INTO club_activite VALUES (40, 330);
INSERT INTO club_activite VALUES (40, 210);
INSERT INTO club_activite VALUES (40, 300);
INSERT INTO club_activite VALUES (40, 318);
INSERT INTO club_activite VALUES (41, 234);
INSERT INTO club_activite VALUES (41, 10);
INSERT INTO club_activite VALUES (41, 339);
INSERT INTO club_activite VALUES (41, 233);
INSERT INTO club_activite VALUES (41, 246);
INSERT INTO club_activite VALUES (41, 200);
INSERT INTO club_activite VALUES (41, 343);
INSERT INTO club_activite VALUES (41, 17);
INSERT INTO club_activite VALUES (41, 306);
INSERT INTO club_activite VALUES (41, 247);
INSERT INTO club_activite VALUES (41, 3);
INSERT INTO club_activite VALUES (41, 337);
INSERT INTO club_activite VALUES (41, 204);
INSERT INTO club_activite VALUES (41, 29);
INSERT INTO club_activite VALUES (41, 8);
INSERT INTO club_activite VALUES (41, 241);
INSERT INTO club_activite VALUES (41, 23);
INSERT INTO club_activite VALUES (41, 301);
INSERT INTO club_activite VALUES (41, 340);
INSERT INTO club_activite VALUES (41, 314);
INSERT INTO club_activite VALUES (42, 242);
INSERT INTO club_activite VALUES (42, 344);
INSERT INTO club_activite VALUES (42, 347);
INSERT INTO club_activite VALUES (42, 21);
INSERT INTO club_activite VALUES (42, 201);
INSERT INTO club_activite VALUES (42, 323);
INSERT INTO club_activite VALUES (42, 244);
INSERT INTO club_activite VALUES (42, 221);
INSERT INTO club_activite VALUES (42, 5);
INSERT INTO club_activite VALUES (42, 324);
INSERT INTO club_activite VALUES (42, 249);
INSERT INTO club_activite VALUES (42, 312);
INSERT INTO club_activite VALUES (42, 331);
INSERT INTO club_activite VALUES (42, 317);
INSERT INTO club_activite VALUES (42, 308);
INSERT INTO club_activite VALUES (42, 213);
INSERT INTO club_activite VALUES (42, 4);
INSERT INTO club_activite VALUES (42, 207);
INSERT INTO club_activite VALUES (42, 7);
INSERT INTO club_activite VALUES (42, 211);
INSERT INTO club_activite VALUES (43, 305);
INSERT INTO club_activite VALUES (43, 214);
INSERT INTO club_activite VALUES (43, 222);
INSERT INTO club_activite VALUES (43, 321);
INSERT INTO club_activite VALUES (43, 329);
INSERT INTO club_activite VALUES (43, 243);
INSERT INTO club_activite VALUES (43, 11);
INSERT INTO club_activite VALUES (43, 345);
INSERT INTO club_activite VALUES (43, 202);
INSERT INTO club_activite VALUES (43, 311);
INSERT INTO club_activite VALUES (43, 333);
INSERT INTO club_activite VALUES (43, 230);
INSERT INTO club_activite VALUES (43, 12);
INSERT INTO club_activite VALUES (43, 1);
INSERT INTO club_activite VALUES (43, 335);
INSERT INTO club_activite VALUES (43, 13);
INSERT INTO club_activite VALUES (43, 209);
INSERT INTO club_activite VALUES (43, 18);
INSERT INTO club_activite VALUES (43, 303);
INSERT INTO club_activite VALUES (43, 212);
INSERT INTO club_activite VALUES (44, 216);
INSERT INTO club_activite VALUES (44, 302);
INSERT INTO club_activite VALUES (44, 322);
INSERT INTO club_activite VALUES (44, 349);
INSERT INTO club_activite VALUES (44, 15);
INSERT INTO club_activite VALUES (44, 229);
INSERT INTO club_activite VALUES (44, 326);
INSERT INTO club_activite VALUES (44, 309);
INSERT INTO club_activite VALUES (44, 219);
INSERT INTO club_activite VALUES (44, 338);
INSERT INTO club_activite VALUES (44, 203);
INSERT INTO club_activite VALUES (44, 332);
INSERT INTO club_activite VALUES (44, 236);
INSERT INTO club_activite VALUES (44, 342);
INSERT INTO club_activite VALUES (44, 226);
INSERT INTO club_activite VALUES (44, 218);
INSERT INTO club_activite VALUES (44, 240);
INSERT INTO club_activite VALUES (44, 9);
INSERT INTO club_activite VALUES (44, 225);
INSERT INTO club_activite VALUES (44, 12);
INSERT INTO club_activite VALUES (45, 336);
INSERT INTO club_activite VALUES (45, 235);
INSERT INTO club_activite VALUES (45, 313);
INSERT INTO club_activite VALUES (45, 346);
INSERT INTO club_activite VALUES (45, 14);
INSERT INTO club_activite VALUES (45, 237);
INSERT INTO club_activite VALUES (45, 16);
INSERT INTO club_activite VALUES (45, 228);
INSERT INTO club_activite VALUES (45, 206);
INSERT INTO club_activite VALUES (45, 220);
INSERT INTO club_activite VALUES (45, 223);
INSERT INTO club_activite VALUES (45, 304);
INSERT INTO club_activite VALUES (45, 217);
INSERT INTO club_activite VALUES (45, 320);
INSERT INTO club_activite VALUES (45, 208);
INSERT INTO club_activite VALUES (45, 22);
INSERT INTO club_activite VALUES (45, 307);
INSERT INTO club_activite VALUES (45, 315);
INSERT INTO club_activite VALUES (45, 349);
INSERT INTO club_activite VALUES (46, 325);
INSERT INTO club_activite VALUES (46, 224);
INSERT INTO club_activite VALUES (46, 310);
INSERT INTO club_activite VALUES (46, 348);
INSERT INTO club_activite VALUES (46, 231);
INSERT INTO club_activite VALUES (46, 248);
INSERT INTO club_activite VALUES (46, 327);
INSERT INTO club_activite VALUES (46, 316);
INSERT INTO club_activite VALUES (46, 300);
INSERT INTO club_activite VALUES (46, 238);
INSERT INTO club_activite VALUES (46, 330);
INSERT INTO club_activite VALUES (46, 215);
INSERT INTO club_activite VALUES (46, 205);
INSERT INTO club_activite VALUES (46, 334);
INSERT INTO club_activite VALUES (46, 210);
INSERT INTO club_activite VALUES (46, 245);
INSERT INTO club_activite VALUES (46, 227);
INSERT INTO club_activite VALUES (46, 318);
INSERT INTO club_activite VALUES (46, 328);
INSERT INTO club_activite VALUES (46, 223);
INSERT INTO club_activite VALUES (47, 241);
INSERT INTO club_activite VALUES (47, 10);
INSERT INTO club_activite VALUES (47, 301);
INSERT INTO club_activite VALUES (47, 306);
INSERT INTO club_activite VALUES (47, 234);
INSERT INTO club_activite VALUES (47, 233);
INSERT INTO club_activite VALUES (47, 200);
INSERT INTO club_activite VALUES (47, 339);
INSERT INTO club_activite VALUES (47, 337);
INSERT INTO club_activite VALUES (47, 246);
INSERT INTO club_activite VALUES (47, 314);
INSERT INTO club_activite VALUES (47, 8);
INSERT INTO club_activite VALUES (47, 340);
INSERT INTO club_activite VALUES (47, 204);
INSERT INTO club_activite VALUES (47, 17);
INSERT INTO club_activite VALUES (47, 247);
INSERT INTO club_activite VALUES (47, 29);
INSERT INTO club_activite VALUES (47, 23);
INSERT INTO club_activite VALUES (47, 3);
INSERT INTO club_activite VALUES (47, 343);
INSERT INTO club_activite VALUES (48, 221);
INSERT INTO club_activite VALUES (48, 211);
INSERT INTO club_activite VALUES (48, 207);
INSERT INTO club_activite VALUES (48, 331);
INSERT INTO club_activite VALUES (48, 244);
INSERT INTO club_activite VALUES (48, 323);
INSERT INTO club_activite VALUES (48, 347);
INSERT INTO club_activite VALUES (48, 312);
INSERT INTO club_activite VALUES (48, 242);
INSERT INTO club_activite VALUES (48, 21);
INSERT INTO club_activite VALUES (48, 201);
INSERT INTO club_activite VALUES (48, 4);
INSERT INTO club_activite VALUES (48, 308);
INSERT INTO club_activite VALUES (48, 324);
INSERT INTO club_activite VALUES (48, 5);
INSERT INTO club_activite VALUES (48, 7);
INSERT INTO club_activite VALUES (48, 249);
INSERT INTO club_activite VALUES (48, 317);
INSERT INTO club_activite VALUES (48, 344);
INSERT INTO club_activite VALUES (48, 213);
INSERT INTO club_activite VALUES (49, 13);
INSERT INTO club_activite VALUES (49, 212);
INSERT INTO club_activite VALUES (49, 321);
INSERT INTO club_activite VALUES (49, 1);
INSERT INTO club_activite VALUES (49, 333);
INSERT INTO club_activite VALUES (49, 345);
INSERT INTO club_activite VALUES (49, 222);
INSERT INTO club_activite VALUES (49, 329);
INSERT INTO club_activite VALUES (49, 303);
INSERT INTO club_activite VALUES (49, 243);
INSERT INTO club_activite VALUES (49, 230);
INSERT INTO club_activite VALUES (49, 311);
INSERT INTO club_activite VALUES (49, 305);
INSERT INTO club_activite VALUES (49, 12);
INSERT INTO club_activite VALUES (49, 335);
INSERT INTO club_activite VALUES (49, 202);
INSERT INTO club_activite VALUES (49, 214);
INSERT INTO club_activite VALUES (49, 319);
INSERT INTO club_activite VALUES (49, 11);
INSERT INTO club_activite VALUES (49, 18);
INSERT INTO club_activite VALUES (50, 15);
INSERT INTO club_activite VALUES (50, 216);
INSERT INTO club_activite VALUES (50, 240);
INSERT INTO club_activite VALUES (50, 236);
INSERT INTO club_activite VALUES (50, 203);
INSERT INTO club_activite VALUES (50, 302);
INSERT INTO club_activite VALUES (50, 332);
INSERT INTO club_activite VALUES (50, 326);
INSERT INTO club_activite VALUES (50, 342);
INSERT INTO club_activite VALUES (50, 229);
INSERT INTO club_activite VALUES (50, 338);
INSERT INTO club_activite VALUES (50, 322);
INSERT INTO club_activite VALUES (50, 12);
INSERT INTO club_activite VALUES (50, 226);
INSERT INTO club_activite VALUES (50, 309);
INSERT INTO club_activite VALUES (50, 9);
INSERT INTO club_activite VALUES (50, 218);
INSERT INTO club_activite VALUES (50, 225);
INSERT INTO club_activite VALUES (50, 349);
INSERT INTO club_activite VALUES (50, 219);

-- club_categorie
INSERT INTO club_categorie VALUES (1, 1);
INSERT INTO club_categorie VALUES (1, 9);
INSERT INTO club_categorie VALUES (2, 11);
INSERT INTO club_categorie VALUES (3, 2);
INSERT INTO club_categorie VALUES (3, 4);
INSERT INTO club_categorie VALUES (4, 2);
INSERT INTO club_categorie VALUES (5, 2);
INSERT INTO club_categorie VALUES (5, 3);
INSERT INTO club_categorie VALUES (6, 2);
INSERT INTO club_categorie VALUES (7, 2);
INSERT INTO club_categorie VALUES (8, 11);
INSERT INTO club_categorie VALUES (9, 11);
INSERT INTO club_categorie VALUES (10, 2);
INSERT INTO club_categorie VALUES (10, 3);
INSERT INTO club_categorie VALUES (11, 1);
INSERT INTO club_categorie VALUES (12, 1);
INSERT INTO club_categorie VALUES (12, 7);
INSERT INTO club_categorie VALUES (13, 1);
INSERT INTO club_categorie VALUES (14, 2);
INSERT INTO club_categorie VALUES (15, 2);
INSERT INTO club_categorie VALUES (16, 2);
INSERT INTO club_categorie VALUES (16, 7);
INSERT INTO club_categorie VALUES (17, 2);
INSERT INTO club_categorie VALUES (17, 8);
INSERT INTO club_categorie VALUES (18, 2);
INSERT INTO club_categorie VALUES (18, 5);
INSERT INTO club_categorie VALUES (19, 2);
INSERT INTO club_categorie VALUES (20, 2);
INSERT INTO club_categorie VALUES (20, 7);
INSERT INTO club_categorie VALUES (21, 11);
INSERT INTO club_categorie VALUES (22, 1);
INSERT INTO club_categorie VALUES (23, 2);
INSERT INTO club_categorie VALUES (23, 4);
INSERT INTO club_categorie VALUES (24, 1);
INSERT INTO club_categorie VALUES (24, 9);
INSERT INTO club_categorie VALUES (25, 1);
INSERT INTO club_categorie VALUES (26, 1);
INSERT INTO club_categorie VALUES (27, 1);
INSERT INTO club_categorie VALUES (28, 1);
INSERT INTO club_categorie VALUES (28, 5);
INSERT INTO club_categorie VALUES (29, 1);
INSERT INTO club_categorie VALUES (30, 1);
INSERT INTO club_categorie VALUES (30, 3);
INSERT INTO club_categorie VALUES (31, 1);
INSERT INTO club_categorie VALUES (31, 5);
INSERT INTO club_categorie VALUES (32, 1);
INSERT INTO club_categorie VALUES (33, 1);
INSERT INTO club_categorie VALUES (34, 1);
INSERT INTO club_categorie VALUES (35, 1);
INSERT INTO club_categorie VALUES (35, 5);
INSERT INTO club_categorie VALUES (36, 1);
INSERT INTO club_categorie VALUES (37, 2);
INSERT INTO club_categorie VALUES (38, 2);
INSERT INTO club_categorie VALUES (38, 7);
INSERT INTO club_categorie VALUES (39, 2);
INSERT INTO club_categorie VALUES (40, 2);
INSERT INTO club_categorie VALUES (41, 2);
INSERT INTO club_categorie VALUES (42, 2);
INSERT INTO club_categorie VALUES (43, 2);
INSERT INTO club_categorie VALUES (44, 2);
INSERT INTO club_categorie VALUES (44, 5);
INSERT INTO club_categorie VALUES (45, 2);
INSERT INTO club_categorie VALUES (46, 2);
INSERT INTO club_categorie VALUES (46, 7);
INSERT INTO club_categorie VALUES (47, 2);
INSERT INTO club_categorie VALUES (48, 1);
INSERT INTO club_categorie VALUES (48, 9);
INSERT INTO club_categorie VALUES (49, 2);
INSERT INTO club_categorie VALUES (50, 11);
INSERT INTO club_categorie VALUES (50, 3);

-- club_regroupement
INSERT INTO club_regroupement VALUES (2, 4);
INSERT INTO club_regroupement VALUES (3, 2);
INSERT INTO club_regroupement VALUES (4, 1);
INSERT INTO club_regroupement VALUES (5, 4);
INSERT INTO club_regroupement VALUES (6, 2);
INSERT INTO club_regroupement VALUES (8, 4);
INSERT INTO club_regroupement VALUES (11, 2);
INSERT INTO club_regroupement VALUES (16, 2);
INSERT INTO club_regroupement VALUES (24, 4);
INSERT INTO club_regroupement VALUES (25, 2);
INSERT INTO club_regroupement VALUES (26, 3);
INSERT INTO club_regroupement VALUES (27, 3);
INSERT INTO club_regroupement VALUES (36, 4);
INSERT INTO club_regroupement VALUES (38, 3);
INSERT INTO club_regroupement VALUES (41, 3);
INSERT INTO club_regroupement VALUES (43, 4);
INSERT INTO club_regroupement VALUES (46, 3);
INSERT INTO club_regroupement VALUES (49, 2);
INSERT INTO club_regroupement VALUES (50, 2);

-- club_restauration
INSERT INTO club_restauration VALUES (1, 6);
INSERT INTO club_restauration VALUES (2, 46);
INSERT INTO club_restauration VALUES (3, 29);
INSERT INTO club_restauration VALUES (3, 9);
INSERT INTO club_restauration VALUES (4, 2);
INSERT INTO club_restauration VALUES (5, 46);
INSERT INTO club_restauration VALUES (6, 29);
INSERT INTO club_restauration VALUES (6, 31);
INSERT INTO club_restauration VALUES (7, 39);
INSERT INTO club_restauration VALUES (7, 37);
INSERT INTO club_restauration VALUES (8, 8);
INSERT INTO club_restauration VALUES (9, 26);
INSERT INTO club_restauration VALUES (10, 30);
INSERT INTO club_restauration VALUES (11, 30);
INSERT INTO club_restauration VALUES (11, 4);
INSERT INTO club_restauration VALUES (12, 21);
INSERT INTO club_restauration VALUES (12, 30);
INSERT INTO club_restauration VALUES (13, 4);
INSERT INTO club_restauration VALUES (13, 2);
INSERT INTO club_restauration VALUES (14, 9);
INSERT INTO club_restauration VALUES (14, 40);
INSERT INTO club_restauration VALUES (15, 28);
INSERT INTO club_restauration VALUES (15, 45);
INSERT INTO club_restauration VALUES (16, 49);
INSERT INTO club_restauration VALUES (17, 36);
INSERT INTO club_restauration VALUES (17, 31);
INSERT INTO club_restauration VALUES (18, 40);
INSERT INTO club_restauration VALUES (19, 28);
INSERT INTO club_restauration VALUES (20, 30);
INSERT INTO club_restauration VALUES (20, 2);
INSERT INTO club_restauration VALUES (21, 37);
INSERT INTO club_restauration VALUES (21, 29);
INSERT INTO club_restauration VALUES (22, 30);
INSERT INTO club_restauration VALUES (23, 50);
INSERT INTO club_restauration VALUES (23, 49);
INSERT INTO club_restauration VALUES (24, 8);
INSERT INTO club_restauration VALUES (24, 44);
INSERT INTO club_restauration VALUES (25, 30);
INSERT INTO club_restauration VALUES (26, 20);
INSERT INTO club_restauration VALUES (27, 34);
INSERT INTO club_restauration VALUES (27, 2);
INSERT INTO club_restauration VALUES (28, 43);
INSERT INTO club_restauration VALUES (28, 34);
INSERT INTO club_restauration VALUES (29, 36);
INSERT INTO club_restauration VALUES (29, 40);
INSERT INTO club_restauration VALUES (30, 2);
INSERT INTO club_restauration VALUES (30, 35);
INSERT INTO club_restauration VALUES (31, 34);
INSERT INTO club_restauration VALUES (31, 6);
INSERT INTO club_restauration VALUES (32, 5);
INSERT INTO club_restauration VALUES (33, 27);
INSERT INTO club_restauration VALUES (33, 44);
INSERT INTO club_restauration VALUES (34, 10);
INSERT INTO club_restauration VALUES (34, 37);
INSERT INTO club_restauration VALUES (35, 33);
INSERT INTO club_restauration VALUES (35, 22);
INSERT INTO club_restauration VALUES (36, 24);
INSERT INTO club_restauration VALUES (36, 5);
INSERT INTO club_restauration VALUES (37, 46);
INSERT INTO club_restauration VALUES (37, 29);
INSERT INTO club_restauration VALUES (38, 34);
INSERT INTO club_restauration VALUES (39, 26);
INSERT INTO club_restauration VALUES (40, 7);
INSERT INTO club_restauration VALUES (40, 10);
INSERT INTO club_restauration VALUES (41, 49);
INSERT INTO club_restauration VALUES (42, 24);
INSERT INTO club_restauration VALUES (43, 39);
INSERT INTO club_restauration VALUES (44, 10);
INSERT INTO club_restauration VALUES (44, 32);
INSERT INTO club_restauration VALUES (45, 8);
INSERT INTO club_restauration VALUES (45, 49);
INSERT INTO club_restauration VALUES (46, 6);
INSERT INTO club_restauration VALUES (46, 28);
INSERT INTO club_restauration VALUES (47, 49);
INSERT INTO club_restauration VALUES (48, 5);
INSERT INTO club_restauration VALUES (48, 6);
INSERT INTO club_restauration VALUES (49, 38);
INSERT INTO club_restauration VALUES (49, 3);
INSERT INTO club_restauration VALUES (50, 35);
INSERT INTO club_restauration VALUES (50, 2);

-- categorie_localisation
INSERT INTO categorie_localisation VALUES (1, 1);
INSERT INTO categorie_localisation VALUES (1, 2);
INSERT INTO categorie_localisation VALUES (1, 7);
INSERT INTO categorie_localisation VALUES (1, 8);
INSERT INTO categorie_localisation VALUES (1, 6);
INSERT INTO categorie_localisation VALUES (2, 1);
INSERT INTO categorie_localisation VALUES (2, 3);
INSERT INTO categorie_localisation VALUES (2, 4);
INSERT INTO categorie_localisation VALUES (2, 5);
INSERT INTO categorie_localisation VALUES (2, 6);
INSERT INTO categorie_localisation VALUES (2, 7);
INSERT INTO categorie_localisation VALUES (2, 8);
INSERT INTO categorie_localisation VALUES (3, 1);
INSERT INTO categorie_localisation VALUES (3, 2);
INSERT INTO categorie_localisation VALUES (3, 3);
INSERT INTO categorie_localisation VALUES (3, 4);
INSERT INTO categorie_localisation VALUES (3, 5);
INSERT INTO categorie_localisation VALUES (3, 6);
INSERT INTO categorie_localisation VALUES (3, 7);
INSERT INTO categorie_localisation VALUES (3, 8);
INSERT INTO categorie_localisation VALUES (4, 1);
INSERT INTO categorie_localisation VALUES (4, 2);
INSERT INTO categorie_localisation VALUES (4, 3);
INSERT INTO categorie_localisation VALUES (4, 4);
INSERT INTO categorie_localisation VALUES (4, 5);
INSERT INTO categorie_localisation VALUES (4, 6);
INSERT INTO categorie_localisation VALUES (4, 7);
INSERT INTO categorie_localisation VALUES (4, 8);
INSERT INTO categorie_localisation VALUES (5, 1);
INSERT INTO categorie_localisation VALUES (5, 2);
INSERT INTO categorie_localisation VALUES (5, 3);
INSERT INTO categorie_localisation VALUES (5, 4);
INSERT INTO categorie_localisation VALUES (5, 5);
INSERT INTO categorie_localisation VALUES (5, 6);
INSERT INTO categorie_localisation VALUES (5, 7);
INSERT INTO categorie_localisation VALUES (5, 8);
INSERT INTO categorie_localisation VALUES (6, 1);
INSERT INTO categorie_localisation VALUES (6, 2);
INSERT INTO categorie_localisation VALUES (6, 3);
INSERT INTO categorie_localisation VALUES (6, 4);
INSERT INTO categorie_localisation VALUES (6, 5);
INSERT INTO categorie_localisation VALUES (6, 6);
INSERT INTO categorie_localisation VALUES (6, 7);
INSERT INTO categorie_localisation VALUES (6, 8);
INSERT INTO categorie_localisation VALUES (7, 1);
INSERT INTO categorie_localisation VALUES (7, 2);
INSERT INTO categorie_localisation VALUES (7, 3);
INSERT INTO categorie_localisation VALUES (7, 4);
INSERT INTO categorie_localisation VALUES (7, 5);
INSERT INTO categorie_localisation VALUES (7, 6);
INSERT INTO categorie_localisation VALUES (7, 7);
INSERT INTO categorie_localisation VALUES (7, 8);
INSERT INTO categorie_localisation VALUES (8, 1);
INSERT INTO categorie_localisation VALUES (8, 2);
INSERT INTO categorie_localisation VALUES (8, 3);
INSERT INTO categorie_localisation VALUES (8, 4);
INSERT INTO categorie_localisation VALUES (8, 5);
INSERT INTO categorie_localisation VALUES (8, 6);
INSERT INTO categorie_localisation VALUES (8, 7);
INSERT INTO categorie_localisation VALUES (8, 8);
INSERT INTO categorie_localisation VALUES (9, 1);
INSERT INTO categorie_localisation VALUES (9, 2);
INSERT INTO categorie_localisation VALUES (9, 7);
INSERT INTO categorie_localisation VALUES (9, 8);
INSERT INTO categorie_localisation VALUES (10, 1);
INSERT INTO categorie_localisation VALUES (10, 2);
INSERT INTO categorie_localisation VALUES (10, 3);
INSERT INTO categorie_localisation VALUES (10, 4);
INSERT INTO categorie_localisation VALUES (10, 5);
INSERT INTO categorie_localisation VALUES (10, 6);
INSERT INTO categorie_localisation VALUES (10, 7);
INSERT INTO categorie_localisation VALUES (10, 8);
INSERT INTO categorie_localisation VALUES (11, 1);
INSERT INTO categorie_localisation VALUES (11, 7);
INSERT INTO categorie_localisation VALUES (11, 8);
INSERT INTO categorie_localisation VALUES (12, 3);
INSERT INTO categorie_localisation VALUES (12, 4);
INSERT INTO categorie_localisation VALUES (12, 5);
INSERT INTO categorie_localisation VALUES (12, 6);
INSERT INTO categorie_localisation VALUES (12, 8);

-- disponibilite (Dépend de calendrier, chambre, club)

-- photo_club

-- photoavis

-- prix_periode
INSERT INTO prix_periode VALUES ('HIVER_25', 1, 335);
INSERT INTO prix_periode VALUES ('PRINT_26', 1, 484);
INSERT INTO prix_periode VALUES ('ETE_26', 1, 484);
INSERT INTO prix_periode VALUES ('AUT_26', 1, 335);
INSERT INTO prix_periode VALUES ('HIVER_25', 2, 336);
INSERT INTO prix_periode VALUES ('PRINT_26', 2, 280);
INSERT INTO prix_periode VALUES ('ETE_26', 2, 350);
INSERT INTO prix_periode VALUES ('AUT_26', 2, 280);
INSERT INTO prix_periode VALUES ('HIVER_25', 3, 499);
INSERT INTO prix_periode VALUES ('PRINT_26', 3, 333);
INSERT INTO prix_periode VALUES ('ETE_26', 3, 266);
INSERT INTO prix_periode VALUES ('AUT_26', 3, 333);
INSERT INTO prix_periode VALUES ('HIVER_25', 4, 303);
INSERT INTO prix_periode VALUES ('PRINT_26', 4, 379);
INSERT INTO prix_periode VALUES ('ETE_26', 4, 379);
INSERT INTO prix_periode VALUES ('AUT_26', 4, 262);
INSERT INTO prix_periode VALUES ('HIVER_25', 5, 597);
INSERT INTO prix_periode VALUES ('PRINT_26', 5, 398);
INSERT INTO prix_periode VALUES ('ETE_26', 5, 318);
INSERT INTO prix_periode VALUES ('AUT_26', 5, 398);
INSERT INTO prix_periode VALUES ('HIVER_25', 6, 922);
INSERT INTO prix_periode VALUES ('PRINT_26', 6, 615);
INSERT INTO prix_periode VALUES ('ETE_26', 6, 492);
INSERT INTO prix_periode VALUES ('AUT_26', 6, 615);
INSERT INTO prix_periode VALUES ('HIVER_25', 7, 1072);
INSERT INTO prix_periode VALUES ('PRINT_26', 7, 715);
INSERT INTO prix_periode VALUES ('ETE_26', 7, 572);
INSERT INTO prix_periode VALUES ('AUT_26', 7, 715);
INSERT INTO prix_periode VALUES ('HIVER_25', 8, 452);
INSERT INTO prix_periode VALUES ('PRINT_26', 8, 565);
INSERT INTO prix_periode VALUES ('ETE_26', 8, 565);
INSERT INTO prix_periode VALUES ('AUT_26', 8, 391);
INSERT INTO prix_periode VALUES ('HIVER_25', 9, 390);
INSERT INTO prix_periode VALUES ('PRINT_26', 9, 487);
INSERT INTO prix_periode VALUES ('ETE_26', 9, 487);
INSERT INTO prix_periode VALUES ('AUT_26', 9, 337);
INSERT INTO prix_periode VALUES ('HIVER_25', 10, 477);
INSERT INTO prix_periode VALUES ('PRINT_26', 10, 318);
INSERT INTO prix_periode VALUES ('ETE_26', 10, 254);
INSERT INTO prix_periode VALUES ('AUT_26', 10, 318);
INSERT INTO prix_periode VALUES ('HIVER_25', 11, 280);
INSERT INTO prix_periode VALUES ('PRINT_26', 11, 405);
INSERT INTO prix_periode VALUES ('ETE_26', 11, 405);
INSERT INTO prix_periode VALUES ('AUT_26', 11, 280);
INSERT INTO prix_periode VALUES ('HIVER_25', 12, 1200);
INSERT INTO prix_periode VALUES ('PRINT_26', 12, 800);
INSERT INTO prix_periode VALUES ('ETE_26', 12, 640);
INSERT INTO prix_periode VALUES ('AUT_26', 12, 800);
INSERT INTO prix_periode VALUES ('HIVER_25', 13, 903);
INSERT INTO prix_periode VALUES ('PRINT_26', 13, 1128);
INSERT INTO prix_periode VALUES ('ETE_26', 13, 1128);
INSERT INTO prix_periode VALUES ('AUT_26', 13, 781);
INSERT INTO prix_periode VALUES ('HIVER_25', 14, 256);
INSERT INTO prix_periode VALUES ('PRINT_26', 14, 320);
INSERT INTO prix_periode VALUES ('ETE_26', 14, 320);
INSERT INTO prix_periode VALUES ('AUT_26', 14, 221);
INSERT INTO prix_periode VALUES ('HIVER_25', 15, 609);
INSERT INTO prix_periode VALUES ('PRINT_26', 15, 761);
INSERT INTO prix_periode VALUES ('ETE_26', 15, 761);
INSERT INTO prix_periode VALUES ('AUT_26', 15, 526);
INSERT INTO prix_periode VALUES ('HIVER_25', 16, 747);
INSERT INTO prix_periode VALUES ('PRINT_26', 16, 498);
INSERT INTO prix_periode VALUES ('ETE_26', 16, 398);
INSERT INTO prix_periode VALUES ('AUT_26', 16, 498);
INSERT INTO prix_periode VALUES ('HIVER_25', 17, 477);
INSERT INTO prix_periode VALUES ('PRINT_26', 17, 318);
INSERT INTO prix_periode VALUES ('ETE_26', 17, 254);
INSERT INTO prix_periode VALUES ('AUT_26', 17, 318);
INSERT INTO prix_periode VALUES ('HIVER_25', 18, 237);
INSERT INTO prix_periode VALUES ('PRINT_26', 18, 197);
INSERT INTO prix_periode VALUES ('ETE_26', 18, 247);
INSERT INTO prix_periode VALUES ('AUT_26', 18, 197);
INSERT INTO prix_periode VALUES ('HIVER_25', 19, 730);
INSERT INTO prix_periode VALUES ('PRINT_26', 19, 609);
INSERT INTO prix_periode VALUES ('ETE_26', 19, 761);
INSERT INTO prix_periode VALUES ('AUT_26', 19, 609);
INSERT INTO prix_periode VALUES ('HIVER_25', 20, 276);
INSERT INTO prix_periode VALUES ('PRINT_26', 20, 398);
INSERT INTO prix_periode VALUES ('ETE_26', 20, 398);
INSERT INTO prix_periode VALUES ('AUT_26', 20, 276);
INSERT INTO prix_periode VALUES ('HIVER_25', 21, 622);
INSERT INTO prix_periode VALUES ('PRINT_26', 21, 519);
INSERT INTO prix_periode VALUES ('ETE_26', 21, 648);
INSERT INTO prix_periode VALUES ('AUT_26', 21, 519);
INSERT INTO prix_periode VALUES ('HIVER_25', 22, 603);
INSERT INTO prix_periode VALUES ('PRINT_26', 22, 753);
INSERT INTO prix_periode VALUES ('ETE_26', 22, 753);
INSERT INTO prix_periode VALUES ('AUT_26', 22, 521);
INSERT INTO prix_periode VALUES ('HIVER_25', 23, 222);
INSERT INTO prix_periode VALUES ('PRINT_26', 23, 277);
INSERT INTO prix_periode VALUES ('ETE_26', 23, 277);
INSERT INTO prix_periode VALUES ('AUT_26', 23, 191);
INSERT INTO prix_periode VALUES ('HIVER_25', 24, 757);
INSERT INTO prix_periode VALUES ('PRINT_26', 24, 946);
INSERT INTO prix_periode VALUES ('ETE_26', 24, 946);
INSERT INTO prix_periode VALUES ('AUT_26', 24, 655);
INSERT INTO prix_periode VALUES ('HIVER_25', 25, 474);
INSERT INTO prix_periode VALUES ('PRINT_26', 25, 316);
INSERT INTO prix_periode VALUES ('ETE_26', 25, 252);
INSERT INTO prix_periode VALUES ('AUT_26', 25, 316);
INSERT INTO prix_periode VALUES ('HIVER_25', 26, 172);
INSERT INTO prix_periode VALUES ('PRINT_26', 26, 216);
INSERT INTO prix_periode VALUES ('ETE_26', 26, 216);
INSERT INTO prix_periode VALUES ('AUT_26', 26, 149);
INSERT INTO prix_periode VALUES ('HIVER_25', 27, 490);
INSERT INTO prix_periode VALUES ('PRINT_26', 27, 409);
INSERT INTO prix_periode VALUES ('ETE_26', 27, 511);
INSERT INTO prix_periode VALUES ('AUT_26', 27, 409);
INSERT INTO prix_periode VALUES ('HIVER_25', 30, 471);
INSERT INTO prix_periode VALUES ('PRINT_26', 30, 314);
INSERT INTO prix_periode VALUES ('ETE_26', 30, 251);
INSERT INTO prix_periode VALUES ('AUT_26', 30, 314);
INSERT INTO prix_periode VALUES ('HIVER_25', 31, 237);
INSERT INTO prix_periode VALUES ('PRINT_26', 31, 158);
INSERT INTO prix_periode VALUES ('ETE_26', 31, 126);
INSERT INTO prix_periode VALUES ('AUT_26', 31, 158);
INSERT INTO prix_periode VALUES ('HIVER_25', 32, 232);
INSERT INTO prix_periode VALUES ('PRINT_26', 32, 290);
INSERT INTO prix_periode VALUES ('ETE_26', 32, 290);
INSERT INTO prix_periode VALUES ('AUT_26', 32, 200);
INSERT INTO prix_periode VALUES ('HIVER_25', 33, 402);
INSERT INTO prix_periode VALUES ('PRINT_26', 33, 502);
INSERT INTO prix_periode VALUES ('ETE_26', 33, 502);
INSERT INTO prix_periode VALUES ('AUT_26', 33, 348);
INSERT INTO prix_periode VALUES ('HIVER_25', 34, 1075);
INSERT INTO prix_periode VALUES ('PRINT_26', 34, 717);
INSERT INTO prix_periode VALUES ('ETE_26', 34, 573);
INSERT INTO prix_periode VALUES ('AUT_26', 34, 717);
INSERT INTO prix_periode VALUES ('HIVER_25', 35, 664);
INSERT INTO prix_periode VALUES ('PRINT_26', 35, 830);
INSERT INTO prix_periode VALUES ('ETE_26', 35, 830);
INSERT INTO prix_periode VALUES ('AUT_26', 35, 574);
INSERT INTO prix_periode VALUES ('HIVER_25', 36, 1098);
INSERT INTO prix_periode VALUES ('PRINT_26', 36, 732);
INSERT INTO prix_periode VALUES ('ETE_26', 36, 585);
INSERT INTO prix_periode VALUES ('AUT_26', 36, 732);
INSERT INTO prix_periode VALUES ('HIVER_25', 37, 1056);
INSERT INTO prix_periode VALUES ('PRINT_26', 37, 704);
INSERT INTO prix_periode VALUES ('ETE_26', 37, 563);
INSERT INTO prix_periode VALUES ('AUT_26', 37, 704);
INSERT INTO prix_periode VALUES ('HIVER_25', 38, 288);
INSERT INTO prix_periode VALUES ('PRINT_26', 38, 360);
INSERT INTO prix_periode VALUES ('ETE_26', 38, 360);
INSERT INTO prix_periode VALUES ('AUT_26', 38, 249);
INSERT INTO prix_periode VALUES ('HIVER_25', 39, 420);
INSERT INTO prix_periode VALUES ('PRINT_26', 39, 525);
INSERT INTO prix_periode VALUES ('ETE_26', 39, 525);
INSERT INTO prix_periode VALUES ('AUT_26', 39, 363);
INSERT INTO prix_periode VALUES ('HIVER_25', 40, 396);
INSERT INTO prix_periode VALUES ('PRINT_26', 40, 495);
INSERT INTO prix_periode VALUES ('ETE_26', 40, 495);
INSERT INTO prix_periode VALUES ('AUT_26', 40, 342);
INSERT INTO prix_periode VALUES ('HIVER_25', 41, 1000);
INSERT INTO prix_periode VALUES ('PRINT_26', 41, 667);
INSERT INTO prix_periode VALUES ('ETE_26', 41, 533);
INSERT INTO prix_periode VALUES ('AUT_26', 41, 667);
INSERT INTO prix_periode VALUES ('HIVER_25', 42, 609);
INSERT INTO prix_periode VALUES ('PRINT_26', 42, 406);
INSERT INTO prix_periode VALUES ('ETE_26', 42, 324);
INSERT INTO prix_periode VALUES ('AUT_26', 42, 406);
INSERT INTO prix_periode VALUES ('HIVER_25', 43, 622);
INSERT INTO prix_periode VALUES ('PRINT_26', 43, 415);
INSERT INTO prix_periode VALUES ('ETE_26', 43, 332);
INSERT INTO prix_periode VALUES ('AUT_26', 43, 415);
INSERT INTO prix_periode VALUES ('HIVER_25', 44, 469);
INSERT INTO prix_periode VALUES ('PRINT_26', 44, 313);
INSERT INTO prix_periode VALUES ('ETE_26', 44, 250);
INSERT INTO prix_periode VALUES ('AUT_26', 44, 313);
INSERT INTO prix_periode VALUES ('HIVER_25', 45, 630);
INSERT INTO prix_periode VALUES ('PRINT_26', 45, 420);
INSERT INTO prix_periode VALUES ('ETE_26', 45, 336);
INSERT INTO prix_periode VALUES ('AUT_26', 45, 420);
INSERT INTO prix_periode VALUES ('HIVER_25', 46, 258);
INSERT INTO prix_periode VALUES ('PRINT_26', 46, 172);
INSERT INTO prix_periode VALUES ('ETE_26', 46, 137);
INSERT INTO prix_periode VALUES ('AUT_26', 46, 172);
INSERT INTO prix_periode VALUES ('HIVER_25', 47, 609);
INSERT INTO prix_periode VALUES ('PRINT_26', 47, 406);
INSERT INTO prix_periode VALUES ('ETE_26', 47, 324);
INSERT INTO prix_periode VALUES ('AUT_26', 47, 406);
INSERT INTO prix_periode VALUES ('HIVER_25', 48, 237);
INSERT INTO prix_periode VALUES ('PRINT_26', 48, 297);
INSERT INTO prix_periode VALUES ('ETE_26', 48, 297);
INSERT INTO prix_periode VALUES ('AUT_26', 48, 205);
INSERT INTO prix_periode VALUES ('HIVER_25', 49, 1071);
INSERT INTO prix_periode VALUES ('PRINT_26', 49, 714);
INSERT INTO prix_periode VALUES ('ETE_26', 49, 571);
INSERT INTO prix_periode VALUES ('AUT_26', 49, 714);
INSERT INTO prix_periode VALUES ('HIVER_25', 50, 465);
INSERT INTO prix_periode VALUES ('PRINT_26', 50, 310);
INSERT INTO prix_periode VALUES ('ETE_26', 50, 248);
INSERT INTO prix_periode VALUES ('AUT_26', 50, 310);
INSERT INTO prix_periode VALUES ('HIVER_25', 51, 999);
INSERT INTO prix_periode VALUES ('PRINT_26', 51, 666);
INSERT INTO prix_periode VALUES ('ETE_26', 51, 532);
INSERT INTO prix_periode VALUES ('AUT_26', 51, 666);
INSERT INTO prix_periode VALUES ('HIVER_25', 52, 990);
INSERT INTO prix_periode VALUES ('PRINT_26', 52, 660);
INSERT INTO prix_periode VALUES ('ETE_26', 52, 528);
INSERT INTO prix_periode VALUES ('AUT_26', 52, 660);
INSERT INTO prix_periode VALUES ('HIVER_25', 53, 396);
INSERT INTO prix_periode VALUES ('PRINT_26', 53, 495);
INSERT INTO prix_periode VALUES ('ETE_26', 53, 495);
INSERT INTO prix_periode VALUES ('AUT_26', 53, 342);
INSERT INTO prix_periode VALUES ('HIVER_25', 54, 439);
INSERT INTO prix_periode VALUES ('PRINT_26', 54, 366);
INSERT INTO prix_periode VALUES ('ETE_26', 54, 458);
INSERT INTO prix_periode VALUES ('AUT_26', 54, 366);
INSERT INTO prix_periode VALUES ('HIVER_25', 55, 334);
INSERT INTO prix_periode VALUES ('PRINT_26', 55, 418);
INSERT INTO prix_periode VALUES ('ETE_26', 55, 418);
INSERT INTO prix_periode VALUES ('AUT_26', 55, 289);
INSERT INTO prix_periode VALUES ('HIVER_25', 56, 178);
INSERT INTO prix_periode VALUES ('PRINT_26', 56, 223);
INSERT INTO prix_periode VALUES ('ETE_26', 56, 223);
INSERT INTO prix_periode VALUES ('AUT_26', 56, 154);
INSERT INTO prix_periode VALUES ('HIVER_25', 57, 499);
INSERT INTO prix_periode VALUES ('PRINT_26', 57, 333);
INSERT INTO prix_periode VALUES ('ETE_26', 57, 266);
INSERT INTO prix_periode VALUES ('AUT_26', 57, 333);
INSERT INTO prix_periode VALUES ('HIVER_25', 58, 237);
INSERT INTO prix_periode VALUES ('PRINT_26', 58, 297);
INSERT INTO prix_periode VALUES ('ETE_26', 58, 297);
INSERT INTO prix_periode VALUES ('AUT_26', 58, 205);
INSERT INTO prix_periode VALUES ('HIVER_25', 59, 1078);
INSERT INTO prix_periode VALUES ('PRINT_26', 59, 719);
INSERT INTO prix_periode VALUES ('ETE_26', 59, 575);
INSERT INTO prix_periode VALUES ('AUT_26', 59, 719);
INSERT INTO prix_periode VALUES ('HIVER_25', 60, 273);
INSERT INTO prix_periode VALUES ('PRINT_26', 60, 227);
INSERT INTO prix_periode VALUES ('ETE_26', 60, 284);
INSERT INTO prix_periode VALUES ('AUT_26', 60, 227);
INSERT INTO prix_periode VALUES ('HIVER_25', 61, 232);
INSERT INTO prix_periode VALUES ('PRINT_26', 61, 290);
INSERT INTO prix_periode VALUES ('ETE_26', 61, 290);
INSERT INTO prix_periode VALUES ('AUT_26', 61, 200);
INSERT INTO prix_periode VALUES ('HIVER_25', 62, 234);
INSERT INTO prix_periode VALUES ('PRINT_26', 62, 195);
INSERT INTO prix_periode VALUES ('ETE_26', 62, 243);
INSERT INTO prix_periode VALUES ('AUT_26', 62, 195);
INSERT INTO prix_periode VALUES ('HIVER_25', 63, 663);
INSERT INTO prix_periode VALUES ('PRINT_26', 63, 442);
INSERT INTO prix_periode VALUES ('ETE_26', 63, 353);
INSERT INTO prix_periode VALUES ('AUT_26', 63, 442);
INSERT INTO prix_periode VALUES ('HIVER_25', 64, 219);
INSERT INTO prix_periode VALUES ('PRINT_26', 64, 182);
INSERT INTO prix_periode VALUES ('ETE_26', 64, 228);
INSERT INTO prix_periode VALUES ('AUT_26', 64, 182);
INSERT INTO prix_periode VALUES ('HIVER_25', 65, 403);
INSERT INTO prix_periode VALUES ('PRINT_26', 65, 336);
INSERT INTO prix_periode VALUES ('ETE_26', 65, 420);
INSERT INTO prix_periode VALUES ('AUT_26', 65, 336);
INSERT INTO prix_periode VALUES ('HIVER_25', 66, 174);
INSERT INTO prix_periode VALUES ('PRINT_26', 66, 145);
INSERT INTO prix_periode VALUES ('ETE_26', 66, 181);
INSERT INTO prix_periode VALUES ('AUT_26', 66, 145);
INSERT INTO prix_periode VALUES ('HIVER_25', 67, 307);
INSERT INTO prix_periode VALUES ('PRINT_26', 67, 256);
INSERT INTO prix_periode VALUES ('ETE_26', 67, 320);
INSERT INTO prix_periode VALUES ('AUT_26', 67, 256);
INSERT INTO prix_periode VALUES ('HIVER_25', 68, 642);
INSERT INTO prix_periode VALUES ('PRINT_26', 68, 428);
INSERT INTO prix_periode VALUES ('ETE_26', 68, 342);
INSERT INTO prix_periode VALUES ('AUT_26', 68, 428);
INSERT INTO prix_periode VALUES ('HIVER_25', 69, 1024);
INSERT INTO prix_periode VALUES ('PRINT_26', 69, 683);
INSERT INTO prix_periode VALUES ('ETE_26', 69, 546);
INSERT INTO prix_periode VALUES ('AUT_26', 69, 683);
INSERT INTO prix_periode VALUES ('HIVER_25', 70, 786);
INSERT INTO prix_periode VALUES ('PRINT_26', 70, 524);
INSERT INTO prix_periode VALUES ('ETE_26', 70, 419);
INSERT INTO prix_periode VALUES ('AUT_26', 70, 524);
INSERT INTO prix_periode VALUES ('HIVER_25', 71, 792);
INSERT INTO prix_periode VALUES ('PRINT_26', 71, 528);
INSERT INTO prix_periode VALUES ('ETE_26', 71, 422);
INSERT INTO prix_periode VALUES ('AUT_26', 71, 528);
INSERT INTO prix_periode VALUES ('HIVER_25', 72, 607);
INSERT INTO prix_periode VALUES ('PRINT_26', 72, 405);
INSERT INTO prix_periode VALUES ('ETE_26', 72, 324);
INSERT INTO prix_periode VALUES ('AUT_26', 72, 405);
INSERT INTO prix_periode VALUES ('HIVER_25', 73, 1074);
INSERT INTO prix_periode VALUES ('PRINT_26', 73, 716);
INSERT INTO prix_periode VALUES ('ETE_26', 73, 572);
INSERT INTO prix_periode VALUES ('AUT_26', 73, 716);
INSERT INTO prix_periode VALUES ('HIVER_25', 74, 921);
INSERT INTO prix_periode VALUES ('PRINT_26', 74, 614);
INSERT INTO prix_periode VALUES ('ETE_26', 74, 491);
INSERT INTO prix_periode VALUES ('AUT_26', 74, 614);
INSERT INTO prix_periode VALUES ('HIVER_25', 75, 424);
INSERT INTO prix_periode VALUES ('PRINT_26', 75, 530);
INSERT INTO prix_periode VALUES ('ETE_26', 75, 530);
INSERT INTO prix_periode VALUES ('AUT_26', 75, 367);
INSERT INTO prix_periode VALUES ('HIVER_25', 76, 375);
INSERT INTO prix_periode VALUES ('PRINT_26', 76, 250);
INSERT INTO prix_periode VALUES ('ETE_26', 76, 200);
INSERT INTO prix_periode VALUES ('AUT_26', 76, 250);
INSERT INTO prix_periode VALUES ('HIVER_25', 77, 630);
INSERT INTO prix_periode VALUES ('PRINT_26', 77, 420);
INSERT INTO prix_periode VALUES ('ETE_26', 77, 336);
INSERT INTO prix_periode VALUES ('AUT_26', 77, 420);
INSERT INTO prix_periode VALUES ('HIVER_25', 78, 663);
INSERT INTO prix_periode VALUES ('PRINT_26', 78, 828);
INSERT INTO prix_periode VALUES ('ETE_26', 78, 828);
INSERT INTO prix_periode VALUES ('AUT_26', 78, 573);
INSERT INTO prix_periode VALUES ('HIVER_25', 79, 396);
INSERT INTO prix_periode VALUES ('PRINT_26', 79, 264);
INSERT INTO prix_periode VALUES ('ETE_26', 79, 211);
INSERT INTO prix_periode VALUES ('AUT_26', 79, 264);
INSERT INTO prix_periode VALUES ('HIVER_25', 80, 249);
INSERT INTO prix_periode VALUES ('PRINT_26', 80, 207);
INSERT INTO prix_periode VALUES ('ETE_26', 80, 259);
INSERT INTO prix_periode VALUES ('AUT_26', 80, 207);
INSERT INTO prix_periode VALUES ('HIVER_25', 81, 756);
INSERT INTO prix_periode VALUES ('PRINT_26', 81, 504);
INSERT INTO prix_periode VALUES ('ETE_26', 81, 403);
INSERT INTO prix_periode VALUES ('AUT_26', 81, 504);
INSERT INTO prix_periode VALUES ('HIVER_25', 82, 363);
INSERT INTO prix_periode VALUES ('PRINT_26', 82, 242);
INSERT INTO prix_periode VALUES ('ETE_26', 82, 193);
INSERT INTO prix_periode VALUES ('AUT_26', 82, 242);
INSERT INTO prix_periode VALUES ('HIVER_25', 83, 400);
INSERT INTO prix_periode VALUES ('PRINT_26', 83, 267);
INSERT INTO prix_periode VALUES ('ETE_26', 83, 213);
INSERT INTO prix_periode VALUES ('AUT_26', 83, 267);
INSERT INTO prix_periode VALUES ('HIVER_25', 84, 921);
INSERT INTO prix_periode VALUES ('PRINT_26', 84, 614);
INSERT INTO prix_periode VALUES ('ETE_26', 84, 491);
INSERT INTO prix_periode VALUES ('AUT_26', 84, 614);
INSERT INTO prix_periode VALUES ('HIVER_25', 85, 471);
INSERT INTO prix_periode VALUES ('PRINT_26', 85, 314);
INSERT INTO prix_periode VALUES ('ETE_26', 85, 251);
INSERT INTO prix_periode VALUES ('AUT_26', 85, 314);
INSERT INTO prix_periode VALUES ('HIVER_25', 86, 1056);
INSERT INTO prix_periode VALUES ('PRINT_26', 86, 704);
INSERT INTO prix_periode VALUES ('ETE_26', 86, 563);
INSERT INTO prix_periode VALUES ('AUT_26', 86, 704);
INSERT INTO prix_periode VALUES ('HIVER_25', 87, 607);
INSERT INTO prix_periode VALUES ('PRINT_26', 87, 405);
INSERT INTO prix_periode VALUES ('ETE_26', 87, 324);
INSERT INTO prix_periode VALUES ('AUT_26', 87, 405);
INSERT INTO prix_periode VALUES ('HIVER_25', 88, 774);
INSERT INTO prix_periode VALUES ('PRINT_26', 88, 516);
INSERT INTO prix_periode VALUES ('ETE_26', 88, 412);
INSERT INTO prix_periode VALUES ('AUT_26', 88, 516);
INSERT INTO prix_periode VALUES ('HIVER_25', 89, 439);
INSERT INTO prix_periode VALUES ('PRINT_26', 89, 293);
INSERT INTO prix_periode VALUES ('ETE_26', 89, 234);
INSERT INTO prix_periode VALUES ('AUT_26', 89, 293);
INSERT INTO prix_periode VALUES ('HIVER_25', 90, 786);
INSERT INTO prix_periode VALUES ('PRINT_26', 90, 524);
INSERT INTO prix_periode VALUES ('ETE_26', 90, 419);
INSERT INTO prix_periode VALUES ('AUT_26', 90, 524);
INSERT INTO prix_periode VALUES ('HIVER_25', 91, 703);
INSERT INTO prix_periode VALUES ('PRINT_26', 91, 938);
INSERT INTO prix_periode VALUES ('ETE_26', 91, 938);
INSERT INTO prix_periode VALUES ('AUT_26', 91, 649);
INSERT INTO prix_periode VALUES ('HIVER_25', 92, 452);
INSERT INTO prix_periode VALUES ('PRINT_26', 92, 301);
INSERT INTO prix_periode VALUES ('ETE_26', 92, 241);
INSERT INTO prix_periode VALUES ('AUT_26', 92, 301);
INSERT INTO prix_periode VALUES ('HIVER_25', 93, 222);
INSERT INTO prix_periode VALUES ('PRINT_26', 93, 277);
INSERT INTO prix_periode VALUES ('ETE_26', 93, 277);
INSERT INTO prix_periode VALUES ('AUT_26', 93, 191);
INSERT INTO prix_periode VALUES ('HIVER_25', 94, 159);
INSERT INTO prix_periode VALUES ('PRINT_26', 94, 206);
INSERT INTO prix_periode VALUES ('ETE_26', 94, 206);
INSERT INTO prix_periode VALUES ('AUT_26', 94, 142);
INSERT INTO prix_periode VALUES ('HIVER_25', 95, 345);
INSERT INTO prix_periode VALUES ('PRINT_26', 95, 230);
INSERT INTO prix_periode VALUES ('ETE_26', 95, 184);
INSERT INTO prix_periode VALUES ('AUT_26', 95, 230);
INSERT INTO prix_periode VALUES ('HIVER_25', 96, 609);
INSERT INTO prix_periode VALUES ('PRINT_26', 96, 406);
INSERT INTO prix_periode VALUES ('ETE_26', 96, 324);
INSERT INTO prix_periode VALUES ('AUT_26', 96, 406);
INSERT INTO prix_periode VALUES ('HIVER_25', 97, 1074);
INSERT INTO prix_periode VALUES ('PRINT_26', 97, 716);
INSERT INTO prix_periode VALUES ('ETE_26', 97, 572);
INSERT INTO prix_periode VALUES ('AUT_26', 97, 716);
INSERT INTO prix_periode VALUES ('HIVER_25', 98, 936);
INSERT INTO prix_periode VALUES ('PRINT_26', 98, 624);
INSERT INTO prix_periode VALUES ('ETE_26', 98, 499);
INSERT INTO prix_periode VALUES ('AUT_26', 98, 624);
INSERT INTO prix_periode VALUES ('HIVER_25', 99, 465);
INSERT INTO prix_periode VALUES ('PRINT_26', 99, 310);
INSERT INTO prix_periode VALUES ('ETE_26', 99, 248);
INSERT INTO prix_periode VALUES ('AUT_26', 99, 310);
INSERT INTO prix_periode VALUES ('HIVER_25', 100, 396);
INSERT INTO prix_periode VALUES ('PRINT_26', 100, 264);
INSERT INTO prix_periode VALUES ('ETE_26', 100, 211);
INSERT INTO prix_periode VALUES ('AUT_26', 100, 264);
INSERT INTO prix_periode VALUES ('HIVER_25', 101, 786);
INSERT INTO prix_periode VALUES ('PRINT_26', 101, 524);
INSERT INTO prix_periode VALUES ('ETE_26', 101, 419);
INSERT INTO prix_periode VALUES ('AUT_26', 101, 524);
INSERT INTO prix_periode VALUES ('HIVER_25', 102, 1056);
INSERT INTO prix_periode VALUES ('PRINT_26', 102, 704);
INSERT INTO prix_periode VALUES ('ETE_26', 102, 563);
INSERT INTO prix_periode VALUES ('AUT_26', 102, 704);
INSERT INTO prix_periode VALUES ('HIVER_25', 103, 334);
INSERT INTO prix_periode VALUES ('PRINT_26', 103, 418);
INSERT INTO prix_periode VALUES ('ETE_26', 103, 418);
INSERT INTO prix_periode VALUES ('AUT_26', 103, 289);
INSERT INTO prix_periode VALUES ('HIVER_25', 104, 307);
INSERT INTO prix_periode VALUES ('PRINT_26', 104, 256);
INSERT INTO prix_periode VALUES ('ETE_26', 104, 320);
INSERT INTO prix_periode VALUES ('AUT_26', 104, 256);
INSERT INTO prix_periode VALUES ('HIVER_25', 105, 783);
INSERT INTO prix_periode VALUES ('PRINT_26', 105, 522);
INSERT INTO prix_periode VALUES ('ETE_26', 105, 417);
INSERT INTO prix_periode VALUES ('AUT_26', 105, 522);
INSERT INTO prix_periode VALUES ('HIVER_25', 106, 940);
INSERT INTO prix_periode VALUES ('PRINT_26', 106, 627);
INSERT INTO prix_periode VALUES ('ETE_26', 106, 501);
INSERT INTO prix_periode VALUES ('AUT_26', 106, 627);
INSERT INTO prix_periode VALUES ('HIVER_25', 107, 720);
INSERT INTO prix_periode VALUES ('PRINT_26', 107, 480);
INSERT INTO prix_periode VALUES ('ETE_26', 107, 384);
INSERT INTO prix_periode VALUES ('AUT_26', 107, 480);
INSERT INTO prix_periode VALUES ('HIVER_25', 108, 936);
INSERT INTO prix_periode VALUES ('PRINT_26', 108, 624);
INSERT INTO prix_periode VALUES ('ETE_26', 108, 499);
INSERT INTO prix_periode VALUES ('AUT_26', 108, 624);
INSERT INTO prix_periode VALUES ('HIVER_25', 109, 396);
INSERT INTO prix_periode VALUES ('PRINT_26', 109, 264);
INSERT INTO prix_periode VALUES ('ETE_26', 109, 211);
INSERT INTO prix_periode VALUES ('AUT_26', 109, 264);
INSERT INTO prix_periode VALUES ('HIVER_25', 110, 1074);
INSERT INTO prix_periode VALUES ('PRINT_26', 110, 716);
INSERT INTO prix_periode VALUES ('ETE_26', 110, 572);
INSERT INTO prix_periode VALUES ('AUT_26', 110, 716);
INSERT INTO prix_periode VALUES ('HIVER_25', 111, 469);
INSERT INTO prix_periode VALUES ('PRINT_26', 111, 313);
INSERT INTO prix_periode VALUES ('ETE_26', 111, 250);
INSERT INTO prix_periode VALUES ('AUT_26', 111, 313);
INSERT INTO prix_periode VALUES ('HIVER_25', 112, 1024);
INSERT INTO prix_periode VALUES ('PRINT_26', 112, 683);
INSERT INTO prix_periode VALUES ('ETE_26', 112, 546);
INSERT INTO prix_periode VALUES ('AUT_26', 112, 683);
INSERT INTO prix_periode VALUES ('HIVER_25', 113, 237);
INSERT INTO prix_periode VALUES ('PRINT_26', 113, 297);
INSERT INTO prix_periode VALUES ('ETE_26', 113, 297);
INSERT INTO prix_periode VALUES ('AUT_26', 113, 205);
INSERT INTO prix_periode VALUES ('HIVER_25', 114, 603);
INSERT INTO prix_periode VALUES ('PRINT_26', 114, 753);
INSERT INTO prix_periode VALUES ('ETE_26', 114, 753);
INSERT INTO prix_periode VALUES ('AUT_26', 114, 521);
INSERT INTO prix_periode VALUES ('HIVER_25', 115, 607);
INSERT INTO prix_periode VALUES ('PRINT_26', 115, 405);
INSERT INTO prix_periode VALUES ('ETE_26', 115, 324);
INSERT INTO prix_periode VALUES ('AUT_26', 115, 405);
INSERT INTO prix_periode VALUES ('HIVER_25', 116, 730);
INSERT INTO prix_periode VALUES ('PRINT_26', 116, 609);
INSERT INTO prix_periode VALUES ('ETE_26', 116, 761);
INSERT INTO prix_periode VALUES ('AUT_26', 116, 609);
INSERT INTO prix_periode VALUES ('HIVER_25', 117, 720);
INSERT INTO prix_periode VALUES ('PRINT_26', 117, 480);
INSERT INTO prix_periode VALUES ('ETE_26', 117, 384);
INSERT INTO prix_periode VALUES ('AUT_26', 117, 480);
INSERT INTO prix_periode VALUES ('HIVER_25', 118, 474);
INSERT INTO prix_periode VALUES ('PRINT_26', 118, 316);
INSERT INTO prix_periode VALUES ('ETE_26', 118, 252);
INSERT INTO prix_periode VALUES ('AUT_26', 118, 316);
INSERT INTO prix_periode VALUES ('HIVER_25', 119, 1074);
INSERT INTO prix_periode VALUES ('PRINT_26', 119, 716);
INSERT INTO prix_periode VALUES ('ETE_26', 119, 572);
INSERT INTO prix_periode VALUES ('AUT_26', 119, 716);
INSERT INTO prix_periode VALUES ('HIVER_25', 120, 1072);
INSERT INTO prix_periode VALUES ('PRINT_26', 120, 715);
INSERT INTO prix_periode VALUES ('ETE_26', 120, 572);
INSERT INTO prix_periode VALUES ('AUT_26', 120, 715);
INSERT INTO prix_periode VALUES ('HIVER_25', 121, 237);
INSERT INTO prix_periode VALUES ('PRINT_26', 121, 297);
INSERT INTO prix_periode VALUES ('ETE_26', 121, 297);
INSERT INTO prix_periode VALUES ('AUT_26', 121, 205);
INSERT INTO prix_periode VALUES ('HIVER_25', 122, 603);
INSERT INTO prix_periode VALUES ('PRINT_26', 122, 753);
INSERT INTO prix_periode VALUES ('ETE_26', 122, 753);
INSERT INTO prix_periode VALUES ('AUT_26', 122, 521);
INSERT INTO prix_periode VALUES ('HIVER_25', 123, 1056);
INSERT INTO prix_periode VALUES ('PRINT_26', 123, 704);
INSERT INTO prix_periode VALUES ('ETE_26', 123, 563);
INSERT INTO prix_periode VALUES ('AUT_26', 123, 704);
INSERT INTO prix_periode VALUES ('HIVER_25', 124, 756);
INSERT INTO prix_periode VALUES ('PRINT_26', 124, 504);
INSERT INTO prix_periode VALUES ('ETE_26', 124, 403);
INSERT INTO prix_periode VALUES ('AUT_26', 124, 504);
INSERT INTO prix_periode VALUES ('HIVER_25', 125, 477);
INSERT INTO prix_periode VALUES ('PRINT_26', 125, 318);
INSERT INTO prix_periode VALUES ('ETE_26', 125, 254);
INSERT INTO prix_periode VALUES ('AUT_26', 125, 318);
INSERT INTO prix_periode VALUES ('HIVER_25', 126, 757);
INSERT INTO prix_periode VALUES ('PRINT_26', 126, 946);
INSERT INTO prix_periode VALUES ('ETE_26', 126, 946);
INSERT INTO prix_periode VALUES ('AUT_26', 126, 655);
INSERT INTO prix_periode VALUES ('HIVER_25', 127, 439);
INSERT INTO prix_periode VALUES ('PRINT_26', 127, 293);
INSERT INTO prix_periode VALUES ('ETE_26', 127, 234);
INSERT INTO prix_periode VALUES ('AUT_26', 127, 293);
INSERT INTO prix_periode VALUES ('HIVER_25', 128, 474);
INSERT INTO prix_periode VALUES ('PRINT_26', 128, 316);
INSERT INTO prix_periode VALUES ('ETE_26', 128, 252);
INSERT INTO prix_periode VALUES ('AUT_26', 128, 316);
INSERT INTO prix_periode VALUES ('HIVER_25', 129, 663);
INSERT INTO prix_periode VALUES ('PRINT_26', 129, 442);
INSERT INTO prix_periode VALUES ('ETE_26', 129, 353);
INSERT INTO prix_periode VALUES ('AUT_26', 129, 442);
INSERT INTO prix_periode VALUES ('HIVER_25', 130, 774);
INSERT INTO prix_periode VALUES ('PRINT_26', 130, 516);
INSERT INTO prix_periode VALUES ('ETE_26', 130, 412);
INSERT INTO prix_periode VALUES ('AUT_26', 130, 516);
INSERT INTO prix_periode VALUES ('HIVER_25', 131, 307);
INSERT INTO prix_periode VALUES ('PRINT_26', 131, 256);
INSERT INTO prix_periode VALUES ('ETE_26', 131, 320);
INSERT INTO prix_periode VALUES ('AUT_26', 131, 256);
INSERT INTO prix_periode VALUES ('HIVER_25', 132, 288);
INSERT INTO prix_periode VALUES ('PRINT_26', 132, 360);
INSERT INTO prix_periode VALUES ('ETE_26', 132, 360);
INSERT INTO prix_periode VALUES ('AUT_26', 132, 249);
INSERT INTO prix_periode VALUES ('HIVER_25', 133, 903);
INSERT INTO prix_periode VALUES ('PRINT_26', 133, 1128);
INSERT INTO prix_periode VALUES ('ETE_26', 133, 1128);
INSERT INTO prix_periode VALUES ('AUT_26', 133, 781);
INSERT INTO prix_periode VALUES ('HIVER_25', 134, 1098);
INSERT INTO prix_periode VALUES ('PRINT_26', 134, 732);
INSERT INTO prix_periode VALUES ('ETE_26', 134, 585);
INSERT INTO prix_periode VALUES ('AUT_26', 134, 732);
INSERT INTO prix_periode VALUES ('HIVER_25', 135, 1200);
INSERT INTO prix_periode VALUES ('PRINT_26', 135, 800);
INSERT INTO prix_periode VALUES ('ETE_26', 135, 640);
INSERT INTO prix_periode VALUES ('AUT_26', 135, 800);
INSERT INTO prix_periode VALUES ('HIVER_25', 136, 172);
INSERT INTO prix_periode VALUES ('PRINT_26', 136, 216);
INSERT INTO prix_periode VALUES ('ETE_26', 136, 216);
INSERT INTO prix_periode VALUES ('AUT_26', 136, 149);
INSERT INTO prix_periode VALUES ('HIVER_25', 137, 720);
INSERT INTO prix_periode VALUES ('PRINT_26', 137, 480);
INSERT INTO prix_periode VALUES ('ETE_26', 137, 384);
INSERT INTO prix_periode VALUES ('AUT_26', 137, 480);
INSERT INTO prix_periode VALUES ('HIVER_25', 138, 276);
INSERT INTO prix_periode VALUES ('PRINT_26', 138, 398);
INSERT INTO prix_periode VALUES ('ETE_26', 138, 398);
INSERT INTO prix_periode VALUES ('AUT_26', 138, 276);
INSERT INTO prix_periode VALUES ('HIVER_25', 139, 452);
INSERT INTO prix_periode VALUES ('PRINT_26', 139, 565);
INSERT INTO prix_periode VALUES ('ETE_26', 139, 565);
INSERT INTO prix_periode VALUES ('AUT_26', 139, 391);
INSERT INTO prix_periode VALUES ('HIVER_25', 140, 222);
INSERT INTO prix_periode VALUES ('PRINT_26', 140, 277);
INSERT INTO prix_periode VALUES ('ETE_26', 140, 277);
INSERT INTO prix_periode VALUES ('AUT_26', 140, 191);
INSERT INTO prix_periode VALUES ('HIVER_25', 141, 1071);
INSERT INTO prix_periode VALUES ('PRINT_26', 141, 714);
INSERT INTO prix_periode VALUES ('ETE_26', 141, 571);
INSERT INTO prix_periode VALUES ('AUT_26', 141, 714);
INSERT INTO prix_periode VALUES ('HIVER_25', 142, 622);
INSERT INTO prix_periode VALUES ('PRINT_26', 142, 519);
INSERT INTO prix_periode VALUES ('ETE_26', 142, 648);
INSERT INTO prix_periode VALUES ('AUT_26', 142, 519);
INSERT INTO prix_periode VALUES ('HIVER_25', 143, 622);
INSERT INTO prix_periode VALUES ('PRINT_26', 143, 415);
INSERT INTO prix_periode VALUES ('ETE_26', 143, 332);
INSERT INTO prix_periode VALUES ('AUT_26', 143, 415);
INSERT INTO prix_periode VALUES ('HIVER_25', 144, 999);
INSERT INTO prix_periode VALUES ('PRINT_26', 144, 666);
INSERT INTO prix_periode VALUES ('ETE_26', 144, 532);
INSERT INTO prix_periode VALUES ('AUT_26', 144, 666);
INSERT INTO prix_periode VALUES ('HIVER_25', 145, 178);
INSERT INTO prix_periode VALUES ('PRINT_26', 145, 223);
INSERT INTO prix_periode VALUES ('ETE_26', 145, 223);
INSERT INTO prix_periode VALUES ('AUT_26', 145, 154);
INSERT INTO prix_periode VALUES ('HIVER_25', 146, 256);
INSERT INTO prix_periode VALUES ('PRINT_26', 146, 320);
INSERT INTO prix_periode VALUES ('ETE_26', 146, 320);
INSERT INTO prix_periode VALUES ('AUT_26', 146, 221);
INSERT INTO prix_periode VALUES ('HIVER_25', 147, 499);
INSERT INTO prix_periode VALUES ('PRINT_26', 147, 333);
INSERT INTO prix_periode VALUES ('ETE_26', 147, 266);
INSERT INTO prix_periode VALUES ('AUT_26', 147, 333);
INSERT INTO prix_periode VALUES ('HIVER_25', 148, 630);
INSERT INTO prix_periode VALUES ('PRINT_26', 148, 420);
INSERT INTO prix_periode VALUES ('ETE_26', 148, 336);
INSERT INTO prix_periode VALUES ('AUT_26', 148, 420);
INSERT INTO prix_periode VALUES ('HIVER_25', 149, 159);
INSERT INTO prix_periode VALUES ('PRINT_26', 149, 206);
INSERT INTO prix_periode VALUES ('ETE_26', 149, 206);
INSERT INTO prix_periode VALUES ('AUT_26', 149, 142);
INSERT INTO prix_periode VALUES ('HIVER_25', 150, 420);
INSERT INTO prix_periode VALUES ('PRINT_26', 150, 525);
INSERT INTO prix_periode VALUES ('ETE_26', 150, 525);
INSERT INTO prix_periode VALUES ('AUT_26', 150, 363);
INSERT INTO prix_periode VALUES ('HIVER_25', 151, 609);
INSERT INTO prix_periode VALUES ('PRINT_26', 151, 761);
INSERT INTO prix_periode VALUES ('ETE_26', 151, 761);
INSERT INTO prix_periode VALUES ('AUT_26', 151, 526);
INSERT INTO prix_periode VALUES ('HIVER_25', 152, 936);
INSERT INTO prix_periode VALUES ('PRINT_26', 152, 624);
INSERT INTO prix_periode VALUES ('ETE_26', 152, 499);
INSERT INTO prix_periode VALUES ('AUT_26', 152, 624);
INSERT INTO prix_periode VALUES ('HIVER_25', 153, 642);
INSERT INTO prix_periode VALUES ('PRINT_26', 153, 428);
INSERT INTO prix_periode VALUES ('ETE_26', 153, 342);
INSERT INTO prix_periode VALUES ('AUT_26', 153, 428);
INSERT INTO prix_periode VALUES ('HIVER_25', 154, 783);
INSERT INTO prix_periode VALUES ('PRINT_26', 154, 522);
INSERT INTO prix_periode VALUES ('ETE_26', 154, 417);
INSERT INTO prix_periode VALUES ('AUT_26', 154, 522);
INSERT INTO prix_periode VALUES ('HIVER_25', 155, 335);
INSERT INTO prix_periode VALUES ('PRINT_26', 155, 484);
INSERT INTO prix_periode VALUES ('ETE_26', 155, 484);
INSERT INTO prix_periode VALUES ('AUT_26', 155, 335);
INSERT INTO prix_periode VALUES ('HIVER_25', 156, 390);
INSERT INTO prix_periode VALUES ('PRINT_26', 156, 487);
INSERT INTO prix_periode VALUES ('ETE_26', 156, 487);
INSERT INTO prix_periode VALUES ('AUT_26', 156, 337);
INSERT INTO prix_periode VALUES ('HIVER_25', 157, 490);
INSERT INTO prix_periode VALUES ('PRINT_26', 157, 409);
INSERT INTO prix_periode VALUES ('ETE_26', 157, 511);
INSERT INTO prix_periode VALUES ('AUT_26', 157, 409);
INSERT INTO prix_periode VALUES ('HIVER_25', 158, 222);
INSERT INTO prix_periode VALUES ('PRINT_26', 158, 277);
INSERT INTO prix_periode VALUES ('ETE_26', 158, 277);
INSERT INTO prix_periode VALUES ('AUT_26', 158, 191);

-- reservation_activite
INSERT INTO reservation_activite VALUES (1, 238, (SELECT nbpersonnes FROM reservation WHERE numreservation = 1), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (1, 212, (SELECT nbpersonnes FROM reservation WHERE numreservation = 1), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (4, 346, (SELECT nbpersonnes FROM reservation WHERE numreservation = 4), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (4, 213, (SELECT nbpersonnes FROM reservation WHERE numreservation = 4), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (5, 300, (SELECT nbpersonnes FROM reservation WHERE numreservation = 5), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (6, 303, (SELECT nbpersonnes FROM reservation WHERE numreservation = 6), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (6, 344, (SELECT nbpersonnes FROM reservation WHERE numreservation = 6), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (7, 219, (SELECT nbpersonnes FROM reservation WHERE numreservation = 7), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (7, 29, (SELECT nbpersonnes FROM reservation WHERE numreservation = 7), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (8, 240, (SELECT nbpersonnes FROM reservation WHERE numreservation = 8), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (8, 14, (SELECT nbpersonnes FROM reservation WHERE numreservation = 8), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (10, 329, (SELECT nbpersonnes FROM reservation WHERE numreservation = 10), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (10, 343, (SELECT nbpersonnes FROM reservation WHERE numreservation = 10), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (11, 220, (SELECT nbpersonnes FROM reservation WHERE numreservation = 11), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (11, 306, (SELECT nbpersonnes FROM reservation WHERE numreservation = 11), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (12, 10, (SELECT nbpersonnes FROM reservation WHERE numreservation = 12), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (12, 239, (SELECT nbpersonnes FROM reservation WHERE numreservation = 12), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (13, 229, (SELECT nbpersonnes FROM reservation WHERE numreservation = 13), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (13, 17, (SELECT nbpersonnes FROM reservation WHERE numreservation = 13), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (14, 237, (SELECT nbpersonnes FROM reservation WHERE numreservation = 14), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (14, 230, (SELECT nbpersonnes FROM reservation WHERE numreservation = 14), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (15, 342, (SELECT nbpersonnes FROM reservation WHERE numreservation = 15), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (15, 233, (SELECT nbpersonnes FROM reservation WHERE numreservation = 15), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (16, 226, (SELECT nbpersonnes FROM reservation WHERE numreservation = 16), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (17, 349, (SELECT nbpersonnes FROM reservation WHERE numreservation = 17), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (18, 305, (SELECT nbpersonnes FROM reservation WHERE numreservation = 18), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (19, 236, (SELECT nbpersonnes FROM reservation WHERE numreservation = 19), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (20, 228, (SELECT nbpersonnes FROM reservation WHERE numreservation = 20), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (20, 318, (SELECT nbpersonnes FROM reservation WHERE numreservation = 20), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (21, 225, (SELECT nbpersonnes FROM reservation WHERE numreservation = 21), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (22, 227, (SELECT nbpersonnes FROM reservation WHERE numreservation = 22), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (23, 332, (SELECT nbpersonnes FROM reservation WHERE numreservation = 23), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (24, 232, (SELECT nbpersonnes FROM reservation WHERE numreservation = 24), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (24, 316, (SELECT nbpersonnes FROM reservation WHERE numreservation = 24), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (25, 337, (SELECT nbpersonnes FROM reservation WHERE numreservation = 25), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (25, 203, (SELECT nbpersonnes FROM reservation WHERE numreservation = 25), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (26, 340, (SELECT nbpersonnes FROM reservation WHERE numreservation = 26), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (26, 323, (SELECT nbpersonnes FROM reservation WHERE numreservation = 26), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (27, 246, (SELECT nbpersonnes FROM reservation WHERE numreservation = 27), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (27, 336, (SELECT nbpersonnes FROM reservation WHERE numreservation = 27), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (28, 200, (SELECT nbpersonnes FROM reservation WHERE numreservation = 28), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (28, 223, (SELECT nbpersonnes FROM reservation WHERE numreservation = 28), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (30, 209, (SELECT nbpersonnes FROM reservation WHERE numreservation = 30), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (30, 248, (SELECT nbpersonnes FROM reservation WHERE numreservation = 30), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (32, 210, (SELECT nbpersonnes FROM reservation WHERE numreservation = 32), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (32, 23, (SELECT nbpersonnes FROM reservation WHERE numreservation = 32), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (33, 243, (SELECT nbpersonnes FROM reservation WHERE numreservation = 33), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (34, 11, (SELECT nbpersonnes FROM reservation WHERE numreservation = 34), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (34, 326, (SELECT nbpersonnes FROM reservation WHERE numreservation = 34), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (35, 12, (SELECT nbpersonnes FROM reservation WHERE numreservation = 35), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (35, 339, (SELECT nbpersonnes FROM reservation WHERE numreservation = 35), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (37, 22, (SELECT nbpersonnes FROM reservation WHERE numreservation = 37), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (38, 247, (SELECT nbpersonnes FROM reservation WHERE numreservation = 38), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (38, 328, (SELECT nbpersonnes FROM reservation WHERE numreservation = 38), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (39, 315, (SELECT nbpersonnes FROM reservation WHERE numreservation = 39), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (39, 307, (SELECT nbpersonnes FROM reservation WHERE numreservation = 39), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (40, 241, (SELECT nbpersonnes FROM reservation WHERE numreservation = 40), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (40, 330, (SELECT nbpersonnes FROM reservation WHERE numreservation = 40), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (41, 13, (SELECT nbpersonnes FROM reservation WHERE numreservation = 41), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (42, 313, (SELECT nbpersonnes FROM reservation WHERE numreservation = 42), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (43, 333, (SELECT nbpersonnes FROM reservation WHERE numreservation = 43), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (44, 341, (SELECT nbpersonnes FROM reservation WHERE numreservation = 44), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (44, 15, (SELECT nbpersonnes FROM reservation WHERE numreservation = 44), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (45, 335, (SELECT nbpersonnes FROM reservation WHERE numreservation = 45), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (46, 235, (SELECT nbpersonnes FROM reservation WHERE numreservation = 46), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (47, 348, (SELECT nbpersonnes FROM reservation WHERE numreservation = 47), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (47, 224, (SELECT nbpersonnes FROM reservation WHERE numreservation = 47), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (48, 231, (SELECT nbpersonnes FROM reservation WHERE numreservation = 48), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (48, 304, (SELECT nbpersonnes FROM reservation WHERE numreservation = 48), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (49, 1, (SELECT nbpersonnes FROM reservation WHERE numreservation = 49), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (49, 216, (SELECT nbpersonnes FROM reservation WHERE numreservation = 49), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (50, 345, (SELECT nbpersonnes FROM reservation WHERE numreservation = 50), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (50, 206, (SELECT nbpersonnes FROM reservation WHERE numreservation = 50), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (51, 322, (SELECT nbpersonnes FROM reservation WHERE numreservation = 51), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (51, 334, (SELECT nbpersonnes FROM reservation WHERE numreservation = 51), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (52, 234, (SELECT nbpersonnes FROM reservation WHERE numreservation = 52), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (52, 8, (SELECT nbpersonnes FROM reservation WHERE numreservation = 52), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (53, 301, (SELECT nbpersonnes FROM reservation WHERE numreservation = 53), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (54, 320, (SELECT nbpersonnes FROM reservation WHERE numreservation = 54), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (54, 245, (SELECT nbpersonnes FROM reservation WHERE numreservation = 54), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (55, 321, (SELECT nbpersonnes FROM reservation WHERE numreservation = 55), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (56, 16, (SELECT nbpersonnes FROM reservation WHERE numreservation = 56), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (56, 215, (SELECT nbpersonnes FROM reservation WHERE numreservation = 56), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (58, 218, (SELECT nbpersonnes FROM reservation WHERE numreservation = 58), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (58, 204, (SELECT nbpersonnes FROM reservation WHERE numreservation = 58), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (60, 338, (SELECT nbpersonnes FROM reservation WHERE numreservation = 60), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (60, 202, (SELECT nbpersonnes FROM reservation WHERE numreservation = 60), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (61, 346, (SELECT nbpersonnes FROM reservation WHERE numreservation = 61), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (61, 29, (SELECT nbpersonnes FROM reservation WHERE numreservation = 61), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (62, 311, (SELECT nbpersonnes FROM reservation WHERE numreservation = 62), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (63, 222, (SELECT nbpersonnes FROM reservation WHERE numreservation = 63), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (64, 214, (SELECT nbpersonnes FROM reservation WHERE numreservation = 64), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (64, 208, (SELECT nbpersonnes FROM reservation WHERE numreservation = 64), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (65, 314, (SELECT nbpersonnes FROM reservation WHERE numreservation = 65), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (65, 300, (SELECT nbpersonnes FROM reservation WHERE numreservation = 65), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (67, 310, (SELECT nbpersonnes FROM reservation WHERE numreservation = 67), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (67, 302, (SELECT nbpersonnes FROM reservation WHERE numreservation = 67), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (68, 212, (SELECT nbpersonnes FROM reservation WHERE numreservation = 68), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (68, 347, (SELECT nbpersonnes FROM reservation WHERE numreservation = 68), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (69, 319, (SELECT nbpersonnes FROM reservation WHERE numreservation = 69), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (69, 9, (SELECT nbpersonnes FROM reservation WHERE numreservation = 69), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (70, 217, (SELECT nbpersonnes FROM reservation WHERE numreservation = 70), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (70, 309, (SELECT nbpersonnes FROM reservation WHERE numreservation = 70), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (71, 18, (SELECT nbpersonnes FROM reservation WHERE numreservation = 71), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (71, 325, (SELECT nbpersonnes FROM reservation WHERE numreservation = 71), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (72, 331, (SELECT nbpersonnes FROM reservation WHERE numreservation = 72), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (73, 205, (SELECT nbpersonnes FROM reservation WHERE numreservation = 73), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (73, 327, (SELECT nbpersonnes FROM reservation WHERE numreservation = 73), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (74, 317, (SELECT nbpersonnes FROM reservation WHERE numreservation = 74), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (76, 221, (SELECT nbpersonnes FROM reservation WHERE numreservation = 76), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (76, 3, (SELECT nbpersonnes FROM reservation WHERE numreservation = 76), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (77, 242, (SELECT nbpersonnes FROM reservation WHERE numreservation = 77), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (77, 211, (SELECT nbpersonnes FROM reservation WHERE numreservation = 77), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (78, 249, (SELECT nbpersonnes FROM reservation WHERE numreservation = 78), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (79, 308, (SELECT nbpersonnes FROM reservation WHERE numreservation = 79), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (79, 7, (SELECT nbpersonnes FROM reservation WHERE numreservation = 79), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (80, 201, (SELECT nbpersonnes FROM reservation WHERE numreservation = 80), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (80, 21, (SELECT nbpersonnes FROM reservation WHERE numreservation = 80), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (81, 312, (SELECT nbpersonnes FROM reservation WHERE numreservation = 81), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (82, 323, (SELECT nbpersonnes FROM reservation WHERE numreservation = 82), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (83, 324, (SELECT nbpersonnes FROM reservation WHERE numreservation = 83), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (83, 244, (SELECT nbpersonnes FROM reservation WHERE numreservation = 83), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (84, 207, (SELECT nbpersonnes FROM reservation WHERE numreservation = 84), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (84, 4, (SELECT nbpersonnes FROM reservation WHERE numreservation = 84), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (85, 213, (SELECT nbpersonnes FROM reservation WHERE numreservation = 85), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (86, 5, (SELECT nbpersonnes FROM reservation WHERE numreservation = 86), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (87, 226, (SELECT nbpersonnes FROM reservation WHERE numreservation = 87), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (87, 340, (SELECT nbpersonnes FROM reservation WHERE numreservation = 87), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (88, 302, (SELECT nbpersonnes FROM reservation WHERE numreservation = 88), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (89, 322, (SELECT nbpersonnes FROM reservation WHERE numreservation = 89), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (89, 239, (SELECT nbpersonnes FROM reservation WHERE numreservation = 89), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (90, 310, (SELECT nbpersonnes FROM reservation WHERE numreservation = 90), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (90, 10, (SELECT nbpersonnes FROM reservation WHERE numreservation = 90), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (91, 332, (SELECT nbpersonnes FROM reservation WHERE numreservation = 91), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (91, 23, (SELECT nbpersonnes FROM reservation WHERE numreservation = 91), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (92, 348, (SELECT nbpersonnes FROM reservation WHERE numreservation = 92), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (92, 228, (SELECT nbpersonnes FROM reservation WHERE numreservation = 92), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (93, 329, (SELECT nbpersonnes FROM reservation WHERE numreservation = 93), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (93, 240, (SELECT nbpersonnes FROM reservation WHERE numreservation = 93), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (94, 220, (SELECT nbpersonnes FROM reservation WHERE numreservation = 94), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (94, 320, (SELECT nbpersonnes FROM reservation WHERE numreservation = 94), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (95, 306, (SELECT nbpersonnes FROM reservation WHERE numreservation = 95), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (95, 12, (SELECT nbpersonnes FROM reservation WHERE numreservation = 95), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (96, 22, (SELECT nbpersonnes FROM reservation WHERE numreservation = 96), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (96, 230, (SELECT nbpersonnes FROM reservation WHERE numreservation = 96), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (97, 235, (SELECT nbpersonnes FROM reservation WHERE numreservation = 97), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (98, 209, (SELECT nbpersonnes FROM reservation WHERE numreservation = 98), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (99, 13, (SELECT nbpersonnes FROM reservation WHERE numreservation = 99), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (100, 318, (SELECT nbpersonnes FROM reservation WHERE numreservation = 100), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (100, 219, (SELECT nbpersonnes FROM reservation WHERE numreservation = 100), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (101, 330, (SELECT nbpersonnes FROM reservation WHERE numreservation = 101), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (101, 223, (SELECT nbpersonnes FROM reservation WHERE numreservation = 101), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (102, 1, (SELECT nbpersonnes FROM reservation WHERE numreservation = 102), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (103, 349, (SELECT nbpersonnes FROM reservation WHERE numreservation = 103), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (104, 325, (SELECT nbpersonnes FROM reservation WHERE numreservation = 104), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (104, 246, (SELECT nbpersonnes FROM reservation WHERE numreservation = 104), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (105, 16, (SELECT nbpersonnes FROM reservation WHERE numreservation = 105), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (105, 333, (SELECT nbpersonnes FROM reservation WHERE numreservation = 105), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (106, 200, (SELECT nbpersonnes FROM reservation WHERE numreservation = 106), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (106, 234, (SELECT nbpersonnes FROM reservation WHERE numreservation = 106), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (107, 341, (SELECT nbpersonnes FROM reservation WHERE numreservation = 107), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (107, 225, (SELECT nbpersonnes FROM reservation WHERE numreservation = 107), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (108, 15, (SELECT nbpersonnes FROM reservation WHERE numreservation = 108), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (108, 227, (SELECT nbpersonnes FROM reservation WHERE numreservation = 108), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (109, 335, (SELECT nbpersonnes FROM reservation WHERE numreservation = 109), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (109, 238, (SELECT nbpersonnes FROM reservation WHERE numreservation = 109), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (110, 232, (SELECT nbpersonnes FROM reservation WHERE numreservation = 110), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (110, 339, (SELECT nbpersonnes FROM reservation WHERE numreservation = 110), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (111, 212, (SELECT nbpersonnes FROM reservation WHERE numreservation = 111), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (111, 203, (SELECT nbpersonnes FROM reservation WHERE numreservation = 111), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (112, 345, (SELECT nbpersonnes FROM reservation WHERE numreservation = 112), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (113, 342, (SELECT nbpersonnes FROM reservation WHERE numreservation = 113), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (114, 216, (SELECT nbpersonnes FROM reservation WHERE numreservation = 114), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (114, 241, (SELECT nbpersonnes FROM reservation WHERE numreservation = 114), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (115, 326, (SELECT nbpersonnes FROM reservation WHERE numreservation = 115), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (116, 336, (SELECT nbpersonnes FROM reservation WHERE numreservation = 116), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (116, 224, (SELECT nbpersonnes FROM reservation WHERE numreservation = 116), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (117, 231, (SELECT nbpersonnes FROM reservation WHERE numreservation = 117), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (117, 206, (SELECT nbpersonnes FROM reservation WHERE numreservation = 117), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (118, 304, (SELECT nbpersonnes FROM reservation WHERE numreservation = 118), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (118, 334, (SELECT nbpersonnes FROM reservation WHERE numreservation = 118), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (119, 8, (SELECT nbpersonnes FROM reservation WHERE numreservation = 119), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (119, 218, (SELECT nbpersonnes FROM reservation WHERE numreservation = 119), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (120, 245, (SELECT nbpersonnes FROM reservation WHERE numreservation = 120), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (120, 11, (SELECT nbpersonnes FROM reservation WHERE numreservation = 120), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (121, 215, (SELECT nbpersonnes FROM reservation WHERE numreservation = 121), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (121, 301, (SELECT nbpersonnes FROM reservation WHERE numreservation = 121), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (122, 204, (SELECT nbpersonnes FROM reservation WHERE numreservation = 122), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (123, 233, (SELECT nbpersonnes FROM reservation WHERE numreservation = 123), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (123, 338, (SELECT nbpersonnes FROM reservation WHERE numreservation = 123), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (124, 202, (SELECT nbpersonnes FROM reservation WHERE numreservation = 124), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (124, 313, (SELECT nbpersonnes FROM reservation WHERE numreservation = 124), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (125, 344, (SELECT nbpersonnes FROM reservation WHERE numreservation = 125), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (126, 305, (SELECT nbpersonnes FROM reservation WHERE numreservation = 126), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (127, 29, (SELECT nbpersonnes FROM reservation WHERE numreservation = 127), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (128, 236, (SELECT nbpersonnes FROM reservation WHERE numreservation = 128), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (128, 222, (SELECT nbpersonnes FROM reservation WHERE numreservation = 128), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (129, 237, (SELECT nbpersonnes FROM reservation WHERE numreservation = 129), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (130, 229, (SELECT nbpersonnes FROM reservation WHERE numreservation = 130), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (130, 14, (SELECT nbpersonnes FROM reservation WHERE numreservation = 130), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (132, 243, (SELECT nbpersonnes FROM reservation WHERE numreservation = 132), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (132, 337, (SELECT nbpersonnes FROM reservation WHERE numreservation = 132), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (133, 210, (SELECT nbpersonnes FROM reservation WHERE numreservation = 133), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (133, 247, (SELECT nbpersonnes FROM reservation WHERE numreservation = 133), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (134, 343, (SELECT nbpersonnes FROM reservation WHERE numreservation = 134), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (134, 328, (SELECT nbpersonnes FROM reservation WHERE numreservation = 134), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (135, 17, (SELECT nbpersonnes FROM reservation WHERE numreservation = 135), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (136, 316, (SELECT nbpersonnes FROM reservation WHERE numreservation = 136), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (136, 321, (SELECT nbpersonnes FROM reservation WHERE numreservation = 136), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (137, 214, (SELECT nbpersonnes FROM reservation WHERE numreservation = 137), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (138, 307, (SELECT nbpersonnes FROM reservation WHERE numreservation = 138), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (138, 248, (SELECT nbpersonnes FROM reservation WHERE numreservation = 138), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (139, 315, (SELECT nbpersonnes FROM reservation WHERE numreservation = 139), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (139, 314, (SELECT nbpersonnes FROM reservation WHERE numreservation = 139), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (140, 303, (SELECT nbpersonnes FROM reservation WHERE numreservation = 140), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (140, 311, (SELECT nbpersonnes FROM reservation WHERE numreservation = 140), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (141, 319, (SELECT nbpersonnes FROM reservation WHERE numreservation = 141), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (142, 9, (SELECT nbpersonnes FROM reservation WHERE numreservation = 142), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (142, 208, (SELECT nbpersonnes FROM reservation WHERE numreservation = 142), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (143, 217, (SELECT nbpersonnes FROM reservation WHERE numreservation = 143), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (143, 18, (SELECT nbpersonnes FROM reservation WHERE numreservation = 143), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (144, 309, (SELECT nbpersonnes FROM reservation WHERE numreservation = 144), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (144, 331, (SELECT nbpersonnes FROM reservation WHERE numreservation = 144), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (145, 205, (SELECT nbpersonnes FROM reservation WHERE numreservation = 145), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (146, 327, (SELECT nbpersonnes FROM reservation WHERE numreservation = 146), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (146, 317, (SELECT nbpersonnes FROM reservation WHERE numreservation = 146), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (147, 221, (SELECT nbpersonnes FROM reservation WHERE numreservation = 147), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (148, 3, (SELECT nbpersonnes FROM reservation WHERE numreservation = 148), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (149, 242, (SELECT nbpersonnes FROM reservation WHERE numreservation = 149), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (149, 211, (SELECT nbpersonnes FROM reservation WHERE numreservation = 149), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (150, 249, (SELECT nbpersonnes FROM reservation WHERE numreservation = 150), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (150, 308, (SELECT nbpersonnes FROM reservation WHERE numreservation = 150), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (151, 7, (SELECT nbpersonnes FROM reservation WHERE numreservation = 151), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (152, 201, (SELECT nbpersonnes FROM reservation WHERE numreservation = 152), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (153, 21, (SELECT nbpersonnes FROM reservation WHERE numreservation = 153), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (154, 312, (SELECT nbpersonnes FROM reservation WHERE numreservation = 154), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (154, 323, (SELECT nbpersonnes FROM reservation WHERE numreservation = 154), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (155, 324, (SELECT nbpersonnes FROM reservation WHERE numreservation = 155), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (156, 244, (SELECT nbpersonnes FROM reservation WHERE numreservation = 156), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (157, 207, (SELECT nbpersonnes FROM reservation WHERE numreservation = 157), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (157, 4, (SELECT nbpersonnes FROM reservation WHERE numreservation = 157), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (158, 213, (SELECT nbpersonnes FROM reservation WHERE numreservation = 158), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (159, 5, (SELECT nbpersonnes FROM reservation WHERE numreservation = 159), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (159, 226, (SELECT nbpersonnes FROM reservation WHERE numreservation = 159), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (160, 240, (SELECT nbpersonnes FROM reservation WHERE numreservation = 160), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (160, 302, (SELECT nbpersonnes FROM reservation WHERE numreservation = 160), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (161, 322, (SELECT nbpersonnes FROM reservation WHERE numreservation = 161), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (161, 239, (SELECT nbpersonnes FROM reservation WHERE numreservation = 161), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (162, 310, (SELECT nbpersonnes FROM reservation WHERE numreservation = 162), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (162, 10, (SELECT nbpersonnes FROM reservation WHERE numreservation = 162), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (163, 332, (SELECT nbpersonnes FROM reservation WHERE numreservation = 163), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (163, 23, (SELECT nbpersonnes FROM reservation WHERE numreservation = 163), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (164, 348, (SELECT nbpersonnes FROM reservation WHERE numreservation = 164), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (164, 228, (SELECT nbpersonnes FROM reservation WHERE numreservation = 164), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (165, 329, (SELECT nbpersonnes FROM reservation WHERE numreservation = 165), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (165, 240, (SELECT nbpersonnes FROM reservation WHERE numreservation = 165), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (166, 220, (SELECT nbpersonnes FROM reservation WHERE numreservation = 166), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (166, 320, (SELECT nbpersonnes FROM reservation WHERE numreservation = 166), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (167, 306, (SELECT nbpersonnes FROM reservation WHERE numreservation = 167), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (167, 12, (SELECT nbpersonnes FROM reservation WHERE numreservation = 167), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (168, 22, (SELECT nbpersonnes FROM reservation WHERE numreservation = 168), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (168, 230, (SELECT nbpersonnes FROM reservation WHERE numreservation = 168), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (169, 235, (SELECT nbpersonnes FROM reservation WHERE numreservation = 169), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (170, 209, (SELECT nbpersonnes FROM reservation WHERE numreservation = 170), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (171, 13, (SELECT nbpersonnes FROM reservation WHERE numreservation = 171), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (172, 318, (SELECT nbpersonnes FROM reservation WHERE numreservation = 172), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (172, 219, (SELECT nbpersonnes FROM reservation WHERE numreservation = 172), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (173, 330, (SELECT nbpersonnes FROM reservation WHERE numreservation = 173), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (173, 223, (SELECT nbpersonnes FROM reservation WHERE numreservation = 173), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (174, 1, (SELECT nbpersonnes FROM reservation WHERE numreservation = 174), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (175, 349, (SELECT nbpersonnes FROM reservation WHERE numreservation = 175), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (176, 325, (SELECT nbpersonnes FROM reservation WHERE numreservation = 176), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (176, 246, (SELECT nbpersonnes FROM reservation WHERE numreservation = 176), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (177, 16, (SELECT nbpersonnes FROM reservation WHERE numreservation = 177), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (177, 333, (SELECT nbpersonnes FROM reservation WHERE numreservation = 177), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (178, 200, (SELECT nbpersonnes FROM reservation WHERE numreservation = 178), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (178, 234, (SELECT nbpersonnes FROM reservation WHERE numreservation = 178), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (179, 341, (SELECT nbpersonnes FROM reservation WHERE numreservation = 179), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (179, 225, (SELECT nbpersonnes FROM reservation WHERE numreservation = 179), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (180, 15, (SELECT nbpersonnes FROM reservation WHERE numreservation = 180), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (180, 227, (SELECT nbpersonnes FROM reservation WHERE numreservation = 180), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (181, 335, (SELECT nbpersonnes FROM reservation WHERE numreservation = 181), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (181, 238, (SELECT nbpersonnes FROM reservation WHERE numreservation = 181), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (182, 232, (SELECT nbpersonnes FROM reservation WHERE numreservation = 182), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (182, 339, (SELECT nbpersonnes FROM reservation WHERE numreservation = 182), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (183, 212, (SELECT nbpersonnes FROM reservation WHERE numreservation = 183), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (183, 203, (SELECT nbpersonnes FROM reservation WHERE numreservation = 183), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (184, 345, (SELECT nbpersonnes FROM reservation WHERE numreservation = 184), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (185, 342, (SELECT nbpersonnes FROM reservation WHERE numreservation = 185), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (186, 216, (SELECT nbpersonnes FROM reservation WHERE numreservation = 186), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (186, 241, (SELECT nbpersonnes FROM reservation WHERE numreservation = 186), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (187, 326, (SELECT nbpersonnes FROM reservation WHERE numreservation = 187), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (188, 336, (SELECT nbpersonnes FROM reservation WHERE numreservation = 188), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (188, 224, (SELECT nbpersonnes FROM reservation WHERE numreservation = 188), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (189, 231, (SELECT nbpersonnes FROM reservation WHERE numreservation = 189), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (189, 206, (SELECT nbpersonnes FROM reservation WHERE numreservation = 189), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (190, 304, (SELECT nbpersonnes FROM reservation WHERE numreservation = 190), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (190, 334, (SELECT nbpersonnes FROM reservation WHERE numreservation = 190), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (191, 8, (SELECT nbpersonnes FROM reservation WHERE numreservation = 191), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (191, 218, (SELECT nbpersonnes FROM reservation WHERE numreservation = 191), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (192, 245, (SELECT nbpersonnes FROM reservation WHERE numreservation = 192), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (192, 11, (SELECT nbpersonnes FROM reservation WHERE numreservation = 192), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (193, 215, (SELECT nbpersonnes FROM reservation WHERE numreservation = 193), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (193, 301, (SELECT nbpersonnes FROM reservation WHERE numreservation = 193), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (194, 204, (SELECT nbpersonnes FROM reservation WHERE numreservation = 194), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (195, 233, (SELECT nbpersonnes FROM reservation WHERE numreservation = 195), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (195, 338, (SELECT nbpersonnes FROM reservation WHERE numreservation = 195), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (196, 202, (SELECT nbpersonnes FROM reservation WHERE numreservation = 196), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (196, 313, (SELECT nbpersonnes FROM reservation WHERE numreservation = 196), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (197, 344, (SELECT nbpersonnes FROM reservation WHERE numreservation = 197), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (198, 305, (SELECT nbpersonnes FROM reservation WHERE numreservation = 198), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (199, 29, (SELECT nbpersonnes FROM reservation WHERE numreservation = 199), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (200, 236, (SELECT nbpersonnes FROM reservation WHERE numreservation = 200), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (200, 222, (SELECT nbpersonnes FROM reservation WHERE numreservation = 200), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (201, 237, (SELECT nbpersonnes FROM reservation WHERE numreservation = 201), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (202, 229, (SELECT nbpersonnes FROM reservation WHERE numreservation = 202), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (202, 14, (SELECT nbpersonnes FROM reservation WHERE numreservation = 202), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (204, 243, (SELECT nbpersonnes FROM reservation WHERE numreservation = 204), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (204, 337, (SELECT nbpersonnes FROM reservation WHERE numreservation = 204), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (205, 210, (SELECT nbpersonnes FROM reservation WHERE numreservation = 205), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (205, 247, (SELECT nbpersonnes FROM reservation WHERE numreservation = 205), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (206, 343, (SELECT nbpersonnes FROM reservation WHERE numreservation = 206), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (206, 328, (SELECT nbpersonnes FROM reservation WHERE numreservation = 206), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (207, 17, (SELECT nbpersonnes FROM reservation WHERE numreservation = 207), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (208, 316, (SELECT nbpersonnes FROM reservation WHERE numreservation = 208), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (208, 321, (SELECT nbpersonnes FROM reservation WHERE numreservation = 208), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (209, 214, (SELECT nbpersonnes FROM reservation WHERE numreservation = 209), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (210, 307, (SELECT nbpersonnes FROM reservation WHERE numreservation = 210), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (210, 248, (SELECT nbpersonnes FROM reservation WHERE numreservation = 210), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (211, 315, (SELECT nbpersonnes FROM reservation WHERE numreservation = 211), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (211, 314, (SELECT nbpersonnes FROM reservation WHERE numreservation = 211), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (212, 303, (SELECT nbpersonnes FROM reservation WHERE numreservation = 212), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (212, 311, (SELECT nbpersonnes FROM reservation WHERE numreservation = 212), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (213, 319, (SELECT nbpersonnes FROM reservation WHERE numreservation = 213), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (214, 9, (SELECT nbpersonnes FROM reservation WHERE numreservation = 214), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (214, 208, (SELECT nbpersonnes FROM reservation WHERE numreservation = 214), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (215, 217, (SELECT nbpersonnes FROM reservation WHERE numreservation = 215), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (215, 18, (SELECT nbpersonnes FROM reservation WHERE numreservation = 215), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (216, 309, (SELECT nbpersonnes FROM reservation WHERE numreservation = 216), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (216, 331, (SELECT nbpersonnes FROM reservation WHERE numreservation = 216), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (217, 205, (SELECT nbpersonnes FROM reservation WHERE numreservation = 217), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (218, 327, (SELECT nbpersonnes FROM reservation WHERE numreservation = 218), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (218, 317, (SELECT nbpersonnes FROM reservation WHERE numreservation = 218), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (219, 221, (SELECT nbpersonnes FROM reservation WHERE numreservation = 219), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (220, 3, (SELECT nbpersonnes FROM reservation WHERE numreservation = 220), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (221, 242, (SELECT nbpersonnes FROM reservation WHERE numreservation = 221), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (221, 211, (SELECT nbpersonnes FROM reservation WHERE numreservation = 221), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (222, 249, (SELECT nbpersonnes FROM reservation WHERE numreservation = 222), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (222, 308, (SELECT nbpersonnes FROM reservation WHERE numreservation = 222), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (223, 7, (SELECT nbpersonnes FROM reservation WHERE numreservation = 223), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (224, 201, (SELECT nbpersonnes FROM reservation WHERE numreservation = 224), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (225, 21, (SELECT nbpersonnes FROM reservation WHERE numreservation = 225), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (226, 312, (SELECT nbpersonnes FROM reservation WHERE numreservation = 226), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (226, 323, (SELECT nbpersonnes FROM reservation WHERE numreservation = 226), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (227, 324, (SELECT nbpersonnes FROM reservation WHERE numreservation = 227), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (228, 244, (SELECT nbpersonnes FROM reservation WHERE numreservation = 228), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (229, 207, (SELECT nbpersonnes FROM reservation WHERE numreservation = 229), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (229, 4, (SELECT nbpersonnes FROM reservation WHERE numreservation = 229), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (230, 213, (SELECT nbpersonnes FROM reservation WHERE numreservation = 230), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (231, 5, (SELECT nbpersonnes FROM reservation WHERE numreservation = 231), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (231, 226, (SELECT nbpersonnes FROM reservation WHERE numreservation = 231), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (232, 240, (SELECT nbpersonnes FROM reservation WHERE numreservation = 232), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (232, 302, (SELECT nbpersonnes FROM reservation WHERE numreservation = 232), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (233, 322, (SELECT nbpersonnes FROM reservation WHERE numreservation = 233), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (233, 239, (SELECT nbpersonnes FROM reservation WHERE numreservation = 233), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (234, 310, (SELECT nbpersonnes FROM reservation WHERE numreservation = 234), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (234, 10, (SELECT nbpersonnes FROM reservation WHERE numreservation = 234), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (235, 332, (SELECT nbpersonnes FROM reservation WHERE numreservation = 235), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (235, 23, (SELECT nbpersonnes FROM reservation WHERE numreservation = 235), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (236, 348, (SELECT nbpersonnes FROM reservation WHERE numreservation = 236), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (236, 228, (SELECT nbpersonnes FROM reservation WHERE numreservation = 236), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (237, 329, (SELECT nbpersonnes FROM reservation WHERE numreservation = 237), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (237, 240, (SELECT nbpersonnes FROM reservation WHERE numreservation = 237), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (238, 220, (SELECT nbpersonnes FROM reservation WHERE numreservation = 238), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (238, 320, (SELECT nbpersonnes FROM reservation WHERE numreservation = 238), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (239, 306, (SELECT nbpersonnes FROM reservation WHERE numreservation = 239), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (239, 12, (SELECT nbpersonnes FROM reservation WHERE numreservation = 239), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (240, 22, (SELECT nbpersonnes FROM reservation WHERE numreservation = 240), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (240, 230, (SELECT nbpersonnes FROM reservation WHERE numreservation = 240), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (241, 235, (SELECT nbpersonnes FROM reservation WHERE numreservation = 241), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (242, 209, (SELECT nbpersonnes FROM reservation WHERE numreservation = 242), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (243, 13, (SELECT nbpersonnes FROM reservation WHERE numreservation = 243), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (244, 318, (SELECT nbpersonnes FROM reservation WHERE numreservation = 244), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (244, 219, (SELECT nbpersonnes FROM reservation WHERE numreservation = 244), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (245, 330, (SELECT nbpersonnes FROM reservation WHERE numreservation = 245), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (245, 223, (SELECT nbpersonnes FROM reservation WHERE numreservation = 245), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (246, 1, (SELECT nbpersonnes FROM reservation WHERE numreservation = 246), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (247, 349, (SELECT nbpersonnes FROM reservation WHERE numreservation = 247), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (248, 325, (SELECT nbpersonnes FROM reservation WHERE numreservation = 248), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (248, 246, (SELECT nbpersonnes FROM reservation WHERE numreservation = 248), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (249, 16, (SELECT nbpersonnes FROM reservation WHERE numreservation = 249), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (249, 333, (SELECT nbpersonnes FROM reservation WHERE numreservation = 249), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (250, 200, (SELECT nbpersonnes FROM reservation WHERE numreservation = 250), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (250, 234, (SELECT nbpersonnes FROM reservation WHERE numreservation = 250), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (251, 341, (SELECT nbpersonnes FROM reservation WHERE numreservation = 251), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (251, 225, (SELECT nbpersonnes FROM reservation WHERE numreservation = 251), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (252, 15, (SELECT nbpersonnes FROM reservation WHERE numreservation = 252), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (252, 227, (SELECT nbpersonnes FROM reservation WHERE numreservation = 252), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (253, 335, (SELECT nbpersonnes FROM reservation WHERE numreservation = 253), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (253, 238, (SELECT nbpersonnes FROM reservation WHERE numreservation = 253), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (254, 232, (SELECT nbpersonnes FROM reservation WHERE numreservation = 254), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (254, 339, (SELECT nbpersonnes FROM reservation WHERE numreservation = 254), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (255, 212, (SELECT nbpersonnes FROM reservation WHERE numreservation = 255), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (255, 203, (SELECT nbpersonnes FROM reservation WHERE numreservation = 255), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (256, 345, (SELECT nbpersonnes FROM reservation WHERE numreservation = 256), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (257, 342, (SELECT nbpersonnes FROM reservation WHERE numreservation = 257), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (258, 216, (SELECT nbpersonnes FROM reservation WHERE numreservation = 258), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (258, 241, (SELECT nbpersonnes FROM reservation WHERE numreservation = 258), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (259, 326, (SELECT nbpersonnes FROM reservation WHERE numreservation = 259), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (260, 336, (SELECT nbpersonnes FROM reservation WHERE numreservation = 260), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (260, 224, (SELECT nbpersonnes FROM reservation WHERE numreservation = 260), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (261, 231, (SELECT nbpersonnes FROM reservation WHERE numreservation = 261), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (261, 206, (SELECT nbpersonnes FROM reservation WHERE numreservation = 261), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (262, 304, (SELECT nbpersonnes FROM reservation WHERE numreservation = 262), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (262, 334, (SELECT nbpersonnes FROM reservation WHERE numreservation = 262), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (263, 8, (SELECT nbpersonnes FROM reservation WHERE numreservation = 263), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (263, 218, (SELECT nbpersonnes FROM reservation WHERE numreservation = 263), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (264, 245, (SELECT nbpersonnes FROM reservation WHERE numreservation = 264), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (264, 11, (SELECT nbpersonnes FROM reservation WHERE numreservation = 264), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (265, 215, (SELECT nbpersonnes FROM reservation WHERE numreservation = 265), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (265, 301, (SELECT nbpersonnes FROM reservation WHERE numreservation = 265), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (266, 204, (SELECT nbpersonnes FROM reservation WHERE numreservation = 266), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (267, 233, (SELECT nbpersonnes FROM reservation WHERE numreservation = 267), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (267, 338, (SELECT nbpersonnes FROM reservation WHERE numreservation = 267), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (268, 202, (SELECT nbpersonnes FROM reservation WHERE numreservation = 268), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (268, 313, (SELECT nbpersonnes FROM reservation WHERE numreservation = 268), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (269, 344, (SELECT nbpersonnes FROM reservation WHERE numreservation = 269), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (270, 305, (SELECT nbpersonnes FROM reservation WHERE numreservation = 270), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (271, 29, (SELECT nbpersonnes FROM reservation WHERE numreservation = 271), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (272, 236, (SELECT nbpersonnes FROM reservation WHERE numreservation = 272), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (272, 222, (SELECT nbpersonnes FROM reservation WHERE numreservation = 272), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (273, 237, (SELECT nbpersonnes FROM reservation WHERE numreservation = 273), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (274, 229, (SELECT nbpersonnes FROM reservation WHERE numreservation = 274), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (274, 14, (SELECT nbpersonnes FROM reservation WHERE numreservation = 274), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (276, 243, (SELECT nbpersonnes FROM reservation WHERE numreservation = 276), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (276, 337, (SELECT nbpersonnes FROM reservation WHERE numreservation = 276), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (277, 210, (SELECT nbpersonnes FROM reservation WHERE numreservation = 277), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (277, 247, (SELECT nbpersonnes FROM reservation WHERE numreservation = 277), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (278, 343, (SELECT nbpersonnes FROM reservation WHERE numreservation = 278), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (278, 328, (SELECT nbpersonnes FROM reservation WHERE numreservation = 278), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (279, 17, (SELECT nbpersonnes FROM reservation WHERE numreservation = 279), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (280, 316, (SELECT nbpersonnes FROM reservation WHERE numreservation = 280), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (280, 321, (SELECT nbpersonnes FROM reservation WHERE numreservation = 280), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (281, 214, (SELECT nbpersonnes FROM reservation WHERE numreservation = 281), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (282, 307, (SELECT nbpersonnes FROM reservation WHERE numreservation = 282), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (282, 248, (SELECT nbpersonnes FROM reservation WHERE numreservation = 282), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (283, 315, (SELECT nbpersonnes FROM reservation WHERE numreservation = 283), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (283, 314, (SELECT nbpersonnes FROM reservation WHERE numreservation = 283), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (284, 303, (SELECT nbpersonnes FROM reservation WHERE numreservation = 284), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (284, 311, (SELECT nbpersonnes FROM reservation WHERE numreservation = 284), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (285, 319, (SELECT nbpersonnes FROM reservation WHERE numreservation = 285), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (286, 9, (SELECT nbpersonnes FROM reservation WHERE numreservation = 286), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (286, 208, (SELECT nbpersonnes FROM reservation WHERE numreservation = 286), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (287, 217, (SELECT nbpersonnes FROM reservation WHERE numreservation = 287), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (287, 18, (SELECT nbpersonnes FROM reservation WHERE numreservation = 287), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (288, 309, (SELECT nbpersonnes FROM reservation WHERE numreservation = 288), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (288, 331, (SELECT nbpersonnes FROM reservation WHERE numreservation = 288), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (289, 205, (SELECT nbpersonnes FROM reservation WHERE numreservation = 289), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (290, 327, (SELECT nbpersonnes FROM reservation WHERE numreservation = 290), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (290, 317, (SELECT nbpersonnes FROM reservation WHERE numreservation = 290), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (291, 221, (SELECT nbpersonnes FROM reservation WHERE numreservation = 291), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (292, 3, (SELECT nbpersonnes FROM reservation WHERE numreservation = 292), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (293, 242, (SELECT nbpersonnes FROM reservation WHERE numreservation = 293), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (293, 211, (SELECT nbpersonnes FROM reservation WHERE numreservation = 293), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (294, 249, (SELECT nbpersonnes FROM reservation WHERE numreservation = 294), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (294, 308, (SELECT nbpersonnes FROM reservation WHERE numreservation = 294), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (295, 7, (SELECT nbpersonnes FROM reservation WHERE numreservation = 295), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (296, 201, (SELECT nbpersonnes FROM reservation WHERE numreservation = 296), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (297, 21, (SELECT nbpersonnes FROM reservation WHERE numreservation = 297), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (298, 312, (SELECT nbpersonnes FROM reservation WHERE numreservation = 298), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (298, 323, (SELECT nbpersonnes FROM reservation WHERE numreservation = 298), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (299, 324, (SELECT nbpersonnes FROM reservation WHERE numreservation = 299), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (300, 244, (SELECT nbpersonnes FROM reservation WHERE numreservation = 300), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (301, 207, (SELECT nbpersonnes FROM reservation WHERE numreservation = 301), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (301, 4, (SELECT nbpersonnes FROM reservation WHERE numreservation = 301), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (302, 213, (SELECT nbpersonnes FROM reservation WHERE numreservation = 302), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (303, 5, (SELECT nbpersonnes FROM reservation WHERE numreservation = 303), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (303, 226, (SELECT nbpersonnes FROM reservation WHERE numreservation = 303), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (304, 240, (SELECT nbpersonnes FROM reservation WHERE numreservation = 304), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (304, 302, (SELECT nbpersonnes FROM reservation WHERE numreservation = 304), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (305, 322, (SELECT nbpersonnes FROM reservation WHERE numreservation = 305), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (305, 239, (SELECT nbpersonnes FROM reservation WHERE numreservation = 305), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (306, 310, (SELECT nbpersonnes FROM reservation WHERE numreservation = 306), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (306, 10, (SELECT nbpersonnes FROM reservation WHERE numreservation = 306), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (307, 332, (SELECT nbpersonnes FROM reservation WHERE numreservation = 307), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (307, 23, (SELECT nbpersonnes FROM reservation WHERE numreservation = 307), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (308, 348, (SELECT nbpersonnes FROM reservation WHERE numreservation = 308), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (308, 228, (SELECT nbpersonnes FROM reservation WHERE numreservation = 308), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (309, 329, (SELECT nbpersonnes FROM reservation WHERE numreservation = 309), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (309, 240, (SELECT nbpersonnes FROM reservation WHERE numreservation = 309), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (310, 220, (SELECT nbpersonnes FROM reservation WHERE numreservation = 310), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (310, 320, (SELECT nbpersonnes FROM reservation WHERE numreservation = 310), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (311, 306, (SELECT nbpersonnes FROM reservation WHERE numreservation = 311), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (311, 12, (SELECT nbpersonnes FROM reservation WHERE numreservation = 311), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (312, 22, (SELECT nbpersonnes FROM reservation WHERE numreservation = 312), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (312, 230, (SELECT nbpersonnes FROM reservation WHERE numreservation = 312), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (313, 235, (SELECT nbpersonnes FROM reservation WHERE numreservation = 313), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (314, 209, (SELECT nbpersonnes FROM reservation WHERE numreservation = 314), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (315, 13, (SELECT nbpersonnes FROM reservation WHERE numreservation = 315), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (316, 318, (SELECT nbpersonnes FROM reservation WHERE numreservation = 316), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (316, 219, (SELECT nbpersonnes FROM reservation WHERE numreservation = 316), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (317, 330, (SELECT nbpersonnes FROM reservation WHERE numreservation = 317), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (317, 223, (SELECT nbpersonnes FROM reservation WHERE numreservation = 317), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (318, 1, (SELECT nbpersonnes FROM reservation WHERE numreservation = 318), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (319, 349, (SELECT nbpersonnes FROM reservation WHERE numreservation = 319), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (320, 325, (SELECT nbpersonnes FROM reservation WHERE numreservation = 320), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (320, 246, (SELECT nbpersonnes FROM reservation WHERE numreservation = 320), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (321, 16, (SELECT nbpersonnes FROM reservation WHERE numreservation = 321), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (321, 333, (SELECT nbpersonnes FROM reservation WHERE numreservation = 321), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (322, 200, (SELECT nbpersonnes FROM reservation WHERE numreservation = 322), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (322, 234, (SELECT nbpersonnes FROM reservation WHERE numreservation = 322), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (323, 341, (SELECT nbpersonnes FROM reservation WHERE numreservation = 323), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (323, 225, (SELECT nbpersonnes FROM reservation WHERE numreservation = 323), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (324, 15, (SELECT nbpersonnes FROM reservation WHERE numreservation = 324), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (324, 227, (SELECT nbpersonnes FROM reservation WHERE numreservation = 324), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (325, 335, (SELECT nbpersonnes FROM reservation WHERE numreservation = 325), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (325, 238, (SELECT nbpersonnes FROM reservation WHERE numreservation = 325), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (326, 232, (SELECT nbpersonnes FROM reservation WHERE numreservation = 326), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (326, 339, (SELECT nbpersonnes FROM reservation WHERE numreservation = 326), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (327, 212, (SELECT nbpersonnes FROM reservation WHERE numreservation = 327), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (327, 203, (SELECT nbpersonnes FROM reservation WHERE numreservation = 327), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (328, 345, (SELECT nbpersonnes FROM reservation WHERE numreservation = 328), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (329, 342, (SELECT nbpersonnes FROM reservation WHERE numreservation = 329), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (330, 216, (SELECT nbpersonnes FROM reservation WHERE numreservation = 330), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (330, 241, (SELECT nbpersonnes FROM reservation WHERE numreservation = 330), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (331, 326, (SELECT nbpersonnes FROM reservation WHERE numreservation = 331), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (332, 336, (SELECT nbpersonnes FROM reservation WHERE numreservation = 332), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (332, 224, (SELECT nbpersonnes FROM reservation WHERE numreservation = 332), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (333, 231, (SELECT nbpersonnes FROM reservation WHERE numreservation = 333), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (333, 206, (SELECT nbpersonnes FROM reservation WHERE numreservation = 333), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (334, 304, (SELECT nbpersonnes FROM reservation WHERE numreservation = 334), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (334, 334, (SELECT nbpersonnes FROM reservation WHERE numreservation = 334), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (335, 8, (SELECT nbpersonnes FROM reservation WHERE numreservation = 335), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (335, 218, (SELECT nbpersonnes FROM reservation WHERE numreservation = 335), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (336, 245, (SELECT nbpersonnes FROM reservation WHERE numreservation = 336), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (336, 11, (SELECT nbpersonnes FROM reservation WHERE numreservation = 336), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (337, 215, (SELECT nbpersonnes FROM reservation WHERE numreservation = 337), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (337, 301, (SELECT nbpersonnes FROM reservation WHERE numreservation = 337), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (338, 204, (SELECT nbpersonnes FROM reservation WHERE numreservation = 338), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (339, 233, (SELECT nbpersonnes FROM reservation WHERE numreservation = 339), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (339, 338, (SELECT nbpersonnes FROM reservation WHERE numreservation = 339), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (340, 202, (SELECT nbpersonnes FROM reservation WHERE numreservation = 340), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (340, 313, (SELECT nbpersonnes FROM reservation WHERE numreservation = 340), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (341, 344, (SELECT nbpersonnes FROM reservation WHERE numreservation = 341), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (342, 305, (SELECT nbpersonnes FROM reservation WHERE numreservation = 342), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (343, 29, (SELECT nbpersonnes FROM reservation WHERE numreservation = 343), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (344, 236, (SELECT nbpersonnes FROM reservation WHERE numreservation = 344), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (344, 222, (SELECT nbpersonnes FROM reservation WHERE numreservation = 344), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (345, 237, (SELECT nbpersonnes FROM reservation WHERE numreservation = 345), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (346, 229, (SELECT nbpersonnes FROM reservation WHERE numreservation = 346), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (346, 14, (SELECT nbpersonnes FROM reservation WHERE numreservation = 346), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (348, 243, (SELECT nbpersonnes FROM reservation WHERE numreservation = 348), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (348, 337, (SELECT nbpersonnes FROM reservation WHERE numreservation = 348), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (349, 210, (SELECT nbpersonnes FROM reservation WHERE numreservation = 349), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (349, 247, (SELECT nbpersonnes FROM reservation WHERE numreservation = 349), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (350, 343, (SELECT nbpersonnes FROM reservation WHERE numreservation = 350), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (350, 328, (SELECT nbpersonnes FROM reservation WHERE numreservation = 350), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (351, 17, (SELECT nbpersonnes FROM reservation WHERE numreservation = 351), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (352, 316, (SELECT nbpersonnes FROM reservation WHERE numreservation = 352), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (352, 321, (SELECT nbpersonnes FROM reservation WHERE numreservation = 352), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (353, 214, (SELECT nbpersonnes FROM reservation WHERE numreservation = 353), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (354, 307, (SELECT nbpersonnes FROM reservation WHERE numreservation = 354), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (354, 248, (SELECT nbpersonnes FROM reservation WHERE numreservation = 354), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (355, 315, (SELECT nbpersonnes FROM reservation WHERE numreservation = 355), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (355, 314, (SELECT nbpersonnes FROM reservation WHERE numreservation = 355), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (356, 303, (SELECT nbpersonnes FROM reservation WHERE numreservation = 356), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (356, 311, (SELECT nbpersonnes FROM reservation WHERE numreservation = 356), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (357, 319, (SELECT nbpersonnes FROM reservation WHERE numreservation = 357), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (358, 9, (SELECT nbpersonnes FROM reservation WHERE numreservation = 358), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (358, 208, (SELECT nbpersonnes FROM reservation WHERE numreservation = 358), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (359, 217, (SELECT nbpersonnes FROM reservation WHERE numreservation = 359), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (359, 18, (SELECT nbpersonnes FROM reservation WHERE numreservation = 359), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (360, 309, (SELECT nbpersonnes FROM reservation WHERE numreservation = 360), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (360, 331, (SELECT nbpersonnes FROM reservation WHERE numreservation = 360), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (361, 205, (SELECT nbpersonnes FROM reservation WHERE numreservation = 361), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (362, 327, (SELECT nbpersonnes FROM reservation WHERE numreservation = 362), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (362, 317, (SELECT nbpersonnes FROM reservation WHERE numreservation = 362), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (363, 221, (SELECT nbpersonnes FROM reservation WHERE numreservation = 363), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (364, 3, (SELECT nbpersonnes FROM reservation WHERE numreservation = 364), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (365, 242, (SELECT nbpersonnes FROM reservation WHERE numreservation = 365), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (365, 211, (SELECT nbpersonnes FROM reservation WHERE numreservation = 365), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (366, 249, (SELECT nbpersonnes FROM reservation WHERE numreservation = 366), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (366, 308, (SELECT nbpersonnes FROM reservation WHERE numreservation = 366), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (367, 7, (SELECT nbpersonnes FROM reservation WHERE numreservation = 367), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (368, 201, (SELECT nbpersonnes FROM reservation WHERE numreservation = 368), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (369, 21, (SELECT nbpersonnes FROM reservation WHERE numreservation = 369), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (370, 312, (SELECT nbpersonnes FROM reservation WHERE numreservation = 370), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (370, 323, (SELECT nbpersonnes FROM reservation WHERE numreservation = 370), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (371, 324, (SELECT nbpersonnes FROM reservation WHERE numreservation = 371), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (372, 244, (SELECT nbpersonnes FROM reservation WHERE numreservation = 372), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (373, 207, (SELECT nbpersonnes FROM reservation WHERE numreservation = 373), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (373, 4, (SELECT nbpersonnes FROM reservation WHERE numreservation = 373), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (374, 213, (SELECT nbpersonnes FROM reservation WHERE numreservation = 374), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (375, 5, (SELECT nbpersonnes FROM reservation WHERE numreservation = 375), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (375, 226, (SELECT nbpersonnes FROM reservation WHERE numreservation = 375), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (376, 240, (SELECT nbpersonnes FROM reservation WHERE numreservation = 376), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (376, 302, (SELECT nbpersonnes FROM reservation WHERE numreservation = 376), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (377, 322, (SELECT nbpersonnes FROM reservation WHERE numreservation = 377), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (377, 239, (SELECT nbpersonnes FROM reservation WHERE numreservation = 377), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (378, 310, (SELECT nbpersonnes FROM reservation WHERE numreservation = 378), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (378, 10, (SELECT nbpersonnes FROM reservation WHERE numreservation = 378), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (379, 332, (SELECT nbpersonnes FROM reservation WHERE numreservation = 379), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (379, 23, (SELECT nbpersonnes FROM reservation WHERE numreservation = 379), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (380, 348, (SELECT nbpersonnes FROM reservation WHERE numreservation = 380), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (380, 228, (SELECT nbpersonnes FROM reservation WHERE numreservation = 380), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (381, 329, (SELECT nbpersonnes FROM reservation WHERE numreservation = 381), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (381, 240, (SELECT nbpersonnes FROM reservation WHERE numreservation = 381), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (382, 220, (SELECT nbpersonnes FROM reservation WHERE numreservation = 382), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (382, 320, (SELECT nbpersonnes FROM reservation WHERE numreservation = 382), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (383, 306, (SELECT nbpersonnes FROM reservation WHERE numreservation = 383), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (383, 12, (SELECT nbpersonnes FROM reservation WHERE numreservation = 383), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (384, 22, (SELECT nbpersonnes FROM reservation WHERE numreservation = 384), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (384, 230, (SELECT nbpersonnes FROM reservation WHERE numreservation = 384), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (385, 235, (SELECT nbpersonnes FROM reservation WHERE numreservation = 385), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (386, 209, (SELECT nbpersonnes FROM reservation WHERE numreservation = 386), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (387, 13, (SELECT nbpersonnes FROM reservation WHERE numreservation = 387), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (388, 318, (SELECT nbpersonnes FROM reservation WHERE numreservation = 388), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (388, 219, (SELECT nbpersonnes FROM reservation WHERE numreservation = 388), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (389, 330, (SELECT nbpersonnes FROM reservation WHERE numreservation = 389), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (389, 223, (SELECT nbpersonnes FROM reservation WHERE numreservation = 389), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (390, 1, (SELECT nbpersonnes FROM reservation WHERE numreservation = 390), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (391, 349, (SELECT nbpersonnes FROM reservation WHERE numreservation = 391), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (392, 325, (SELECT nbpersonnes FROM reservation WHERE numreservation = 392), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (392, 246, (SELECT nbpersonnes FROM reservation WHERE numreservation = 392), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (393, 16, (SELECT nbpersonnes FROM reservation WHERE numreservation = 393), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (393, 333, (SELECT nbpersonnes FROM reservation WHERE numreservation = 393), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (394, 200, (SELECT nbpersonnes FROM reservation WHERE numreservation = 394), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (394, 234, (SELECT nbpersonnes FROM reservation WHERE numreservation = 394), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (395, 341, (SELECT nbpersonnes FROM reservation WHERE numreservation = 395), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (395, 225, (SELECT nbpersonnes FROM reservation WHERE numreservation = 395), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (396, 15, (SELECT nbpersonnes FROM reservation WHERE numreservation = 396), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (396, 227, (SELECT nbpersonnes FROM reservation WHERE numreservation = 396), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (397, 335, (SELECT nbpersonnes FROM reservation WHERE numreservation = 397), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (397, 238, (SELECT nbpersonnes FROM reservation WHERE numreservation = 397), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (398, 232, (SELECT nbpersonnes FROM reservation WHERE numreservation = 398), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (398, 339, (SELECT nbpersonnes FROM reservation WHERE numreservation = 398), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (399, 212, (SELECT nbpersonnes FROM reservation WHERE numreservation = 399), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (399, 203, (SELECT nbpersonnes FROM reservation WHERE numreservation = 399), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (400, 345, (SELECT nbpersonnes FROM reservation WHERE numreservation = 400), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (401, 342, (SELECT nbpersonnes FROM reservation WHERE numreservation = 401), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (402, 216, (SELECT nbpersonnes FROM reservation WHERE numreservation = 402), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (402, 241, (SELECT nbpersonnes FROM reservation WHERE numreservation = 402), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (403, 326, (SELECT nbpersonnes FROM reservation WHERE numreservation = 403), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (404, 336, (SELECT nbpersonnes FROM reservation WHERE numreservation = 404), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (404, 224, (SELECT nbpersonnes FROM reservation WHERE numreservation = 404), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (405, 231, (SELECT nbpersonnes FROM reservation WHERE numreservation = 405), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (405, 206, (SELECT nbpersonnes FROM reservation WHERE numreservation = 405), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (406, 304, (SELECT nbpersonnes FROM reservation WHERE numreservation = 406), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (406, 334, (SELECT nbpersonnes FROM reservation WHERE numreservation = 406), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (407, 8, (SELECT nbpersonnes FROM reservation WHERE numreservation = 407), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (407, 218, (SELECT nbpersonnes FROM reservation WHERE numreservation = 407), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (408, 245, (SELECT nbpersonnes FROM reservation WHERE numreservation = 408), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (408, 11, (SELECT nbpersonnes FROM reservation WHERE numreservation = 408), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (409, 215, (SELECT nbpersonnes FROM reservation WHERE numreservation = 409), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (409, 301, (SELECT nbpersonnes FROM reservation WHERE numreservation = 409), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (410, 204, (SELECT nbpersonnes FROM reservation WHERE numreservation = 410), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (411, 233, (SELECT nbpersonnes FROM reservation WHERE numreservation = 411), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (411, 338, (SELECT nbpersonnes FROM reservation WHERE numreservation = 411), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (412, 202, (SELECT nbpersonnes FROM reservation WHERE numreservation = 412), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (412, 313, (SELECT nbpersonnes FROM reservation WHERE numreservation = 412), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (413, 344, (SELECT nbpersonnes FROM reservation WHERE numreservation = 413), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (414, 305, (SELECT nbpersonnes FROM reservation WHERE numreservation = 414), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (415, 29, (SELECT nbpersonnes FROM reservation WHERE numreservation = 415), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (416, 236, (SELECT nbpersonnes FROM reservation WHERE numreservation = 416), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (416, 222, (SELECT nbpersonnes FROM reservation WHERE numreservation = 416), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (417, 237, (SELECT nbpersonnes FROM reservation WHERE numreservation = 417), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (418, 229, (SELECT nbpersonnes FROM reservation WHERE numreservation = 418), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (418, 14, (SELECT nbpersonnes FROM reservation WHERE numreservation = 418), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (420, 243, (SELECT nbpersonnes FROM reservation WHERE numreservation = 420), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (420, 337, (SELECT nbpersonnes FROM reservation WHERE numreservation = 420), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (421, 210, (SELECT nbpersonnes FROM reservation WHERE numreservation = 421), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (421, 247, (SELECT nbpersonnes FROM reservation WHERE numreservation = 421), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (422, 343, (SELECT nbpersonnes FROM reservation WHERE numreservation = 422), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (422, 328, (SELECT nbpersonnes FROM reservation WHERE numreservation = 422), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (423, 17, (SELECT nbpersonnes FROM reservation WHERE numreservation = 423), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (424, 316, (SELECT nbpersonnes FROM reservation WHERE numreservation = 424), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (424, 321, (SELECT nbpersonnes FROM reservation WHERE numreservation = 424), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (425, 214, (SELECT nbpersonnes FROM reservation WHERE numreservation = 425), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (426, 307, (SELECT nbpersonnes FROM reservation WHERE numreservation = 426), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (426, 248, (SELECT nbpersonnes FROM reservation WHERE numreservation = 426), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (427, 315, (SELECT nbpersonnes FROM reservation WHERE numreservation = 427), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (427, 314, (SELECT nbpersonnes FROM reservation WHERE numreservation = 427), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (428, 303, (SELECT nbpersonnes FROM reservation WHERE numreservation = 428), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (428, 311, (SELECT nbpersonnes FROM reservation WHERE numreservation = 428), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (429, 319, (SELECT nbpersonnes FROM reservation WHERE numreservation = 429), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (430, 9, (SELECT nbpersonnes FROM reservation WHERE numreservation = 430), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (430, 208, (SELECT nbpersonnes FROM reservation WHERE numreservation = 430), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (431, 217, (SELECT nbpersonnes FROM reservation WHERE numreservation = 431), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (431, 18, (SELECT nbpersonnes FROM reservation WHERE numreservation = 431), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (432, 309, (SELECT nbpersonnes FROM reservation WHERE numreservation = 432), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (432, 331, (SELECT nbpersonnes FROM reservation WHERE numreservation = 432), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (433, 205, (SELECT nbpersonnes FROM reservation WHERE numreservation = 433), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (434, 327, (SELECT nbpersonnes FROM reservation WHERE numreservation = 434), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (434, 317, (SELECT nbpersonnes FROM reservation WHERE numreservation = 434), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (435, 221, (SELECT nbpersonnes FROM reservation WHERE numreservation = 435), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (436, 3, (SELECT nbpersonnes FROM reservation WHERE numreservation = 436), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (437, 242, (SELECT nbpersonnes FROM reservation WHERE numreservation = 437), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (437, 211, (SELECT nbpersonnes FROM reservation WHERE numreservation = 437), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (438, 249, (SELECT nbpersonnes FROM reservation WHERE numreservation = 438), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (438, 308, (SELECT nbpersonnes FROM reservation WHERE numreservation = 438), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (439, 7, (SELECT nbpersonnes FROM reservation WHERE numreservation = 439), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (440, 201, (SELECT nbpersonnes FROM reservation WHERE numreservation = 440), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (441, 21, (SELECT nbpersonnes FROM reservation WHERE numreservation = 441), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (442, 312, (SELECT nbpersonnes FROM reservation WHERE numreservation = 442), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (442, 323, (SELECT nbpersonnes FROM reservation WHERE numreservation = 442), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (443, 324, (SELECT nbpersonnes FROM reservation WHERE numreservation = 443), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (444, 244, (SELECT nbpersonnes FROM reservation WHERE numreservation = 444), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (445, 207, (SELECT nbpersonnes FROM reservation WHERE numreservation = 445), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (445, 4, (SELECT nbpersonnes FROM reservation WHERE numreservation = 445), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (446, 213, (SELECT nbpersonnes FROM reservation WHERE numreservation = 446), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (447, 5, (SELECT nbpersonnes FROM reservation WHERE numreservation = 447), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (447, 226, (SELECT nbpersonnes FROM reservation WHERE numreservation = 447), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (448, 240, (SELECT nbpersonnes FROM reservation WHERE numreservation = 448), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (448, 302, (SELECT nbpersonnes FROM reservation WHERE numreservation = 448), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (449, 322, (SELECT nbpersonnes FROM reservation WHERE numreservation = 449), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (449, 239, (SELECT nbpersonnes FROM reservation WHERE numreservation = 449), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (450, 310, (SELECT nbpersonnes FROM reservation WHERE numreservation = 450), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (450, 10, (SELECT nbpersonnes FROM reservation WHERE numreservation = 450), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (451, 332, (SELECT nbpersonnes FROM reservation WHERE numreservation = 451), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (451, 23, (SELECT nbpersonnes FROM reservation WHERE numreservation = 451), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (452, 348, (SELECT nbpersonnes FROM reservation WHERE numreservation = 452), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (452, 228, (SELECT nbpersonnes FROM reservation WHERE numreservation = 452), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (453, 329, (SELECT nbpersonnes FROM reservation WHERE numreservation = 453), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (453, 240, (SELECT nbpersonnes FROM reservation WHERE numreservation = 453), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (454, 220, (SELECT nbpersonnes FROM reservation WHERE numreservation = 454), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (454, 320, (SELECT nbpersonnes FROM reservation WHERE numreservation = 454), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (455, 306, (SELECT nbpersonnes FROM reservation WHERE numreservation = 455), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (455, 12, (SELECT nbpersonnes FROM reservation WHERE numreservation = 455), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (456, 22, (SELECT nbpersonnes FROM reservation WHERE numreservation = 456), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (456, 230, (SELECT nbpersonnes FROM reservation WHERE numreservation = 456), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (457, 235, (SELECT nbpersonnes FROM reservation WHERE numreservation = 457), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (458, 209, (SELECT nbpersonnes FROM reservation WHERE numreservation = 458), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (459, 13, (SELECT nbpersonnes FROM reservation WHERE numreservation = 459), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (460, 318, (SELECT nbpersonnes FROM reservation WHERE numreservation = 460), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (460, 219, (SELECT nbpersonnes FROM reservation WHERE numreservation = 460), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (461, 330, (SELECT nbpersonnes FROM reservation WHERE numreservation = 461), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (461, 223, (SELECT nbpersonnes FROM reservation WHERE numreservation = 461), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (462, 1, (SELECT nbpersonnes FROM reservation WHERE numreservation = 462), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (463, 349, (SELECT nbpersonnes FROM reservation WHERE numreservation = 463), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (464, 325, (SELECT nbpersonnes FROM reservation WHERE numreservation = 464), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (464, 246, (SELECT nbpersonnes FROM reservation WHERE numreservation = 464), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (465, 16, (SELECT nbpersonnes FROM reservation WHERE numreservation = 465), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (465, 333, (SELECT nbpersonnes FROM reservation WHERE numreservation = 465), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (466, 200, (SELECT nbpersonnes FROM reservation WHERE numreservation = 466), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (466, 234, (SELECT nbpersonnes FROM reservation WHERE numreservation = 466), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (467, 341, (SELECT nbpersonnes FROM reservation WHERE numreservation = 467), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (467, 225, (SELECT nbpersonnes FROM reservation WHERE numreservation = 467), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (468, 15, (SELECT nbpersonnes FROM reservation WHERE numreservation = 468), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (468, 227, (SELECT nbpersonnes FROM reservation WHERE numreservation = 468), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (469, 335, (SELECT nbpersonnes FROM reservation WHERE numreservation = 469), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (469, 238, (SELECT nbpersonnes FROM reservation WHERE numreservation = 469), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (470, 232, (SELECT nbpersonnes FROM reservation WHERE numreservation = 470), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (470, 339, (SELECT nbpersonnes FROM reservation WHERE numreservation = 470), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (471, 212, (SELECT nbpersonnes FROM reservation WHERE numreservation = 471), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (471, 203, (SELECT nbpersonnes FROM reservation WHERE numreservation = 471), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (472, 345, (SELECT nbpersonnes FROM reservation WHERE numreservation = 472), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (473, 342, (SELECT nbpersonnes FROM reservation WHERE numreservation = 473), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (474, 216, (SELECT nbpersonnes FROM reservation WHERE numreservation = 474), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (474, 241, (SELECT nbpersonnes FROM reservation WHERE numreservation = 474), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (475, 326, (SELECT nbpersonnes FROM reservation WHERE numreservation = 475), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (476, 336, (SELECT nbpersonnes FROM reservation WHERE numreservation = 476), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (476, 224, (SELECT nbpersonnes FROM reservation WHERE numreservation = 476), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (477, 231, (SELECT nbpersonnes FROM reservation WHERE numreservation = 477), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (477, 206, (SELECT nbpersonnes FROM reservation WHERE numreservation = 477), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (478, 304, (SELECT nbpersonnes FROM reservation WHERE numreservation = 478), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (478, 334, (SELECT nbpersonnes FROM reservation WHERE numreservation = 478), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (479, 8, (SELECT nbpersonnes FROM reservation WHERE numreservation = 479), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (479, 218, (SELECT nbpersonnes FROM reservation WHERE numreservation = 479), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (480, 245, (SELECT nbpersonnes FROM reservation WHERE numreservation = 480), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (480, 11, (SELECT nbpersonnes FROM reservation WHERE numreservation = 480), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (481, 215, (SELECT nbpersonnes FROM reservation WHERE numreservation = 481), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (481, 301, (SELECT nbpersonnes FROM reservation WHERE numreservation = 481), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (482, 204, (SELECT nbpersonnes FROM reservation WHERE numreservation = 482), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (483, 233, (SELECT nbpersonnes FROM reservation WHERE numreservation = 483), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (483, 338, (SELECT nbpersonnes FROM reservation WHERE numreservation = 483), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (484, 202, (SELECT nbpersonnes FROM reservation WHERE numreservation = 484), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (484, 313, (SELECT nbpersonnes FROM reservation WHERE numreservation = 484), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (485, 344, (SELECT nbpersonnes FROM reservation WHERE numreservation = 485), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (486, 305, (SELECT nbpersonnes FROM reservation WHERE numreservation = 486), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (487, 29, (SELECT nbpersonnes FROM reservation WHERE numreservation = 487), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (488, 236, (SELECT nbpersonnes FROM reservation WHERE numreservation = 488), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (488, 222, (SELECT nbpersonnes FROM reservation WHERE numreservation = 488), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (489, 237, (SELECT nbpersonnes FROM reservation WHERE numreservation = 489), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (490, 229, (SELECT nbpersonnes FROM reservation WHERE numreservation = 490), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (490, 14, (SELECT nbpersonnes FROM reservation WHERE numreservation = 490), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (492, 243, (SELECT nbpersonnes FROM reservation WHERE numreservation = 492), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (492, 337, (SELECT nbpersonnes FROM reservation WHERE numreservation = 492), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (493, 210, (SELECT nbpersonnes FROM reservation WHERE numreservation = 493), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (493, 247, (SELECT nbpersonnes FROM reservation WHERE numreservation = 493), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (494, 343, (SELECT nbpersonnes FROM reservation WHERE numreservation = 494), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (494, 328, (SELECT nbpersonnes FROM reservation WHERE numreservation = 494), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (495, 17, (SELECT nbpersonnes FROM reservation WHERE numreservation = 495), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (496, 316, (SELECT nbpersonnes FROM reservation WHERE numreservation = 496), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (496, 321, (SELECT nbpersonnes FROM reservation WHERE numreservation = 496), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (497, 214, (SELECT nbpersonnes FROM reservation WHERE numreservation = 497), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (498, 307, (SELECT nbpersonnes FROM reservation WHERE numreservation = 498), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (498, 248, (SELECT nbpersonnes FROM reservation WHERE numreservation = 498), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (499, 315, (SELECT nbpersonnes FROM reservation WHERE numreservation = 499), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (499, 314, (SELECT nbpersonnes FROM reservation WHERE numreservation = 499), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (500, 303, (SELECT nbpersonnes FROM reservation WHERE numreservation = 500), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (500, 311, (SELECT nbpersonnes FROM reservation WHERE numreservation = 500), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (501, 319, (SELECT nbpersonnes FROM reservation WHERE numreservation = 501), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (502, 9, (SELECT nbpersonnes FROM reservation WHERE numreservation = 502), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (502, 208, (SELECT nbpersonnes FROM reservation WHERE numreservation = 502), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (503, 217, (SELECT nbpersonnes FROM reservation WHERE numreservation = 503), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (503, 18, (SELECT nbpersonnes FROM reservation WHERE numreservation = 503), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (504, 309, (SELECT nbpersonnes FROM reservation WHERE numreservation = 504), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (504, 331, (SELECT nbpersonnes FROM reservation WHERE numreservation = 504), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (505, 205, (SELECT nbpersonnes FROM reservation WHERE numreservation = 505), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (506, 327, (SELECT nbpersonnes FROM reservation WHERE numreservation = 506), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (506, 317, (SELECT nbpersonnes FROM reservation WHERE numreservation = 506), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (507, 221, (SELECT nbpersonnes FROM reservation WHERE numreservation = 507), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (508, 3, (SELECT nbpersonnes FROM reservation WHERE numreservation = 508), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (509, 242, (SELECT nbpersonnes FROM reservation WHERE numreservation = 509), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (509, 211, (SELECT nbpersonnes FROM reservation WHERE numreservation = 509), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (510, 249, (SELECT nbpersonnes FROM reservation WHERE numreservation = 510), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (510, 308, (SELECT nbpersonnes FROM reservation WHERE numreservation = 510), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (511, 7, (SELECT nbpersonnes FROM reservation WHERE numreservation = 511), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (512, 201, (SELECT nbpersonnes FROM reservation WHERE numreservation = 512), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (513, 21, (SELECT nbpersonnes FROM reservation WHERE numreservation = 513), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (514, 312, (SELECT nbpersonnes FROM reservation WHERE numreservation = 514), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (514, 323, (SELECT nbpersonnes FROM reservation WHERE numreservation = 514), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (515, 324, (SELECT nbpersonnes FROM reservation WHERE numreservation = 515), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (516, 244, (SELECT nbpersonnes FROM reservation WHERE numreservation = 516), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (517, 207, (SELECT nbpersonnes FROM reservation WHERE numreservation = 517), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (517, 4, (SELECT nbpersonnes FROM reservation WHERE numreservation = 517), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (518, 213, (SELECT nbpersonnes FROM reservation WHERE numreservation = 518), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (519, 5, (SELECT nbpersonnes FROM reservation WHERE numreservation = 519), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (519, 226, (SELECT nbpersonnes FROM reservation WHERE numreservation = 519), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (520, 240, (SELECT nbpersonnes FROM reservation WHERE numreservation = 520), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (520, 302, (SELECT nbpersonnes FROM reservation WHERE numreservation = 520), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (521, 322, (SELECT nbpersonnes FROM reservation WHERE numreservation = 521), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (521, 239, (SELECT nbpersonnes FROM reservation WHERE numreservation = 521), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (522, 310, (SELECT nbpersonnes FROM reservation WHERE numreservation = 522), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (522, 10, (SELECT nbpersonnes FROM reservation WHERE numreservation = 522), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (523, 332, (SELECT nbpersonnes FROM reservation WHERE numreservation = 523), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (523, 23, (SELECT nbpersonnes FROM reservation WHERE numreservation = 523), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (524, 348, (SELECT nbpersonnes FROM reservation WHERE numreservation = 524), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (524, 228, (SELECT nbpersonnes FROM reservation WHERE numreservation = 524), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (525, 329, (SELECT nbpersonnes FROM reservation WHERE numreservation = 525), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (525, 240, (SELECT nbpersonnes FROM reservation WHERE numreservation = 525), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (526, 220, (SELECT nbpersonnes FROM reservation WHERE numreservation = 526), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (526, 320, (SELECT nbpersonnes FROM reservation WHERE numreservation = 526), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (527, 306, (SELECT nbpersonnes FROM reservation WHERE numreservation = 527), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (527, 12, (SELECT nbpersonnes FROM reservation WHERE numreservation = 527), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (528, 22, (SELECT nbpersonnes FROM reservation WHERE numreservation = 528), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (528, 230, (SELECT nbpersonnes FROM reservation WHERE numreservation = 528), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (529, 235, (SELECT nbpersonnes FROM reservation WHERE numreservation = 529), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (530, 209, (SELECT nbpersonnes FROM reservation WHERE numreservation = 530), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (531, 13, (SELECT nbpersonnes FROM reservation WHERE numreservation = 531), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (532, 318, (SELECT nbpersonnes FROM reservation WHERE numreservation = 532), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (532, 219, (SELECT nbpersonnes FROM reservation WHERE numreservation = 532), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (533, 330, (SELECT nbpersonnes FROM reservation WHERE numreservation = 533), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (533, 223, (SELECT nbpersonnes FROM reservation WHERE numreservation = 533), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (534, 1, (SELECT nbpersonnes FROM reservation WHERE numreservation = 534), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (535, 349, (SELECT nbpersonnes FROM reservation WHERE numreservation = 535), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (536, 325, (SELECT nbpersonnes FROM reservation WHERE numreservation = 536), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (536, 246, (SELECT nbpersonnes FROM reservation WHERE numreservation = 536), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (537, 16, (SELECT nbpersonnes FROM reservation WHERE numreservation = 537), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (537, 333, (SELECT nbpersonnes FROM reservation WHERE numreservation = 537), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (538, 200, (SELECT nbpersonnes FROM reservation WHERE numreservation = 538), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (538, 234, (SELECT nbpersonnes FROM reservation WHERE numreservation = 538), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (539, 341, (SELECT nbpersonnes FROM reservation WHERE numreservation = 539), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (539, 225, (SELECT nbpersonnes FROM reservation WHERE numreservation = 539), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (540, 15, (SELECT nbpersonnes FROM reservation WHERE numreservation = 540), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (540, 227, (SELECT nbpersonnes FROM reservation WHERE numreservation = 540), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (541, 335, (SELECT nbpersonnes FROM reservation WHERE numreservation = 541), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (541, 238, (SELECT nbpersonnes FROM reservation WHERE numreservation = 541), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (542, 232, (SELECT nbpersonnes FROM reservation WHERE numreservation = 542), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (542, 339, (SELECT nbpersonnes FROM reservation WHERE numreservation = 542), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (543, 212, (SELECT nbpersonnes FROM reservation WHERE numreservation = 543), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (543, 203, (SELECT nbpersonnes FROM reservation WHERE numreservation = 543), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (544, 345, (SELECT nbpersonnes FROM reservation WHERE numreservation = 544), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (545, 342, (SELECT nbpersonnes FROM reservation WHERE numreservation = 545), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (546, 216, (SELECT nbpersonnes FROM reservation WHERE numreservation = 546), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (546, 241, (SELECT nbpersonnes FROM reservation WHERE numreservation = 546), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (547, 326, (SELECT nbpersonnes FROM reservation WHERE numreservation = 547), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (548, 336, (SELECT nbpersonnes FROM reservation WHERE numreservation = 548), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (548, 224, (SELECT nbpersonnes FROM reservation WHERE numreservation = 548), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (549, 231, (SELECT nbpersonnes FROM reservation WHERE numreservation = 549), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (549, 206, (SELECT nbpersonnes FROM reservation WHERE numreservation = 549), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (550, 304, (SELECT nbpersonnes FROM reservation WHERE numreservation = 550), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (550, 334, (SELECT nbpersonnes FROM reservation WHERE numreservation = 550), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (551, 8, (SELECT nbpersonnes FROM reservation WHERE numreservation = 551), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (551, 218, (SELECT nbpersonnes FROM reservation WHERE numreservation = 551), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (552, 245, (SELECT nbpersonnes FROM reservation WHERE numreservation = 552), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (552, 11, (SELECT nbpersonnes FROM reservation WHERE numreservation = 552), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (553, 215, (SELECT nbpersonnes FROM reservation WHERE numreservation = 553), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (553, 301, (SELECT nbpersonnes FROM reservation WHERE numreservation = 553), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (554, 204, (SELECT nbpersonnes FROM reservation WHERE numreservation = 554), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (555, 233, (SELECT nbpersonnes FROM reservation WHERE numreservation = 555), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (555, 338, (SELECT nbpersonnes FROM reservation WHERE numreservation = 555), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (556, 202, (SELECT nbpersonnes FROM reservation WHERE numreservation = 556), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (556, 313, (SELECT nbpersonnes FROM reservation WHERE numreservation = 556), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (557, 344, (SELECT nbpersonnes FROM reservation WHERE numreservation = 557), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (558, 305, (SELECT nbpersonnes FROM reservation WHERE numreservation = 558), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (559, 29, (SELECT nbpersonnes FROM reservation WHERE numreservation = 559), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (560, 236, (SELECT nbpersonnes FROM reservation WHERE numreservation = 560), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (560, 222, (SELECT nbpersonnes FROM reservation WHERE numreservation = 560), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (561, 237, (SELECT nbpersonnes FROM reservation WHERE numreservation = 561), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (562, 229, (SELECT nbpersonnes FROM reservation WHERE numreservation = 562), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (562, 14, (SELECT nbpersonnes FROM reservation WHERE numreservation = 562), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (564, 243, (SELECT nbpersonnes FROM reservation WHERE numreservation = 564), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (564, 337, (SELECT nbpersonnes FROM reservation WHERE numreservation = 564), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (565, 210, (SELECT nbpersonnes FROM reservation WHERE numreservation = 565), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (565, 247, (SELECT nbpersonnes FROM reservation WHERE numreservation = 565), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (566, 343, (SELECT nbpersonnes FROM reservation WHERE numreservation = 566), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (566, 328, (SELECT nbpersonnes FROM reservation WHERE numreservation = 566), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (567, 17, (SELECT nbpersonnes FROM reservation WHERE numreservation = 567), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (568, 316, (SELECT nbpersonnes FROM reservation WHERE numreservation = 568), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (568, 321, (SELECT nbpersonnes FROM reservation WHERE numreservation = 568), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (569, 214, (SELECT nbpersonnes FROM reservation WHERE numreservation = 569), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (570, 307, (SELECT nbpersonnes FROM reservation WHERE numreservation = 570), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (570, 248, (SELECT nbpersonnes FROM reservation WHERE numreservation = 570), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (571, 315, (SELECT nbpersonnes FROM reservation WHERE numreservation = 571), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (571, 314, (SELECT nbpersonnes FROM reservation WHERE numreservation = 571), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (572, 303, (SELECT nbpersonnes FROM reservation WHERE numreservation = 572), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (572, 311, (SELECT nbpersonnes FROM reservation WHERE numreservation = 572), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (573, 319, (SELECT nbpersonnes FROM reservation WHERE numreservation = 573), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (574, 9, (SELECT nbpersonnes FROM reservation WHERE numreservation = 574), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (574, 208, (SELECT nbpersonnes FROM reservation WHERE numreservation = 574), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (575, 217, (SELECT nbpersonnes FROM reservation WHERE numreservation = 575), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (575, 18, (SELECT nbpersonnes FROM reservation WHERE numreservation = 575), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (576, 309, (SELECT nbpersonnes FROM reservation WHERE numreservation = 576), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (576, 331, (SELECT nbpersonnes FROM reservation WHERE numreservation = 576), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (577, 205, (SELECT nbpersonnes FROM reservation WHERE numreservation = 577), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (578, 327, (SELECT nbpersonnes FROM reservation WHERE numreservation = 578), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (578, 317, (SELECT nbpersonnes FROM reservation WHERE numreservation = 578), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (579, 221, (SELECT nbpersonnes FROM reservation WHERE numreservation = 579), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (580, 3, (SELECT nbpersonnes FROM reservation WHERE numreservation = 580), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (581, 242, (SELECT nbpersonnes FROM reservation WHERE numreservation = 581), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (581, 211, (SELECT nbpersonnes FROM reservation WHERE numreservation = 581), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (582, 249, (SELECT nbpersonnes FROM reservation WHERE numreservation = 582), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (582, 308, (SELECT nbpersonnes FROM reservation WHERE numreservation = 582), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (583, 7, (SELECT nbpersonnes FROM reservation WHERE numreservation = 583), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (584, 201, (SELECT nbpersonnes FROM reservation WHERE numreservation = 584), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (585, 21, (SELECT nbpersonnes FROM reservation WHERE numreservation = 585), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (586, 312, (SELECT nbpersonnes FROM reservation WHERE numreservation = 586), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (586, 323, (SELECT nbpersonnes FROM reservation WHERE numreservation = 586), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (587, 324, (SELECT nbpersonnes FROM reservation WHERE numreservation = 587), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (588, 244, (SELECT nbpersonnes FROM reservation WHERE numreservation = 588), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (589, 207, (SELECT nbpersonnes FROM reservation WHERE numreservation = 589), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (589, 4, (SELECT nbpersonnes FROM reservation WHERE numreservation = 589), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (590, 213, (SELECT nbpersonnes FROM reservation WHERE numreservation = 590), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (591, 5, (SELECT nbpersonnes FROM reservation WHERE numreservation = 591), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (591, 226, (SELECT nbpersonnes FROM reservation WHERE numreservation = 591), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (592, 240, (SELECT nbpersonnes FROM reservation WHERE numreservation = 592), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (592, 302, (SELECT nbpersonnes FROM reservation WHERE numreservation = 592), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (593, 322, (SELECT nbpersonnes FROM reservation WHERE numreservation = 593), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (593, 239, (SELECT nbpersonnes FROM reservation WHERE numreservation = 593), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (594, 310, (SELECT nbpersonnes FROM reservation WHERE numreservation = 594), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (594, 10, (SELECT nbpersonnes FROM reservation WHERE numreservation = 594), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (595, 332, (SELECT nbpersonnes FROM reservation WHERE numreservation = 595), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (595, 23, (SELECT nbpersonnes FROM reservation WHERE numreservation = 595), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (596, 348, (SELECT nbpersonnes FROM reservation WHERE numreservation = 596), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (596, 228, (SELECT nbpersonnes FROM reservation WHERE numreservation = 596), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (597, 329, (SELECT nbpersonnes FROM reservation WHERE numreservation = 597), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (597, 240, (SELECT nbpersonnes FROM reservation WHERE numreservation = 597), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (598, 220, (SELECT nbpersonnes FROM reservation WHERE numreservation = 598), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (598, 320, (SELECT nbpersonnes FROM reservation WHERE numreservation = 598), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (599, 306, (SELECT nbpersonnes FROM reservation WHERE numreservation = 599), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (599, 12, (SELECT nbpersonnes FROM reservation WHERE numreservation = 599), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (600, 22, (SELECT nbpersonnes FROM reservation WHERE numreservation = 600), false, NULL, NULL);
INSERT INTO reservation_activite VALUES (600, 230, (SELECT nbpersonnes FROM reservation WHERE numreservation = 600), false, NULL, NULL);

-- type_chambre_equipement
INSERT INTO type_chambre_equipement VALUES (2, 5);
INSERT INTO type_chambre_equipement VALUES (4, 5);
INSERT INTO type_chambre_equipement VALUES (6, 5);
INSERT INTO type_chambre_equipement VALUES (8, 5);
INSERT INTO type_chambre_equipement VALUES (9, 5);
INSERT INTO type_chambre_equipement VALUES (1, 6);
INSERT INTO type_chambre_equipement VALUES (12, 6);
INSERT INTO type_chambre_equipement VALUES (3, 6);
INSERT INTO type_chambre_equipement VALUES (7, 6);
INSERT INTO type_chambre_equipement VALUES (2, 6);
INSERT INTO type_chambre_equipement VALUES (1, 7);
INSERT INTO type_chambre_equipement VALUES (8, 7);
INSERT INTO type_chambre_equipement VALUES (2, 7);
INSERT INTO type_chambre_equipement VALUES (7, 7);
INSERT INTO type_chambre_equipement VALUES (12, 8);
INSERT INTO type_chambre_equipement VALUES (10, 8);
INSERT INTO type_chambre_equipement VALUES (6, 8);
INSERT INTO type_chambre_equipement VALUES (11, 8);
INSERT INTO type_chambre_equipement VALUES (8, 9);
INSERT INTO type_chambre_equipement VALUES (6, 9);
INSERT INTO type_chambre_equipement VALUES (10, 9);
INSERT INTO type_chambre_equipement VALUES (1, 9);
INSERT INTO type_chambre_equipement VALUES (3, 9);
INSERT INTO type_chambre_equipement VALUES (8, 10);
INSERT INTO type_chambre_equipement VALUES (2, 10);
INSERT INTO type_chambre_equipement VALUES (3, 10);
INSERT INTO type_chambre_equipement VALUES (10, 10);
INSERT INTO type_chambre_equipement VALUES (11, 10);
INSERT INTO type_chambre_equipement VALUES (5, 11);
INSERT INTO type_chambre_equipement VALUES (6, 11);
INSERT INTO type_chambre_equipement VALUES (7, 11);
INSERT INTO type_chambre_equipement VALUES (4, 11);
INSERT INTO type_chambre_equipement VALUES (8, 11);
INSERT INTO type_chambre_equipement VALUES (2, 12);
INSERT INTO type_chambre_equipement VALUES (9, 12);
INSERT INTO type_chambre_equipement VALUES (1, 12);
INSERT INTO type_chambre_equipement VALUES (10, 13);
INSERT INTO type_chambre_equipement VALUES (7, 13);
INSERT INTO type_chambre_equipement VALUES (3, 13);
INSERT INTO type_chambre_equipement VALUES (2, 13);
INSERT INTO type_chambre_equipement VALUES (12, 13);
INSERT INTO type_chambre_equipement VALUES (5, 14);
INSERT INTO type_chambre_equipement VALUES (4, 14);
INSERT INTO type_chambre_equipement VALUES (7, 14);
INSERT INTO type_chambre_equipement VALUES (2, 14);
INSERT INTO type_chambre_equipement VALUES (8, 15);
INSERT INTO type_chambre_equipement VALUES (6, 15);
INSERT INTO type_chambre_equipement VALUES (12, 15);
INSERT INTO type_chambre_equipement VALUES (5, 15);
INSERT INTO type_chambre_equipement VALUES (5, 16);
INSERT INTO type_chambre_equipement VALUES (8, 16);
INSERT INTO type_chambre_equipement VALUES (3, 17);
INSERT INTO type_chambre_equipement VALUES (9, 17);
INSERT INTO type_chambre_equipement VALUES (10, 18);
INSERT INTO type_chambre_equipement VALUES (12, 18);
INSERT INTO type_chambre_equipement VALUES (5, 18);
INSERT INTO type_chambre_equipement VALUES (12, 19);
INSERT INTO type_chambre_equipement VALUES (10, 19);
INSERT INTO type_chambre_equipement VALUES (3, 19);
INSERT INTO type_chambre_equipement VALUES (10, 20);
INSERT INTO type_chambre_equipement VALUES (3, 20);
INSERT INTO type_chambre_equipement VALUES (11, 20);
INSERT INTO type_chambre_equipement VALUES (12, 20);
INSERT INTO type_chambre_equipement VALUES (5, 21);
INSERT INTO type_chambre_equipement VALUES (12, 22);
INSERT INTO type_chambre_equipement VALUES (1, 22);
INSERT INTO type_chambre_equipement VALUES (7, 23);
INSERT INTO type_chambre_equipement VALUES (8, 23);
INSERT INTO type_chambre_equipement VALUES (10, 23);
INSERT INTO type_chambre_equipement VALUES (1, 23);
INSERT INTO type_chambre_equipement VALUES (7, 24);
INSERT INTO type_chambre_equipement VALUES (1, 24);
INSERT INTO type_chambre_equipement VALUES (11, 24);
INSERT INTO type_chambre_equipement VALUES (10, 24);
INSERT INTO type_chambre_equipement VALUES (3, 25);
INSERT INTO type_chambre_equipement VALUES (7, 25);
INSERT INTO type_chambre_equipement VALUES (4, 25);
INSERT INTO type_chambre_equipement VALUES (12, 25);
INSERT INTO type_chambre_equipement VALUES (8, 26);
INSERT INTO type_chambre_equipement VALUES (2, 26);
INSERT INTO type_chambre_equipement VALUES (12, 26);
INSERT INTO type_chambre_equipement VALUES (7, 26);
INSERT INTO type_chambre_equipement VALUES (2, 27);
INSERT INTO type_chambre_equipement VALUES (3, 27);
INSERT INTO type_chambre_equipement VALUES (2, 30);
INSERT INTO type_chambre_equipement VALUES (3, 30);
INSERT INTO type_chambre_equipement VALUES (9, 30);
INSERT INTO type_chambre_equipement VALUES (7, 30);
INSERT INTO type_chambre_equipement VALUES (7, 31);
INSERT INTO type_chambre_equipement VALUES (10, 31);
INSERT INTO type_chambre_equipement VALUES (12, 31);
INSERT INTO type_chambre_equipement VALUES (2, 31);
INSERT INTO type_chambre_equipement VALUES (10, 32);
INSERT INTO type_chambre_equipement VALUES (6, 32);
INSERT INTO type_chambre_equipement VALUES (5, 33);
INSERT INTO type_chambre_equipement VALUES (4, 33);
INSERT INTO type_chambre_equipement VALUES (9, 33);
INSERT INTO type_chambre_equipement VALUES (12, 34);
INSERT INTO type_chambre_equipement VALUES (2, 34);
INSERT INTO type_chambre_equipement VALUES (1, 34);
INSERT INTO type_chambre_equipement VALUES (10, 34);
INSERT INTO type_chambre_equipement VALUES (1, 35);
INSERT INTO type_chambre_equipement VALUES (8, 35);
INSERT INTO type_chambre_equipement VALUES (12, 36);
INSERT INTO type_chambre_equipement VALUES (5, 36);
INSERT INTO type_chambre_equipement VALUES (10, 36);
INSERT INTO type_chambre_equipement VALUES (5, 37);
INSERT INTO type_chambre_equipement VALUES (7, 37);
INSERT INTO type_chambre_equipement VALUES (4, 37);
INSERT INTO type_chambre_equipement VALUES (1, 37);
INSERT INTO type_chambre_equipement VALUES (10, 37);
INSERT INTO type_chambre_equipement VALUES (9, 38);
INSERT INTO type_chambre_equipement VALUES (12, 38);
INSERT INTO type_chambre_equipement VALUES (10, 38);
INSERT INTO type_chambre_equipement VALUES (1, 38);
INSERT INTO type_chambre_equipement VALUES (5, 38);
INSERT INTO type_chambre_equipement VALUES (9, 39);
INSERT INTO type_chambre_equipement VALUES (3, 39);
INSERT INTO type_chambre_equipement VALUES (8, 39);
INSERT INTO type_chambre_equipement VALUES (12, 39);
INSERT INTO type_chambre_equipement VALUES (6, 39);
INSERT INTO type_chambre_equipement VALUES (2, 40);
INSERT INTO type_chambre_equipement VALUES (5, 40);
INSERT INTO type_chambre_equipement VALUES (6, 40);
INSERT INTO type_chambre_equipement VALUES (12, 40);
INSERT INTO type_chambre_equipement VALUES (10, 41);
INSERT INTO type_chambre_equipement VALUES (5, 41);
INSERT INTO type_chambre_equipement VALUES (12, 41);
INSERT INTO type_chambre_equipement VALUES (3, 41);
INSERT INTO type_chambre_equipement VALUES (1, 42);
INSERT INTO type_chambre_equipement VALUES (2, 42);
INSERT INTO type_chambre_equipement VALUES (6, 42);
INSERT INTO type_chambre_equipement VALUES (8, 42);
INSERT INTO type_chambre_equipement VALUES (9, 42);
INSERT INTO type_chambre_equipement VALUES (8, 43);
INSERT INTO type_chambre_equipement VALUES (6, 43);
INSERT INTO type_chambre_equipement VALUES (9, 44);
INSERT INTO type_chambre_equipement VALUES (10, 44);
INSERT INTO type_chambre_equipement VALUES (11, 44);
INSERT INTO type_chambre_equipement VALUES (1, 44);
INSERT INTO type_chambre_equipement VALUES (12, 45);
INSERT INTO type_chambre_equipement VALUES (10, 45);
INSERT INTO type_chambre_equipement VALUES (3, 45);
INSERT INTO type_chambre_equipement VALUES (5, 46);
INSERT INTO type_chambre_equipement VALUES (12, 46);
INSERT INTO type_chambre_equipement VALUES (1, 46);
INSERT INTO type_chambre_equipement VALUES (10, 46);
INSERT INTO type_chambre_equipement VALUES (7, 46);
INSERT INTO type_chambre_equipement VALUES (5, 47);
INSERT INTO type_chambre_equipement VALUES (6, 47);
INSERT INTO type_chambre_equipement VALUES (8, 48);
INSERT INTO type_chambre_equipement VALUES (1, 48);
INSERT INTO type_chambre_equipement VALUES (12, 48);
INSERT INTO type_chambre_equipement VALUES (10, 49);
INSERT INTO type_chambre_equipement VALUES (1, 49);
INSERT INTO type_chambre_equipement VALUES (11, 49);
INSERT INTO type_chambre_equipement VALUES (9, 49);
INSERT INTO type_chambre_equipement VALUES (2, 50);
INSERT INTO type_chambre_equipement VALUES (5, 50);
INSERT INTO type_chambre_equipement VALUES (10, 50);
INSERT INTO type_chambre_equipement VALUES (3, 50);
INSERT INTO type_chambre_equipement VALUES (8, 51);
INSERT INTO type_chambre_equipement VALUES (6, 51);
INSERT INTO type_chambre_equipement VALUES (3, 51);
INSERT INTO type_chambre_equipement VALUES (10, 51);
INSERT INTO type_chambre_equipement VALUES (12, 51);
INSERT INTO type_chambre_equipement VALUES (10, 52);
INSERT INTO type_chambre_equipement VALUES (5, 53);
INSERT INTO type_chambre_equipement VALUES (11, 53);
INSERT INTO type_chambre_equipement VALUES (10, 53);
INSERT INTO type_chambre_equipement VALUES (9, 54);
INSERT INTO type_chambre_equipement VALUES (3, 54);
INSERT INTO type_chambre_equipement VALUES (12, 54);
INSERT INTO type_chambre_equipement VALUES (5, 54);
INSERT INTO type_chambre_equipement VALUES (10, 55);
INSERT INTO type_chambre_equipement VALUES (3, 55);
INSERT INTO type_chambre_equipement VALUES (11, 55);
INSERT INTO type_chambre_equipement VALUES (9, 55);
INSERT INTO type_chambre_equipement VALUES (5, 55);
INSERT INTO type_chambre_equipement VALUES (12, 56);
INSERT INTO type_chambre_equipement VALUES (5, 56);
INSERT INTO type_chambre_equipement VALUES (10, 56);
INSERT INTO type_chambre_equipement VALUES (3, 56);
INSERT INTO type_chambre_equipement VALUES (1, 57);
INSERT INTO type_chambre_equipement VALUES (12, 57);
INSERT INTO type_chambre_equipement VALUES (5, 57);
INSERT INTO type_chambre_equipement VALUES (7, 57);
INSERT INTO type_chambre_equipement VALUES (10, 57);
INSERT INTO type_chambre_equipement VALUES (2, 58);
INSERT INTO type_chambre_equipement VALUES (10, 59);
INSERT INTO type_chambre_equipement VALUES (3, 59);
INSERT INTO type_chambre_equipement VALUES (11, 59);
INSERT INTO type_chambre_equipement VALUES (5, 59);
INSERT INTO type_chambre_equipement VALUES (2, 60);
INSERT INTO type_chambre_equipement VALUES (7, 60);
INSERT INTO type_chambre_equipement VALUES (9, 60);
INSERT INTO type_chambre_equipement VALUES (12, 60);
INSERT INTO type_chambre_equipement VALUES (8, 61);
INSERT INTO type_chambre_equipement VALUES (10, 61);
INSERT INTO type_chambre_equipement VALUES (5, 62);
INSERT INTO type_chambre_equipement VALUES (12, 62);
INSERT INTO type_chambre_equipement VALUES (2, 62);
INSERT INTO type_chambre_equipement VALUES (3, 62);
INSERT INTO type_chambre_equipement VALUES (2, 63);
INSERT INTO type_chambre_equipement VALUES (6, 63);
INSERT INTO type_chambre_equipement VALUES (1, 63);
INSERT INTO type_chambre_equipement VALUES (9, 64);
INSERT INTO type_chambre_equipement VALUES (8, 64);
INSERT INTO type_chambre_equipement VALUES (6, 64);
INSERT INTO type_chambre_equipement VALUES (3, 64);
INSERT INTO type_chambre_equipement VALUES (8, 65);
INSERT INTO type_chambre_equipement VALUES (10, 65);
INSERT INTO type_chambre_equipement VALUES (2, 65);
INSERT INTO type_chambre_equipement VALUES (5, 65);
INSERT INTO type_chambre_equipement VALUES (6, 65);
INSERT INTO type_chambre_equipement VALUES (12, 66);
INSERT INTO type_chambre_equipement VALUES (5, 66);
INSERT INTO type_chambre_equipement VALUES (10, 66);
INSERT INTO type_chambre_equipement VALUES (11, 66);
INSERT INTO type_chambre_equipement VALUES (1, 67);
INSERT INTO type_chambre_equipement VALUES (8, 67);
INSERT INTO type_chambre_equipement VALUES (5, 67);
INSERT INTO type_chambre_equipement VALUES (7, 67);
INSERT INTO type_chambre_equipement VALUES (6, 67);
INSERT INTO type_chambre_equipement VALUES (5, 68);
INSERT INTO type_chambre_equipement VALUES (1, 68);
INSERT INTO type_chambre_equipement VALUES (10, 68);
INSERT INTO type_chambre_equipement VALUES (10, 69);
INSERT INTO type_chambre_equipement VALUES (2, 69);
INSERT INTO type_chambre_equipement VALUES (3, 69);
INSERT INTO type_chambre_equipement VALUES (5, 69);
INSERT INTO type_chambre_equipement VALUES (9, 69);
INSERT INTO type_chambre_equipement VALUES (7, 70);
INSERT INTO type_chambre_equipement VALUES (12, 70);
INSERT INTO type_chambre_equipement VALUES (4, 70);
INSERT INTO type_chambre_equipement VALUES (3, 70);
INSERT INTO type_chambre_equipement VALUES (7, 71);
INSERT INTO type_chambre_equipement VALUES (10, 71);
INSERT INTO type_chambre_equipement VALUES (8, 72);
INSERT INTO type_chambre_equipement VALUES (2, 72);
INSERT INTO type_chambre_equipement VALUES (1, 72);
INSERT INTO type_chambre_equipement VALUES (10, 72);
INSERT INTO type_chambre_equipement VALUES (5, 73);
INSERT INTO type_chambre_equipement VALUES (4, 73);
INSERT INTO type_chambre_equipement VALUES (1, 73);
INSERT INTO type_chambre_equipement VALUES (10, 73);
INSERT INTO type_chambre_equipement VALUES (9, 74);
INSERT INTO type_chambre_equipement VALUES (3, 74);
INSERT INTO type_chambre_equipement VALUES (10, 74);
INSERT INTO type_chambre_equipement VALUES (11, 74);
INSERT INTO type_chambre_equipement VALUES (5, 75);
INSERT INTO type_chambre_equipement VALUES (4, 75);
INSERT INTO type_chambre_equipement VALUES (2, 75);
INSERT INTO type_chambre_equipement VALUES (5, 76);
INSERT INTO type_chambre_equipement VALUES (12, 76);
INSERT INTO type_chambre_equipement VALUES (1, 76);
INSERT INTO type_chambre_equipement VALUES (2, 76);
INSERT INTO type_chambre_equipement VALUES (4, 76);
INSERT INTO type_chambre_equipement VALUES (9, 77);
INSERT INTO type_chambre_equipement VALUES (1, 77);
INSERT INTO type_chambre_equipement VALUES (2, 77);
INSERT INTO type_chambre_equipement VALUES (3, 77);
INSERT INTO type_chambre_equipement VALUES (7, 77);
INSERT INTO type_chambre_equipement VALUES (9, 78);
INSERT INTO type_chambre_equipement VALUES (5, 78);
INSERT INTO type_chambre_equipement VALUES (12, 78);
INSERT INTO type_chambre_equipement VALUES (3, 78);
INSERT INTO type_chambre_equipement VALUES (1, 78);
INSERT INTO type_chambre_equipement VALUES (10, 79);
INSERT INTO type_chambre_equipement VALUES (10, 80);
INSERT INTO type_chambre_equipement VALUES (3, 80);
INSERT INTO type_chambre_equipement VALUES (8, 80);
INSERT INTO type_chambre_equipement VALUES (5, 80);
INSERT INTO type_chambre_equipement VALUES (10, 81);
INSERT INTO type_chambre_equipement VALUES (6, 81);
INSERT INTO type_chambre_equipement VALUES (7, 81);
INSERT INTO type_chambre_equipement VALUES (9, 81);
INSERT INTO type_chambre_equipement VALUES (12, 81);
INSERT INTO type_chambre_equipement VALUES (10, 82);
INSERT INTO type_chambre_equipement VALUES (7, 82);
INSERT INTO type_chambre_equipement VALUES (9, 82);
INSERT INTO type_chambre_equipement VALUES (6, 82);
INSERT INTO type_chambre_equipement VALUES (2, 82);
INSERT INTO type_chambre_equipement VALUES (10, 83);
INSERT INTO type_chambre_equipement VALUES (7, 83);
INSERT INTO type_chambre_equipement VALUES (4, 83);
INSERT INTO type_chambre_equipement VALUES (9, 83);
INSERT INTO type_chambre_equipement VALUES (12, 83);
INSERT INTO type_chambre_equipement VALUES (10, 84);
INSERT INTO type_chambre_equipement VALUES (6, 84);
INSERT INTO type_chambre_equipement VALUES (5, 84);
INSERT INTO type_chambre_equipement VALUES (12, 84);
INSERT INTO type_chambre_equipement VALUES (3, 85);
INSERT INTO type_chambre_equipement VALUES (9, 85);
INSERT INTO type_chambre_equipement VALUES (2, 85);
INSERT INTO type_chambre_equipement VALUES (10, 85);
INSERT INTO type_chambre_equipement VALUES (3, 86);
INSERT INTO type_chambre_equipement VALUES (12, 86);
INSERT INTO type_chambre_equipement VALUES (2, 86);
INSERT INTO type_chambre_equipement VALUES (1, 86);
INSERT INTO type_chambre_equipement VALUES (6, 87);
INSERT INTO type_chambre_equipement VALUES (12, 88);
INSERT INTO type_chambre_equipement VALUES (10, 88);
INSERT INTO type_chambre_equipement VALUES (7, 88);
INSERT INTO type_chambre_equipement VALUES (6, 88);
INSERT INTO type_chambre_equipement VALUES (7, 89);
INSERT INTO type_chambre_equipement VALUES (4, 89);
INSERT INTO type_chambre_equipement VALUES (12, 89);
INSERT INTO type_chambre_equipement VALUES (6, 90);
INSERT INTO type_chambre_equipement VALUES (8, 90);
INSERT INTO type_chambre_equipement VALUES (5, 90);
INSERT INTO type_chambre_equipement VALUES (9, 90);
INSERT INTO type_chambre_equipement VALUES (10, 91);
INSERT INTO type_chambre_equipement VALUES (7, 91);
INSERT INTO type_chambre_equipement VALUES (1, 92);
INSERT INTO type_chambre_equipement VALUES (7, 92);
INSERT INTO type_chambre_equipement VALUES (6, 92);
INSERT INTO type_chambre_equipement VALUES (12, 92);
INSERT INTO type_chambre_equipement VALUES (2, 92);
INSERT INTO type_chambre_equipement VALUES (2, 93);
INSERT INTO type_chambre_equipement VALUES (6, 93);
INSERT INTO type_chambre_equipement VALUES (1, 93);
INSERT INTO type_chambre_equipement VALUES (3, 93);
INSERT INTO type_chambre_equipement VALUES (3, 94);
INSERT INTO type_chambre_equipement VALUES (1, 94);
INSERT INTO type_chambre_equipement VALUES (10, 94);
INSERT INTO type_chambre_equipement VALUES (9, 94);
INSERT INTO type_chambre_equipement VALUES (3, 95);
INSERT INTO type_chambre_equipement VALUES (1, 95);
INSERT INTO type_chambre_equipement VALUES (12, 95);
INSERT INTO type_chambre_equipement VALUES (2, 96);
INSERT INTO type_chambre_equipement VALUES (12, 96);
INSERT INTO type_chambre_equipement VALUES (1, 97);
INSERT INTO type_chambre_equipement VALUES (12, 97);
INSERT INTO type_chambre_equipement VALUES (10, 97);
INSERT INTO type_chambre_equipement VALUES (11, 97);
INSERT INTO type_chambre_equipement VALUES (12, 98);
INSERT INTO type_chambre_equipement VALUES (10, 98);
INSERT INTO type_chambre_equipement VALUES (9, 98);
INSERT INTO type_chambre_equipement VALUES (1, 99);
INSERT INTO type_chambre_equipement VALUES (3, 99);
INSERT INTO type_chambre_equipement VALUES (10, 100);
INSERT INTO type_chambre_equipement VALUES (3, 100);
INSERT INTO type_chambre_equipement VALUES (2, 100);
INSERT INTO type_chambre_equipement VALUES (12, 100);
INSERT INTO type_chambre_equipement VALUES (7, 101);
INSERT INTO type_chambre_equipement VALUES (9, 101);
INSERT INTO type_chambre_equipement VALUES (5, 102);
INSERT INTO type_chambre_equipement VALUES (7, 102);
INSERT INTO type_chambre_equipement VALUES (3, 102);
INSERT INTO type_chambre_equipement VALUES (10, 103);
INSERT INTO type_chambre_equipement VALUES (11, 103);
INSERT INTO type_chambre_equipement VALUES (3, 103);
INSERT INTO type_chambre_equipement VALUES (9, 103);
INSERT INTO type_chambre_equipement VALUES (1, 104);
INSERT INTO type_chambre_equipement VALUES (3, 104);
INSERT INTO type_chambre_equipement VALUES (6, 104);
INSERT INTO type_chambre_equipement VALUES (7, 104);
INSERT INTO type_chambre_equipement VALUES (3, 105);
INSERT INTO type_chambre_equipement VALUES (7, 105);
INSERT INTO type_chambre_equipement VALUES (10, 105);
INSERT INTO type_chambre_equipement VALUES (11, 105);
INSERT INTO type_chambre_equipement VALUES (9, 106);
INSERT INTO type_chambre_equipement VALUES (10, 106);
INSERT INTO type_chambre_equipement VALUES (5, 106);
INSERT INTO type_chambre_equipement VALUES (10, 107);
INSERT INTO type_chambre_equipement VALUES (5, 107);
INSERT INTO type_chambre_equipement VALUES (4, 107);
INSERT INTO type_chambre_equipement VALUES (11, 107);
INSERT INTO type_chambre_equipement VALUES (9, 108);
INSERT INTO type_chambre_equipement VALUES (3, 108);
INSERT INTO type_chambre_equipement VALUES (2, 109);
INSERT INTO type_chambre_equipement VALUES (10, 109);
INSERT INTO type_chambre_equipement VALUES (5, 109);
INSERT INTO type_chambre_equipement VALUES (4, 109);
INSERT INTO type_chambre_equipement VALUES (10, 110);
INSERT INTO type_chambre_equipement VALUES (3, 110);
INSERT INTO type_chambre_equipement VALUES (7, 110);
INSERT INTO type_chambre_equipement VALUES (5, 110);
INSERT INTO type_chambre_equipement VALUES (2, 111);
INSERT INTO type_chambre_equipement VALUES (10, 112);
INSERT INTO type_chambre_equipement VALUES (5, 112);
INSERT INTO type_chambre_equipement VALUES (12, 112);
INSERT INTO type_chambre_equipement VALUES (2, 112);
INSERT INTO type_chambre_equipement VALUES (2, 113);
INSERT INTO type_chambre_equipement VALUES (10, 113);
INSERT INTO type_chambre_equipement VALUES (5, 113);
INSERT INTO type_chambre_equipement VALUES (6, 113);
INSERT INTO type_chambre_equipement VALUES (1, 113);
INSERT INTO type_chambre_equipement VALUES (2, 114);
INSERT INTO type_chambre_equipement VALUES (10, 114);
INSERT INTO type_chambre_equipement VALUES (12, 114);
INSERT INTO type_chambre_equipement VALUES (9, 114);
INSERT INTO type_chambre_equipement VALUES (3, 115);
INSERT INTO type_chambre_equipement VALUES (6, 115);
INSERT INTO type_chambre_equipement VALUES (7, 116);
INSERT INTO type_chambre_equipement VALUES (5, 116);
INSERT INTO type_chambre_equipement VALUES (12, 116);
INSERT INTO type_chambre_equipement VALUES (4, 116);
INSERT INTO type_chambre_equipement VALUES (3, 117);
INSERT INTO type_chambre_equipement VALUES (9, 117);
INSERT INTO type_chambre_equipement VALUES (10, 117);
INSERT INTO type_chambre_equipement VALUES (5, 117);
INSERT INTO type_chambre_equipement VALUES (4, 117);
INSERT INTO type_chambre_equipement VALUES (9, 118);
INSERT INTO type_chambre_equipement VALUES (1, 118);
INSERT INTO type_chambre_equipement VALUES (2, 118);
INSERT INTO type_chambre_equipement VALUES (10, 119);
INSERT INTO type_chambre_equipement VALUES (9, 119);
INSERT INTO type_chambre_equipement VALUES (2, 120);
INSERT INTO type_chambre_equipement VALUES (3, 120);
INSERT INTO type_chambre_equipement VALUES (1, 120);
INSERT INTO type_chambre_equipement VALUES (10, 120);
INSERT INTO type_chambre_equipement VALUES (2, 121);
INSERT INTO type_chambre_equipement VALUES (7, 121);
INSERT INTO type_chambre_equipement VALUES (10, 121);
INSERT INTO type_chambre_equipement VALUES (10, 122);
INSERT INTO type_chambre_equipement VALUES (3, 122);
INSERT INTO type_chambre_equipement VALUES (12, 122);
INSERT INTO type_chambre_equipement VALUES (10, 123);
INSERT INTO type_chambre_equipement VALUES (7, 123);
INSERT INTO type_chambre_equipement VALUES (9, 123);
INSERT INTO type_chambre_equipement VALUES (5, 123);
INSERT INTO type_chambre_equipement VALUES (6, 123);
INSERT INTO type_chambre_equipement VALUES (6, 124);
INSERT INTO type_chambre_equipement VALUES (7, 124);
INSERT INTO type_chambre_equipement VALUES (5, 124);
INSERT INTO type_chambre_equipement VALUES (10, 124);
INSERT INTO type_chambre_equipement VALUES (9, 125);
INSERT INTO type_chambre_equipement VALUES (6, 126);
INSERT INTO type_chambre_equipement VALUES (8, 126);
INSERT INTO type_chambre_equipement VALUES (9, 126);
INSERT INTO type_chambre_equipement VALUES (5, 126);
INSERT INTO type_chambre_equipement VALUES (4, 126);
INSERT INTO type_chambre_equipement VALUES (2, 127);
INSERT INTO type_chambre_equipement VALUES (3, 127);
INSERT INTO type_chambre_equipement VALUES (1, 127);
INSERT INTO type_chambre_equipement VALUES (5, 127);
INSERT INTO type_chambre_equipement VALUES (9, 128);
INSERT INTO type_chambre_equipement VALUES (5, 128);
INSERT INTO type_chambre_equipement VALUES (12, 128);
INSERT INTO type_chambre_equipement VALUES (6, 128);
INSERT INTO type_chambre_equipement VALUES (2, 128);
INSERT INTO type_chambre_equipement VALUES (2, 129);
INSERT INTO type_chambre_equipement VALUES (3, 129);
INSERT INTO type_chambre_equipement VALUES (6, 129);
INSERT INTO type_chambre_equipement VALUES (9, 129);
INSERT INTO type_chambre_equipement VALUES (2, 130);
INSERT INTO type_chambre_equipement VALUES (10, 130);
INSERT INTO type_chambre_equipement VALUES (11, 130);
INSERT INTO type_chambre_equipement VALUES (5, 130);
INSERT INTO type_chambre_equipement VALUES (3, 131);
INSERT INTO type_chambre_equipement VALUES (1, 131);
INSERT INTO type_chambre_equipement VALUES (10, 131);
INSERT INTO type_chambre_equipement VALUES (12, 131);
INSERT INTO type_chambre_equipement VALUES (7, 131);
INSERT INTO type_chambre_equipement VALUES (10, 132);
INSERT INTO type_chambre_equipement VALUES (1, 132);
INSERT INTO type_chambre_equipement VALUES (7, 132);
INSERT INTO type_chambre_equipement VALUES (5, 132);
INSERT INTO type_chambre_equipement VALUES (9, 133);
INSERT INTO type_chambre_equipement VALUES (2, 133);
INSERT INTO type_chambre_equipement VALUES (1, 134);
INSERT INTO type_chambre_equipement VALUES (12, 134);
INSERT INTO type_chambre_equipement VALUES (2, 134);
INSERT INTO type_chambre_equipement VALUES (5, 134);
INSERT INTO type_chambre_equipement VALUES (6, 135);
INSERT INTO type_chambre_equipement VALUES (10, 135);
INSERT INTO type_chambre_equipement VALUES (9, 135);
INSERT INTO type_chambre_equipement VALUES (11, 135);
INSERT INTO type_chambre_equipement VALUES (12, 136);
INSERT INTO type_chambre_equipement VALUES (10, 136);
INSERT INTO type_chambre_equipement VALUES (2, 136);
INSERT INTO type_chambre_equipement VALUES (1, 136);
INSERT INTO type_chambre_equipement VALUES (7, 136);
INSERT INTO type_chambre_equipement VALUES (7, 137);
INSERT INTO type_chambre_equipement VALUES (9, 137);
INSERT INTO type_chambre_equipement VALUES (1, 137);
INSERT INTO type_chambre_equipement VALUES (5, 137);
INSERT INTO type_chambre_equipement VALUES (5, 138);
INSERT INTO type_chambre_equipement VALUES (1, 138);
INSERT INTO type_chambre_equipement VALUES (12, 138);
INSERT INTO type_chambre_equipement VALUES (10, 139);
INSERT INTO type_chambre_equipement VALUES (9, 139);
INSERT INTO type_chambre_equipement VALUES (1, 140);
INSERT INTO type_chambre_equipement VALUES (12, 140);
INSERT INTO type_chambre_equipement VALUES (2, 140);
INSERT INTO type_chambre_equipement VALUES (10, 140);
INSERT INTO type_chambre_equipement VALUES (10, 141);
INSERT INTO type_chambre_equipement VALUES (5, 141);
INSERT INTO type_chambre_equipement VALUES (6, 142);
INSERT INTO type_chambre_equipement VALUES (5, 142);
INSERT INTO type_chambre_equipement VALUES (6, 143);
INSERT INTO type_chambre_equipement VALUES (9, 143);
INSERT INTO type_chambre_equipement VALUES (10, 143);
INSERT INTO type_chambre_equipement VALUES (2, 143);
INSERT INTO type_chambre_equipement VALUES (8, 143);
INSERT INTO type_chambre_equipement VALUES (2, 144);
INSERT INTO type_chambre_equipement VALUES (12, 144);
INSERT INTO type_chambre_equipement VALUES (10, 144);
INSERT INTO type_chambre_equipement VALUES (5, 144);
INSERT INTO type_chambre_equipement VALUES (12, 145);
INSERT INTO type_chambre_equipement VALUES (5, 145);
INSERT INTO type_chambre_equipement VALUES (5, 146);
INSERT INTO type_chambre_equipement VALUES (7, 146);
INSERT INTO type_chambre_equipement VALUES (12, 146);
INSERT INTO type_chambre_equipement VALUES (6, 147);
INSERT INTO type_chambre_equipement VALUES (9, 147);
INSERT INTO type_chambre_equipement VALUES (7, 147);
INSERT INTO type_chambre_equipement VALUES (10, 147);
INSERT INTO type_chambre_equipement VALUES (1, 148);
INSERT INTO type_chambre_equipement VALUES (1, 149);
INSERT INTO type_chambre_equipement VALUES (12, 149);
INSERT INTO type_chambre_equipement VALUES (3, 149);
INSERT INTO type_chambre_equipement VALUES (9, 149);
INSERT INTO type_chambre_equipement VALUES (10, 150);
INSERT INTO type_chambre_equipement VALUES (1, 150);
INSERT INTO type_chambre_equipement VALUES (3, 150);
INSERT INTO type_chambre_equipement VALUES (6, 150);
INSERT INTO type_chambre_equipement VALUES (6, 151);
INSERT INTO type_chambre_equipement VALUES (8, 151);
INSERT INTO type_chambre_equipement VALUES (10, 151);
INSERT INTO type_chambre_equipement VALUES (12, 151);
INSERT INTO type_chambre_equipement VALUES (9, 152);
INSERT INTO type_chambre_equipement VALUES (5, 152);
INSERT INTO type_chambre_equipement VALUES (12, 152);
INSERT INTO type_chambre_equipement VALUES (2, 152);
INSERT INTO type_chambre_equipement VALUES (5, 153);
INSERT INTO type_chambre_equipement VALUES (10, 153);
INSERT INTO type_chambre_equipement VALUES (9, 153);
INSERT INTO type_chambre_equipement VALUES (12, 154);
INSERT INTO type_chambre_equipement VALUES (5, 154);
INSERT INTO type_chambre_equipement VALUES (9, 154);
INSERT INTO type_chambre_equipement VALUES (1, 154);
INSERT INTO type_chambre_equipement VALUES (3, 155);
INSERT INTO type_chambre_equipement VALUES (12, 156);
INSERT INTO type_chambre_equipement VALUES (9, 156);
INSERT INTO type_chambre_equipement VALUES (6, 156);
INSERT INTO type_chambre_equipement VALUES (12, 157);
INSERT INTO type_chambre_equipement VALUES (5, 157);
INSERT INTO type_chambre_equipement VALUES (4, 157);
INSERT INTO type_chambre_equipement VALUES (2, 158);
INSERT INTO type_chambre_equipement VALUES (12, 158);
INSERT INTO type_chambre_equipement VALUES (1, 158);
INSERT INTO type_chambre_equipement VALUES (7, 158);
INSERT INTO type_chambre_equipement VALUES (10, 158);

-- type_chambre_pointfort
INSERT INTO type_chambre_pointfort VALUES (1, 1);
INSERT INTO type_chambre_pointfort VALUES (1, 3);
INSERT INTO type_chambre_pointfort VALUES (1, 5);
INSERT INTO type_chambre_pointfort VALUES (3, 7);
INSERT INTO type_chambre_pointfort VALUES (2, 8);
INSERT INTO type_chambre_pointfort VALUES (5, 9);
INSERT INTO type_chambre_pointfort VALUES (4, 10);
INSERT INTO type_chambre_pointfort VALUES (2, 10);
INSERT INTO type_chambre_pointfort VALUES (3, 12);
INSERT INTO type_chambre_pointfort VALUES (1, 14);
INSERT INTO type_chambre_pointfort VALUES (2, 14);
INSERT INTO type_chambre_pointfort VALUES (5, 15);
INSERT INTO type_chambre_pointfort VALUES (4, 15);
INSERT INTO type_chambre_pointfort VALUES (2, 17);
INSERT INTO type_chambre_pointfort VALUES (5, 18);
INSERT INTO type_chambre_pointfort VALUES (3, 19);
INSERT INTO type_chambre_pointfort VALUES (5, 20);
INSERT INTO type_chambre_pointfort VALUES (3, 21);
INSERT INTO type_chambre_pointfort VALUES (2, 22);
INSERT INTO type_chambre_pointfort VALUES (1, 23);
INSERT INTO type_chambre_pointfort VALUES (1, 24);
INSERT INTO type_chambre_pointfort VALUES (1, 25);
INSERT INTO type_chambre_pointfort VALUES (2, 25);
INSERT INTO type_chambre_pointfort VALUES (4, 26);
INSERT INTO type_chambre_pointfort VALUES (2, 26);
INSERT INTO type_chambre_pointfort VALUES (3, 30);
INSERT INTO type_chambre_pointfort VALUES (1, 34);
INSERT INTO type_chambre_pointfort VALUES (5, 34);
INSERT INTO type_chambre_pointfort VALUES (1, 40);
INSERT INTO type_chambre_pointfort VALUES (1, 42);
INSERT INTO type_chambre_pointfort VALUES (2, 43);
INSERT INTO type_chambre_pointfort VALUES (5, 44);
INSERT INTO type_chambre_pointfort VALUES (2, 44);
INSERT INTO type_chambre_pointfort VALUES (5, 45);
INSERT INTO type_chambre_pointfort VALUES (1, 47);
INSERT INTO type_chambre_pointfort VALUES (2, 48);
INSERT INTO type_chambre_pointfort VALUES (1, 48);
INSERT INTO type_chambre_pointfort VALUES (3, 49);
INSERT INTO type_chambre_pointfort VALUES (2, 50);
INSERT INTO type_chambre_pointfort VALUES (5, 50);
INSERT INTO type_chambre_pointfort VALUES (3, 53);
INSERT INTO type_chambre_pointfort VALUES (1, 54);
INSERT INTO type_chambre_pointfort VALUES (1, 56);
INSERT INTO type_chambre_pointfort VALUES (4, 59);
INSERT INTO type_chambre_pointfort VALUES (1, 59);
INSERT INTO type_chambre_pointfort VALUES (5, 60);
INSERT INTO type_chambre_pointfort VALUES (1, 60);
INSERT INTO type_chambre_pointfort VALUES (5, 61);
INSERT INTO type_chambre_pointfort VALUES (3, 62);
INSERT INTO type_chambre_pointfort VALUES (2, 63);
INSERT INTO type_chambre_pointfort VALUES (3, 63);
INSERT INTO type_chambre_pointfort VALUES (5, 65);
INSERT INTO type_chambre_pointfort VALUES (3, 65);
INSERT INTO type_chambre_pointfort VALUES (3, 68);
INSERT INTO type_chambre_pointfort VALUES (2, 69);
INSERT INTO type_chambre_pointfort VALUES (2, 70);
INSERT INTO type_chambre_pointfort VALUES (5, 71);
INSERT INTO type_chambre_pointfort VALUES (3, 74);
INSERT INTO type_chambre_pointfort VALUES (5, 75);
INSERT INTO type_chambre_pointfort VALUES (1, 75);
INSERT INTO type_chambre_pointfort VALUES (2, 77);
INSERT INTO type_chambre_pointfort VALUES (5, 78);
INSERT INTO type_chambre_pointfort VALUES (2, 79);
INSERT INTO type_chambre_pointfort VALUES (3, 79);
INSERT INTO type_chambre_pointfort VALUES (5, 80);
INSERT INTO type_chambre_pointfort VALUES (1, 80);
INSERT INTO type_chambre_pointfort VALUES (4, 82);
INSERT INTO type_chambre_pointfort VALUES (3, 83);
INSERT INTO type_chambre_pointfort VALUES (5, 83);
INSERT INTO type_chambre_pointfort VALUES (5, 84);
INSERT INTO type_chambre_pointfort VALUES (3, 84);
INSERT INTO type_chambre_pointfort VALUES (2, 85);
INSERT INTO type_chambre_pointfort VALUES (2, 86);
INSERT INTO type_chambre_pointfort VALUES (1, 86);
INSERT INTO type_chambre_pointfort VALUES (3, 87);
INSERT INTO type_chambre_pointfort VALUES (4, 90);
INSERT INTO type_chambre_pointfort VALUES (4, 91);
INSERT INTO type_chambre_pointfort VALUES (2, 92);
INSERT INTO type_chambre_pointfort VALUES (5, 92);
INSERT INTO type_chambre_pointfort VALUES (2, 93);
INSERT INTO type_chambre_pointfort VALUES (3, 93);
INSERT INTO type_chambre_pointfort VALUES (3, 94);
INSERT INTO type_chambre_pointfort VALUES (1, 94);
INSERT INTO type_chambre_pointfort VALUES (3, 95);
INSERT INTO type_chambre_pointfort VALUES (2, 95);
INSERT INTO type_chambre_pointfort VALUES (3, 98);
INSERT INTO type_chambre_pointfort VALUES (5, 100);
INSERT INTO type_chambre_pointfort VALUES (5, 101);
INSERT INTO type_chambre_pointfort VALUES (1, 102);
INSERT INTO type_chambre_pointfort VALUES (1, 103);
INSERT INTO type_chambre_pointfort VALUES (2, 104);
INSERT INTO type_chambre_pointfort VALUES (1, 105);
INSERT INTO type_chambre_pointfort VALUES (1, 107);
INSERT INTO type_chambre_pointfort VALUES (2, 108);
INSERT INTO type_chambre_pointfort VALUES (5, 109);
INSERT INTO type_chambre_pointfort VALUES (1, 112);
INSERT INTO type_chambre_pointfort VALUES (3, 112);
INSERT INTO type_chambre_pointfort VALUES (5, 113);
INSERT INTO type_chambre_pointfort VALUES (3, 114);
INSERT INTO type_chambre_pointfort VALUES (2, 114);
INSERT INTO type_chambre_pointfort VALUES (3, 115);
INSERT INTO type_chambre_pointfort VALUES (5, 116);
INSERT INTO type_chambre_pointfort VALUES (4, 116);
INSERT INTO type_chambre_pointfort VALUES (3, 117);
INSERT INTO type_chambre_pointfort VALUES (2, 118);
INSERT INTO type_chambre_pointfort VALUES (1, 119);
INSERT INTO type_chambre_pointfort VALUES (1, 120);
INSERT INTO type_chambre_pointfort VALUES (1, 122);
INSERT INTO type_chambre_pointfort VALUES (3, 122);
INSERT INTO type_chambre_pointfort VALUES (2, 123);
INSERT INTO type_chambre_pointfort VALUES (3, 124);
INSERT INTO type_chambre_pointfort VALUES (5, 124);
INSERT INTO type_chambre_pointfort VALUES (1, 125);
INSERT INTO type_chambre_pointfort VALUES (5, 128);
INSERT INTO type_chambre_pointfort VALUES (2, 129);
INSERT INTO type_chambre_pointfort VALUES (2, 130);
INSERT INTO type_chambre_pointfort VALUES (5, 131);
INSERT INTO type_chambre_pointfort VALUES (5, 132);
INSERT INTO type_chambre_pointfort VALUES (2, 133);
INSERT INTO type_chambre_pointfort VALUES (1, 134);
INSERT INTO type_chambre_pointfort VALUES (5, 135);
INSERT INTO type_chambre_pointfort VALUES (5, 136);
INSERT INTO type_chambre_pointfort VALUES (3, 136);
INSERT INTO type_chambre_pointfort VALUES (1, 137);
INSERT INTO type_chambre_pointfort VALUES (5, 138);
INSERT INTO type_chambre_pointfort VALUES (1, 138);
INSERT INTO type_chambre_pointfort VALUES (5, 140);
INSERT INTO type_chambre_pointfort VALUES (1, 140);
INSERT INTO type_chambre_pointfort VALUES (3, 143);
INSERT INTO type_chambre_pointfort VALUES (3, 144);
INSERT INTO type_chambre_pointfort VALUES (3, 146);
INSERT INTO type_chambre_pointfort VALUES (5, 147);
INSERT INTO type_chambre_pointfort VALUES (3, 149);
INSERT INTO type_chambre_pointfort VALUES (1, 151);
INSERT INTO type_chambre_pointfort VALUES (3, 151);
INSERT INTO type_chambre_pointfort VALUES (1, 152);
INSERT INTO type_chambre_pointfort VALUES (1, 153);
INSERT INTO type_chambre_pointfort VALUES (3, 154);
INSERT INTO type_chambre_pointfort VALUES (2, 155);
INSERT INTO type_chambre_pointfort VALUES (2, 156);
INSERT INTO type_chambre_pointfort VALUES (3, 156);
INSERT INTO type_chambre_pointfort VALUES (2, 157);
INSERT INTO type_chambre_pointfort VALUES (5, 158);
INSERT INTO type_chambre_pointfort VALUES (3, 158);

-- type_chambre_sdb
INSERT INTO type_chambre_sdb VALUES (4, 5);
INSERT INTO type_chambre_sdb VALUES (1, 5);
INSERT INTO type_chambre_sdb VALUES (4, 6);
INSERT INTO type_chambre_sdb VALUES (4, 7);
INSERT INTO type_chambre_sdb VALUES (2, 7);
INSERT INTO type_chambre_sdb VALUES (3, 8);
INSERT INTO type_chambre_sdb VALUES (2, 8);
INSERT INTO type_chambre_sdb VALUES (1, 9);
INSERT INTO type_chambre_sdb VALUES (2, 10);
INSERT INTO type_chambre_sdb VALUES (5, 10);
INSERT INTO type_chambre_sdb VALUES (2, 11);
INSERT INTO type_chambre_sdb VALUES (5, 11);
INSERT INTO type_chambre_sdb VALUES (2, 12);
INSERT INTO type_chambre_sdb VALUES (1, 13);
INSERT INTO type_chambre_sdb VALUES (3, 14);
INSERT INTO type_chambre_sdb VALUES (1, 14);
INSERT INTO type_chambre_sdb VALUES (3, 15);
INSERT INTO type_chambre_sdb VALUES (2, 16);
INSERT INTO type_chambre_sdb VALUES (5, 17);
INSERT INTO type_chambre_sdb VALUES (2, 17);
INSERT INTO type_chambre_sdb VALUES (1, 18);
INSERT INTO type_chambre_sdb VALUES (3, 18);
INSERT INTO type_chambre_sdb VALUES (2, 19);
INSERT INTO type_chambre_sdb VALUES (1, 19);
INSERT INTO type_chambre_sdb VALUES (5, 20);
INSERT INTO type_chambre_sdb VALUES (1, 20);
INSERT INTO type_chambre_sdb VALUES (4, 21);
INSERT INTO type_chambre_sdb VALUES (5, 22);
INSERT INTO type_chambre_sdb VALUES (3, 22);
INSERT INTO type_chambre_sdb VALUES (2, 23);
INSERT INTO type_chambre_sdb VALUES (3, 23);
INSERT INTO type_chambre_sdb VALUES (2, 24);
INSERT INTO type_chambre_sdb VALUES (3, 24);
INSERT INTO type_chambre_sdb VALUES (2, 25);
INSERT INTO type_chambre_sdb VALUES (3, 26);
INSERT INTO type_chambre_sdb VALUES (5, 27);
INSERT INTO type_chambre_sdb VALUES (1, 27);
INSERT INTO type_chambre_sdb VALUES (3, 30);
INSERT INTO type_chambre_sdb VALUES (1, 30);
INSERT INTO type_chambre_sdb VALUES (2, 31);
INSERT INTO type_chambre_sdb VALUES (3, 31);
INSERT INTO type_chambre_sdb VALUES (5, 32);
INSERT INTO type_chambre_sdb VALUES (4, 32);
INSERT INTO type_chambre_sdb VALUES (1, 33);
INSERT INTO type_chambre_sdb VALUES (1, 34);
INSERT INTO type_chambre_sdb VALUES (3, 34);
INSERT INTO type_chambre_sdb VALUES (2, 35);
INSERT INTO type_chambre_sdb VALUES (3, 36);
INSERT INTO type_chambre_sdb VALUES (5, 36);
INSERT INTO type_chambre_sdb VALUES (4, 37);
INSERT INTO type_chambre_sdb VALUES (2, 38);
INSERT INTO type_chambre_sdb VALUES (3, 39);
INSERT INTO type_chambre_sdb VALUES (5, 39);
INSERT INTO type_chambre_sdb VALUES (2, 40);
INSERT INTO type_chambre_sdb VALUES (2, 41);
INSERT INTO type_chambre_sdb VALUES (3, 42);
INSERT INTO type_chambre_sdb VALUES (2, 42);
INSERT INTO type_chambre_sdb VALUES (2, 43);
INSERT INTO type_chambre_sdb VALUES (5, 43);
INSERT INTO type_chambre_sdb VALUES (1, 44);
INSERT INTO type_chambre_sdb VALUES (3, 44);
INSERT INTO type_chambre_sdb VALUES (1, 45);
INSERT INTO type_chambre_sdb VALUES (3, 45);
INSERT INTO type_chambre_sdb VALUES (2, 46);
INSERT INTO type_chambre_sdb VALUES (5, 46);
INSERT INTO type_chambre_sdb VALUES (5, 47);
INSERT INTO type_chambre_sdb VALUES (1, 47);
INSERT INTO type_chambre_sdb VALUES (5, 48);
INSERT INTO type_chambre_sdb VALUES (4, 48);
INSERT INTO type_chambre_sdb VALUES (4, 49);
INSERT INTO type_chambre_sdb VALUES (5, 49);
INSERT INTO type_chambre_sdb VALUES (4, 50);
INSERT INTO type_chambre_sdb VALUES (3, 50);
INSERT INTO type_chambre_sdb VALUES (2, 51);
INSERT INTO type_chambre_sdb VALUES (3, 52);
INSERT INTO type_chambre_sdb VALUES (2, 53);
INSERT INTO type_chambre_sdb VALUES (3, 53);
INSERT INTO type_chambre_sdb VALUES (1, 54);
INSERT INTO type_chambre_sdb VALUES (3, 54);
INSERT INTO type_chambre_sdb VALUES (5, 55);
INSERT INTO type_chambre_sdb VALUES (1, 56);
INSERT INTO type_chambre_sdb VALUES (3, 57);
INSERT INTO type_chambre_sdb VALUES (3, 58);
INSERT INTO type_chambre_sdb VALUES (2, 58);
INSERT INTO type_chambre_sdb VALUES (2, 59);
INSERT INTO type_chambre_sdb VALUES (3, 59);
INSERT INTO type_chambre_sdb VALUES (1, 60);
INSERT INTO type_chambre_sdb VALUES (2, 60);
INSERT INTO type_chambre_sdb VALUES (1, 61);
INSERT INTO type_chambre_sdb VALUES (5, 62);
INSERT INTO type_chambre_sdb VALUES (1, 62);
INSERT INTO type_chambre_sdb VALUES (5, 63);
INSERT INTO type_chambre_sdb VALUES (2, 63);
INSERT INTO type_chambre_sdb VALUES (5, 64);
INSERT INTO type_chambre_sdb VALUES (3, 64);
INSERT INTO type_chambre_sdb VALUES (3, 65);
INSERT INTO type_chambre_sdb VALUES (3, 66);
INSERT INTO type_chambre_sdb VALUES (1, 66);
INSERT INTO type_chambre_sdb VALUES (1, 67);
INSERT INTO type_chambre_sdb VALUES (3, 67);
INSERT INTO type_chambre_sdb VALUES (1, 68);
INSERT INTO type_chambre_sdb VALUES (5, 69);
INSERT INTO type_chambre_sdb VALUES (2, 70);
INSERT INTO type_chambre_sdb VALUES (3, 70);
INSERT INTO type_chambre_sdb VALUES (3, 71);
INSERT INTO type_chambre_sdb VALUES (3, 72);
INSERT INTO type_chambre_sdb VALUES (2, 73);
INSERT INTO type_chambre_sdb VALUES (5, 73);
INSERT INTO type_chambre_sdb VALUES (1, 74);
INSERT INTO type_chambre_sdb VALUES (2, 74);
INSERT INTO type_chambre_sdb VALUES (3, 75);
INSERT INTO type_chambre_sdb VALUES (3, 76);
INSERT INTO type_chambre_sdb VALUES (2, 76);
INSERT INTO type_chambre_sdb VALUES (2, 77);
INSERT INTO type_chambre_sdb VALUES (2, 78);
INSERT INTO type_chambre_sdb VALUES (5, 79);
INSERT INTO type_chambre_sdb VALUES (1, 80);
INSERT INTO type_chambre_sdb VALUES (3, 80);
INSERT INTO type_chambre_sdb VALUES (3, 81);
INSERT INTO type_chambre_sdb VALUES (3, 82);
INSERT INTO type_chambre_sdb VALUES (3, 83);
INSERT INTO type_chambre_sdb VALUES (3, 84);
INSERT INTO type_chambre_sdb VALUES (1, 84);
INSERT INTO type_chambre_sdb VALUES (2, 85);
INSERT INTO type_chambre_sdb VALUES (5, 86);
INSERT INTO type_chambre_sdb VALUES (3, 87);
INSERT INTO type_chambre_sdb VALUES (3, 88);
INSERT INTO type_chambre_sdb VALUES (3, 89);
INSERT INTO type_chambre_sdb VALUES (2, 90);
INSERT INTO type_chambre_sdb VALUES (5, 90);
INSERT INTO type_chambre_sdb VALUES (1, 91);
INSERT INTO type_chambre_sdb VALUES (3, 91);
INSERT INTO type_chambre_sdb VALUES (2, 92);
INSERT INTO type_chambre_sdb VALUES (2, 93);
INSERT INTO type_chambre_sdb VALUES (5, 93);
INSERT INTO type_chambre_sdb VALUES (5, 94);
INSERT INTO type_chambre_sdb VALUES (2, 94);
INSERT INTO type_chambre_sdb VALUES (5, 95);
INSERT INTO type_chambre_sdb VALUES (3, 95);
INSERT INTO type_chambre_sdb VALUES (5, 96);
INSERT INTO type_chambre_sdb VALUES (3, 97);
INSERT INTO type_chambre_sdb VALUES (2, 98);
INSERT INTO type_chambre_sdb VALUES (2, 99);
INSERT INTO type_chambre_sdb VALUES (5, 99);
INSERT INTO type_chambre_sdb VALUES (2, 100);
INSERT INTO type_chambre_sdb VALUES (3, 100);
INSERT INTO type_chambre_sdb VALUES (5, 101);
INSERT INTO type_chambre_sdb VALUES (1, 102);
INSERT INTO type_chambre_sdb VALUES (1, 103);
INSERT INTO type_chambre_sdb VALUES (1, 104);
INSERT INTO type_chambre_sdb VALUES (3, 104);
INSERT INTO type_chambre_sdb VALUES (2, 105);
INSERT INTO type_chambre_sdb VALUES (3, 105);
INSERT INTO type_chambre_sdb VALUES (1, 106);
INSERT INTO type_chambre_sdb VALUES (1, 107);
INSERT INTO type_chambre_sdb VALUES (5, 107);
INSERT INTO type_chambre_sdb VALUES (1, 108);
INSERT INTO type_chambre_sdb VALUES (2, 108);
INSERT INTO type_chambre_sdb VALUES (1, 109);
INSERT INTO type_chambre_sdb VALUES (3, 109);
INSERT INTO type_chambre_sdb VALUES (5, 110);
INSERT INTO type_chambre_sdb VALUES (3, 110);
INSERT INTO type_chambre_sdb VALUES (3, 111);
INSERT INTO type_chambre_sdb VALUES (5, 112);
INSERT INTO type_chambre_sdb VALUES (1, 112);
INSERT INTO type_chambre_sdb VALUES (1, 113);
INSERT INTO type_chambre_sdb VALUES (1, 114);
INSERT INTO type_chambre_sdb VALUES (2, 114);
INSERT INTO type_chambre_sdb VALUES (1, 115);
INSERT INTO type_chambre_sdb VALUES (2, 115);
INSERT INTO type_chambre_sdb VALUES (2, 116);
INSERT INTO type_chambre_sdb VALUES (1, 116);
INSERT INTO type_chambre_sdb VALUES (1, 117);
INSERT INTO type_chambre_sdb VALUES (1, 118);
INSERT INTO type_chambre_sdb VALUES (1, 119);
INSERT INTO type_chambre_sdb VALUES (2, 120);
INSERT INTO type_chambre_sdb VALUES (2, 121);
INSERT INTO type_chambre_sdb VALUES (5, 122);
INSERT INTO type_chambre_sdb VALUES (5, 123);
INSERT INTO type_chambre_sdb VALUES (2, 123);
INSERT INTO type_chambre_sdb VALUES (1, 124);
INSERT INTO type_chambre_sdb VALUES (3, 124);
INSERT INTO type_chambre_sdb VALUES (5, 125);
INSERT INTO type_chambre_sdb VALUES (1, 125);
INSERT INTO type_chambre_sdb VALUES (3, 126);
INSERT INTO type_chambre_sdb VALUES (5, 126);
INSERT INTO type_chambre_sdb VALUES (2, 127);
INSERT INTO type_chambre_sdb VALUES (3, 127);
INSERT INTO type_chambre_sdb VALUES (2, 128);
INSERT INTO type_chambre_sdb VALUES (3, 129);
INSERT INTO type_chambre_sdb VALUES (2, 129);
INSERT INTO type_chambre_sdb VALUES (3, 130);
INSERT INTO type_chambre_sdb VALUES (2, 130);
INSERT INTO type_chambre_sdb VALUES (3, 131);
INSERT INTO type_chambre_sdb VALUES (1, 131);
INSERT INTO type_chambre_sdb VALUES (5, 132);
INSERT INTO type_chambre_sdb VALUES (3, 133);
INSERT INTO type_chambre_sdb VALUES (2, 133);
INSERT INTO type_chambre_sdb VALUES (1, 134);
INSERT INTO type_chambre_sdb VALUES (3, 134);
INSERT INTO type_chambre_sdb VALUES (2, 135);
INSERT INTO type_chambre_sdb VALUES (1, 136);
INSERT INTO type_chambre_sdb VALUES (3, 137);
INSERT INTO type_chambre_sdb VALUES (5, 138);
INSERT INTO type_chambre_sdb VALUES (1, 138);
INSERT INTO type_chambre_sdb VALUES (2, 139);
INSERT INTO type_chambre_sdb VALUES (3, 139);
INSERT INTO type_chambre_sdb VALUES (5, 140);
INSERT INTO type_chambre_sdb VALUES (2, 140);
INSERT INTO type_chambre_sdb VALUES (3, 141);
INSERT INTO type_chambre_sdb VALUES (2, 142);
INSERT INTO type_chambre_sdb VALUES (5, 143);
INSERT INTO type_chambre_sdb VALUES (1, 143);
INSERT INTO type_chambre_sdb VALUES (2, 144);
INSERT INTO type_chambre_sdb VALUES (1, 144);
INSERT INTO type_chambre_sdb VALUES (3, 145);
INSERT INTO type_chambre_sdb VALUES (3, 146);
INSERT INTO type_chambre_sdb VALUES (2, 147);
INSERT INTO type_chambre_sdb VALUES (1, 147);
INSERT INTO type_chambre_sdb VALUES (2, 148);
INSERT INTO type_chambre_sdb VALUES (3, 148);
INSERT INTO type_chambre_sdb VALUES (3, 149);
INSERT INTO type_chambre_sdb VALUES (3, 150);
INSERT INTO type_chambre_sdb VALUES (2, 150);
INSERT INTO type_chambre_sdb VALUES (2, 151);
INSERT INTO type_chambre_sdb VALUES (2, 152);
INSERT INTO type_chambre_sdb VALUES (3, 152);
INSERT INTO type_chambre_sdb VALUES (2, 153);
INSERT INTO type_chambre_sdb VALUES (2, 154);
INSERT INTO type_chambre_sdb VALUES (5, 154);
INSERT INTO type_chambre_sdb VALUES (2, 155);
INSERT INTO type_chambre_sdb VALUES (3, 155);
INSERT INTO type_chambre_sdb VALUES (1, 156);
INSERT INTO type_chambre_sdb VALUES (3, 157);
INSERT INTO type_chambre_sdb VALUES (2, 158);
INSERT INTO type_chambre_sdb VALUES (5, 158);

-- type_chambre_service
INSERT INTO type_chambre_service VALUES (4, 1);
INSERT INTO type_chambre_service VALUES (1, 1);
INSERT INTO type_chambre_service VALUES (5, 2);
INSERT INTO type_chambre_service VALUES (4, 4);
INSERT INTO type_chambre_service VALUES (1, 4);
INSERT INTO type_chambre_service VALUES (5, 5);
INSERT INTO type_chambre_service VALUES (4, 6);
INSERT INTO type_chambre_service VALUES (3, 6);
INSERT INTO type_chambre_service VALUES (3, 7);
INSERT INTO type_chambre_service VALUES (5, 7);
INSERT INTO type_chambre_service VALUES (3, 8);
INSERT INTO type_chambre_service VALUES (1, 9);
INSERT INTO type_chambre_service VALUES (2, 9);
INSERT INTO type_chambre_service VALUES (3, 10);
INSERT INTO type_chambre_service VALUES (3, 11);
INSERT INTO type_chambre_service VALUES (2, 11);
INSERT INTO type_chambre_service VALUES (3, 12);
INSERT INTO type_chambre_service VALUES (2, 12);
INSERT INTO type_chambre_service VALUES (2, 13);
INSERT INTO type_chambre_service VALUES (5, 14);
INSERT INTO type_chambre_service VALUES (4, 14);
INSERT INTO type_chambre_service VALUES (2, 15);
INSERT INTO type_chambre_service VALUES (5, 15);
INSERT INTO type_chambre_service VALUES (3, 15);
INSERT INTO type_chambre_service VALUES (4, 16);
INSERT INTO type_chambre_service VALUES (2, 17);
INSERT INTO type_chambre_service VALUES (1, 18);
INSERT INTO type_chambre_service VALUES (1, 19);
INSERT INTO type_chambre_service VALUES (3, 20);
INSERT INTO type_chambre_service VALUES (2, 20);
INSERT INTO type_chambre_service VALUES (4, 21);
INSERT INTO type_chambre_service VALUES (2, 21);
INSERT INTO type_chambre_service VALUES (5, 22);
INSERT INTO type_chambre_service VALUES (1, 23);
INSERT INTO type_chambre_service VALUES (2, 24);
INSERT INTO type_chambre_service VALUES (3, 24);
INSERT INTO type_chambre_service VALUES (5, 24);
INSERT INTO type_chambre_service VALUES (1, 25);
INSERT INTO type_chambre_service VALUES (2, 26);
INSERT INTO type_chambre_service VALUES (4, 26);
INSERT INTO type_chambre_service VALUES (5, 26);
INSERT INTO type_chambre_service VALUES (3, 27);
INSERT INTO type_chambre_service VALUES (2, 27);
INSERT INTO type_chambre_service VALUES (4, 30);
INSERT INTO type_chambre_service VALUES (1, 30);
INSERT INTO type_chambre_service VALUES (2, 31);
INSERT INTO type_chambre_service VALUES (3, 31);
INSERT INTO type_chambre_service VALUES (4, 32);
INSERT INTO type_chambre_service VALUES (4, 34);
INSERT INTO type_chambre_service VALUES (5, 34);
INSERT INTO type_chambre_service VALUES (3, 35);
INSERT INTO type_chambre_service VALUES (3, 36);
INSERT INTO type_chambre_service VALUES (1, 37);
INSERT INTO type_chambre_service VALUES (2, 37);
INSERT INTO type_chambre_service VALUES (1, 38);
INSERT INTO type_chambre_service VALUES (2, 38);
INSERT INTO type_chambre_service VALUES (1, 39);
INSERT INTO type_chambre_service VALUES (2, 39);
INSERT INTO type_chambre_service VALUES (2, 40);
INSERT INTO type_chambre_service VALUES (3, 40);
INSERT INTO type_chambre_service VALUES (4, 42);
INSERT INTO type_chambre_service VALUES (5, 42);
INSERT INTO type_chambre_service VALUES (4, 43);
INSERT INTO type_chambre_service VALUES (3, 44);
INSERT INTO type_chambre_service VALUES (2, 46);
INSERT INTO type_chambre_service VALUES (3, 46);
INSERT INTO type_chambre_service VALUES (4, 47);
INSERT INTO type_chambre_service VALUES (2, 47);
INSERT INTO type_chambre_service VALUES (1, 49);
INSERT INTO type_chambre_service VALUES (5, 49);
INSERT INTO type_chambre_service VALUES (2, 49);
INSERT INTO type_chambre_service VALUES (2, 50);
INSERT INTO type_chambre_service VALUES (4, 51);
INSERT INTO type_chambre_service VALUES (2, 51);
INSERT INTO type_chambre_service VALUES (5, 52);
INSERT INTO type_chambre_service VALUES (1, 52);
INSERT INTO type_chambre_service VALUES (3, 53);
INSERT INTO type_chambre_service VALUES (2, 53);
INSERT INTO type_chambre_service VALUES (3, 54);
INSERT INTO type_chambre_service VALUES (1, 54);
INSERT INTO type_chambre_service VALUES (3, 55);
INSERT INTO type_chambre_service VALUES (3, 56);
INSERT INTO type_chambre_service VALUES (3, 57);
INSERT INTO type_chambre_service VALUES (4, 57);
INSERT INTO type_chambre_service VALUES (5, 58);
INSERT INTO type_chambre_service VALUES (3, 58);
INSERT INTO type_chambre_service VALUES (1, 59);
INSERT INTO type_chambre_service VALUES (3, 60);
INSERT INTO type_chambre_service VALUES (4, 60);
INSERT INTO type_chambre_service VALUES (3, 61);
INSERT INTO type_chambre_service VALUES (2, 61);
INSERT INTO type_chambre_service VALUES (4, 62);
INSERT INTO type_chambre_service VALUES (1, 62);
INSERT INTO type_chambre_service VALUES (1, 63);
INSERT INTO type_chambre_service VALUES (5, 63);
INSERT INTO type_chambre_service VALUES (2, 63);
INSERT INTO type_chambre_service VALUES (2, 64);
INSERT INTO type_chambre_service VALUES (1, 64);
INSERT INTO type_chambre_service VALUES (4, 65);
INSERT INTO type_chambre_service VALUES (2, 66);
INSERT INTO type_chambre_service VALUES (5, 66);
INSERT INTO type_chambre_service VALUES (3, 66);
INSERT INTO type_chambre_service VALUES (3, 67);
INSERT INTO type_chambre_service VALUES (1, 67);
INSERT INTO type_chambre_service VALUES (4, 68);
INSERT INTO type_chambre_service VALUES (2, 69);
INSERT INTO type_chambre_service VALUES (5, 69);
INSERT INTO type_chambre_service VALUES (1, 70);
INSERT INTO type_chambre_service VALUES (1, 71);
INSERT INTO type_chambre_service VALUES (2, 72);
INSERT INTO type_chambre_service VALUES (4, 72);
INSERT INTO type_chambre_service VALUES (2, 74);
INSERT INTO type_chambre_service VALUES (3, 74);
INSERT INTO type_chambre_service VALUES (1, 75);
INSERT INTO type_chambre_service VALUES (2, 75);
INSERT INTO type_chambre_service VALUES (2, 76);
INSERT INTO type_chambre_service VALUES (4, 77);
INSERT INTO type_chambre_service VALUES (4, 78);
INSERT INTO type_chambre_service VALUES (3, 79);
INSERT INTO type_chambre_service VALUES (1, 80);
INSERT INTO type_chambre_service VALUES (3, 80);
INSERT INTO type_chambre_service VALUES (3, 81);
INSERT INTO type_chambre_service VALUES (1, 81);
INSERT INTO type_chambre_service VALUES (2, 82);
INSERT INTO type_chambre_service VALUES (5, 83);
INSERT INTO type_chambre_service VALUES (3, 84);
INSERT INTO type_chambre_service VALUES (2, 85);
INSERT INTO type_chambre_service VALUES (1, 86);
INSERT INTO type_chambre_service VALUES (1, 87);
INSERT INTO type_chambre_service VALUES (5, 87);
INSERT INTO type_chambre_service VALUES (2, 88);
INSERT INTO type_chambre_service VALUES (3, 88);
INSERT INTO type_chambre_service VALUES (4, 88);
INSERT INTO type_chambre_service VALUES (2, 90);
INSERT INTO type_chambre_service VALUES (3, 90);
INSERT INTO type_chambre_service VALUES (4, 91);
INSERT INTO type_chambre_service VALUES (5, 91);
INSERT INTO type_chambre_service VALUES (4, 92);
INSERT INTO type_chambre_service VALUES (3, 92);
INSERT INTO type_chambre_service VALUES (5, 92);
INSERT INTO type_chambre_service VALUES (3, 93);
INSERT INTO type_chambre_service VALUES (4, 93);
INSERT INTO type_chambre_service VALUES (3, 94);
INSERT INTO type_chambre_service VALUES (1, 94);
INSERT INTO type_chambre_service VALUES (3, 95);
INSERT INTO type_chambre_service VALUES (2, 97);
INSERT INTO type_chambre_service VALUES (4, 97);
INSERT INTO type_chambre_service VALUES (2, 98);
INSERT INTO type_chambre_service VALUES (3, 99);
INSERT INTO type_chambre_service VALUES (1, 100);
INSERT INTO type_chambre_service VALUES (2, 100);
INSERT INTO type_chambre_service VALUES (2, 101);
INSERT INTO type_chambre_service VALUES (5, 103);
INSERT INTO type_chambre_service VALUES (2, 104);
INSERT INTO type_chambre_service VALUES (2, 105);
INSERT INTO type_chambre_service VALUES (1, 107);
INSERT INTO type_chambre_service VALUES (3, 107);
INSERT INTO type_chambre_service VALUES (2, 108);
INSERT INTO type_chambre_service VALUES (3, 109);
INSERT INTO type_chambre_service VALUES (2, 109);
INSERT INTO type_chambre_service VALUES (3, 110);
INSERT INTO type_chambre_service VALUES (3, 111);
INSERT INTO type_chambre_service VALUES (1, 112);
INSERT INTO type_chambre_service VALUES (3, 113);
INSERT INTO type_chambre_service VALUES (3, 114);
INSERT INTO type_chambre_service VALUES (1, 115);
INSERT INTO type_chambre_service VALUES (2, 116);
INSERT INTO type_chambre_service VALUES (2, 117);
INSERT INTO type_chambre_service VALUES (2, 119);
INSERT INTO type_chambre_service VALUES (4, 119);
INSERT INTO type_chambre_service VALUES (4, 120);
INSERT INTO type_chambre_service VALUES (2, 120);
INSERT INTO type_chambre_service VALUES (2, 121);
INSERT INTO type_chambre_service VALUES (4, 121);
INSERT INTO type_chambre_service VALUES (2, 122);
INSERT INTO type_chambre_service VALUES (5, 123);
INSERT INTO type_chambre_service VALUES (2, 123);
INSERT INTO type_chambre_service VALUES (1, 123);
INSERT INTO type_chambre_service VALUES (3, 124);
INSERT INTO type_chambre_service VALUES (4, 124);
INSERT INTO type_chambre_service VALUES (1, 125);
INSERT INTO type_chambre_service VALUES (1, 126);
INSERT INTO type_chambre_service VALUES (3, 127);
INSERT INTO type_chambre_service VALUES (3, 129);
INSERT INTO type_chambre_service VALUES (1, 129);
INSERT INTO type_chambre_service VALUES (3, 130);
INSERT INTO type_chambre_service VALUES (1, 131);
INSERT INTO type_chambre_service VALUES (3, 131);
INSERT INTO type_chambre_service VALUES (1, 132);
INSERT INTO type_chambre_service VALUES (4, 133);
INSERT INTO type_chambre_service VALUES (1, 134);
INSERT INTO type_chambre_service VALUES (4, 135);
INSERT INTO type_chambre_service VALUES (2, 135);
INSERT INTO type_chambre_service VALUES (4, 136);
INSERT INTO type_chambre_service VALUES (3, 136);
INSERT INTO type_chambre_service VALUES (2, 138);
INSERT INTO type_chambre_service VALUES (3, 139);
INSERT INTO type_chambre_service VALUES (4, 140);
INSERT INTO type_chambre_service VALUES (5, 140);
INSERT INTO type_chambre_service VALUES (3, 141);
INSERT INTO type_chambre_service VALUES (2, 141);
INSERT INTO type_chambre_service VALUES (2, 142);
INSERT INTO type_chambre_service VALUES (4, 142);
INSERT INTO type_chambre_service VALUES (3, 143);
INSERT INTO type_chambre_service VALUES (4, 144);
INSERT INTO type_chambre_service VALUES (3, 144);
INSERT INTO type_chambre_service VALUES (2, 145);
INSERT INTO type_chambre_service VALUES (3, 146);
INSERT INTO type_chambre_service VALUES (3, 147);
INSERT INTO type_chambre_service VALUES (3, 149);
INSERT INTO type_chambre_service VALUES (2, 150);
INSERT INTO type_chambre_service VALUES (3, 150);
INSERT INTO type_chambre_service VALUES (1, 151);
INSERT INTO type_chambre_service VALUES (4, 152);
INSERT INTO type_chambre_service VALUES (1, 152);
INSERT INTO type_chambre_service VALUES (5, 153);
INSERT INTO type_chambre_service VALUES (1, 154);
INSERT INTO type_chambre_service VALUES (2, 155);
INSERT INTO type_chambre_service VALUES (3, 155);
INSERT INTO type_chambre_service VALUES (4, 156);
INSERT INTO type_chambre_service VALUES (5, 157);
INSERT INTO type_chambre_service VALUES (1, 157);
INSERT INTO type_chambre_service VALUES (4, 158);
INSERT INTO type_chambre_service VALUES (3, 158);


-- Indexs

-- Optimiser l'accès aux réservations d'un client (Espace Client)
CREATE INDEX idx_reservation_client 
ON reservation (numclient);

-- Optimiser les jointures et filtres sur les dates de réservation. Utile pour les tableaux de bord et la détection de chevauchements.
CREATE INDEX idx_reservation_dates 
ON reservation (datedebut, datefin);

-- Optimiser le calcul de la note moyenne des clubs. Accélère le trigger de mise à jour des notes.
CREATE INDEX idx_avis_club 
ON avis (idclub);

-- Optimiser la recherche textuelle sur les clubs (Recherche utilisateur)
CREATE INDEX idx_club_titre 
ON club (titre);

-- Procedures
-- Creer reservation
CREATE OR REPLACE PROCEDURE creer_reservation(
    p_idclub INT,
    p_idtransport INT,
    p_numclient INT,
    p_datedebut DATE,
    p_datefin DATE,
    p_nbpersonnes INT,
    p_numchambre INT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_disponible BOOLEAN;
BEGIN
    SELECT NOT EXISTS (
        SELECT 1 
        FROM disponibilite 
        WHERE idclub = p_idclub 
          AND numchambre = p_numchambre
          AND date >= p_datedebut 
          AND date < p_datefin
          AND estdisponibilite = false
    ) INTO v_disponible;

    IF NOT v_disponible THEN
        RAISE EXCEPTION 'La chambre % n''est pas disponible pour ces dates.', p_numchambre;
    END IF;

    INSERT INTO reservation (idclub, idtransport, numclient, datedebut, datefin, nbpersonnes, statut, disponibilite_confirmee)
    VALUES (p_idclub, p_idtransport, p_numclient, p_datedebut, p_datefin, p_nbpersonnes, 'EN_ATTENTE', true);

    UPDATE disponibilite
    SET estdisponibilite = false
    WHERE idclub = p_idclub 
      AND numchambre = p_numchambre
      AND date >= p_datedebut 
      AND date < p_datefin;
      
    COMMIT;
END;
$$;

-- Annuler reservation
CREATE OR REPLACE PROCEDURE annuler_reservation(p_numreservation INT)
LANGUAGE plpgsql
AS $$
DECLARE
    v_idclub INT;
    v_datedebut DATE;
    v_datefin DATE;
BEGIN
    SELECT idclub, datedebut, datefin 
    INTO v_idclub, v_datedebut, v_datefin
    FROM reservation WHERE numreservation = p_numreservation;

    UPDATE reservation SET statut = 'ANNULEE', veut_annuler = true 
    WHERE numreservation = p_numreservation;
    
    COMMIT;
END;
$$;

-- Creation d'un club
CREATE OR REPLACE PROCEDURE creer_club(
    p_titre VARCHAR,
    p_description TEXT,
    p_numpays INTEGER,
    p_email VARCHAR,
    p_numphoto INTEGER DEFAULT 1
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_new_id INTEGER;
BEGIN
    SELECT COALESCE(MAX(idclub), 0) + 1 INTO v_new_id FROM club;

    INSERT INTO club (
        idclub, 
        titre, 
        description, 
        numpays, 
        email, 
        numphoto, 
        statut_mise_en_ligne, 
        notemoyenne          
    )
    VALUES (
        v_new_id, 
        p_titre, 
        p_description, 
        p_numpays, 
        p_email, 
        p_numphoto, 
        'EN_CREATION', 
        NULL
    );

    RAISE NOTICE 'Club "%" créé avec succès (ID: %). Statut: EN_CREATION.', p_titre, v_new_id;
END;
$$;

-- Fonctions & Triggers
-- Mise à jour automatique de la note moyenne du Club
CREATE OR REPLACE FUNCTION update_notemoyenne_club()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE club
    SET notemoyenne = (
        SELECT ROUND(AVG(note)::numeric, 1)
        FROM avis
        WHERE idclub = COALESCE(NEW.idclub, OLD.idclub)
    )
    WHERE idclub = COALESCE(NEW.idclub, OLD.idclub);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Validation des dates
CREATE OR REPLACE FUNCTION check_dates_coherence()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.datefin <= NEW.datedebut THEN
        RAISE EXCEPTION 'La date de fin doit être strictement postérieure à la date de début.';
    END IF;
    
    IF NEW.datedebut < CURRENT_DATE THEN
         RAISE EXCEPTION 'On ne peut pas réserver dans le passé.';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;



CREATE TRIGGER trg_update_club_rating
AFTER INSERT OR UPDATE OR DELETE ON avis
FOR EACH ROW
EXECUTE FUNCTION update_notemoyenne_club();

CREATE TRIGGER trg_validate_reservation_dates
BEFORE INSERT OR UPDATE ON reservation
FOR EACH ROW
EXECUTE FUNCTION check_dates_coherence();



-- Vue Power BI
CREATE OR REPLACE VIEW v_bi_analyse_ventes_resort AS
SELECT 
    -- Annee, mois
    TO_CHAR(r.datedebut, 'YYYY') AS annee,
    TO_CHAR(r.datedebut, 'MM') AS mois_numero,
    TO_CHAR(r.datedebut, 'TMMonth') AS mois_nom,
    TO_CHAR(r.datedebut, 'YYYY-MM') AS axe_temporel,

    -- Resort
    c.titre AS resort_nom,

    -- Categorie
    COALESCE(cat.nomcategory, 'Aucune catégorie') AS categorie_resort,

    -- Pays
    COALESCE(sl.nompays, 'Indéterminé') AS pays_resort,

    -- Calculs
    COUNT(r.numreservation) AS nombre_ventes,
    SUM(r.prix) AS chiffre_affaires_total,
    ROUND(AVG(r.prix), 2) AS panier_moyen

FROM reservation r
JOIN club c ON r.idclub = c.idclub
LEFT JOIN souslocalisation sl ON c.numpays = sl.numpays
LEFT JOIN club_categorie cc ON c.idclub = cc.idclub
LEFT JOIN categorie cat ON cc.numcategory = cat.numcategory

WHERE r.statut IN ('PAYEE', 'CONFIRMEE', 'TERMINEE')

GROUP BY 
    TO_CHAR(r.datedebut, 'YYYY'),
    TO_CHAR(r.datedebut, 'MM'),
    TO_CHAR(r.datedebut, 'TMMonth'),
    TO_CHAR(r.datedebut, 'YYYY-MM'),
    c.titre,
    cat.nomcategory,
    sl.nompays;

-- Vue Membre vente
CREATE OR REPLACE VIEW v_suivi_ventes_global AS
SELECT 
    r.numreservation AS "ID",
    cl.nom || ' ' || cl.prenom AS "Client",
    cl.email,

    c.titre AS "Destination",
    r.datedebut AS "Date Arrivée",
    r.nbpersonnes AS "Pax", 
    r.statut,
    COALESCE((SELECT SUM(montant) FROM transaction t WHERE t.numreservation = r.numreservation), 0) AS "Montant Encaissé"
FROM reservation r
JOIN client cl ON r.numclient = cl.numclient
JOIN club c ON r.idclub = c.idclub
ORDER BY r.numreservation DESC;

-- Vue Membre Marketing
CREATE OR REPLACE VIEW v_clubs_en_creation AS
SELECT 
    idclub,
    titre AS "Nom du Club",
    description,
    numpays,

    statut_mise_en_ligne AS "Statut Actuel",
    
    CASE 
        WHEN description IS NULL OR description = '' THEN 'Description Manquante'
        WHEN numphoto IS NULL THEN 'Photo Manquante'
        ELSE 'Prêt à publier ?'
    END AS "Action Requise"
FROM club
WHERE statut_mise_en_ligne = 'EN_CREATION';


-- Contraintes de clés primaires
ALTER TABLE   date_calendrier 
    ADD CONSTRAINT date_calendrier_pkey PRIMARY KEY (jour);


ALTER TABLE   failed_jobs 
    ADD CONSTRAINT failed_jobs_pkey PRIMARY KEY (id);


ALTER TABLE   failed_jobs 
    ADD CONSTRAINT failed_jobs_uuid_unique UNIQUE (uuid);


ALTER TABLE   migrations 
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (id);


ALTER TABLE   partenaires 
    ADD CONSTRAINT partenaires_pkey PRIMARY KEY (idpartenaire);


ALTER TABLE   password_reset_tokens 
    ADD CONSTRAINT password_reset_tokens_pkey PRIMARY KEY (email);


ALTER TABLE   personal_access_tokens 
    ADD CONSTRAINT personal_access_tokens_pkey PRIMARY KEY (id);


ALTER TABLE   personal_access_tokens 
    ADD CONSTRAINT personal_access_tokens_token_unique UNIQUE (token);


ALTER TABLE   activiteadulte 
    ADD CONSTRAINT pk_activiteadulte PRIMARY KEY (idactivite);


ALTER TABLE   activiteenfant 
    ADD CONSTRAINT pk_activiteenfant PRIMARY KEY (idactivite);


ALTER TABLE   adresse 
    ADD CONSTRAINT pk_adresse PRIMARY KEY (numadresse);


ALTER TABLE   type_chambre_sdb 
    ADD CONSTRAINT pk_type_chambre_sdb PRIMARY KEY (numequipementsallebain, idtypechambre);


ALTER TABLE   autrevoyageur 
    ADD CONSTRAINT pk_autrevoyageur PRIMARY KEY (numvoyageur);


ALTER TABLE   avis 
    ADD CONSTRAINT pk_avis PRIMARY KEY (numavis);


ALTER TABLE   calendrier 
    ADD CONSTRAINT pk_calendrier PRIMARY KEY (date);


ALTER TABLE   categorie 
    ADD CONSTRAINT pk_categorie PRIMARY KEY (numcategory);


ALTER TABLE   chambre 
    ADD CONSTRAINT pk_chambre PRIMARY KEY (numchambre);


ALTER TABLE   client 
    ADD CONSTRAINT pk_client PRIMARY KEY (numclient);


ALTER TABLE   club 
    ADD CONSTRAINT pk_club PRIMARY KEY (idclub);


ALTER TABLE   clubstation 
    ADD CONSTRAINT pk_clubstation PRIMARY KEY (idclub);


ALTER TABLE   club_categorie 
    ADD CONSTRAINT pk_club_categorie PRIMARY KEY (idclub, numcategory);


ALTER TABLE   club_regroupement 
    ADD CONSTRAINT pk_club_regroupement PRIMARY KEY (idclub, numregroupement);


ALTER TABLE   disponibilite 
    ADD CONSTRAINT pk_disponibilite PRIMARY KEY (date, numchambre, idclub);


ALTER TABLE   equipement 
    ADD CONSTRAINT pk_equipement PRIMARY KEY (numequipement);


ALTER TABLE   equipementsalledebain 
    ADD CONSTRAINT pk_equipementsalledebain PRIMARY KEY (numequipementsallebain);


ALTER TABLE   club_restauration 
    ADD CONSTRAINT pk_club_restauration PRIMARY KEY (idclub, numrestauration);


ALTER TABLE   categorie_localisation 
    ADD CONSTRAINT pk_categorie_localisation PRIMARY KEY (numcategory, numlocalisation);


ALTER TABLE   icon 
    ADD CONSTRAINT pk_icon PRIMARY KEY (numicon);


ALTER TABLE   club_activite 
    ADD CONSTRAINT pk_club_activite PRIMARY KEY (idclub, idactivite);


ALTER TABLE   lieurestauration 
    ADD CONSTRAINT pk_lieurestauration PRIMARY KEY (numrestauration);


ALTER TABLE   localisation 
    ADD CONSTRAINT pk_localisation PRIMARY KEY (numlocalisation);


ALTER TABLE   periode 
    ADD CONSTRAINT pk_periode PRIMARY KEY (numperiode);


ALTER TABLE   photo 
    ADD CONSTRAINT pk_photo PRIMARY KEY (numphoto);


ALTER TABLE   photo_club 
    ADD CONSTRAINT pk_photo_club PRIMARY KEY (idclub, numphoto);


ALTER TABLE   photoavis 
    ADD CONSTRAINT pk_photoavis PRIMARY KEY (numavis, numphoto);


ALTER TABLE   pointfort 
    ADD CONSTRAINT pk_pointfort PRIMARY KEY (numpointfort);


ALTER TABLE   prix_periode 
    ADD CONSTRAINT pk_prix_periode PRIMARY KEY (numperiode, idtypechambre);


ALTER TABLE   regroupement 
    ADD CONSTRAINT pk_regroupement PRIMARY KEY (numregroupement);


ALTER TABLE   reservation 
    ADD CONSTRAINT pk_reservation PRIMARY KEY (numreservation);


ALTER TABLE   pays_region 
    ADD CONSTRAINT pk_pays_region PRIMARY KEY (numlocalisation, numpays);


ALTER TABLE   categorie_type_club 
    ADD CONSTRAINT pk_categorie_type_club PRIMARY KEY (numcategory, numtype);


ALTER TABLE   type_chambre_service 
    ADD CONSTRAINT pk_type_chambre_service PRIMARY KEY (numservice, idtypechambre);


ALTER TABLE   club_chambre 
    ADD CONSTRAINT pk_club_chambre PRIMARY KEY (idclub, numchambre);


ALTER TABLE   reservation_activite 
    ADD CONSTRAINT pk_reservation_activite PRIMARY KEY (numreservation, idactivite);


ALTER TABLE   type_chambre_equipement 
    ADD CONSTRAINT pk_type_chambre_equipement PRIMARY KEY (numequipement, idtypechambre);


ALTER TABLE   service 
    ADD CONSTRAINT pk_service PRIMARY KEY (numservice);


ALTER TABLE   souslocalisation 
    ADD CONSTRAINT pk_souslocalisation PRIMARY KEY (numpays);


ALTER TABLE   station 
    ADD CONSTRAINT pk_station PRIMARY KEY (numstation);


ALTER TABLE   type_chambre_pointfort 
    ADD CONSTRAINT pk_type_chambre_pointfort PRIMARY KEY (numpointfort, idtypechambre);


ALTER TABLE   trancheage 
    ADD CONSTRAINT pk_trancheage PRIMARY KEY (numtranche);


ALTER TABLE   transport 
    ADD CONSTRAINT pk_transport PRIMARY KEY (idtransport);


ALTER TABLE   typeactivite 
    ADD CONSTRAINT pk_typeactivite PRIMARY KEY (numtypeactivite);


ALTER TABLE   typechambre 
    ADD CONSTRAINT pk_typechambre PRIMARY KEY (idtypechambre);


ALTER TABLE   typeclub 
    ADD CONSTRAINT pk_typeclub PRIMARY KEY (numtype);


ALTER TABLE   subscription_items 
    ADD CONSTRAINT subscription_items_pkey PRIMARY KEY (id);

ALTER TABLE   subscription_items 
    ADD CONSTRAINT subscription_items_stripe_id_unique UNIQUE (stripe_id);

ALTER TABLE   subscription_items 
    ADD CONSTRAINT subscription_items_subscription_id_stripe_price_unique UNIQUE (subscription_id, stripe_price);


ALTER TABLE   subscriptions 
    ADD CONSTRAINT subscriptions_pkey PRIMARY KEY (id);

ALTER TABLE   subscriptions 
    ADD CONSTRAINT subscriptions_stripe_id_unique UNIQUE (stripe_id);


ALTER TABLE   transaction 
    ADD CONSTRAINT transaction_pkey PRIMARY KEY (idtransaction);


ALTER TABLE   avis 
    ADD CONSTRAINT uk_avis_unique UNIQUE (idclub, numclient, numreservation);


ALTER TABLE   utilisateur 
    ADD CONSTRAINT utilisateur_email_key UNIQUE (email);

ALTER TABLE   utilisateur 
    ADD CONSTRAINT utilisateur_pkey PRIMARY KEY (idutilisateur);


-- Contraintes de clés étrangères
ALTER TABLE   activiteenfant 
    ADD CONSTRAINT fk_activite_heritage__activite FOREIGN KEY (idactivite) REFERENCES activite(idactivite);

ALTER TABLE   activiteadulte 
    ADD CONSTRAINT fk_activite_heritage__activite FOREIGN KEY (idactivite) REFERENCES activite(idactivite);

ALTER TABLE   activite 
    ADD CONSTRAINT fk_activite_partenaire FOREIGN KEY (idpartenaire) REFERENCES partenaires(idpartenaire) ON DELETE SET NULL;

ALTER TABLE   activiteadulte 
    ADD CONSTRAINT fk_activite_s_entrela_typeacti FOREIGN KEY (numtypeactivite) REFERENCES typeactivite(numtypeactivite);

ALTER TABLE   activiteenfant 
    ADD CONSTRAINT fk_activite_se_rappor_tranchea FOREIGN KEY (numtranche) REFERENCES trancheage(numtranche);

ALTER TABLE   type_chambre_sdb 
    ADD CONSTRAINT fk_assure_l_assure_la_equipeme FOREIGN KEY (numequipementsallebain) REFERENCES equipementsalledebain(numequipementsallebain);

ALTER TABLE   type_chambre_sdb 
    ADD CONSTRAINT fk_assure_l_assure_la_typecham FOREIGN KEY (idtypechambre) REFERENCES typechambre(idtypechambre);

ALTER TABLE   autrevoyageur 
    ADD CONSTRAINT fk_autrevoy_complete_reservat FOREIGN KEY (numreservation) REFERENCES reservation(numreservation);

ALTER TABLE   avis 
    ADD CONSTRAINT fk_avis_concerne_reservation FOREIGN KEY (numreservation) REFERENCES reservation(numreservation);

ALTER TABLE   avis 
    ADD CONSTRAINT fk_avis_correspon_club FOREIGN KEY (idclub) REFERENCES club(idclub);

ALTER TABLE   avis 
    ADD CONSTRAINT fk_avis_harmonise_client FOREIGN KEY (numclient) REFERENCES client(numclient);

ALTER TABLE   chambre 
    ADD CONSTRAINT fk_chambre_associati_typecham FOREIGN KEY (idtypechambre) REFERENCES typechambre(idtypechambre);

ALTER TABLE   client 
    ADD CONSTRAINT fk_client_croise_adresse FOREIGN KEY (numadresse) REFERENCES adresse(numadresse);

ALTER TABLE   club 
    ADD CONSTRAINT fk_club_pays FOREIGN KEY (numpays) REFERENCES souslocalisation(numpays);

ALTER TABLE   club 
    ADD CONSTRAINT fk_club_relate_photo FOREIGN KEY (numphoto) REFERENCES photo(numphoto);

ALTER TABLE   clubstation 
    ADD CONSTRAINT fk_clubstat_club_categorie_station FOREIGN KEY (numstation) REFERENCES station(numstation);

ALTER TABLE   clubstation 
    ADD CONSTRAINT fk_clubstat_heritage__club FOREIGN KEY (idclub) REFERENCES club(idclub);

ALTER TABLE   club_categorie 
    ADD CONSTRAINT fk_collabor_club_categorie_categori FOREIGN KEY (numcategory) REFERENCES categorie(numcategory);

ALTER TABLE   club_categorie 
    ADD CONSTRAINT fk_collabor_club_categorie_club FOREIGN KEY (idclub) REFERENCES club(idclub);

ALTER TABLE   club_regroupement 
    ADD CONSTRAINT fk_converge_converge__club FOREIGN KEY (idclub) REFERENCES club(idclub);

ALTER TABLE   club_regroupement 
    ADD CONSTRAINT fk_converge_converge__regroupe FOREIGN KEY (numregroupement) REFERENCES regroupement(numregroupement);

ALTER TABLE   disponibilite 
    ADD CONSTRAINT fk_disponib_disponibi_calendrier FOREIGN KEY (date) REFERENCES calendrier(date);

ALTER TABLE   disponibilite 
    ADD CONSTRAINT fk_disponib_disponibi_chambre FOREIGN KEY (numchambre) REFERENCES chambre(numchambre);

ALTER TABLE   disponibilite 
    ADD CONSTRAINT fk_disponib_disponibi_club FOREIGN KEY (idclub) REFERENCES club(idclub);

ALTER TABLE   equipement 
    ADD CONSTRAINT fk_equipeme_se_conjug_icon FOREIGN KEY (numicon) REFERENCES icon(numicon);

ALTER TABLE   club_restauration 
    ADD CONSTRAINT fk_club_restauration_club_restauration2_lieurest FOREIGN KEY (numrestauration) REFERENCES lieurestauration(numrestauration);

ALTER TABLE   categorie_localisation 
    ADD CONSTRAINT fk_club_restauration_club_restauration__categori FOREIGN KEY (numcategory) REFERENCES categorie(numcategory);

ALTER TABLE   categorie_localisation 
    ADD CONSTRAINT fk_club_restauration_club_restauration__localisa FOREIGN KEY (numlocalisation) REFERENCES localisation(numlocalisation);

ALTER TABLE   club_restauration 
    ADD CONSTRAINT fk_club_restauration_club_restauration_club FOREIGN KEY (idclub) REFERENCES club(idclub);

ALTER TABLE   icon 
    ADD CONSTRAINT fk_icon_interconn_equipeme FOREIGN KEY (numequipementsallebain) REFERENCES equipementsalledebain(numequipementsallebain);

ALTER TABLE   icon 
    ADD CONSTRAINT fk_icon_s_entrela_service FOREIGN KEY (numservice) REFERENCES service(numservice);

ALTER TABLE   icon 
    ADD CONSTRAINT fk_icon_se_relie__pointfor FOREIGN KEY (numpointfort) REFERENCES pointfort(numpointfort);

ALTER TABLE   club_activite 
    ADD CONSTRAINT fk_incruste_incruste__activite FOREIGN KEY (idactivite) REFERENCES activite(idactivite);

ALTER TABLE   club_activite 
    ADD CONSTRAINT fk_incruste_incruste__club FOREIGN KEY (idclub) REFERENCES club(idclub);

ALTER TABLE   lieurestauration 
    ADD CONSTRAINT fk_lieurest_rapproche_photo FOREIGN KEY (numphoto) REFERENCES photo(numphoto);

ALTER TABLE   photo_club 
    ADD CONSTRAINT fk_photo_club_club FOREIGN KEY (idclub) REFERENCES club(idclub);

ALTER TABLE   photo_club 
    ADD CONSTRAINT fk_photo_club_photo FOREIGN KEY (numphoto) REFERENCES photo(numphoto);

ALTER TABLE   photoavis 
    ADD CONSTRAINT fk_photoavis_avis FOREIGN KEY (numavis) REFERENCES avis(numavis) ON UPDATE RESTRICT ON DELETE RESTRICT;

ALTER TABLE   photoavis 
    ADD CONSTRAINT fk_photoavis_photo FOREIGN KEY (numphoto) REFERENCES photo(numphoto) ON UPDATE RESTRICT ON DELETE RESTRICT;

ALTER TABLE   prix_periode 
    ADD CONSTRAINT fk_prix_per_prix_peri_periode FOREIGN KEY (numperiode) REFERENCES periode(numperiode);

ALTER TABLE   prix_periode 
    ADD CONSTRAINT fk_prix_per_prix_peri_typecham FOREIGN KEY (idtypechambre) REFERENCES typechambre(idtypechambre);

ALTER TABLE   reservation 
    ADD CONSTRAINT fk_reservat_associati_transpor FOREIGN KEY (idtransport) REFERENCES transport(idtransport);

ALTER TABLE   reservation 
    ADD CONSTRAINT fk_reservat_enchaine_club FOREIGN KEY (idclub) REFERENCES club(idclub);

ALTER TABLE   reservation 
    ADD CONSTRAINT fk_reservat_tend_vers_client FOREIGN KEY (numclient) REFERENCES client(numclient);

ALTER TABLE   pays_region 
    ADD CONSTRAINT fk_s_articu_s_articul_localisa FOREIGN KEY (numlocalisation) REFERENCES localisation(numlocalisation);

ALTER TABLE   pays_region 
    ADD CONSTRAINT fk_s_articu_s_articul_sousloca FOREIGN KEY (numpays) REFERENCES souslocalisation(numpays);

ALTER TABLE   categorie_type_club 
    ADD CONSTRAINT fk_s_harmon_s_harmoni_categori FOREIGN KEY (numcategory) REFERENCES categorie(numcategory);

ALTER TABLE   categorie_type_club 
    ADD CONSTRAINT fk_s_harmon_s_harmoni_typeclub FOREIGN KEY (numtype) REFERENCES typeclub(numtype);

ALTER TABLE   type_chambre_service 
    ADD CONSTRAINT fk_s_imbriq_s_imbriqu_service FOREIGN KEY (numservice) REFERENCES service(numservice);

ALTER TABLE   type_chambre_service 
    ADD CONSTRAINT fk_s_imbriq_s_imbriqu_typecham FOREIGN KEY (idtypechambre) REFERENCES typechambre(idtypechambre);

ALTER TABLE   club_chambre 
    ADD CONSTRAINT fk_club_chambre_club_chambre2_chambre FOREIGN KEY (numchambre) REFERENCES chambre(numchambre);

ALTER TABLE   club_chambre 
    ADD CONSTRAINT fk_club_chambre_club_chambre_club FOREIGN KEY (idclub) REFERENCES club(idclub);

ALTER TABLE   reservation_activite 
    ADD CONSTRAINT fk_reservation_activite_reservation_activite2_activite FOREIGN KEY (idactivite) REFERENCES activite(idactivite);

ALTER TABLE   reservation_activite 
    ADD CONSTRAINT fk_reservation_activite_reservation_activite_reservat FOREIGN KEY (numreservation) REFERENCES reservation(numreservation);

ALTER TABLE   type_chambre_equipement 
    ADD CONSTRAINT fk_se_met_e_se_met_en_equipeme FOREIGN KEY (numequipement) REFERENCES equipement(numequipement);

ALTER TABLE   type_chambre_equipement 
    ADD CONSTRAINT fk_se_met_e_se_met_en_typecham FOREIGN KEY (idtypechambre) REFERENCES typechambre(idtypechambre);

ALTER TABLE   souslocalisation 
    ADD CONSTRAINT fk_sousloca_s_integre_photo FOREIGN KEY (numphoto) REFERENCES photo(numphoto);

ALTER TABLE   station 
    ADD CONSTRAINT fk_station_se_coordo_photo FOREIGN KEY (numphoto) REFERENCES photo(numphoto);

ALTER TABLE   type_chambre_pointfort 
    ADD CONSTRAINT fk_synchron_synchroni_pointfor FOREIGN KEY (numpointfort) REFERENCES pointfort(numpointfort);

ALTER TABLE   type_chambre_pointfort 
    ADD CONSTRAINT fk_synchron_synchroni_typecham FOREIGN KEY (idtypechambre) REFERENCES typechambre(idtypechambre);

ALTER TABLE   transaction 
    ADD CONSTRAINT fk_transac_res FOREIGN KEY (numreservation) REFERENCES reservation(numreservation);

ALTER TABLE   typeactivite 
    ADD CONSTRAINT fk_typeacti_se_croise_photo FOREIGN KEY (numphoto) REFERENCES photo(numphoto);

ALTER TABLE   typechambre 
    ADD CONSTRAINT fk_typecham_entre_en__photo FOREIGN KEY (numphoto) REFERENCES photo(numphoto);

ALTER TABLE   typechambre 
    ADD CONSTRAINT fk_typechambre_club FOREIGN KEY (idclub) REFERENCES club(idclub) ON DELETE CASCADE;


