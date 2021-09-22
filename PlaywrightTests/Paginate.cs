using System.Threading.Tasks;
using Microsoft.Playwright;
using Microsoft.Playwright.NUnit;
using NUnit.Framework;
using PlaywrightTests.lib;

namespace PlaywrightTests
{
    [Parallelizable(ParallelScope.Self)]
    public class Paginate : PageTest
    {
        [Test]
        public async Task CanPaginate()
        {
            await Helpers.VisitURL(Page);
            await Page.ClickAsync("text=2 (current)");
            await Page.ClickAsync("text=3 (current)");
            await Page.ClickAsync("text=1 (current)");
        }
    }
}