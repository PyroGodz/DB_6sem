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
            string input = "";
            Console.WriteLine($"Введите Insert, update или delete");
            while (!input.Equals("q"))
            {

                if (input.Equals("Insert"))
                {
                    sqlExpression = "INSERT INTO Users (Name, Age) VALUES ('Alice', 32), ('Bob', 28)";
                    using (var connection = new SqliteConnection("Data Source=lab11.db"))
                    {
                        connection.Open();

                        SqliteCommand command = new SqliteCommand(sqlExpression, connection);

                        int number = command.ExecuteNonQuery();

                        Console.WriteLine($"В таблицу Users добавлено объектов: {number}");
                    }
                }



                if (input.Equals("Update"))
                {
                    sqlExpression = "UPDATE Users SET Age=20 WHERE Name='Tom'";
                    using (var connection = new SqliteConnection("Data Source=lab11.db"))
                    {
                        connection.Open();

                        SqliteCommand command = new SqliteCommand(sqlExpression, connection);

                        int number = command.ExecuteNonQuery();

                        Console.WriteLine($"Обновлено объектов: {number}");
                    }
                }
                if (input.Equals("Delete"))
                {
                    sqlExpression = "DELETE  FROM Users WHERE Name='Tom'";
                    using (var connection = new SqliteConnection("Data Source=lab11.db"))
                    {
                        connection.Open();

                        SqliteCommand command = new SqliteCommand(sqlExpression, connection);

                        int number = command.ExecuteNonQuery();

                        Console.WriteLine($"Удалено объектов: {number}");
                    }
                }

               

                else
                {
                    Console.WriteLine($"Неверная команда");
                }
                input = Console.ReadLine();
            }
            Console.Read();
        }
    }
}
