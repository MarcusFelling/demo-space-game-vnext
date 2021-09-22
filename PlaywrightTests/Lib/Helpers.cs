using System;
using System.Threading.Tasks;
using Microsoft.Playwright;

namespace PlaywrightTests.lib
{
    public class Helpers
    {
        public static async Task<IResponse> VisitURL(IPage page, string path = "/")
        { 
            string url = Environment.GetEnvironmentVariable("SITE_URL"); 
            return await page.GotoAsync(url);
        }

        public static async Task<string> VisitURLGetErrors(IPage page, string path = "/")
        {
            var errors = "";
            page.PageError += (_, exception) => { errors = errors + exception; };
            await VisitURL(page, path);
            return errors;
        }
    }
}