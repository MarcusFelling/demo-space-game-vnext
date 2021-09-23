using System.Threading.Tasks;
using Microsoft.Playwright;
using Microsoft.Playwright.NUnit;
using NUnit.Framework;
using PlaywrightTests.lib;

namespace PlaywrightTests
{
    [Parallelizable(ParallelScope.Self)]
    public class Error : PageTest
    {
        [Test]
        public async Task CanCheckForNoErrors()
        {
            string errors = await Helpers.VisitURLGetErrors(Page);
            Assert.AreEqual(string.Empty, errors);
        }
    }
}