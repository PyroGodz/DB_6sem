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
    }
}
