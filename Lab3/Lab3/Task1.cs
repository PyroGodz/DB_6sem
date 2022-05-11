using Microsoft.SqlServer.Server;
using System;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using System.IO;
using System.Security.Permissions;
using System.Text;

namespace Lab3
{
    public class Task1
    {
        [Microsoft.SqlServer.Server.SqlProcedure]
        public static void WriteFile(string filename, string data)
        {
            if (!File.Exists(filename))
            {
                using (StreamWriter sw = File.CreateText(filename))
                {
                    sw.WriteLine(data);
                }
                return;
            }
            using (StreamWriter sw = File.AppendText(filename))
            {
                sw.WriteLine(data);
            }

        }

        //ReadTextFile does not work because of StreamReader
        [Microsoft.SqlServer.Server.SqlProcedure]
        public static void ReadTextFile(string path)
        {
            if (File.Exists(path))
            {
                using (StreamReader sw = new StreamReader(path))
                {
                    string text = sw.ReadToEnd();
                    SqlContext.Pipe.Send(text);
                }
                return;
            }
            else
            {
                SqlContext.Pipe.Send("File does not exist.");
                return;
            }
        }
    }
}
