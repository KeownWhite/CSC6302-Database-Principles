import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.Scanner;

public class DatabaseConnectionTest {

    public static void main(String[] args) {

        String url = "jdbc:mysql://localhost:3306/";
        String user = "root";

        String password;

        if (System.console() != null) {
            char[] passwordChars = System.console().readPassword("MySQL root password: ");
            password = new String(passwordChars);
        } else {
            Scanner scanner = new Scanner(System.in);
            System.out.print("MySQL root password: ");
            password = scanner.nextLine();
        }

        try (
                Connection connection = DriverManager.getConnection(url, user, password);

                Statement statement = connection.createStatement();

                ResultSet result = statement.executeQuery(
                        "SELECT VERSION(), CURRENT_USER(), @@port")) {

            if (result.next()) {
                System.out.println();
                System.out.println("Successfully connected to MySQL.");
                System.out.println(
                        "Server version : " + result.getString(1));
                System.out.println(
                        "Current user   : " + result.getString(2));
                System.out.println(
                        "Server port    : " + result.getInt(3));
            }

        } catch (Exception e) {
            System.err.println();
            System.err.println("Database connection failed.");
            System.err.println(e.getMessage());
        }
    }
}