using System.Threading.Tasks;
using Microsoft.Playwright;
using Microsoft.Playwright.NUnit;
using NUnit.Framework;
using PlaywrightTests.lib;

namespace PlaywrightTests
{
    [Parallelizable(ParallelScope.Self)]
    public class Download : PageTest
    {
        [Test]
        public async Task CanDownload()
        {
            await Helpers.VisitURL(Page);

            // Click download button
            await Page.ClickAsync("text=Download game");

            // Click text that doesn't actually link to anything
            await Page.ClickAsync("text=This link is for example purposes and goes nowhere. 😐");

            // Close download modal
            await Page.ClickAsync("#pretend-modal >> text=×");


        }
    }
}