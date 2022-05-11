using System;
using System.Data.SqlClient;

namespace Lab4
{
    class Program
    {
        static void Main(string[] args)
        {
            string connection_string = "Server=PYROG;Database=SportPlace;Integrated Security=True";
            bool flag = true;
            int id = 0;
            decimal freeSpace = 0;
            string point = "";
            string point2 = "";
            string point3 = "";
            string name = "";
            // Shop sh = new Shop(connection_string);
            string sqlProcedure = "AddSportPlace";
            string sqlProcedure2 = "CalculateShortestPath";
            string sqlProcedure3 = "GetCoverageMap";
            string sqlProcedure4 = "GetPlaceMap";

            using (SqlConnection connection = new SqlConnection(connection_string))
            {
                connection.Open();

                //SqlCommand _command = new SqlCommand(sqlProcedure, connection);
                //_command.CommandType = System.Data.CommandType.StoredProcedure;
                //Console.WriteLine("Please enter SportPlace name:");
                //name = Console.ReadLine();
                //SqlParameter _nameParam = new SqlParameter
                //{
                //    ParameterName = "@name",
                //    Value = name
                //};
                //Console.WriteLine("Please enter SportPlace free space:");
                //freeSpace = Convert.ToInt32(Console.ReadLine());
                //SqlParameter _freeSpace = new SqlParameter
                //{
                //    ParameterName = "@freeSpace",
                //    Value = freeSpace
                //};
                //Console.WriteLine("Please enter SportPlace point:");
                //point = Console.ReadLine();
                //SqlParameter _point = new SqlParameter
                //{
                //    ParameterName = "@point",
                //    Value = point
                //};
                //_command.Parameters.Add(_nameParam);
                //_command.Parameters.Add(_freeSpace);
                //_command.Parameters.Add(_point);
                //var _reader = _command.ExecuteReader();

                //if (_reader.HasRows)
                //{
                //    Console.WriteLine("{0}\t", _reader.GetName(0));
                //    while (_reader.Read())
                //    {
                //        int created = _reader.GetInt32(0);
                //        Console.WriteLine("{0} ", created);
                //    }
                //}
                //_reader.Close();


                SqlCommand _command2 = new SqlCommand(sqlProcedure2, connection);
                _command2.CommandType = System.Data.CommandType.StoredProcedure;
                Console.WriteLine("Please enter point 1:");
                point2 = Console.ReadLine();
                SqlParameter _point1 = new SqlParameter
                {
                    ParameterName = "@p1",
                    Value = point2
                };
                Console.WriteLine("Please enter point 2:");
                point3 = Console.ReadLine();
                SqlParameter _point2 = new SqlParameter
                {
                    ParameterName = "@p2",
                    Value = point3
                };
                _command2.Parameters.Add(_point1);
                _command2.Parameters.Add(_point2);
                var _reader2 = _command2.ExecuteReader();

                if (_reader2.HasRows)
                {
                    Console.WriteLine("{0}\t", _reader2.GetName(0));
                    while (_reader2.Read())
                    {
                        double created = _reader2.GetDouble(0);
                        Console.WriteLine("{0} ", created);
                    }
                }
                _reader2.Close();

                //SqlCommand _command3 = new SqlCommand(sqlProcedure3, connection);
                //_command3.CommandType = System.Data.CommandType.StoredProcedure;

                //var _reader3 = _command3.ExecuteReader();

                //if (_reader3.HasRows)
                //{
                //    Console.WriteLine("{0}\t", _reader3.GetName(0));
                //    while (_reader3.Read())
                //    {
                //        string created = _reader3.GetString(0);
                //        Console.WriteLine("{0} ", created);
                //    }
                //}
                //_reader3.Close();

                //SqlCommand _command4 = new SqlCommand(sqlProcedure4, connection);
                //_command4.CommandType = System.Data.CommandType.StoredProcedure;

                //var _reader4 = _command4.ExecuteReader();

                //if (_reader4.HasRows)
                //{
                //    Console.WriteLine("{0}\t", _reader4.GetName(0));
                //    while (_reader4.Read())
                //    {
                //        string created = _reader4.GetString(0);
                //        Console.WriteLine("{0} ", created);
                //    }
                //}
                //_reader4.Close();

                connection.Close();
            }
            Console.ReadKey();
        }
    }
}
