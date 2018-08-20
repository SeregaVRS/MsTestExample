namespace MsTestExample
{
    using System.Net;

    using Microsoft.VisualStudio.TestTools.UnitTesting;

    using RestSharp;

    /// <summary>
    /// Class contains smoke tests for http://worldclockapi.com/api
    /// </summary>
    [TestClass]
    public class WorldClockRestApiSmokeTests : WorldClockRestApiBaseTest
    {
        /// <summary>
        /// World Clock Api Client 
        /// http://worldclockapi.com/
        /// </summary>
        public readonly RestClient WorldClockApiClient = new RestClient("http://worldclockapi.com/api");

        /// <summary>
        /// Eastern Standard Time Test
        /// </summary>
        [TestMethod]
        public void EasternStandardTimeGetTest()
        {
            var easternStandardTimeRequest = new RestRequest("json/est/now", Method.GET);
            var response = this.WorldClockApiClient.Execute(easternStandardTimeRequest);
            
            Assert.IsFalse(string.IsNullOrWhiteSpace(response.Content));
            Assert.IsTrue(response.StatusCode.Equals(HttpStatusCode.OK));
        }

        /// <summary>
        /// Eastern Standard Time Exception Post Test
        /// Expected: MethodNotAllowed
        /// </summary>
        [TestMethod]
        public void EasternStandardTimeExceptionPostTest()
        {
            var easternStandardTimeRequest = new RestRequest("json/est/now", Method.POST);
            var response = this.WorldClockApiClient.Execute(easternStandardTimeRequest);

            Assert.IsFalse(string.IsNullOrWhiteSpace(response.Content));
            Assert.IsTrue(response.StatusCode.Equals(HttpStatusCode.MethodNotAllowed));
        }

        /// <summary>
        /// Coordinated Universal Time Test
        /// </summary>
        [TestMethod]
        public void CoordinatedUniversalTimeGetTest()
        {
            var coordinatedUniversalTimeRequest = new RestRequest("json/utc/now", Method.GET);
            var response = this.WorldClockApiClient.Execute(coordinatedUniversalTimeRequest);

            Assert.IsFalse(string.IsNullOrWhiteSpace(response.Content));
            Assert.IsTrue(response.StatusCode.Equals(HttpStatusCode.OK));
        }

        /// <summary>
        /// Coordinated Universal Time Test
        /// Expected: MethodNotAllowed
        /// </summary>
        [TestMethod]
        public void CoordinatedUniversalTimePostTest()
        {
            var coordinatedUniversalTimeRequest = new RestRequest("json/utc/now", Method.POST);
            var response = this.WorldClockApiClient.Execute(coordinatedUniversalTimeRequest);

            Assert.IsFalse(string.IsNullOrWhiteSpace(response.Content));
            Assert.IsTrue(response.StatusCode.Equals(HttpStatusCode.MethodNotAllowed));
        }

        /// <summary>
        /// Central European Standard Time Test
        /// </summary>
        [TestMethod]
        public void CentralEuropeanStandardTimeGetTest()
        {
            var centralEuropeanStandardTimeRequest = new RestRequest("jsonp/cet/now?callback=mycallback", Method.GET);
            var response = this.WorldClockApiClient.Execute(centralEuropeanStandardTimeRequest);

            Assert.IsFalse(string.IsNullOrWhiteSpace(response.Content));
            Assert.IsTrue(response.StatusCode.Equals(HttpStatusCode.OK));
        }

        /// <summary>
        /// Central European Standard Time Test
        /// Expected: MethodNotAllowed
        /// </summary>
        [TestMethod]
        [Ignore]
        public void CentralEuropeanStandardTimePostTest()
        {
            var centralEuropeanStandardTimeRequest = new RestRequest("jsonp/cet/now?callback=mycallback", Method.POST);
            var response = this.WorldClockApiClient.Execute(centralEuropeanStandardTimeRequest);

            Assert.IsFalse(string.IsNullOrWhiteSpace(response.Content));
            // Assert.IsTrue(response.StatusCode.Equals(HttpStatusCode.InternalServerError));
        }
    }
}
