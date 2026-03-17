using ClubMed.Models.EntityFramework;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace ClubMed.Models.Repository
{
    public class DataRepository<T> : IDataRepository<T> where T : class
    {
        public Task AddAsync(T entity)
        {
            throw new NotImplementedException();
        }

        public Task DeleteAsync(T entity)
        {
            throw new NotImplementedException();
        }

        public Task<ActionResult<IEnumerable<T>>> GetAllAsync()
        {
            throw new NotImplementedException();
        }

        public Task<ActionResult<T?>> GetByIdAsync(int id)
        {
            throw new NotImplementedException();
        }

        public Task<ActionResult<T?>> GetByStringAsync(string str)
        {
            throw new NotImplementedException();
        }

        public Task UpdateAsync(T entityToUpdate, T entity)
        {
            throw new NotImplementedException();
        }
    }
}