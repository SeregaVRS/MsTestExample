namespace MsTestExample
{
    using System;

    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class Class1
    {
        [AssemblyInitialize]
        public void MsTestAssemblyInitialize()
        {
        }

        [AssemblyCleanup]
        public void MsTestAssemblyCleanup()
        {
        }

        [TestInitialize]
        public void MsTestTestInitialize()
        {
        }

        [TestCleanup]
        public void MsTestTestCleanup()
        {
        }

        [TestMethod]
        [TestCategory("Category")]
        public void NewMethodPassed()
        {
            Console.WriteLine();
            Assert.IsTrue("12345".Length == 5);
        }

        [TestMethod]
        [TestCategory("Category")]
        public void NewMethodFailed()
        {
            Console.WriteLine();
            Assert.IsTrue("12345".Length > 5);
        }
    }
}
