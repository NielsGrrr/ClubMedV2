using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace ClubMed.Migrations
{
    /// <inheritdoc />
    public partial class AddParticipantSystemAzure : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<DateTime>(
                name: "sre_datenaissance",
                table: "t_e_sousreservation_sre",
                type: "timestamp with time zone",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "sre_nom",
                table: "t_e_sousreservation_sre",
                type: "character varying(100)",
                maxLength: 100,
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "sre_prenom",
                table: "t_e_sousreservation_sre",
                type: "character varying(100)",
                maxLength: 100,
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "sre_type",
                table: "t_e_sousreservation_sre",
                type: "character varying(20)",
                maxLength: 20,
                nullable: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "sre_datenaissance",
                table: "t_e_sousreservation_sre");

            migrationBuilder.DropColumn(
                name: "sre_nom",
                table: "t_e_sousreservation_sre");

            migrationBuilder.DropColumn(
                name: "sre_prenom",
                table: "t_e_sousreservation_sre");

            migrationBuilder.DropColumn(
                name: "sre_type",
                table: "t_e_sousreservation_sre");
        }
    }
}
