using Microsoft.EntityFrameworkCore.Migrations;
using Npgsql.EntityFrameworkCore.PostgreSQL.Metadata;

#nullable disable

namespace ClubMed.Migrations
{
    /// <inheritdoc />
    public partial class AddSousReservationsV2 : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "t_e_sousreservation_sre",
                columns: table => new
                {
                    sre_id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    res_numreservation = table.Column<int>(type: "integer", nullable: false),
                    cli_numclient = table.Column<int>(type: "integer", nullable: false),
                    tra_idtransport = table.Column<int>(type: "integer", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_sousreservation", x => x.sre_id);
                    table.ForeignKey(
                        name: "fk_sousresa_client",
                        column: x => x.cli_numclient,
                        principalTable: "t_e_client_cli",
                        principalColumn: "cli_numclient",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "fk_sousresa_reservation",
                        column: x => x.res_numreservation,
                        principalTable: "t_e_reservation_res",
                        principalColumn: "res_numreservation",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "fk_sousresa_transport",
                        column: x => x.tra_idtransport,
                        principalTable: "t_e_transport_tra",
                        principalColumn: "tra_id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "t_j_sousreservationactivite_sra",
                columns: table => new
                {
                    sre_id = table.Column<int>(type: "integer", nullable: false),
                    act_id = table.Column<int>(type: "integer", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_sousreservationactivite", x => new { x.sre_id, x.act_id });
                    table.ForeignKey(
                        name: "fk_sra_activite",
                        column: x => x.act_id,
                        principalTable: "t_e_activite_act",
                        principalColumn: "act_id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "fk_sra_sousresa",
                        column: x => x.sre_id,
                        principalTable: "t_e_sousreservation_sre",
                        principalColumn: "sre_id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "IX_t_e_sousreservation_sre_cli_numclient",
                table: "t_e_sousreservation_sre",
                column: "cli_numclient");

            migrationBuilder.CreateIndex(
                name: "IX_t_e_sousreservation_sre_res_numreservation",
                table: "t_e_sousreservation_sre",
                column: "res_numreservation");

            migrationBuilder.CreateIndex(
                name: "IX_t_e_sousreservation_sre_tra_idtransport",
                table: "t_e_sousreservation_sre",
                column: "tra_idtransport");

            migrationBuilder.CreateIndex(
                name: "IX_t_j_sousreservationactivite_sra_act_id",
                table: "t_j_sousreservationactivite_sra",
                column: "act_id");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "t_j_sousreservationactivite_sra");

            migrationBuilder.DropTable(
                name: "t_e_sousreservation_sre");
        }
    }
}
