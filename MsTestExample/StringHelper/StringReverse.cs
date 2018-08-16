namespace StringHelper
{
    using System.Text;

    /// <summary>
    /// String Reverse
    /// </summary>
    public static class StringReverse
    {
        /// <summary>
        /// Reverse String using Builder
        /// </summary>
        /// <param name="stringForReversing"></param>
        /// <returns></returns>
        public static string ReverseStringBuilder(this string stringForReversing)
        {
            StringBuilder sb = new StringBuilder(stringForReversing.Length);

            for (int i = stringForReversing.Length; i-- != 0;)
            {
                sb.Append(stringForReversing[i]);
            }

            return sb.ToString();
        }
    }
}
