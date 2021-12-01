# Asymmetric Encryption using .Net

Jan 2018

> Example of asymmetric (public private) encryption using c#.

```
using Microsoft.VisualStudio.TestTools.UnitTesting;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Security.Cryptography;
using System.IO;

namespace Nlist.Concept.Cryptography.AsymmetricEncryption
{
    public class AsymmetricAlgorithmHelper
    {
        private RSACryptoServiceProvider asymmetricAlgorithm;
        private RSAParameters publicKey;
        private RSAParameters privateKey;

        public AsymmetricAlgorithmHelper(
            RSAParameters publicKey,
            RSAParameters privateKey,
            RSACryptoServiceProvider asymmetricAlgorithm)
        {
            this.publicKey = publicKey;
            this.privateKey = privateKey;
            this.asymmetricAlgorithm = asymmetricAlgorithm;
        }

        public string Encrypt(string data)
        {
            var base64 = this.Encrypt(Encoding.UTF8.GetBytes(data));
            var result = Convert.ToBase64String(base64);
            return result;
        }

        public byte[] Encrypt(byte[] data)
        {
            byte[] cipher;

            asymmetricAlgorithm.PersistKeyInCsp = false;
            asymmetricAlgorithm.ImportParameters(publicKey);

            cipher = asymmetricAlgorithm.Encrypt(data, true);

            return cipher;
        }

        public string Decrypt(string base64)
        {
            var data = Convert.FromBase64String(base64);
            var value = this.Decrypt(data);
            return Encoding.UTF8.GetString(value);
        }

        public byte[] Decrypt(byte[] data)
        {
            byte[] plain;

            asymmetricAlgorithm.PersistKeyInCsp = false;
            asymmetricAlgorithm.ImportParameters(privateKey);

            plain = asymmetricAlgorithm.Decrypt(data, true);

            return plain;
        }
    }
}
```