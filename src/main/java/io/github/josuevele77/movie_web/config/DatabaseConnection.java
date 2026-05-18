package io.github.josuevele77.movie_web.config;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DatabaseConnection {
    private static final String URL = "jdbc:postgresql://localhost:5432/movie_web";
    private static final String USER = "postgres";
    private static final String PASSWORD = "root";

    private static Connection connection = null;

    // Constructor privado para evitar que instancien la clase
    private DatabaseConnection() {}

    public static Connection getConnection() {
        if (connection == null) {
            try {
                // Paso requerido para aplicaciones web: registrar el driver manualmente
                Class.forName("org.postgresql.Driver");

                // Establecer la conexión
                connection = DriverManager.getConnection(URL, USER, PASSWORD);
                System.out.println("Conexión a PostgreSQL exitosa.");

            } catch (ClassNotFoundException e) {
                System.err.println("Error: No se encontró el Driver de PostgreSQL. Revisa el .jar");
                e.printStackTrace();
            } catch (SQLException e) {
                System.err.println("Error: Fallo al conectar con la base de datos.");
                e.printStackTrace();
            }
        }
        return connection;
    }

    public static void closeConnection() {
        if (connection != null) {
            try {
                connection.close();
                connection = null;
                System.out.println("Conexión cerrada.");
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}