using System.Threading.Tasks;
using Microsoft.Playwright.NUnit;
using NUnit.Framework;
using PlaywrightTests.lib;

namespace PlaywrightTests
{
    [Parallelizable(ParallelScope.Self)]
    public class Cookie : PageTest
    {
        [Test]
        public async Task CanAcceptCookies()
        {
            await Helpers.VisitURL(Page);

            // Click on the cookie policy acceptance button if it exists
            if ((await Page.QuerySelectorAsync("text=Accept")) != null)
            {
                await Page.ClickAsync("text=Accept");
            }            
        }
        [Test]
        public async Task CanLearnMoreCookies()
        {
            await Helpers.VisitURL(Page);

            // Click on the cookie policy learn more button if it exists
            if ((await Page.QuerySelectorAsync("text=Learn More")) != null)
            {
                await Page.ClickAsync("text=Learn More");
            }            
        }
    }
}