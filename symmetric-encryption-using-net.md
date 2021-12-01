# Symmetric Encryption using .Net

Jan 2018

> Example of symmetric encryption using .net.

Symmetric encryption is when both parties have access to the key  

```
using Microsoft.VisualStudio.TestTools.UnitTesting;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Security.Cryptography;
using System.IO;

namespace Nlist.Concept.Cryptography.SymmetricEncryption
{
    public class SymmetricAlgorithmHelper
    {
        private SymmetricAlgorithm symmetricAlgorithm;

        public SymmetricAlgorithmHelper(SymmetricAlgorithm symmetricAlgorithm)
        {
            this.symmetricAlgorithm = symmetricAlgorithm;
        }

        public string Encrypt(string data)
        {
            var base64 = this.Encrypt(Encoding.UTF8.GetBytes(data));
            var result = Convert.ToBase64String(base64);
            return result;
        }

        public byte[] Encrypt(byte[] data)
        {
            using (var ms = new MemoryStream())
            {
                var cs = new CryptoStream(ms, this.symmetricAlgorithm.CreateEncryptor(), CryptoStreamMode.Write);

                cs.Write(data, 0, data.Length);
                cs.FlushFinalBlock();

                return ms.ToArray();
            }
        }

        public string Decrypt(string base64)
        {
            var data = Convert.FromBase64String(base64);
            var value = this.Decrypt(data);
            return Encoding.UTF8.GetString(value);
        }

        public byte[] Decrypt(byte[] data)
        {
            using (var ms = new MemoryStream())
            {
                var cs = new CryptoStream(ms, this.symmetricAlgorithm.CreateDecryptor(), CryptoStreamMode.Write);

                cs.Write(data, 0, data.Length);
                cs.FlushFinalBlock();

                return ms.ToArray();
            }
        }
    }
}
```