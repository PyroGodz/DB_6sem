using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;

namespace Lab2
{
    /// <summary>
    /// Логика взаимодействия для MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {
        public MainWindow()
        {
            InitializeComponent();
        }
        string connStr = @"Data Source=PYROG;Initial Catalog=SportPlace;Integrated Security=True";
        DataTable Abon = new DataTable();
        DataTable Client = new DataTable();
        DataTable Coach = new DataTable();
        DataTable Hal = new DataTable();
        DataTable Record = new DataTable();
        DataTable SportPlaces = new DataTable();

        // To Do вывод дистанции
        private void Distance_Click(object sender, RoutedEventArgs e)
        {

        }


        private void allPlaces_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                string sqlExpression = "allSportPlaces";

                using (SqlConnection connection = new SqlConnection(connStr))
                {
                    connection.Open();
                    SqlDataAdapter command = new SqlDataAdapter(sqlExpression, connection);
                    // указываем, что команда представляет хранимую процедуру
                    SportPlaces.Clear();
                    // Заполняем Dataset
                    command.Fill(SportPlaces);
                    // Отображаем данные
                    PointGrid.ItemsSource = SportPlaces.DefaultView;
                    connection.Close();
                }
            }
            catch
            {
                MessageBox.Show("Ошибка запроса");
            }
        }

        private void addCoach_Click(object sender, RoutedEventArgs e)
        {
            string name = textBoxNameCoach.Text;
            string city = textBoxCityCoach.Text;

            if (name.Length == 0 || city.Length == 0)
            {
                MessageBox.Show("Проверьте данные");
            }
            else
            {
                DB db = new DB();
                db.openConnection(connStr);
                db.add_coach(name, city);
                db.closeConnection();
            }
        }

        private void addClient_Click(object sender, RoutedEventArgs e)
        {
            string Secondname = textBoxSecondNameClient.Text;
            string Firstname = textBoxFirstNameClient.Text;
            string Phone = textBoxPhoneClient.Text;
            string CoachId = textBoxCoachIdClient.Text;

            if (Secondname.Length == 0 || Firstname.Length == 0 || Phone.Length == 0 || CoachId.Length == 0)
            {
                MessageBox.Show("Проверьте данные");
            }
            else
            {
                DB db = new DB();
                db.openConnection(connStr);
                db.add_Client(Secondname, Firstname, Phone, CoachId);
                db.closeConnection();
            }
        }


        private void addHal_Click(object sender, RoutedEventArgs e)
        {
            string city = textBoxNamehal.Text;

            if (city.Length == 0)
            {
                MessageBox.Show("Проверьте данные");
            }
            else
            {
                DB db = new DB();
                db.openConnection(connStr);
                db.add_Hal(city);
                db.closeConnection();
            }
        }

        private void dropCoach_Click(object sender, RoutedEventArgs e)
        {
            int id = Convert.ToInt32(textBoxIdCoach.Text);
            if (textBoxIdCoach.Text == null)
            {
                MessageBox.Show("Введите ID клиента");
            }
            else
            {
                DB db = new DB();
                db.openConnection(connStr);
                db.drop_coach(id);
                db.closeConnection();
            }
        }

        private void dropClient_Click(object sender, RoutedEventArgs e)
        {
            int id = Convert.ToInt32(textBoxIdClient.Text);
            if (textBoxIdClient.Text == null)
            {
                MessageBox.Show("Введите ID клиента");
            }
            else
            {
                DB db = new DB();
                db.openConnection(connStr);
                db.drop_client(id);
                db.closeConnection();
            }
        }

        private void dropHal_Click(object sender, RoutedEventArgs e)
        {
            int id = Convert.ToInt32(textBoxIdHal.Text);
            if (textBoxIdHal.Text == null)
            {
                MessageBox.Show("Введите ID клиента");
            }
            else
            {
                DB db = new DB();
                db.openConnection(connStr);
                db.drop_hal(id);
                db.closeConnection();
            }
        }

        private void changeCoach_Click(object sender, RoutedEventArgs e)
        {
            int id = Convert.ToInt32(textBoxIdCoach.Text);
            string name = textBoxNameCoach.Text;
            string city = textBoxCityCoach.Text;
            if (name.Length == 0 || city.Length == 0)
            {
                MessageBox.Show("Проверьте данные");
            }
            else
            {
                DB db = new DB();
                db.openConnection(connStr);
                db.change_coach(id, name, city);
                db.closeConnection();
            }
        }

        private void changeClient_Click(object sender, RoutedEventArgs e)
        {
            int id = Convert.ToInt32(textBoxIdClient.Text);
            string Secondname = textBoxSecondNameClient.Text;
            string Firstname = textBoxFirstNameClient.Text;
            string Phone = textBoxPhoneClient.Text;
            int CoachId = Convert.ToInt32(textBoxCoachIdClient.Text);

            if (Secondname.Length == 0 || Firstname.Length == 0 || Phone.Length == 0 || textBoxCoachIdClient.Text.Length == 0)
            {
                MessageBox.Show("Проверьте данные");
            }
            else
            {
                DB db = new DB();
                db.openConnection(connStr);
                db.change_client(id, Secondname, Firstname, Phone, CoachId);
                db.closeConnection();
            }
        }

        //TO DO: check
        private void changeHal_Click(object sender, RoutedEventArgs e)
        {
            int id = Convert.ToInt32(textBoxIdHal.Text);
            string name = textBoxNamehal.Text;
            if (name.Length == 0)
            {
                MessageBox.Show("Проверьте данные");
            }
            else
            {
                DB db = new DB();
                db.openConnection(connStr);
                db.change_hal(id, name);
                db.closeConnection();
            }
        }

        private void allCoach_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                string sqlExpression = "getAllCoaches";

                using (SqlConnection connection = new SqlConnection(connStr))
                {
                    connection.Open();
                    SqlDataAdapter command = new SqlDataAdapter(sqlExpression, connection);
                    // указываем, что команда представляет хранимую процедуру
                    Coach.Clear();
                    // Заполняем Dataset
                    command.Fill(Coach);
                    // Отображаем данные
                    usersGrid.ItemsSource = Coach.DefaultView;
                    connection.Close();
                }
            }
            catch
            {
                MessageBox.Show("Ошибка запроса");
            }
        }
        private void allClient_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                string sqlExpression = "getAllClients";

                using (SqlConnection connection = new SqlConnection(connStr))
                {
                    connection.Open();
                    SqlDataAdapter command = new SqlDataAdapter(sqlExpression, connection);
                    // указываем, что команда представляет хранимую процедуру
                    Client.Clear();
                    // Заполняем Dataset
                    command.Fill(Client);
                    // Отображаем данные
                    usersClientGrid.ItemsSource = Client.DefaultView;
                    connection.Close();
                }
            }
            catch
            {
                MessageBox.Show("Ошибка запроса");
            }
        }

        private void allHal_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                string sqlExpression = "getAllHals";

                using (SqlConnection connection = new SqlConnection(connStr))
                {
                    connection.Open();
                    SqlDataAdapter command = new SqlDataAdapter(sqlExpression, connection);
                    // указываем, что команда представляет хранимую процедуру
                    Hal.Clear();
                    // Заполняем Dataset
                    command.Fill(Hal);
                    // Отображаем данные
                    usersHalGrid.ItemsSource = Hal.DefaultView;
                    connection.Close();
                }
            }
            catch
            {
                MessageBox.Show("Ошибка запроса");
            }
        }

    }
}
