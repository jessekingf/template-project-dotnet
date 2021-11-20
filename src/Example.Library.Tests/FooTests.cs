// Licensed under the MIT License.
// See LICENSE.txt in the project root for license information.

namespace Example.Library.Tests;

using Microsoft.VisualStudio.TestTools.UnitTesting;

/// <summary>
/// Test fixture for the <see cref="Foo"/>.
/// </summary>
[TestClass]
public class FooTests
{
    /// <summary>
    /// A good case test for the Bar method.
    /// </summary>
    [TestMethod]
    public void Bar_GoodCase_Success()
    {
        Assert.IsTrue(Foo.Bar());
    }
}
