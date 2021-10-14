using System.Threading.Tasks;
using Microsoft.Playwright;
using Microsoft.Playwright.NUnit;
using NUnit.Framework;
using PlaywrightTests.lib;

namespace PlaywrightTests
{
    [Parallelizable(ParallelScope.Self)]
    public class Filter : PageTest
    {
        [Test]
        public async Task CanFilter()
        {
            await Helpers.VisitURL(Page);
            
            // Hover on Galaxy
            await Page.HoverAsync("h4:has-text(\"Galaxy\")");

            // Filter Galaxy
            await Page.ClickAsync("text=Milky Way");
            await Page.ClickAsync("text=Andromeda");
            await Page.ClickAsync("text=Pinwheel");
            await Page.ClickAsync("text=NGC 1300");
            await Page.ClickAsync("text=Messier 82");

            // Hover on Mode
            await Page.HoverAsync("h4:has-text(\"Mode\")");

            // Filter Mode
            await Page.ClickAsync("text=Solo");
            await Page.ClickAsync("text=Duo");
            await Page.ClickAsync("text=Trio");
        }
    }
}