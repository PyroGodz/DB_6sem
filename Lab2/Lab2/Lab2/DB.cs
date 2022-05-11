using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Lab2
{
    class DB
    {
        SqlConnection conn;
        public void openConnection(string connStr)
        {
            conn = new SqlConnection(connStr);
            conn.Open();
        }

        public void closeConnection()
        {
            conn.Close();
        }

        public void add_coach(string name, string payment)
        {
            using (SqlCommand cmd = new SqlCommand("add_coach", conn))
            {
                cmd.CommandType = System.Data.CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@FIO", name);
                cmd.Parameters.AddWithValue("@payment", payment);
                cmd.ExecuteNonQuery();
            }
        }

        public void add_Client( string Secondname, string Firstname, string Phone, string CoachId)
        {
            using (SqlCommand cmd = new SqlCommand("add_client", conn))
            {
                cmd.CommandType = System.Data.CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@Secondname", Secondname);
                cmd.Parameters.AddWithValue("@Firstname", Firstname);
                cmd.Parameters.AddWithValue("@Phone", Phone);
                cmd.Parameters.AddWithValue("@CoachId", CoachId);
                cmd.ExecuteNonQuery();
            }
        }
        public void add_Hal(string payment)
        {
            using (SqlCommand cmd = new SqlCommand("add_hal", conn))
            {
                cmd.CommandType = System.Data.CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@name", payment);
                cmd.ExecuteNonQuery();
            }
        }


        public void drop_coach(int id)
        {
            using (SqlCommand cmd = new SqlCommand("drop_coach", conn))
            {
                cmd.CommandType = System.Data.CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@id", id);
                cmd.ExecuteNonQuery();
            }
        }
        public void drop_client(int id)
        {
            using (SqlCommand cmd = new SqlCommand("drop_client", conn))
            {
                cmd.CommandType = System.Data.CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@id", id);
                cmd.ExecuteNonQuery();
            }
        }
        public void drop_hal(int id)
        {
            using (SqlCommand cmd = new SqlCommand("drop_hal", conn))
            {
                cmd.CommandType = System.Data.CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@id", id);
                cmd.ExecuteNonQuery();
            }
        }

        public void change_coach(int id, string fio, string payment)
        {
            using (SqlCommand cmd = new SqlCommand("change_coach", conn))
            {
                cmd.CommandType = System.Data.CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@id", id);
                cmd.Parameters.AddWithValue("@FIO", fio);
                cmd.Parameters.AddWithValue("@payment", payment);
                cmd.ExecuteNonQuery();
            }
        }

        public void change_client(int id, string secondname, string firstname, string phone, int CoachId)
        {
            using (SqlCommand cmd = new SqlCommand("change_client", conn))
            {
                cmd.CommandType = System.Data.CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@id", id);
                cmd.Parameters.AddWithValue("@Secondname", secondname);
                cmd.Parameters.AddWithValue("@Firstname", firstname);
                cmd.Parameters.AddWithValue("@Phone", phone);
                cmd.Parameters.AddWithValue("@CoachId", CoachId);
                cmd.ExecuteNonQuery();
            }
        }

        public void change_hal(int id, string name)
        {
            using (SqlCommand cmd = new SqlCommand("change_hal", conn))
            {
                cmd.CommandType = System.Data.CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@id", id);
                cmd.Parameters.AddWithValue("@name", name);
                cmd.ExecuteNonQuery();
            }
        }
    }
}
