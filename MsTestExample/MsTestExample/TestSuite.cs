namespace MsTestExample
{
    using System;
    using System.Diagnostics;
    using System.Threading;

    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class TestSuite
    {
        private const int TimeoutInMilliseconds = 100;

        private static TestContext Context { get; set; }

        #region Initialization

        /// <summary>
        ///     Called once before the tests in the class have executed.
        /// </summary>
        /// <param name="testContext">The test context.</param>
        [ClassInitialize]
        public static void ClassInitialize(TestContext testContext)
        {
            Context = testContext;
        }

        /// <summary>
        ///     Called once before each test is executed.
        /// </summary>
        [TestInitialize]
        public void TestInitialize()
        {
            Trace.WriteLine(Context.TestName);
        }

        #endregion Initialization

        #region Cleanup

        /// <summary>
        ///     Called once after all tests in the class have executed.
        /// </summary>
        [ClassCleanup]
        public static void ClassCleanup()
        {
            //
        }

        /// <summary>
        ///     Called once after each test is executed.
        /// </summary>
        [TestCleanup]
        public void TestCleanup()
        {
            //
        }

        #endregion Cleanup

        #region The actual tests

        /// <summary>
        ///     A typical test that asserts something.
        /// </summary>
        [TestMethod]
        public void TestTypicalAssertion()
        {
            Assert.AreEqual(1, 1);
        }

        /// <summary>
        ///     Test will fail if it takes longer than the specifed timeout value.
        /// </summary>
        [TestMethod]
        [Timeout(TimeoutInMilliseconds)]
        public void TestThatTimeouts()
        {
            Thread.Sleep(TimeoutInMilliseconds / 2);
        }

        /// <summary>
        ///     An example of a test that is expected to throw an exception.
        /// </summary>
        /// <exception cref="System.Exception">doh!</exception>
        [TestMethod]
        [ExpectedException(typeof(InvalidOperationException))]
        public void TestThatIsExpectedToThrowAnException()
        {
            throw new InvalidOperationException("Argh!");
        }

        /// <summary>
        ///     An example of a test that is ignored.
        /// </summary>
        [TestMethod]
        [Ignore]
        public void TestThatIsIgnored()
        {
            throw new InvalidOperationException();
        }

        #endregion The actual tests
    }
}
