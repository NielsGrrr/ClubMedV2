using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using Microsoft.IdentityModel.Tokens;
using System;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using System.Threading.Tasks;
using ClubMed.Models;
using ClubMed.Models.EntityFramework;
using ClubMed.Models.Repository;

namespace ClubMed.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class AuthController : ControllerBase
    {
        private readonly IDataRepository<Client> _dataRepository;
        private readonly IConfiguration _configuration;

        public AuthController(IDataRepository<Client> dataRepository, IConfiguration configuration)
        {
            _dataRepository = dataRepository;
            _configuration = configuration;
        }

        [HttpPost("login")]
        public async Task<IActionResult> Login([FromBody] LoginDto loginDto)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            // Find user by email
            string normalizedEmail = loginDto.Email.ToLowerInvariant();
            var client = await _dataRepository.GetByStringAsync(normalizedEmail);
            
            if (client == null)
            {
                return Unauthorized(new { message = "Email ou mot de passe incorrect." });
            }

            // Verify password using BCrypt
            bool isPasswordValid = false;
            try 
            {
                isPasswordValid = BCrypt.Net.BCrypt.Verify(loginDto.Password, client.MotDePasseCrypter);
            }
            catch
            {
                return Unauthorized(new { message = "Email ou mot de passe incorrect." });
            }

            if (!isPasswordValid)
            {
                return Unauthorized(new { message = "Email ou mot de passe incorrect." });
            }

            // Generate Token
            var token = GenerateJwtToken(client);

            return Ok(new
            {
                token = token,
                user = new
                {
                    numClient = client.NumClient,
                    email = client.Email,
                    nom = client.Nom,
                    prenom = client.Prenom,
                    role = client.Role,
                    telephone = client.Telephone,
                    genre = client.Genre,
                    dateNaissance = client.DateNaissance
                }
            });
        }

        private string GenerateJwtToken(Client client)
        {
            var jwtSettings = _configuration.GetSection("Jwt");
            var keyString = jwtSettings["Key"] ?? "DefaultSecretKeyNeedToBeLongEnough123!";
            var securityKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(keyString));
            var credentials = new SigningCredentials(securityKey, SecurityAlgorithms.HmacSha256);

            var claims = new[]
            {
                new Claim(JwtRegisteredClaimNames.Sub, client.NumClient.ToString()),
                new Claim(JwtRegisteredClaimNames.Email, client.Email ?? ""),
                new Claim(ClaimTypes.Name, client.Prenom + " " + client.Nom),
                new Claim(ClaimTypes.Role, client.Role ?? "particulier")
            };

            var token = new JwtSecurityToken(
                issuer: jwtSettings["Issuer"],
                audience: jwtSettings["Audience"],
                claims: claims,
                expires: DateTime.Now.AddHours(2), // Token valid for 2 hours
                signingCredentials: credentials);

            return new JwtSecurityTokenHandler().WriteToken(token);
        }
    }
}
