namespace MsTestExample
{
    using System;

    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class Tests
    {
        //[AssemblyInitialize]
        //public void MsTestAssemblyInitialize()
        //{
        //}

        //[AssemblyCleanup]
        //public void MsTestAssemblyCleanup()
        //{
        //}

        //[TestInitialize]
        //public void MsTestTestInitialize()
        //{
        //}

        //[TestCleanup]
        //public void MsTestTestCleanup()
        //{
        //}

        [ClassInitialize]
        public void ClassInit()
        {
            Console.WriteLine();
        }

        [TestMethod]
        [TestCategory("Passed")]
        public void NewMethodPassed()
        {
            Console.WriteLine();
            Assert.IsTrue("12345".Length == 5);
        }

        [TestMethod]
        [TestCategory("Failed")]
        public void NewMethodFailed()
        {
            Console.WriteLine();
            Assert.IsTrue("12345".Length > 5);
        }

        [TestMethod]
        [TestCategory("Passed")]
        public void NewMethodTwoChecksFailed()
        {
            Console.WriteLine();
            Assert.IsTrue("12345".Length == 5);
            Assert.IsTrue("12345".Length > 5);
        }
    }
}
