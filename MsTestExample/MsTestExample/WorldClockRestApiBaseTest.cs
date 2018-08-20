namespace MsTestExample
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    using RestSharp;

    /// <summary>
    /// World Clock Rest Api Base Test class that contains client initialization
    /// </summary>
    [TestClass]
    public class WorldClockRestApiBaseTest
    {
        protected readonly RestClient WorldClockApiClient;

        protected WorldClockRestApiBaseTest()
        {
            this.WorldClockApiClient = new RestClient("http://worldclockapi.com/api");
        }
    }
}
