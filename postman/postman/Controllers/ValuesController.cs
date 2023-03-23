using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using postman.model;

namespace postman.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ValuesController : ControllerBase
    {
        List<Class> students = new List<Class>
        {
            new Class { Id = 1,Name="veera",Location ="Mantralayam"},
            new Class { Id = 2,Name="tarun",Location ="Vijaywada"},
            new Class { Id = 3,Name="neelesh",Location ="Hydrabad"},
            new Class { Id = 4,Name="viswa",Location ="hydrabad"},
            new Class { Id = 5,Name="bharat",Location ="Guntur"},
        };
        [HttpGet]
        public IActionResult Gets()
        {
            if (students.Count == 0)
            {
                return NotFound("NO ListFound");
            }
            return Ok(students);
        }
        [HttpGet("GetStudent")]
        public IActionResult Get(int id)
        {
            var ostudent=students.SingleOrDefault(x => x.Id == id);
            if (ostudent == null)
            {
                return NotFound("No student found..");
            }
            return Ok(ostudent);
        }
        [HttpPost]
        public IActionResult Save(Class ostudent)
        {
            students.Add(ostudent);
            if(students.Count == 0) {
                return NotFound("No List Found");
            }
            return Ok(students);
        }
        [HttpPut]
        public IActionResult put([FromBody] Class ostudent)
        {
            students.RemoveAll(x=>x.Id== ostudent.Id);
            students.Add(ostudent);
            return Ok(students);
        }


        [HttpDelete] public IActionResult Delete(int id)
        {
            var ostudent = students.SingleOrDefault(x => x.Id == id);
            if (ostudent == null)
            {
                return NotFound("No student found..");
            }
            students.Remove(ostudent);  
            if(students.Count == 0)
            {
                return NotFound("No list found");
            }
            return Ok(students);

        }
    }
}
