using System;
using Microsoft.EntityFrameworkCore.Migrations;
using Npgsql.EntityFrameworkCore.PostgreSQL.Metadata;

#nullable disable

namespace ClubMed.Migrations
{
    /// <inheritdoc />
    public partial class CreationInitiale : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "t_e_activite_act",
                columns: table => new
                {
                    act_id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    act_titre = table.Column<string>(type: "character varying(1024)", maxLength: 1024, nullable: true),
                    act_description = table.Column<string>(type: "character varying(1024)", maxLength: 1024, nullable: false),
                    act_prixmin = table.Column<decimal>(type: "numeric(18,2)", nullable: false),
                    act_idpartenaire = table.Column<int>(type: "integer", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_activite", x => x.act_id);
                });

            migrationBuilder.CreateTable(
                name: "t_e_adresse_adr",
                columns: table => new
                {
                    adr_numadresse = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    adr_numrue = table.Column<int>(type: "integer", nullable: false),
                    adr_nomrue = table.Column<string>(type: "character varying(1024)", maxLength: 1024, nullable: false),
                    adr_codepostal = table.Column<string>(type: "char(5)", maxLength: 5, nullable: false),
                    adr_ville = table.Column<string>(type: "character varying(1024)", maxLength: 1024, nullable: false),
                    adr_pays = table.Column<string>(type: "character varying(1024)", maxLength: 1024, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_adresse", x => x.adr_numadresse);
                });

            migrationBuilder.CreateTable(
                name: "t_e_calendrier_cal",
                columns: table => new
                {
                    cal_date = table.Column<DateTime>(type: "timestamp with time zone", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_calendrier", x => x.cal_date);
                });

            migrationBuilder.CreateTable(
                name: "t_e_categorie_cat",
                columns: table => new
                {
                    cat_numcategory = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    cat_nomcategory = table.Column<string>(type: "character varying(100)", maxLength: 100, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_numcategory", x => x.cat_numcategory);
                });

            migrationBuilder.CreateTable(
                name: "t_e_equipementsalledebain_esb",
                columns: table => new
                {
                    esb_num = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    esb_nom = table.Column<string>(type: "character varying(1024)", maxLength: 1024, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_equipementsalledebain", x => x.esb_num);
                });

            migrationBuilder.CreateTable(
                name: "t_e_lieurestauration_lre",
                columns: table => new
                {
                    lre_numrestauration = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    lre_numphoto = table.Column<int>(type: "integer", nullable: false),
                    lre_presentation = table.Column<string>(type: "character varying(1024)", nullable: true),
                    lre_nom = table.Column<string>(type: "character varying(1024)", nullable: false),
                    lre_description = table.Column<string>(type: "character varying(1024)", nullable: false),
                    lre_estbar = table.Column<bool>(type: "boolean", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_lre_numrestauration", x => x.lre_numrestauration);
                });

            migrationBuilder.CreateTable(
                name: "t_e_partenaire_par",
                columns: table => new
                {
                    par_id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    par_nom = table.Column<string>(type: "character varying(255)", maxLength: 255, nullable: false),
                    par_email = table.Column<string>(type: "character varying(255)", maxLength: 255, nullable: true),
                    par_telephone = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_partenaire", x => x.par_id);
                });

            migrationBuilder.CreateTable(
                name: "t_e_periode_per",
                columns: table => new
                {
                    per_num = table.Column<string>(type: "character varying(10)", maxLength: 10, nullable: false),
                    per_datedeb = table.Column<DateTime>(type: "date", nullable: true),
                    per_datefin = table.Column<DateTime>(type: "date", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_periode", x => x.per_num);
                });

            migrationBuilder.CreateTable(
                name: "t_e_photo_pho",
                columns: table => new
                {
                    pho_numphoto = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    pho_url = table.Column<string>(type: "character varying(1024)", maxLength: 1024, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pho_numphoto", x => x.pho_numphoto);
                });

            migrationBuilder.CreateTable(
                name: "t_e_pointfort_ptf",
                columns: table => new
                {
                    ptf_numpointfort = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    ptf_nom = table.Column<string>(type: "character varying(1024)", maxLength: 1024, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_pointfort", x => x.ptf_numpointfort);
                });

            migrationBuilder.CreateTable(
                name: "t_e_service_srv",
                columns: table => new
                {
                    srv_num = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    srv_nom = table.Column<string>(type: "character varying(1024)", maxLength: 1024, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_service", x => x.srv_num);
                });

            migrationBuilder.CreateTable(
                name: "t_e_station_sta",
                columns: table => new
                {
                    sta_id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    sta_numphoto = table.Column<int>(type: "integer", nullable: false),
                    sta_nomstation = table.Column<string>(type: "character varying(1024)", maxLength: 1024, nullable: false),
                    sta_altitudestation = table.Column<decimal>(type: "numeric(10,2)", nullable: false),
                    sta_longueurpistes = table.Column<decimal>(type: "numeric(10,2)", nullable: false),
                    sta_nbpistes = table.Column<int>(type: "integer", nullable: false),
                    sta_infoski = table.Column<string>(type: "text", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_station", x => x.sta_id);
                });

            migrationBuilder.CreateTable(
                name: "t_e_trancheage_tra",
                columns: table => new
                {
                    tra_numtranche = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    tra_agemin = table.Column<int>(type: "integer", nullable: false),
                    tra_agemax = table.Column<int>(type: "integer", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_trancheage", x => x.tra_numtranche);
                });

            migrationBuilder.CreateTable(
                name: "t_e_transport_tra",
                columns: table => new
                {
                    tra_id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    tra_lieudepart = table.Column<string>(type: "character varying(1024)", maxLength: 1024, nullable: false),
                    tra_prix = table.Column<decimal>(type: "numeric(18,2)", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_transport", x => x.tra_id);
                });

            migrationBuilder.CreateTable(
                name: "t_e_typeactivite_tya",
                columns: table => new
                {
                    tya_numtypeactivite = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    tya_numphoto = table.Column<int>(type: "integer", nullable: false),
                    tya_description = table.Column<string>(type: "character varying(1024)", maxLength: 1024, nullable: false),
                    tya_nbactivitecarte = table.Column<int>(type: "integer", nullable: false),
                    tya_nbactiviteincluse = table.Column<int>(type: "integer", nullable: false),
                    tya_titre = table.Column<string>(type: "character varying(1024)", maxLength: 1024, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_typeactivite", x => x.tya_numtypeactivite);
                });

            migrationBuilder.CreateTable(
                name: "t_e_typeclub_tcl",
                columns: table => new
                {
                    tcl_numtype = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    tcl_nomtype = table.Column<string>(type: "character varying(100)", maxLength: 100, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_typeclub", x => x.tcl_numtype);
                });

            migrationBuilder.CreateTable(
                name: "t_j_clubactivite_cla",
                columns: table => new
                {
                    cla_idclub = table.Column<int>(type: "integer", nullable: false),
                    cla_idactivite = table.Column<int>(type: "integer", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_clubactivite", x => new { x.cla_idclub, x.cla_idactivite });
                });

            migrationBuilder.CreateTable(
                name: "t_r_localisation_loc",
                columns: table => new
                {
                    loc_numlocalisation = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    loc_nomlocalisation = table.Column<string>(type: "character varying(1024)", maxLength: 1024, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_localisation", x => x.loc_numlocalisation);
                });

            migrationBuilder.CreateTable(
                name: "t_r_regroupement_rgr",
                columns: table => new
                {
                    rgr_numregroupement = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    rgr_libelleregroupement = table.Column<string>(type: "character varying(1024)", maxLength: 1024, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_regroupement", x => x.rgr_numregroupement);
                });

            migrationBuilder.CreateTable(
                name: "t_r_souslocalisation_slc",
                columns: table => new
                {
                    slc_numpays = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    slc_numphoto = table.Column<int>(type: "integer", nullable: false),
                    slc_nompays = table.Column<string>(type: "character varying(1024)", maxLength: 1024, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_souslocalisation", x => x.slc_numpays);
                });

            migrationBuilder.CreateTable(
                name: "t_e_client_cli",
                columns: table => new
                {
                    cli_numclient = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    cli_numadresse = table.Column<int>(type: "integer", nullable: true),
                    cli_genre = table.Column<string>(type: "character varying(1024)", maxLength: 1024, nullable: true),
                    cli_prenom = table.Column<string>(type: "character varying(1024)", maxLength: 1024, nullable: false),
                    cli_nom = table.Column<string>(type: "character varying(1024)", maxLength: 1024, nullable: false),
                    cli_datenaissance = table.Column<DateTime>(type: "date", nullable: true),
                    cli_email = table.Column<string>(type: "character varying(1024)", maxLength: 1024, nullable: false),
                    cli_telephone = table.Column<string>(type: "character varying(1024)", maxLength: 1024, nullable: true),
                    cli_motdepasse_crypter = table.Column<string>(type: "character varying(1024)", maxLength: 1024, nullable: false),
                    cli_role = table.Column<string>(type: "character varying(20)", maxLength: 20, nullable: true, defaultValue: "client"),
                    cli_a2f_active = table.Column<bool>(type: "boolean", nullable: true, defaultValue: false),
                    cli_stripe_id = table.Column<string>(type: "character varying(255)", maxLength: 255, nullable: true),
                    cli_pm_type = table.Column<string>(type: "character varying(255)", maxLength: 255, nullable: true),
                    cli_pm_last_four = table.Column<string>(type: "char(4)", maxLength: 4, nullable: true),
                    cli_trial_ends_at = table.Column<DateTime>(type: "timestamp with time zone", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_client", x => x.cli_numclient);
                    table.CheckConstraint("ck_email", "((cli_email)::text ~~ '%_@_%._%'::text)");
                    table.ForeignKey(
                        name: "fk_client_adresse",
                        column: x => x.cli_numadresse,
                        principalTable: "t_e_adresse_adr",
                        principalColumn: "adr_numadresse",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "t_e_disponibilite_dis",
                columns: table => new
                {
                    dis_date = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    dis_numchambre = table.Column<int>(type: "integer", nullable: false),
                    dis_idclub = table.Column<int>(type: "integer", nullable: false),
                    dis_estdisponibilite = table.Column<bool>(type: "boolean", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_disponibilite", x => new { x.dis_date, x.dis_numchambre, x.dis_idclub });
                    table.ForeignKey(
                        name: "fk_disponibilite_calendrier",
                        column: x => x.dis_date,
                        principalTable: "t_e_calendrier_cal",
                        principalColumn: "cal_date",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "t_e_icon_ico",
                columns: table => new
                {
                    ico_num = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    ptf_num = table.Column<int>(type: "integer", nullable: false),
                    srv_num = table.Column<int>(type: "integer", nullable: false),
                    esb_num = table.Column<int>(type: "integer", nullable: false),
                    ico_lien = table.Column<string>(type: "character varying(1024)", maxLength: 1024, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_icon", x => x.ico_num);
                    table.ForeignKey(
                        name: "fk_icon_equipementsalledebain",
                        column: x => x.esb_num,
                        principalTable: "t_e_equipementsalledebain_esb",
                        principalColumn: "esb_num",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "fk_icon_pointfort",
                        column: x => x.ptf_num,
                        principalTable: "t_e_pointfort_ptf",
                        principalColumn: "ptf_numpointfort",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "fk_icon_service",
                        column: x => x.srv_num,
                        principalTable: "t_e_service_srv",
                        principalColumn: "srv_num",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "t_e_activiteenfant_ace",
                columns: table => new
                {
                    ace_id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    ace_numtranche = table.Column<int>(type: "integer", nullable: false),
                    ace_titre = table.Column<string>(type: "character varying(1024)", maxLength: 1024, nullable: false),
                    ace_description = table.Column<string>(type: "character varying(1024)", maxLength: 1024, nullable: false),
                    ace_prixmin = table.Column<decimal>(type: "numeric(18,2)", nullable: false),
                    ace_detail = table.Column<string>(type: "character varying(1024)", maxLength: 1024, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_activiteenfant", x => x.ace_id);
                    table.ForeignKey(
                        name: "fk_activiteenfant_trancheage",
                        column: x => x.ace_numtranche,
                        principalTable: "t_e_trancheage_tra",
                        principalColumn: "tra_numtranche",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "t_e_reservation_res",
                columns: table => new
                {
                    res_numreservation = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    res_idclub = table.Column<int>(type: "integer", nullable: false),
                    res_idtransport = table.Column<int>(type: "integer", nullable: false),
                    res_numclient = table.Column<int>(type: "integer", nullable: false),
                    res_datedebut = table.Column<DateTime>(type: "timestamp with time zone", nullable: true),
                    res_datefin = table.Column<DateTime>(type: "timestamp with time zone", nullable: true),
                    res_nbpersonnes = table.Column<int>(type: "integer", nullable: true),
                    res_lieudepart = table.Column<string>(type: "character varying(1024)", maxLength: 1024, nullable: true),
                    res_prix = table.Column<decimal>(type: "numeric(18,2)", nullable: true),
                    res_statut = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: false, defaultValue: "EN_ATTENTE"),
                    res_etatcalcule = table.Column<string>(type: "character varying(20)", maxLength: 20, nullable: true),
                    res_mail = table.Column<bool>(type: "boolean", nullable: true, defaultValue: false),
                    res_disponibiliteconfirmee = table.Column<bool>(type: "boolean", nullable: true, defaultValue: false),
                    res_mailconfirmationenvoye = table.Column<bool>(type: "boolean", nullable: true),
                    res_veutannuler = table.Column<bool>(type: "boolean", nullable: true, defaultValue: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_reservation", x => x.res_numreservation);
                    table.ForeignKey(
                        name: "fk_reservation_transport",
                        column: x => x.res_idtransport,
                        principalTable: "t_e_transport_tra",
                        principalColumn: "tra_id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "t_e_activiteadulte_aca",
                columns: table => new
                {
                    aca_id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    aca_numtypeactivite = table.Column<int>(type: "integer", nullable: false),
                    aca_titre = table.Column<string>(type: "character varying(1024)", maxLength: 1024, nullable: false),
                    aca_description = table.Column<string>(type: "character varying(1024)", maxLength: 1024, nullable: false),
                    aca_prixmin = table.Column<decimal>(type: "numeric(18,2)", nullable: false),
                    aca_duree = table.Column<decimal>(type: "numeric(18,2)", nullable: false),
                    aca_ageminimum = table.Column<int>(type: "integer", nullable: false),
                    aca_frequence = table.Column<string>(type: "character varying(1024)", maxLength: 1024, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_activiteadulte", x => x.aca_id);
                    table.ForeignKey(
                        name: "fk_activiteadulte_typeactivite",
                        column: x => x.aca_numtypeactivite,
                        principalTable: "t_e_typeactivite_tya",
                        principalColumn: "tya_numtypeactivite",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "t_e_categorietypeclub_ctc",
                columns: table => new
                {
                    cat_numcategory = table.Column<int>(type: "integer", nullable: false),
                    tcl_numtype = table.Column<int>(type: "integer", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_categorie_typeclub", x => new { x.cat_numcategory, x.tcl_numtype });
                    table.ForeignKey(
                        name: "fk_categorie_typeclub_category",
                        column: x => x.cat_numcategory,
                        principalTable: "t_e_categorie_cat",
                        principalColumn: "cat_numcategory",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "fk_categorie_typeclub_typeclub",
                        column: x => x.tcl_numtype,
                        principalTable: "t_e_typeclub_tcl",
                        principalColumn: "tcl_numtype",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "t_e_categorielocalisation_clo",
                columns: table => new
                {
                    numcategory = table.Column<int>(type: "integer", nullable: false),
                    numlocalisation = table.Column<int>(type: "integer", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_categorie_localisation", x => new { x.numcategory, x.numlocalisation });
                    table.ForeignKey(
                        name: "fk_categorie_localisation_category",
                        column: x => x.numcategory,
                        principalTable: "t_e_categorie_cat",
                        principalColumn: "cat_numcategory",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "fk_categorie_localisation_localisation",
                        column: x => x.numlocalisation,
                        principalTable: "t_r_localisation_loc",
                        principalColumn: "loc_numlocalisation",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "t_e_club_clu",
                columns: table => new
                {
                    clu_id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    clu_numphoto = table.Column<int>(type: "integer", nullable: false),
                    clu_titre = table.Column<string>(type: "character varying(100)", maxLength: 100, nullable: true),
                    clu_description = table.Column<string>(type: "text", nullable: true),
                    clu_notemoyenne = table.Column<decimal>(type: "numeric(3,2)", nullable: true),
                    clu_lienpdf = table.Column<string>(type: "character varying(1024)", maxLength: 1024, nullable: true),
                    clu_numpays = table.Column<int>(type: "integer", nullable: true),
                    clu_email = table.Column<string>(type: "character varying(255)", maxLength: 255, nullable: true),
                    clu_statut_mise_en_ligne = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: true, defaultValue: "EN_CREATION")
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_club", x => x.clu_id);
                    table.ForeignKey(
                        name: "fk_club_souslocalisation",
                        column: x => x.clu_numpays,
                        principalTable: "t_r_souslocalisation_slc",
                        principalColumn: "slc_numpays");
                });

            migrationBuilder.CreateTable(
                name: "t_j_paysregion_pyr",
                columns: table => new
                {
                    pyr_numlocalisation = table.Column<int>(type: "integer", nullable: false),
                    pyr_numpays = table.Column<int>(type: "integer", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_pays_region", x => new { x.pyr_numlocalisation, x.pyr_numpays });
                    table.ForeignKey(
                        name: "fk_pyr_loc",
                        column: x => x.pyr_numlocalisation,
                        principalTable: "t_r_localisation_loc",
                        principalColumn: "loc_numlocalisation",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "fk_pyr_slc",
                        column: x => x.pyr_numpays,
                        principalTable: "t_r_souslocalisation_slc",
                        principalColumn: "slc_numpays",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "t_e_equipement_equ",
                columns: table => new
                {
                    equ_num = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    icn_num = table.Column<int>(type: "integer", nullable: false),
                    equ_nom = table.Column<string>(type: "character varying(1024)", maxLength: 1024, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_equipement", x => x.equ_num);
                    table.ForeignKey(
                        name: "fk_equipement_icon",
                        column: x => x.icn_num,
                        principalTable: "t_e_icon_ico",
                        principalColumn: "ico_num",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "t_e_autrevoyageur_auv",
                columns: table => new
                {
                    auv_numvoyageur = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    auv_numreservation = table.Column<int>(type: "integer", nullable: false),
                    auv_genre = table.Column<string>(type: "character varying(1024)", maxLength: 1024, nullable: true),
                    auv_prenom = table.Column<string>(type: "character varying(1024)", maxLength: 1024, nullable: true),
                    auv_nom = table.Column<string>(type: "character varying(1024)", maxLength: 1024, nullable: false),
                    auv_datenaissance = table.Column<DateTime>(type: "timestamp with time zone", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_autrevoyageur", x => x.auv_numvoyageur);
                    table.ForeignKey(
                        name: "fk_autrevoyageur_reservation",
                        column: x => x.auv_numreservation,
                        principalTable: "t_e_reservation_res",
                        principalColumn: "res_numreservation",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "t_e_transaction_trs",
                columns: table => new
                {
                    trs_id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    trs_numreservation = table.Column<int>(type: "integer", nullable: false),
                    trs_montant = table.Column<decimal>(type: "numeric(18,2)", nullable: false),
                    trs_datetransaction = table.Column<DateTime>(type: "timestamp with time zone", nullable: false, defaultValueSql: "CURRENT_TIMESTAMP"),
                    trs_moyenpaiement = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: false),
                    trs_statutpaiement = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_transaction", x => x.trs_id);
                    table.ForeignKey(
                        name: "fk_transaction_reservation",
                        column: x => x.trs_numreservation,
                        principalTable: "t_e_reservation_res",
                        principalColumn: "res_numreservation",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "t_j_activitereservation_rea",
                columns: table => new
                {
                    rea_numreservation = table.Column<int>(type: "integer", nullable: false),
                    rea_idactivite = table.Column<int>(type: "integer", nullable: false),
                    rea_nbpersonnes = table.Column<int>(type: "integer", nullable: false),
                    rea_disponibiliteconfirmee = table.Column<bool>(type: "boolean", nullable: false, defaultValue: false),
                    rea_token = table.Column<string>(type: "character varying(255)", maxLength: 255, nullable: true),
                    rea_dateenvoi = table.Column<DateTime>(type: "timestamp with time zone", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_activitereservation", x => new { x.rea_numreservation, x.rea_idactivite });
                    table.ForeignKey(
                        name: "fk_activitereservation_reservation",
                        column: x => x.rea_numreservation,
                        principalTable: "t_e_reservation_res",
                        principalColumn: "res_numreservation",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "t_e_typechambre_tch",
                columns: table => new
                {
                    tch_id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    pht_id = table.Column<int>(type: "integer", nullable: false),
                    tch_nom = table.Column<string>(type: "character varying(1024)", maxLength: 1024, nullable: true),
                    tch_surface = table.Column<double>(type: "double precision", nullable: true),
                    tch_textepresentation = table.Column<string>(type: "character varying(1024)", maxLength: 1024, nullable: true),
                    tch_capacitemax = table.Column<int>(type: "integer", nullable: true),
                    clu_id = table.Column<int>(type: "integer", nullable: false),
                    tch_indisponible = table.Column<bool>(type: "boolean", nullable: true, defaultValue: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_typechambre", x => x.tch_id);
                    table.ForeignKey(
                        name: "fk_club_typechambre",
                        column: x => x.clu_id,
                        principalTable: "t_e_club_clu",
                        principalColumn: "clu_id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "fk_typechambre_photo",
                        column: x => x.pht_id,
                        principalTable: "t_e_photo_pho",
                        principalColumn: "pho_numphoto",
                        onDelete: ReferentialAction.SetNull);
                });

            migrationBuilder.CreateTable(
                name: "t_j_avis_avi",
                columns: table => new
                {
                    avi_numavis = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    clu_idclub = table.Column<int>(type: "integer", nullable: false),
                    cli_numclient = table.Column<int>(type: "integer", nullable: false),
                    avi_titre = table.Column<string>(type: "character varying(100)", maxLength: 100, nullable: true),
                    avi_commentaire = table.Column<string>(type: "text", nullable: false),
                    avi_note = table.Column<int>(type: "integer", nullable: false),
                    res_numreservation = table.Column<int>(type: "integer", nullable: false),
                    avi_reponse = table.Column<string>(type: "text", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_avis", x => x.avi_numavis);
                    table.ForeignKey(
                        name: "fk_avis_client",
                        column: x => x.cli_numclient,
                        principalTable: "t_e_client_cli",
                        principalColumn: "cli_numclient",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "fk_avis_club",
                        column: x => x.clu_idclub,
                        principalTable: "t_e_club_clu",
                        principalColumn: "clu_id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "t_j_clubcategorie_cca",
                columns: table => new
                {
                    clu_idclub = table.Column<int>(type: "integer", nullable: false),
                    cat_numcategory = table.Column<int>(type: "integer", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_club_categorie", x => new { x.clu_idclub, x.cat_numcategory });
                    table.ForeignKey(
                        name: "FK_t_j_clubcategorie_cca_t_e_categorie_cat_cat_numcategory",
                        column: x => x.cat_numcategory,
                        principalTable: "t_e_categorie_cat",
                        principalColumn: "cat_numcategory",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_t_j_clubcategorie_cca_t_e_club_clu_clu_idclub",
                        column: x => x.clu_idclub,
                        principalTable: "t_e_club_clu",
                        principalColumn: "clu_id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "t_j_clubregroupement_crg",
                columns: table => new
                {
                    crg_idclub = table.Column<int>(type: "integer", nullable: false),
                    crg_numregroupement = table.Column<int>(type: "integer", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_club_regroupement", x => new { x.crg_idclub, x.crg_numregroupement });
                    table.ForeignKey(
                        name: "fk_crg_clb",
                        column: x => x.crg_idclub,
                        principalTable: "t_e_club_clu",
                        principalColumn: "clu_id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "fk_crg_rgr",
                        column: x => x.crg_numregroupement,
                        principalTable: "t_r_regroupement_rgr",
                        principalColumn: "rgr_numregroupement",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "t_j_clubrestauration_cre",
                columns: table => new
                {
                    clu_idclub = table.Column<int>(type: "integer", nullable: false),
                    lre_numrestauration = table.Column<int>(type: "integer", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_club_lieurestuaration", x => new { x.clu_idclub, x.lre_numrestauration });
                    table.ForeignKey(
                        name: "fk_clubrestauration_club",
                        column: x => x.clu_idclub,
                        principalTable: "t_e_club_clu",
                        principalColumn: "clu_id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "fk_clubrestauration_lieurestauration",
                        column: x => x.lre_numrestauration,
                        principalTable: "t_e_lieurestauration_lre",
                        principalColumn: "lre_numrestauration",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "t_j_clubstation_clu",
                columns: table => new
                {
                    clu_id = table.Column<int>(type: "integer", nullable: false),
                    sta_id = table.Column<int>(type: "integer", nullable: false),
                    clu_numphoto = table.Column<int>(type: "integer", nullable: true),
                    clu_titre = table.Column<string>(type: "character varying(100)", maxLength: 100, nullable: true),
                    clu_description = table.Column<string>(type: "text", nullable: false),
                    clu_notemoyenne = table.Column<decimal>(type: "numeric(3,2)", nullable: false),
                    clu_lienpdf = table.Column<string>(type: "character varying(1024)", maxLength: 1024, nullable: false),
                    clu_altitudeclub = table.Column<string>(type: "char(10)", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_club_station", x => new { x.clu_id, x.sta_id });
                    table.ForeignKey(
                        name: "fk_clubstation_club",
                        column: x => x.clu_id,
                        principalTable: "t_e_club_clu",
                        principalColumn: "clu_id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "fk_clubstation_station",
                        column: x => x.sta_id,
                        principalTable: "t_e_station_sta",
                        principalColumn: "sta_id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "t_j_photo_club_pcl",
                columns: table => new
                {
                    clu_idclub = table.Column<int>(type: "integer", nullable: false),
                    pho_numphoto = table.Column<int>(type: "integer", nullable: false),
                    pcl_ordre = table.Column<int>(type: "integer", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_club_photo", x => new { x.clu_idclub, x.pho_numphoto });
                    table.ForeignKey(
                        name: "fk_club_photo_club",
                        column: x => x.clu_idclub,
                        principalTable: "t_e_club_clu",
                        principalColumn: "clu_id");
                    table.ForeignKey(
                        name: "fk_club_photo_photo",
                        column: x => x.pho_numphoto,
                        principalTable: "t_e_photo_pho",
                        principalColumn: "pho_numphoto");
                });

            migrationBuilder.CreateTable(
                name: "t_e_chambre_cha",
                columns: table => new
                {
                    cha_num = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    tch_id = table.Column<int>(type: "integer", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_chambre", x => x.cha_num);
                    table.ForeignKey(
                        name: "fk_chambre_typechambre",
                        column: x => x.tch_id,
                        principalTable: "t_e_typechambre_tch",
                        principalColumn: "tch_id",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "t_e_typechambresdb_tcs",
                columns: table => new
                {
                    esb_num = table.Column<int>(type: "integer", nullable: false),
                    tch_id = table.Column<int>(type: "integer", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_type_chambre_sdb", x => new { x.esb_num, x.tch_id });
                    table.ForeignKey(
                        name: "fk_type_chambre_sdb_equipementsalledebain",
                        column: x => x.esb_num,
                        principalTable: "t_e_equipementsalledebain_esb",
                        principalColumn: "esb_num",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "fk_type_chambre_sdb_typechambre",
                        column: x => x.tch_id,
                        principalTable: "t_e_typechambre_tch",
                        principalColumn: "tch_id",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "t_j_prixperiode_prp",
                columns: table => new
                {
                    per_num = table.Column<string>(type: "character varying(10)", maxLength: 10, nullable: false),
                    tch_id = table.Column<int>(type: "integer", nullable: false),
                    prp_prixperiode = table.Column<decimal>(type: "numeric(10,2)", precision: 10, scale: 2, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_prix_periode", x => new { x.per_num, x.tch_id });
                    table.ForeignKey(
                        name: "fk_prix_periode_periode",
                        column: x => x.per_num,
                        principalTable: "t_e_periode_per",
                        principalColumn: "per_num",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "fk_prix_periode_typechambre",
                        column: x => x.tch_id,
                        principalTable: "t_e_typechambre_tch",
                        principalColumn: "tch_id",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "t_j_typechambreequipement_tce",
                columns: table => new
                {
                    equ_numequipement = table.Column<int>(type: "integer", nullable: false),
                    tch_id = table.Column<int>(type: "integer", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_type_chambre_equipement", x => new { x.equ_numequipement, x.tch_id });
                    table.ForeignKey(
                        name: "fk_type_chambre_equipement_equipement",
                        column: x => x.equ_numequipement,
                        principalTable: "t_e_equipement_equ",
                        principalColumn: "equ_num",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "fk_type_chambre_equipement_typechambre",
                        column: x => x.tch_id,
                        principalTable: "t_e_typechambre_tch",
                        principalColumn: "tch_id",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "t_j_typechambrepointfort_tpf",
                columns: table => new
                {
                    numpointfort = table.Column<int>(type: "integer", nullable: false),
                    idtypechambre = table.Column<int>(type: "integer", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_type_chambre_pointfort", x => new { x.numpointfort, x.idtypechambre });
                    table.ForeignKey(
                        name: "fk_type_chambre_pointfort_pointfort",
                        column: x => x.numpointfort,
                        principalTable: "t_e_pointfort_ptf",
                        principalColumn: "ptf_numpointfort",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "fk_type_chambre_pointfort_typechambre",
                        column: x => x.idtypechambre,
                        principalTable: "t_e_typechambre_tch",
                        principalColumn: "tch_id",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "t_j_typechambreservice_tcr",
                columns: table => new
                {
                    numservice = table.Column<int>(type: "integer", nullable: false),
                    idtypechambre = table.Column<int>(type: "integer", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_type_chambre_service", x => new { x.numservice, x.idtypechambre });
                    table.ForeignKey(
                        name: "fk_type_chambre_service_service",
                        column: x => x.numservice,
                        principalTable: "t_e_service_srv",
                        principalColumn: "srv_num",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "fk_type_chambre_service_typechambre",
                        column: x => x.idtypechambre,
                        principalTable: "t_e_typechambre_tch",
                        principalColumn: "tch_id",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "t_j_photo_avis_pav",
                columns: table => new
                {
                    avi_numavis = table.Column<int>(type: "integer", nullable: false),
                    pho_numphoto = table.Column<int>(type: "integer", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_avis_photo", x => new { x.avi_numavis, x.pho_numphoto });
                    table.ForeignKey(
                        name: "FK_t_j_photo_avis_pav_t_e_photo_pho_pho_numphoto",
                        column: x => x.pho_numphoto,
                        principalTable: "t_e_photo_pho",
                        principalColumn: "pho_numphoto",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_t_j_photo_avis_pav_t_j_avis_avi_avi_numavis",
                        column: x => x.avi_numavis,
                        principalTable: "t_j_avis_avi",
                        principalColumn: "avi_numavis",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "t_j_clubchambre_cch",
                columns: table => new
                {
                    clu_id = table.Column<int>(type: "integer", nullable: false),
                    cha_num = table.Column<int>(type: "integer", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_club_chambre", x => new { x.clu_id, x.cha_num });
                    table.ForeignKey(
                        name: "fk_clubchambre_chambre",
                        column: x => x.cha_num,
                        principalTable: "t_e_chambre_cha",
                        principalColumn: "cha_num",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "fk_clubchambre_club",
                        column: x => x.clu_id,
                        principalTable: "t_e_club_clu",
                        principalColumn: "clu_id",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateIndex(
                name: "IX_t_e_activiteadulte_aca_aca_numtypeactivite",
                table: "t_e_activiteadulte_aca",
                column: "aca_numtypeactivite");

            migrationBuilder.CreateIndex(
                name: "IX_t_e_activiteenfant_ace_ace_numtranche",
                table: "t_e_activiteenfant_ace",
                column: "ace_numtranche");

            migrationBuilder.CreateIndex(
                name: "IX_t_e_autrevoyageur_auv_auv_numreservation",
                table: "t_e_autrevoyageur_auv",
                column: "auv_numreservation");

            migrationBuilder.CreateIndex(
                name: "IX_t_e_categorielocalisation_clo_numlocalisation",
                table: "t_e_categorielocalisation_clo",
                column: "numlocalisation");

            migrationBuilder.CreateIndex(
                name: "IX_t_e_categorietypeclub_ctc_tcl_numtype",
                table: "t_e_categorietypeclub_ctc",
                column: "tcl_numtype");

            migrationBuilder.CreateIndex(
                name: "IX_t_e_chambre_cha_tch_id",
                table: "t_e_chambre_cha",
                column: "tch_id");

            migrationBuilder.CreateIndex(
                name: "IX_t_e_client_cli_cli_numadresse",
                table: "t_e_client_cli",
                column: "cli_numadresse");

            migrationBuilder.CreateIndex(
                name: "uq_client_email",
                table: "t_e_client_cli",
                column: "cli_email",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_t_e_club_clu_clu_numpays",
                table: "t_e_club_clu",
                column: "clu_numpays");

            migrationBuilder.CreateIndex(
                name: "IX_t_e_equipement_equ_icn_num",
                table: "t_e_equipement_equ",
                column: "icn_num");

            migrationBuilder.CreateIndex(
                name: "IX_t_e_icon_ico_esb_num",
                table: "t_e_icon_ico",
                column: "esb_num");

            migrationBuilder.CreateIndex(
                name: "IX_t_e_icon_ico_ptf_num",
                table: "t_e_icon_ico",
                column: "ptf_num");

            migrationBuilder.CreateIndex(
                name: "IX_t_e_icon_ico_srv_num",
                table: "t_e_icon_ico",
                column: "srv_num");

            migrationBuilder.CreateIndex(
                name: "IX_t_e_reservation_res_res_idtransport",
                table: "t_e_reservation_res",
                column: "res_idtransport");

            migrationBuilder.CreateIndex(
                name: "IX_t_e_transaction_trs_trs_numreservation",
                table: "t_e_transaction_trs",
                column: "trs_numreservation");

            migrationBuilder.CreateIndex(
                name: "IX_t_e_typechambre_tch_clu_id",
                table: "t_e_typechambre_tch",
                column: "clu_id");

            migrationBuilder.CreateIndex(
                name: "IX_t_e_typechambre_tch_pht_id",
                table: "t_e_typechambre_tch",
                column: "pht_id");

            migrationBuilder.CreateIndex(
                name: "IX_t_e_typechambresdb_tcs_tch_id",
                table: "t_e_typechambresdb_tcs",
                column: "tch_id");

            migrationBuilder.CreateIndex(
                name: "IX_t_j_avis_avi_cli_numclient",
                table: "t_j_avis_avi",
                column: "cli_numclient");

            migrationBuilder.CreateIndex(
                name: "IX_t_j_avis_avi_clu_idclub",
                table: "t_j_avis_avi",
                column: "clu_idclub");

            migrationBuilder.CreateIndex(
                name: "IX_t_j_clubcategorie_cca_cat_numcategory",
                table: "t_j_clubcategorie_cca",
                column: "cat_numcategory");

            migrationBuilder.CreateIndex(
                name: "IX_t_j_clubchambre_cch_cha_num",
                table: "t_j_clubchambre_cch",
                column: "cha_num");

            migrationBuilder.CreateIndex(
                name: "IX_t_j_clubregroupement_crg_crg_numregroupement",
                table: "t_j_clubregroupement_crg",
                column: "crg_numregroupement");

            migrationBuilder.CreateIndex(
                name: "IX_t_j_clubrestauration_cre_lre_numrestauration",
                table: "t_j_clubrestauration_cre",
                column: "lre_numrestauration");

            migrationBuilder.CreateIndex(
                name: "IX_t_j_clubstation_clu_sta_id",
                table: "t_j_clubstation_clu",
                column: "sta_id");

            migrationBuilder.CreateIndex(
                name: "IX_t_j_paysregion_pyr_pyr_numpays",
                table: "t_j_paysregion_pyr",
                column: "pyr_numpays");

            migrationBuilder.CreateIndex(
                name: "IX_t_j_photo_avis_pav_pho_numphoto",
                table: "t_j_photo_avis_pav",
                column: "pho_numphoto");

            migrationBuilder.CreateIndex(
                name: "IX_t_j_photo_club_pcl_pho_numphoto",
                table: "t_j_photo_club_pcl",
                column: "pho_numphoto");

            migrationBuilder.CreateIndex(
                name: "IX_t_j_prixperiode_prp_tch_id",
                table: "t_j_prixperiode_prp",
                column: "tch_id");

            migrationBuilder.CreateIndex(
                name: "IX_t_j_typechambreequipement_tce_tch_id",
                table: "t_j_typechambreequipement_tce",
                column: "tch_id");

            migrationBuilder.CreateIndex(
                name: "IX_t_j_typechambrepointfort_tpf_idtypechambre",
                table: "t_j_typechambrepointfort_tpf",
                column: "idtypechambre");

            migrationBuilder.CreateIndex(
                name: "IX_t_j_typechambreservice_tcr_idtypechambre",
                table: "t_j_typechambreservice_tcr",
                column: "idtypechambre");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "t_e_activite_act");

            migrationBuilder.DropTable(
                name: "t_e_activiteadulte_aca");

            migrationBuilder.DropTable(
                name: "t_e_activiteenfant_ace");

            migrationBuilder.DropTable(
                name: "t_e_autrevoyageur_auv");

            migrationBuilder.DropTable(
                name: "t_e_categorielocalisation_clo");

            migrationBuilder.DropTable(
                name: "t_e_categorietypeclub_ctc");

            migrationBuilder.DropTable(
                name: "t_e_disponibilite_dis");

            migrationBuilder.DropTable(
                name: "t_e_partenaire_par");

            migrationBuilder.DropTable(
                name: "t_e_transaction_trs");

            migrationBuilder.DropTable(
                name: "t_e_typechambresdb_tcs");

            migrationBuilder.DropTable(
                name: "t_j_activitereservation_rea");

            migrationBuilder.DropTable(
                name: "t_j_clubactivite_cla");

            migrationBuilder.DropTable(
                name: "t_j_clubcategorie_cca");

            migrationBuilder.DropTable(
                name: "t_j_clubchambre_cch");

            migrationBuilder.DropTable(
                name: "t_j_clubregroupement_crg");

            migrationBuilder.DropTable(
                name: "t_j_clubrestauration_cre");

            migrationBuilder.DropTable(
                name: "t_j_clubstation_clu");

            migrationBuilder.DropTable(
                name: "t_j_paysregion_pyr");

            migrationBuilder.DropTable(
                name: "t_j_photo_avis_pav");

            migrationBuilder.DropTable(
                name: "t_j_photo_club_pcl");

            migrationBuilder.DropTable(
                name: "t_j_prixperiode_prp");

            migrationBuilder.DropTable(
                name: "t_j_typechambreequipement_tce");

            migrationBuilder.DropTable(
                name: "t_j_typechambrepointfort_tpf");

            migrationBuilder.DropTable(
                name: "t_j_typechambreservice_tcr");

            migrationBuilder.DropTable(
                name: "t_e_typeactivite_tya");

            migrationBuilder.DropTable(
                name: "t_e_trancheage_tra");

            migrationBuilder.DropTable(
                name: "t_e_typeclub_tcl");

            migrationBuilder.DropTable(
                name: "t_e_calendrier_cal");

            migrationBuilder.DropTable(
                name: "t_e_reservation_res");

            migrationBuilder.DropTable(
                name: "t_e_categorie_cat");

            migrationBuilder.DropTable(
                name: "t_e_chambre_cha");

            migrationBuilder.DropTable(
                name: "t_r_regroupement_rgr");

            migrationBuilder.DropTable(
                name: "t_e_lieurestauration_lre");

            migrationBuilder.DropTable(
                name: "t_e_station_sta");

            migrationBuilder.DropTable(
                name: "t_r_localisation_loc");

            migrationBuilder.DropTable(
                name: "t_j_avis_avi");

            migrationBuilder.DropTable(
                name: "t_e_periode_per");

            migrationBuilder.DropTable(
                name: "t_e_equipement_equ");

            migrationBuilder.DropTable(
                name: "t_e_transport_tra");

            migrationBuilder.DropTable(
                name: "t_e_typechambre_tch");

            migrationBuilder.DropTable(
                name: "t_e_client_cli");

            migrationBuilder.DropTable(
                name: "t_e_icon_ico");

            migrationBuilder.DropTable(
                name: "t_e_club_clu");

            migrationBuilder.DropTable(
                name: "t_e_photo_pho");

            migrationBuilder.DropTable(
                name: "t_e_adresse_adr");

            migrationBuilder.DropTable(
                name: "t_e_equipementsalledebain_esb");

            migrationBuilder.DropTable(
                name: "t_e_pointfort_ptf");

            migrationBuilder.DropTable(
                name: "t_e_service_srv");

            migrationBuilder.DropTable(
                name: "t_r_souslocalisation_slc");
        }
    }
}
