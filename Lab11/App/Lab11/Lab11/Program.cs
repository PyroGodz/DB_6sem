using Microsoft.Data.Sqlite;
using System;

namespace Lab11
{
    class Program
    {
        static void Main(string[] args)
        {

  
            string FIO, sqlExpression;
            int payment;
            string input = Console.ReadLine();
            while (!input.Equals("q"))
            {

                    Console.WriteLine("Введите ФИО");
                    FIO = Console.ReadLine();
                    Console.WriteLine("Введите заработную плату");
                    payment = Convert.ToInt32(Console.ReadLine());
                    sqlExpression = $"insert into coach (FIO, payment) VALUES ({FIO}, {payment});";
                using (var connection = new SqliteConnection("Data Source=lab11.db"))
                {
                    connection.Open();
                    SqliteCommand command = new SqliteCommand(sqlExpression, connection);
                    command.ExecuteNonQuery();
                    connection.Close();
                }
                    Console.WriteLine("Данные вставлены в таблицу coach");
                    //    input = Console.ReadLine();
                    //    command.CommandText = "select * from coach;";
                    //    command.ExecuteNonQuery();
            }
            Console.Read();
        }
    }
}
