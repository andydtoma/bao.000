using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
//using Microsoft

namespace Bao.Core
{
    public class Class1
    {
    }

    public class PowerShell : Microsoft.Build.Tasks.Exec
    {
        public string ScriptBlock
        {
            set
            {
                EchoOff = true;
                Command = string.Format(
                  "@powershell \"Invoke-Command -ScriptBlock {{ $errorActionPreference='Stop'; {0} ; exit $LASTEXITCODE }} \"",
                  value.Replace("\"", "\"\"").Replace("\r\n", ";").Replace("\n", ";").Replace("\r", ";"));
            }
        }
    }
}

