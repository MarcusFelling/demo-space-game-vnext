using System.Threading.Tasks;
using Microsoft.Playwright.NUnit;
using NUnit.Framework;
using PlaywrightTests.lib;

namespace PlaywrightTests
{
    [Parallelizable(ParallelScope.Self)]
    public class PlayerProfile : PageTest
    {
        [Test]
        public async Task CanViewPlayerProfile()
        {
            await Helpers.VisitURL(Page);

            // Click #1 ranked profile
            await Page.ClickAsync("div.score-data.username");

            // Get content of modal
            var profile = await Page.QuerySelectorAsync("div.modal-content");

            // Make sure it's populated
            Assert.NotNull(profile);

           // Close player profile
           await Page.ClickAsync("text=×");
        
        }
    }
}