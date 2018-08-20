namespace MsTestExample
{
    using System;

    using Microsoft.VisualStudio.TestTools.UnitTesting;

    using RestSharp;

    /// <summary>
    /// Class contains tests for http://worldclockapi.com/api
    /// </summary>
    [TestClass]
    public class WorldClockRestApiExtendedTests : WorldClockRestApiBaseTest
    {
        /// <summary>
        /// Eastern Standard Time Test
        /// </summary>
        [TestMethod]
        public void EasternStandardTimeContentTest()
        {
            var systemTime = DateTime.Now;
            var easternStandardTimeRequest = new RestRequest("json/est/now", Method.GET);
            var response = this.WorldClockApiClient.Execute(easternStandardTimeRequest);

            Assert.IsFalse(string.IsNullOrWhiteSpace(response.Content));

        }

        /// <summary>
        /// Coordinated Universal Time Test
        /// </summary>
        [TestMethod]
        public void CoordinatedUniversalTimeContentTest()
        {
            var systemTime = DateTime.Now;
            var coordinatedUniversalTimeRequest = new RestRequest("json/utc/now", Method.GET);
            var response = this.WorldClockApiClient.Execute(coordinatedUniversalTimeRequest);

            Assert.IsFalse(string.IsNullOrWhiteSpace(response.Content));

        }

        /// <summary>
        /// Central European Standard Time Test
        /// </summary>
        [TestMethod]
        public void CentralEuropeanStandardTimeContentTest()
        {
            var systemTime = DateTime.Now;
            var centralEuropeanStandardTimeRequest = new RestRequest("jsonp/cet/now?callback=mycallback", Method.GET);
            var response = this.WorldClockApiClient.Execute(centralEuropeanStandardTimeRequest);

            Assert.IsFalse(string.IsNullOrWhiteSpace(response.Content));
        }
    }
}
